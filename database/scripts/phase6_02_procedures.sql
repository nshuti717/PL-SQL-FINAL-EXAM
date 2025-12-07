-- ============================================================
-- PHASE VI: PL/SQL PROCEDURES
-- Student: NSHUTI Sano Delphin
-- Student ID: 27903
-- Database: TUE_27903_DELPHIN_MATERNALEWS_DB
-- Date: December 2025
-- ============================================================

-- ============================================================
-- PROCEDURE 1: Register New Mother
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_register_mother(
    p_national_id       IN VARCHAR2,
    p_full_name         IN VARCHAR2,
    p_date_of_birth     IN DATE,
    p_village           IN VARCHAR2,
    p_sector            IN VARCHAR2,
    p_district          IN VARCHAR2,
    p_phone_number      IN VARCHAR2,
    p_blood_type        IN VARCHAR2,
    p_chw_id            IN NUMBER,
    p_mother_id         OUT NUMBER
) IS
BEGIN
    INSERT INTO mothers (
        mother_id, assigned_chw_id, national_id, full_name,
        date_of_birth, village, sector, district, phone_number, blood_type
    ) VALUES (
        seq_mother_id.NEXTVAL, p_chw_id, p_national_id, p_full_name,
        p_date_of_birth, p_village, p_sector, p_district, p_phone_number, p_blood_type
    ) RETURNING mother_id INTO p_mother_id;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Mother registered successfully. ID: ' || p_mother_id);
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20001, 'National ID already exists');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'Error registering mother: ' || SQLERRM);
END sp_register_mother;
/

-- ============================================================
-- PROCEDURE 2: Register New Pregnancy
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_register_pregnancy(
    p_mother_id             IN NUMBER,
    p_pregnancy_start_date  IN DATE,
    p_gravida               IN NUMBER DEFAULT 1,
    p_para                  IN NUMBER DEFAULT 0,
    p_pregnancy_id          OUT NUMBER
) IS
    v_edd DATE;
BEGIN
    -- Calculate estimated delivery date (40 weeks from LMP)
    v_edd := p_pregnancy_start_date + 280;
    
    INSERT INTO pregnancies (
        pregnancy_id, mother_id, estimated_delivery_date,
        pregnancy_start_date, gravida, para, pregnancy_status, risk_level
    ) VALUES (
        seq_pregnancy_id.NEXTVAL, p_mother_id, v_edd,
        p_pregnancy_start_date, p_gravida, p_para, 'Active', 'Low'
    ) RETURNING pregnancy_id INTO p_pregnancy_id;
    
    -- Generate ANC schedule (8 visits per WHO guidelines)
    sp_generate_anc_schedule(p_pregnancy_id, p_pregnancy_start_date);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pregnancy registered. ID: ' || p_pregnancy_id || ', EDD: ' || TO_CHAR(v_edd, 'DD-MON-YYYY'));
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Error registering pregnancy: ' || SQLERRM);
END sp_register_pregnancy;
/

-- ============================================================
-- PROCEDURE 3: Generate ANC Schedule
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_generate_anc_schedule(
    p_pregnancy_id      IN NUMBER,
    p_start_date        IN DATE
) IS
    TYPE t_weeks IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v_anc_weeks t_weeks;
    v_scheduled_date DATE;
BEGIN
    -- WHO recommended ANC visit weeks
    v_anc_weeks(1) := 12;
    v_anc_weeks(2) := 20;
    v_anc_weeks(3) := 26;
    v_anc_weeks(4) := 30;
    v_anc_weeks(5) := 34;
    v_anc_weeks(6) := 36;
    v_anc_weeks(7) := 38;
    v_anc_weeks(8) := 40;
    
    FOR i IN 1..8 LOOP
        v_scheduled_date := p_start_date + (v_anc_weeks(i) * 7);
        
        INSERT INTO anc_schedule (
            schedule_id, pregnancy_id, visit_number,
            scheduled_date, status, gestational_week
        ) VALUES (
            seq_schedule_id.NEXTVAL, p_pregnancy_id, i,
            v_scheduled_date, 'Scheduled', v_anc_weeks(i)
        );
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('ANC schedule generated for pregnancy: ' || p_pregnancy_id);
END sp_generate_anc_schedule;
/

