-- ============================================================
-- PHASE VI: WINDOW / ANALYTICAL FUNCTIONS
-- Student: NSHUTI Sano Delphin
-- Student ID: 27903
-- Database: TUE_27903_DELPHIN_MATERNALEWS_DB
-- Date: December 2025
-- ============================================================

-- ============================================================
-- 1. RANK() - Rank Mothers by Risk Score
-- ============================================================
SELECT 
    m.full_name,
    m.district,
    p.risk_level,
    p.last_risk_score,
    RANK() OVER (ORDER BY p.last_risk_score DESC) AS overall_risk_rank,
    RANK() OVER (PARTITION BY m.district ORDER BY p.last_risk_score DESC) AS district_risk_rank
FROM pregnancies p
JOIN mothers m ON p.mother_id = m.mother_id
WHERE p.pregnancy_status = 'Active'
AND p.last_risk_score IS NOT NULL
ORDER BY p.last_risk_score DESC;

-- ============================================================
-- 2. DENSE_RANK() - Dense Rank CHWs by Performance
-- ============================================================
SELECT 
    c.full_name AS chw_name,
    c.assigned_sector,
    COUNT(DISTINCT m.mother_id) AS mothers_assigned,
    COUNT(v.vital_id) AS visits_recorded,
    DENSE_RANK() OVER (ORDER BY COUNT(v.vital_id) DESC) AS performance_rank
FROM community_health_workers c
LEFT JOIN mothers m ON c.chw_id = m.assigned_chw_id
LEFT JOIN pregnancies p ON m.mother_id = p.mother_id
LEFT JOIN maternal_vitals v ON p.pregnancy_id = v.pregnancy_id
WHERE c.is_active = 'Yes'
GROUP BY c.chw_id, c.full_name, c.assigned_sector
ORDER BY visits_recorded DESC;

-- ============================================================
-- 3. ROW_NUMBER() - Unique Row Numbers for Alerts
-- ============================================================
SELECT 
    ROW_NUMBER() OVER (ORDER BY a.alert_timestamp DESC) AS alert_num,
    a.alert_id,
    m.full_name,
    a.severity,
    a.alert_type,
    a.status,
    TO_CHAR(a.alert_timestamp, 'DD-MON-YYYY HH24:MI') AS alert_time
FROM maternal_alerts a
JOIN pregnancies p ON a.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
WHERE a.status IN ('Open', 'Acknowledged')
ORDER BY a.alert_timestamp DESC;

-- ============================================================
-- 4. LAG() - Compare Current vs Previous Vital Signs
-- ============================================================
SELECT 
    v.vital_id,
    m.full_name,
    v.visit_date,
    v.systolic_bp AS current_systolic,
    LAG(v.systolic_bp, 1) OVER (PARTITION BY v.pregnancy_id ORDER BY v.visit_date) AS prev_systolic,
    v.systolic_bp - LAG(v.systolic_bp, 1) OVER (PARTITION BY v.pregnancy_id ORDER BY v.visit_date) AS bp_change,
    CASE 
        WHEN v.systolic_bp - LAG(v.systolic_bp, 1) OVER (PARTITION BY v.pregnancy_id ORDER BY v.visit_date) > 20 
        THEN 'SIGNIFICANT INCREASE'
        WHEN v.systolic_bp - LAG(v.systolic_bp, 1) OVER (PARTITION BY v.pregnancy_id ORDER BY v.visit_date) < -20 
        THEN 'SIGNIFICANT DECREASE'
        ELSE 'STABLE'
    END AS trend
FROM maternal_vitals v
JOIN pregnancies p ON v.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
ORDER BY v.pregnancy_id, v.visit_date;

-- ============================================================
-- 5. LEAD() - Next Scheduled ANC Visit
-- ============================================================
SELECT 
    m.full_name,
    a.visit_number,
    a.scheduled_date,
    a.status,
    LEAD(a.scheduled_date, 1) OVER (PARTITION BY a.pregnancy_id ORDER BY a.visit_number) AS next_visit_date,
    LEAD(a.scheduled_date, 1) OVER (PARTITION BY a.pregnancy_id ORDER BY a.visit_number) - a.scheduled_date AS days_between
