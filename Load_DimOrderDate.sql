-- =============================================
-- Author:		Joel Joseph
-- Create date: 2022-04-03
-- Description:	Loads DimOrderDate
-- passed unit testing 04-06
-- =============================================
drop procedure if exists [Project2].[Load_DimOrderDate]
go
create PROCEDURE [Project2].[Load_DimOrderDate] @UserAuthorizationKey int with exec as owner
AS
BEGIN

set nocount on
	declare @start as datetime
	declare @end as datetime
	
	select @start = SYSDATETIME();
	
	truncate table [CH01-01-Dimension].[DimOrderDate]
	insert into [CH01-01-Dimension].[DimOrderDate]
	(
	Orderdate,
	MonthName,
	MonthNumber,
	Year,
	UserAuthorizationKey
	)

	select distinct
	a.OrderDate,
	a.MonthName,
	a.MonthNumber,
	a.Year,
	@UserAuthorizationKey
	from FileUpload.OriginallyLoadedData As a 

	Select @end = sysdatetime()

	declare @rowcount as int
	set @rowcount = (select count(*)
	from [CH01-01-Dimension].[DimOrderDate]);

	exec Process.usp_TrackWorkFlow 
	@WorkFlowDescription = 'Loading OrderDate table',
	@UserAuthorizationKey = @UserAuthorizationKey,
	@WorkFlowStepTableRowCount=@rowcount,
	@StartTime = @start,
	@EndTime = @end

END
