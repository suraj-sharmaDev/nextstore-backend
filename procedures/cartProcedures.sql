--BULK CREATE cart records
CREATE PROCEDURE dbo.spbulkCreateCart
@json NVARCHAR(max)
AS
BEGIN
	DECLARE @cartMasterId INT;
	-- first insert into cartMaster
	INSERT into cartMaster (customerId, shopId)
	  select json.customerId, json.shopId 
	  from openjson(@json, '$.master')
	  with(
	    customerId INT '$.customerId',
		shopId INT '$.shopId'
	  )json
	  
	SET @cartMasterId = SCOPE_IDENTITY();

	INSERT into cartDetail (productId, name, image, price, qty, cartMasterId)
	  select json.productId, json.name, json.image, json.price, json.qty, @cartMasterId as cartMasterId 
	  from openjson(@json, '$.detail')
	  with(
	    productId INT '$.productId',
	    name nvarchar(100) '$.name',
	    image nvarchar(180) '$.image',
	    price INT '$.price',
	    qty INT '$.qty'
	  )json

END