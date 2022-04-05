use BIClass
go

-- =============================================
-- Author:		<Nick W>
-- Create date: <2022-04-02>
-- Description:	<Sequence for the workflow table>
-- The sequence gets inserted each time TrackWorkFlow gets exec'd
-- =============================================
ALTER PROCEDURE [Process].[WorkFlowSeq]
AS
BEGIN
	drop sequence if exists process.workflowseqctr;

	create sequence process.workflowseqctr
	as int
	start with 1
	increment by 1;
END

--exec procedures in this order:

--Gender
--MaritalStatus
--ProductCategories
--ProductSubcategories
--SalesManager
--Occupation
--Territory
--Product
--OrderDate
--Customer
--Data

-- =============================================
-- Author:		Nick Walton
-- Create date: 2022-04-05
-- Description:	Creates Process.WorkFlowSteps table 
-- passed unit testing
-- =============================================
go
ALTER PROCEDURE 
	[Process].[CreateWorkFlowStepsTable] @UserAuthorizationKey int
AS
BEGIN
	SET NOCOUNT ON;

	exec [Process].[WorkFlowSeq]

	declare @start datetime2
	declare @end datetime2
	drop table if exists [Process].[WorkflowSteps]
	select @start = sysdatetime()
	CREATE TABLE [Process].[WorkflowSteps]
	(
		[WorkFlowStepKey] [int] NOT NULL identity(1,1),
		[WorkFlowStepDescription] [nvarchar](100) NOT NULL,
		[WorkFlowStepTableRowCount] [int] NULL default(0),
		[StartingDateTime] [datetime2](7) NULL default(sysdatetime()),
		[EndingDateTime] [datetime2](7) NULL default(sysdatetime()),
		[Class Time] [char](5) NULL default('10:45'),
		[UserAuthorizationKey] [int] NOT NULL
		constraint PK_WorkFlowStep
			primary key(WorkFlowStepKey)
	)

	select @end = sysdatetime()
	
	insert into [Process].[WorkflowSteps]
	(
	WorkFlowStepTableRowCount,
	WorkFlowStepDescription,
	UserAuthorizationKey,
	StartingDateTime,
	EndingDateTime
	)
	values
	(
	next value for Process.workflowseqctr,
	'Creating [Process].[WorkflowSteps] table',
	@UserAuthorizationKey,
	@start,
	@end
	)
END

-- =============================================
-- Author:		Andrew Zheng
-- Create date: 2022-04-03
-- Description:	Creates DBSecurity.UserAuthorization
-- passed unit testing
-- =============================================
drop procedure if exists [Project2].[CreateDBSecurityAuthorizationTable]
go
create procedure [Project2].[CreateDBSecurityAuthorizationTable] @UserAuthorizationKey int
as
begin
-- Create Sequence Object for UserAuthorization Table
declare @start datetime2,
		@end datetime2
select @start = sysdatetime();
drop table if exists DbSecurity.UserAuthorizat
CREATE TABLE DbSecurity.UserAuthorization(
    UserAuthorizationKey INT            NOT NULL    PRIMARY KEY,
    ClassTime            NCHAR(5)       NULL        DEFAULT '10:45',
    [Individual Project] NVARCHAR(60)   NULL        DEFAULT 'PROJECT 2 RECREATE THE BICLASS DATABASE STAR SCHEMA',
    GroupMemberLastName  NVARCHAR(35)   NOT NULL,
    GroupMemberFirstName NVARCHAR(25)   NOT NULL,
    GroupName            NVARCHAR(20)   NOT NULL    DEFAULT 'G10-C',
    DateAdded            DATETIME2      NULL        DEFAULT SYSDATETIME()
);

-- Insert Group Members into table
INSERT INTO DbSecurity.UserAuthorization(
	UserAuthorizationKey,
    GroupMemberLastName,
    GroupMemberFirstName
) VALUES
    (1, 'Zheng', 'Andrew'),
    (2, 'Paul', 'Spohia'),
    (3, 'Hossian', 'Ivan'),
    (4, 'Walton', 'Nick'),
    (5, 'Joseph', 'Joel'),
    (7, 'Sebastian', 'Manna');

select @end = sysdatetime();
	exec Process.usp_TrackWorkFlow
		@StartTime = @start,
		@EndTime = @end,
		@WorkFlowDescription = 'Loading DimOrderDate',
		@UserAuthorizationkey = @UserAuthorizationkey

end


GO
-- =============================================
-- Author:		Joel Joseph
-- Create date: 2022-04-03
-- Description:	Loads DimOrderDate
-- passed unit testing
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

	exec Process.usp_TrackWorkFlow
	@StartTime = @start,
	@EndTime = @end,
	@WorkFlowDescription = 'Loading DimOrderDate',
	@UserAuthorizationkey = @UserAuthorizationkey

