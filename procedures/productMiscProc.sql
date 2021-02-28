--------This procedures are mainly for product Masters and offers--------------
--------Since products for shops are handled in shopProcedures-----------------

--------------------------------------------------------------------
----------------Search productMaster by keyword---------------------

CREATE PROCEDURE dbo.spGetProductMasterByKeyword
@searchTerm NVARCHAR(100),
@categoryId int
AS
BEGIN
	Declare @baseUrl varchar(200);
	--get baseUrl as local variable
	Select @baseUrl=baseUrl from appConfig;	
	DECLARE @searchKey NVARCHAR(100) = '%' + @searchTerm + '%'; 
	DECLARE @query NVARCHAR(MAX) = N'
		SELECT 
		TOP 10
		p.id as productId,
		p.name,
		COALESCE(@baseUrl + p.image, null) as [image],
		COALESCE(@baseUrl + p.bigImage1, null) as bigImage1,
		COALESCE(@baseUrl + p.bigImage2, null) as bigImage2,
		COALESCE(@baseUrl + p.bigImage3, null) as bigImage3,
		COALESCE(@baseUrl + p.bigImage4, null) as bigImage4,
		COALESCE(@baseUrl + p.bigImage5, null) as bigImage5,
		COALESCE(@baseUrl + p.bigImage6, null) as bigImage6,
		scc.name as subCategoryChildName,
		scc.id as subCategoryChildId,
		sc.name as subCategoryName,
		sc.id as subCategoryId,
		c2.name as categoryName,
		c2.id as categoryId
		FROM productMaster as p
		INNER JOIN subCategoryChild scc on scc.id = p.subCategoryChildId
		INNER JOIN subCategory sc on sc.id = scc.subCategoryId 
		INNER JOIN category c2 on c2.id = sc.categoryId 
		where p.name like @searchKey
	';
	if @categoryId IS NOT NULL
	BEGIN
		SET @query = @query + N'
			and c2.id = @categoryId
		';
	END
	-- Finally execute the query
	EXEC sp_executeSql 
		@query, 
		N'@searchKey NVARCHAR(100), @baseUrl varchar(200), 
		  @categoryId int
		',
		@searchKey, @baseUrl, @categoryId
	;
END

GO;

--------------------------------------------------------------------
--------------------Add new Product in productMaster----------------
CREATE PROCEDURE dbo.spInsertInProductMaster
@json NVARCHAR(max)
AS
BEGIN
	INSERT into productMaster (
		name, subCategoryChildId, 
		[image], bigImage1, 
		bigImage2, bigImage3, 
		bigImage4, bigImage5, bigImage6 
	)
	select json.name, json.subCategoryChildId, 
		json.image, json.bigImage1, 
		json.bigImage2, json.bigImage3, 
		json.bigImage4, json.bigImage5, json.bigImage6  
	from openjson(@json)
	with(
		name nvarchar(100) '$.name', 
		subCategoryChildId nvarchar(100) '$.subCategoryChildId',
		image nvarchar(100) '$.image',
		bigImage1 nvarchar(100) '$.bigImage1',
		bigImage2 nvarchar(100) '$.bigImage2',
		bigImage3 nvarchar(100) '$.bigImage3',
		bigImage4 nvarchar(100) '$.bigImage4',
		bigImage5 nvarchar(100) '$.bigImage5',
		bigImage6 nvarchar(100) '$.bigImage6'
	)json
END

GO;
--------------------------------------------------------------------
--------------------Update Product in productMaster-----------------

