
-------------------------------------------------------
------------Get Details of a quote---------------------
CREATE Procedure dbo.spGetQuoteDetails
@quoteMasterId INT
AS
BEGIN
	with x(json) as (
		SELECT
		master = (
			select * from quoteMaster
			where id=@quoteMasterId
			FOR JSON AUTO
		),
		detail = (
			select * from quoteDetail
			where quoteMasterId=@quoteMasterId
			FOR JSON PATH			
		),
		providerBids = (
			select * from quotationBiddings
			where quoteMasterId = quoteMaster.id
			FOR JSON PATH, INCLUDE_NULL_VALUES
		)		
		For JSON PATH, INCLUDE_NULL_VALUES, WITHOUT_ARRAY_WRAPPER			
	)
	
	SELECT json from x;
END	

GO;

------------------------------------------------------
------Create a quote for user-------------------------
CREATE Procedure dbo.spCreateNewQuote
@json NVARCHAR(MAX)
AS
BEGIN
	DECLARE @quoteMasterId INT;
	DECLARE @createdAt datetimeoffset = GETUTCDATE();
	
	DECLARE @customerId INT = JSON_VALUE(@json, '$.master.customerId');
	DECLARE @type VARCHAR(20) = JSON_VALUE(@json, '$.master.type');
	DECLARE @deliveryAddress NVARCHAR(500) = JSON_QUERY(@json, '$.master.deliveryAddress');
	DECLARE @categoryId INT = JSON_VALUE(@json, '$.master.categoryId');
	--store customer latitude and longitude in variables
	DECLARE @custLat FLOAT = JSON_VALUE(@deliveryAddress, '$.coordinate.latitude');
	DECLARE @custLng FLOAT = JSON_VALUE(@deliveryAddress, '$.coordinate.longitude');

	-- IF OBJECT_ID('tempdb..#NearByServiceProviders') IS NOT NULL
	--     Truncate TABLE #NearByServiceProviders
	-- else
	--     CREATE TABLE #NearByServiceProviders
	--     (
	-- 		id int,
	-- 		categoryId int,
	-- 		onlineStatus BIT,
	-- 		fcmToken NVARCHAR(255),
	-- 		coverage INT,
	-- 		distance FLOAT
	--     )

	-- variables to store charge amount and other admin set values
	DECLARE @totalAmount INT;

	-- insert into quotemaster
	insert into quotemaster (customerId, [type], categoryId, deliveryAddress, createdAt)
	VALUES (@customerId, @type, @categoryId, @deliveryAddress, @createdAt);
	
	--then bulk insert into quoteDetail with the quoteMasterId
	SET @quoteMasterId = SCOPE_IDENTITY();

	INSERT into quoteDetail (productId, productName, json, quoteMasterId)
	  select json.productId, json.productName, json.json, @quoteMasterId as quoteMasterId
	  from openjson(@json, '$.detail')
	  with(
	    productId INT '$.productId',
	    productName nvarchar(100) '$.productName',
	    [json] NVARCHAR(MAX) AS JSON
	  )json

	-- store totalAmount to variable
	SELECT @totalAmount = InitialPaymentAmount from nxtServiceCategory WHERE CategoryId = @categoryId;

	 -- Find all service providers nearby to send them the quotations
	-- INSERT INTO #NearByServiceProviders
	-- 	exec spfindServiceProvidersNearby @custLat, @custLng, @categoryId; 

	-- INSERT INTO quotedServiceProviders (serviceProviderId, quoteMasterId )
	-- 	SELECT id as serviceProviderId, @quoteMasterId as quoteMasterId
	-- 	FROM #NearByServiceProviders
		
	-- SELECT fcmToken from #NearByServiceProviders
	-- WHERE fcmToken IS NOT NULL AND fcmToken <> ''
	-- UNION ALL
	-- SELECT adminTable.fcmToken
	-- FROM adminTable
	-- where adminTable.fcmToken IS NOT NULL and adminTable.fcmToken <> ''	;
	 SELECT @quoteMasterId as quoteId, @totalAmount as totalAmount;;
END

GO;
-------------------------------------------------------------
---------Bid this Quote----------------------------------------

