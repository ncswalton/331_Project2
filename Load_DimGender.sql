-- =============================================
-- Author: Manna Sebastian
-- Create date: April 4, 2022
-- Description:	Add the necessary information to the DimGender table
-- Passed unit testing 04-06. Removed unneeded sequence
-- =============================================
go
drop procedure if exists [Project2].[Load_DimGender]
go
create PROCEDURE [Project2].[Load_DimGender] @UserAuthorizationKey INT
AS
BEGIN

	SET NOCOUNT ON;
    DECLARE @start datetime2;
    DECLARE @end DATETIME2;

    SELECT @start = SYSDATETIME();

	INSERT INTO [CH01-01-Dimension].DimGender (Gender, GenderDescription)

    SELECT Gender,
    GenderDescription = CASE
    WHEN Gender = 'F' THEN 
        'Female'
    ELSE 
        'Male'
    END
    FROM
    (SELECT DISTINCT Gender FROM FileUpload.OriginallyLoadedData)
    As G


	SELECT @end = SYSDATETIME();


    EXEC [Process].[usp_TrackWorkFlow]
     @StartTime = @start,
     @EndTime = @end,
     @WorkFlowDescription = 'Load DimGender',
     @UserAuthorizationKey = @UserAuthorizationKey
END
