-- ============================================================
-- ANALYTICS QUERIES (Window Functions & Advanced Analytics)
-- Maternal & Newborn Early Warning System
-- Student: NSHUTI Sano Delphin | ID: 27903
-- ============================================================

-- ============================================================
-- RANKING FUNCTIONS
-- ============================================================

-- 1. Rank mothers by risk score (highest risk first)
SELECT 
    m.first_name || ' ' || m.last_name AS mother_name,
    p.risk_level,
    a.risk_score,
    RANK() OVER (ORDER BY a.risk_score DESC) AS risk_rank,
    DENSE_RANK() OVER (ORDER BY a.risk_score DESC) AS dense_risk_rank
FROM mothers m
JOIN pregnancies p ON m.mother_id = p.mother_id
JOIN maternal_alerts a ON p.pregnancy_id = a.pregnancy_id
WHERE p.status = 'ACTIVE'
ORDER BY risk_rank;

-- 2. Rank CHWs by number of active pregnancies
SELECT 
    c.first_name || ' ' || c.last_name AS chw_name,
    c.sector,
    COUNT(p.pregnancy_id) AS active_cases,
    RANK() OVER (ORDER BY COUNT(p.pregnancy_id) DESC) AS workload_rank,
    ROW_NUMBER() OVER (ORDER BY COUNT(p.pregnancy_id) DESC) AS row_num
FROM community_health_workers c
LEFT JOIN pregnancies p ON c.chw_id = p.assigned_chw_id AND p.status = 'ACTIVE'
GROUP BY c.chw_id, c.first_name, c.last_name, c.sector
ORDER BY workload_rank;

-- 3. Rank sectors by alert frequency
SELECT 
    m.sector,
    COUNT(a.alert_id) AS total_alerts,
    SUM(CASE WHEN a.severity = 'RED' THEN 1 ELSE 0 END) AS red_alerts,
    RANK() OVER (ORDER BY COUNT(a.alert_id) DESC) AS alert_rank
FROM maternal_alerts a
JOIN pregnancies p ON a.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
GROUP BY m.sector
ORDER BY alert_rank;

-- ============================================================
-- LAG/LEAD FUNCTIONS (Trend Analysis)
-- ============================================================

-- 4. Track blood pressure changes over time for each mother
SELECT 
    m.first_name || ' ' || m.last_name AS mother_name,
    v.recorded_at,
    v.systolic_bp,
    v.diastolic_bp,
    LAG(v.systolic_bp) OVER (PARTITION BY p.mother_id ORDER BY v.recorded_at) AS prev_systolic,
    v.systolic_bp - LAG(v.systolic_bp) OVER (PARTITION BY p.mother_id ORDER BY v.recorded_at) AS systolic_change,
    CASE 
        WHEN v.systolic_bp > LAG(v.systolic_bp) OVER (PARTITION BY p.mother_id ORDER BY v.recorded_at) 
        THEN 'INCREASING'
        WHEN v.systolic_bp < LAG(v.systolic_bp) OVER (PARTITION BY p.mother_id ORDER BY v.recorded_at) 
        THEN 'DECREASING'
        ELSE 'STABLE'
    END AS bp_trend
FROM maternal_vitals v
JOIN pregnancies p ON v.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
ORDER BY m.mother_id, v.recorded_at;

-- 5. Track weight changes during pregnancy
SELECT 
    m.first_name || ' ' || m.last_name AS mother_name,
    v.recorded_at,
    v.weight_kg,
    LAG(v.weight_kg) OVER (PARTITION BY p.mother_id ORDER BY v.recorded_at) AS prev_weight,
    v.weight_kg - LAG(v.weight_kg) OVER (PARTITION BY p.mother_id ORDER BY v.recorded_at) AS weight_gain,
    LEAD(v.weight_kg) OVER (PARTITION BY p.mother_id ORDER BY v.recorded_at) AS next_weight
FROM maternal_vitals v
JOIN pregnancies p ON v.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
ORDER BY m.mother_id, v.recorded_at;

-- 6. Alert severity progression
SELECT 
    m.first_name || ' ' || m.last_name AS mother_name,
    a.created_at,
    a.severity,
    a.risk_score,
    LAG(a.severity) OVER (PARTITION BY p.mother_id ORDER BY a.created_at) AS prev_severity,
    LAG(a.risk_score) OVER (PARTITION BY p.mother_id ORDER BY a.created_at) AS prev_score,
    a.risk_score - LAG(a.risk_score) OVER (PARTITION BY p.mother_id ORDER BY a.created_at) AS score_change
FROM maternal_alerts a
JOIN pregnancies p ON a.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
ORDER BY m.mother_id, a.created_at;

-- ============================================================
-- PARTITION BY ANALYTICS
-- ============================================================

-- 7. Statistics by sector
SELECT DISTINCT
    m.sector,
    COUNT(*) OVER (PARTITION BY m.sector) AS mothers_in_sector,
    COUNT(CASE WHEN p.status = 'ACTIVE' THEN 1 END) OVER (PARTITION BY m.sector) AS active_pregnancies,
    COUNT(CASE WHEN p.risk_level = 'HIGH' THEN 1 END) OVER (PARTITION BY m.sector) AS high_risk_count,
    ROUND(AVG(a.risk_score) OVER (PARTITION BY m.sector), 2) AS avg_risk_score
