-- ============================================================
-- PHASE VII: DATABASE TRIGGERS
-- Student: NSHUTI Sano Delphin
-- Student ID: 27903
-- Database: TUE_27903_DELPHIN_MATERNALEWS_DB
-- Date: December 2025
-- ============================================================

-- ============================================================
-- TRIGGER 1: Auto-Generate Alert After Vital Signs Entry
-- ============================================================
CREATE OR REPLACE TRIGGER trg_maternal_alert_check
AFTER INSERT ON maternal_vitals
FOR EACH ROW
DECLARE
    v_risk_score NUMBER;
    v_severity VARCHAR2(10);
    v_alert_type VARCHAR2(50);
BEGIN
    -- Calculate risk score
    v_risk_score := calculate_maternal_risk_score(:NEW.vital_id);
    
    -- Only create alert if risk score >= 15
    IF v_risk_score >= 15 THEN
        -- Determine severity
        v_severity := get_alert_severity(v_risk_score);
        
        -- Determine alert type
        IF :NEW.systolic_bp >= 160 OR :NEW.diastolic_bp >= 110 THEN
            v_alert_type := 'Severe Hypertension';
        ELSIF :NEW.vaginal_bleeding = 'Yes' THEN
            v_alert_type := 'Vaginal Bleeding';
        ELSIF :NEW.convulsions = 'Yes' THEN
            v_alert_type := 'Convulsions/Eclampsia';
        ELSIF :NEW.hemoglobin_level < 7 THEN
            v_alert_type := 'Severe Anemia';
        ELSIF :NEW.systolic_bp >= 140 THEN
            v_alert_type := 'Elevated Blood Pressure';
        ELSE
            v_alert_type := 'Multiple Risk Factors';
        END IF;
        
        -- Insert alert
        INSERT INTO maternal_alerts (
            alert_id, pregnancy_id, vital_id, alert_type,
            severity, risk_score, status
        ) VALUES (
            seq_alert_id.NEXTVAL, :NEW.pregnancy_id, :NEW.vital_id,
            v_alert_type, v_severity, v_risk_score, 'Open'
        );
        
        -- Update pregnancy risk level
        UPDATE pregnancies
        SET last_risk_score = v_risk_score,
            risk_level = CASE
                WHEN v_risk_score >= 50 THEN 'Critical'
                WHEN v_risk_score >= 25 THEN 'High'
                WHEN v_risk_score >= 15 THEN 'Medium'
                ELSE 'Low'
            END
        WHERE pregnancy_id = :NEW.pregnancy_id;
    END IF;
END;
/

-- ============================================================
-- TRIGGER 2: Auto-Dispatch Ambulance for Red Alerts
-- ============================================================
CREATE OR REPLACE TRIGGER trg_auto_dispatch_ambulance
AFTER INSERT ON maternal_alerts
FOR EACH ROW
WHEN (NEW.severity = 'Red')
DECLARE
    v_ambulance_id NUMBER;
    v_chw_id NUMBER;
    v_facility VARCHAR2(100);
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    -- Find available ambulance
    BEGIN
        SELECT ambulance_id, based_at_facility
        INTO v_ambulance_id, v_facility
        FROM ambulances
        WHERE current_status = 'Available'
        AND ROWNUM = 1
        FOR UPDATE SKIP LOCKED;
        
        -- Get referring CHW
        SELECT m.assigned_chw_id INTO v_chw_id
        FROM pregnancies p
        JOIN mothers m ON p.mother_id = m.mother_id
        WHERE p.pregnancy_id = :NEW.pregnancy_id;
        
        -- Update ambulance status
        UPDATE ambulances
        SET current_status = 'Dispatched'
        WHERE ambulance_id = v_ambulance_id;
        
        -- Create referral
        INSERT INTO referrals (
            referral_id, alert_id, pregnancy_id, referring_chw,
            ambulance_id, to_facility, referral_reason, urgency_level, status
        ) VALUES (
            seq_referral_id.NEXTVAL, :NEW.alert_id, :NEW.pregnancy_id, v_chw_id,
            v_ambulance_id, v_facility, :NEW.alert_type || ' - Emergency', 'Emergency', 'In Transit'
        );
        
        COMMIT;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- No ambulance available - create referral without ambulance
            SELECT m.assigned_chw_id INTO v_chw_id
            FROM pregnancies p
            JOIN mothers m ON p.mother_id = m.mother_id
            WHERE p.pregnancy_id = :NEW.pregnancy_id;
            
            INSERT INTO referrals (
                referral_id, alert_id, pregnancy_id, referring_chw,
                to_facility, referral_reason, urgency_level, status
            ) VALUES (
                seq_referral_id.NEXTVAL, :NEW.alert_id, :NEW.pregnancy_id, v_chw_id,
                'Nearest Hospital', :NEW.alert_type || ' - NO AMBULANCE AVAILABLE', 'Emergency', 'Pending'
            );
            COMMIT;
    END;
