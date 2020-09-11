---------------------------------------------------------
-----------Get Top 5 products in Shop recommendations----

CREATE Procedure dbo.spGetRecommendedProducts
@shopId INT
As
BEGIN
	DECLARE @tableId int;
	Declare @baseUrl varchar(200);
	--get baseUrl as local variable
	Select @baseUrl=baseUrl from appConfig;
	DECLARE @query NVARCHAR(MAX);	
	If @shopId % 20 = 0
		SET @tableId =  @shopId/20;
	ELSE
		SET @tableId =  @shopId/20 + 1;
	
	DECLARE @tableName varchar(100) = N'product'+ cast(@tableId as varchar);

	SET @query = N'
		SELECT
		TOP 5
		rcmdProduct.id,
		rcmdProduct.shopId,
		product.id as productId,
		productMaster.name,
		productMaster.id as productMasterId,
		CONCAT(@baseUrl, productMaster.image) as image,
		product.price
		from recommendedProducts as rcmdProduct
		INNER JOIN '+@tableName+' as product 
		on 
			product.id = rcmdProduct.productId
		INNER JOIN productMaster on productMaster.id = product.productMasterId
		where rcmdProduct.shopId = '+cast(@shopId as varchar)+'
		ORDER BY [count] desc;
	';
	
	EXEC sp_executeSql @query, N'@baseUrl VARCHAR(200)', @baseUrl;
END
GO;
---------------------------------------------------------
-----------INSERT OR UPDATE recommendedProducts----------
CREATE Procedure dbo.spInsertRecommendedProduct
@shopId INT,
@json NVARCHAR(MAX)
As
Begin
	with stagingTable as (
  	SELECT productId, @shopId as shopId from OPENJSON(@json, '$.detail')
	    with (
	      productId INT '$.productId'
	    )
	)

    MERGE recommendedProducts AS TARGET
    USING stagingTable AS SOURCE
    ON (SOURCE.shopId = TARGET.shopId AND SOURCE.productId = TARGET.productId)
    WHEN MATCHED 
    THEN 
        UPDATE set count = count + 1
    WHEN NOT MATCHED
    THEN
        INSERT (shopId, productId)
        VALUES (SOURCE.shopId, SOURCE.productId);
END