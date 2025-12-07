-- ============================================================
-- PHASE VI: PL/SQL FUNCTIONS
-- Student: NSHUTI Sano Delphin
-- Student ID: 27903
-- Database: TUE_27903_DELPHIN_MATERNALEWS_DB
-- Date: December 2025
-- ============================================================

-- ============================================================
-- FUNCTION 1: Calculate Maternal Risk Score
-- Based on WHO guidelines for pregnancy risk assessment
-- ============================================================
CREATE OR REPLACE FUNCTION calculate_maternal_risk_score(
    p_vital_id IN NUMBER
) RETURN NUMBER IS
    v_score NUMBER := 0;
    v_systolic NUMBER;
    v_diastolic NUMBER;
    v_temperature NUMBER;
    v_fetal_hr NUMBER;
    v_hemoglobin NUMBER;
    v_bleeding VARCHAR2(3);
    v_headache VARCHAR2(3);
    v_vision VARCHAR2(3);
    v_convulsions VARCHAR2(3);
    v_reduced_movement VARCHAR2(3);
BEGIN
    -- Get vital signs
    SELECT systolic_bp, diastolic_bp, temperature, fetal_heart_rate,
           hemoglobin_level, vaginal_bleeding, severe_headache,
           blurred_vision, convulsions, reduced_fetal_movement
    INTO v_systolic, v_diastolic, v_temperature, v_fetal_hr,
         v_hemoglobin, v_bleeding, v_headache, v_vision, v_convulsions, v_reduced_movement
    FROM maternal_vitals
    WHERE vital_id = p_vital_id;
    
    -- Blood Pressure Scoring (Hypertension)
    IF v_systolic >= 160 OR v_diastolic >= 110 THEN
        v_score := v_score + 30;  -- Severe hypertension
    ELSIF v_systolic >= 140 OR v_diastolic >= 90 THEN
        v_score := v_score + 15;  -- Mild hypertension
    END IF;
    
    -- Temperature Scoring (Fever/Infection)
    IF v_temperature >= 38.5 THEN
        v_score := v_score + 15;  -- High fever
    ELSIF v_temperature >= 37.5 THEN
        v_score := v_score + 5;   -- Low-grade fever
    END IF;
    
    -- Fetal Heart Rate Scoring (Distress)
    IF v_fetal_hr IS NOT NULL THEN
        IF v_fetal_hr < 110 OR v_fetal_hr > 160 THEN
            v_score := v_score + 15;  -- Fetal distress
        END IF;
    END IF;
    
    -- Hemoglobin Scoring (Anemia)
    IF v_hemoglobin IS NOT NULL THEN
        IF v_hemoglobin < 7 THEN
            v_score := v_score + 20;  -- Severe anemia
        ELSIF v_hemoglobin < 10 THEN
            v_score := v_score + 10;  -- Moderate anemia
        END IF;
    END IF;
    
    -- Danger Signs Scoring
    IF v_bleeding = 'Yes' THEN
        v_score := v_score + 25;  -- Vaginal bleeding
    END IF;
    
    IF v_headache = 'Yes' THEN
        v_score := v_score + 10;  -- Severe headache
    END IF;
    
    IF v_vision = 'Yes' THEN
        v_score := v_score + 10;  -- Blurred vision
    END IF;
    
    IF v_convulsions = 'Yes' THEN
        v_score := v_score + 30;  -- Convulsions (eclampsia risk)
    END IF;
    
    IF v_reduced_movement = 'Yes' THEN
        v_score := v_score + 10;  -- Reduced fetal movement
    END IF;
    
    RETURN v_score;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1;  -- Vital record not found
    WHEN OTHERS THEN
        RETURN -2;  -- Other error
END calculate_maternal_risk_score;
/

-- ============================================================
-- FUNCTION 2: Get Alert Severity from Risk Score
-- ============================================================
CREATE OR REPLACE FUNCTION get_alert_severity(
    p_risk_score IN NUMBER
) RETURN VARCHAR2 IS
BEGIN
    IF p_risk_score >= 50 THEN
        RETURN 'Red';      -- Emergency: Immediate action
    ELSIF p_risk_score >= 25 THEN
        RETURN 'Orange';   -- Urgent: Within 24 hours
    ELSIF p_risk_score >= 15 THEN
        RETURN 'Yellow';   -- Routine: Schedule follow-up
    ELSE
        RETURN 'Green';    -- Normal: Continue monitoring
    END IF;
