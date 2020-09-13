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
		* 
		from 
		(
			SELECT id, firstName, lastName, mobile from merchant
		) as merchant
		inner join
		(
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
		) as shops 
		on shops.merchantId = merchant.id
		where id = @merchId
		For Json Auto, WITHOUT_ARRAY_WRAPPER	
	)
	
	select @result=json from x;
	select @result;
	RETURN
End




---------------------------------------------------------