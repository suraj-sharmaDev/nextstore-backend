-- nxtServiceCategory > nxtServiceItem > nxtPackage || nxtRepairItems

--Add a serviceProvider to a merchantId
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
--------Get all services-----------------------------

CREATE PROCEDURE dbo.spGetAllServices
AS
BEGIN
	SELECT * FROM nxtServiceCategory;
END

GO;

----------Get all service Item for belonging to service Category
CREATE PROCEDURE dbo.spGetAllServicesForCategory
@categoryId INT
AS
BEGIN
	SELECT * FROM nxtServiceItem
	where CategoryId = @categoryId;
END

GO;

-- Get packages and repair items belonging to serviceItem

CREATE PROCEDURE dbo.spGetAllDetailsInService
@categoryItemId int
AS
BEGIN
	with x(json) as
	(
		SELECT 
			repairItems = (
				SELECT * FROM nxtRepairItems
				where CategoryItemId = @categoryItemId
				FOR JSON PATH, INCLUDE_NULL_VALUES	
			),
			packages = (
				SELECT * FROM nxtPackage np 
				where CategoryItemId = @categoryItemId
				FOR JSON PATH, INCLUDE_NULL_VALUES					
			)
		For JSON PATH, INCLUDE_NULL_VALUES, WITHOUT_ARRAY_WRAPPER				
	)
	select json from x;
END

GO;

---Get Package Item rate
CREATE PROCEDURE dbo.spGetPackageItemRate
@packageId int
AS
BEGIN
	SELECT * from nxtPackageItemRate
	where PackageId = @packageId
END

GO;

---Get Repair Service Charge and Parts Rate

CREATE PROCEDURE dbo.spGetRepairPartsServiceCharge
AS
BEGIN
	with x(json) as
	(
		SELECT 
			repairPartsRate = (
				SELECT
				RepairPartsRate_Id,
				RepairPartName,
				convert(numeric(38,0),cast(Min_Rate AS float)) as Min_Rate,				
				convert(numeric(38,0),cast(Max_Rate AS float)) as Max_Rate,
				Active 
				FROM RepairPartsRate
				where RepairItemID = @repairItemId
				FOR JSON PATH, INCLUDE_NULL_VALUES	
			),
			repairServiceCharge = (
				SELECT
				RepairItemsAndRate_Id,
				RepairItemsPart,
				convert(numeric(38,0),cast(Rate AS float)) as Rate,
				convert(numeric(38,0),cast(OfferRate AS float)) as OfferRate,
				Active,
				convert(numeric(38,0),cast(Min_Rate AS float)) as Min_Rate,
				convert(numeric(38,0),cast(Min_OfferRate AS float)) as Min_OfferRate				
				FROM nxtRepairServiceCharge
				where RepairItemID = @repairItemId
				FOR JSON PATH, INCLUDE_NULL_VALUES					
			)
		For JSON PATH, INCLUDE_NULL_VALUES, WITHOUT_ARRAY_WRAPPER				
	)
	select json from x;
END