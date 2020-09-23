-- nxtServiceCategory > nxtServiceItem > nxtPackage || nxtRepairItems
-- All the procedures listed here is for retrieval of data

----------Get all service providers nearby-------------
-------------------------------------------------------

CREATE PROCEDURE dbo.spfindServiceProvidersNearby
@custLat FLOAT,
@custLng FLOAT,
@categoryId INT
AS
BEGIN
	DECLARE @id INT;
	DECLARE @onlineStatus bit;
	DECLARE @fcmToken NVARCHAR(255);
	DECLARE @coverage INT;
	DECLARE @shopCategoryId INT;

	DECLARE @distance FLOAT;
	DECLARE @serviceProviderTable table (
		id INT,
		categoryId INT,
		onlineStatus bit,
		fcmToken NVARCHAR(255),
		coverage INT,
		distance FLOAT
	);

	IF @categoryId IS NULL
	BEGIN
		DECLARE shopCursor CURSOR 
		FOR				
			SELECT id, categoryId, onlineStatus, fcmToken, coverage FROM serviceProvider
	END
	ELSE
	BEGIN
		DECLARE shopCursor CURSOR 
		FOR				
			SELECT id, categoryId, onlineStatus, fcmToken, coverage FROM serviceProvider
			WHERE categoryId = @categoryId
	END
		
	Open shopCursor
		Fetch next from shopCursor into @id, @shopCategoryId, @onlineStatus, @fcmToken, @coverage;
		WHILE @@FETCH_STATUS = 0
		begin
			
			--find distance between shop and customer
			SELECT @distance = geography::Point(@custLat, @custLng, 4326).STDistance(
				geography::Point(latitude, longitude, 4326)
			) from serviceProviderAddress
			where serviceProviderAddress.serviceProviderId = @id;
			-- convert meters to KMs
			SET @distance = ROUND(@distance/1000, 2);
			--check if distance is less than the coverage of shop
			If(@distance <= @coverage)
			begin
				--if user is within coverage distance add shop to output table
				INSERT INTO @serviceProviderTable(id, categoryId, onlineStatus, fcmToken, 
					coverage, distance) 
				values (@id, @shopCategoryId, @onlineStatus, @fcmToken, @coverage, @distance);
			end
			
			Fetch next from shopCursor into @id, @shopCategoryId, @onlineStatus, @fcmToken, @coverage;
		end
		
	Close shopCursor
	Deallocate shopCursor
	--output all found shops
	select * from @serviceProviderTable
END

GO;

--------Get all services-----------------------------

CREATE PROCEDURE dbo.spGetAllServices
AS
BEGIN
	SELECT * FROM nxtServiceCategory;
END

GO;

--------Get all services Near the User-----------------------------
-------------------------------------------------------------------

CREATE PROCEDURE dbo.spGetAllServicesNearUser
@custLat FLOAT,
@custLng FLOAT
AS
BEGIN
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
	
	INSERT INTO #NearByServiceProviders
		exec spfindServiceProvidersNearby @custLat, @custLng, NULL;
	
	SELECT * from nxtServiceCategory
	where nxtServiceCategory.CategoryId in (
		SELECT DISTINCT categoryId from  #NearByServiceProviders
	);
	
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
@repairItemId int
AS
BEGIN
	-- first we have to check if its twowheeler or other
	DECLARE @categoryItemName [VARCHAR](50);

	SELECT @categoryItemName = CategoryItemName From nxtServiceItem 
	where CategoryItemId = (Select CategoryItemId from nxtRepairItems where RepairItemId = @repairItemId);

	If @categoryItemName = 'Two Wheeler'
	BEGIN
		with x(json) as
		(
			SELECT 
				spairPartsRate = (
					SELECT
					SparePartName,
					convert(numeric(38,0),cast(Moped_Min AS float)) as moped_Min,
					convert(numeric(38,0),cast(Moped_Max AS float)) as moped_Max,
					convert(numeric(38,0),cast(CC_150_180_Min AS float)) as below_180_cc_min,
					convert(numeric(38,0),cast(CC_150_180_Max AS float)) as below_180_cc_max,
					convert(numeric(38,0),cast(CC_Above_180_Min AS float)) as above_180_cc_min,
					convert(numeric(38,0),cast(CC_150_180_Max AS float)) as above_180_cc_max,
					convert(numeric(38,0),cast(Bullet_Min AS float)) as bullet_min,
					convert(numeric(38,0),cast(Bullet_Max AS float)) as bullet_max,
					Active 
					FROM TwoWheelerSparePartRate
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
	ELSE
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
END