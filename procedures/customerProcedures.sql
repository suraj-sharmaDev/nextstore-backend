------------Get Customer Details
------------Get Customer Details
CREATE Procedure dbo.spInitializeCustomer
@custId int
As
Begin 
	Declare @result nvarchar(max);
	with x(json) as (
		Select 
			name,
			mobile,
			favourite = (
				select id, shopId from favourite
				where customerId = @custId
				FOR JSON AUTO, INCLUDE_NULL_VALUES
			),
			cart = (
				select cm.shopId, cm.customerId, cartDetail.* 
				from cartMaster cm
				inner join cartDetail on cartDetail.cartMasterId = cm.id
				where cm.customerId = @custId and cm.status = 0
				FOR JSON AUTO, INCLUDE_NULL_VALUES
			),
			address = (
				select * from customerAddress
				where customerId = @custId
				For Json PATH, INCLUDE_NULL_VALUES				
			),
			[order] = (
				select
				orderMaster.*,
				items.productId,
				items.productName,
				items.price,
				items.qty 
				from 
				(
					SELECT orderMaster.*, shop.name from orderMaster
					INNER JOIN shop on shop.id = orderMaster.shopId
					where orderMaster.customerId = @custId
				)
				as orderMaster				
				INNER JOIN orderDetail as items on items.orderMasterId = orderMaster.id
				And orderMaster.status in ('pending', 'accepted')
				For Json AUTO, INCLUDE_NULL_VALUES				
			),
			recentOrder = (
				select 
				TOP 3 
				* 
				from orderMaster
				where orderMaster.customerId = @custId
				And orderMaster.status in ('completed')
				For Json PATH, INCLUDE_NULL_VALUES							
			)
		from customer
		where id = @custId
		For Json Auto, INCLUDE_NULL_VALUES, WITHOUT_ARRAY_WRAPPER	
	)
	
	select @result=json from x;
	select @result;
	RETURN
End

GO;

---------------------------------------------------------
--procedure to find or create a customer along with otp--

CREATE PROCEDURE dbo.spLoginOrSignupCustomer
@mobile nvarchar(20)
AS
BEGIN
	DECLARE @otp nvarchar(10);
	DECLARE @customerId int;
	-- create and store otp in @otp
	exec spGenerateOtp 4, @output = @otp out;
	SELECT @customerId = id FROM customer WHERE mobile = @mobile;
	IF (@customerId > 0)
		BEGIN 
			-- create a row for verifying the customer
			INSERT INTO verification (customerId, otpCode ) values (@customerId, @otp);
			-- Return customer Information
			SELECT 
			c.id, c.name, c.mobile, @otp as otp
			from customer as c
			where c.id = @customerId
		END
	ELSE 
		BEGIN 
			-- create a new user with @mobile
			INSERT INTO customer (mobile) values (@mobile);
			-- Get the customerId of the inserted customer
			SELECT @customerId = id FROM customer WHERE mobile = @mobile;
			-- create a row for verifying the customer
			INSERT INTO verification (customerId, otpCode ) values (@customerId, @otp);
			-- Return customer Information
			SELECT 
			c.id, c.name, c.mobile, @otp as otp
			from customer as c
			where c.id = @customerId
		END
END

GO;

----------------------------------------------------------------------
-- verify the customer with otp

CREATE PROCEDURE dbo.spVerifyCustomerOtp
@customerId int,
@otp NVARCHAR(20)
AS
BEGIN
	DECLARE @timeDiff INT;

	select
	@timeDiff = DATEDIFF(minute, [timestamp], GETDATE())
	from verification
	where customerId = @customerId
	AND otpCode = @otp;

	IF (@timeDiff < 5)
	BEGIN
		-- on time verification
		UPDATE verification set verified = 1 where customerId = @customerId AND otpCode = @otp;
		select 'verified' as message;
	END
	ELSE
	BEGIN
		-- too late for verification
		UPDATE verification set verified = 0 where customerId = @customerId AND otpCode = @otp;
		select 'late' as message;	
	END
END

GO;

----------------------------------------------------------------------
-- Get all shops marked as favourites

CREATE PROCEDURE dbo.spGetFavouriteShops
@customerId int
AS
BEGIN
	Declare @baseUrl varchar(200);
	--get baseUrl as local variable
	Select @baseUrl=baseUrl from appConfig;

	SELECT 
	f.id, 
	f.shopId,
	s.name,
	s.onlineStatus,
	CONCAT(@baseUrl,s.[image]) as [image],
	s.rating,
	s.category,
	s.coverage,
	a.latitude,
	a.longitude,
	f.[timestamp] 
	from favourite as f 
	INNER JOIN shop as s on s.id = f.shopId
	INNER JOIN shopAddress as a on a.shopId = f.shopId
	where f.customerId = @customerId;
	RETURN;
END

GO;

----------------------------------------------------------------------
-- Add shop to favourites

CREATE PROCEDURE dbo.spAddShopAsFavourite
@customerId int,
@shopId int
AS
BEGIN
	INSERT INTO favourite (customerId, shopId) VALUES (@customerId, @shopId);
	RETURN;
END

GO;

----------------------------------------------------------------------
-- Remove shop from favourites

CREATE PROCEDURE dbo.spDeleteShopFromFavourite
@customerId int,
@shopId int
AS
BEGIN
	DELETE FROM favourite where customerId = @customerId and shopId = @shopId;
	RETURN;
END


GO;