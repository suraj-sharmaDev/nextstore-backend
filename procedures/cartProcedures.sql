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

GO;
---------------------------------------------
---------------- Get Customer Cart Data-------

CREATE Procedure dbo.spGetCustomerCart
@custId int
As
Begin 
	Declare @result nvarchar(max);
	with x(json) as (
		Select
			id as customerId,
			cart = (
				select cm.shopId, cartDetail.* 
				from cartMaster cm
				inner join cartDetail on cartDetail.cartMasterId = cm.id
				where cm.customerId = 1 and cm.status = 0
				FOR JSON AUTO, INCLUDE_NULL_VALUES
			)
		from customer
		where id = @custId
		For Json Auto, INCLUDE_NULL_VALUES, WITHOUT_ARRAY_WRAPPER	
	)
	
	select @result=json from x;
	select @result;
	RETURN
End