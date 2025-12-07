-- ============================================================
-- PHASE V: VERIFICATION & VALIDATION QUERIES
-- Student: NSHUTI Sano Delphin
-- Student ID: 27903
-- Database: TUE_27903_DELPHIN_MATERNALEWS_DB
-- Date: December 2025
-- ============================================================

-- ============================================================
-- 1. VERIFY ALL TABLES EXIST
-- ============================================================
SELECT table_name, num_rows, tablespace_name
FROM user_tables
ORDER BY table_name;

-- ============================================================
-- 2. VERIFY TABLE STRUCTURE (DESCRIBE)
-- ============================================================
DESC community_health_workers;
DESC mothers;
DESC pregnancies;
DESC maternal_vitals;
DESC maternal_alerts;
DESC newborns;
DESC newborn_vitals;
DESC anc_schedule;
DESC referrals;
DESC ambulances;
DESC vaccinations;
DESC audit_log;
DESC holidays;

-- ============================================================
-- 3. COUNT RECORDS IN ALL TABLES
-- ============================================================
SELECT 'COMMUNITY_HEALTH_WORKERS' AS table_name, COUNT(*) AS row_count FROM community_health_workers
UNION ALL SELECT 'MOTHERS', COUNT(*) FROM mothers
UNION ALL SELECT 'PREGNANCIES', COUNT(*) FROM pregnancies
UNION ALL SELECT 'MATERNAL_VITALS', COUNT(*) FROM maternal_vitals
UNION ALL SELECT 'MATERNAL_ALERTS', COUNT(*) FROM maternal_alerts
UNION ALL SELECT 'NEWBORNS', COUNT(*) FROM newborns
UNION ALL SELECT 'NEWBORN_VITALS', COUNT(*) FROM newborn_vitals
UNION ALL SELECT 'ANC_SCHEDULE', COUNT(*) FROM anc_schedule
UNION ALL SELECT 'REFERRALS', COUNT(*) FROM referrals
UNION ALL SELECT 'AMBULANCES', COUNT(*) FROM ambulances
UNION ALL SELECT 'VACCINATIONS', COUNT(*) FROM vaccinations
UNION ALL SELECT 'AUDIT_LOG', COUNT(*) FROM audit_log
UNION ALL SELECT 'HOLIDAYS', COUNT(*) FROM holidays
ORDER BY 1;

-- ============================================================
-- 4. VERIFY CONSTRAINTS
-- ============================================================
SELECT constraint_name, constraint_type, table_name, status
FROM user_constraints
WHERE constraint_type IN ('P', 'R', 'C', 'U')
ORDER BY table_name, constraint_type;

-- ============================================================
-- 5. VERIFY INDEXES
-- ============================================================
SELECT index_name, table_name, uniqueness, tablespace_name
FROM user_indexes
ORDER BY table_name;

-- ============================================================
-- 6. VERIFY SEQUENCES
-- ============================================================
SELECT sequence_name, last_number, increment_by
FROM user_sequences
ORDER BY sequence_name;

-- ============================================================
-- 7. SAMPLE DATA VERIFICATION QUERIES
-- ============================================================

-- CHWs with their assigned mothers count
SELECT c.chw_id, c.full_name, c.assigned_sector, COUNT(m.mother_id) AS mothers_count
FROM community_health_workers c
LEFT JOIN mothers m ON c.chw_id = m.assigned_chw_id
GROUP BY c.chw_id, c.full_name, c.assigned_sector
ORDER BY mothers_count DESC;

-- Pregnancies by risk level
SELECT risk_level, pregnancy_status, COUNT(*) AS count
FROM pregnancies
GROUP BY risk_level, pregnancy_status
ORDER BY risk_level;

-- Alerts by severity
SELECT severity, status, COUNT(*) AS count
FROM maternal_alerts
GROUP BY severity, status
ORDER BY severity;

-- Recent maternal vitals with danger signs
SELECT v.vital_id, m.full_name, v.visit_date, v.systolic_bp, v.diastolic_bp,
       v.vaginal_bleeding, v.severe_headache, v.blurred_vision
FROM maternal_vitals v
JOIN pregnancies p ON v.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
WHERE v.vaginal_bleeding = 'Yes' OR v.severe_headache = 'Yes' OR v.blurred_vision = 'Yes'
ORDER BY v.visit_date DESC;

-- Referrals with status
SELECT r.referral_id, m.full_name, r.to_facility, r.urgency_level, r.status, r.referral_date
FROM referrals r
JOIN pregnancies p ON r.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
ORDER BY r.referral_date DESC;

-- Newborns with birth details
SELECT n.newborn_id, m.full_name AS mother_name, n.birth_date, n.gender, 
       n.birth_weight_kg, n.apgar_5min, n.delivery_type
FROM newborns n
JOIN pregnancies p ON n.pregnancy_id = p.pregnancy_id
JOIN mothers m ON p.mother_id = m.mother_id
ORDER BY n.birth_date DESC;

-- ANC compliance check
SELECT p.pregnancy_id, m.full_name,
       COUNT(CASE WHEN a.status = 'Completed' THEN 1 END) AS completed_visits,
       COUNT(CASE WHEN a.status = 'Missed' THEN 1 END) AS missed_visits,
       COUNT(CASE WHEN a.status = 'Scheduled' THEN 1 END) AS pending_visits
FROM pregnancies p
JOIN mothers m ON p.mother_id = m.mother_id
LEFT JOIN anc_schedule a ON p.pregnancy_id = a.pregnancy_id
WHERE p.pregnancy_status = 'Active'
GROUP BY p.pregnancy_id, m.full_name
ORDER BY missed_visits DESC;

-- Vaccination coverage
SELECT vaccine_type, COUNT(*) AS doses_given
FROM vaccinations
GROUP BY vaccine_type
ORDER BY doses_given DESC;

-- ============================================================
-- 8. DATA INTEGRITY CHECKS
-- ============================================================

-- Check for orphan records
SELECT 'Mothers without CHW' AS check_name, COUNT(*) AS count
FROM mothers WHERE assigned_chw_id NOT IN (SELECT chw_id FROM community_health_workers)
UNION ALL
SELECT 'Pregnancies without Mother', COUNT(*)
FROM pregnancies WHERE mother_id NOT IN (SELECT mother_id FROM mothers)
UNION ALL
SELECT 'Vitals without Pregnancy', COUNT(*)
FROM maternal_vitals WHERE pregnancy_id NOT IN (SELECT pregnancy_id FROM pregnancies)
UNION ALL
SELECT 'Alerts without Pregnancy', COUNT(*)
FROM maternal_alerts WHERE pregnancy_id NOT IN (SELECT pregnancy_id FROM pregnancies);

-- All checks should return 0

PROMPT ============================================
PROMPT Phase V Verification Complete!
PROMPT ============================================
