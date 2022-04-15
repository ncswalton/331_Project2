use BIClass
go
-- =============================================
-- Author:		<Nick Walton>
-- Create date: <2022-04-02>
-- Description:	<Creates [Process].[usp_TrackWorkFlow] to track execution of procedures>
-- =============================================
drop procedure if exists [Process].[usp_TrackWorkFlow]
go
create PROCEDURE [Process].[usp_TrackWorkFlow]
	-- Add the parameters for the stored procedure here
	@StartTime datetime2(7),
	@EndTime datetime2(7),
	@WorkFlowDescription nvarchar(100),
	@UserAuthorizationKey int,
	@WorkFlowStepTableRowCount int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	insert into Process.WorkflowSteps
	(
	WorkFlowStepDescription,
	UserAuthorizationKey,
	StartingDateTime,
	EndingDateTime,
	WorkFlowStepTableRowCount
	)

	values
	(@WorkFlowDescription, 
	@UserAuthorizationKey, 
	@StartTime, 
	@EndTime,
	@WorkFlowStepTableRowCount);
END

go
--STEP 2: CREATE WORKFLOWSTEPS TABLE
-- =============================================
-- Author:		Nick Walton
-- Create date: 2022-04-05
-- Description:	Creates Process.WorkFlowSteps table 
-- passed unit testing
-- =============================================

drop procedure if exists [Process].[CreateWorkFlowStepsTable]
go
create PROCEDURE [Process].[CreateWorkFlowStepsTable] @UserAuthorizationKey int
	AS
BEGIN
	SET NOCOUNT ON;
	
	exec [Process].[WorkFlowSeq]

	declare @start datetime2,
			@end datetime2,
			@rowcount int
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
	select @rowcount = count(*) from Process.WorkflowSteps

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
	@rowcount,
	'Creating [Process].[WorkflowSteps] table',
	@UserAuthorizationKey,
	@start,
	@end
	)
END

go

--STEP 3: ADD NEW COLUMNS TO 9 ORIGINAL TABLES
--DROP ADDED
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
		@UserAuthorizationKey = @UserAuthorizationKey,
		@WorkFlowStepTableRowCount = null;

end


go
-- STEP 4: CREATE AUTHORIZATION TABLE
-- =============================================
-- Author:		Andrew Zheng
-- Create date: 2022-04-03
-- Description:	Creates DBSecurity.UserAuthorization
-- passed unit testing
-- =============================================
	drop procedure if exists [Project2].[CreateDBSecurityAuthorizationTable]
		go
		drop procedure if exists [Project2].[CreateDBSecurityAuthorizationTable]
		go
			create procedure [Project2].[CreateDBSecurityAuthorizationTable] @UserAuthorizationKey int
			as
		begin
	-- Create Sequence Object for UserAuthorization Table
	declare @start datetime2,
			@end datetime2
	select @start = sysdatetime();
	drop table if exists DbSecurity.UserAuthorization
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
			@WorkFlowDescription = 'Creating Db.SecurityAuthorization',
			@UserAuthorizationkey = @UserAuthorizationkey,
			@WorkFlowStepTableRowCount = null

	end
GO

