-- nxtServiceCategory > nxtServiceItem > nxtPackage || nxtRepairItems
-- All the procedures listed here is for create, update, delete of data

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

-- Add a serviceProvider to a merchantId
-- CREATE PROCEDURE dbo.spAddServiceToMerchant
-- @json NVARCHAR(max)
-- AS
-- BEGIN
-- END