-- ============================================================
-- PHASE VII: DML RESTRICTION TRIGGER (Weekday & Holiday Block)
-- Student: NSHUTI Sano Delphin
-- Student ID: 27903
-- Database: TUE_27903_DELPHIN_MATERNALEWS_DB
-- Date: December 2025
-- ============================================================

-- ============================================================
-- REQUIREMENT: 
-- Block DML operations (INSERT, UPDATE, DELETE) on:
-- 1. Weekdays (Monday to Friday) - only allow weekends
-- 2. Rwanda Public Holidays (from HOLIDAYS table)
-- ============================================================

-- ============================================================
-- FUNCTION: Check if DML is Allowed
-- Returns TRUE if DML should be blocked, FALSE if allowed
-- ============================================================
CREATE OR REPLACE FUNCTION fn_is_dml_blocked RETURN BOOLEAN IS
    v_day_name VARCHAR2(20);
    v_holiday_count NUMBER;
    v_current_date DATE := TRUNC(SYSDATE);
BEGIN
    -- Get day name
    v_day_name := TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH');
    
    -- Check if it's a weekday (Monday-Friday)
    IF v_day_name IN ('MON', 'TUE', 'WED', 'THU', 'FRI') THEN
        RETURN TRUE; -- Block DML on weekdays
    END IF;
    
    -- Check if it's a holiday
    SELECT COUNT(*)
    INTO v_holiday_count
    FROM holidays
    WHERE holiday_date = v_current_date;
    
    IF v_holiday_count > 0 THEN
        RETURN TRUE; -- Block DML on holidays
    END IF;
    
    -- Weekend and not a holiday - allow DML
    RETURN FALSE;
END fn_is_dml_blocked;
/

-- ============================================================
-- FUNCTION: Get Block Reason Message
-- ============================================================
CREATE OR REPLACE FUNCTION fn_get_block_reason RETURN VARCHAR2 IS
    v_day_name VARCHAR2(20);
    v_holiday_name VARCHAR2(100);
    v_current_date DATE := TRUNC(SYSDATE);
BEGIN
    v_day_name := TO_CHAR(SYSDATE, 'DAY', 'NLS_DATE_LANGUAGE=ENGLISH');
    
    -- Check if it's a holiday first
    BEGIN
        SELECT holiday_name INTO v_holiday_name
        FROM holidays
        WHERE holiday_date = v_current_date;
        
        RETURN 'DML blocked: Today is ' || TRIM(v_holiday_name) || ' (Rwanda Public Holiday)';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Not a holiday, check weekday
            RETURN 'DML blocked: Today is ' || TRIM(v_day_name) || ' (Weekday). DML only allowed on weekends.';
    END;
END fn_get_block_reason;
/

-- ============================================================
-- COMPOUND TRIGGER: Block DML on MOTHERS table
-- ============================================================
CREATE OR REPLACE TRIGGER trg_restrict_dml_mothers
BEFORE INSERT OR UPDATE OR DELETE ON mothers
FOR EACH ROW
DECLARE
    v_action VARCHAR2(10);
BEGIN
    IF fn_is_dml_blocked() THEN
        -- Determine action type
        IF INSERTING THEN v_action := 'INSERT';
        ELSIF UPDATING THEN v_action := 'UPDATE';
        ELSE v_action := 'DELETE';
        END IF;
        
        -- Log the denied action
        INSERT INTO audit_log (
            log_id, table_name, action_type, action_timestamp,
            performed_by, record_id, action_status, denial_reason
        ) VALUES (
            seq_audit_id.NEXTVAL, 'MOTHERS', v_action, SYSTIMESTAMP,
            USER, NVL(:NEW.mother_id, :OLD.mother_id), 'DENIED', fn_get_block_reason()
        );
        
        -- Raise error
        RAISE_APPLICATION_ERROR(-20300, fn_get_block_reason());
    END IF;
END;
/