-- =============================================
-- Author:		Nick Walton
-- Procedure:	[Project2].[CreateProductCategory]
-- Create date: 2022-04-04
-- Description:	Creates the ProductCategory table
-- Passed unit testing 04-06
-- =============================================
drop procedure if exists [Project2].[CreateProductCategory]
go
create procedure [Project2].[CreateProductCategory] @UserAuthorizationKey int
as
begin

	declare @start datetime2,
			@end datetime2,
			@rowcount int
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
	[ProductCategory] varchar(20) not null,
	UserAuthorizationKey int not null default(-1),
	DateAdded datetime2 null default(sysdatetime()),
	DateOfLastUpdate datetime2 null default(sysdatetime())
	)


	insert into [CH01-01-Dimension].[DimProductCategory]
	(
	ProductCategoryKey,
	ProductCategory,
	UserAuthorizationKey
	)
	select
		next value for [PkSequence].[DimProductCategorySequenceObject],
		fu.ProductCategory,
		@UserAuthorizationKey
	from
		(select distinct ProductCategory
		from FileUpload.OriginallyLoadedData) as fu

	select @end = sysdatetime();

	select @rowcount = count(*) from [CH01-01-Dimension].DimProductCategory

	exec [Process].usp_TrackWorkFlow 
		@StartTime = @start,
		@EndTime = @end,
		@WorkFlowDescription = 'Created [DimProductCategory] table',
		@UserAuthorizationKey = @UserAuthorizationKey,
		@WorkFlowStepTableRowCount = @rowcount
end;

go
drop procedure if exists [Project2].[CreateProductSubcategory];
go
create procedure [Project2].[CreateProductSubcategory] @UserAuthorizationKey INT
as
begin
	declare @start datetime2,
			@end datetime2,
			@rowcount int
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
        ProductSubcategory varchar(20) null,
		UserAuthorizationKey int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime())

    );


    SET NOCOUNT ON;

    insert into [CH01-01-Dimension].[DimProductSubcategory]
    (
        [ProductSubcategoryKey],
        [ProductCategoryKey],
        [ProductSubcategory],
		UserAuthorizationKey
    )
    select next value for [PkSequence].[DimProductSubcategorySequenceObject],
           query.ProductCategoryKey,
           query.ProductSubcategory,
		   @UserAuthorizationKey
    from
    (
	select distinct fu.ProductCategory, fu.ProductSubcategory, pc.ProductCategoryKey
	from FileUpload.OriginallyLoadedData AS fu
	inner join [CH01-01-Dimension].[DimProductCategory] AS pc
	on pc.ProductCategory = fu.ProductCategory
    ) as query;

    select @end = sysdatetime();

	select @rowcount = count(*) from [CH01-01-Dimension].DimProductSubcategory

    exec [Process].[usp_TrackWorkFlow] 
		@StartTime = @start,
		@EndTime = @end,
		@WorkFlowDescription = 'Create/load ProductSubcategory table',
		@UserAuthorizationKey = @UserAuthorizationKey,
		@WorkFlowStepTableRowCount = @rowcount
		                                   
END;
GO


GO
-- =============================================
-- Author: Joel Joseph
-- Create date: 2022-04-05
-- Description: Loads DimProduct table 
-- Passed unit testing 04-06
-- =============================================
drop procedure if exists [Project2].[Load_DimProduct]
go
create PROCEDURE [Project2].[Load_DimProduct] @UserAuthorizationKey int
AS
BEGIN
set nocount on
    declare @start as datetime
    declare @end as datetime
    

    select @start = SYSDATETIME();

	drop sequence if exists PkSequence.DimProductSequenceObject
	create sequence PkSequence.DimProductSequenceObject as int
	start with 1
	increment by 1

    insert into [CH01-01-Dimension].[DimProduct]
    (
    [ProductKey],
    [ProductCategory],
	ProductSubcategory,
    [ProductSubcategoryKey],
    [ProductCode],
    [ProductName],
    [Color],
    [ModelName],
	UserAuthorizationKey
    )

    select
    next value for PkSequence.DimProductSequenceObject,
    x.[ProductCategory],
	x.[ProductSubcategory],
    x.[ProductSubcategoryKey],
    x.[ProductCode],
    x.[ProductName],
    x.[Color],
    x.[ModelName],
	@UserAuthorizationKey


    from 
	(
	select distinct 
	a.ProductCategory,
	a.ProductSubcategory,
	a.ProductCode, 
	a.ProductName, 
	a.Color,
	a.ModelName, 
	b.ProductSubCategoryKey 
	from FileUpload.OriginallyLoadedData As a
    inner join [CH01-01-Dimension].DimProductSubcategory as b 
	on a.ProductSubcategory = b.ProductSubcategory) as x;

	select @end = sysdatetime();
	
	declare @rowcount as int
	set @rowcount = (select count(*)
	from [CH01-01-Dimension].[DimProduct]);

	exec Process.usp_TrackWorkFlow 
	@WorkFlowDescription = 'Loading DimProduct table',
	@UserAuthorizationKey = @UserAuthorizationKey,
	@WorkFlowStepTableRowCount=@rowcount,
	@StartTime = @start,
	@EndTime = @end