FROM anc_schedule a
JOIN pregnancies p ON a.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
WHERE p.pregnancy_status = 'Active'
ORDER BY a.pregnancy_id, a.visit_number;

-- ============================================================
-- 6. FIRST_VALUE() / LAST_VALUE() - First and Last Vitals
-- ============================================================
SELECT DISTINCT
    m.full_name,
    p.pregnancy_id,
    FIRST_VALUE(v.systolic_bp) OVER (
        PARTITION BY v.pregnancy_id ORDER BY v.visit_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS first_systolic,
    LAST_VALUE(v.systolic_bp) OVER (
        PARTITION BY v.pregnancy_id ORDER BY v.visit_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS latest_systolic,
    FIRST_VALUE(v.visit_date) OVER (
        PARTITION BY v.pregnancy_id ORDER BY v.visit_date
    ) AS first_visit,
    LAST_VALUE(v.visit_date) OVER (
        PARTITION BY v.pregnancy_id ORDER BY v.visit_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS latest_visit
FROM maternal_vitals v
JOIN pregnancies p ON v.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
WHERE p.pregnancy_status = 'Active';

-- ============================================================
-- 7. SUM() OVER - Running Total of Alerts
-- ============================================================
SELECT 
    TO_CHAR(TRUNC(a.alert_timestamp), 'DD-MON-YYYY') AS alert_date,
    COUNT(*) AS daily_alerts,
    SUM(COUNT(*)) OVER (ORDER BY TRUNC(a.alert_timestamp)) AS cumulative_alerts
FROM maternal_alerts a
GROUP BY TRUNC(a.alert_timestamp)
ORDER BY TRUNC(a.alert_timestamp);

-- ============================================================
-- 8. AVG() OVER - Moving Average Risk Score
-- ============================================================
SELECT 
    m.full_name,
    v.visit_date,
    calculate_maternal_risk_score(v.vital_id) AS risk_score,
    ROUND(AVG(calculate_maternal_risk_score(v.vital_id)) OVER (
        PARTITION BY v.pregnancy_id 
        ORDER BY v.visit_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3_visits
FROM maternal_vitals v
JOIN pregnancies p ON v.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
ORDER BY v.pregnancy_id, v.visit_date;

-- ============================================================
-- 9. COUNT() OVER - Cumulative Visit Count per Pregnancy
-- ============================================================
SELECT 
    m.full_name,
    v.visit_date,
    v.vital_id,
    COUNT(*) OVER (PARTITION BY v.pregnancy_id ORDER BY v.visit_date) AS visit_num,
    COUNT(*) OVER (PARTITION BY v.pregnancy_id) AS total_visits
FROM maternal_vitals v
JOIN pregnancies p ON v.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
ORDER BY v.pregnancy_id, v.visit_date;

-- ============================================================
-- 10. NTILE() - Divide Pregnancies into Risk Quartiles
-- ============================================================
SELECT 
    m.full_name,
    p.last_risk_score,
    NTILE(4) OVER (ORDER BY p.last_risk_score DESC) AS risk_quartile,
    CASE NTILE(4) OVER (ORDER BY p.last_risk_score DESC)
        WHEN 1 THEN 'Highest Risk (Top 25%)'
        WHEN 2 THEN 'High Risk (25-50%)'
        WHEN 3 THEN 'Moderate Risk (50-75%)'
        WHEN 4 THEN 'Low Risk (Bottom 25%)'
    END AS risk_category
FROM pregnancies p
JOIN mothers m ON p.mother_id = m.mother_id
WHERE p.pregnancy_status = 'Active'
AND p.last_risk_score IS NOT NULL
ORDER BY p.last_risk_score DESC;

-- ============================================================
-- 11. PERCENT_RANK() - Percentile Ranking
-- ============================================================
SELECT 
    m.full_name,
    p.last_risk_score,
    ROUND(PERCENT_RANK() OVER (ORDER BY p.last_risk_score) * 100, 2) AS percentile
FROM pregnancies p
JOIN mothers m ON p.mother_id = m.mother_id
WHERE p.pregnancy_status = 'Active'
AND p.last_risk_score IS NOT NULL
ORDER BY p.last_risk_score DESC;

-- ============================================================
-- 12. PARTITION BY Multiple Columns - District & Risk Analysis
-- ============================================================
SELECT 
    m.district,
    p.risk_level,
    m.full_name,
    p.last_risk_score,
    COUNT(*) OVER (PARTITION BY m.district) AS district_total,
    COUNT(*) OVER (PARTITION BY m.district, p.risk_level) AS district_risk_count,
    ROUND(
        COUNT(*) OVER (PARTITION BY m.district, p.risk_level) * 100.0 / 
        COUNT(*) OVER (PARTITION BY m.district), 2
    ) AS pct_of_district
FROM pregnancies p
JOIN mothers m ON p.mother_id = m.mother_id
WHERE p.pregnancy_status = 'Active'
ORDER BY m.district, p.risk_level, p.last_risk_score DESC;

-- ============================================================
-- 13. Complex Analytics - CHW Dashboard View
-- ============================================================
CREATE OR REPLACE VIEW vw_chw_dashboard AS
SELECT 
    c.chw_id,
    c.full_name AS chw_name,
    c.assigned_sector,
    COUNT(DISTINCT m.mother_id) AS total_mothers,
    COUNT(DISTINCT CASE WHEN p.pregnancy_status = 'Active' THEN p.pregnancy_id END) AS active_pregnancies,
    COUNT(DISTINCT CASE WHEN p.risk_level IN ('High', 'Critical') THEN p.pregnancy_id END) AS high_risk_count,
    COUNT(DISTINCT CASE WHEN a.status = 'Open' THEN a.alert_id END) AS open_alerts,
    RANK() OVER (ORDER BY COUNT(DISTINCT m.mother_id) DESC) AS workload_rank,
    ROUND(AVG(p.last_risk_score), 2) AS avg_risk_score
FROM community_health_workers c
LEFT JOIN mothers m ON c.chw_id = m.assigned_chw_id
LEFT JOIN pregnancies p ON m.mother_id = p.mother_id
LEFT JOIN maternal_alerts a ON p.pregnancy_id = a.pregnancy_id AND a.status = 'Open'
WHERE c.is_active = 'Yes'
GROUP BY c.chw_id, c.full_name, c.assigned_sector;

-- Query the dashboard view
SELECT * FROM vw_chw_dashboard ORDER BY workload_rank;

-- ============================================================
-- 14. District Analytics View
-- ============================================================
CREATE OR REPLACE VIEW vw_district_analytics AS
SELECT 
    m.district,
    COUNT(DISTINCT m.mother_id) AS total_mothers,
    COUNT(DISTINCT CASE WHEN p.pregnancy_status = 'Active' THEN p.pregnancy_id END) AS active_pregnancies,
    COUNT(DISTINCT CASE WHEN p.risk_level = 'Critical' THEN p.pregnancy_id END) AS critical_cases,
    COUNT(DISTINCT CASE WHEN p.risk_level = 'High' THEN p.pregnancy_id END) AS high_risk_cases,
    COUNT(DISTINCT CASE WHEN a.severity = 'Red' AND a.status = 'Open' THEN a.alert_id END) AS red_alerts,
    ROUND(AVG(p.last_risk_score), 2) AS avg_risk_score,
    RANK() OVER (ORDER BY COUNT(DISTINCT CASE WHEN p.risk_level IN ('High', 'Critical') THEN p.pregnancy_id END) DESC) AS concern_rank
FROM mothers m
LEFT JOIN pregnancies p ON m.mother_id = p.mother_id
LEFT JOIN maternal_alerts a ON p.pregnancy_id = a.pregnancy_id
GROUP BY m.district;

-- Query district analytics
SELECT * FROM vw_district_analytics ORDER BY concern_rank;

PROMPT ============================================
PROMPT Window Functions Completed Successfully!
PROMPT ============================================
