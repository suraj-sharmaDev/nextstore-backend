
----------------------------------------------------------
CREATE PROCEDURE dbo.spCreateNewOrder
@json NVARCHAR(max)
AS
BEGIN
	-- DECLARE @fcmToken NVARCHAR(250);
	DECLARE @orderMasterId INT;
	DECLARE @createdAt datetimeoffset = GETUTCDATE();

	DECLARE @customerId INT = JSON_VALUE(@json, '$.master.customerId');
	DECLARE @shopId INT = JSON_VALUE(@json, '$.master.shopId');
	DECLARE @deliveryAddress NVARCHAR(500) = JSON_QUERY(@json, '$.master.deliveryAddress');

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

	---all the products ordered will be sent for recommendation---
	EXEC spInsertRecommendedProduct @shopId, @json;  
	--------------------------------------------------------------
	
	-- select @fcmToken=fcmToken from shop where id in (
	-- 	select shopId from openjson(@json, '$.master') with ( shopId int '$.shopId')
	-- );

	;with x(json) as (
		select
		orderMaster.*,
		items.productId,
		items.productName,
		items.price,
		items.qty 
		from 
		(
			SELECT orderMaster.*, shop.name from orderMaster
			INNER JOIN shop on shop.id = orderMaster.shopId
			WHERE [orderMaster].[id] = @orderMasterId
		)
		as orderMaster				
		INNER JOIN orderDetail as items on items.orderMasterId = orderMaster.id
		And orderMaster.status in ('pending', 'accepted')
		For Json AUTO, INCLUDE_NULL_VALUES	
	)

	select 
	(
		SELECT fcmToken FROM (
			SELECT fcmToken
			FROM adminTable
			where adminTable.fcmToken IS NOT NULL and adminTable.fcmToken <> ''	
			UNION ALL			
			select fcmToken 
			from shop
			where id = @shopId
			and shop.fcmToken IS NOT NULL and shop.fcmToken <> ''
		)A
		FOR JSON PATH
	) as fcmToken,
	@orderMasterId as orderMasterId, 
	json as orderDetail from x;

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
@orderId INT
AS
BEGIN
	DECLARE @fcmToken NVARCHAR(255);
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
	
	select @fcmToken as fcmToken;
END

GO;

--------------------------------------------------------

--compelete Order with orderId

CREATE PROCEDURE dbo.spCompleteOrder
@orderId INT
AS
BEGIN
	DECLARE @fcmToken NVARCHAR(255);
	UPDATE
	    dbo.orderMaster 
	SET
	    dbo.orderMaster.status = 'completed'
	WHERE
	    dbo.orderMaster.id = @orderId
	
	--send back the fcmToken for the customer with provided orderId
	
	select @fcmToken=fcmToken from customer where id in (
	  select customerId from dbo.orderMaster where id = @orderId
	)
	
	select @fcmToken as fcmToken;
END

GO;
--------------------------------------------------------
------reject Order with orderId-------------------------

CREATE PROCEDURE dbo.spRejectOrder
@orderId INT
AS
BEGIN
	DECLARE @fcmToken NVARCHAR(255);
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
	select @fcmToken as fcmToken;
END

GO;

-------------------------------------------------------------------
-----------Get orders irrespective of any particular shops---------

