-- ============================================================
-- PHASE IV: PLUGGABLE DATABASE CREATION
-- Student: NSHUTI Sano Delphin | ID: 27903
-- Database: TUE_27903_DELPHIN_MATERNALEWS_DB
-- Course: Database Development with PL/SQL (INSY 8311)
-- ============================================================

-- Connect as SYSDBA
-- sqlplus sys as sysdba

-- Step 1: Check existing PDBs
SELECT pdb_name, status FROM dba_pdbs;

-- Step 2: Create the Pluggable Database
CREATE PLUGGABLE DATABASE TUE_27903_DELPHIN_MATERNALEWS_DB
    ADMIN USER pdb_admin IDENTIFIED BY admin123
    FILE_NAME_CONVERT = ('D:\PL-SQL\ORADATA\XE\PDBSEED\', 
                         'D:\PL-SQL\ORADATA\XE\TUE_27903_DELPHIN_MATERNALEWS_DB\');

-- Step 3: Open the PDB
ALTER PLUGGABLE DATABASE TUE_27903_DELPHIN_MATERNALEWS_DB OPEN;

-- Step 4: Save state for auto-open on restart
ALTER PLUGGABLE DATABASE TUE_27903_DELPHIN_MATERNALEWS_DB SAVE STATE;

-- Step 5: Verify PDB creation
SELECT pdb_name, status, open_mode FROM dba_pdbs 
WHERE pdb_name = 'TUE_27903_DELPHIN_MATERNALEWS_DB';

-- Step 6: Switch to the new PDB
ALTER SESSION SET CONTAINER = TUE_27903_DELPHIN_MATERNALEWS_DB;

SHOW CON_NAME;

-- ============================================================
-- TABLESPACE CREATION
-- ============================================================

-- Create Data Tablespace
CREATE TABLESPACE TBS_EWS_DATA
    DATAFILE 'D:\PL-SQL\ORADATA\XE\TUE_27903_DELPHIN_MATERNALEWS_DB\tbs_ews_data01.dbf'
    SIZE 100M AUTOEXTEND ON NEXT 50M MAXSIZE UNLIMITED
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;

-- Create Index Tablespace
CREATE TABLESPACE TBS_EWS_IDX
    DATAFILE 'D:\PL-SQL\ORADATA\XE\TUE_27903_DELPHIN_MATERNALEWS_DB\tbs_ews_idx01.dbf'
    SIZE 50M AUTOEXTEND ON NEXT 25M MAXSIZE UNLIMITED
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;

-- Verify tablespaces
SELECT tablespace_name, status, contents FROM dba_tablespaces WHERE tablespace_name LIKE 'TBS_EWS%';

-- ============================================================
-- ADMIN USER CONFIGURATION
-- ============================================================

-- Configure admin user
ALTER USER pdb_admin DEFAULT TABLESPACE TBS_EWS_DATA;
ALTER USER pdb_admin QUOTA UNLIMITED ON TBS_EWS_DATA;
ALTER USER pdb_admin QUOTA UNLIMITED ON TBS_EWS_IDX;

-- Grant privileges
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW TO pdb_admin;
GRANT CREATE SEQUENCE, CREATE PROCEDURE, CREATE TRIGGER TO pdb_admin;
GRANT DBA TO pdb_admin;
ALTER USER pdb_admin ACCOUNT UNLOCK;

-- Verify
SELECT username, default_tablespace, account_status FROM dba_users WHERE username = 'PDB_ADMIN';

PROMPT ============================================
PROMPT Database Setup Complete!
PROMPT PDB: TUE_27903_DELPHIN_MATERNALEWS_DB
PROMPT User: pdb_admin / admin123
PROMPT ============================================
