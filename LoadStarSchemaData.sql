GO
-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
drop procedure if exists Project2.LoadStarSchemaData
go
create procedure [Project2].[LoadStarSchemaData]
    -- Add the parameters for the stored procedure here
AS
BEGIN
    SET NOCOUNT ON;
	declare @start datetime2,
			@end datetime2;
	select @start = sysdatetime();

	-- Must create these 2 tables before counting rows
	EXEC  [Project2].[Load_DimProductCategory] @UserAuthorizationKey = 4;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimProductSubcategory] @UserAuthorizationKey = 4;  -- Change -1 to the appropriate UserAuthorizationKey

	-- Get row counts for all tables
	EXEC	[Project2].[ShowTableStatusRowCount]
		@UserAuthorizationKey = 4,  -- Change -1 to the appropriate UserAuthorizationKey
		@TableStatus = N'''Pre-truncate of tables'''
    --
    --	Drop FKs, truncate, create DBSecurity table, Replace PKs with sequence columns
 	--

    EXEC  [Project2].[DropForeignKeysFromStarSchemaData] @UserAuthorizationKey = 4;
	EXEC  [Project2].[TruncateStarSchemaData] @UserAuthorizationKey = 4;
	--
	exec Project2.CreateDBSecurityAuthorizationTable @UserAuthorizationKey = 1;
	exec Project2.ReplacePKsWithSequenceColumns @UserAuthorizationKey = 4;
    --
    --	Always truncate the Star Schema Data
    --

    --
    --	Load the star schema
    --

    EXEC  [Project2].[Load_DimProduct] @UserAuthorizationKey = 5;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_SalesManagers] @UserAuthorizationKey = 1;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimGender] @UserAuthorizationKey = 7;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimMaritalStatus] @UserAuthorizationKey = 27;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimOccupation] @UserAuthorizationKey = 3;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimOrderDate] @UserAuthorizationKey = 5;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimTerritory] @UserAuthorizationKey = 4;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_DimCustomer] @UserAuthorizationKey = 3;  -- Change -1 to the appropriate UserAuthorizationKey
    EXEC  [Project2].[Load_Data] @UserAuthorizationKey = 4;  -- Change -1 to the appropriate UserAuthorizationKey
  --
    --	Recreate all of the foreign keys prior after loading the star schema
    --
 	--
	--	Check row count before truncation
	EXEC	[Project2].[ShowTableStatusRowCount]
		@UserAuthorizationKey = 4,  -- Change -1 to the appropriate UserAuthorizationKey
		@TableStatus = N'''Row Count after loading the star schema'''
	--
   EXEC [Project2].[AddForeignKeysToStarSchemaData] @UserAuthorizationKey = 1;  -- Change -1 to the appropriate UserAuthorizationKey

   select @end = sysdatetime();

   	    exec [Process].[usp_TrackWorkFlow]
			@StartTime = @start,
			@EndTime = @end,
			@WorkFlowDescription = 'Executing LoadStarSchemaData',
			@UserAuthorizationKey = 0,
			@WorkFlowStepTableRowCount = null

    --
END;