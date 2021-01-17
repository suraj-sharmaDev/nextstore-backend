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
@custLng FLOAT,
@categoryId INT = NULL
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
		exec spfindServiceProvidersNearby @custLat, @custLng, @categoryId;
	
	SELECT * from nxtServiceCategory
	where nxtServiceCategory.CategoryId in (
		SELECT DISTINCT categoryId from  #NearByServiceProviders
		where Active = 1
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
			symptoms = (
				SELECT * FROM nxtServiceItemSymptoms
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


--------------------------------------------------------------------------------------------
-----------------------Add or update service Item-------------------------------------------
CREATE PROCEDURE dbo.spAddUpdateServiceItem
@json NVARCHAR(max),
@serviceItemId INT
AS
BEGIN
	DECLARE @message varchar(40);
	IF OBJECT_ID('tempdb..#ServiceItemDetailTemp') IS NOT NULL
	DROP TABLE #ServiceItemDetailTemp;
	-- add the json data to tempTable
    select 
        json.CategoryItemName, json.CategoryId,
        json.[Description], json.Active, 
        json.[Type]
    INTO #ServiceItemDetailTemp FROM OPENJSON(@json)
        with (
            CategoryItemName varchar(50) '$.CategoryItemName', 
            CategoryId int '$.CategoryId',
            [Description] [varchar](500) '$.Description',
            Active int '$.Active',
            [Type] [varchar](30) '$.Type'
        )json
	-- if serviceItemId is null then the procedure will add the serviceItem
	-- else it will update the existing serviceItem
	If @serviceItemId IS NULL
	BEGIN
		INSERT INTO nxtServiceItem(CategoryItemName, CategoryId, [Description], Active, [Type])
		SELECT
		CategoryItemName, 
		CategoryId, 
		[Description], 
		COALESCE(Active, 1) AS Active, 
		[Type]
		FROM #ServiceItemDetailTemp;
		SET @message = 'service item inserted';
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT CategoryItemId from nxtServiceItem where CategoryItemId=@serviceItemId)
		BEGIN
			UPDATE nxtServiceItem
			SET 
				nxtServiceItem.CategoryItemName = CASE
				WHEN #ServiceItemDetailTemp.CategoryItemName IS NOT NULL THEN #ServiceItemDetailTemp.CategoryItemName
				ELSE nxtServiceItem.CategoryItemName
				END,
				nxtServiceItem.CategoryId = CASE
				WHEN #ServiceItemDetailTemp.CategoryId IS NOT NULL THEN #ServiceItemDetailTemp.CategoryId
				ELSE nxtServiceItem.CategoryId
				END,
				nxtServiceItem.Description = CASE
				WHEN #ServiceItemDetailTemp.Description IS NOT NULL THEN #ServiceItemDetailTemp.Description
				ELSE nxtServiceItem.Description
				END,
				nxtServiceItem.Active = CASE
				WHEN #ServiceItemDetailTemp.Active IS NOT NULL THEN #ServiceItemDetailTemp.Active
				ELSE nxtServiceItem.Active
				END,
				nxtServiceItem.Type = CASE
				WHEN #ServiceItemDetailTemp.Type IS NOT NULL THEN #ServiceItemDetailTemp.Type
				ELSE nxtServiceItem.Type
				END						
			FROM nxtServiceItem, #ServiceItemDetailTemp 
			WHERE nxtServiceItem.CategoryItemId = @serviceItemId;
			SET @message = 'service item updated';
		END
		ELSE
		BEGIN
			SET @message = 'Given serviceItem Id doesnt exist';
		END	
	END

	SELECT @message as message;
END


--------------------------------------------------------------------------------------------
-----------------------Add or update service Packages---------------------------------------
CREATE PROCEDURE dbo.spAddUpdateServicePackage
@json NVARCHAR(max),
@packageId INT
AS
BEGIN
	DECLARE @message varchar(40);
	IF OBJECT_ID('tempdb..#ServicePackageDetailTemp') IS NOT NULL
	DROP TABLE #ServicePackageDetailTemp;
	-- add the json data to tempTable
    select 
        json.PackageName, json.CategoryItemId,
        json.[Description], json.Active
    INTO #ServicePackageDetailTemp FROM OPENJSON(@json)
        with (
            PackageName varchar(50) '$.PackageName', 
            CategoryItemId int '$.CategoryItemId',
            [Description] [varchar](500) '$.Description',
            Active int '$.Active'
        )json
	-- if packageId is null then the procedure will add the serviceItem
	-- else it will update the existing serviceItem
	If @packageId IS NULL
	BEGIN
		INSERT INTO nxtPackage(PackageName, CategoryItemId, [Description], Active)
		SELECT
		PackageName, 
		CategoryItemId, 
		[Description], 
		COALESCE(Active, 1) AS Active
		FROM #ServicePackageDetailTemp;
		SET @message = 'Package inserted';
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT PackageId from nxtPackage where PackageId=@packageId)
		BEGIN
			UPDATE nxtPackage
			SET 
				nxtPackage.PackageName = CASE
				WHEN #ServicePackageDetailTemp.PackageName IS NOT NULL THEN #ServicePackageDetailTemp.PackageName
				ELSE nxtPackage.PackageName
				END,
				nxtPackage.CategoryItemId = CASE
				WHEN #ServicePackageDetailTemp.CategoryItemId IS NOT NULL THEN #ServicePackageDetailTemp.CategoryItemId
				ELSE nxtPackage.CategoryItemId
				END,
				nxtPackage.Description = CASE
				WHEN #ServicePackageDetailTemp.Description IS NOT NULL THEN #ServicePackageDetailTemp.Description
				ELSE nxtPackage.Description
				END,
				nxtPackage.Active = CASE
				WHEN #ServicePackageDetailTemp.Active IS NOT NULL THEN #ServicePackageDetailTemp.Active
				ELSE nxtPackage.Active
				END
			FROM nxtPackage, #ServicePackageDetailTemp 
			WHERE nxtPackage.PackageId = @packageId;
			SET @message = 'Package updated';
		END
		ELSE
		BEGIN
			SET @message = 'Given Package Id doesnt exist';
		END	
	END

	SELECT @message as message;
