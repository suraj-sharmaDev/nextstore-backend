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

---------------------------------------------------------