CREATE Procedure dbo.spGetAllShopOrders
@status NVARCHAR(30),
@page INT,
@startDate datetimeoffset,
@endDate datetimeoffset
As
BEGIN
	-- this procedure gives 20 orders belonging to all shops
	-- orders with status pending, accepted, rejected or all
	DECLARE @offset INT = 20 * (@page - 1);
	DECLARE @query NVARCHAR(MAX) = N'
			;with x(json) as (
				SELECT 
				orderMaster.*,
				shop.name as shopName,
				customer.name as customerName,
				customer.mobile as customerMobile,				
				items = (
					select * from orderDetail
					where orderMasterId = orderMaster.id
					FOR JSON PATH, INCLUDE_NULL_VALUES
				)
				from orderMaster
				INNER JOIN shop on shop.id = orderMaster.shopId
				INNER JOIN customer on customer.id = orderMaster.customerId
				where orderMaster.shopId > 0
	';
	
	IF (@startDate is not NULL and @endDate is not NULL)
	BEGIN
		SET @query = @query + '
			and ( createdAt >= @startDate and createdAt <= @endDate)
		';
	END
	IF (@status <> 'all')
	BEGIN
		SET @query = @query + '
				and status = @status
		';
	END
	-- finally query execution
	SET @query = @query + '
		ORDER BY orderMaster.id DESC
		OFFSET @offset ROWS 
		FETCH FIRST 20 ROWS ONLY
		FOR JSON PATH, INCLUDE_NULL_VALUES
		)
		SELECT json as [json] from x;
	';
	EXEC sp_executeSql 
		@query, 
		N'@status NVARCHAR(30), @startDate datetimeoffset, @endDate datetimeoffset, @offset INT',
		@status, @startDate, @endDate, @offset
	;
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
	DECLARE @query NVARCHAR(MAX) = N'
			;with x(json) as (
				SELECT 
				orderMaster.*,
				customer.name as customerName,
				customer.mobile as customerMobile,
				items = (
					select * from orderDetail
					where orderMasterId = orderMaster.id
					FOR JSON PATH, INCLUDE_NULL_VALUES
				)
				from orderMaster
				INNER JOIN customer on customer.id = orderMaster.customerId 
				where shopId = @shopId
	';
	
	IF (@startDate is not NULL and @endDate is not NULL)
	BEGIN
		SET @query = @query + '
			and ( createdAt >= @startDate and createdAt <= @endDate)
		';
	END
	IF (@status <> 'all')
	BEGIN
		SET @query = @query + '
				and status = @status
		';
	END
	-- finally query execution
	SET @query = @query + '
		ORDER BY orderMaster.id DESC
		OFFSET @offset ROWS 
		FETCH FIRST 15 ROWS ONLY
		FOR JSON PATH, INCLUDE_NULL_VALUES
		)
		SELECT json as [json] from x;
	';
	EXEC sp_executeSql 
		@query, 
		N'@shopId INT, @status NVARCHAR(30), @startDate datetimeoffset, @endDate datetimeoffset, @offset INT',
		@shopId, @status, @startDate, @endDate, @offset
	;
END

------------------------------------------------------------------------
------------------Get Orders--------------------------------------------

CREATE Procedure dbo.spGetCustomerOrders
@customerId INT,
@page INT,
@startDate datetimeoffset,
@endDate datetimeoffset
As
BEGIN
	-- this procedure gives 15 orders belonging to customerId
	DECLARE @offset INT = 15 * (@page - 1);
	DECLARE @status NVARCHAR(20) = N'completed';
	Declare @baseUrl varchar(200);
	--get baseUrl as local variable
	Select @baseUrl=baseUrl from appConfig;

	DECLARE @query NVARCHAR(MAX) = N'
			;with x(json) as (
				SELECT 
				orderMaster.*,
				shop.name as shopName,
				shop.category as category,
				CONCAT(@baseUrl ,shop.image) as shopImage,
				items = (
					select * from orderDetail
					where orderMasterId = orderMaster.id
					FOR JSON PATH, INCLUDE_NULL_VALUES
				)
				from orderMaster
				INNER JOIN shop on shop.id = orderMaster.shopId 
				where orderMaster.customerId = @customerId
                and orderMaster.status = @status
	';	
	IF (@startDate is not NULL and @endDate is not NULL)
	BEGIN
		SET @query = @query + '
			and ( createdAt >= @startDate and createdAt <= @endDate)
		';
	END
	-- finally query execution
	SET @query = @query + '
		ORDER BY orderMaster.id DESC
		OFFSET @offset ROWS 
		FETCH FIRST 15 ROWS ONLY
		FOR JSON PATH, INCLUDE_NULL_VALUES
		)
		SELECT json as [json] from x;
	';
	EXEC sp_executeSql 
		@query, 
		N'@customerId INT, @status NVARCHAR(30), 
		  @startDate datetimeoffset, 
		  @endDate datetimeoffset, @offset INT,
		  @baseUrl varchar(200)
		',
		@customerId, @status, @startDate, @endDate, @offset, @baseUrl
	;
END