-- nxtServiceCategory > nxtServiceItem > nxtPackage || nxtRepairItems
-- All the procedures listed here is for create, update, delete of data

CREATE PROCEDURE dbo.spGetServiceProvidersWithFilter
@json NVARCHAR(MAX),
@page INT
AS
BEGIN
	-- this procedure gives 15 service providers abiding by certain search queries
	DECLARE @offset INT = 15 * (@page - 1);	
	DECLARE @onlineStatus INT = JSON_VALUE(@json, '$.onlineStatus');
	DECLARE @providerName VARCHAR(100) = JSON_VALUE(@json, '$.providerName');
	DECLARE @merchantId VARCHAR(40)  = JSON_VALUE(@json, '$.merchantId');

	DECLARE @query NVARCHAR(MAX) = N'
		SELECT 
		serviceProvider.id,
		serviceProvider.name,
		serviceProvider.categoryId,
		nxtServiceCategory.CategoryName as categoryName,
		serviceProvider.name,
		serviceProvider.onlineStatus,
		serviceProvider.coverage,
		serviceProvider.rating
		FROM serviceProvider
		INNER JOIN merchant on serviceProvider.merchantId = merchant.id
		INNER JOIN nxtServiceCategory on serviceProvider.categoryId = nxtServiceCategory.CategoryId
		WHERE
		1 = 1
	';
	IF @onlineStatus IS NOT NULL
	BEGIN
		SET @query = @query + N'
			and serviceProvider.onlineStatus = @onlineStatus
		';
	END
	IF @providerName IS NOT NULL
	BEGIN
		SET @query = @query + N'
			and serviceProvider.name = @providerName 
		';
	END
	IF @merchantId IS NOT NULL
	BEGIN
		SET @query = @query + N'
			and merchant.email = @merchantId 
		';
	END	
	-- final modification to query for limiting output size
	SET @query = @query + N'
				ORDER BY id
				OFFSET @offset ROWS FETCH NEXT 15 ROWS ONLY
	';
	-- Finally execute the query
	EXEC sp_executeSql 
		@query, 
		N'@onlineStatus int, @providerName varchar(100), 
		  @merchantId VARCHAR(40), @offset INT
		',
		@onlineStatus, @providerName, @merchantId, @offset
	;
END

GO;

-- Add a serviceProvider to a merchantId
CREATE PROCEDURE dbo.spAddServiceToMerchant
@json NVARCHAR(max)
AS
BEGIN

	DECLARE @serviceProviderId int;

	INSERT INTO serviceProvider (name, categoryId, coverage, merchantId )
		select json.name, json.categoryId, json.coverage, json.merchantId 
		from openjson(@json, '$.detail')
		with(
			name nvarchar(100) '$.name',
			categoryId int '$.categoryId',
			coverage int '$.coverage',
			merchantId int '$.merchantId'
		)json
	
	SET @serviceProviderId = SCOPE_IDENTITY();
	
	INSERT INTO serviceProviderAddress (pickupAddress, latitude, longitude, serviceProviderId )
		select json.pickupAddress, json.latitude, json.longitude, @serviceProviderId as serviceProviderId
		from openjson(@json, '$.address')
		with(
			pickupAddress nvarchar(255) '$.pickupAddress', 
			latitude float '$.latitude', 
			longitude float '$.longitude'
		)json
	
	SELECT @serviceProviderId as serviceProviderId;
	RETURN;
END

GO;

