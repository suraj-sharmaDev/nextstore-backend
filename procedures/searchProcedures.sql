---Search for products in shop with keyword
CREATE PROCEDURE dbo.spSearchInShop
@shopId INT, 
@keyword NVARCHAR(100)
AS
BEGIN
	Declare @outputData NVARCHAR(MAX);
	DECLARE @query NVARCHAR(MAX);
	declare @tableId int;

	Declare @baseUrl varchar(200);
	--get baseUrl as local variable
	Select @baseUrl=baseUrl from appConfig;

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
		CONCAT(@baseUrl ,productMaster.image) as image, 
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
		EXEC sp_executesql @query, N'@baseUrl varchar(200)', @baseUrl;
	
	----all categories and subCategories for the products retrieved into #Categories
	
	select 
	subCategory.categoryId as categoryId,
	subCategory.id as subCategoryId,
	subCategoryChild.id as subCategoryChildId,
	subCategoryChild.name as title
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
		title = title,
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
	DECLARE @rating INT;

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
		rating INT,
		distance FLOAT
	);

	DECLARE @searchFlag INT; --to check if product exist in shop
	INSERT Into @stagingTable exec spfindShopsNearby @custLat, @custLng;

	Declare shopCursor cursor for
		select shopId, name, category, onlineStatus, image, rating from @stagingTable
	Open shopCursor 
	
	Fetch next from shopCursor into @id, @name, @category, @onlineStatus, @image, @rating 
	
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
		Fetch next from shopCursor into @id, @name, @category, @onlineStatus, @image, @rating
	END
	SELECT * FROM @stagingTable;
END

GO;


-----------------------------------------------------------------------------------------
----------------Get all nearby shops having products for subCategoryChildId--------------

CREATE PROCEDURE dbo.spSearchShopsWithSubCategoryChildId
@custLat FLOAT,
@custLng FLOAT,
@subCategoryChildId INT
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
		distance FLOAT
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
	
		-- find if the shop has products belonging to subcategoryChildId
			
		SET @query = N'
			select
			TOP 1
			@searchFlag = productMaster.id
			From
			productMaster
			INNER JOIN product1 as product on product.productMasterId = productMaster.id
			where (productMaster.subCategoryChildId = '+ cast(@subCategoryChildId as varchar) +'
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
