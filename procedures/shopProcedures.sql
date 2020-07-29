--Get all categories, subCategories and subCategorychild for any shop
CREATE PROCEDURE dbo.spCreateShopContent
@shopId INT
AS
BEGIN
--will create json output for shops complete details

	declare @tableId int;

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
		SELECT id, name, category, onlineStatus 
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
		productMaster.image,
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
		EXEC sp_executeSql @query;

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
-----------------------------------------------------------

---Search for products in shop with keyword
CREATE PROCEDURE dbo.spSearchInShop
@shopId INT, 
@keyword NVARCHAR(100)
AS
BEGIN
Declare @outputData NVARCHAR(MAX);
DECLARE @query NVARCHAR(MAX);
declare @tableId int;

If @shopId % 20 = 0
	SET @tableId =  @shopId/20;
ELSE
	SET @tableId =  @shopId/20 + 1;

declare @tableName varchar(100) = N'product'+ cast(@tableId as varchar);

IF OBJECT_ID('tempdb..#Products') IS NOT NULL
	Truncate TABLE #Products
else
	CREATE TABLE #Products 
	(
		id int,
		name varchar(100),
		image varchar(200),
		subCategoryChildId int,
		price int
	 )
	 
IF OBJECT_ID('tempdb..#Categories') IS NOT NULL
DROP TABLE #Categories;

----all matching products added to temp table #Products
Declare @search varchar(100) = '''%' + @keyword + '%''';
SET @query = N'
	select productMaster.id as id,
	productMaster.name as name, 
	productMaster.image as image, 
	productMaster.subCategoryChildId as subCategoryChildId,
	product.price as price
	From
		productMaster
		INNER JOIN '+ @tableName + ' as product on product.productMasterId = productMaster.id
	where productMaster.name LIKE ' + @search + '
	and product.shopId = ' + cast(@shopId as varchar) + '
	Order By productMaster.subCategoryChildId OFFSET 0 ROWS
	';

INSERT INTO #Products
	EXEC sp_executesql @query;

----all categories and subCategories for the products retrieved into #Categories

select 
subCategory.categoryId as categoryId,
subCategory.id as subCategoryId,
subCategoryChild.id as subCategoryChildId
INTO #Categories
from 
subCategoryChild
INNER JOIN subCategory on subCategory.id = subCategoryChild.subCategoryId 
where subCategoryChild.id in (
	select subCategoryChildId from #Products
); 

with x(json) as (
	select 
	categoryId = categoryId,
	subCategoryId = subCategoryId,
	subCategoryChildId = subCategoryChildId,
	data = (
		select id, name, image, price from #Products
		where subCategoryChildId = C.subCategoryChildId
		FOR JSON PATH, INCLUDE_NULL_VALUES 
	)
	From 
	#Categories C 
	FOR JSON PATH, INCLUDE_NULL_VALUES
)

 select @outputData=json from x;
 select @outputData;
 RETURN
END

GO;
----------------------------------------------------------------

--Get all shops having products with keyword
--constraint to `near the user`

CREATE PROCEDURE dbo.spSearchShopsWithProduct
@custLat FLOAT, @custLng FLOAT, @keyword NVARCHAR(100)
AS
BEGIN
	DECLARE @id INT;
	DECLARE @name NVARCHAR(100);
	DECLARE @category NVARCHAR(30);
	DECLARE @image NVARCHAR(100);
	DECLARE @onlineStatus bit;
	
	DECLARE @tableId int;
	DECLARE @tableName varchar(100);
	DECLARE @query NVARCHAR(MAX);
	DECLARE @search varchar(100) = '''%' + @keyword + '%''';
	--This procedure is combination of two separate procedures
	-- 1st Find all shops near the user
	-- 2nd find products in this shop matching keyword
	-- For faster results lets not use second one
	-- instead write out own sub query
	
	DECLARE @stagingTable table (
		shopId INT,
		name nvarchar(100),
		category nvarchar(50),
		onlineStatus bit,
		image nvarchar(100),
		distance DECIMAL(3, 3)
	);
	DECLARE @searchFlag INT; --to check if product exist in shop
	INSERT Into @stagingTable exec spfindShopsNearby @custLat, @custLng;

	Declare shopCursor cursor for
		select shopId, name, category, onlineStatus, image from @stagingTable
	Open shopCursor 
	
	Fetch next from shopCursor into @id, @name, @category, @onlineStatus, @image 
	
	While(@@FETCH_STATUS=0)
	Begin
		--each of the row this cursor points to is shop near this user
		--For each loop set @searchFlag to null, to not hold past value
		SET @searchFlag = NULL;
		--find the table name for the shop with shopId = @id
		If @id % 20 = 0
			SET @tableId =  @id/20;
		ELSE
			SET @tableId =  @id/20 + 1;
		
		SET @tableName = N'product'+ cast(@tableId as varchar);
	
		SET @query = N'
			select
			TOP 1
			@searchFlag = productMaster.id
			From
			productMaster
			INNER JOIN product1 as product on product.productMasterId = productMaster.id
			where (productMaster.name LIKE '+ @search +'
				and product.shopId = ' + cast(@id as varchar) + ' )';
			
		EXEC sp_executesql @query, N'@searchFlag INT OUTPUT', @searchFlag=@searchFlag OUTPUT;
		if(@searchFlag is NULL)
		begin
			Delete from @stagingTable where shopId=@id
		end
		Fetch next from shopCursor into @id, @name, @category, @onlineStatus, @image
	END
	SELECT * FROM @stagingTable;
END




GO;

----------------------------------------------------------------

--Get all shops near to user with coordinates(lan, lng)



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


	DECLARE @distance FLOAT;
	DECLARE @outputTable table (
		shopId INT,
		name nvarchar(100),
		category nvarchar(50),
		onlineStatus bit,
		image nvarchar(100),
		distance DECIMAL(3, 3)
	);

	DECLARE shopCursor CURSOR 
		FOR
			SELECT id, name, category, onlineStatus, image, coverage FROM shop;
		
	Open shopCursor
		Fetch next from shopCursor into @id, @name, @category, @onlineStatus, @image, @coverage;
		WHILE @@FETCH_STATUS = 0
		begin
			
			--find distance between shop and customer
			SELECT @distance = geography::Point(@custLat, @custLng, 4326).STDistance(
				geography::Point(latitude, longitude, 4326)
			) from shopAddress
			where shopAddress.shopId = @id;
			--check if distance is less than the coverage of shop
			If(@distance<=@coverage)
			begin
				--if user is within coverage distance add shop to output table
				INSERT INTO @outputTable(shopId, name, category, onlineStatus, image, distance) 
				values (@id, @name, @category, @onlineStatus, @image, @distance);
			end
			
			Fetch next from shopCursor into @id, @name, @category, @onlineStatus, @image, @coverage;
		end
		
	Close shopCursor
	Deallocate shopCursor
	--output all found shops
	select * from @outputTable
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