END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Nick Walton
-- Procedure:	[Project2].[CreateProductCategory]
-- Create date: 2022-04-04
-- Description:	Creates the ProductCategory table
-- =============================================
drop procedure if exists [Project2].[CreateProductCategory]
go
create procedure [Project2].[CreateProductCategory] @UserAuthorizationKey int
as
begin

	declare @start datetime2,
			@end datetime2
	select @start = sysdatetime();

	drop sequence if exists [PkSequence].[DimProductCategorySequenceObject]
	create sequence [PkSequence].[DimProductCategorySequenceObject]
	as int
	start with 1
	increment by 1

	drop table if exists [CH01-01-Dimension].[DimProductCategory];
	create table [CH01-01-Dimension].[DimProductCategory]
	(
	[ProductCategoryKey] int not null primary key,
	[ProductCategory] varchar(20) not null
	)


	insert into [CH01-01-Dimension].[DimProductCategory]
	(
	ProductCategoryKey,
	ProductCategory
	)
	select
		next value for [PkSequence].[DimProductCategorySequenceObject],
		fu.ProductCategory
	from
		(select distinct ProductCategory
		from FileUpload.OriginallyLoadedData) as fu

	select @end = sysdatetime();

	exec [Process].usp_TrackWorkFlow 
		@StartTime = @start,
		@EndTime = @end,
		@WorkFlowDescription = 'Created [DimProductCategory] table',
		@UserAuthorizationKey = @UserAuthorizationKey
end;

-- =============================================
-- Author:		Nick Walton
-- Procedure:	[Project2].[CreateProductCategory]
-- Create date: 2022-04-04
-- Description:	Creates the ProductSubcategory table
-- =============================================

drop procedure if exists [Project2].[CreateProductSubcategory];
go

create procedure [Project2].[CreateProductSubcategory] @UserAuthorizationKey INT
as
begin
	declare @start datetime2,
			@end datetime2
	select @start = sysdatetime();
	
	drop sequence if exists [PkSequence].[DimProductSubategorySequenceObject]
	create sequence [PkSequence].[DimProductSubcategorySequenceObject]
	as int
	start with 1
	increment by 1

    drop table if exists [CH01-01-Dimension].[DimProductSubcategory];

    create table [CH01-01-Dimension].[DimProductSubcategory]
    (
        [ProductSubcategoryKey] int not null primary key,
        [ProductCategoryKey] int not null,
        constraint FK_DimProductCategory
            foreign key (ProductCategoryKey)
            references [CH01-01-Dimension].[DimProductCategory] (ProductCategoryKey),
        ProductSubcategory varchar(20) null
    );


    SET NOCOUNT ON;

    insert into [CH01-01-Dimension].[DimProductSubcategory]
    (
        [ProductSubcategoryKey],
        [ProductCategoryKey],
        [ProductSubcategory]
    )
    select next value for [PkSequence].[DimProductSubcategorySequenceObject],
           query.ProductCategoryKey,
           query.ProductSubcategory
    from
    (
	select distinct fu.ProductCategory, fu.ProductSubcategory, pc.ProductCategoryKey
	from FileUpload.OriginallyLoadedData AS fu
	inner join [CH01-01-Dimension].[DimProductCategory] AS pc
	on pc.ProductCategory = fu.ProductCategory
    ) as query;

    select @end = sysdatetime();

    exec [Process].[usp_TrackWorkFlow] 
		@StartTime = @start,
		@EndTime = @end,
		@WorkFlowDescription = 'Create/load ProductSubcategory table',
		@UserAuthorizationKey = @UserAuthorizationKey;
		                                   
END;
GO

--TODO: product table procedure

-- =============================================
-- Author:		Nick Walton
-- Create date: 2022-04-05
-- Description:	Drop the Foreign Keys From the Star Schema
-- =============================================
drop procedure if exists [Project2].[DropForeignKeysFromStarSchemaData]
go
create PROCEDURE [Project2].[DropForeignKeysFromStarSchemaData] @UserAuthorizationKey int
AS
BEGIN

declare @start datetime2,
		@end datetime2;
select @start = sysdatetime();

    SET NOCOUNT ON;
	alter table [CH01-01-Fact].[Data] drop constraint FK_Data_DimCustomer;
	alter table [CH01-01-Fact].[Data] drop constraint FK_Data_DimGender;
	alter table [CH01-01-Fact].[Data] drop constraint FK_Data_DimMaritalStatus;
	alter table [CH01-01-Fact].[Data] drop constraint FK_Data_DimOccupation;
	alter table [CH01-01-Fact].[Data] drop constraint FK_Data_DimProduct;
	alter table [CH01-01-Fact].[Data] drop constraint FK_Data_SalesManagers;
	alter table [CH01-01-Fact].[Data] drop constraint FK_Data_DimTerritory;
	alter table [CH01-01-Fact].[Data] drop constraint FK_Data_DimOrderDate;

