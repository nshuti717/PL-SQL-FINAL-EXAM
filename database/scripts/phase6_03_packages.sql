-- ============================================================
-- PHASE VI: PL/SQL PACKAGES
-- Student: NSHUTI Sano Delphin
-- Student ID: 27903
-- Database: TUE_27903_DELPHIN_MATERNALEWS_DB
-- Date: December 2025
-- ============================================================

-- ============================================================
-- PACKAGE 1: EWS_CORE_PKG - Core Early Warning System Package
-- ============================================================

-- Package Specification
CREATE OR REPLACE PACKAGE ews_core_pkg AS
    -- Constants for risk thresholds
    c_red_threshold     CONSTANT NUMBER := 50;
    c_orange_threshold  CONSTANT NUMBER := 25;
    c_yellow_threshold  CONSTANT NUMBER := 15;
    
    -- Types
    TYPE t_alert_rec IS RECORD (
        alert_id        NUMBER,
        mother_name     VARCHAR2(100),
        severity        VARCHAR2(10),
        risk_score      NUMBER,
        alert_type      VARCHAR2(50)
    );
    TYPE t_alert_tab IS TABLE OF t_alert_rec;
    
    -- Risk Assessment Functions
    FUNCTION calc_risk_score(p_vital_id NUMBER) RETURN NUMBER;
    FUNCTION get_severity(p_score NUMBER) RETURN VARCHAR2;
    
    -- Alert Management Procedures
    PROCEDURE process_vital_signs(
        p_pregnancy_id NUMBER,
        p_chw_id NUMBER,
        p_systolic NUMBER,
        p_diastolic NUMBER,
        p_temp NUMBER,
        p_fhr NUMBER
    );
    
    PROCEDURE get_open_alerts(
        p_chw_id NUMBER,
        p_alerts OUT SYS_REFCURSOR
    );
    
    PROCEDURE acknowledge_alert(
        p_alert_id NUMBER,
        p_chw_id NUMBER
    );
    
    -- Statistics Functions
    FUNCTION get_district_alert_count(p_district VARCHAR2) RETURN NUMBER;
    FUNCTION get_chw_performance_score(p_chw_id NUMBER) RETURN NUMBER;
    