END get_alert_severity;
/

-- ============================================================
-- FUNCTION 3: Calculate Gestational Age
-- ============================================================
CREATE OR REPLACE FUNCTION calculate_gestational_age(
    p_pregnancy_id IN NUMBER
) RETURN NUMBER IS
    v_start_date DATE;
    v_weeks NUMBER;
BEGIN
    SELECT pregnancy_start_date
    INTO v_start_date
    FROM pregnancies
    WHERE pregnancy_id = p_pregnancy_id;
    
    v_weeks := TRUNC((SYSDATE - v_start_date) / 7);
    
    RETURN v_weeks;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1;
END calculate_gestational_age;
/

-- ============================================================
-- FUNCTION 4: Get Mother Age
-- ============================================================
CREATE OR REPLACE FUNCTION get_mother_age(
    p_mother_id IN NUMBER
) RETURN NUMBER IS
    v_dob DATE;
    v_age NUMBER;
BEGIN
    SELECT date_of_birth INTO v_dob
    FROM mothers
    WHERE mother_id = p_mother_id;
    
    v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, v_dob) / 12);
    
    RETURN v_age;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1;
END get_mother_age;
/

-- ============================================================
-- FUNCTION 5: Check High Risk Pregnancy
-- ============================================================
CREATE OR REPLACE FUNCTION is_high_risk_pregnancy(
    p_pregnancy_id IN NUMBER
) RETURN VARCHAR2 IS
    v_risk_level VARCHAR2(10);
    v_mother_age NUMBER;
    v_gravida NUMBER;
    v_mother_id NUMBER;
BEGIN
    SELECT p.risk_level, p.gravida, p.mother_id
    INTO v_risk_level, v_gravida, v_mother_id
    FROM pregnancies p
    WHERE pregnancy_id = p_pregnancy_id;
    
    -- Get mother's age
    v_mother_age := get_mother_age(v_mother_id);
    
    -- Check high risk conditions
    IF v_risk_level IN ('High', 'Critical') THEN
        RETURN 'Yes';
    ELSIF v_mother_age < 18 OR v_mother_age > 35 THEN
        RETURN 'Yes';  -- Age risk
    ELSIF v_gravida > 4 THEN
        RETURN 'Yes';  -- Grand multipara
    ELSE
        RETURN 'No';
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Unknown';
END is_high_risk_pregnancy;
/

-- ============================================================
-- FUNCTION 6: Count Open Alerts for CHW
-- ============================================================
CREATE OR REPLACE FUNCTION count_open_alerts_for_chw(
    p_chw_id IN NUMBER
) RETURN NUMBER IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM maternal_alerts a
    JOIN pregnancies p ON a.pregnancy_id = p.pregnancy_id
    JOIN mothers m ON p.mother_id = m.mother_id
    WHERE m.assigned_chw_id = p_chw_id
    AND a.status = 'Open';
    
    RETURN v_count;
END count_open_alerts_for_chw;
/

-- ============================================================
-- FUNCTION 7: Get Days Until Delivery
-- ============================================================
CREATE OR REPLACE FUNCTION days_until_delivery(
    p_pregnancy_id IN NUMBER
) RETURN NUMBER IS
    v_edd DATE;
    v_days NUMBER;
BEGIN
    SELECT estimated_delivery_date
    INTO v_edd
    FROM pregnancies
    WHERE pregnancy_id = p_pregnancy_id;
    
    v_days := TRUNC(v_edd - SYSDATE);
    
    RETURN v_days;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -999;
END days_until_delivery;
/

-- ============================================================
-- TEST FUNCTIONS
-- ============================================================
-- Test risk score calculation
SELECT vital_id, 
       calculate_maternal_risk_score(vital_id) AS risk_score,
       get_alert_severity(calculate_maternal_risk_score(vital_id)) AS severity
FROM maternal_vitals
WHERE ROWNUM <= 10;

-- Test gestational age
SELECT pregnancy_id, 
       calculate_gestational_age(pregnancy_id) AS weeks
FROM pregnancies
WHERE ROWNUM <= 5;

-- Test high risk check
SELECT pregnancy_id,
       is_high_risk_pregnancy(pregnancy_id) AS is_high_risk
FROM pregnancies
WHERE ROWNUM <= 10;

PROMPT ============================================
PROMPT Functions Created Successfully!
PROMPT ============================================
