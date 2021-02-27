----------------Procedure to create payment -------------
/**
    the params for following procedure is JSON with following attributes 
    {
        "orderType" : 'order' / 'service',
        "orderQuoteId": Id of order or quote
        "totalAmount" : ??,
        "paymentMethod" : ??
        "razorpay_payment_id" : ??
        "razorpay_order_id" : ?? 
        "razorpay_signature" : ??
    }
**/
CREATE PROCEDURE dbo.spCreateNewPayment
@json NVARCHAR(MAX)
AS
BEGIN
	DECLARE @createdAt datetimeoffset = GETUTCDATE();
    DECLARE @orderType NVARCHAR(30) = JSON_VALUE(@json, '$.orderType');
    DECLARE @orderQuoteId int = JSON_VALUE(@json, '$.orderQuoteId');
    DECLARE @totalAmount int = JSON_VALUE(@json, '$.totalAmount');    
    DECLARE @paymentMethod NVARCHAR(30) = JSON_VALUE(@json, '$.paymentMethod');
    DECLARE @razorpay_payment_id NVARCHAR(100) = JSON_VALUE(@json, '$.razorpay_payment_id');
    DECLARE @razorpay_order_id NVARCHAR(100) = JSON_VALUE(@json, '$.razorpay_order_id');
    DECLARE @razorpay_signature NVARCHAR(255) = JSON_VALUE(@json, '$.razorpay_signature');
    DECLARE @remarks NVARCHAR(255) = 'Paid ' + CAST(@totalAmount as VARCHAR);
    -- After successful creation of payment we have to notify concerned parties
    DECLARE @fcmToken NVARCHAR(MAX);   
    -- depending on the orderType either order or service we store the details in that field
    DECLARE @orderId INT;
   	DECLARE @quoteId INT;
    IF @orderType = 'order'
    BEGIN
	    SET @remarks += ' for order with orderMasterId ' + CAST(@orderQuoteId as VARCHAR);
	   	SET @orderId = @orderQuoteId;
        
        -- we also neet to change the status of orderMaster to pending from unpaid
        UPDATE orderMaster SET [status] = N'pending' WHERE id = @orderId;

        -- store all required fcmTokens in @fcmToken
        select @fcmToken = (
            SELECT fcmToken FROM (
                SELECT fcmToken
                FROM adminTable
                where adminTable.fcmToken IS NOT NULL and adminTable.fcmToken <> ''	
                UNION ALL			
                select fcmToken 
                from shop
                where id = (
                	SELECT shopId from orderMaster
                	where id = @orderId
                )
                and shop.fcmToken IS NOT NULL and shop.fcmToken <> ''
            )A
            FOR JSON PATH
	    );        
    END
    ELSE
    BEGIN
        ------------ SERVICE SECTION ----------------
	    SET @remarks += ' for service with quoteMasterId ' + CAST(@orderQuoteId as VARCHAR);
	   	SET @quoteId = @orderQuoteId;

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

        DECLARE @categoryId INT;
		DECLARE @deliveryAddress NVARCHAR(MAX);
		
		SELECT
		@categoryId = categoryId,
		@deliveryAddress = deliveryAddress
		from quoteMaster where id = @quoteId;
		
		DECLARE @custLat FLOAT = JSON_VALUE(@deliveryAddress, '$.coordinate.latitude');
		DECLARE @custLng FLOAT = JSON_VALUE(@deliveryAddress, '$.coordinate.longitude');
            

        INSERT INTO #NearByServiceProviders
            exec spfindServiceProvidersNearby @custLat, @custLng, @categoryId; 

        INSERT INTO quotedServiceProviders (serviceProviderId, quoteMasterId )
            SELECT id as serviceProviderId, @quoteId as quoteMasterId
            FROM #NearByServiceProviders

		-- store all required fcmTokens in @fcmToken
		SELECT @fcmToken=( 
			SELECT fcmToken from
			(
                SELECT fcmToken from #NearByServiceProviders
                WHERE fcmToken IS NOT NULL AND fcmToken <> ''
                UNION ALL
                SELECT adminTable.fcmToken
                FROM adminTable
                where adminTable.fcmToken IS NOT NULL and adminTable.fcmToken <> ''
			)A
			FOR JSON PATH
		)
    END
    
    --- Till now we have fcmTokens, remarks and proper fields for payments Table
    -- Insert into payments table
    INSERT into payments 
    (orderId, quoteId, totalAmount, paymentMethod, razorpay_payment_id, razorpay_order_id, razorpay_signature, remarks, createdAt)
    VALUES
	(@orderId, @quoteId, @totalAmount, @paymentMethod, @razorpay_payment_id, @razorpay_order_id, @razorpay_signature, @remarks, @createdAt);

	SELECT @fcmToken as fcmToken;
END