CREATE PROCEDURE dbo.spBidQuoteFromCustomer
@quoteMasterId INT, 
@serviceProviderId INT,
@json NVARCHAR(MAX)
AS
BEGIN
	-- to store user fcmToken
	DECLARE @fcmToken NVARCHAR(255);
	DECLARE @createdAt datetimeoffset = GETUTCDATE();
	-- before bidding for this quote 
	-- we have to check if the quote has already been accepted or not
	DECLARE @flag INT;
	-- @flag stored the count of acceptance the quote got and it should be 0
	SELECT @flag = count(id) FROM quoteMaster
	WHERE id = @quoteMasterId 
	AND status = 'accepted';
	-- if the quote has not been accepted then we can bid
	IF @flag = 0
	BEGIN
		UPDATE
		    dbo.quotedServiceProviders
		SET
		    dbo.quotedServiceProviders.status = 'accepted'
		WHERE
		    dbo.quotedServiceProviders.quoteMasterId = @quoteMasterId
		AND 
		    dbo.quotedServiceProviders.serviceProviderId = @serviceProviderId
		
		-- insert bidding data into quotation biddings
		INSERT INTO quotationBiddings (serviceProviderId, quoteMasterId, json, createdAt )
		VALUES (@serviceProviderId, @quoteMasterId, @json, @createdAt);

		SELECT @fcmToken=fcmToken from customer
		where customer.id = (
			SELECT customerId from quoteMaster
			where id = @quoteMasterId
		);
	
		SELECT 0 as error, @fcmToken as fcmToken;
	END
	ELSE 
	BEGIN 
		-- if the quote has been accepted by some other service provider
		-- then send some message to indicate that
		SELECT 1 as error;
	END
END

GO;

------------------------------------------------------------------------
---------------------Accept the quote-----------------------------------
CREATE PROCEDURE dbo.spAcceptQuoteFromCustomer
@quoteMasterId INT, 
@serviceProviderId INT
AS
BEGIN
	--set quoteMaster.status to accepted
	--set quotedServiceProviders.status to accepted from this serviceProvider
	--and set others to rejected
	--this procedure is acted for packages and repairs where there is no biddings
	DECLARE @fcmToken NVARCHAR(255);

	UPDATE quoteMaster 
	SET 
		quoteMaster.status = 'accepted'
	WHERE id = @quoteMasterId
	
	UPDATE
	    dbo.quotedServiceProviders
	SET
	    dbo.quotedServiceProviders.status = CASE 
	    	WHEN dbo.quotedServiceProviders.serviceProviderId = @serviceProviderId
	    		THEN 'accepted'
	    	ELSE
	    		'rejected'
	    END
	WHERE
	    dbo.quotedServiceProviders.quoteMasterId = @quoteMasterId

	SELECT @fcmToken=fcmToken from customer
	where customer.id = (
		SELECT customerId from quoteMaster
		where id = @quoteMasterId
	);
	
	SELECT 1 as accepted, @fcmToken as fcmToken;	    
END
------------------------------------------------------------------------
--------------------Reject the quote-----------------------------------

CREATE PROCEDURE dbo.spRejectQuoteFromCustomer
@quoteMasterId INT, 
@serviceProviderId INT
AS
BEGIN
	-- to store user fcmToken
	DECLARE @fcmToken NVARCHAR(255);
	-- after rejecting this quote we have to check if all the
	-- service providers have rejected
	-- if so then this quote becomes rejected 
	DECLARE @rejections INT;
	DECLARE @totalBidders INT;
	-- @flag stored the count of acceptance the quote got and it should be 0
	
	UPDATE
	    dbo.quotedServiceProviders
	SET
	    dbo.quotedServiceProviders.status = 'rejected'
	WHERE
	    dbo.quotedServiceProviders.quoteMasterId = @quoteMasterId
	AND 
	    dbo.quotedServiceProviders.serviceProviderId = @serviceProviderId

	-- find the totalBidders and rejections
	
	SELECT @rejections = count(id) FROM quotedServiceProviders
	WHERE quoteMasterId = @quoteMasterId AND status = 'rejected';
	
	SELECT @totalBidders = count(id) FROM quotedServiceProviders
	WHERE quoteMasterId = @quoteMasterId;

	IF @totalBidders - @rejections = 0
	BEGIN

		UPDATE
			dbo.quoteMaster
		SET
			dbo.quoteMaster.status = 'rejected'
		WHERE
			dbo.quoteMaster.id = @quoteMasterId

		SELECT @fcmToken=fcmToken from customer
		where customer.id = (
			SELECT customerId from quoteMaster
			where id = @quoteMasterId
		);
		SELECT 1 as rejected, @fcmToken as fcmToken;
	END
	ELSE 
	BEGIN 
		-- if the quote has been rejected by few and still hope
		-- then indicate that
		SELECT 1 as rejected;
	END
END

GO;

