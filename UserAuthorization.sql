-- =============================================
-- Author:		Andrew Zheng
-- Create date: 2022-04-03
-- Description:	Creates DBSecurity.UserAuthorization
-- passed unit testing
-- =============================================
	drop procedure if exists [Project2].[CreateDBSecurityAuthorizationTable]
		go
		drop procedure if exists [Project2].[CreateDBSecurityAuthorizationTable]
		go
			create procedure [Project2].[CreateDBSecurityAuthorizationTable] @UserAuthorizationKey int
			as
		begin
	-- Create Sequence Object for UserAuthorization Table
	declare @start datetime2,
			@end datetime2
	select @start = sysdatetime();
	drop table if exists DbSecurity.UserAuthorization
	CREATE TABLE DbSecurity.UserAuthorization(
		UserAuthorizationKey INT            NOT NULL    PRIMARY KEY,
		ClassTime            NCHAR(5)       NULL        DEFAULT '10:45',
		[Individual Project] NVARCHAR(60)   NULL        DEFAULT 'PROJECT 2 RECREATE THE BICLASS DATABASE STAR SCHEMA',
		GroupMemberLastName  NVARCHAR(35)   NOT NULL,
		GroupMemberFirstName NVARCHAR(25)   NOT NULL,
		GroupName            NVARCHAR(20)   NOT NULL    DEFAULT 'G10-C',
		DateAdded            DATETIME2      NULL        DEFAULT SYSDATETIME()
	);

	-- Insert Group Members into table
	INSERT INTO DbSecurity.UserAuthorization(
		UserAuthorizationKey,
		GroupMemberLastName,
		GroupMemberFirstName
	) VALUES
		(1, 'Zheng', 'Andrew'),
		(2, 'Paul', 'Spohia'),
		(3, 'Hossian', 'Ivan'),
		(4, 'Walton', 'Nick'),
		(5, 'Joseph', 'Joel'),
		(7, 'Sebastian', 'Manna');

	select @end = sysdatetime();
		exec Process.usp_TrackWorkFlow
			@StartTime = @start,
			@EndTime = @end,
			@WorkFlowDescription = 'Creating Db.SecurityAuthorization',
			@UserAuthorizationkey = @UserAuthorizationkey

	end
GO