
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

	IF OBJECT_ID('tempdb..#NearByServiceProviders') IS NOT NULL
	    Truncate TABLE #NearByServiceProviders
	else
	    CREATE TABLE #NearByServiceProviders
	    (
			id int,
			categoryId int,
			onlineStatus BIT,
			fcmToken NVARCHAR(255),
			coverage INT,
			distance FLOAT
	    )
	    
	-- insert into quotemaster
	
	insert into quotemaster (customerId, [type], deliveryAddress, createdAt)
	VALUES (@customerId, @type, @deliveryAddress, @createdAt);
	
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

	 -- Find all service providers nearby to send them the quotations
	INSERT INTO #NearByServiceProviders
		exec spfindServiceProvidersNearby @custLat, @custLng, @categoryId; 
	
	INSERT INTO quotedServiceProviders (serviceProviderId, quoteMasterId )
		SELECT id as serviceProviderId, @quoteMasterId as quoteMasterId
		FROM #NearByServiceProviders
		
	SELECT fcmToken from #NearByServiceProviders;
	 
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

-------------------------------------------------------------------
------------Get Quotes for serviceProviders belonging to any of 4 criteria----

CREATE Procedure dbo.spGetServiceProviderQuotes
@serviceProviderId INT,
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
				customer.name as customerName,
				customer.mobile as customerMobile,
				items = (
					select * from quoteDetail
					where quoteMasterId = quoteMaster.id
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
		FOR JSON PATH, INCLUDE_NULL_VALUES
		)
		SELECT json as [json] from x;
	';
	EXEC sp_executeSql 
		@query, 
		N'@serviceProviderId INT, @status NVARCHAR(30), @startDate datetimeoffset, @endDate datetimeoffset, @offset INT',
		@serviceProviderId, @status, @startDate, @endDate, @offset
	;
--	SELECT @query ;
END