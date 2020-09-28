-- Get all shops either with filter parameter such as merchantId or onlineStatus 
-- or merchant Name, shop Name, shopId
CREATE PROCEDURE dbo.spGetMerchantsWithFilter
@json NVARCHAR(MAX),
@page INT
AS
BEGIN
	-- this procedure gives 15 merchants belonging abiding by certain search queries
	DECLARE @offset INT = 15 * (@page - 1);	
	DECLARE @merchId INT = JSON_VALUE(@json, '$.merchId');
	DECLARE @merchName VARCHAR(30) = JSON_VALUE(@json, '$.merchName');
	DECLARE @merchEmail VARCHAR(40)  = JSON_VALUE(@json, '$.merchEmail');

	DECLARE @query NVARCHAR(500) = N'
		SELECT 
		id,
		CONCAT(firstName+'' '', lastName ) as fullName,
		mobile,
		email,
		createdAt
		FROM merchant
		WHERE
		1 = 1
	';
	IF @merchId IS NOT NULL
	BEGIN
		SET @query = @query + N'
			AND id = @merchId
		';
	END
	IF @merchName IS NOT NULL
	BEGIN
		SET @query = @query + N'
			AND CONCAT(firstName+'' '', lastName ) like ''%''+@merchName+''%''
		';
	END	
	IF @merchEmail IS NOT NULL
	BEGIN
		SET @query = @query + N'
			AND email = @merchEmail 
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
		N'@merchId int, @merchEmail VARCHAR(40), @merchName VARCHAR(30), @offset INT',
		@merchId, @merchEmail, @merchName, @offset
	;
END

GO;

---------------------------------------------------------
------procedure to login merchant -----------------------

CREATE PROCEDURE dbo.spLoginMerchant
@email nvarchar(30),
@password nvarchar(30)
AS
BEGIN
	DECLARE @merchantId int;
	DECLARE @password_hash NVARCHAR(500) = HASHBYTES('MD5', @password);

	SELECT @merchantId = id FROM merchant 
	WHERE 
		email = @email;
	
	IF (@merchantId > 0)
		BEGIN 
			-- Email matches to one of user
			-- check if password matches too
			IF EXISTS (SELECT id from merchant where id = @merchantId and password = @password_hash)
			BEGIN 
				SELECT 
				m.id, CONCAT(m.firstName , ' ', m.lastName ) as [name], m.mobile
				from merchant m 
				where m.id = @merchantId
			END
			ELSE
			BEGIN 
				SELECT 'password_mismatch' as message, 'TRUE' as 'error';				
			END
		END
	ELSE 
	BEGIN 
		-- neither email nor password matches
		SELECT 'email_password_mismatch' as message, 'TRUE' as 'error';
	END
END

GO;

------------Get Merchant and shop Details---------

CREATE Procedure dbo.spGetMerchantShops
@merchId int
As
Begin 
	Declare @result nvarchar(max);
	Declare @baseUrl varchar(200);
	--get baseUrl as local variable
	Select @baseUrl=baseUrl from appConfig;
	with x(json) as (
		Select 
		id, firstName, lastName, mobile,
		shops = (
			select 
				shop.id as shopId,
				shop.name as name,
				shop.category as category,
				shop.onlineStatus as onlineStatus,
				CONCAT(@baseUrl,shop.image) as image,
				shop.merchantId as merchantId,
				shopAddress.pickupAddress as pickupAddress,
				shopAddress.latitude as latitude,
				shopAddress.longitude as longitude
			from shop 
			inner join shopAddress on shopAddress.shopId = shop.id
			where merchantId = @merchId	
			FOR JSON PATH, INCLUDE_NULL_VALUES
		),
		services = (
			SELECT 
			serviceProvider.id,
			serviceProvider.name,
			serviceProvider.categoryId,
			nsc.CategoryName as categoryName,
			serviceProvider.coverage,
			serviceProvider.rating,
			spa.pickupAddress,
			spa.latitude,
			spa.longitude 
			from serviceProvider
			inner join nxtServiceCategory nsc on nsc.CategoryId = serviceProvider.categoryId 
			inner join serviceProviderAddress spa on spa.serviceProviderId = serviceProvider.id
			where serviceProvider.merchantId = @merchId
			FOR JSON PATH, INCLUDE_NULL_VALUES			
		)
		from merchant
		where merchant.id = @merchId
		For Json Auto, WITHOUT_ARRAY_WRAPPER	
	)
	
	select @result=json from x;
	select @result;
	RETURN
End




---------------------------------------------------------