-- =============================================
-- Author: Manna Sebastian & Sophia Paul
-- Create date: April 4, 2022
-- Description:	Add the necessary information to the DimMaritalStatus table
-- Passed unit testing 04-06. Took out sequence (not needed) 
-- =============================================
use BIClass

drop procedure if exists [Project2].[Load_DimMaritalStatus]
go
create PROCEDURE [Project2].[Load_DimMaritalStatus] @UserAuthorizationKey INT
AS
BEGIN

	SET NOCOUNT ON;
    DECLARE @start datetime2;
    DECLARE @end datetime2;

    SELECT @start = SYSDATETIME();

	INSERT INTO [CH01-01-Dimension].DimMaritalStatus (MaritalStatus, MaritalStatusDescription)

    SELECT MaritalStatus,
    MaritalStatusDescription = CASE
        WHEN MaritalStatus = 'M' THEN 
            'Married'
        ELSE 
            'Single'
    END
    from 
    (SELECT DISTINCT MaritalStatus FROM FileUpload.OriginallyLoadedData)
    AS A

	SELECT @end = SYSDATETIME();


    EXEC [Process].[usp_TrackWorkFlow]
     @StartTime = @start,
     @EndTime = @end,
     @WorkFlowDescription = 'Load DimMaritalStatus',
     @UserAuthorizationKey = @UserAuthorizationKey

END