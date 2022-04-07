-- =============================================
-- Author:		Andrew Zheng
-- Create date: 4/5
-- Description:	Altering table to add constraint/foreign key
-- =============================================
go
drop procedure if exists Project2.AddForeignKeysToStarSchemaData
go
create PROCEDURE [Project2].[AddForeignKeysToStarSchemaData]

    @GroupMemberUserAuthorizationKey int
AS
   BEGIN
declare @start datetime2,
		@end datetime2;
select @start = sysdatetime();
		

    ALTER TABLE [CH01-01-Fact].[Data]  WITH CHECK ADD  CONSTRAINT [FK_Data_DimCustomer] FOREIGN KEY([CustomerKey])
	REFERENCES [CH01-01-Dimension].[DimCustomer] ([CustomerKey])

    ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimCustomer]

    ALTER TABLE [CH01-01-Fact].[Data]  WITH CHECK ADD  CONSTRAINT [FK_Data_DimGender] FOREIGN KEY([Gender])
	REFERENCES [CH01-01-Dimension].[DimGender] ([Gender])

    ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimGender]

    ALTER TABLE [CH01-01-Fact].[Data]  WITH CHECK ADD  CONSTRAINT [FK_Data_DimMaritalStatus] FOREIGN KEY([MaritalStatus])
	REFERENCES [CH01-01-Dimension].[DimMaritalStatus] ([MaritalStatus])

    ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimMaritalStatus]

    ALTER TABLE [CH01-01-Fact].[Data]  WITH CHECK ADD  CONSTRAINT [FK_Data_DimOccupation] FOREIGN KEY([OccupationKey])
	REFERENCES [CH01-01-Dimension].[DimOccupation] ([OccupationKey])

    ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimOccupation]



    ALTER TABLE [CH01-01-Fact].[Data]  WITH CHECK ADD  CONSTRAINT [FK_Data_DimTerritory] FOREIGN KEY([TerritoryKey])
	REFERENCES [CH01-01-Dimension].[DimTerritory] ([TerritoryKey])

    ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimTerritory]

    ALTER TABLE [CH01-01-Fact].[Data]  WITH CHECK ADD  CONSTRAINT [FK_Data_SalesManagers] FOREIGN KEY([SalesManagerKey])
	REFERENCES [CH01-01-Dimension].[SalesManagers] ([SalesManagerKey])

    ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_SalesManagers]
    
    ALTER TABLE [CH01-01-Fact].[Data]  WITH CHECK ADD  CONSTRAINT [FK_Data_DimOrderDate] FOREIGN KEY([OrderDate])
	REFERENCES [CH01-01-Dimension].[DimOrderDate] ([OrderDate])

    ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimOrderDate]
    ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory]  WITH CHECK ADD  CONSTRAINT [FK_DimProductSubcategory_DimProductCategory] FOREIGN KEY([ProductCategoryKey])
	REFERENCES [CH01-01-Dimension].[DimProductCategory] ([ProductCategoryKey])
    
    ALTER TABLE [CH01-01-Fact].[Data]  WITH CHECK ADD  CONSTRAINT [FK_Data_DimProduct] FOREIGN KEY([ProductKey])
	REFERENCES [CH01-01-Dimension].[DimProduct] ([ProductKey])

    ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimProduct]
    ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory] CHECK CONSTRAINT [FK_DimProductSubcategory_DimProductCategory]
    
    ALTER TABLE [CH01-01-Dimension].[DimProduct]  WITH CHECK ADD  CONSTRAINT [FK_DimProduct_DimProductSubcategory] FOREIGN KEY([ProductSubcategoryKey])
	REFERENCES [CH01-01-Dimension].[DimProductSubcategory] ([ProductSubcategoryKey])


    ALTER TABLE [CH01-01-Dimension].[DimProduct] CHECK CONSTRAINT [FK_DimProduct_DimProductSubcategory]

	select @end = sysdatetime();

exec [Process].[usp_TrackWorkFlow]
	@StartTime = @start,
	@EndTime = @end,
	@WorkFlowDescription = 'Adding FKs to Fact.Data',
	@UserAuthorizationKey = @GroupMemberUserAuthorizationKey

END
