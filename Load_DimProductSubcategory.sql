drop procedure if exists [Project2].[CreateProductSubcategory];
go
create procedure [Project2].[CreateProductSubcategory] @UserAuthorizationKey INT
as
begin
	declare @start datetime2,
			@end datetime2,
			@rowcount int
	select @start = sysdatetime();
	
	drop sequence if exists [PkSequence].[DimProductSubcategorySequenceObject]
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