END


--------------------------------------------------------------------------------------------
-----------------------Add or update service PackageItems-----------------------------------
CREATE PROCEDURE dbo.spAddUpdateServicePackageItem
@json NVARCHAR(max),
@packageItemId INT
AS
BEGIN
	DECLARE @message varchar(40);
	IF OBJECT_ID('tempdb..#ServicePackageItemDetailTemp') IS NOT NULL
	DROP TABLE #ServicePackageItemDetailTemp;
	-- add the json data to tempTable
    select 
        json.PackageItemName, json.PackageId,
        json.[Description], json.Active, json.Rate, json.OfferRate
    INTO #ServicePackageItemDetailTemp FROM OPENJSON(@json)
        with (
            PackageItemName varchar(50) '$.PackageItemName', 
            PackageId int '$.PackageId',
            [Description] [varchar](500) '$.Description',
            Active int '$.Active',
			Rate float '$.Rate',
			OfferRate float '$.OfferRate'			
        )json
	-- if packageItemId is null then the procedure will add the serviceItem
	-- else it will update the existing serviceItem
	If @packageItemId IS NULL
	BEGIN
		INSERT INTO nxtPackageItemRate(PackageItemName, PackageId, [Description], Active, Rate, OfferRate)
		SELECT
		PackageItemName, 
		PackageId, 
		[Description], 
		COALESCE(Active, 1) AS Active,
		Rate, 
		OfferRate
		FROM #ServicePackageItemDetailTemp;
		SET @message = 'Package Item inserted';
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT PackageItemsId from nxtPackageItemRate where PackageItemsId=@packageItemId)
		BEGIN
			UPDATE nxtPackageItemRate
			SET 
				nxtPackageItemRate.PackageItemName = CASE
				WHEN #ServicePackageItemDetailTemp.PackageItemName IS NOT NULL THEN #ServicePackageItemDetailTemp.PackageItemName
				ELSE nxtPackageItemRate.PackageItemName
				END,
				nxtPackageItemRate.PackageId = CASE
				WHEN #ServicePackageItemDetailTemp.PackageId IS NOT NULL THEN #ServicePackageItemDetailTemp.PackageId
				ELSE nxtPackageItemRate.PackageId
				END,
				nxtPackageItemRate.Description = CASE
				WHEN #ServicePackageItemDetailTemp.Description IS NOT NULL THEN #ServicePackageItemDetailTemp.Description
				ELSE nxtPackageItemRate.Description
				END,
				nxtPackageItemRate.Active = CASE
				WHEN #ServicePackageItemDetailTemp.Active IS NOT NULL THEN #ServicePackageItemDetailTemp.Active
				ELSE nxtPackageItemRate.Active
				END,
				nxtPackageItemRate.Rate = CASE
				WHEN #ServicePackageItemDetailTemp.Rate IS NOT NULL THEN #ServicePackageItemDetailTemp.Rate
				ELSE nxtPackageItemRate.Rate
				END,
				nxtPackageItemRate.OfferRate = CASE
				WHEN #ServicePackageItemDetailTemp.OfferRate IS NOT NULL THEN #ServicePackageItemDetailTemp.OfferRate
				ELSE nxtPackageItemRate.OfferRate
				END								
			FROM nxtPackageItemRate, #ServicePackageItemDetailTemp 
			WHERE nxtPackageItemRate.PackageItemsId = @packageItemId;
			SET @message = 'Package Item updated';
		END
		ELSE
		BEGIN
			SET @message = 'Given Package Item Id doesnt exist';
		END	
	END

	SELECT @message as message;