-- ============================================================
-- PROCEDURE 4: Record Maternal Vital Signs
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_record_vital_signs(
    p_pregnancy_id          IN NUMBER,
    p_chw_id                IN NUMBER,
    p_systolic_bp           IN NUMBER,
    p_diastolic_bp          IN NUMBER,
    p_temperature           IN NUMBER,
    p_fetal_heart_rate      IN NUMBER,
    p_weight_kg             IN NUMBER DEFAULT NULL,
    p_hemoglobin_level      IN NUMBER DEFAULT NULL,
    p_vaginal_bleeding      IN VARCHAR2 DEFAULT 'No',
    p_severe_headache       IN VARCHAR2 DEFAULT 'No',
    p_blurred_vision        IN VARCHAR2 DEFAULT 'No',
    p_convulsions           IN VARCHAR2 DEFAULT 'No',
    p_notes                 IN VARCHAR2 DEFAULT NULL,
    p_vital_id              OUT NUMBER,
    p_risk_score            OUT NUMBER,
    p_alert_severity        OUT VARCHAR2
) IS
    v_gest_weeks NUMBER;
BEGIN
    -- Calculate gestational age
    v_gest_weeks := calculate_gestational_age(p_pregnancy_id);
    
    -- Insert vital signs
    INSERT INTO maternal_vitals (
        vital_id, pregnancy_id, recorded_by_chw, visit_date,
        gestational_age_weeks, systolic_bp, diastolic_bp, temperature,
        fetal_heart_rate, weight_kg, hemoglobin_level,
        vaginal_bleeding, severe_headache, blurred_vision, convulsions, notes
    ) VALUES (
        seq_vital_id.NEXTVAL, p_pregnancy_id, p_chw_id, SYSDATE,
        v_gest_weeks, p_systolic_bp, p_diastolic_bp, p_temperature,
        p_fetal_heart_rate, p_weight_kg, p_hemoglobin_level,
        p_vaginal_bleeding, p_severe_headache, p_blurred_vision, p_convulsions, p_notes
    ) RETURNING vital_id INTO p_vital_id;
    
    -- Calculate risk score
    p_risk_score := calculate_maternal_risk_score(p_vital_id);
    p_alert_severity := get_alert_severity(p_risk_score);
    
    -- Update pregnancy risk level
    UPDATE pregnancies
    SET last_risk_score = p_risk_score,
        risk_level = CASE
            WHEN p_risk_score >= 50 THEN 'Critical'
            WHEN p_risk_score >= 25 THEN 'High'
            WHEN p_risk_score >= 15 THEN 'Medium'
            ELSE 'Low'
        END
    WHERE pregnancy_id = p_pregnancy_id;
    
    -- Generate alert if needed
    IF p_risk_score >= 15 THEN
        sp_generate_alert(p_pregnancy_id, p_vital_id, p_risk_score, p_alert_severity);
    END IF;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Vital signs recorded. Risk Score: ' || p_risk_score || ', Severity: ' || p_alert_severity);
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Error recording vitals: ' || SQLERRM);
END sp_record_vital_signs;
/

-- ============================================================
-- PROCEDURE 5: Generate Alert
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_generate_alert(
    p_pregnancy_id  IN NUMBER,
    p_vital_id      IN NUMBER,
    p_risk_score    IN NUMBER,
    p_severity      IN VARCHAR2
) IS
    v_alert_type VARCHAR2(50);
    v_alert_id NUMBER;
BEGIN
    -- Determine alert type based on conditions
    SELECT CASE
        WHEN systolic_bp >= 160 OR diastolic_bp >= 110 THEN 'Severe Hypertension'
        WHEN vaginal_bleeding = 'Yes' THEN 'Vaginal Bleeding'
        WHEN convulsions = 'Yes' THEN 'Convulsions/Eclampsia Risk'
        WHEN hemoglobin_level < 7 THEN 'Severe Anemia'
        WHEN systolic_bp >= 140 THEN 'Elevated Blood Pressure'
        ELSE 'Multiple Risk Factors'
    END INTO v_alert_type
    FROM maternal_vitals
    WHERE vital_id = p_vital_id;
    
    INSERT INTO maternal_alerts (
        alert_id, pregnancy_id, vital_id, alert_type,
        severity, risk_score, status
    ) VALUES (
        seq_alert_id.NEXTVAL, p_pregnancy_id, p_vital_id, v_alert_type,
        p_severity, p_risk_score, 'Open'
    ) RETURNING alert_id INTO v_alert_id;
    
    DBMS_OUTPUT.PUT_LINE('Alert generated. ID: ' || v_alert_id || ', Type: ' || v_alert_type);
    
    -- Auto-dispatch ambulance for Red alerts
    IF p_severity = 'Red' THEN
        sp_dispatch_ambulance(v_alert_id, p_pregnancy_id);
    END IF;
    
