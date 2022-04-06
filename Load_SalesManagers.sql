-- =============================================
-- Author:		Andrew Zheng
-- Create date: 4/3
-- Description:	Stored Procedure (SalesManagers)
-- passed unit testing 04-06
-- fixed small typo (Maurizo -> Maurizio)
-- =============================================
go
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
        
    
        (SalesManager, Category, Office,SalesManagerKey)
    SELECT SalesManager, ProductsubCategory, Office=case

        when SalesManager LIKE N'Maurizio%' 
        or SalesManager LIKE N'Marco%'
        Then 
        'Redmond'
        When SalesManager Like N'Alberto%'
        Or SalesManager Like N'Luis%' THEN
        'Seattle'
        
        END,
    next VALUE for PkSequence.SalesManagerSequenceObject
    
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