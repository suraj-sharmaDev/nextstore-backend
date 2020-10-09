-- Get all shops either with filter parameter such as merchantId or onlineStatus 
-- or merchant Name, shop Name, shopId
CREATE PROCEDURE dbo.spGetShopsWithFilter
@json NVARCHAR(MAX),
@page INT
AS
BEGIN
	-- this procedure gives 15 shops belonging abiding by certain search queries
	DECLARE @offset INT = 15 * (@page - 1);	
	DECLARE @onlineStatus INT = JSON_VALUE(@json, '$.onlineStatus');
	DECLARE @shopName VARCHAR(100) = JSON_VALUE(@json, '$.shopName');
	DECLARE @merchantId VARCHAR(40)  = JSON_VALUE(@json, '$.merchantId');
	Declare @baseUrl varchar(200);
	--get baseUrl as local variable
	Select @baseUrl=baseUrl from appConfig;

	DECLARE @query NVARCHAR(MAX) = N'
		SELECT 
		shop.id,
		shop.name,
		shop.category,
		shop.name,
		shop.onlineStatus,
		shop.coverage,
		CONCAT(@baseUrl ,shop.image) as image,
		shop.rating
		FROM shop
		INNER JOIN merchant on shop.merchantId = merchant.id
		WHERE
		1 = 1
	';
	IF @onlineStatus IS NOT NULL
	BEGIN
		SET @query = @query + N'
			and shop.onlineStatus = @onlineStatus
		';
	END
	IF @shopName IS NOT NULL
	BEGIN
		SET @query = @query + N'
			and shop.name = @shopName 
		';
	END
	IF @merchantId IS NOT NULL
	BEGIN
		SET @query = @query + N'
			and merchant.email = @merchantId 
		';
	END	
	-- final modification to query for limiting output size
	SET @query = @query + N'
				ORDER BY id
				OFFSET @offset ROWS FETCH NEXT 15 ROWS ONLY
	';
	-- Finally execute the query
	EXEC sp_executeSql 
		@query, 
		N'@onlineStatus int, @shopName varchar(100), 
		  @merchantId VARCHAR(40), @offset INT,
		  @baseUrl varchar(200)
		',
		@onlineStatus, @shopName, @merchantId, @offset, @baseUrl
	;
END

GO;

-- Get basic information of shop
CREATE PROCEDURE dbo.spShopBasicInfo
@shopId INT
AS
BEGIN
	Declare @baseUrl varchar(200);
	--get baseUrl as local variable
	Select @baseUrl=baseUrl from appConfig;

	SELECT s.id, s.name, s.category, CONCAT(@baseUrl, s.[image]) as [image], s.onlineStatus,
	a.pickupAddress as pickupAddress
	from shop as s 
	INNER JOIN shopAddress as a on a.shopId = s.id
	where s.id = @shopId
END

GO;

--Get all categories, subCategories and subCategorychild for any shop
CREATE PROCEDURE dbo.spCreateShopContent
@shopId INT
AS
BEGIN
	DECLARE @tableId int;
	DECLARE @baseUrl varchar(200);
	--get baseUrl as local variable
	Select @baseUrl=baseUrl from appConfig;

	If @shopId % 20 = 0
		SET @tableId =  @shopId/20;
	ELSE
		SET @tableId =  @shopId/20 + 1;
	
	declare @tableName varchar(100) = N'product'+ cast(@tableId as varchar);	
	declare @query nvarchar(max) = N'
		select DISTINCT productMasterId 
		from '+ @tableName +'
		where shopId =' + cast(@shopId as varchar);

	IF OBJECT_ID('tempdb..#ShopContentTemp') IS NOT NULL
	    Truncate TABLE #ShopContentTemp
	else
	    CREATE TABLE #ShopContentTemp
	    (
	    	productMasterId int
	    )
	
	INSERT INTO #ShopContentTemp EXEC sp_executesql @query;

	IF OBJECT_ID('tempdb..#Results') IS NOT NULL
	    Truncate TABLE #Results
	else
	    CREATE TABLE #Results
	    (
	    	shopInfo NVARCHAR(MAX),
			categories NVARCHAR(MAX),
			recommends NVARCHAR(MAX)
	    )
	    
	IF OBJECT_ID('tempdb..#Recommends') IS NOT NULL
	    Truncate TABLE #Recommends
	else
	    CREATE TABLE #Recommends
	    (
			id INT,
		    shopId INT,
			productId INT,
			name NVARCHAR(100),
			productMasterId INT,			
			image NVARCHAR(200),
			price INT
	    )	    

	INSERT INTO #Recommends EXEC spGetRecommendedProducts @shopId;

	;With x(json) as
	(
		SELECT  
			category.id as categoryId,
			category.name as categoryName,
			subCategory.id as subCategoryId,
			subCategory.name as subCategoryName,
			subCategoryChild.id as subCategoryChildId,
			subCategoryChild.name as subCategoryChildName
		from category
		INNER JOIN subCategory on subCategory.categoryId = category.id
		INNER JOIN subCategoryChild on subCategory.id = subCategoryChild.subCategoryId 
		INNER JOIN (
			select DISTINCT subCategoryChildId
			from productMaster
			INNER JOIN (				
			select productMasterId 
				from #ShopContentTemp
			)as product on product.productMasterId = productMaster.id
		)as productMaster on productMaster.subCategoryChildId = subCategoryChild.id 
		FOR JSON AUTO
	)
	
	Insert Into #Results (categories) 
		select json from x;
	
	UPDATE #Results SET shopInfo = (
		SELECT s.id, s.name, s.category, CONCAT(@baseUrl, s.[image]) as [image], s.onlineStatus,
		a.pickupAddress as pickupAddress
		from shop as s 
		INNER JOIN shopAddress as a on a.shopId = s.id
		where s.id = @shopId
		for JSON PATH, WITHOUT_ARRAY_WRAPPER
	)
	
	UPDATE #Results SET recommends = (
		SELECT * from #Recommends
		FOR JSON PATH
	);

	select * from #Results
