-- ============================================================
-- PHASE VII: COMPREHENSIVE AUDIT TRIGGERS
-- Student: NSHUTI Sano Delphin
-- Student ID: 27903
-- Database: TUE_27903_DELPHIN_MATERNALEWS_DB
-- Date: December 2025
-- ============================================================

-- ============================================================
-- AUDIT TRIGGER 1: Audit MOTHERS Table
-- ============================================================
CREATE OR REPLACE TRIGGER trg_audit_mothers
AFTER INSERT OR UPDATE OR DELETE ON mothers
FOR EACH ROW
DECLARE
    v_action VARCHAR2(10);
    v_old_vals CLOB;
    v_new_vals CLOB;
    v_record_id NUMBER;
BEGIN
    IF INSERTING THEN
        v_action := 'INSERT';
        v_record_id := :NEW.mother_id;
        v_new_vals := 'national_id=' || :NEW.national_id || ', full_name=' || :NEW.full_name ||
                      ', district=' || :NEW.district || ', phone=' || :NEW.phone_number;
    ELSIF UPDATING THEN
        v_action := 'UPDATE';
        v_record_id := :NEW.mother_id;
        v_old_vals := 'national_id=' || :OLD.national_id || ', full_name=' || :OLD.full_name ||
                      ', district=' || :OLD.district || ', phone=' || :OLD.phone_number;
        v_new_vals := 'national_id=' || :NEW.national_id || ', full_name=' || :NEW.full_name ||
                      ', district=' || :NEW.district || ', phone=' || :NEW.phone_number;
    ELSIF DELETING THEN
        v_action := 'DELETE';
        v_record_id := :OLD.mother_id;
        v_old_vals := 'national_id=' || :OLD.national_id || ', full_name=' || :OLD.full_name ||
                      ', district=' || :OLD.district || ', phone=' || :OLD.phone_number;
    END IF;
    
    INSERT INTO audit_log (
        log_id, table_name, action_type, action_timestamp,
        performed_by, record_id, old_values, new_values
    ) VALUES (
        seq_audit_id.NEXTVAL, 'MOTHERS', v_action, SYSTIMESTAMP,
        USER, v_record_id, v_old_vals, v_new_vals
    );
END;
/

-- ============================================================
-- AUDIT TRIGGER 2: Audit PREGNANCIES Table
-- ============================================================
CREATE OR REPLACE TRIGGER trg_audit_pregnancies
AFTER INSERT OR UPDATE OR DELETE ON pregnancies
FOR EACH ROW
DECLARE
    v_action VARCHAR2(10);
    v_old_vals CLOB;
    v_new_vals CLOB;
    v_record_id NUMBER;
BEGIN
    IF INSERTING THEN
        v_action := 'INSERT';
        v_record_id := :NEW.pregnancy_id;
        v_new_vals := 'mother_id=' || :NEW.mother_id || ', status=' || :NEW.pregnancy_status ||
                      ', risk_level=' || :NEW.risk_level || ', EDD=' || TO_CHAR(:NEW.estimated_delivery_date, 'DD-MON-YYYY');
    ELSIF UPDATING THEN
        v_action := 'UPDATE';
        v_record_id := :NEW.pregnancy_id;
        v_old_vals := 'status=' || :OLD.pregnancy_status || ', risk_level=' || :OLD.risk_level ||
                      ', last_score=' || :OLD.last_risk_score;
        v_new_vals := 'status=' || :NEW.pregnancy_status || ', risk_level=' || :NEW.risk_level ||
                      ', last_score=' || :NEW.last_risk_score;
    ELSIF DELETING THEN
        v_action := 'DELETE';
        v_record_id := :OLD.pregnancy_id;
        v_old_vals := 'mother_id=' || :OLD.mother_id || ', status=' || :OLD.pregnancy_status;
    END IF;
    
    INSERT INTO audit_log (
        log_id, table_name, action_type, action_timestamp,
        performed_by, record_id, old_values, new_values
    ) VALUES (
        seq_audit_id.NEXTVAL, 'PREGNANCIES', v_action, SYSTIMESTAMP,
        USER, v_record_id, v_old_vals, v_new_vals
    );
