drop procedure if exists [Project2].[AddColumns];
go
create procedure [Project2].[AddColumns] @UserAuthorizationKey INT
	as
	begin

	begin
		alter table [CH01-01-Dimension].[DimCustomer]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

	begin
		alter table [CH01-01-Dimension].[DimMaritalStatus]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

	begin
		alter table [CH01-01-Dimension].[DimGender]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

	begin
		alter table [CH01-01-Dimension].[DimOccupation]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

	begin
		alter table [CH01-01-Dimension].[DimOrderDate]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

	begin
		alter table [CH01-01-Dimension].[DimProduct]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

	begin
		alter table [CH01-01-Dimension].[DimTerritory]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

	begin
		alter table [CH01-01-Dimension].[SalesManagers]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

	begin
		alter table [CH01-01-Fact].[Data]
		add [UserAuthorizationKey] int not null default(-1),
		DateAdded datetime2 null default(sysdatetime()),
		DateOfLastUpdate datetime2 null default(sysdatetime());
	end;

end