END

GO;

----------------------------------------------------------
--Get all products belonging to shop with shopId and subCategoyId
CREATE PROCEDURE dbo.spGetProductsInSubCategory
@shopId INT, 
@subCategoryId INT
AS
BEGIN
	Declare @outputData NVARCHAR(MAX);

	declare @tableId int;

	Declare @baseUrl varchar(200);
	--get baseUrl as local variable
	Select @baseUrl=baseUrl from appConfig;

	If @shopId % 20 = 0
		SET @tableId =  @shopId/20;
	ELSE
		SET @tableId =  @shopId/20 + 1;
	
	declare @tableName varchar(100) = N'product'+ cast(@tableId as varchar);	

	IF OBJECT_ID('tempdb..#DistTemp') IS NOT NULL
	TRUNCATE TABLE #DistTemp
	ELSE
		CREATE TABLE #DistTemp (
			productMasterId int,
			productId int,
			[name] varchar(200),
			[image] varchar(180),
			[bigImage1] nvarchar(180),
			[bigImage2] nvarchar(180),
			[bigImage3] nvarchar(180),
			[bigImage4] nvarchar(180),
			[bigImage5] nvarchar(180),
			[bigImage6] nvarchar(180),
			subCategoryChildId int,
			stock int,
			mrp int,
			price int
		);
	
	declare @query nvarchar(max) = N'
		select 
		productMaster.id as productMasterId,
		product.id as productId,
		productMaster.name,
		COALESCE(@baseUrl + productMaster.image, null) as image,
		COALESCE(@baseUrl + productMaster.bigImage1, null) as bigImage1,
		COALESCE(@baseUrl + productMaster.bigImage2, null) as bigImage2,
		COALESCE(@baseUrl + productMaster.bigImage3, null) as bigImage3,
		COALESCE(@baseUrl + productMaster.bigImage4, null) as bigImage4,
		COALESCE(@baseUrl + productMaster.bigImage5, null) as bigImage5,
		COALESCE(@baseUrl + productMaster.bigImage6, null) as bigImage6,
		productMaster.subCategoryChildId,
		product.stock,
		product.mrp,
		product.price
		from productMaster
		Inner join ' + @tableName +' as product on product.productMasterId = productMaster.id
		where product.shopId = '+ cast(@shopId as varchar);
	
	--steps--
	--get all subCategoryChild matching subCategoryId = @subCategoryId
	--get all products with subCategoryChild matching above and belonging to shopId
	-- add categories to those shops
	-- return in readable json format
	INSERT INTO #DistTemp
		EXEC sp_executeSql @query, N'@baseUrl VARCHAR(200)', @baseUrl;

	with x(json) as (
		select 
		scc.categoryId as categoryId,
		scc.categoryName as categoryName,
		scc.subCategoryId as subCategoryId,
		scc.subCategoryName as subCategoryName,
		scc.subCategoryChildId as subCategoryChildId,
		scc.title as title,
		data.productMasterId as productMasterId,
		data.productId as productId,
		data.name as [name],
		data.image as [image],
		data.bigImage1 as [bigImage1],
		data.bigImage2 as [bigImage2],
		data.bigImage3 as [bigImage3],
		data.bigImage4 as [bigImage4],
		data.bigImage5 as [bigImage5],
		data.bigImage6 as [bigImage6],
		data.stock as [stock],
		data.mrp as mrp,
		data.price as price
		from (
			select 
			category.id as categoryId,
			category.name as categoryName,
			subCategory.id as subCategoryId,
			subCategory.name as subCategoryName,
			subCategoryChild.id as subCategoryChildId,
			subCategoryChild.name as title
			from subCategoryChild
			inner join subCategory on subCategory.id = subCategoryChild.subCategoryId
			inner join category on category.id = subCategory.categoryId
			where subCategoryChild.subCategoryId = @subCategoryId
		) as scc
		inner join #DistTemp as data on data.subCategoryChildId = scc.subCategoryChildId
		For Json AUTO
	)
 select @outputData=json from x;
 select @outputData;
 RETURN