FROM mothers m
LEFT JOIN pregnancies p ON m.mother_id = p.mother_id
LEFT JOIN maternal_alerts a ON p.pregnancy_id = a.pregnancy_id
ORDER BY sector;

-- 8. CHW performance within each sector
SELECT 
    c.sector,
    c.first_name || ' ' || c.last_name AS chw_name,
    COUNT(p.pregnancy_id) AS total_cases,
    RANK() OVER (PARTITION BY c.sector ORDER BY COUNT(p.pregnancy_id) DESC) AS rank_in_sector,
    ROUND(COUNT(p.pregnancy_id) * 100.0 / SUM(COUNT(p.pregnancy_id)) OVER (PARTITION BY c.sector), 2) AS pct_of_sector
FROM community_health_workers c
LEFT JOIN pregnancies p ON c.chw_id = p.assigned_chw_id
GROUP BY c.sector, c.chw_id, c.first_name, c.last_name
ORDER BY c.sector, rank_in_sector;

-- ============================================================
-- RUNNING TOTALS AND MOVING AVERAGES
-- ============================================================

-- 9. Cumulative alerts over time
SELECT 
    TRUNC(created_at) AS alert_date,
    COUNT(*) AS daily_alerts,
    SUM(COUNT(*)) OVER (ORDER BY TRUNC(created_at)) AS cumulative_alerts,
    ROUND(AVG(COUNT(*)) OVER (ORDER BY TRUNC(created_at) ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS moving_avg_7day
FROM maternal_alerts
GROUP BY TRUNC(created_at)
ORDER BY alert_date;

-- 10. Running total of deliveries by month
SELECT 
    TO_CHAR(delivery_date, 'YYYY-MM') AS month,
    COUNT(*) AS monthly_deliveries,
    SUM(COUNT(*)) OVER (ORDER BY TO_CHAR(delivery_date, 'YYYY-MM')) AS cumulative_deliveries
FROM pregnancies
WHERE delivery_date IS NOT NULL
GROUP BY TO_CHAR(delivery_date, 'YYYY-MM')
ORDER BY month;

-- ============================================================
-- NTILE (Quartile Analysis)
-- ============================================================

-- 11. Divide mothers into risk quartiles
SELECT 
    m.first_name || ' ' || m.last_name AS mother_name,
    a.risk_score,
    NTILE(4) OVER (ORDER BY a.risk_score) AS risk_quartile,
    CASE NTILE(4) OVER (ORDER BY a.risk_score)
        WHEN 1 THEN 'Low Risk (Q1)'
        WHEN 2 THEN 'Moderate Risk (Q2)'
        WHEN 3 THEN 'Elevated Risk (Q3)'
        WHEN 4 THEN 'High Risk (Q4)'
    END AS risk_category
FROM mothers m
JOIN pregnancies p ON m.mother_id = p.mother_id
JOIN maternal_alerts a ON p.pregnancy_id = a.pregnancy_id
ORDER BY risk_quartile, a.risk_score;

-- ============================================================
-- FIRST_VALUE / LAST_VALUE
-- ============================================================

-- 12. First and latest vital signs for each pregnancy
SELECT DISTINCT
    m.first_name || ' ' || m.last_name AS mother_name,
    FIRST_VALUE(v.systolic_bp) OVER (PARTITION BY p.pregnancy_id ORDER BY v.recorded_at) AS first_systolic,
    LAST_VALUE(v.systolic_bp) OVER (PARTITION BY p.pregnancy_id ORDER BY v.recorded_at 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS latest_systolic,
    FIRST_VALUE(v.weight_kg) OVER (PARTITION BY p.pregnancy_id ORDER BY v.recorded_at) AS first_weight,
    LAST_VALUE(v.weight_kg) OVER (PARTITION BY p.pregnancy_id ORDER BY v.recorded_at 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS latest_weight
FROM maternal_vitals v
JOIN pregnancies p ON v.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
ORDER BY mother_name;

-- ============================================================
-- COMPREHENSIVE DASHBOARD QUERY
-- ============================================================

-- 13. Executive Dashboard Summary
SELECT 
    'Total Mothers' AS metric, TO_CHAR(COUNT(*)) AS value FROM mothers
UNION ALL
SELECT 'Active Pregnancies', TO_CHAR(COUNT(*)) FROM pregnancies WHERE status = 'ACTIVE'
UNION ALL
SELECT 'High Risk Pregnancies', TO_CHAR(COUNT(*)) FROM pregnancies WHERE risk_level = 'HIGH' AND status = 'ACTIVE'
UNION ALL
SELECT 'Open RED Alerts', TO_CHAR(COUNT(*)) FROM maternal_alerts WHERE severity = 'RED' AND status = 'OPEN'
UNION ALL
SELECT 'Open ORANGE Alerts', TO_CHAR(COUNT(*)) FROM maternal_alerts WHERE severity = 'ORANGE' AND status = 'OPEN'
UNION ALL
SELECT 'Total CHWs', TO_CHAR(COUNT(*)) FROM community_health_workers WHERE status = 'ACTIVE'
UNION ALL
SELECT 'Total Newborns', TO_CHAR(COUNT(*)) FROM newborns
UNION ALL
SELECT 'Active Ambulances', TO_CHAR(COUNT(*)) FROM ambulances WHERE status = 'AVAILABLE';

-- ============================================================
-- End of Analytics Queries
-- ============================================================
