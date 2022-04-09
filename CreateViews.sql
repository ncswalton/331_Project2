

-- =============================================
-- Author:		<Sophia Paul>
-- Create date: <April 7, 2022>
-- Description:	<Creates Views for all the tables>
-- =============================================

	



declare @start datetime2
declare @end datetime2;
	
	DROP VIEW IF EXISTS [Project2].[CreateCustomerView]
	GO
	CREATE VIEW [Project2].[CreateCustomerView]
	AS 
	SELECT A.CustomerName
		FROM (SELECT DISTINCT CustomerName
		FROM FileUpload.OriginallyLoadedData) AS A
		GO
	
	DROP VIEW IF EXISTS [Project2].[CreateGenderView];
	GO
	CREATE VIEW [Project2].[CreateGenderView]
	AS

	SELECT Gender,
    GenderDescriptiON = CASE
    WHEN Gender = 'F' THEN 
        'Female'
    ELSE 
        'Male'
    END, @UserAuthorizationKey
    
    FROM
    (SELECT DISTINCT Gender FROM FileUpload.OriginallyLoadedData)
    AS G
	GO

	
	DROP VIEW IF EXISTS [Project2].[CreateMaritalStatusView];
	GO
	CREATE VIEW [Project2].[CreateMaritalStatusView]
	AS
	  SELECT MaritalStatus,
    MaritalStatusDescriptiON = CASE
        WHEN MaritalStatus = 'M' THEN 
            'Married'
        ELSE 
            'Single'
    END, @UserAuthorizationKey

    FROM 
    (SELECT DISTINCT MaritalStatus FROM FileUpload.OriginallyLoadedData)
    AS A
	GO

	
	DROP VIEW IF EXISTS [Project2].[CreateOccupationView];
		GO
	CREATE VIEW [Project2].[CreateOccupationView]
	AS
	  SELECT Occupation, @UserAuthorizationKey
	FROM (SELECT DISTINCT OccupatiON FROM FileUpload.OriginallyLoadedData) AS A
	GO

	DROP VIEW IF EXISTS [Project2].[CreateOrderDateView]
	GO
	CREATE VIEW [Project2].[CreateOrderDateView]
	AS
	SELECT distinct
	a.OrderDate,
	a.MonthName,
	a.MonthNumber,
	a.Year,
	@UserAuthorizationKey AS UserAuthorizationKey
	FROM FileUpload.OriginallyLoadedData AS a 
	GO

	DROP VIEW IF EXISTS [Project2].[CreateProductView]
	GO
	CREATE VIEW [Project2].[CreateProductView]
	AS
	SELECT
    x.[ProductCategory],
	x.[ProductSubcategory],
    x.[ProductSubcategoryKey],
    x.[ProductCode],
    x.[ProductName],
    x.[Color],
    x.[ModelName],
	@UserAuthorizationKey


    FROM 
	(
	SELECT DISTINT  
	a.ProductCategory,
	a.ProductSubcategory,
	a.ProductCode, 
	a.ProductName, 
	a.Color,
	a.ModelName, 
	b.ProductSubCategoryKey 
	FROM FileUpload.OriginallyLoadedData AS a
    inner join [CH01-01-Dimension].DimProductSubcategory AS b 
	ON a.ProductSubcategory = b.ProductSubcategory) AS x;
	GO

	DROP VIEW IF EXISTS [Project2].[CreateTerritoryView]
	GO
	CREATE VIEW [Project2].[CreateTerritoryView]
	AS
	SELECT
	query.TerritoryGroup,
	query.TerritoryCountry,
	query.TerritoryRegion,
	@UserAuthorizationKey
	FROM
	(
	SELECT DISTINCT
	fu.TerritoryGroup,
	fu.TerritoryCountry,
	fu.TerritoryRegion
	FROM FileUpload.OriginallyLoadedData AS fu) AS query
	GO

	DROP VIEW IF EXISTS [Project2].[CreateSalesManagerView]
	GO
	CREATE VIEW [Project2].[CreateSalesManagerView]
	AS
	SELECT SalesManager, ProductsubCategory, Office=CASE

        WHEN SalesManager LIKE N'Maurizio%' 
        or SalesManager LIKE N'Marco%'
        THEN
        'Redmond'
        WHEN SalesManager Like N'Alberto%'
        Or SalesManager Like N'Luis%' THEN
        'Seattle'
        
        END, @UserAuthorizationKey
    
    FROM (SELECT DISTINCT SalesManager,ProductSubCategory FROM FileUpload.OriginallyLoadedData) AS A;
	GO

	DROP VIEW IF EXISTS [Project2].[CreateCategoryView]
	GO
	CREATE VIEW [Project2].[CreateCategoryView]
	AS
	SELECT
		fu.ProductCategory,
		@UserAuthorizationKey 
	FROM
		(SELECT DISTINCT ProductCategory
		FROM FileUpload.OriginallyLoadedData) AS fu
		GO

	DROP VIEW IF EXISTS [Project2].[CreateSubcategoryView]
	GO
	CREATE VIEW [Project2].[CreateSubcategoryView]
	AS
		SELECT query.ProductCategoryKey, query.ProductSubcategory,
		   @UserAuthorizationKey
    FROM
    (
	SELECT DISTINCT fu.ProductCategory, fu.ProductSubcategory, pc.ProductCategoryKey
	FROM FileUpload.OriginallyLoadedData AS fu
	inner join [CH01-01-Dimension].[DimProductCategory] AS pc
	ON pc.ProductCategory = fu.ProductCategory
    ) AS query;
	GO

	DROP VIEW IF EXISTS [Project2].[CreateDataView]
	GO
	CREATE VIEW [Project2].[CreateDataView]
	AS
	SELECT
	sm.SalesManagerKey,
	do.OccupationKey,
	dt.TerritoryKey,
	dp.ProductKey,
	dc.CustomerKey,
	fu.ProductCategory,
	fu.SalesManager,
	fu.ProductSubcategory,
	fu.ProductCode,
	fu.ProductName,
	fu.Color,
	fu.ModelName,
	fu.OrderQuantity,
	fu.UnitPrice,
	fu.ProductStandardCost,
	fu.SalesAmount,
	fu.OrderDate,
	fu.MonthName,
	fu.MonthNumber,
	fu.Year,
	fu.CustomerName,
	fu.MaritalStatus,
	fu.Gender,
	fu.Education,
	fu.Occupation,
	fu.TerritoryRegion,
	fu.TerritoryCountry,
	fu.TerritoryGroup,
	@UserAuthorizationKey
FROM FileUpload.OriginallyLoadedData AS fu
inner join [CH01-01-Dimension].SalesManagers AS sm
ON fu.SalesManager = sm.SalesManager
and fu.ProductSubcategory = sm.Category
inner join [CH01-01-Dimension].DimProduct AS dp
ON fu.ProductName = dp.ProductName
inner join [CH01-01-Dimension].DimCustomer AS dc
ON fu.CustomerName = dc.CustomerName
inner join [CH01-01-Dimension].DimOccupatiON AS do
ON fu.OccupatiON = do.Occupation
inner join [CH01-01-Dimension].DimTerritory AS dt
ON fu.TerritoryRegiON = dt.TerritoryRegion
and fu.TerritoryCountry = dt.TerritoryCountry
and fu.TerritoryGroup = dt.TerritoryGroup
GO
