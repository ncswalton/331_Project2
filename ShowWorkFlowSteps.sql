drop procedure if exists [Process].[usp_ShowWorkflowSteps];
go

CREATE PROCEDURE [Process].[usp_ShowWorkflowSteps]
AS

    SELECT * FROM process.workflowsteps;

    select DATEDIFF(second, min(StartingDateTime), max(EndingDateTime)) as TimeElapsedSeconds,  DATEDIFF(second, min(StartingDateTime), max(EndingDateTime)) / 60 as TimeElapsedMinutes
	from Process.WorkflowSteps

    select  db.GroupMemberFirstName, 
    db.UserAuthorizationKey, 
    count(WorkFlowStepKey) as NumProcedures, 
    sum(datediff(millisecond, StartingDateTime, EndingDateTime)) / 1000 as executionTimeInSeconds, 
    sum(datediff(MILLISECOND, StartingDateTime, EndingDateTime)) as executionTimeInMS
    from process.WorkflowSteps as wfs
    left join DbSecurity.UserAuthorization as db
    on db.UserAuthorizationKey = wfs.UserAuthorizationKey
    group by db.UserAuthorizationKey, db.GroupMemberFirstName

GO

end