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