END

go
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
	@UserAuthorizationKey = @UserAuthorizationKey,
	@WorkFlowStepTableRowCount = null

END;


go
-- =============================================
-- Author:		Nick Walton
-- Procedure:	[Project2].[TruncateTables]
-- Create date: 2022-04-04
-- Description:	Procedure to truncate table data before loading
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
		@UserAuthorizationKey = @UserAuthorizationKey,
		@WorkFlowStepTableRowCount = null

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

		exec Process.usp_TrackWorkFlow 
			@WorkFlowDescription = 'Loading SalesManagers table',
			@UserAuthorizationKey = @UserAuthorizationKey,
			@WorkFlowStepTableRowCount=null,
			@StartTime = @start,
			@EndTime = @end
end

go
-- =============================================
-- Author:		Andrew Zheng
-- Create date: 4/3
-- Description:	Stored Procedure (SalesManagers)
-- passed unit testing 04-06
-- fixed small typo (Maurizo -> Maurizio)
-- =============================================
drop procedure if exists [Project2].[Load_SalesManagers]
go
create PROCEDURE [Project2].[Load_SalesManagers] @UserAuthorizationKey int
    
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @start DATETIME2
    DECLARE @end DATETIME2;
    select @start=SYSDATETIME();
    create SEQUENCE PkSequence.SalesManagerSequenceObject
    as int start with 1
    increment by 1
    INSERT INTO [CH01-01-Dimension].[SalesManagers]
        
    
        (SalesManager, Category, Office,SalesManagerKey,UserAuthorizationKey)
    SELECT SalesManager, ProductsubCategory, Office=case

        when SalesManager LIKE N'Maurizio%' 
        or SalesManager LIKE N'Marco%'
        Then 
        'Redmond'
        When SalesManager Like N'Alberto%'
        Or SalesManager Like N'Luis%' THEN
        'Seattle'
        
        END,
    next VALUE for PkSequence.SalesManagerSequenceObject, @UserAuthorizationKey
    
    from (Select distinct SalesManager,ProductSubCategory FROM FileUpload.OriginallyLoadedData)
    As A

        --And Office is NULL
        --And Category is NULL
    select @end = sysdatetime();

	declare @rowcount as int
	set @rowcount = (select count(*)
	from [CH01-01-Dimension].[SalesManagers]);

exec Process.usp_TrackWorkFlow 
@WorkFlowDescription = 'Loading SalesManagers table',
@UserAuthorizationKey = @UserAuthorizationKey,
@WorkFlowStepTableRowCount=@rowcount,
@StartTime = @start,
@EndTime = @end

END
GO

-- =============================================
-- Author: Manna Sebastian & Sophia Paul
-- Create date: April 4, 2022
-- Description:	Add the necessary information to the DimMaritalStatus table
-- Passed unit testing 04-06. Took out sequence (not needed) 
-- =============================================

