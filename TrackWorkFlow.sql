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
