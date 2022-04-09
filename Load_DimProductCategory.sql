-- =============================================
-- Author:		Nick Walton
-- Procedure:	[Project2].[CreateProductCategory]
-- Create date: 2022-04-04
-- Description:	Creates the ProductCategory table
-- Passed unit testing 04-06
-- =============================================
drop procedure if exists [Project2].[CreateProductCategory]
go
create procedure [Project2].[CreateProductCategory] @UserAuthorizationKey int
as
begin

	declare @start datetime2,
			@end datetime2,
			@rowcount int
	select @start = sysdatetime();

	drop sequence if exists [PkSequence].[DimProductCategorySequenceObject]
	create sequence [PkSequence].[DimProductCategorySequenceObject]
	as int
	start with 1
	increment by 1

	drop table if exists [CH01-01-Dimension].[DimProductCategory];
	create table [CH01-01-Dimension].[DimProductCategory]
	(
	[ProductCategoryKey] int not null primary key,
	[ProductCategory] varchar(20) not null,
	UserAuthorizationKey int not null default(-1),
	DateAdded datetime2 null default(sysdatetime()),
	DateOfLastUpdate datetime2 null default(sysdatetime())
	)


	insert into [CH01-01-Dimension].[DimProductCategory]
	(
	ProductCategoryKey,
	ProductCategory,
	UserAuthorizationKey
	)
	select
		next value for [PkSequence].[DimProductCategorySequenceObject],
		fu.ProductCategory,
		@UserAuthorizationKey
	from
		(select distinct ProductCategory
		from FileUpload.OriginallyLoadedData) as fu

	select @end = sysdatetime();

	select @rowcount = count(*) from [CH01-01-Dimension].DimProductCategory

	exec [Process].usp_TrackWorkFlow 
		@StartTime = @start,
		@EndTime = @end,
		@WorkFlowDescription = 'Created [DimProductCategory] table',
		@UserAuthorizationKey = @UserAuthorizationKey,
		@WorkFlowStepTableRowCount = @rowcount
end;
