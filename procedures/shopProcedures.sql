--Get all categories, subCategories and subCategorychild for any shop
CREATE PROCEDURE dbo.spCreateShopContent
@shopId INT
AS
BEGIN
--will create json output for shops complete details

	declare @tableId int;
	
	Declare @baseUrl varchar(200);
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
			categories NVARCHAR(MAX)
	    )
	
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
		SELECT id, name, category, CONCAT(@baseUrl,[image]) as [image], onlineStatus 
		from shop where id = @shopId
		for JSON AUTO, WITHOUT_ARRAY_WRAPPER
	)
	
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
			id int,
			name varchar(200),
			image varchar(200),
			subCategoryChildId int,
			price int
		);
	
	declare @query nvarchar(max) = N'
		select 
		productMaster.id,
		productMaster.name,
		CONCAT(@baseUrl, productMaster.image),
		productMaster.subCategoryChildId,
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
		scc.subCategoryId as subCategoryId,
		scc.subCategoryChildId as subCategoryChildId,
		scc.title as title,
		data.id as productId,
		data.name as name,
		data.image as image,
		data.price as price
		from (
			select 
			category.id as categoryId,
			subCategory.id as subCategoryId,
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
			where shopAddress.shopId = @id;
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
		-- table exists then add the product
		SET @query = N'
			INSERT INTO '+ @tableName +' (mrp, price, shopId, productMasterId) values
			(@mrp, @price, @shopId, @productMasterId)';
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
				productMasterId int NULL FOREIGN KEY REFERENCES productMaster(id)
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
	DROP TABLE #Product;
	
	
	SELECT * INTO #Product FROM OPENJSON(@json)
		with(
			id int,
			mrp int,
			price int,
			productMasterId int
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
			ELSE '+@tableName+'.productMasterId END
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