-- ============================================================
-- TRIGGER: Block DML on PREGNANCIES table
-- ============================================================
CREATE OR REPLACE TRIGGER trg_restrict_dml_pregnancies
BEFORE INSERT OR UPDATE OR DELETE ON pregnancies
FOR EACH ROW
DECLARE
    v_action VARCHAR2(10);
BEGIN
    IF fn_is_dml_blocked() THEN
        IF INSERTING THEN v_action := 'INSERT';
        ELSIF UPDATING THEN v_action := 'UPDATE';
        ELSE v_action := 'DELETE';
        END IF;
        
        INSERT INTO audit_log (
            log_id, table_name, action_type, action_timestamp,
            performed_by, record_id, action_status, denial_reason
        ) VALUES (
            seq_audit_id.NEXTVAL, 'PREGNANCIES', v_action, SYSTIMESTAMP,
            USER, NVL(:NEW.pregnancy_id, :OLD.pregnancy_id), 'DENIED', fn_get_block_reason()
        );
        
        RAISE_APPLICATION_ERROR(-20301, fn_get_block_reason());
    END IF;
END;
/

-- ============================================================
-- TRIGGER: Block DML on MATERNAL_VITALS table
-- ============================================================
CREATE OR REPLACE TRIGGER trg_restrict_dml_vitals
BEFORE INSERT OR UPDATE OR DELETE ON maternal_vitals
FOR EACH ROW
DECLARE
    v_action VARCHAR2(10);
BEGIN
    IF fn_is_dml_blocked() THEN
        IF INSERTING THEN v_action := 'INSERT';
        ELSIF UPDATING THEN v_action := 'UPDATE';
        ELSE v_action := 'DELETE';
        END IF;
        
        INSERT INTO audit_log (
            log_id, table_name, action_type, action_timestamp,
            performed_by, record_id, action_status, denial_reason
        ) VALUES (
            seq_audit_id.NEXTVAL, 'MATERNAL_VITALS', v_action, SYSTIMESTAMP,
            USER, NVL(:NEW.vital_id, :OLD.vital_id), 'DENIED', fn_get_block_reason()
        );
        
        RAISE_APPLICATION_ERROR(-20302, fn_get_block_reason());
    END IF;
END;
/

-- ============================================================
-- TRIGGER: Block DML on MATERNAL_ALERTS table
-- ============================================================
CREATE OR REPLACE TRIGGER trg_restrict_dml_alerts
BEFORE INSERT OR UPDATE OR DELETE ON maternal_alerts
FOR EACH ROW
DECLARE
    v_action VARCHAR2(10);
BEGIN
    IF fn_is_dml_blocked() THEN
        IF INSERTING THEN v_action := 'INSERT';
        ELSIF UPDATING THEN v_action := 'UPDATE';
        ELSE v_action := 'DELETE';
        END IF;
        
        INSERT INTO audit_log (
            log_id, table_name, action_type, action_timestamp,
            performed_by, record_id, action_status, denial_reason
        ) VALUES (
            seq_audit_id.NEXTVAL, 'MATERNAL_ALERTS', v_action, SYSTIMESTAMP,
            USER, NVL(:NEW.alert_id, :OLD.alert_id), 'DENIED', fn_get_block_reason()
        );
        
        RAISE_APPLICATION_ERROR(-20303, fn_get_block_reason());
    END IF;
END;
/

-- ============================================================
-- TRIGGER: Block DML on REFERRALS table
-- ============================================================
CREATE OR REPLACE TRIGGER trg_restrict_dml_referrals
BEFORE INSERT OR UPDATE OR DELETE ON referrals
FOR EACH ROW
DECLARE
    v_action VARCHAR2(10);
BEGIN
    IF fn_is_dml_blocked() THEN
        IF INSERTING THEN v_action := 'INSERT';
        ELSIF UPDATING THEN v_action := 'UPDATE';
        ELSE v_action := 'DELETE';
        END IF;
        
        INSERT INTO audit_log (
            log_id, table_name, action_type, action_timestamp,
            performed_by, record_id, action_status, denial_reason
        ) VALUES (
            seq_audit_id.NEXTVAL, 'REFERRALS', v_action, SYSTIMESTAMP,
            USER, NVL(:NEW.referral_id, :OLD.referral_id), 'DENIED', fn_get_block_reason()
        );
        
        RAISE_APPLICATION_ERROR(-20304, fn_get_block_reason());
    END IF;
