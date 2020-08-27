
----------------------------------------------------------
CREATE PROCEDURE dbo.spCreateNewOrder
@json NVARCHAR(max)
AS
BEGIN

DECLARE @fcmToken NVARCHAR(250);
DECLARE @orderMasterId INT;
DECLARE @createdAt datetimeoffset = GETUTCDATE();

DECLARE @customerId INT = JSON_VALUE(@json, '$.master.customerId');
DECLARE @shopId INT = JSON_VALUE(@json, '$.master.shopId');
DECLARE @deliveryAddress NVARCHAR(250) = JSON_VALUE(@json, '$.master.deliveryAddress');

-- update cartMaster table to identify fulfilled carts

UPDATE cartMaster set status = 1 
where customerId = @customerId and shopId = @shopId and status = 0;

-- insert into ordermaster

insert into orderMaster (customerId, shopId, deliveryAddress, createdAt)
VALUES (@customerId, @shopId, @deliveryAddress, @createdAt);

--then bulk insert into orderDetail with the orderMasterId
SET @orderMasterId = SCOPE_IDENTITY();

INSERT into orderDetail (productId, productName, price, qty, orderMasterId)
  select json.productId, json.productName, json.price, json.qty, 
  @orderMasterId as orderMasterId
  from openjson(@json, '$.detail')
  with(
    productId INT '$.productId',
    productName nvarchar(100) '$.productName',
    price INT '$.price',
    qty INT '$.qty'
  )json

select @fcmToken=fcmToken from shop where id in (
	select shopId from openjson(@json, '$.master') with ( shopId int '$.shopId')
);

select @fcmToken as fcmToken, @orderMasterId as orderMasterId;
END


GO;
-----------------------------------------------------

--BULK CREATE orderDetail records
CREATE PROCEDURE dbo.spbulkCreateOrderDetail
@json NVARCHAR(max), @orderMasterId INT
AS
BEGIN

INSERT into orderDetail (productId, productName, qty, price, orderMasterId )
  select json.productId, json.productName, json.price, json.qty, @orderMasterId as orderMasterId 
  from openjson(@json)
  with(
    productId INT '$.productId',
    productName nvarchar(100) '$.productName',
    price INT '$.price',
    qty INT '$.qty'
  )json

END

GO;
-------------------------------------------------------

--BULK UPDATE orderDetail table
CREATE PROCEDURE dbo.spbulkUpdateOrderDetail
@json NVARCHAR(max)
AS
BEGIN
--create a staging table stagingTable with @json 
with stagingTable as (
  SELECT * from OPENJSON(@json)
    with (
      id INT '$.id',
      qty INT '$.qty'
    )
)

UPDATE
    dbo.orderDetail 
SET
    dbo.orderDetail.qty = s.qty
FROM
    dbo.orderDetail t
INNER JOIN
    stagingTable s
ON 
    s.id = t.id;

END

GO;
--------------------------------------------------------

--accept Order with orderId

CREATE PROCEDURE dbo.spAcceptOrder
@orderId INT, @fcmToken NVARCHAR(255) OUTPUT
AS
BEGIN

UPDATE
    dbo.orderMaster 
SET
    dbo.orderMaster.status = 'accepted'
WHERE
    dbo.orderMaster.id = @orderId

--send back the fcmToken for the customer with provided orderId

select @fcmToken=fcmToken from customer where id in (
  select customerId from dbo.orderMaster where id = @orderId
)  
END

GO;

--------------------------------------------------------
------reject Order with orderId-------------------------

CREATE PROCEDURE dbo.spRejectOrder
@orderId INT, @fcmToken NVARCHAR(255) OUTPUT
AS
BEGIN

UPDATE
    dbo.orderMaster 
SET
    dbo.orderMaster.status = 'rejected'
WHERE
    dbo.orderMaster.id = @orderId

--send back the fcmToken for the customer with provided orderId

select @fcmToken=fcmToken from customer where id in (
  select customerId from dbo.orderMaster where id = @orderId
)  
END

GO;

-------------------------------------------------------------------
------------Get Orders for shops belonging to any of 4 criteria----

CREATE Procedure dbo.spGetShopOrders
@shopId INT,
@status NVARCHAR(30),
@page INT,
@startDate datetimeoffset,
@endDate datetimeoffset
As
BEGIN
	-- this procedure gives 15 orders belonging to shopId
	-- orders with status pending, accepted, rejected or all
	DECLARE @offset INT = 15 * (@page - 1);
	IF (@startDate is not NULL and @endDate is not NULL)
	BEGIN
		IF (@status = 'all')
		BEGIN 
			;with x(json) as (
				SELECT 
				*,
				items = (
					select * from orderDetail
					where orderMasterId = orderMaster.id
					and ( createdAt >= @startDate and createdAt <= @endDate)
					FOR JSON PATH, INCLUDE_NULL_VALUES
				)
				from orderMaster
				where shopId = @shopId 
				ORDER BY id 
				OFFSET @offset ROWS FETCH NEXT 15 ROWS ONLY
				FOR JSON AUTO, INCLUDE_NULL_VALUES
			)
			select json as [json] from x;
		END
		ELSE 
		BEGIN 
			;with x(json) as (
				SELECT 
				*,
				items = (
					select * from orderDetail
					where orderMasterId = orderMaster.id
					and ( createdAt >= @startDate and createdAt <= @endDate)
					FOR JSON PATH, INCLUDE_NULL_VALUES
				)
				from orderMaster
				where shopId = @shopId 
				and 
				status = @status
				ORDER BY id 
				OFFSET @offset ROWS FETCH NEXT 15 ROWS ONLY
				FOR JSON AUTO, INCLUDE_NULL_VALUES
			)
			select json as [json] from x;
		END
	END
	ELSE
	BEGIN
		IF (@status = 'all')
		BEGIN
			;with x(json) as (
				SELECT 
				*,
				items = (
					select * from orderDetail
					where orderMasterId = orderMaster.id
					FOR JSON PATH, INCLUDE_NULL_VALUES
				)
				from orderMaster
				where shopId = @shopId 
				ORDER BY id 
				OFFSET @offset ROWS FETCH NEXT 15 ROWS ONLY
				FOR JSON AUTO, INCLUDE_NULL_VALUES
			)
			select json as [json] from x;
		END
		ELSE
		BEGIN
			;with x(json) as (
				SELECT 
				*,
				items = (
					select * from orderDetail
					where orderMasterId = orderMaster.id
					FOR JSON PATH, INCLUDE_NULL_VALUES
				)
				from orderMaster
				where shopId = @shopId 
				and status = @status
				ORDER BY id 
				OFFSET @offset ROWS FETCH NEXT 15 ROWS ONLY
				FOR JSON AUTO, INCLUDE_NULL_VALUES
			)
			select json as [json] from x;
		END
	END	
END