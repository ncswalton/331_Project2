go
-- =============================================
-- Author:		Nick Walton
-- Procedure:	[Project2].[Load_DimTerritory]
-- Create date: 2022-04-04
-- Description:	Procedure to load DimTerritory
-- Passed unit testing 04-06
-- =============================================
drop procedure if exists [Project2].[Load_DimTerritory]
go
	create procedure [Project2].[Load_DimTerritory] @UserAuthorizationKey int
as
begin
declare @start datetime2,
		@end datetime2,
		@rowcount int
select @start = sysdatetime();

	drop sequence if exists [Project2].[DimTerritorySequenceObject]
	create sequence [Project2].[DimTerritorySequenceObject]
	as int
	start with 1
	increment by 1;

	insert into [CH01-01-Dimension].DimTerritory
	(
	TerritoryKey,
	TerritoryGroup,
	TerritoryCountry,
	TerritoryRegion,
	UserAuthorizationKey
	)
	select
	next value for [Project2].[DimTerritorySequenceObject],
	query.TerritoryGroup,
	query.TerritoryCountry,
	query.TerritoryRegion,
	@UserAuthorizationKey
	from
	(
	select distinct
	fu.TerritoryGroup,
	fu.TerritoryCountry,
	fu.TerritoryRegion
	from FileUpload.OriginallyLoadedData as fu) as query

	select @end = sysdatetime();
	select @rowcount = count(*) from [CH01-01-Dimension].DimTerritory

	exec [Process].[usp_TrackWorkFlow]
		@EndTime = @end,
		@StartTime = @start,
		@WorkFlowDescription = 'Loading DimTerritory',
		@UserAuthorizationKey = @UserAuthorizationKey,
		@WorkFlowStepTableRowCount = rowcount
end;