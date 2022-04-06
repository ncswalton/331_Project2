-- =============================================
-- Author:		Ivan Hossain
-- Create date: 4/5
-- Description:	Stored Procedure (DimOccupation)
-- =============================================
go
drop procedure if exists [Project2].[Load_DimOccupation]
go
create PROCEDURE [Project2].[Load_DimOccupation] @UserAuthorizationKey int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    DECLARE @start DATETIME2
    DECLARE @end DATETIME2;
    select @start=SYSDATETIME();

	DROP SEQUENCE if EXISTS PkSequence.DimOccupationSequenceObject
	CREATE SEQUENCE PkSequence.DimOccupationSequenceObject
	as int start with 1
	INCREMENT BY 1

	INSERT INTO [CH01-01-Dimension].[DimOccupation]
        (Occupation, OccupationKey)
    SELECT Occupation, 
	NEXT VALUE for Project2.DimOccupationSequenceObject 
	FROM (SELECT DISTINCT Occupation FROM FileUpload.OriginallyLoadedData) AS A
    
    select @end = sysdatetime();

	--declare @rowcount as int 
	--set @rowcount = (select count(*)
	--from [CH01-01-Dimension].[DimCustomer]);


exec Process.usp_TrackWorkFlow 
@WorkFlowDescription = 'Loading DimOccupation',
@UserAuthorizationKey = @UserAuthorizationKey,
--@WorkFlowStepTableRowCount=@rowcount
@StartTime = @start,
@EndTime = @end

END
