--Get all categories, subCategories and subCategorychild for any shop
CREATE PROCEDURE dbo.spCreateShopContent
@shopId INT
AS
BEGIN
--will create json output for shops complete details
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
				select DISTINCT productMasterId 
				from product
				where shopId = @shopId
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

----------------------------------------------------------
--Get all products belonging to shop with shopId and subCategoyId
CREATE PROCEDURE dbo.spGetProductsInSubCategory
@shopId INT, 
@subCategoryId INT
AS
BEGIN
	Declare @outputData NVARCHAR(MAX);
	--steps--
	--get all subCategoryChild matching subCategoryId = @subCategoryId
	--get all products with subCategoryChild matching above and belonging to shopId
	-- add categories to those shops
	-- return in readable json format
	
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
		inner join (
			select 
			productMaster.id,
			productMaster.name,
			productMaster.image,
			productMaster.subCategoryChildId,
			product.price
			from productMaster
			Inner join product on product.productMasterId = productMaster.id
			where product.shopId = @shopId
		) as data on data.subCategoryChildId = scc.subCategoryChildId
		For Json AUTO, WITHOUT_ARRAY_WRAPPER
	)
 select @outputData=json from x;
 select @outputData;
 RETURN

END

-----------------------------------------------------------

---Search for products in shop with keyword
CREATE PROCEDURE dbo.spSearchInShop
@shopId INT, 
@keyword NVARCHAR(100)
AS
BEGIN
Declare @outputData NVARCHAR(MAX);
IF OBJECT_ID('tempdb..#Products') IS NOT NULL
DROP TABLE #Products;

IF OBJECT_ID('tempdb..#Categories') IS NOT NULL
DROP TABLE #Categories;

----all matching products added to temp table #Products
select productMaster.id as id,
productMaster.name as name, 
productMaster.image as image, 
productMaster.subCategoryChildId as subCategoryChildId,
product.price as price
INTO #Products
From
	productMaster
	INNER JOIN product on product.productMasterId = productMaster.id
where productMaster.name LIKE '%'+@keyword+'%'
and product.shopId = @shopId
Order By productMaster.subCategoryChildId OFFSET 0 ROWS

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
	--This procedure is combination of two separate procedures
	-- 1st Find all shops near the user
	-- 2nd find products in this shop matching keyword
	-- For faster results lets not use second one
	-- instead write our own sub query
	
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
		select 
		@searchFlag=productMaster.id
		From
			productMaster
			INNER JOIN product on product.productMasterId = productMaster.id
		where (productMaster.name LIKE '%'+@keyword+'%'
				and product.shopId = @id)
		if(@searchFlag is NULL)
		begin
			Delete from @stagingTable where shopId=@id
		end
		Fetch next from shopCursor into @id, @name, @category, @onlineStatus, @image
	END
	SELECT * FROM @stagingTable;
END





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