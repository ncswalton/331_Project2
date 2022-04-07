-- =============================================
-- Author: Manna Sebastian & Sophia Paul
-- Create date: April 4, 2022
-- Description:	Add the necessary information to the DimMaritalStatus table
-- Passed unit testing 04-06. Took out sequence (not needed) 
-- Added WorkFlowStepTableRowCount column & UserAuthorizationKey column
-- =============================================
USE BIClass

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