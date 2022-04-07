USE [BIClass]
GO
/****** Object:  StoredProcedure [Project2].[Load_DimMaritalStatus]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Manna Sebastian
-- Create date: April 4, 2022
-- Description:	Add the necessary information to the DimGender table
-- Passed unit testing 04-06. Removed unneeded sequence
-- Added WorkFlowStepTableRowCount column & UserAuthorizationKey column
-- =============================================
GO
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
