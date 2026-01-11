/* =========================================================
   GERITAPP - FINAL SEED SCRIPT (SINGLE SCRIPT)
   SQL Server 2019+
   Safe to run multiple times
   No MERGE + VALUES
   No conversion errors
   Production-like GUIDs
   ========================================================= */

SET NOCOUNT ON;

------------------------------------------------------------
-- 0. OWNER USER + RLS CONTEXT
------------------------------------------------------------
DECLARE @OwnerUserId UNIQUEIDENTIFIER = '6F9D8C0E-3A44-4E5A-9F7C-3F2C5E9A1D42';

IF NOT EXISTS (
    SELECT 1 FROM dbo.Users WHERE UserId = @OwnerUserId
)
BEGIN
    INSERT INTO dbo.Users (UserId, Email, PasswordHash, FullName)
    VALUES (
        @OwnerUserId,
        'admin@geritapp.com',
        'DEV_HASH_ONLY',
        'GeritApp Administrator'
    );
END;

EXEC sp_set_session_context 
    @key = N'UserId',
    @value = @OwnerUserId;

------------------------------------------------------------
-- 1. CLIENTS
------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM dbo.Clients WHERE ClientId = '2C1F7E3D-6A9B-4E2D-9B6F-1F9A4E3C7A01')
INSERT INTO dbo.Clients (ClientId, Name, Email, Phone, TaxNumber, Address, ConsentStatus, OwnerUserId, CreatedAt)
VALUES
('2C1F7E3D-6A9B-4E2D-9B6F-1F9A4E3C7A01', 'Empresa ABC, Lda', 'geral@abc.pt', '210123456', '500123456',
 'Av. da Liberdade 110, Lisboa', 'Granted', @OwnerUserId, '2023-01-15');

IF NOT EXISTS (SELECT 1 FROM dbo.Clients WHERE ClientId = '7B4E9C6D-2A1F-4D9E-8A3B-5F1C7E6A9D02')
INSERT INTO dbo.Clients VALUES
('7B4E9C6D-2A1F-4D9E-8A3B-5F1C7E6A9D02', 'Condomínio Sol', 'condominio.sol@mail.com', '912345678', '999876543',
 'Rua do Sol 45, Faro', 'Pending', @OwnerUserId, '2023-03-22');

IF NOT EXISTS (SELECT 1 FROM dbo.Clients WHERE ClientId = '9A3F6C7E-5D4B-4E2A-8F1C-6E9D2A7B5C03')
INSERT INTO dbo.Clients VALUES
('9A3F6C7E-5D4B-4E2A-8F1C-6E9D2A7B5C03', 'Restaurante Sabor', 'restaurante.sabor@email.com', '223456789', '501987654',
 'Praça do Comércio 5, Lisboa', 'Revoked', @OwnerUserId, '2023-05-10');

IF NOT EXISTS (SELECT 1 FROM dbo.Clients WHERE ClientId = '4D7E1A9F-6C3B-4F2E-9A5D-7B8C1E6F2A04')
INSERT INTO dbo.Clients VALUES
('4D7E1A9F-6C3B-4F2E-9A5D-7B8C1E6F2A04', 'Particular - Ana Santos', 'ana.santos@email.com', '961234567', '234567890',
 'Rua das Flores 12, Porto', 'Granted', @OwnerUserId, '2023-06-01');

------------------------------------------------------------
-- 2. TEAM MEMBERS
------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM dbo.TeamMembers WHERE TeamMemberId = 'A1F7D3C9-6E4B-4F2A-9C8D-1E5B7A6F2031')
INSERT INTO dbo.TeamMembers VALUES
('A1F7D3C9-6E4B-4F2A-9C8D-1E5B7A6F2031', 'João Silva', 'Senior Technician',
 'joao.silva@geritapp.com', '910000001', 1, @OwnerUserId, SYSDATETIME());

