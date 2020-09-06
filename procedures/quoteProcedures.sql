
-------------------------------------------------------------------
------------Get Quotes for serviceProvider belonging to any of 4 criteria----

CREATE Procedure dbo.spGetServiceProviderQuotes
@serviceProviderId INT,
@status NVARCHAR(30),
@page INT,
@startDate datetimeoffset,
@endDate datetimeoffset
As
BEGIN
	-- this procedure gives 15 Quotes belonging to serviceProviderId
	-- Quotes with status pending, accepted, rejected or all
	DECLARE @offset INT = 15 * (@page - 1);
	IF (@startDate is not NULL and @endDate is not NULL)
	BEGIN
		IF (@status = 'all')
		BEGIN 
			;with x(json) as (
				SELECT 
				*,
				items = (
					select * from orderDetail
					where orderMasterId = orderMaster.id
					FOR JSON PATH, INCLUDE_NULL_VALUES
				)
				from orderMaster
				where serviceProviderId = @serviceProviderId 
				and ( createdAt >= @startDate and createdAt <= @endDate)				
				ORDER BY id 
				OFFSET @offset ROWS FETCH NEXT 15 ROWS ONLY
				FOR JSON AUTO, INCLUDE_NULL_VALUES
			)
			select json as [json] from x;
		END
		ELSE 
		BEGIN 
			;with x(json) as (
				SELECT 
				*,
				items = (
					select * from orderDetail
					where orderMasterId = orderMaster.id
					FOR JSON PATH, INCLUDE_NULL_VALUES
				)
				from orderMaster
				where serviceProviderId = @serviceProviderId 
				and 
				status = @status
				and ( createdAt >= @startDate and createdAt <= @endDate)				
				ORDER BY id 
				OFFSET @offset ROWS FETCH NEXT 15 ROWS ONLY
				FOR JSON AUTO, INCLUDE_NULL_VALUES
			)
			select json as [json] from x;
		END
	END
	ELSE
	BEGIN
		IF (@status = 'all')
		BEGIN
			;with x(json) as (
				SELECT 
				*,
				items = (
					select * from orderDetail
					where orderMasterId = orderMaster.id
					FOR JSON PATH, INCLUDE_NULL_VALUES
				)
				from orderMaster
				where serviceProviderId = @serviceProviderId 
				ORDER BY id 
				OFFSET @offset ROWS FETCH NEXT 15 ROWS ONLY
				FOR JSON AUTO, INCLUDE_NULL_VALUES
			)
			select json as [json] from x;
		END
		ELSE
		BEGIN
			;with x(json) as (
				SELECT 
				*,
				items = (
					select * from orderDetail
					where orderMasterId = orderMaster.id
					FOR JSON PATH, INCLUDE_NULL_VALUES
				)
				from orderMaster
				where serviceProviderId = @serviceProviderId 
				and status = @status
				ORDER BY id 
				OFFSET @offset ROWS FETCH NEXT 15 ROWS ONLY
				FOR JSON AUTO, INCLUDE_NULL_VALUES
			)
			select json as [json] from x;
		END
	END	
END