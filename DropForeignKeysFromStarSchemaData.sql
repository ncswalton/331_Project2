-- =============================================
-- Author:		Nick Walton
-- Create date: 2022-04-05
-- Description:	Drop the Foreign Keys From the Star Schema
-- =============================================
go
drop procedure if exists [Project2].[DropForeignKeysFromStarSchemaData]
go
create PROCEDURE [Project2].[DropForeignKeysFromStarSchemaData] @UserAuthorizationKey int
AS
BEGIN

declare @start datetime2,
		@end datetime2;
select @start = sysdatetime();

    SET NOCOUNT ON;
	alter table [CH01-01-Fact].[Data] drop constraint FK_Data_DimCustomer;
	alter table [CH01-01-Fact].[Data] drop constraint FK_Data_DimGender;
	alter table [CH01-01-Fact].[Data] drop constraint FK_Data_DimMaritalStatus;
	alter table [CH01-01-Fact].[Data] drop constraint FK_Data_DimOccupation;
	alter table [CH01-01-Fact].[Data] drop constraint FK_Data_DimProduct;
	alter table [CH01-01-Fact].[Data] drop constraint FK_Data_SalesManagers;
	alter table [CH01-01-Fact].[Data] drop constraint FK_Data_DimTerritory;
	alter table [CH01-01-Fact].[Data] drop constraint FK_Data_DimOrderDate;

select @end = sysdatetime();

exec [Process].usp_TrackWorkFlow 
	@StartTime = @start, 
	@EndTime = @end, 
	@WorkFlowDescription = 'Dropped FKs from Fact.Data table',
	@UserAuthorizationKey = @UserAuthorizationKey;

END;