IF NOT EXISTS (SELECT 1 FROM dbo.TeamMembers WHERE TeamMemberId = 'B6C9F2E4-7A1D-4C8F-9E3B-5A6D1F207032')
INSERT INTO dbo.TeamMembers VALUES
('B6C9F2E4-7A1D-4C8F-9E3B-5A6D1F207032', 'Maria Costa', 'Specialist Technician',
 'maria.costa@geritapp.com', '910000002', 1, @OwnerUserId, SYSDATETIME());

IF NOT EXISTS (SELECT 1 FROM dbo.TeamMembers WHERE TeamMemberId = 'C8E2A6D9-4F1B-4E7C-9A5D-6F3B1C207033')
INSERT INTO dbo.TeamMembers VALUES
('C8E2A6D9-4F1B-4E7C-9A5D-6F3B1C207033', 'Carlos Santos', 'Assistant',
 'carlos.santos@geritapp.com', '910000003', 1, @OwnerUserId, SYSDATETIME());

IF NOT EXISTS (SELECT 1 FROM dbo.TeamMembers WHERE TeamMemberId = 'D5F9B3E6-7C4A-4D1E-8A2F-9C6B1E207034')
INSERT INTO dbo.TeamMembers VALUES
('D5F9B3E6-7C4A-4D1E-8A2F-9C6B1E207034', 'Ana Pereira', 'Operations Manager',
 'ana.pereira@geritapp.com', '910000004', 1, @OwnerUserId, SYSDATETIME());

------------------------------------------------------------
-- 3. VEHICLES
------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM dbo.Vehicles WHERE VehicleId = 'E1A9C4F7-3D6B-4F2E-9A5C-7D8E6B4A8011')
INSERT INTO dbo.Vehicles VALUES
('E1A9C4F7-3D6B-4F2E-9A5C-7D8E6B4A8011', 'AB-12-CD', 'Renault', 'Kangoo', 2019,
 'Active', NULL, @OwnerUserId, '2023-01-10');

------------------------------------------------------------
-- 4. EQUIPMENT
------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM dbo.Equipment WHERE EquipmentId = 'C1A9E6F3-7D4B-4E2F-9A5C-8D6B7A902041')
INSERT INTO dbo.Equipment VALUES
('C1A9E6F3-7D4B-4E2F-9A5C-8D6B7A902041', 'Berbequim Percutor',
 'Power Tool', 'BP-12345', 'Available', @OwnerUserId, '2023-01-05');

------------------------------------------------------------
-- 5. INTERVENTION
------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1 FROM dbo.Interventions
    WHERE InterventionId = 'A3C9F6E1-7D4B-4F2A-9E5C-6B8D7A902101'
)
BEGIN
    INSERT INTO dbo.Interventions VALUES (
        'A3C9F6E1-7D4B-4F2A-9E5C-6B8D7A902101',
        @OwnerUserId,
        '9A3F6C7E-5D4B-4E2A-8F1C-6E9D2A7B5C03',
        'A1F7D3C9-6E4B-4F2A-9C8D-1E5B7A6F2031',
        'E1A9C4F7-3D6B-4F2E-9A5C-7D8E6B4A8011',
        'Reparação de Fuga de Água na Cozinha Principal',
        'Fuga identificada debaixo do lava-loiças. Necessário substituir o sifão.',
        'Open',
        '2024-07-28T09:00',
        '2024-07-28T11:00',
        'Praça do Comércio 5, Lisboa',
        85.50,
        SYSDATETIME()
    );
END;

------------------------------------------------------------
-- 6. INTERVENTION × EQUIPMENT
------------------------------------------------------------
IF NOT EXISTS (
    SELECT 1
    FROM dbo.InterventionEquipment
    WHERE InterventionId = 'A3C9F6E1-7D4B-4F2A-9E5C-6B8D7A902101'
      AND EquipmentId   = 'C1A9E6F3-7D4B-4E2F-9A5C-8D6B7A902041'
)
BEGIN
    INSERT INTO dbo.InterventionEquipment
    VALUES (
        'A3C9F6E1-7D4B-4F2A-9E5C-6B8D7A902101',
        'C1A9E6F3-7D4B-4E2F-9A5C-8D6B7A902041'
    );
END;