CREATE PROCEDURE dbo.spUpdateInProductMaster
@json NVARCHAR(max), @productMasterId INT
AS
BEGIN
	DECLARE @query NVARCHAR(MAX);
	DECLARE @paramDef nvarchar (500);	
	DECLARE @tableName varchar(15) = 'productMaster';

	IF OBJECT_ID('tempdb..#ProductMasterTemp') IS NOT NULL
	DROP TABLE #ProductMasterTemp;

	select 
		@productMasterId as id,
		json.name, json.subCategoryChildId,
		json.image, json.bigImage1, 
		json.bigImage2, json.bigImage3, 
		json.bigImage4, json.bigImage5, json.bigImage6
	INTO #ProductMasterTemp FROM OPENJSON(@json)
	    with (
			name nvarchar(100) '$.name', 
			subCategoryChildId nvarchar(100) '$.subCategoryChildId',
			image nvarchar(100) '$.image',
			bigImage1 nvarchar(100) '$.bigImage1',
			bigImage2 nvarchar(100) '$.bigImage2',
			bigImage3 nvarchar(100) '$.bigImage3',
			bigImage4 nvarchar(100) '$.bigImage4',
			bigImage5 nvarchar(100) '$.bigImage5',
			bigImage6 nvarchar(100) '$.bigImage6'
	    )json

	SET @query = N'
		UPDATE '+@tableName+'
		SET 
		'+@tableName+'.name = 
			CASE WHEN (#ProductMasterTemp.name IS NOT NULL) THEN #ProductMasterTemp.name
			ELSE '+@tableName+'.name END,
		'+@tableName+'.subCategoryChildId = 
			CASE WHEN (#ProductMasterTemp.subCategoryChildId IS NOT NULL) THEN #ProductMasterTemp.subCategoryChildId
			ELSE '+@tableName+'.subCategoryChildId END,
		'+@tableName+'.image = 
			CASE WHEN (#ProductMasterTemp.image IS NOT NULL) THEN #ProductMasterTemp.image
			ELSE '+@tableName+'.image END,
		'+@tableName+'.bigImage1 =
			CASE WHEN (#ProductMasterTemp.bigImage1 IS NOT NULL) THEN #ProductMasterTemp.bigImage1
			ELSE '+@tableName+'.bigImage1 END,
		'+@tableName+'.bigImage2 =
			CASE WHEN (#ProductMasterTemp.bigImage2 IS NOT NULL) THEN #ProductMasterTemp.bigImage2
			ELSE '+@tableName+'.bigImage2 END,
		'+@tableName+'.bigImage3 =
			CASE WHEN (#ProductMasterTemp.bigImage3 IS NOT NULL) THEN #ProductMasterTemp.bigImage3
			ELSE '+@tableName+'.bigImage3 END,
		'+@tableName+'.bigImage4 =
			CASE WHEN (#ProductMasterTemp.bigImage4 IS NOT NULL) THEN #ProductMasterTemp.bigImage4
			ELSE '+@tableName+'.bigImage4 END,
		'+@tableName+'.bigImage5 =
			CASE WHEN (#ProductMasterTemp.bigImage5 IS NOT NULL) THEN #ProductMasterTemp.bigImage5
			ELSE '+@tableName+'.bigImage5 END,
		'+@tableName+'.bigImage6 =
			CASE WHEN (#ProductMasterTemp.bigImage6 IS NOT NULL) THEN #ProductMasterTemp.bigImage6
			ELSE '+@tableName+'.bigImage6 END
		FROM '+@tableName+', #ProductMasterTemp 
		WHERE #ProductMasterTemp.id = '+@tableName+'.id';
	
	EXEC sp_executeSql @query;

END


GO;
--------------------------------------------------------------------
--------------------Delete Product in productMaster-----------------


-------------------------------------------------------------------------
--------------------Get all Shop Offers belonging to shop ---------------

CREATE PROCEDURE dbo.spGetshopOffersForShop
@shopId int,
@page int
AS
BEGIN
	DECLARE @offset INT = 15 * (@page - 1);		
	Declare @baseUrl varchar(200);
	--get baseUrl as local variable
	Select @baseUrl=baseUrl from appConfig;	
	DECLARE @query NVARCHAR(500) = N'
		SELECT 
		id,
		shopId,
		CONCAT(@baseUrl, offer_image ) as offer_image,
		createdAt 
		FROM shopOffers
		where 1=1
	';
	if @shopId IS NOT NULL
	BEGIN
		SET @query = @query + N'
			AND shopId = @shopId
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
		N'@shopId int, @offset INT, @baseUrl varchar(200)',
		@shopId, @offset, @baseUrl
	;
END

GO;
-------------------------------------------------------------------------
--------------------Add new Shop Offers ---------------------------------

CREATE PROCEDURE dbo.spInsertInshopOffers
@json NVARCHAR(max)
AS
BEGIN
	DECLARE @shopId INT = JSON_VALUE(@json, '$.shopId');
	DECLARE @offerImage NVARCHAR(100) = JSON_VALUE(@json, '$.offer_image');

	INSERT INTO shopOffers(shopId, offer_image )
	VALUES (@shopId, @offerImage);
	
END

GO;

-------------------------------------------------------------------------
---------------------Update Shop Offers ---------------------------------

CREATE PROCEDURE dbo.spUpdateInshopOffers
@json NVARCHAR(max), @offerId INT
AS
BEGIN
	DECLARE @query NVARCHAR(MAX);
	DECLARE @tableName varchar(15) = 'shopOffers';	
	DECLARE @shopId INT = JSON_VALUE(@json, '$.shopId');
	DECLARE @offerImage NVARCHAR(100) = JSON_VALUE(@json, '$.offer_image');
	DECLARE @prevImage NVARCHAR(100);

    SELECT @prevImage = offer_image 
    from shopOffers
    where id = @offerId;

	SET @query = N'
		UPDATE '+@tableName+'
		SET 
		'+@tableName+'.shopId = 
			CASE WHEN (@shopId IS NOT NULL) THEN @shopId
			ELSE '+@tableName+'.shopId END,
		'+@tableName+'.offer_image = 
			CASE WHEN (@offerImage IS NOT NULL) THEN @offerImage
			ELSE '+@tableName+'.offer_image END 
		WHERE '+@tableName+'.id = @offerId';
	
	EXEC sp_executeSql 
		@query, 
		N'@shopId int, @offerImage nvarchar(100), @offerId int',
		@shopId, @offerImage, @offerId
	;
	SELECT @prevImage as previousImage;
END

GO;
-------------------------------------------------------------------------
---------------------Delete Shop Offers ---------------------------------

CREATE PROCEDURE dbo.spDeleteInshopOffers
@offerId INT
AS
BEGIN
	DECLARE @prevImage NVARCHAR(100);

    SELECT @prevImage = offer_image 
    from shopOffers
    where id = @offerId;

	DELETE FROM shopOffers
	where id = @offerId;
	
	SELECT @prevImage as previousImage;
END

-------------Get app Config------------
CREATE PROCEDURE dbo.spGetAppConfig
AS
BEGIN
	SELECT
	*
	FROM appConfig
	WHERE id = 1;
END

-----------Update app config--------------
CREATE PROCEDURE dbo.spUpdateAppConfig
@json NVARCHAR(MAX)
AS
BEGIN
	DECLARE @baseUrl varchar(150) = JSON_VALUE(@json, '$.baseUrl');
	DECLARE @CGST int = JSON_VALUE(@json, '$.CGST');
	DECLARE @GST int = JSON_VALUE(@json, '$.GST');
	DECLARE @stdShipping int = JSON_VALUE(@json, '$.stdShipping');
	DECLARE @minShippingDistance INT = JSON_VALUE(@json, '$.minShippingDistance');
	DECLARE @extraShippingCharge INT = JSON_VALUE(@json, '$.extraShippingCharge');

	UPDATE appConfig
	SET 
		appConfig.baseUrl = 
			CASE WHEN (@baseUrl IS NOT NULL)
				THEN @baseUrl
				ELSE appConfig.baseUrl
			END,
		appConfig.CGST = 
			CASE WHEN (@CGST IS NOT NULL)
				THEN @CGST
				ELSE appConfig.CGST
			END,
		appConfig.GST = 
			CASE WHEN (@GST IS NOT NULL)
				THEN @GST
				ELSE appConfig.GST
			END,
		appConfig.stdShipping = 
			CASE WHEN (@stdShipping IS NOT NULL)
				THEN @stdShipping
				ELSE appConfig.stdShipping
			END
		-- appConfig.minShippingDistance = 
		-- 	CASE WHEN (@minShippingDistance IS NOT NULL)
		-- 		THEN @minShippingDistance
		-- 		ELSE appConfig.minShippingDistance
		-- 	END,
		-- appConfig.extraShippingCharge = 
		-- 	CASE WHEN (@extraShippingCharge IS NOT NULL)
		-- 		THEN @extraShippingCharge
		-- 		ELSE appConfig.extraShippingCharge
		-- 	END			
		WHERE appConfig.id = 1;

	SELECT 'updated' as [message];	
END