END


--------------------------------------------------------------------------------------------
-----------------------Add or update service RepairItems-----------------------------------

CREATE PROCEDURE dbo.spAddUpdateServiceRepairItem
@json NVARCHAR(max),
@RepairItemId INT
AS
BEGIN
	DECLARE @message varchar(40);
	IF OBJECT_ID('tempdb..#ServiceRepairItemDetailTemp') IS NOT NULL
	DROP TABLE #ServiceRepairItemDetailTemp;
	-- add the json data to tempTable
    select 
        json.RepairItems, json.CategoryItemId,
        json.Active
    INTO #ServiceRepairItemDetailTemp FROM OPENJSON(@json)
        with (
            RepairItems varchar(50) '$.RepairItems', 
            CategoryItemId int '$.CategoryItemId',
            Active int '$.Active'
        )json
	-- if RepairItemId is null then the procedure will add the serviceItem
	-- else it will update the existing serviceItem
	If @RepairItemId IS NULL
	BEGIN
		INSERT INTO nxtRepairItems(RepairItems, CategoryItemId, Active)
		SELECT
		RepairItems, 
		CategoryItemId, 
		COALESCE(Active, 1) AS Active
		FROM #ServiceRepairItemDetailTemp;
		SET @message = 'Package Item inserted';
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT RepairItemId from nxtRepairItems where RepairItemId=@RepairItemId)
		BEGIN
			UPDATE nxtRepairItems
			SET 
				nxtRepairItems.RepairItems = CASE
				WHEN #ServiceRepairItemDetailTemp.RepairItems IS NOT NULL THEN #ServiceRepairItemDetailTemp.RepairItems
				ELSE nxtRepairItems.RepairItems
				END,
				nxtRepairItems.CategoryItemId = CASE
				WHEN #ServiceRepairItemDetailTemp.CategoryItemId IS NOT NULL THEN #ServiceRepairItemDetailTemp.CategoryItemId
				ELSE nxtRepairItems.CategoryItemId
				END,
				nxtRepairItems.Active = CASE
				WHEN #ServiceRepairItemDetailTemp.Active IS NOT NULL THEN #ServiceRepairItemDetailTemp.Active
				ELSE nxtRepairItems.Active
				END
			FROM nxtRepairItems, #ServiceRepairItemDetailTemp 
			WHERE nxtRepairItems.RepairItemId = @RepairItemId;
			SET @message = 'Package Item updated';
		END
		ELSE
		BEGIN
			SET @message = 'Given Package Item Id doesnt exist';
		END	
	END

	SELECT @message as message;
END

--------------------------------------------------------------------------------------------
-----------------------Add or update service Repair Parts-----------------------------------

