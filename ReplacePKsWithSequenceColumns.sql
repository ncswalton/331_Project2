-- =============================================
-- Author:		Nick Walton
-- Procedure:	[Project2].[ReplacePKsWithSequenceColumns]
-- Create date: 2022-04-04
-- Description:	Procedure to drop and replace PK columns
-- =============================================

drop procedure if exists [Project2].[ReplacePKsWithSequenceColumns]
go
create procedure [Project2].[ReplacePKsWithSequenceColumns] @UserAuthorizationKey int
as
begin

	declare @start datetime2,
			@end datetime2;

	select @start = sysdatetime();

	--Drop PK constraints and columns to eliminate identity
	alter table [CH01-01-Dimension].[DimCustomer]
		drop constraint PK__DimCusto__95011E6452BCF41C,
		column [CustomerKey]
	alter table [CH01-01-Dimension].[DimOccupation]
		drop constraint PK_DimOccupation,
		column [OccupationKey]
	alter table [CH01-01-Dimension].[DimTerritory]
		drop constraint PK__DimTerri__C54B735D813BBCA6,
		column [TerritoryKey]
	alter table [CH01-01-Dimension].[DimProduct]
		drop constraint  PK__DimProdu__A15E99B3E27177EF,
		column [ProductKey]
	alter table [CH01-01-Dimension].[SalesManagers]
		drop constraint PK_SalesManagers,
		column [SalesManagerKey]
	alter table [CH01-01-Fact].[Data]
		drop constraint PK_Data,
		column [SalesKey]

	--Add column back in for the sequence object


	alter table [CH01-01-Dimension].[DimCustomer]
		add [CustomerKey] int not null primary key default(-1)
	alter table [CH01-01-Dimension].[DimOccupation]
		add [OccupationKey] int not null primary key default(-1)
	alter table [CH01-01-Dimension].[DimTerritory]
		add [TerritoryKey] int not null primary key default(-1)
	alter table [CH01-01-Dimension].[DimProduct]
		add [ProductKey] int not null primary key default(-1)
	alter table [CH01-01-Dimension].[SalesManagers]
		add [SalesManagerKey] int not null primary key default(-1)
	alter table [CH01-01-Fact].[Data]
		add [SalesKey] int not null primary key default(-1)

select @end = sysdatetime();

	exec [Process].usp_TrackWorkFlow 
		@StartTime = @start, 
		@EndTime = @end, 
		@WorkFlowDescription = 'Dropping and replacing PK columns',
		@UserAuthorizationKey = @UserAuthorizationKey;

end