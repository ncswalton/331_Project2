

-- =============================================
-- Author:		Nick Walton
-- Create date: 2022-04-05
-- Description:	Truncate tables in the star schema
-- =============================================

drop procedure if exists Project2.[TruncateStarSchemaData] 
go
create procedure Project2.[TruncateStarSchemaData] @UserAuthorizationKey int 
as
begin

	declare @start datetime2,
			@end datetime2;

	select @start = sysdatetime();

	truncate table [CH01-01-Dimension].[DimCustomer];
	truncate table [CH01-01-Dimension].[DimMaritalStatus];
	truncate table [CH01-01-Dimension].[DimGender];
	truncate table [CH01-01-Dimension].[DimOccupation];
	truncate table [CH01-01-Dimension].[DimOrderDate];
	truncate table [CH01-01-Dimension].[DimProduct];
	truncate table [CH01-01-Dimension].[DimTerritory];
	truncate table [CH01-01-Dimension].[SalesManagers];
	truncate table [CH01-01-Fact].[Data];

	select @end = sysdatetime();

	exec [Process].usp_TrackWorkFlow 
		@StartTime = @start, 
		@EndTime = @end, 
		@WorkFlowDescription = 'Truncating tables',
		@UserAuthorizationKey = @UserAuthorizationKey;

end