DROP PROCEDURE IF EXISTS [Project2].[Load_DimMaritalStatus]
GO
CREATE PROCEDURE [Project2].[Load_DimMaritalStatus] @UserAuthorizationKey INT
AS
BEGIN

	SET NOCOUNT ON;
    DECLARE @start datetime2;
    DECLARE @end datetime2;

    SELECT @start = SYSDATETIME();

	INSERT INTO [CH01-01-Dimension].DimMaritalStatus (MaritalStatus, MaritalStatusDescription, UserAuthorizationKey)

    SELECT MaritalStatus,
    MaritalStatusDescription = CASE
        WHEN MaritalStatus = 'M' THEN 
            'Married'
        ELSE 
            'Single'
    END, @UserAuthorizationKey

    FROM 
    (SELECT DISTINCT MaritalStatus FROM FileUpload.OriginallyLoadedData)
    AS A

	SELECT @end = SYSDATETIME();

    DECLARE @rowcount AS INT 
    SET @rowcount = (SELECT count(*)
    FROM [CH01-01-Dimension].[DimMaritalStatus]);

    EXEC [Process].[usp_TrackWorkFlow]
     @StartTime = @start,
     @EndTime = @end,
     @WorkFlowDescription = 'Load DimMaritalStatus',
     @WorkFlowStepTableRowCount = @rowcount,
     @UserAuthorizationKey = @UserAuthorizationKey

END
go
-- =============================================
-- Author: Manna Sebastian
-- Create date: April 4, 2022
-- Description:	Add the necessary information to the DimGender table
-- Passed unit testing 04-06. Removed unneeded sequence
-- =============================================
DROP PROCEDURE IF EXISTS [Project2].[Load_DimGender]
GO
CREATE PROCEDURE [Project2].[Load_DimGender] @UserAuthorizationKey INT
AS
BEGIN

	SET NOCOUNT ON;
    DECLARE @start datetime2;
    DECLARE @end DATETIME2;

    SELECT @start = SYSDATETIME();

	INSERT INTO [CH01-01-Dimension].DimGender (Gender, GenderDescription, UserAuthorizationKey)

    SELECT Gender,
    GenderDescription = CASE
    WHEN Gender = 'F' THEN 
        'Female'
    ELSE 
        'Male'
    END, @UserAuthorizationKey
    
    FROM
    (SELECT DISTINCT Gender FROM FileUpload.OriginallyLoadedData)
    As G

	SELECT @end = SYSDATETIME();

    DECLARE @rowcount AS INT 
    SET @rowcount = (SELECT count(*)
    FROM [CH01-01-Dimension].[DimGender]);

    EXEC [Process].[usp_TrackWorkFlow]
     @StartTime = @start,
     @EndTime = @end,
     @WorkFlowDescription = 'Load DimGender Table',
     @WorkFlowStepTableRowCount = @rowcount,
     @UserAuthorizationKey = @UserAuthorizationKey
END

go
-- =============================================
-- Author:		Nick Walton
-- Procedure:	[Project2].[LoadTerritory]
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

go
-- =============================================
-- Author:		Ivan Hossain
-- Create date: 4/5
-- Description:	Stored Procedure (DimCustomers)
-- Passed unit testing 04-06
-- =============================================
drop procedure if exists [Project2].[Load_DimCustomer]
go
create PROCEDURE [Project2].[Load_DimCustomer] @UserAuthorizationKey int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @start DATETIME2
	DECLARE @end DATETIME2;
	select @start=SYSDATETIME();

	drop sequence if exists PkSequence.CustomerSequenceObject
	CREATE SEQUENCE PkSequence.CustomerSequenceObject
	as int start with 1
	INCREMENT BY 1

	INSERT INTO [CH01-01-Dimension].[DimCustomer]
		(CustomerName, CustomerKey, UserAuthorizationKey)
	SELECT A.CustomerName,
		NEXT VALUE for PkSequence.CustomerSequenceObject, @UserAuthorizationKey

	FROM (SELECT DISTINCT CustomerName
		FROM FileUpload.OriginallyLoadedData) as A

	select @end = sysdatetime();

	declare @rowcount as int
	set @rowcount = (select count(*)
	from [CH01-01-Dimension].[DimCustomer]);

