drop procedure if exists [Project2].[Load_Data];
go
create procedure [Project2].[Load_Data] @UserAuthorizationKey int
AS
BEGIN

	SET NOCOUNT ON;
	declare @start datetime2,
			@end datetime2,
			@rowcount int
	select @start = sysdatetime();

    drop sequence if exists [Project2].[DataSequenceObject];
    create sequence  [Project2].[DataSequenceObject]
	as int
    start with 1
    increment by 1;

insert into [CH01-01-Fact].[Data]
    (
	SalesKey,
	SalesManagerKey,
	OccupationKey,
	TerritoryKey,
	ProductKey,
	CustomerKey,
	ProductCategory,
	SalesManager,
	ProductSubcategory,
	ProductCode,
	ProductName,
	Color,
	ModelName,
	OrderQuantity,
	UnitPrice,
	ProductStandardCost,
	SalesAmount,
	OrderDate,
	MonthName,
	MonthNumber,
	Year,
	CustomerName,
	MaritalStatus,
	Gender,
	Education,
	Occupation,
	TerritoryRegion,
	TerritoryCountry,
	TerritoryGroup,
	UserAuthorizationKey
    )
select
	next value for [Project2].[DataSequenceObject],
	sm.SalesManagerKey,
	do.OccupationKey,
	dt.TerritoryKey,
	dp.ProductKey,
	dc.CustomerKey,
	fu.ProductCategory,
	fu.SalesManager,
	fu.ProductSubcategory,
	fu.ProductCode,
	fu.ProductName,
	fu.Color,
	fu.ModelName,
	fu.OrderQuantity,
	fu.UnitPrice,
	fu.ProductStandardCost,
	fu.SalesAmount,
	fu.OrderDate,
	fu.MonthName,
	fu.MonthNumber,
	fu.Year,
	fu.CustomerName,
	fu.MaritalStatus,
	fu.Gender,
	fu.Education,
	fu.Occupation,
	fu.TerritoryRegion,
	fu.TerritoryCountry,
	fu.TerritoryGroup,
	@UserAuthorizationKey
from FileUpload.OriginallyLoadedData as fu
inner join [CH01-01-Dimension].SalesManagers as sm
on fu.SalesManager = sm.SalesManager
and fu.ProductSubcategory = sm.Category
inner join [CH01-01-Dimension].DimProduct as dp
on fu.ProductName = dp.ProductName
inner join [CH01-01-Dimension].DimCustomer as dc
on fu.CustomerName = dc.CustomerName
inner join [CH01-01-Dimension].DimOccupation as do
on fu.Occupation = do.Occupation
inner join [CH01-01-Dimension].DimTerritory as dt
on fu.TerritoryRegion = dt.TerritoryRegion
and fu.TerritoryCountry = dt.TerritoryCountry
and fu.TerritoryGroup = dt.TerritoryGroup

	select @end = sysdatetime();
	select @rowcount = count(*) from [CH01-01-Fact].[Data]

    exec [Process].[usp_TrackWorkFlow]
		@StartTime = @start,
		@EndTime = @end,
		@WorkFlowDescription = 'Loading Fact.Data table',
		@UserAuthorizationKey = @UserAuthorizationKey,
		@WorkFlowStepTableRowCount = @rowcount
		
END;