CREATE PROCEDURE dbo.spAddUpdateServiceRepairParts
@json NVARCHAR(max),
@RepairItemsAndRate_Id INT
AS
BEGIN
	DECLARE @message varchar(120);
	IF OBJECT_ID('tempdb..#ServiceRepairPartItemDetailTemp') IS NOT NULL
	DROP TABLE #ServiceRepairPartItemDetailTemp;
	-- add the json data to tempTable
    select 
        json.RepairItemsPart, json.RepairItemId,
		json.Rate, json.OfferRate,
        json.Active, json.Min_Rate,
		json.Min_OfferRate
    INTO #ServiceRepairPartItemDetailTemp FROM OPENJSON(@json)
        with (
            RepairItemsPart varchar(50) '$.RepairItemsPart', 
            RepairItemId int '$.RepairItemId',
			Rate float '$.Rate',
			OfferRate float '$.OfferRate',			
            Active int '$.Active',
			Min_Rate float '$.Min_Rate',
			Min_OfferRate float '$.Min_OfferRate'						
        )json
	-- if RepairItemsAndRate_Id is null then the procedure will add the serviceItem
	-- else it will update the existing serviceItem
	If @RepairItemsAndRate_Id IS NULL
	BEGIN
		INSERT INTO nxtRepairServiceCharge(RepairItemsPart, RepairItemId, Rate, OfferRate, Active, Min_Rate, Min_OfferRate)
		SELECT
		RepairItemsPart, 
		RepairItemId, 
		Rate,
		OfferRate,
		COALESCE(Active, 1) AS Active,
		Min_Rate,
		Min_OfferRate
		FROM #ServiceRepairPartItemDetailTemp;
		SET @message = 'Repair Item Parts and Charge inserted';
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT RepairItemsAndRate_Id from nxtRepairServiceCharge where RepairItemsAndRate_Id=@RepairItemsAndRate_Id)
		BEGIN
			UPDATE nxtRepairServiceCharge
			SET 
				nxtRepairServiceCharge.RepairItemsPart = CASE
				WHEN #ServiceRepairPartItemDetailTemp.RepairItemsPart IS NOT NULL THEN #ServiceRepairPartItemDetailTemp.RepairItemsPart
				ELSE nxtRepairServiceCharge.RepairItemsPart
				END,
				nxtRepairServiceCharge.RepairItemId = CASE
				WHEN #ServiceRepairPartItemDetailTemp.RepairItemId IS NOT NULL THEN #ServiceRepairPartItemDetailTemp.RepairItemId
				ELSE nxtRepairServiceCharge.RepairItemId
				END,
				nxtRepairServiceCharge.Rate = CASE
				WHEN #ServiceRepairPartItemDetailTemp.Rate IS NOT NULL THEN #ServiceRepairPartItemDetailTemp.Rate
				ELSE nxtRepairServiceCharge.Rate
				END,
				nxtRepairServiceCharge.OfferRate = CASE
				WHEN #ServiceRepairPartItemDetailTemp.OfferRate IS NOT NULL THEN #ServiceRepairPartItemDetailTemp.OfferRate
				ELSE nxtRepairServiceCharge.OfferRate
				END,								
				nxtRepairServiceCharge.Active = CASE
				WHEN #ServiceRepairPartItemDetailTemp.Active IS NOT NULL THEN #ServiceRepairPartItemDetailTemp.Active
				ELSE nxtRepairServiceCharge.Active
				END,
				nxtRepairServiceCharge.Min_Rate = CASE
				WHEN #ServiceRepairPartItemDetailTemp.Min_Rate IS NOT NULL THEN #ServiceRepairPartItemDetailTemp.Min_Rate
				ELSE nxtRepairServiceCharge.Min_Rate
				END,
				nxtRepairServiceCharge.Min_OfferRate = CASE
				WHEN #ServiceRepairPartItemDetailTemp.Min_OfferRate IS NOT NULL THEN #ServiceRepairPartItemDetailTemp.Min_OfferRate
				ELSE nxtRepairServiceCharge.Min_OfferRate
				END								
			FROM nxtRepairServiceCharge, #ServiceRepairPartItemDetailTemp 
			WHERE nxtRepairServiceCharge.RepairItemsAndRate_Id = @RepairItemsAndRate_Id;
			SET @message = 'Repair Item Parts and Charge updated';
		END
		ELSE
		BEGIN
			SET @message = 'Given Repair Item Parts Id doesnt exist';
		END	
	END

	SELECT @message as message;
END