END



GO;

----------------------------------------------------------------

--------------Get all shops near to user with coordinates(lan, lng)

--Select all shops near to customer

CREATE PROCEDURE dbo.spfindShopsNearby
@custLat FLOAT, @custLng FLOAT
AS
BEGIN
	DECLARE @id INT;
	DECLARE @name NVARCHAR(100);
	DECLARE @category NVARCHAR(30);
	DECLARE @image NVARCHAR(100);
	DECLARE @onlineStatus bit;
	DECLARE @coverage INT;
	DECLARE @rating INT;

	Declare @baseUrl varchar(200);
	--get baseUrl as local variable
	Select @baseUrl=baseUrl from appConfig;

	DECLARE @distance FLOAT;
	DECLARE @shopsTable table (
		shopId INT,
		name nvarchar(100),
		category nvarchar(50),
		onlineStatus bit,
		image nvarchar(100),
		rating INT,
		distance FLOAT
	);

	DECLARE shopCursor CURSOR 
		FOR
			SELECT id, name, category, onlineStatus, image, coverage, rating FROM shop;
		
	Open shopCursor
		Fetch next from shopCursor into @id, @name, @category, @onlineStatus, @image, @coverage, @rating;
		WHILE @@FETCH_STATUS = 0
		begin
			
			--find distance between shop and customer
			SELECT @distance = geography::Point(@custLat, @custLng, 4326).STDistance(
				geography::Point(latitude, longitude, 4326)
			) from shopAddress
			where shopAddress.shopId = @id
			AND (shopAddress.latitude IS NOT NULL AND shopAddress.longitude IS NOT NULL) 
			;
			-- convert meters to KMs
			SET @distance = ROUND(@distance/1000, 2);
			--check if distance is less than the coverage of shop
			If(@distance <= @coverage)
			begin
				--if user is within coverage distance add shop to output table
				INSERT INTO @shopsTable(shopId, name, category, onlineStatus, image, rating, distance) 
				values (@id, @name, @category, @onlineStatus, CONCAT(@baseUrl, @image), @rating, @distance);
			end
			
			Fetch next from shopCursor into @id, @name, @category, @onlineStatus, @image, @coverage, @rating;
		end
		
	Close shopCursor
	Deallocate shopCursor
	--output all found shops
	select * from @shopsTable
END

GO;

-------------------------------------------------------------
------Insert product into a shop--------
CREATE PROCEDURE dbo.spInsertProductInShop
@json NVARCHAR(255)
AS
BEGIN
-- copy json data to local variables
	DECLARE @mrp INT = JSON_VALUE(@json, '$.mrp');
	DECLARE @price INT = JSON_VALUE(@json, '$.price');
	DECLARE @productMasterId INT = JSON_VALUE(@json, '$.productMasterId');
	DECLARE @shopId INT = JSON_VALUE(@json, '$.shopId');
	DECLARE @query NVARCHAR(MAX);
	DECLARE @paramDef nvarchar (500);
	-- insert into productX table
	-- each productX table stores 10,000 or more products for 20 shops 
	-- so the calculation for which table should store products for which shop should be based
	-- upon shopId
	declare @tableId int;
	
	If @shopId % 20 = 0
		SET @tableId =  @shopId/20;
	ELSE
		SET @tableId =  @shopId/20 + 1;
	
	declare @tableName varchar(100) = N'product'+ cast(@tableId as varchar);
	
	--Now check if that table exists
	
	IF OBJECT_ID(@tableName) IS NOT NULL
	BEGIN
		-- table exists first check if product with same productMasterId is already added
		SET @query = N'
			IF NOT EXISTS (
				SELECT * FROM '+@tableName+' WHERE productMasterId = @productMasterId
				and shopId = @shopId
			)
			BEGIN
				INSERT INTO '+ @tableName +' (mrp, price, shopId, productMasterId) values
				(@mrp, @price, @shopId, @productMasterId)
			END';
		SET @paramDef = N'@mrp int, @price int, @shopId int, @productMasterId int';
		EXEC sp_executeSql @query, @paramDef, @mrp, @price, @shopId, @productMasterId;
	END
	ELSE
	BEGIN
		-- table doesn't exist so create a new table and add the product
		SET @query = N'
			CREATE TABLE ' + @tableName + '(
				id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
				mrp int NULL,
				price int NULL,
				shopId int NULL FOREIGN KEY REFERENCES shop(id),
				productMasterId int NULL FOREIGN KEY REFERENCES productMaster(id),
				stock int DEFAULT 1
			);
			
			INSERT INTO '+ @tableName +' (mrp, price, shopId, productMasterId) values
			(@mrp, @price, @shopId, @productMasterId);
		';
		SET @paramDef = N'@mrp int, @price int, @shopId int, @productMasterId int';
		EXEC sp_executesql @query, @paramDef, @mrp, @price, @shopId, @productMasterId;
	END
