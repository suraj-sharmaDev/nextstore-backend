--------This procedures are mainly for product Masters and offers--------------
--------Since products for shops are handled in shopProcedures-----------------

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
-------------------------------------------------------------------------
---------------------Delete Shop Offers ---------------------------------