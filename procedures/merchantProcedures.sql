------------Get Merchant and shop Details
CREATE Procedure dbo.spGetMerchantShops
@merchId int
As
Begin 
	Declare @result nvarchar(max);
	Declare @baseUrl varchar(200);
	--get baseUrl as local variable
	Select @baseUrl=baseUrl from appConfig;
	with x(json) as (
		Select * from merchant
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