/* =========================================================
   1. REMOVE ROW-LEVEL SECURITY POLICIES
   ========================================================= */

DROP SECURITY POLICY IF EXISTS dbo.RLS_Interventions;
DROP SECURITY POLICY IF EXISTS dbo.RLS_Equipment;
DROP SECURITY POLICY IF EXISTS dbo.RLS_Vehicles;
DROP SECURITY POLICY IF EXISTS dbo.RLS_TeamMembers;
DROP SECURITY POLICY IF EXISTS dbo.RLS_Clients;

/* =========================================================
   2. REMOVE RLS FUNCTION
   ========================================================= */

DROP FUNCTION IF EXISTS dbo.fn_RLS_UserIsolation;

/* =========================================================
   3. REMOVE DOMAIN TABLES
   ========================================================= */

DROP TABLE IF EXISTS dbo.InterventionEquipment;
DROP TABLE IF EXISTS dbo.Interventions;
DROP TABLE IF EXISTS dbo.Equipment;
DROP TABLE IF EXISTS dbo.Vehicles;
DROP TABLE IF EXISTS dbo.TeamMembers;
DROP TABLE IF EXISTS dbo.Clients;

/* =========================================================
   4. REMOVE AUTHORIZATION TABLES
   ========================================================= */

DROP TABLE IF EXISTS dbo.UserRoles;
DROP TABLE IF EXISTS dbo.Roles;

/* =========================================================
   5. REMOVE AUTHENTICATION TABLE
   ========================================================= */

DROP TABLE IF EXISTS dbo.Users;
