------------Get Customer Details
Create Procedure dbo.spInitializeCustomer
@custId int
As
Begin 
	Declare @result nvarchar(max);
	with x(json) as (
		Select 
			name,
			mobile,
			carts = (
				select * from cart
				where cart.customerId = @custId
				For Json PATH, INCLUDE_NULL_VALUES
			),
			addresses = (
				select * from customerAddress
				where customerId = @custId
				For Json PATH, INCLUDE_NULL_VALUES				
			),
			orders = (
				select 
				TOP 3 
				* 
				from orderMaster
				where orderMaster.customerId = @custId
				And orderMaster.status in ('pending', 'accepted')
				For Json PATH, INCLUDE_NULL_VALUES				
			)
		from customer
		where id = @custId
		For Json Auto, WITHOUT_ARRAY_WRAPPER	
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