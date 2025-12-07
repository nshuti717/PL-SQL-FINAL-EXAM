-- ============================================================
-- PHASE VI: PL/SQL CURSORS
-- Student: NSHUTI Sano Delphin
-- Student ID: 27903
-- Database: TUE_27903_DELPHIN_MATERNALEWS_DB
-- Date: December 2025
-- ============================================================

SET SERVEROUTPUT ON;

-- ============================================================
-- CURSOR 1: Explicit Cursor - High Risk Pregnancies
-- ============================================================
DECLARE
    CURSOR c_high_risk IS
        SELECT p.pregnancy_id, m.full_name, m.phone_number,
               p.risk_level, p.last_risk_score, p.estimated_delivery_date,
               c.full_name AS chw_name
        FROM pregnancies p
        JOIN mothers m ON p.mother_id = m.mother_id
        JOIN community_health_workers c ON m.assigned_chw_id = c.chw_id
        WHERE p.pregnancy_status = 'Active'
        AND p.risk_level IN ('High', 'Critical')
        ORDER BY p.last_risk_score DESC;
    
    v_rec c_high_risk%ROWTYPE;
    v_count NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== HIGH RISK PREGNANCIES REPORT ===');
    DBMS_OUTPUT.PUT_LINE('Generated: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI'));
    DBMS_OUTPUT.PUT_LINE('=====================================');
    
    OPEN c_high_risk;
    LOOP
        FETCH c_high_risk INTO v_rec;
        EXIT WHEN c_high_risk%NOTFOUND;
        
        v_count := v_count + 1;
        DBMS_OUTPUT.PUT_LINE(v_count || '. ' || v_rec.full_name);
        DBMS_OUTPUT.PUT_LINE('   Risk: ' || v_rec.risk_level || ' (Score: ' || v_rec.last_risk_score || ')');
        DBMS_OUTPUT.PUT_LINE('   EDD: ' || TO_CHAR(v_rec.estimated_delivery_date, 'DD-MON-YYYY'));
        DBMS_OUTPUT.PUT_LINE('   CHW: ' || v_rec.chw_name);
        DBMS_OUTPUT.PUT_LINE('   Phone: ' || v_rec.phone_number);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    END LOOP;
    CLOSE c_high_risk;
    
    DBMS_OUTPUT.PUT_LINE('Total High Risk Cases: ' || v_count);
END;
/

-- ============================================================
-- CURSOR 2: Cursor FOR Loop - Open Alerts Summary
-- ============================================================
DECLARE
    v_total NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== OPEN ALERTS BY SEVERITY ===');
    
    FOR r IN (
        SELECT severity, COUNT(*) AS alert_count
        FROM maternal_alerts
        WHERE status = 'Open'
        GROUP BY severity
        ORDER BY CASE severity 
            WHEN 'Red' THEN 1 
            WHEN 'Orange' THEN 2 
            WHEN 'Yellow' THEN 3 
        END
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(r.severity, 10) || ': ' || r.alert_count || ' alerts');
        v_total := v_total + r.alert_count;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('-------------------------------');
    DBMS_OUTPUT.PUT_LINE('Total Open: ' || v_total);
END;
/

-- ============================================================
-- CURSOR 3: Parameterized Cursor - CHW Workload
-- ============================================================
DECLARE
    CURSOR c_chw_workload(p_sector VARCHAR2) IS
        SELECT c.chw_id, c.full_name, c.assigned_sector,
               COUNT(DISTINCT m.mother_id) AS mothers_count,
               COUNT(DISTINCT CASE WHEN p.pregnancy_status = 'Active' THEN p.pregnancy_id END) AS active_pregnancies
        FROM community_health_workers c
        LEFT JOIN mothers m ON c.chw_id = m.assigned_chw_id
        LEFT JOIN pregnancies p ON m.mother_id = p.mother_id
        WHERE c.assigned_sector = p_sector OR p_sector IS NULL
        GROUP BY c.chw_id, c.full_name, c.assigned_sector
        ORDER BY mothers_count DESC;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== CHW WORKLOAD - GASABO SECTOR ===');
    
    FOR r IN c_chw_workload('Gasabo') LOOP
        DBMS_OUTPUT.PUT_LINE(r.full_name || ' | Mothers: ' || r.mothers_count || 
                            ' | Active Pregnancies: ' || r.active_pregnancies);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== CHW WORKLOAD - ALL SECTORS ===');
    
    FOR r IN c_chw_workload(NULL) LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(r.full_name, 25) || ' | ' || 
                            RPAD(r.assigned_sector, 15) || ' | ' ||
                            'M:' || LPAD(r.mothers_count, 3) || ' | ' ||
                            'P:' || LPAD(r.active_pregnancies, 3));
    END LOOP;
