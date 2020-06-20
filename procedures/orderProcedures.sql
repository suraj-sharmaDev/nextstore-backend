--Create new orderMaster and add children orderdetails
CREATE PROCEDURE dbo.spCreateNewOrder
@json NVARCHAR(max)
AS
BEGIN
DECLARE @orderMasterId INT;
DECLARE @createdAt datetimeoffset;
SET @createdAt = GETUTCDATE();

insert into orderMaster (customerId, shopId, createdAt)
  select json.customerId, json.shopId, @createdAt as createdAt
  from openjson(@json, '$.master')
    with(
      customerId int '$.customerId',
      shopId int '$.shopId'
    )json
--then bulk insert into orderDetail with the orderMasterId
SET @orderMasterId = SCOPE_IDENTITY();

INSERT into orderDetail (productId, productName, qty, price, orderMasterId)
  select json.productId, json.productName, json.price, json.qty, 
  @orderMasterId as orderMasterId
  from openjson(@json, '$.detail')
  with(
    productId INT '$.productId',
    productName nvarchar(100) '$.productName',
    price INT '$.price',
    qty INT '$.qty'
  )json

END

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