END;
/

-- ============================================================
-- AUDIT TRIGGER 3: Audit MATERNAL_VITALS Table
-- ============================================================
CREATE OR REPLACE TRIGGER trg_audit_vitals
AFTER INSERT OR UPDATE OR DELETE ON maternal_vitals
FOR EACH ROW
DECLARE
    v_action VARCHAR2(10);
    v_old_vals CLOB;
    v_new_vals CLOB;
    v_record_id NUMBER;
BEGIN
    IF INSERTING THEN
        v_action := 'INSERT';
        v_record_id := :NEW.vital_id;
        v_new_vals := 'pregnancy_id=' || :NEW.pregnancy_id || ', BP=' || :NEW.systolic_bp || '/' || :NEW.diastolic_bp ||
                      ', temp=' || :NEW.temperature || ', FHR=' || :NEW.fetal_heart_rate ||
                      ', bleeding=' || :NEW.vaginal_bleeding || ', headache=' || :NEW.severe_headache;
    ELSIF UPDATING THEN
        v_action := 'UPDATE';
        v_record_id := :NEW.vital_id;
        v_old_vals := 'BP=' || :OLD.systolic_bp || '/' || :OLD.diastolic_bp || ', temp=' || :OLD.temperature;
        v_new_vals := 'BP=' || :NEW.systolic_bp || '/' || :NEW.diastolic_bp || ', temp=' || :NEW.temperature;
    ELSIF DELETING THEN
        v_action := 'DELETE';
        v_record_id := :OLD.vital_id;
        v_old_vals := 'pregnancy_id=' || :OLD.pregnancy_id || ', BP=' || :OLD.systolic_bp || '/' || :OLD.diastolic_bp;
    END IF;
    
    INSERT INTO audit_log (
        log_id, table_name, action_type, action_timestamp,
        performed_by, record_id, old_values, new_values
    ) VALUES (
        seq_audit_id.NEXTVAL, 'MATERNAL_VITALS', v_action, SYSTIMESTAMP,
        USER, v_record_id, v_old_vals, v_new_vals
    );
END;
/

-- ============================================================
-- AUDIT TRIGGER 4: Audit MATERNAL_ALERTS Table
-- ============================================================
CREATE OR REPLACE TRIGGER trg_audit_alerts
AFTER INSERT OR UPDATE OR DELETE ON maternal_alerts
FOR EACH ROW
DECLARE
    v_action VARCHAR2(10);
    v_old_vals CLOB;
    v_new_vals CLOB;
    v_record_id NUMBER;
BEGIN
    IF INSERTING THEN
        v_action := 'INSERT';
        v_record_id := :NEW.alert_id;
        v_new_vals := 'pregnancy_id=' || :NEW.pregnancy_id || ', severity=' || :NEW.severity ||
                      ', type=' || :NEW.alert_type || ', score=' || :NEW.risk_score;
    ELSIF UPDATING THEN
        v_action := 'UPDATE';
        v_record_id := :NEW.alert_id;
        v_old_vals := 'status=' || :OLD.status || ', severity=' || :OLD.severity;
        v_new_vals := 'status=' || :NEW.status || ', severity=' || :NEW.severity ||
                      ', resolved_by=' || :NEW.resolved_by;
    ELSIF DELETING THEN
        v_action := 'DELETE';
        v_record_id := :OLD.alert_id;
        v_old_vals := 'pregnancy_id=' || :OLD.pregnancy_id || ', severity=' || :OLD.severity;
    END IF;
    
    INSERT INTO audit_log (
        log_id, table_name, action_type, action_timestamp,
        performed_by, record_id, old_values, new_values
    ) VALUES (
        seq_audit_id.NEXTVAL, 'MATERNAL_ALERTS', v_action, SYSTIMESTAMP,
        USER, v_record_id, v_old_vals, v_new_vals
    );
END;
/

-- ============================================================
-- AUDIT TRIGGER 5: Audit REFERRALS Table
-- ============================================================
CREATE OR REPLACE TRIGGER trg_audit_referrals
AFTER INSERT OR UPDATE OR DELETE ON referrals
FOR EACH ROW
DECLARE
    v_action VARCHAR2(10);
    v_old_vals CLOB;
    v_new_vals CLOB;
    v_record_id NUMBER;