------------------------------------------------------------------------
----------------Complete the quote from customer by serviceProvider-----
CREATE PROCEDURE dbo.spCompleteQuoteFromCustomer
@quoteMasterId INT, 
@serviceProviderId INT
AS
BEGIN
	--First the quoteMaster.status should be completed
	--then the quotedServiceProviders.status should be completed
	DECLARE @fcmToken NVARCHAR(255);
	UPDATE quoteMaster
	SET 
		quoteMaster.status = 'completed'
	WHERE quoteMaster.id = @quoteMasterId;
	
	UPDATE quotedServiceProviders 
	SET
		quotedServiceProviders.status = 'completed'
	WHERE 
		quotedServiceProviders.quoteMasterId = @quoteMasterId
	AND 
		quotedServiceProviders.serviceProviderId = @serviceProviderId;

	--fetch fcmToken from database to notify the customer
	SELECT @fcmToken=fcmToken from customer
		where customer.id = (
			SELECT customerId from quoteMaster
			where id = @quoteMasterId
		);	
	
	SELECT 1 as completed, @fcmToken as fcmToken;
END

------------------------------------------------------------------------
--------------------Accept the Bidding By Customer----------------------

CREATE PROCEDURE dbo.spAcceptBiddingFromServiceProvider
@quoteBiddingId INT, 
@serviceProviderId INT
AS
BEGIN
	-- accepting this bid will cancel all other bids
	DECLARE @quoteMasterId INT;
	--get quoteMasterId
	SELECT @quoteMasterId=quoteMasterId from quotationBiddings
	WHERE id = @quoteBiddingId;
	
	UPDATE quotationBiddings
	SET
		status = 'accepted'	
	WHERE id = @quoteBiddingId and serviceProviderId = @serviceProviderId;
	-- reject all other bids
	UPDATE quotationBiddings
	SET
		status = 'rejected'
	WHERE quoteMasterId = @quoteMasterId and serviceProviderId != @serviceProviderId;
	-- update quoteMaster for quote as accpeted
	UPDATE quoteMaster
	SET 
		status = 'accepted'
	WHERE id = @quoteMasterId
	-- notify the service provider indicating his quote has been accepted
	SELECT fcmToken from serviceProvider
	where id = @serviceProviderId;
	
END

GO;

------------------------------------------------------------------------------
------------Get Quotes irrespective of any particular serviceProviders -------

CREATE Procedure dbo.spGetAllServiceProviderQuotes
@status NVARCHAR(30),
@page INT,
@startDate datetimeoffset,
@endDate datetimeoffset
AS
BEGIN
	-- this procedure gives 15 orders belonging to shopId
	-- orders with status pending, accepted, rejected or all
	DECLARE @offset INT = 15 * (@page - 1);
	DECLARE @query NVARCHAR(MAX) = N'
			;with x(json) as (
				SELECT 
				quoteMaster.*,
				qS.serviceProviderId,
				qS.status as providerStatus,
				customer.name as customerName,
				customer.mobile as customerMobile,
				items = (
					select * from quoteDetail
					where quoteMasterId = quoteMaster.id
					FOR JSON PATH, INCLUDE_NULL_VALUES
				),
				providerBids = (
					select * from quotationBiddings
					where quoteMasterId = quoteMaster.id
					and serviceProviderId = qS.serviceProviderId
					FOR JSON PATH, INCLUDE_NULL_VALUES
				)
				from quoteMaster
				INNER JOIN customer on customer.id = quoteMaster.customerId
				INNER JOIN quotedServiceProviders qS on 
					qS.quoteMasterId = quoteMaster.id 
				where qS.serviceProviderId > 0
	';
	
	IF (@startDate is not NULL and @endDate is not NULL)
	BEGIN
		SET @query = @query + '
			and ( quoteMaster.createdAt >= @startDate and quoteMaster.createdAt <= @endDate)
		';
	END
	IF (@status <> 'all')
	BEGIN
		SET @query = @query + '
				and quoteMaster.status = @status
		';
	END
	-- finally query execution
	SET @query = @query + '
		ORDER BY qS.id DESC
		OFFSET @offset ROWS 
		FETCH FIRST 15 ROWS ONLY	
		FOR JSON PATH, INCLUDE_NULL_VALUES
		)
		SELECT json as [json] from x;
	';
	EXEC sp_executeSql 
		@query, 
		N'@status NVARCHAR(30), @startDate datetimeoffset, @endDate datetimeoffset, @offset INT',
		@status, @startDate, @endDate, @offset
	;
--	SELECT @query ;
END

Go;
------------------------------------------------------------------------------
------------Get Quotes for serviceProviders belonging to any of 4 criteria----