END ews_core_pkg;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY ews_core_pkg AS

    -- Calculate Risk Score
    FUNCTION calc_risk_score(p_vital_id NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN calculate_maternal_risk_score(p_vital_id);
    END calc_risk_score;
    
    -- Get Severity Level
    FUNCTION get_severity(p_score NUMBER) RETURN VARCHAR2 IS
    BEGIN
        IF p_score >= c_red_threshold THEN
            RETURN 'Red';
        ELSIF p_score >= c_orange_threshold THEN
            RETURN 'Orange';
        ELSIF p_score >= c_yellow_threshold THEN
            RETURN 'Yellow';
        ELSE
            RETURN 'Green';
        END IF;
    END get_severity;
    
    -- Process Vital Signs
    PROCEDURE process_vital_signs(
        p_pregnancy_id NUMBER,
        p_chw_id NUMBER,
        p_systolic NUMBER,
        p_diastolic NUMBER,
        p_temp NUMBER,
        p_fhr NUMBER
    ) IS
        v_vital_id NUMBER;
        v_score NUMBER;
        v_severity VARCHAR2(10);
    BEGIN
        sp_record_vital_signs(
            p_pregnancy_id => p_pregnancy_id,
            p_chw_id => p_chw_id,
            p_systolic_bp => p_systolic,
            p_diastolic_bp => p_diastolic,
            p_temperature => p_temp,
            p_fetal_heart_rate => p_fhr,
            p_vital_id => v_vital_id,
            p_risk_score => v_score,
            p_alert_severity => v_severity
        );
    END process_vital_signs;
    
    -- Get Open Alerts for CHW
    PROCEDURE get_open_alerts(
        p_chw_id NUMBER,
        p_alerts OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_alerts FOR
            SELECT a.alert_id, m.full_name AS mother_name,
                   a.severity, a.risk_score, a.alert_type
            FROM maternal_alerts a
            JOIN pregnancies p ON a.pregnancy_id = p.pregnancy_id
            JOIN mothers m ON p.mother_id = m.mother_id
            WHERE m.assigned_chw_id = p_chw_id
            AND a.status = 'Open'
            ORDER BY 
                CASE a.severity 
                    WHEN 'Red' THEN 1 
                    WHEN 'Orange' THEN 2 
                    WHEN 'Yellow' THEN 3 
                END;
    END get_open_alerts;
    
    -- Acknowledge Alert
    PROCEDURE acknowledge_alert(
        p_alert_id NUMBER,
        p_chw_id NUMBER
    ) IS
    BEGIN
        UPDATE maternal_alerts
        SET status = 'Acknowledged',
            resolved_by = p_chw_id
        WHERE alert_id = p_alert_id;
        COMMIT;
    END acknowledge_alert;
    
    -- Get District Alert Count
    FUNCTION get_district_alert_count(p_district VARCHAR2) RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM maternal_alerts a
        JOIN pregnancies p ON a.pregnancy_id = p.pregnancy_id
        JOIN mothers m ON p.mother_id = m.mother_id
        WHERE m.district = p_district
        AND a.status = 'Open';
        RETURN v_count;
    END get_district_alert_count;
    
    -- Get CHW Performance Score
    FUNCTION get_chw_performance_score(p_chw_id NUMBER) RETURN NUMBER IS
        v_visits NUMBER;
        v_resolved NUMBER;
        v_score NUMBER;
    BEGIN
        -- Count visits this month
        SELECT COUNT(*) INTO v_visits
        FROM maternal_vitals v
        JOIN pregnancies p ON v.pregnancy_id = p.pregnancy_id
        JOIN mothers m ON p.mother_id = m.mother_id
        WHERE m.assigned_chw_id = p_chw_id
        AND v.visit_date >= TRUNC(SYSDATE, 'MM');
        
        -- Count resolved alerts
        SELECT COUNT(*) INTO v_resolved
        FROM maternal_alerts a
        WHERE a.resolved_by = p_chw_id
        AND a.resolved_date >= TRUNC(SYSDATE, 'MM');
        
        -- Calculate score (visits * 10 + resolved * 20)
        v_score := (v_visits * 10) + (v_resolved * 20);
        RETURN v_score;
    END get_chw_performance_score;
    
END ews_core_pkg;
/

-- ============================================================
-- PACKAGE 2: EWS_REPORTS_PKG - Reporting Package
-- ============================================================

-- Package Specification
CREATE OR REPLACE PACKAGE ews_reports_pkg AS
    
    -- Report Procedures
    PROCEDURE daily_summary_report(p_date DATE DEFAULT SYSDATE);
    PROCEDURE district_dashboard(p_district VARCHAR2);
    PROCEDURE chw_performance_report(p_chw_id NUMBER);
    PROCEDURE high_risk_pregnancies_report;
    PROCEDURE vaccination_coverage_report;
    PROCEDURE anc_compliance_report;
    
END ews_reports_pkg;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY ews_reports_pkg AS

    -- Daily Summary Report
    PROCEDURE daily_summary_report(p_date DATE DEFAULT SYSDATE) IS
        v_new_registrations NUMBER;
        v_visits NUMBER;
        v_alerts_generated NUMBER;
        v_referrals NUMBER;
        v_deliveries NUMBER;
    BEGIN
        -- New mother registrations
        SELECT COUNT(*) INTO v_new_registrations
        FROM mothers WHERE TRUNC(created_date) = TRUNC(p_date);
        
        -- Visits conducted
        SELECT COUNT(*) INTO v_visits
        FROM maternal_vitals WHERE TRUNC(visit_date) = TRUNC(p_date);
        
        -- Alerts generated
        SELECT COUNT(*) INTO v_alerts_generated
        FROM maternal_alerts WHERE TRUNC(alert_timestamp) = TRUNC(p_date);
        
        -- Referrals made
        SELECT COUNT(*) INTO v_referrals
        FROM referrals WHERE TRUNC(referral_date) = TRUNC(p_date);
        
        -- Deliveries
        SELECT COUNT(*) INTO v_deliveries
        FROM newborns WHERE TRUNC(birth_date) = TRUNC(p_date);
        
        DBMS_OUTPUT.PUT_LINE('=== DAILY SUMMARY REPORT ===');
        DBMS_OUTPUT.PUT_LINE('Date: ' || TO_CHAR(p_date, 'DD-MON-YYYY'));
        DBMS_OUTPUT.PUT_LINE('----------------------------');
        DBMS_OUTPUT.PUT_LINE('New Registrations: ' || v_new_registrations);
        DBMS_OUTPUT.PUT_LINE('Visits Conducted: ' || v_visits);
        DBMS_OUTPUT.PUT_LINE('Alerts Generated: ' || v_alerts_generated);
        DBMS_OUTPUT.PUT_LINE('Referrals Made: ' || v_referrals);
        DBMS_OUTPUT.PUT_LINE('Deliveries: ' || v_deliveries);
        DBMS_OUTPUT.PUT_LINE('============================');
    END daily_summary_report;
    
    -- District Dashboard
    PROCEDURE district_dashboard(p_district VARCHAR2) IS
        v_mothers NUMBER;
        v_active_pregnancies NUMBER;
        v_high_risk NUMBER;
        v_open_alerts NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_mothers
        FROM mothers WHERE district = p_district;
        
        SELECT COUNT(*) INTO v_active_pregnancies
        FROM pregnancies p
        JOIN mothers m ON p.mother_id = m.mother_id
        WHERE m.district = p_district AND p.pregnancy_status = 'Active';
        
        SELECT COUNT(*) INTO v_high_risk
        FROM pregnancies p
        JOIN mothers m ON p.mother_id = m.mother_id
        WHERE m.district = p_district 
        AND p.risk_level IN ('High', 'Critical');
        
        v_open_alerts := ews_core_pkg.get_district_alert_count(p_district);
        
        DBMS_OUTPUT.PUT_LINE('=== DISTRICT DASHBOARD ===');
        DBMS_OUTPUT.PUT_LINE('District: ' || p_district);
        DBMS_OUTPUT.PUT_LINE('--------------------------');
        DBMS_OUTPUT.PUT_LINE('Total Mothers: ' || v_mothers);
        DBMS_OUTPUT.PUT_LINE('Active Pregnancies: ' || v_active_pregnancies);
        DBMS_OUTPUT.PUT_LINE('High Risk Cases: ' || v_high_risk);
        DBMS_OUTPUT.PUT_LINE('Open Alerts: ' || v_open_alerts);
        DBMS_OUTPUT.PUT_LINE('==========================');
    END district_dashboard;
    
    -- CHW Performance Report
    PROCEDURE chw_performance_report(p_chw_id NUMBER) IS
        v_name VARCHAR2(100);
        v_sector VARCHAR2(50);
        v_mothers NUMBER;
        v_visits NUMBER;
        v_alerts_resolved NUMBER;
        v_score NUMBER;
    BEGIN
        SELECT full_name, assigned_sector
        INTO v_name, v_sector
        FROM community_health_workers WHERE chw_id = p_chw_id;
        
        SELECT COUNT(*) INTO v_mothers
        FROM mothers WHERE assigned_chw_id = p_chw_id;
        
        SELECT COUNT(*) INTO v_visits
        FROM maternal_vitals v
        JOIN pregnancies p ON v.pregnancy_id = p.pregnancy_id
        JOIN mothers m ON p.mother_id = m.mother_id
        WHERE m.assigned_chw_id = p_chw_id
        AND v.visit_date >= TRUNC(SYSDATE, 'MM');
        
        SELECT COUNT(*) INTO v_alerts_resolved
        FROM maternal_alerts WHERE resolved_by = p_chw_id;
        
        v_score := ews_core_pkg.get_chw_performance_score(p_chw_id);
        
        DBMS_OUTPUT.PUT_LINE('=== CHW PERFORMANCE REPORT ===');
        DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
        DBMS_OUTPUT.PUT_LINE('Sector: ' || v_sector);
        DBMS_OUTPUT.PUT_LINE('------------------------------');
        DBMS_OUTPUT.PUT_LINE('Assigned Mothers: ' || v_mothers);
        DBMS_OUTPUT.PUT_LINE('Visits This Month: ' || v_visits);
        DBMS_OUTPUT.PUT_LINE('Alerts Resolved: ' || v_alerts_resolved);
        DBMS_OUTPUT.PUT_LINE('Performance Score: ' || v_score);
        DBMS_OUTPUT.PUT_LINE('==============================');
    END chw_performance_report;
    
    -- High Risk Pregnancies Report
    PROCEDURE high_risk_pregnancies_report IS
        CURSOR c_high_risk IS
            SELECT m.full_name, p.pregnancy_id, p.risk_level, 
                   p.last_risk_score, p.estimated_delivery_date
            FROM pregnancies p
            JOIN mothers m ON p.mother_id = m.mother_id
            WHERE p.pregnancy_status = 'Active'
            AND p.risk_level IN ('High', 'Critical')
            ORDER BY p.last_risk_score DESC;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== HIGH RISK PREGNANCIES ===');
        DBMS_OUTPUT.PUT_LINE('Mother Name | Risk Level | Score | EDD');
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
        
        FOR r IN c_high_risk LOOP
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r.full_name, 25) || ' | ' ||
                RPAD(r.risk_level, 10) || ' | ' ||
                LPAD(r.last_risk_score, 5) || ' | ' ||
                TO_CHAR(r.estimated_delivery_date, 'DD-MON-YY')
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('=============================');
    END high_risk_pregnancies_report;
    
    -- Vaccination Coverage Report
    PROCEDURE vaccination_coverage_report IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== VACCINATION COVERAGE ===');
        FOR r IN (
            SELECT vaccine_type, COUNT(*) AS doses_given,
                   COUNT(DISTINCT NVL(mother_id, 0) + NVL(newborn_id, 0)) AS recipients
            FROM vaccinations
            GROUP BY vaccine_type
            ORDER BY doses_given DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(r.vaccine_type || ': ' || r.doses_given || ' doses, ' || r.recipients || ' recipients');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('============================');
    END vaccination_coverage_report;
    
    -- ANC Compliance Report
    PROCEDURE anc_compliance_report IS
        v_total NUMBER;
        v_completed NUMBER;
        v_missed NUMBER;
        v_scheduled NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_total FROM anc_schedule;
        SELECT COUNT(*) INTO v_completed FROM anc_schedule WHERE status = 'Completed';
        SELECT COUNT(*) INTO v_missed FROM anc_schedule WHERE status = 'Missed';
        SELECT COUNT(*) INTO v_scheduled FROM anc_schedule WHERE status = 'Scheduled';
        
        DBMS_OUTPUT.PUT_LINE('=== ANC COMPLIANCE REPORT ===');
        DBMS_OUTPUT.PUT_LINE('Total Scheduled Visits: ' || v_total);
        DBMS_OUTPUT.PUT_LINE('Completed: ' || v_completed || ' (' || ROUND(v_completed/v_total*100, 1) || '%)');
        DBMS_OUTPUT.PUT_LINE('Missed: ' || v_missed || ' (' || ROUND(v_missed/v_total*100, 1) || '%)');
        DBMS_OUTPUT.PUT_LINE('Pending: ' || v_scheduled || ' (' || ROUND(v_scheduled/v_total*100, 1) || '%)');
        DBMS_OUTPUT.PUT_LINE('=============================');
    END anc_compliance_report;
    
END ews_reports_pkg;
/

-- ============================================================
-- TEST PACKAGES
-- ============================================================
SET SERVEROUTPUT ON;

-- Test Core Package
DECLARE
    v_alerts SYS_REFCURSOR;
    v_alert_id NUMBER;
    v_mother VARCHAR2(100);
    v_severity VARCHAR2(10);
    v_score NUMBER;
    v_type VARCHAR2(50);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing EWS_CORE_PKG...');
    DBMS_OUTPUT.PUT_LINE('District Kigali alerts: ' || ews_core_pkg.get_district_alert_count('Kigali'));
    DBMS_OUTPUT.PUT_LINE('CHW 1 performance: ' || ews_core_pkg.get_chw_performance_score(1));
END;
/

-- Test Reports Package
BEGIN
    ews_reports_pkg.daily_summary_report;
    ews_reports_pkg.district_dashboard('Kigali');
    ews_reports_pkg.high_risk_pregnancies_report;
    ews_reports_pkg.vaccination_coverage_report;
    ews_reports_pkg.anc_compliance_report;
END;
/

PROMPT ============================================
PROMPT Packages Created Successfully!
PROMPT ============================================