END sp_generate_alert;
/

-- ============================================================
-- PROCEDURE 6: Dispatch Ambulance
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_dispatch_ambulance(
    p_alert_id      IN NUMBER,
    p_pregnancy_id  IN NUMBER
) IS
    v_ambulance_id NUMBER;
    v_facility VARCHAR2(100);
    v_chw_id NUMBER;
    v_referral_id NUMBER;
BEGIN
    -- Find available ambulance
    SELECT ambulance_id INTO v_ambulance_id
    FROM ambulances
    WHERE current_status = 'Available'
    AND ROWNUM = 1
    FOR UPDATE;
    
    -- Get CHW and nearest facility
    SELECT m.assigned_chw_id INTO v_chw_id
    FROM pregnancies p
    JOIN mothers m ON p.mother_id = m.mother_id
    WHERE p.pregnancy_id = p_pregnancy_id;
    
    SELECT based_at_facility INTO v_facility
    FROM ambulances WHERE ambulance_id = v_ambulance_id;
    
    -- Update ambulance status
    UPDATE ambulances
    SET current_status = 'Dispatched'
    WHERE ambulance_id = v_ambulance_id;
    
    -- Create referral
    INSERT INTO referrals (
        referral_id, alert_id, pregnancy_id, referring_chw,
        ambulance_id, to_facility, referral_reason, urgency_level, status
    ) VALUES (
        seq_referral_id.NEXTVAL, p_alert_id, p_pregnancy_id, v_chw_id,
        v_ambulance_id, v_facility, 'Emergency alert triggered', 'Emergency', 'In Transit'
    ) RETURNING referral_id INTO v_referral_id;
    
    DBMS_OUTPUT.PUT_LINE('Ambulance ' || v_ambulance_id || ' dispatched. Referral ID: ' || v_referral_id);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('WARNING: No ambulance available!');
        -- Create referral without ambulance
        INSERT INTO referrals (
            referral_id, alert_id, pregnancy_id, referring_chw,
            to_facility, referral_reason, urgency_level, status
        ) VALUES (
            seq_referral_id.NEXTVAL, p_alert_id, p_pregnancy_id, v_chw_id,
            'Nearest Hospital', 'Emergency alert - no ambulance available', 'Emergency', 'Pending'
        );
END sp_dispatch_ambulance;
/

-- ============================================================
-- PROCEDURE 7: Complete Referral
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_complete_referral(
    p_referral_id   IN NUMBER,
    p_outcome       IN VARCHAR2
) IS
    v_ambulance_id NUMBER;
    v_alert_id NUMBER;
BEGIN
    -- Get referral details
    SELECT ambulance_id, alert_id
    INTO v_ambulance_id, v_alert_id
    FROM referrals
    WHERE referral_id = p_referral_id;
    
    -- Update referral
    UPDATE referrals
    SET status = 'Completed',
        patient_arrived_time = SYSTIMESTAMP,
        outcome = p_outcome
    WHERE referral_id = p_referral_id;
    
    -- Release ambulance
    IF v_ambulance_id IS NOT NULL THEN
        UPDATE ambulances
        SET current_status = 'Available'
        WHERE ambulance_id = v_ambulance_id;
    END IF;
    
    -- Resolve alert
    IF v_alert_id IS NOT NULL THEN
        UPDATE maternal_alerts
        SET status = 'Resolved',
            response_action = p_outcome,
            resolved_date = SYSTIMESTAMP
        WHERE alert_id = v_alert_id;
    END IF;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Referral completed. Outcome: ' || p_outcome);
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20005, 'Error completing referral: ' || SQLERRM);
END sp_complete_referral;
/

-- ============================================================
-- PROCEDURE 8: Record Newborn Delivery
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_record_delivery(
    p_pregnancy_id      IN NUMBER,
    p_birth_date        IN DATE,
    p_gender            IN VARCHAR2,
    p_birth_weight_kg   IN NUMBER,
    p_apgar_1min        IN NUMBER,
    p_apgar_5min        IN NUMBER,
    p_delivery_type     IN VARCHAR2,
    p_delivery_location IN VARCHAR2,
    p_newborn_id        OUT NUMBER
) IS
BEGIN
    -- Insert newborn record
    INSERT INTO newborns (
        newborn_id, pregnancy_id, birth_date, gender,
        birth_weight_kg, apgar_1min, apgar_5min, delivery_type, delivery_location
    ) VALUES (
        seq_newborn_id.NEXTVAL, p_pregnancy_id, p_birth_date, p_gender,
        p_birth_weight_kg, p_apgar_1min, p_apgar_5min, p_delivery_type, p_delivery_location
    ) RETURNING newborn_id INTO p_newborn_id;
    
    -- Update pregnancy status
    UPDATE pregnancies
    SET pregnancy_status = 'Delivered'
    WHERE pregnancy_id = p_pregnancy_id;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Delivery recorded. Newborn ID: ' || p_newborn_id);
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20006, 'Error recording delivery: ' || SQLERRM);
END sp_record_delivery;
/