exec Process.usp_TrackWorkFlow 
@WorkFlowDescription = 'Loading DimCustomer',
@UserAuthorizationKey = @UserAuthorizationKey,
@WorkFlowStepTableRowCount=@rowcount,
@StartTime = @start,
@EndTime = @end

END

go
-- =============================================
-- Author:		Ivan Hossain
-- Create date: 4/5
-- Description:	Stored Procedure (DimOccupation)
-- =============================================

drop procedure if exists [Project2].[Load_DimOccupation]
go
create PROCEDURE [Project2].[Load_DimOccupation] @UserAuthorizationKey int
AS
BEGIN

	SET NOCOUNT ON;
    DECLARE @start DATETIME2
    DECLARE @end DATETIME2;
    select @start=SYSDATETIME();

	DROP SEQUENCE if EXISTS PkSequence.DimOccupationSequenceObject
	CREATE SEQUENCE PkSequence.DimOccupationSequenceObject
	as int start with 1
	INCREMENT BY 1

	INSERT INTO [CH01-01-Dimension].[DimOccupation]
        (Occupation, OccupationKey, UserAuthorizationKey)
    SELECT Occupation, 
	NEXT VALUE for Project2.DimOccupationSequenceObject, @UserAuthorizationKey
	FROM (SELECT DISTINCT Occupation FROM FileUpload.OriginallyLoadedData) AS A
    
    select @end = sysdatetime();

	declare @rowcount as int 
	set @rowcount = (select count(*)
	from [CH01-01-Dimension].[DimOccupation]);


exec Process.usp_TrackWorkFlow 
@WorkFlowDescription = 'Loading DimOccupation',
@UserAuthorizationKey = @UserAuthorizationKey,
@WorkFlowStepTableRowCount=@rowcount,
@StartTime = @start,
@EndTime = @end

END

go

-- =============================================
-- Author:		Nick Walton
-- Procedure:	[Project2].[Load_Data]
-- Create date: 2022-04-04
-- Description:	Loads Fact.Data
-- =============================================
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

go
drop procedure if exists [Project2].[LoadStarSchemaData]
go
create procedure [Project2].[LoadStarSchemaData]
    -- Add the parameters for the stored procedure here
AS
BEGIN
    SET NOCOUNT ON;
	declare @start datetime2,
			@end datetime2;
	select @start = sysdatetime();

	-- Must create these 2 tables before counting rows
	EXEC  [Project2].[Load_DimProductCategory] @UserAuthorizationKey = 4;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimProductSubcategory] @UserAuthorizationKey = 4;  -- Change -1 to the appropriate UserAuthorizationKey

	-- Get row counts for all tables
	EXEC	[Project2].[ShowTableStatusRowCount]
		@UserAuthorizationKey = 4,  -- Change -1 to the appropriate UserAuthorizationKey
		@TableStatus = N'''Pre-truncate of tables'''
    --
    --	Drop FKs, truncate, create DBSecurity table, Replace PKs with sequence columns
 	--

    EXEC  [Project2].[DropForeignKeysFromStarSchemaData] @UserAuthorizationKey = 4;
	EXEC  [Project2].[TruncateStarSchemaData] @UserAuthorizationKey = 4;
	--
	exec Project2.CreateDBSecurityAuthorizationTable @UserAuthorizationKey = 1;
	exec Project2.ReplacePKsWithSequenceColumns @UserAuthorizationKey = 4;
    --
    --	Always truncate the Star Schema Data
    --

    --
    --	Load the star schema
    --

    EXEC  [Project2].[Load_DimProduct] @UserAuthorizationKey = 5;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_SalesManagers] @UserAuthorizationKey = 1;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimGender] @UserAuthorizationKey = 7;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimMaritalStatus] @UserAuthorizationKey = 2;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimOccupation] @UserAuthorizationKey = 3;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimOrderDate] @UserAuthorizationKey = 5;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimTerritory] @UserAuthorizationKey = 4;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimCustomer] @UserAuthorizationKey = 3;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_Data] @UserAuthorizationKey = 4;  -- Change -1 to the appropriate UserAuthorizationKey
  --
    --	Recreate all of the foreign keys prior after loading the star schema
    --
 	--
	--	Check row count before truncation
	EXEC	[Project2].[ShowTableStatusRowCount]
		@UserAuthorizationKey = 4,  -- Change -1 to the appropriate UserAuthorizationKey
		@TableStatus = N'''Row Count after loading the star schema'''
	--
   EXEC [Project2].[AddForeignKeysToStarSchemaData] @UserAuthorizationKey = 1;  -- Change -1 to the appropriate UserAuthorizationKey

   select @end = sysdatetime();

   	    exec [Process].[usp_TrackWorkFlow]
			@StartTime = @start,
			@EndTime = @end,
			@WorkFlowDescription = 'Executing LoadStarSchemaData',
			@UserAuthorizationKey = 0,
			@WorkFlowStepTableRowCount = null

    --