END;
/

-- ============================================================
-- TRIGGER 3: Update Pregnancy Status on Delivery
-- ============================================================
CREATE OR REPLACE TRIGGER trg_update_pregnancy_on_delivery
AFTER INSERT ON newborns
FOR EACH ROW
BEGIN
    UPDATE pregnancies
    SET pregnancy_status = 'Delivered'
    WHERE pregnancy_id = :NEW.pregnancy_id;
END;
/

-- ============================================================
-- TRIGGER 4: Auto-Schedule Newborn Vaccinations
-- ============================================================
CREATE OR REPLACE TRIGGER trg_schedule_newborn_vaccines
AFTER INSERT ON newborns
FOR EACH ROW
DECLARE
    v_chw_id NUMBER;
BEGIN
    -- Get CHW from mother
    SELECT m.assigned_chw_id INTO v_chw_id
    FROM pregnancies p
    JOIN mothers m ON p.mother_id = m.mother_id
    WHERE p.pregnancy_id = :NEW.pregnancy_id;
    
    -- Schedule BCG (at birth)
    INSERT INTO vaccinations (
        vaccination_id, newborn_id, administered_by, vaccine_type,
        dose_number, vaccination_date
    ) VALUES (
        seq_vaccination_id.NEXTVAL, :NEW.newborn_id, v_chw_id, 'BCG',
        1, :NEW.birth_date
    );
    
    -- Schedule OPV-0 (at birth)
    INSERT INTO vaccinations (
        vaccination_id, newborn_id, administered_by, vaccine_type,
        dose_number, vaccination_date, next_dose_date
    ) VALUES (
        seq_vaccination_id.NEXTVAL, :NEW.newborn_id, v_chw_id, 'OPV',
        0, :NEW.birth_date, :NEW.birth_date + 42
    );
    
    -- Schedule Hepatitis B (at birth)
    INSERT INTO vaccinations (
        vaccination_id, newborn_id, administered_by, vaccine_type,
        dose_number, vaccination_date, next_dose_date
    ) VALUES (
        seq_vaccination_id.NEXTVAL, :NEW.newborn_id, v_chw_id, 'Hepatitis B',
        1, :NEW.birth_date, :NEW.birth_date + 30
    );
    
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Silently handle errors to not block delivery record
END;
/

-- ============================================================
-- TRIGGER 5: Mark ANC as Completed When Vital Recorded
-- ============================================================
CREATE OR REPLACE TRIGGER trg_complete_anc_on_vital
AFTER INSERT ON maternal_vitals
FOR EACH ROW
DECLARE
    v_gest_week NUMBER;