BEGIN
    IF INSERTING THEN
        v_action := 'INSERT';
        v_record_id := :NEW.referral_id;
        v_new_vals := 'pregnancy_id=' || :NEW.pregnancy_id || ', facility=' || :NEW.to_facility ||
                      ', urgency=' || :NEW.urgency_level || ', ambulance=' || :NEW.ambulance_id;
    ELSIF UPDATING THEN
        v_action := 'UPDATE';
        v_record_id := :NEW.referral_id;
        v_old_vals := 'status=' || :OLD.status;
        v_new_vals := 'status=' || :NEW.status || ', outcome=' || :NEW.outcome;
    ELSIF DELETING THEN
        v_action := 'DELETE';
        v_record_id := :OLD.referral_id;
        v_old_vals := 'pregnancy_id=' || :OLD.pregnancy_id || ', facility=' || :OLD.to_facility;
    END IF;
    
    INSERT INTO audit_log (
        log_id, table_name, action_type, action_timestamp,
        performed_by, record_id, old_values, new_values
    ) VALUES (
        seq_audit_id.NEXTVAL, 'REFERRALS', v_action, SYSTIMESTAMP,
        USER, v_record_id, v_old_vals, v_new_vals
    );
END;
/

-- ============================================================
-- AUDIT TRIGGER 6: Audit NEWBORNS Table
-- ============================================================
CREATE OR REPLACE TRIGGER trg_audit_newborns
AFTER INSERT OR UPDATE OR DELETE ON newborns
FOR EACH ROW
DECLARE
    v_action VARCHAR2(10);
    v_old_vals CLOB;
    v_new_vals CLOB;
    v_record_id NUMBER;
BEGIN
    IF INSERTING THEN
        v_action := 'INSERT';
        v_record_id := :NEW.newborn_id;
        v_new_vals := 'pregnancy_id=' || :NEW.pregnancy_id || ', gender=' || :NEW.gender ||
                      ', weight=' || :NEW.birth_weight_kg || ', delivery=' || :NEW.delivery_type;
    ELSIF UPDATING THEN
        v_action := 'UPDATE';
        v_record_id := :NEW.newborn_id;
        v_old_vals := 'is_alive=' || :OLD.is_alive;
        v_new_vals := 'is_alive=' || :NEW.is_alive;
    ELSIF DELETING THEN
        v_action := 'DELETE';
        v_record_id := :OLD.newborn_id;
        v_old_vals := 'pregnancy_id=' || :OLD.pregnancy_id || ', gender=' || :OLD.gender;
    END IF;
    
    INSERT INTO audit_log (
        log_id, table_name, action_type, action_timestamp,
        performed_by, record_id, old_values, new_values
    ) VALUES (
        seq_audit_id.NEXTVAL, 'NEWBORNS', v_action, SYSTIMESTAMP,
        USER, v_record_id, v_old_vals, v_new_vals
    );
END;
/

-- ============================================================
-- VERIFY ALL AUDIT TRIGGERS
-- ============================================================
SELECT trigger_name, table_name, triggering_event, status
FROM user_triggers
WHERE trigger_name LIKE 'TRG_AUDIT%'
ORDER BY trigger_name;

-- ============================================================
-- VIEW AUDIT LOG
-- ============================================================
CREATE OR REPLACE VIEW vw_audit_summary AS
SELECT 
    table_name,
    action_type,
    COUNT(*) AS action_count,
    MAX(action_timestamp) AS last_action
FROM audit_log
GROUP BY table_name, action_type
ORDER BY table_name, action_type;

-- Query audit summary
SELECT * FROM vw_audit_summary;

-- Recent audit entries
SELECT log_id, table_name, action_type, 
       TO_CHAR(action_timestamp, 'DD-MON-YY HH24:MI:SS') AS action_time,
       performed_by, record_id
FROM audit_log
ORDER BY action_timestamp DESC
FETCH FIRST 20 ROWS ONLY;

PROMPT ============================================
PROMPT Audit Triggers Created Successfully!
PROMPT ============================================
