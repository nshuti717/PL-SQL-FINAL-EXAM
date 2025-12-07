-- ============================================================
-- DATA RETRIEVAL QUERIES
-- Maternal & Newborn Early Warning System
-- Student: NSHUTI Sano Delphin | ID: 27903
-- ============================================================

-- ============================================================
-- BASIC SELECT QUERIES
-- ============================================================

-- 1. List all Community Health Workers
SELECT chw_id, first_name, last_name, phone, sector, cell, village, status
FROM community_health_workers
ORDER BY sector, last_name;

-- 2. List all registered mothers
SELECT m.mother_id, m.first_name, m.last_name, m.date_of_birth,
       TRUNC(MONTHS_BETWEEN(SYSDATE, m.date_of_birth)/12) AS age,
       m.phone, m.sector, m.cell, m.village
FROM mothers m
ORDER BY m.registration_date DESC;

-- 3. List all active pregnancies
SELECT p.pregnancy_id, m.first_name || ' ' || m.last_name AS mother_name,
       p.lmp_date, p.expected_delivery_date, p.risk_level, p.status
FROM pregnancies p
JOIN mothers m ON p.mother_id = m.mother_id
WHERE p.status = 'ACTIVE'
ORDER BY p.expected_delivery_date;

-- 4. List all maternal vitals
SELECT v.vital_id, m.first_name || ' ' || m.last_name AS mother_name,
       v.systolic_bp, v.diastolic_bp, v.temperature, v.weight_kg,
       v.hemoglobin, v.fetal_heart_rate, v.recorded_at
FROM maternal_vitals v
JOIN pregnancies p ON v.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
ORDER BY v.recorded_at DESC;

-- 5. List all alerts
SELECT a.alert_id, m.first_name || ' ' || m.last_name AS mother_name,
       a.severity, a.risk_score, a.alert_message, a.status, a.created_at
FROM maternal_alerts a
JOIN pregnancies p ON a.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
ORDER BY a.created_at DESC;

-- ============================================================
-- JOIN QUERIES (Multi-table)
-- ============================================================

-- 6. Comprehensive mother-pregnancy-CHW view
SELECT m.mother_id, m.first_name || ' ' || m.last_name AS mother_name,
       m.phone AS mother_phone, m.sector,
       p.pregnancy_id, p.expected_delivery_date, p.risk_level,
       c.first_name || ' ' || c.last_name AS chw_name, c.phone AS chw_phone
FROM mothers m
JOIN pregnancies p ON m.mother_id = p.mother_id
JOIN community_health_workers c ON p.assigned_chw_id = c.chw_id
WHERE p.status = 'ACTIVE'
ORDER BY p.risk_level DESC, p.expected_delivery_date;

-- 7. Alerts with full context
SELECT a.alert_id, a.severity, a.risk_score,
       m.first_name || ' ' || m.last_name AS mother_name,
       m.phone, p.expected_delivery_date,
       c.first_name || ' ' || c.last_name AS assigned_chw,
       a.alert_message, a.status
FROM maternal_alerts a
JOIN pregnancies p ON a.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
JOIN community_health_workers c ON p.assigned_chw_id = c.chw_id
ORDER BY a.severity DESC, a.created_at DESC;

-- 8. Referrals with ambulance details
SELECT r.referral_id, m.first_name || ' ' || m.last_name AS mother_name,
       r.urgency_level, r.reason, r.destination_facility,
       amb.vehicle_number, amb.driver_name, amb.driver_phone,
       r.status, r.created_at
FROM referrals r
JOIN pregnancies p ON r.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
LEFT JOIN ambulances amb ON r.ambulance_id = amb.ambulance_id
ORDER BY r.created_at DESC;

-- 9. Newborns with birth details
SELECT n.newborn_id, n.gender, n.birth_weight_kg, n.birth_length_cm,
       n.apgar_1min, n.apgar_5min, n.delivery_type,
       m.first_name || ' ' || m.last_name AS mother_name,
       p.delivery_date
FROM newborns n
JOIN pregnancies p ON n.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
ORDER BY p.delivery_date DESC;

-- ============================================================
-- AGGREGATION QUERIES (GROUP BY)
-- ============================================================

-- 10. Count mothers by sector
SELECT sector, COUNT(*) AS mother_count
FROM mothers
GROUP BY sector
ORDER BY mother_count DESC;

-- 11. Pregnancies by risk level
SELECT risk_level, COUNT(*) AS pregnancy_count
FROM pregnancies
WHERE status = 'ACTIVE'
GROUP BY risk_level
ORDER BY DECODE(risk_level, 'HIGH', 1, 'MEDIUM', 2, 'LOW', 3);

-- 12. Alerts by severity
SELECT severity, COUNT(*) AS alert_count
FROM maternal_alerts
GROUP BY severity
ORDER BY DECODE(severity, 'RED', 1, 'ORANGE', 2, 'YELLOW', 3);

-- 13. CHW workload analysis
SELECT c.chw_id, c.first_name || ' ' || c.last_name AS chw_name,
       COUNT(DISTINCT p.pregnancy_id) AS active_pregnancies,
       COUNT(DISTINCT a.alert_id) AS open_alerts
FROM community_health_workers c
LEFT JOIN pregnancies p ON c.chw_id = p.assigned_chw_id AND p.status = 'ACTIVE'
LEFT JOIN maternal_alerts a ON p.pregnancy_id = a.pregnancy_id AND a.status = 'OPEN'
GROUP BY c.chw_id, c.first_name, c.last_name
ORDER BY active_pregnancies DESC;

-- 14. Monthly delivery statistics
SELECT TO_CHAR(delivery_date, 'YYYY-MM') AS month,
       COUNT(*) AS total_deliveries,
       SUM(CASE WHEN delivery_type = 'NORMAL' THEN 1 ELSE 0 END) AS normal,
       SUM(CASE WHEN delivery_type = 'CESAREAN' THEN 1 ELSE 0 END) AS cesarean
FROM pregnancies
WHERE delivery_date IS NOT NULL
GROUP BY TO_CHAR(delivery_date, 'YYYY-MM')
ORDER BY month DESC;

-- ============================================================
-- SUBQUERIES
-- ============================================================

-- 15. High-risk mothers (subquery)
SELECT m.mother_id, m.first_name, m.last_name, m.phone
FROM mothers m
WHERE m.mother_id IN (
    SELECT p.mother_id 
    FROM pregnancies p 
    WHERE p.risk_level = 'HIGH' AND p.status = 'ACTIVE'
);

-- 16. CHWs with most alerts (subquery)
SELECT c.chw_id, c.first_name, c.last_name, 
       (SELECT COUNT(*) FROM pregnancies p 
        JOIN maternal_alerts a ON p.pregnancy_id = a.pregnancy_id
        WHERE p.assigned_chw_id = c.chw_id) AS total_alerts
FROM community_health_workers c
ORDER BY total_alerts DESC;

-- 17. Mothers without recent vitals (subquery)
SELECT m.mother_id, m.first_name, m.last_name
FROM mothers m
JOIN pregnancies p ON m.mother_id = p.mother_id
WHERE p.status = 'ACTIVE'
AND p.pregnancy_id NOT IN (
    SELECT v.pregnancy_id FROM maternal_vitals v 
    WHERE v.recorded_at > SYSDATE - 14
);

-- ============================================================
-- End of Data Retrieval Queries
-- ============================================================
