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

-----------------------------------------------------------

---Search for products in shop with keyword
CREATE PROCEDURE dbo.spSearchInShop
@shopId INT, @keyword NVARCHAR(100)
AS
BEGIN

with x(json) as (
	select productMaster.id,
	productMaster.name, productMaster.image, 
	productMaster.subCategoryChildId,
	product.price
	from productMaster
	INNER JOIN product on product.productMasterId = productMaster.id
	where productMaster.name LIKE '%'+@keyword+'%'
	and product.shopId = @shopId
	For Json Path
)
 select json from x
END


----------------------------------------------------------------

--Get all shops having products with keyword
--constraint to `near the user`

CREATE PROCEDURE dbo.spSearchShopsWithProduct
@custLat FLOAT, @custLng FLOAT, @keyword NVARCHAR(100)
AS
BEGIN
	--This procedure is combination of two separate procedures
	-- 1st Find all shops near the user
	-- 2nd find products in this shop matching keyword
	
	DECLARE @outputTable table (
		shopId INT,
		name nvarchar(100),
		category nvarchar(50),
		onlineStatus bit,
		image nvarchar(100)
	);
	INSERT Into @outputTable exec spfindShopsNearby @custLat, @custLng;
	Declare shopCursor cursor for
		select * from @outputTable
	Open shopCursor 
	Fetch next from shopCursor 
	While(@@FETCH_STATUS=0)
	Begin
		Fetch next from shopCursor
	END
END

----------------------------------------------------------------

--Get all shops near to user with coordinates(lan, lng)

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
		image nvarchar(100)
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
				INSERT INTO @outputTable(shopId, name, category, onlineStatus, image) 
				values (@id, @name, @category, @onlineStatus, @image);
			end
			
			Fetch next from shopCursor into @id, @name, @category, @onlineStatus, @image, @coverage;
		end
		
	Close shopCursor
	Deallocate shopCursor
	--output all found shops
	select * from @outputTable
END