CREATE Procedure dbo.spGetServiceProviderQuotes
@serviceProviderId INT,
@status NVARCHAR(30),
@page INT,
@startDate datetimeoffset,
@endDate datetimeoffset
AS
BEGIN

	Declare @baseUrl varchar(200);
	--get baseUrl as local variable
	Select @baseUrl=baseUrl from appConfig;	
	-- this procedure gives 15 orders belonging to shopId
	-- orders with status pending, accepted, rejected or all
	DECLARE @offset INT = 15 * (@page - 1);
	DECLARE @query NVARCHAR(MAX) = N'
			;with x(json) as (
				SELECT 
				quoteMaster.*,
				qS.serviceProviderId,
				qS.status as providerStatus,
				customer.name as customerName,
				customer.mobile as customerMobile,
				billImage = (
					SELECT CONCAT(@baseUrl ,nbd.image) as [Image] from nxtBillDetails nbd
					where nbd.quoteId = quoteMaster.id
				),
				items = (
					select * from quoteDetail
					where quoteMasterId = quoteMaster.id
					FOR JSON PATH, INCLUDE_NULL_VALUES
				),
				providerBids = (
					select * from quotationBiddings
					where quoteMasterId = quoteMaster.id
					and serviceProviderId = @serviceProviderId
					FOR JSON PATH, INCLUDE_NULL_VALUES
				)
				from quoteMaster
				INNER JOIN customer on customer.id = quoteMaster.customerId
				INNER JOIN quotedServiceProviders qS on 
					qS.quoteMasterId = quoteMaster.id 
				where qS.serviceProviderId = @serviceProviderId
	';
	
	IF (@startDate is not NULL and @endDate is not NULL)
	BEGIN
		SET @query = @query + '
			and ( quoteMaster.createdAt >= @startDate and quoteMaster.createdAt <= @endDate)
		';
	END
	IF (@status <> 'all')
	BEGIN
		SET @query = @query + '
				and quoteMaster.status = @status
		';
	END
	-- finally query execution
	SET @query = @query + '
		ORDER BY qS.id DESC
		OFFSET @offset ROWS 
		FETCH FIRST 15 ROWS ONLY	
		FOR JSON PATH, INCLUDE_NULL_VALUES
		)
		SELECT json as [json] from x;
	';
	EXEC sp_executeSql 
		@query, 
		N'@serviceProviderId INT, 
		@status NVARCHAR(30), 
		@startDate datetimeoffset, 
		@endDate datetimeoffset, 
		@offset INT, 
		@baseUrl NVARCHAR(200)',
		@serviceProviderId, @status, @startDate, @endDate, @offset, @baseUrl
	;
--	SELECT @query ;
END

------------------------------------------------------------------------------
------------Get Quotes for customer ------------------------------------------

CREATE Procedure dbo.spGetCustomerQuotes
@customerId INT,
@page INT,
@startDate datetimeoffset,
@endDate datetimeoffset
AS
BEGIN

	Declare @baseUrl varchar(200);
	--get baseUrl as local variable
	Select @baseUrl=baseUrl from appConfig;	
	-- this procedure gives 15 quotes belonging to customerId
	DECLARE @offset INT = 15 * (@page - 1);
	DECLARE @status NVARCHAR(30) = N'completed';
	DECLARE @query NVARCHAR(MAX) = N'
			;with x(json) as (
				SELECT 
				quoteMaster.*,
				sP.name as serviceProviderName,
				billImage = (
					SELECT CONCAT(@baseUrl ,nbd.image) as [Image] from nxtBillDetails nbd
					where nbd.quoteId = quoteMaster.id
				),				
				items = (
					select * from quoteDetail
					where quoteMasterId = quoteMaster.id
					FOR JSON PATH, INCLUDE_NULL_VALUES
				)
				from quoteMaster
				INNER JOIN quotedServiceProviders qS on 
					qS.quoteMasterId = quoteMaster.id
					and qS.status = @status
				INNER JOIN serviceProvider sP on
					sP.id = qS.serviceProviderId
				where quoteMaster.customerId = @customerId
				and quoteMaster.status = @status
	';
	
	IF (@startDate is not NULL and @endDate is not NULL)
	BEGIN
		SET @query = @query + '
			and ( quoteMaster.createdAt >= @startDate and quoteMaster.createdAt <= @endDate)
		';
	END
	-- finally query execution
	SET @query = @query + '
		ORDER BY quoteMaster.id DESC
		OFFSET @offset ROWS 
		FETCH FIRST 15 ROWS ONLY	
		FOR JSON PATH, INCLUDE_NULL_VALUES
		)
		SELECT json as [json] from x;
	';
	EXEC sp_executeSql 
		@query, 
		N'@customerId INT, @status NVARCHAR(30), 
		  @startDate datetimeoffset, @endDate datetimeoffset, 
		  @offset INT,
		  @baseUrl NVARCHAR(200)
		',
		@customerId, @status, @startDate, @endDate, @offset, @baseUrl
	;
END