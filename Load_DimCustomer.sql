-- =============================================
-- Author:		Ivan Hossain
-- Create date: 4/5
-- Description:	Stored Procedure (DimCustomers)
-- Passed unit testing 04-06
-- =============================================
go
drop procedure if exists [Project2].[Load_DimCustomer]
go
create PROCEDURE [Project2].[Load_DimCustomer] @UserAuthorizationKey int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @start DATETIME2
	DECLARE @end DATETIME2;
	select @start=SYSDATETIME();

	drop sequence if exists PkSequence.CustomerSequenceObject
	CREATE SEQUENCE PkSequence.CustomerSequenceObject
	as int start with 1
	INCREMENT BY 1

	INSERT INTO [CH01-01-Dimension].[DimCustomer]
		(CustomerName, CustomerKey, UserAuthorizationKey)
	SELECT A.CustomerName,
		NEXT VALUE for PkSequence.CustomerSequenceObject, @UserAuthorizationKey

	FROM (SELECT DISTINCT CustomerName
		FROM FileUpload.OriginallyLoadedData) as A

	select @end = sysdatetime();

	declare @rowcount as int
	set @rowcount = (select count(*)
	from [CH01-01-Dimension].[DimCustomer]);

exec Process.usp_TrackWorkFlow 
@WorkFlowDescription = 'Loading DimCustomer',
@UserAuthorizationKey = @UserAuthorizationKey,
@WorkFlowStepTableRowCount=@rowcount,
@StartTime = @start,
@EndTime = @end

END