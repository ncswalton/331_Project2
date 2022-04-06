-- =============================================
-- Author:		Nick Walton
-- Create date: 2022-04-05
-- Description:	Creates Process.WorkFlowSteps table 
-- passed unit testing
-- =============================================
go
drop procedure if exists [Process].[CreateWorkFlowStepsTable]
go
create PROCEDURE [Process].[CreateWorkFlowStepsTable] @UserAuthorizationKey int
	AS
BEGIN
	SET NOCOUNT ON;
	
	exec [Process].[WorkFlowSeq]

	declare @start datetime2,
			@end datetime2,
			@rowcount int
	drop table if exists [Process].[WorkflowSteps]
	select @start = sysdatetime()
	CREATE TABLE [Process].[WorkflowSteps]
	(
		[WorkFlowStepKey] [int] NOT NULL identity(1,1),
		[WorkFlowStepDescription] [nvarchar](100) NOT NULL,
		[WorkFlowStepTableRowCount] [int] NULL default(0),
		[StartingDateTime] [datetime2](7) NULL default(sysdatetime()),
		[EndingDateTime] [datetime2](7) NULL default(sysdatetime()),
		[Class Time] [char](5) NULL default('10:45'),
		[UserAuthorizationKey] [int] NOT NULL
		constraint PK_WorkFlowStep
			primary key(WorkFlowStepKey)
	)
	select @rowcount = count(*) from Process.WorkflowSteps

	select @end = sysdatetime()
	
	insert into [Process].[WorkflowSteps]
	(
	WorkFlowStepTableRowCount,
	WorkFlowStepDescription,
	UserAuthorizationKey,
	StartingDateTime,
	EndingDateTime
	)
	values
	(
	@rowcount,
	'Creating [Process].[WorkflowSteps] table',
	@UserAuthorizationKey,
	@start,
	@end
	)
END