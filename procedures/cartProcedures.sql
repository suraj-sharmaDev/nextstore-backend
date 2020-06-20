--BULK CREATE cart records
CREATE PROCEDURE dbo.spbulkCreateCart
@json NVARCHAR(max), @customerId INT
AS
BEGIN

INSERT into cart (productId, name, image, price, qty, customerId)
  select json.productId, json.name, json.image, json.price, json.qty, @customerId as customerId 
  from openjson(@json)
  with(
    productId INT '$.productId',
    name nvarchar(100) '$.name',
    image nvarchar(180) '$.image',
    price INT '$.price',
    qty INT '$.qty'
  )json

END