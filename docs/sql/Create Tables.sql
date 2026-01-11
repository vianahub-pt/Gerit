CREATE TABLE dbo.Users (
    UserId				UNIQUEIDENTIFIER	NOT NULL CONSTRAINT PK_Users PRIMARY KEY,
    Email				NVARCHAR(255)		NOT NULL UNIQUE,
    PasswordHash		NVARCHAR(500)		NOT NULL,
    FullName			NVARCHAR(150)		NOT NULL,
    IsActive			BIT					NOT NULL DEFAULT 1,
    CreatedAt			DATETIME2			NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TABLE dbo.Roles (
    RoleId				INT IDENTITY(1,1) CONSTRAINT PK_Roles PRIMARY KEY,
    Name				NVARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE dbo.UserRoles (
    UserId				UNIQUEIDENTIFIER NOT NULL,
    RoleId				INT NOT NULL,
    CONSTRAINT PK_UserRoles PRIMARY KEY (UserId, RoleId),
    CONSTRAINT FK_UserRoles_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),
    CONSTRAINT FK_UserRoles_Roles FOREIGN KEY (RoleId) REFERENCES dbo.Roles(RoleId)
);
GO
CREATE TABLE dbo.Clients (
    ClientId			UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_Clients PRIMARY KEY,
    OwnerUserId			UNIQUEIDENTIFIER NOT NULL,
    Name				NVARCHAR(150) NOT NULL,
    Email				NVARCHAR(255),
    Phone				NVARCHAR(50),
    TaxNumber			NVARCHAR(20),
    Address				NVARCHAR(255),
    ConsentStatus		NVARCHAR(50) NOT NULL,
    CreatedAt			DATETIME2 NOT NULL,
    CONSTRAINT FK_Clients_Users FOREIGN KEY (OwnerUserId) REFERENCES dbo.Users(UserId)
);
GO
CREATE TABLE dbo.TeamMembers (
    TeamMemberId		UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_TeamMembers PRIMARY KEY,
    OwnerUserId			UNIQUEIDENTIFIER NOT NULL,
    FullName			NVARCHAR(150) NOT NULL,
    Role				NVARCHAR(100),
    Email				NVARCHAR(255),
    Phone				NVARCHAR(50),
    IsActive			BIT NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_TeamMembers_Users FOREIGN KEY (OwnerUserId) REFERENCES dbo.Users(UserId)
);
GO
CREATE TABLE dbo.Vehicles (
    VehicleId			UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_Vehicles PRIMARY KEY,
    OwnerUserId			UNIQUEIDENTIFIER NOT NULL,
    LicensePlate		NVARCHAR(20) NOT NULL,
    Brand				NVARCHAR(100),
    Model				NVARCHAR(100),
    ManufacturingYear	INT,
    Status				NVARCHAR(50) NOT NULL,
    Notes				NVARCHAR(255),
    CreatedAt			DATETIME2 NOT NULL,
    CONSTRAINT FK_Vehicles_Users FOREIGN KEY (OwnerUserId) REFERENCES dbo.Users(UserId)
);
GO
CREATE TABLE dbo.Equipment (
    EquipmentId			UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_Equipment PRIMARY KEY,
    OwnerUserId			UNIQUEIDENTIFIER NOT NULL,
    Name				NVARCHAR(150) NOT NULL,
    Type				NVARCHAR(100),
    SerialNumber		NVARCHAR(100),
    Status				NVARCHAR(50) NOT NULL,
    CreatedAt			DATETIME2 NOT NULL,
    CONSTRAINT FK_Equipment_Users FOREIGN KEY (OwnerUserId) REFERENCES dbo.Users(UserId)
);
GO
CREATE TABLE dbo.Interventions (
    InterventionId		UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_Interventions PRIMARY KEY,
    OwnerUserId			UNIQUEIDENTIFIER NOT NULL,
    ClientId			UNIQUEIDENTIFIER NOT NULL,
    ResponsibleMemberId UNIQUEIDENTIFIER NOT NULL,
    VehicleId			UNIQUEIDENTIFIER,
	Title				NVARCHAR(200) NOT NULL,
    Description			NVARCHAR(500) NOT NULL,
    Status				NVARCHAR(50) NOT NULL,
    StartDateTime		DATETIME2 NOT NULL,
    EndDateTime			DATETIME2,
    Address				NVARCHAR(255),
    EstimatedValue		DECIMAL(10,2),
    CreatedAt			DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Interventions_Clients FOREIGN KEY (ClientId) REFERENCES dbo.Clients(ClientId),
    CONSTRAINT FK_Interventions_TeamMembers_Responsible FOREIGN KEY (ResponsibleMemberId) REFERENCES dbo.TeamMembers(TeamMemberId),
    CONSTRAINT FK_Interventions_Vehicles FOREIGN KEY (VehicleId) REFERENCES dbo.Vehicles(VehicleId),
    CONSTRAINT FK_Interventions_Users FOREIGN KEY (OwnerUserId) REFERENCES dbo.Users(UserId)
);
GO
CREATE TABLE dbo.InterventionEquipment (
    InterventionId		UNIQUEIDENTIFIER NOT NULL,
    EquipmentId			UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT PK_InterventionEquipment PRIMARY KEY (InterventionId, EquipmentId),
    CONSTRAINT FK_IE_Interventions FOREIGN KEY (InterventionId) REFERENCES dbo.Interventions(InterventionId),
    CONSTRAINT FK_IE_Equipment FOREIGN KEY (EquipmentId) REFERENCES dbo.Equipment(EquipmentId)
);
GO
CREATE FUNCTION dbo.fn_RLS_UserIsolation (
    @OwnerUserId UNIQUEIDENTIFIER
)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
(
    SELECT 1 AS AccessGranted
    WHERE @OwnerUserId =
          CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId'))
);
GO
CREATE SECURITY POLICY dbo.RLS_Clients
ADD FILTER PREDICATE dbo.fn_RLS_UserIsolation(OwnerUserId)
    ON dbo.Clients,
ADD BLOCK PREDICATE dbo.fn_RLS_UserIsolation(OwnerUserId)
    ON dbo.Clients
WITH (STATE = ON);
GO

CREATE SECURITY POLICY dbo.RLS_TeamMembers
ADD FILTER PREDICATE dbo.fn_RLS_UserIsolation(OwnerUserId)
    ON dbo.TeamMembers,
ADD BLOCK PREDICATE dbo.fn_RLS_UserIsolation(OwnerUserId)
    ON dbo.TeamMembers
WITH (STATE = ON);
GO

CREATE SECURITY POLICY dbo.RLS_Vehicles
ADD FILTER PREDICATE dbo.fn_RLS_UserIsolation(OwnerUserId)
    ON dbo.Vehicles,
ADD BLOCK PREDICATE dbo.fn_RLS_UserIsolation(OwnerUserId)
    ON dbo.Vehicles
WITH (STATE = ON);
GO

CREATE SECURITY POLICY dbo.RLS_Equipment
ADD FILTER PREDICATE dbo.fn_RLS_UserIsolation(OwnerUserId)
    ON dbo.Equipment,
ADD BLOCK PREDICATE dbo.fn_RLS_UserIsolation(OwnerUserId)
    ON dbo.Equipment
WITH (STATE = ON);
GO

CREATE SECURITY POLICY dbo.RLS_Interventions
ADD FILTER PREDICATE dbo.fn_RLS_UserIsolation(OwnerUserId)
    ON dbo.Interventions,
ADD BLOCK PREDICATE dbo.fn_RLS_UserIsolation(OwnerUserId)
    ON dbo.Interventions
WITH (STATE = ON);
GO
INSERT INTO dbo.Roles (Name)
VALUES ('Admin'), ('User');
GO