END;
/

-- ============================================================
-- CURSOR 4: REF CURSOR - Dynamic Alert Retrieval
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_get_alerts_by_criteria(
    p_severity      IN VARCHAR2 DEFAULT NULL,
    p_status        IN VARCHAR2 DEFAULT NULL,
    p_district      IN VARCHAR2 DEFAULT NULL,
    p_result        OUT SYS_REFCURSOR
) IS
    v_sql VARCHAR2(2000);
BEGIN
    v_sql := 'SELECT a.alert_id, m.full_name AS mother_name, a.severity, 
                     a.alert_type, a.risk_score, a.status, a.alert_timestamp
              FROM maternal_alerts a
              JOIN pregnancies p ON a.pregnancy_id = p.pregnancy_id
              JOIN mothers m ON p.mother_id = m.mother_id
              WHERE 1=1';
    
    IF p_severity IS NOT NULL THEN
        v_sql := v_sql || ' AND a.severity = ''' || p_severity || '''';
    END IF;
    
    IF p_status IS NOT NULL THEN
        v_sql := v_sql || ' AND a.status = ''' || p_status || '''';
    END IF;
    
    IF p_district IS NOT NULL THEN
        v_sql := v_sql || ' AND m.district = ''' || p_district || '''';
    END IF;
    
    v_sql := v_sql || ' ORDER BY a.alert_timestamp DESC';
    
    OPEN p_result FOR v_sql;
END sp_get_alerts_by_criteria;
/

-- Test REF CURSOR
DECLARE
    v_cursor SYS_REFCURSOR;
    v_alert_id NUMBER;
    v_mother VARCHAR2(100);
    v_severity VARCHAR2(10);
    v_type VARCHAR2(50);
    v_score NUMBER;
    v_status VARCHAR2(20);
    v_timestamp TIMESTAMP;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== RED ALERTS (Dynamic Cursor) ===');
    
    sp_get_alerts_by_criteria(
        p_severity => 'Red',
        p_status => 'Open',
        p_result => v_cursor
    );
    
    LOOP
        FETCH v_cursor INTO v_alert_id, v_mother, v_severity, v_type, v_score, v_status, v_timestamp;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Alert #' || v_alert_id || ' | ' || v_mother || ' | ' || v_type);
    END LOOP;
    CLOSE v_cursor;
END;
/

-- ============================================================
-- CURSOR 5: Cursor with BULK COLLECT
-- ============================================================
DECLARE
    TYPE t_mother_rec IS RECORD (
        mother_id NUMBER,
        full_name VARCHAR2(100),
        district VARCHAR2(50),
        active_pregnancies NUMBER
    );
    TYPE t_mother_tab IS TABLE OF t_mother_rec;
    
    v_mothers t_mother_tab;
    
    CURSOR c_mothers IS
        SELECT m.mother_id, m.full_name, m.district,
               COUNT(CASE WHEN p.pregnancy_status = 'Active' THEN 1 END) AS active_pregnancies
        FROM mothers m
        LEFT JOIN pregnancies p ON m.mother_id = p.mother_id
        GROUP BY m.mother_id, m.full_name, m.district;
BEGIN
    OPEN c_mothers;
    FETCH c_mothers BULK COLLECT INTO v_mothers LIMIT 100;
    CLOSE c_mothers;
    
    DBMS_OUTPUT.PUT_LINE('=== MOTHERS BULK COLLECT ===');
    DBMS_OUTPUT.PUT_LINE('Loaded ' || v_mothers.COUNT || ' mothers');
    
    -- Process first 10
    FOR i IN 1..LEAST(10, v_mothers.COUNT) LOOP
        DBMS_OUTPUT.PUT_LINE(v_mothers(i).full_name || ' | ' || 
                            v_mothers(i).district || ' | ' ||
                            'Pregnancies: ' || v_mothers(i).active_pregnancies);
    END LOOP;
END;
/

-- ============================================================
-- CURSOR 6: Cursor with FOR UPDATE (Locking)
-- ============================================================
DECLARE
    CURSOR c_pending_anc IS
        SELECT a.schedule_id, a.pregnancy_id, a.visit_number, a.scheduled_date
        FROM anc_schedule a
        WHERE a.status = 'Scheduled'
        AND a.scheduled_date < SYSDATE
        FOR UPDATE OF a.status;
    
    v_updated NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== UPDATING MISSED ANC VISITS ===');
    
    FOR r IN c_pending_anc LOOP
        UPDATE anc_schedule
        SET status = 'Missed'
        WHERE CURRENT OF c_pending_anc;
        
        v_updated := v_updated + 1;
        DBMS_OUTPUT.PUT_LINE('Marked as missed: Schedule #' || r.schedule_id || 
                            ' (Visit ' || r.visit_number || ')');
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Total updated: ' || v_updated);
    ROLLBACK; -- Rollback for demo purposes
END;
/

-- ============================================================
-- CURSOR 7: Nested Cursors - District Summary
-- ============================================================
DECLARE
    CURSOR c_districts IS
        SELECT DISTINCT district FROM mothers ORDER BY district;
    
    CURSOR c_district_stats(p_district VARCHAR2) IS
        SELECT 
            COUNT(DISTINCT m.mother_id) AS total_mothers,
            COUNT(DISTINCT CASE WHEN p.pregnancy_status = 'Active' THEN p.pregnancy_id END) AS active_pregnancies,
            COUNT(DISTINCT CASE WHEN p.risk_level IN ('High', 'Critical') THEN p.pregnancy_id END) AS high_risk
        FROM mothers m
        LEFT JOIN pregnancies p ON m.mother_id = p.mother_id
        WHERE m.district = p_district;
    
    v_stats c_district_stats%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== DISTRICT SUMMARY REPORT ===');
    DBMS_OUTPUT.PUT_LINE(RPAD('District', 15) || ' | ' || 
                        LPAD('Mothers', 8) || ' | ' ||
                        LPAD('Active', 8) || ' | ' ||
                        LPAD('HighRisk', 8));
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
    
    FOR r_dist IN c_districts LOOP
        OPEN c_district_stats(r_dist.district);
        FETCH c_district_stats INTO v_stats;
        CLOSE c_district_stats;
        
        DBMS_OUTPUT.PUT_LINE(
            RPAD(r_dist.district, 15) || ' | ' ||
            LPAD(v_stats.total_mothers, 8) || ' | ' ||
            LPAD(v_stats.active_pregnancies, 8) || ' | ' ||
            LPAD(v_stats.high_risk, 8)
        );
    END LOOP;
END;
/

-- ============================================================
-- CURSOR 8: Implicit Cursor Attributes
-- ============================================================
DECLARE
    v_updated NUMBER;
BEGIN
    -- Update all low-risk pregnancies that haven't been checked in 30 days
    UPDATE pregnancies p
    SET risk_level = 'Medium'
    WHERE pregnancy_status = 'Active'
    AND risk_level = 'Low'
    AND NOT EXISTS (
        SELECT 1 FROM maternal_vitals v 
        WHERE v.pregnancy_id = p.pregnancy_id 
        AND v.visit_date > SYSDATE - 30
    );
    
    v_updated := SQL%ROWCOUNT;
    
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Updated ' || v_updated || ' pregnancies to Medium risk (no recent visits)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No pregnancies needed updating');
    END IF;
    
    ROLLBACK; -- Rollback for demo
END;
/

PROMPT ============================================
PROMPT Cursor Examples Completed Successfully!
PROMPT ============================================