END 

GO;

----------------------------------------------------------------
---------Update product in shop---------------------------------
CREATE PROCEDURE dbo.spUpdateProductInShop
@json NVARCHAR(MAX), @shopId int
AS
BEGIN
-- copy json data to local variables
	DECLARE @query NVARCHAR(MAX);
	DECLARE @paramDef nvarchar (500);
	-- insert into productX table
	-- each productX table stores 10,000 or more products for 20 shops 
	-- so the calculation for which table should store products for which shop should be based
	-- upon shopId
	declare @tableId int;
	
	If @shopId % 20 = 0
		SET @tableId =  @shopId/20;
	ELSE
		SET @tableId =  @shopId/20 + 1;
	
	DECLARE @tableName varchar(100) = N'product'+ cast(@tableId as varchar);

	IF OBJECT_ID('tempdb..#Product') IS NOT NULL
	TRUNCATE TABLE #Product;
	
	
	SELECT * INTO #Product FROM OPENJSON(@json)
		with(
			id int,
			mrp int,
			price int,
			productMasterId int,
			stock int
		);
	
	SET @query = N'
		UPDATE '+@tableName+'
		SET 
		'+@tableName+'.mrp = 
			CASE WHEN (#Product.mrp IS NOT NULL) THEN #Product.mrp
			ELSE '+@tableName+'.mrp END,
		'+@tableName+'.price = 
			CASE WHEN (#Product.price IS NOT NULL) THEN #Product.price
			ELSE '+@tableName+'.price END,
		'+@tableName+'.productMasterId = 
			CASE WHEN (#Product.productMasterId IS NOT NULL) THEN #Product.productMasterId
			ELSE '+@tableName+'.productMasterId END,
		'+@tableName+'.stock =
			CASE WHEN (#Product.stock IS NOT NULL) THEN #Product.stock
			ELSE '+@tableName+'.stock END
		FROM '+@tableName+', #Product 
		WHERE #Product.id = '+@tableName+'.id';
	
	EXEC sp_executeSql @query;
END

GO;
----------------------------------------------------------------------------
---------Find all the offers-------------------

CREATE PROCEDURE dbo.spGetAllOffers
@custLat FLOAT, 
@custLng FLOAT
AS
BEGIN
	Declare @baseUrl varchar(200);
	--get baseUrl as local variable
	Select @baseUrl=baseUrl from appConfig;

	select
	id,
	offer_name ,
	CONCAT(@baseUrl, offer_image) as offer_image ,
	offer_type ,
	createdAt 
	from offers
	
END

GO;

--------------------------------------------------------------
--------------Get all offers and shops near user--------
Create Procedure dbo.spGetNearbyShopsOffers
@custLat FLOAT,
@custLng FLOAT
AS
BEGIN
	IF OBJECT_ID('tempdb..#NearByShops') IS NOT NULL
	    Truncate TABLE #NearByShops
	else
	    CREATE TABLE #NearByShops
	    (
			shopId int,
			name NVARCHAR(200),
			category NVARCHAR(80),
			onlineStatus BIT,
			image NVARCHAR(200),
			rating INT,
			distance FLOAT
	    )
	    
	IF OBJECT_ID('tempdb..#AllOffers') IS NOT NULL
	    Truncate TABLE #AllOffers
	else
	    CREATE TABLE #AllOffers
	    (
			id INT,
			offer_name NVARCHAR(100),
			offer_image NVARCHAR(200),
			offer_type NVARCHAR(80),
			createdAt datetime
	    )	    
	    
	INSERT INTO #NearByShops
		exec spfindShopsNearby @custLat, @custLng
	INSERT INTO #AllOffers
		exec spGetAllOffers @custLat, @custLng
	
	;with x(json) as
	(
		SELECT 
		shops = (
			select * from #NearByShops
			FOR JSON PATH, INCLUDE_NULL_VALUES 
		),
		offers = (
			select * from #AllOffers
			FOR JSON PATH, INCLUDE_NULL_VALUES 			
		)
		For Json PATH, WITHOUT_ARRAY_WRAPPER	
	)
	
	select json from x;	
END

----------------------------------------------------------
---------------Get shop statistics------------------------
CREATE Procedure dbo.spGetShopStats
@shopId INT,
@startDate datetimeoffset,
@endDate datetimeoffset
As
BEGIN
END