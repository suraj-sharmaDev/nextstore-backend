--BULK CREATE cart records
CREATE PROCEDURE dbo.spbulkCreateCart
@json NVARCHAR(max)
AS
BEGIN
	DECLARE @cartMasterId INT;
	DECLARE @customerId INT = JSON_VALUE(@json, '$.master.customerId');
	DECLARE @shopId INT = JSON_VALUE(@json, '$.master.shopId');

	-- first check if the customer already has items from the shop
	SELECT @cartMasterId = id from cartMaster 
		where customerId = @customerId 
		and shopId = @shopId and status = 0;
	
	IF @cartMasterId IS NULL
	BEGIN
		-- First time cart being added
		INSERT into cartMaster (customerId, shopId)
		  select json.customerId, json.shopId 
		  from openjson(@json, '$.master')
		  with(
		    customerId INT '$.customerId',
			shopId INT '$.shopId'
		  )json
		  
		SET @cartMasterId = SCOPE_IDENTITY();		
	END
	-- after cartMasterId is found insert into cartDetail
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
				where cm.customerId = 1 and cm.status = 0 and cartDetail.qty > 0
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

GO;

-----------------------------------------------------------
----------------update cart items---------------------------
CREATE PROCEDURE dbo.spUpdateCart
@json NVARCHAR(MAX),
@customerId int,
@shopId int
AS
BEGIN
	DECLARE @cartMasterId INT = 0;
	-- find cartMasterId
	SELECT @cartMasterId = id from cartMaster
		where customerId = @customerId and shopId = @shopId
		and status = 0;

	IF @cartMasterId > 0
	BEGIN
		with stagingTable as (
		  SELECT *, @cartMasterId as cartMasterId from OPENJSON(@json)
		    with (
		      productId INT '$.productId',
		      qty INT '$.qty'
		    )
		)
		
		UPDATE
		    dbo.cartDetail 
		SET
		    dbo.cartDetail.qty = s.qty
		FROM
		    dbo.cartDetail t
		INNER JOIN
		    stagingTable s
		ON 
		    s.productId = t.productId
		AND 
			s.cartMasterId = t.cartMasterId 
	END
	
END

GO;
-----------------------------------------------------------
----------------delete cart items---------------------------

CREATE PROCEDURE dbo.spDeleteCart
@json NVARCHAR(MAX),
@customerId int,
@shopId int
AS
BEGIN
	DECLARE @cartMasterId INT = 0;
	-- find cartMasterId
	SELECT @cartMasterId = id from cartMaster
		where customerId = @customerId and shopId = @shopId
		and status = 0;

	IF @cartMasterId > 0
	BEGIN
		DELETE FROM cartDetail where cartMasterId = @cartMasterId and 
		productId in (
			SELECT id from openjson(@json)
			with (
				id INT '$'
			)
		)	
	END
END