END;


GO
drop procedure if exists [Project2].[ShowTableStatusRowCount] 
go
create procedure [Project2].[ShowTableStatusRowCount] 
@UserAuthorizationKey int,
@TableStatus VARCHAR(64)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @start datetime2,
			@end datetime2

	select @start = sysdatetime();


	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimCustomer', COUNT(*) FROM [CH01-01-Dimension].DimCustomer
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimGender', COUNT(*) FROM [CH01-01-Dimension].DimGender
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimMaritalStatus', COUNT(*) FROM [CH01-01-Dimension].DimMaritalStatus
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimOccupation', COUNT(*) FROM [CH01-01-Dimension].DimOccupation
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimOrderDate', COUNT(*) FROM [CH01-01-Dimension].DimOrderDate
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimProduct', COUNT(*) FROM [CH01-01-Dimension].DimProduct
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimProductCategory', COUNT(*) FROM [CH01-01-Dimension].DimProductCategory
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimProductSubcategory', COUNT(*) FROM [CH01-01-Dimension].DimProductSubcategory
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimTerritory', COUNT(*) FROM [CH01-01-Dimension].DimTerritory
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.SalesManagers', COUNT(*) FROM [CH01-01-Dimension].SalesManagers
	select TableStatus = @TableStatus, TableName ='CH01-01-Fact.Data', COUNT(*) FROM [CH01-01-Fact].Data

	select @end = sysdatetime();

	    exec [Process].[usp_TrackWorkFlow]
		@StartTime = @start,
		@EndTime = @end,
		@WorkFlowDescription = 'Executing ShowTableStatusRowCount',
		@UserAuthorizationKey = @UserAuthorizationKey,
		@WorkFlowStepTableRowCount = null

END


go

--DROP ADDED
drop procedure if exists [Process].[usp_ShowWorkflowSteps];
go

CREATE PROCEDURE [Process].[usp_ShowWorkflowSteps]
AS

    SELECT * FROM process.workflowsteps;

    select DATEDIFF(second, min(StartingDateTime), max(EndingDateTime)) as TimeElapsedSeconds,  DATEDIFF(second, min(StartingDateTime), max(EndingDateTime)) / 60 as TimeElapsedMinutes
	from Process.WorkflowSteps

    select  db.GroupMemberFirstName, 
    db.UserAuthorizationKey, 
    count(WorkFlowStepKey) as NumProcedures, 
    sum(datediff(millisecond, StartingDateTime, EndingDateTime)) / 1000 as executionTimeInSeconds, 
    sum(datediff(MILLISECOND, StartingDateTime, EndingDateTime)) as executionTimeInMS
    from process.WorkflowSteps as wfs
    left join DbSecurity.UserAuthorization as db
    on db.UserAuthorizationKey = wfs.UserAuthorizationKey
    group by db.UserAuthorizationKey, db.GroupMemberFirstName

GO

end