END;
/

-- ============================================================
-- VERIFY RESTRICTION TRIGGERS
-- ============================================================
SELECT trigger_name, table_name, triggering_event, status
FROM user_triggers
WHERE trigger_name LIKE 'TRG_RESTRICT%'
ORDER BY trigger_name;

-- ============================================================
-- TEST THE RESTRICTION (Will fail on weekdays)
-- ============================================================
-- Try to insert a test mother (should fail on weekdays)
BEGIN
    INSERT INTO mothers (mother_id, assigned_chw_id, national_id, full_name, date_of_birth, district)
    VALUES (seq_mother_id.NEXTVAL, 1, '1199999999999999', 'Test Mother', DATE '1990-01-01', 'Test');
    DBMS_OUTPUT.PUT_LINE('INSERT succeeded - it must be a weekend!');
    ROLLBACK;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('INSERT blocked as expected: ' || SQLERRM);
END;
/

-- ============================================================
-- VIEW DENIED OPERATIONS
-- ============================================================
SELECT log_id, table_name, action_type, 
       TO_CHAR(action_timestamp, 'DD-MON-YY HH24:MI') AS attempt_time,
       performed_by, action_status, denial_reason
FROM audit_log
WHERE action_status = 'DENIED'
ORDER BY action_timestamp DESC;

-- ============================================================
-- PROCEDURE: Temporarily Disable Restrictions (Admin Only)
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_disable_dml_restrictions AS
BEGIN
    EXECUTE IMMEDIATE 'ALTER TRIGGER trg_restrict_dml_mothers DISABLE';
    EXECUTE IMMEDIATE 'ALTER TRIGGER trg_restrict_dml_pregnancies DISABLE';
    EXECUTE IMMEDIATE 'ALTER TRIGGER trg_restrict_dml_vitals DISABLE';
    EXECUTE IMMEDIATE 'ALTER TRIGGER trg_restrict_dml_alerts DISABLE';
    EXECUTE IMMEDIATE 'ALTER TRIGGER trg_restrict_dml_referrals DISABLE';
    DBMS_OUTPUT.PUT_LINE('DML restriction triggers DISABLED');
END;
/

-- ============================================================
-- PROCEDURE: Re-enable Restrictions
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_enable_dml_restrictions AS
BEGIN
    EXECUTE IMMEDIATE 'ALTER TRIGGER trg_restrict_dml_mothers ENABLE';
    EXECUTE IMMEDIATE 'ALTER TRIGGER trg_restrict_dml_pregnancies ENABLE';
    EXECUTE IMMEDIATE 'ALTER TRIGGER trg_restrict_dml_vitals ENABLE';
    EXECUTE IMMEDIATE 'ALTER TRIGGER trg_restrict_dml_alerts ENABLE';
    EXECUTE IMMEDIATE 'ALTER TRIGGER trg_restrict_dml_referrals ENABLE';
    DBMS_OUTPUT.PUT_LINE('DML restriction triggers ENABLED');
END;
/

-- ============================================================
-- FOR TESTING: Disable triggers temporarily
-- ============================================================
-- Run this to disable restrictions for data insertion:
-- EXEC sp_disable_dml_restrictions;

-- Run this to re-enable after testing:
-- EXEC sp_enable_dml_restrictions;

PROMPT ============================================
PROMPT DML Restriction Triggers Created!
PROMPT 
PROMPT NOTE: DML is blocked on weekdays (Mon-Fri)
PROMPT       and Rwanda public holidays.
PROMPT       Use sp_disable_dml_restrictions to
PROMPT       temporarily disable for testing.
PROMPT ============================================