select @end = sysdatetime();

exec [Process].usp_TrackWorkFlow 
	@StartTime = @start, 
	@EndTime = @end, 
	@WorkFlowDescription = 'Dropped FKs from Fact.Data table',
	@UserAuthorizationKey = @UserAuthorizationKey;

END;

-- =============================================
-- Author:		Nick Walton
-- Procedure:	[Project2].[AddColumns]
-- Create date: 2022-04-04
-- Description:	Adds the UserAuthorizationKey, DateAdded, DateOfLastUpdate cols to each table
-- =============================================
drop procedure if exists [Project2].[AddColumns];
go
create procedure [Project2].[AddColumns] @UserAuthorizationKey INT
	as
	begin
		declare @start datetime2,
				@end datetime2;

	select @start = sysdatetime();

	begin
		alter table [CH01-01-Dimension].[DimCustomer]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

	begin
		alter table [CH01-01-Dimension].[DimMaritalStatus]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

	begin
		alter table [CH01-01-Dimension].[DimGender]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

	begin
		alter table [CH01-01-Dimension].[DimOccupation]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

	begin
		alter table [CH01-01-Dimension].[DimOrderDate]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

	begin
		alter table [CH01-01-Dimension].[DimProduct]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

	begin
		alter table [CH01-01-Dimension].[DimTerritory]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

	begin
		alter table [CH01-01-Dimension].[SalesManagers]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

	begin
		alter table [CH01-01-Fact].[Data]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

	select @end = sysdatetime();

	exec [Process].usp_TrackWorkFlow 
		@StartTime = @start, 
		@EndTime = @end, 
		@WorkFlowDescription = 'Dropped and replaced PK columns',
		@UserAuthorizationKey = @UserAuthorizationKey;

end
go


-- =============================================
-- Author:		Nick Walton
-- Procedure:	[Project2].[TruncateTables]
-- Create date: 2022-04-04
-- Description:	Procedure to truncate table data before loading
-- =============================================
drop procedure if exists [Project2].[TruncateTables]
go
create procedure [Project2].[TruncateTables] @UserAuthorizationKey int, @WorkFlowDescription varchar(20)
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
		@WorkFlowDescription = @WorkFlowDescription,
		@UserAuthorizationKey = @UserAuthorizationKey;

end
go


-- =============================================
-- Author:		Nick Walton
-- Procedure:	[Project2].[ReplacePKsWithSequenceColumns]
-- Create date: 2022-04-04
-- Description:	Procedure to drop and replace PK columns
-- =============================================

drop procedure if exists [Project2].[ReplacePKsWithSequenceColumns]
go
create procedure [Project2].[ReplacePKsWithSequenceColumns] @UserAuthorizationKey int, @WorkFlowDescription varchar(20)
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

end


-- =============================================
-- Author:		Nick Walton
-- Procedure:	[Project2].[LoadTerritory]
-- Create date: 2022-04-04
-- Description:	Procedure to load DimTerritory
-- =============================================
drop procedure if exists [Project2].[LoadTerritory]
go
create procedure [Project2].[LoadTerritory] @UserAuthorizationKey int
as
begin
declare @start datetime2,
		@end datetime2
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
	TerritoryRegion
	--UserAuthorizationKey
	)
	select
	next value for [Project2].[DimTerritorySequenceObject],
	query.TerritoryGroup,
	query.TerritoryCountry,
	query.TerritoryRegion
	---@UserAuthorizationKey
	from
	(
	select distinct
	fu.TerritoryGroup,
	fu.TerritoryCountry,
	fu.TerritoryRegion
	from FileUpload.OriginallyLoadedData as fu) as query

	select @end = sysdatetime();

	exec [Process].[usp_TrackWorkFlow]
		@EndTime = @end,
		@StartTime = @start,
		@WorkFlowDescription = 'Loading DimTerritory',
		@UserAuthorizationKey = @UserAuthorizationKey
end;


-- loads the data table
-- this is dependent on all the other tables being loaded prior
drop procedure if exists [Project2].[LoadData];
go
create procedure [Project2].[LoadData] @UserAuthorizationKey int
AS
BEGIN

	SET NOCOUNT ON;
	declare @start datetime2,
			@end datetime2;
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
	[Year],
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

    exec [Process].[usp_TrackWorkFlow]
		@StartTime = @start,
		@EndTime = @end,
		@WorkFlowDescription = 'Loading Fact.Data table',
		@UserAuthorizationKey = @UserAuthorizationKey
		
END;
GO