-- ============================================================
-- PROCEDURE 9: Administer Vaccination
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_administer_vaccination(
    p_mother_id         IN NUMBER DEFAULT NULL,
    p_newborn_id        IN NUMBER DEFAULT NULL,
    p_chw_id            IN NUMBER,
    p_vaccine_type      IN VARCHAR2,
    p_dose_number       IN NUMBER,
    p_batch_number      IN VARCHAR2
) IS
    v_next_dose_date DATE;
BEGIN
    -- Calculate next dose date based on vaccine type
    v_next_dose_date := CASE p_vaccine_type
        WHEN 'Tetanus Toxoid (TT)' THEN SYSDATE + 30
        WHEN 'OPV' THEN SYSDATE + 42
        WHEN 'Hepatitis B' THEN SYSDATE + 30
        ELSE NULL
    END;
    
    INSERT INTO vaccinations (
        vaccination_id, mother_id, newborn_id, administered_by,
        vaccine_type, dose_number, vaccination_date, next_dose_date, batch_number
    ) VALUES (
        seq_vaccination_id.NEXTVAL, p_mother_id, p_newborn_id, p_chw_id,
        p_vaccine_type, p_dose_number, SYSDATE, v_next_dose_date, p_batch_number
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Vaccination administered: ' || p_vaccine_type || ' Dose ' || p_dose_number);
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20007, 'Error administering vaccination: ' || SQLERRM);
END sp_administer_vaccination;
/

-- ============================================================
-- PROCEDURE 10: Generate CHW Daily Report
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_chw_daily_report(
    p_chw_id    IN NUMBER,
    p_date      IN DATE DEFAULT SYSDATE
) IS
    v_chw_name VARCHAR2(100);
    v_mothers_count NUMBER;
    v_visits_today NUMBER;
    v_open_alerts NUMBER;
    v_pending_anc NUMBER;
BEGIN
    -- Get CHW name
    SELECT full_name INTO v_chw_name FROM community_health_workers WHERE chw_id = p_chw_id;
    
    -- Count assigned mothers
    SELECT COUNT(*) INTO v_mothers_count FROM mothers WHERE assigned_chw_id = p_chw_id;
    
    -- Count today's visits
    SELECT COUNT(*) INTO v_visits_today
    FROM maternal_vitals v
    JOIN pregnancies p ON v.pregnancy_id = p.pregnancy_id
    JOIN mothers m ON p.mother_id = m.mother_id
    WHERE m.assigned_chw_id = p_chw_id AND TRUNC(v.visit_date) = TRUNC(p_date);
    
    -- Count open alerts
    v_open_alerts := count_open_alerts_for_chw(p_chw_id);
    
    -- Count pending ANC visits
    SELECT COUNT(*) INTO v_pending_anc
    FROM anc_schedule a
    JOIN pregnancies p ON a.pregnancy_id = p.pregnancy_id
    JOIN mothers m ON p.mother_id = m.mother_id
    WHERE m.assigned_chw_id = p_chw_id 
    AND a.status = 'Scheduled' 
    AND a.scheduled_date <= SYSDATE + 7;
    
    DBMS_OUTPUT.PUT_LINE('=== CHW DAILY REPORT ===');
    DBMS_OUTPUT.PUT_LINE('CHW: ' || v_chw_name);
    DBMS_OUTPUT.PUT_LINE('Date: ' || TO_CHAR(p_date, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Assigned Mothers: ' || v_mothers_count);
    DBMS_OUTPUT.PUT_LINE('Visits Today: ' || v_visits_today);
    DBMS_OUTPUT.PUT_LINE('Open Alerts: ' || v_open_alerts);
    DBMS_OUTPUT.PUT_LINE('ANC Due (7 days): ' || v_pending_anc);
    DBMS_OUTPUT.PUT_LINE('========================');
    
END sp_chw_daily_report;
/

PROMPT ============================================
PROMPT Procedures Created Successfully!
PROMPT ============================================