BEGIN
    v_gest_week := :NEW.gestational_age_weeks;
    
    -- Find matching scheduled ANC visit
    UPDATE anc_schedule
    SET status = 'Completed',
        actual_date = :NEW.visit_date
    WHERE pregnancy_id = :NEW.pregnancy_id
    AND status = 'Scheduled'
    AND gestational_week <= v_gest_week + 2  -- Within 2 weeks tolerance
    AND gestational_week >= v_gest_week - 2
    AND ROWNUM = 1;
END;
/

-- ============================================================
-- TRIGGER 6: Validate Vital Signs Range
-- ============================================================
CREATE OR REPLACE TRIGGER trg_validate_vital_signs
BEFORE INSERT OR UPDATE ON maternal_vitals
FOR EACH ROW
BEGIN
    -- Validate blood pressure
    IF :NEW.systolic_bp IS NOT NULL THEN
        IF :NEW.systolic_bp < 60 OR :NEW.systolic_bp > 250 THEN
            RAISE_APPLICATION_ERROR(-20101, 'Invalid systolic BP: Must be between 60-250 mmHg');
        END IF;
    END IF;
    
    IF :NEW.diastolic_bp IS NOT NULL THEN
        IF :NEW.diastolic_bp < 40 OR :NEW.diastolic_bp > 150 THEN
            RAISE_APPLICATION_ERROR(-20102, 'Invalid diastolic BP: Must be between 40-150 mmHg');
        END IF;
    END IF;
    
    -- Validate temperature
    IF :NEW.temperature IS NOT NULL THEN
        IF :NEW.temperature < 34 OR :NEW.temperature > 42 THEN
            RAISE_APPLICATION_ERROR(-20103, 'Invalid temperature: Must be between 34-42°C');
        END IF;
    END IF;
    
    -- Validate fetal heart rate
    IF :NEW.fetal_heart_rate IS NOT NULL THEN
        IF :NEW.fetal_heart_rate < 60 OR :NEW.fetal_heart_rate > 220 THEN
            RAISE_APPLICATION_ERROR(-20104, 'Invalid fetal HR: Must be between 60-220 bpm');
        END IF;
    END IF;
    
    -- Validate hemoglobin
    IF :NEW.hemoglobin_level IS NOT NULL THEN
        IF :NEW.hemoglobin_level < 3 OR :NEW.hemoglobin_level > 20 THEN
            RAISE_APPLICATION_ERROR(-20105, 'Invalid hemoglobin: Must be between 3-20 g/dL');
        END IF;
    END IF;
END;
/

-- ============================================================
-- TRIGGER 7: Prevent Deletion of Active Pregnancy
-- ============================================================
CREATE OR REPLACE TRIGGER trg_prevent_delete_active_pregnancy
BEFORE DELETE ON pregnancies
FOR EACH ROW
BEGIN
    IF :OLD.pregnancy_status = 'Active' THEN
        RAISE_APPLICATION_ERROR(-20201, 'Cannot delete active pregnancy. Change status first.');
    END IF;
END;
/

-- ============================================================
-- TRIGGER 8: Log Mother Phone Number Changes
-- ============================================================
CREATE OR REPLACE TRIGGER trg_log_phone_change
AFTER UPDATE OF phone_number ON mothers
FOR EACH ROW
WHEN (OLD.phone_number != NEW.phone_number)
BEGIN
    INSERT INTO audit_log (
        log_id, table_name, action_type, action_timestamp,
        performed_by, record_id, old_values, new_values
    ) VALUES (
        seq_audit_id.NEXTVAL, 'MOTHERS', 'UPDATE', SYSTIMESTAMP,
        USER, :NEW.mother_id,
        'phone_number: ' || :OLD.phone_number,
        'phone_number: ' || :NEW.phone_number
    );
END;
/

-- ============================================================
-- VERIFY TRIGGERS
-- ============================================================
SELECT trigger_name, trigger_type, triggering_event, table_name, status
FROM user_triggers
ORDER BY table_name, trigger_name;

PROMPT ============================================
PROMPT Triggers Created Successfully!
PROMPT ============================================
