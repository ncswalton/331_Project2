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
    [ModelName]
    )

    select
    next value for PkSequence.DimProductSequenceObject,
    x.[ProductCategory],
	x.[ProductSubcategory],
    x.[ProductSubcategoryKey],
    x.[ProductCode],
    x.[ProductName],
    x.[Color],
    x.[ModelName]


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

    exec Process.usp_TrackWorkFlow
	@StartTime = @start,
    @EndTime = @end,
    @WorkFlowDescription = 'Loading DimProduct table',
    @userAuthorizationkey = @UserAuthorizationkey
    
END
