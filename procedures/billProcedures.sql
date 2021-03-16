--------------------------------------------------------------------
--------------------Add new Bill in nxtBillDetails----------------

CREATE PROCEDURE dbo.spInsertBillInNxtBillDetails
@json NVARCHAR(max)
AS
BEGIN
    
    DECLARE @createdAt datetimeoffset = GETUTCDATE();
	DECLARE @merchantId int = JSON_VALUE(@json, '$.merchantId');
	DECLARE @orderId int = JSON_VALUE(@json, '$.orderId');
	DECLARE @quoteId int = JSON_VALUE(@json, '$.quoteId');
	DECLARE @image NVARCHAR(180) = JSON_VALUE(@json, '$.image');

	DECLARE @isAlreadyAdded INT = 0;
	-- check if the merchant has already added a bill for same order or quote
	SELECT @isAlreadyAdded = id FROM nxtBillDetails 
	WHERE 
		merchantId = @merchantId and
		orderId = @orderId OR
		quoteId = @quoteId;

	IF @isAlreadyAdded = 0
	BEGIN
		INSERT into nxtBillDetails (
			merchantId,
			orderId, 
			[quoteId], 
			[image], 
			createdAt
		) VALUES (
			@merchantId,
			@orderId, 
			@quoteId, 
			@image, 
			@createdAt			
		)
	END
END

---------------------------------------------------------------
----------------Retrieve bill details depending on criteria----

CREATE PROCEDURE dbo.spRetrieveBillDetails
@merchantId INT,
@type NVARCHAR(30) = NULL,
@orderQuoteId INT = NULL
AS
BEGIN
	-- we can Retrieve bill details using following criterias
	-- 1. Using quote or orderId
	-- 2. Using merchant id
	Declare @baseUrl varchar(200);
	--get baseUrl as local variable
	Select @baseUrl=baseUrl from appConfig;		
	DECLARE @offset INT = 0;
	DECLARE @query NVARCHAR(MAX) = N'
			;with x(json) as (
				SELECT 
				nxtBillDetails.id,
				nxtBillDetails.merchantId,
				nxtBillDetails.orderId,
				nxtBillDetails.quoteId,				
				COALESCE(@baseUrl + nxtBillDetails.image, null) as [image]
				FROM nxtBillDetails
				WHERE nxtBillDetails.id > 0
	';

	IF (@merchantId is not NULL)
	BEGIN
		SET @query = @query + '
			and ( merchantId = @merchantId)
		';
	END	

	IF (@type is not NULL)
	BEGIN
		IF (@type = 'order')
		BEGIN
			SET @query = @query + '
				and ( orderId = @orderQuoteId)
			';
		END
		ELSE
		BEGIN
			SET @query = @query + '
				and ( quoteId = @orderQuoteId)
			';	
		END	
	END
	-- finally query execution
	SET @query = @query + '
		ORDER BY nxtBillDetails.id DESC
		OFFSET @offset ROWS 
		FETCH FIRST 20 ROWS ONLY
		FOR JSON PATH, INCLUDE_NULL_VALUES
		)
		SELECT json as [json] from x;
	';
	EXEC sp_executeSql 
		@query, 
		N'@merchantId INT, @orderQuoteId INT, @offset INT, @baseUrl NVARCHAR(180)',
		@merchantId, @orderQuoteId, @offset, @baseUrl
	;
		
END