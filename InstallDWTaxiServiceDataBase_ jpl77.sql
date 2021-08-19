USE [master]
GO
/****** Object:  Database [DWTaxiServiceTrips]    Script Date: 10/05/2020 9:49:20 PM ******/

if EXISTS (SELECT name from sys.databases WHERE name = N'BISolutionWorksheet_TaxiService_jpl77')
	BEGIN
		-- CLOSE CONNECTION TO THE DWTAXISERVICETRIPS DATABASE
		ALTER DATABASE [BISolutionWorksheet_TaxiService_jpl77] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE [BISolutionWorksheet_TaxiService_jpl77]
	END
GO

CREATE DATABASE [BISolutionWorksheet_TaxiService_jpl77]
GO



--create the DWTaxiServiceTrips Tables

USE [BISolutionWorksheet_TaxiService_jpl77]
GO

/****** Create the Dimension Tables ******/

CREATE TABLE dbo.DimStreet
(
	Street_Code	int NOT NULL PRIMARY KEY Identity,
	StreetName		nchar(4) NOT NULL,
	ZipCode	nvarchar(50) NOT NULL,
	City_Code	nChar(2) NOT NULL,
)
	
GO

CREATE TABLE dbo.DimTime
(
	PickupTimeKey 		int NOT NULL PRIMARY KEY Identity,
	PickupHour		nchar(4) NOT NULL,
	PickupMinute	nvarchar(50) NOT NULL,
	PickupSecond	nVarChar(50) NOT NULL,
	eveningmorning nVarChar(50) NOT NULL,
) 
GO

CREATE TABLE dbo.DimDriver
(
	DriverId	int NOT NULL PRIMARY KEY Identity,
	LastName 	nvarchar(50) NOT NULL,
	FirstName  nvarchar(50) NOT NULL, 
	DateOfBirth   nvarchar(5) NOT NULL,

) 
GO

CREATE TABLE dbo.DimCity
(
	City_Code		int NOT NULL PRIMARY KEY Identity,
	CountryName		nvarchar(6) NOT NULL,
	CityName		nvarchar(100) NOT NULL,
)
GO

/****** Create the Fact Tables ******/

CREATE TABLE dbo.FactTrips
(
	TripNumber	int not null identity,
	TripCharge	nvarchar(50) NOT NULL,
	TripDateKey	int NOT NULL,
	TripMileage		int NOT NULL,
	PaymentNumber		int NOT NULL,
	StreetCode	int NOT NULL,
	PickupTimeKey		int NOT NULL,
	DriverId	int NOT NULL,
 	CONSTRAINT [PK_FactTrips] PRIMARY KEY ([TripNumber] asc) 

)

GO

-- We should create a date dimension table in the database
CREATE TABLE dbo.DimDates 
(
  	TripDateKey		int NOT NULL PRIMARY KEY IDENTITY, 
  	Date		datetime NOT NULL,
  	[DateName]	nVarchar(50) NOT NULL,
  	Month		int NOT NULL,
  	MonthName	nVarchar(50) NOT NULL,
  	Quarter		int NOT NULL,
  	QuarterName	nVarchar(50) NOT NULL,
  	Year		int NOT NULL,
  	YearName	nVarchar(50) NOT NULL,
)
GO

/****** Add Foreign Keys ******/

Alter Table dbo.DimStreet With Check 
	Add Constraint [FK_DimCity_DimStreet] 
		Foreign Key (City_Code) References dbo.DimCity (City_Code)
Go

Alter Table dbo.FactTrips With Check 
	Add Constraint [FK_FactTrips_DimStreet] 
		Foreign Key (Street_Code) References dbo.DimStreet (Street_Code)
Go

Alter Table dbo.FactTrips With Check 
	Add Constraint [FK_FactTrips_DimDriver] 
		Foreign Key (DriverId) References dbo.DimDriver (DriverId)
Go
Alter Table dbo.FactTrips With Check 
	Add Constraint [FK_FactTrips_DimDates] 
		Foreign Key (TripDateKey) References dbo.DimDates (TripDateKey)
Go
Alter Table dbo.FactTrips  With Check 
	Add Constraint [FK_FactTrips_DimTime] 
		Foreign Key (PickupTimeKey) References dbo.DimTime (PickupTimeKey) 
Go


-- All done! -- 
Select Message = 'The DWTaxiServiceTrips data warehouse is now created'