-- ============================================================
-- AUDIT QUERIES
-- Maternal & Newborn Early Warning System
-- Student: NSHUTI Sano Delphin | ID: 27903
-- ============================================================

-- ============================================================
-- AUDIT LOG QUERIES
-- ============================================================

-- 1. View all audit log entries
SELECT 
    log_id,
    table_name,
    operation,
    record_id,
    old_values,
    new_values,
    changed_by,
    change_timestamp,
    status
FROM audit_log
ORDER BY change_timestamp DESC;

-- 2. View audit log with formatted timestamp
SELECT 
    log_id,
    table_name,
    operation,
    record_id,
    TO_CHAR(change_timestamp, 'YYYY-MM-DD HH24:MI:SS') AS change_time,
    changed_by,
    status,
    SUBSTR(old_values, 1, 50) AS old_vals_preview,
    SUBSTR(new_values, 1, 50) AS new_vals_preview
FROM audit_log
ORDER BY change_timestamp DESC;

-- ============================================================
-- DML RESTRICTION AUDIT QUERIES
-- ============================================================

-- 3. View all DENIED operations (DML blocked)
SELECT 
    log_id,
    table_name,
    operation,
    TO_CHAR(change_timestamp, 'YYYY-MM-DD HH24:MI:SS Day') AS attempt_time,
    changed_by,
    status
FROM audit_log
WHERE status = 'DENIED'
ORDER BY change_timestamp DESC;

-- 4. Count denied operations by day of week
SELECT 
    TO_CHAR(change_timestamp, 'Day') AS day_of_week,
    COUNT(*) AS denied_count
FROM audit_log
WHERE status = 'DENIED'
GROUP BY TO_CHAR(change_timestamp, 'Day')
ORDER BY denied_count DESC;

-- 5. Denied operations by table
SELECT 
    table_name,
    COUNT(*) AS denied_count,
    MAX(change_timestamp) AS last_denied
FROM audit_log
WHERE status = 'DENIED'
GROUP BY table_name
ORDER BY denied_count DESC;

-- 6. Denied operations by user
SELECT 
    changed_by,
    COUNT(*) AS denied_attempts,
    COUNT(DISTINCT table_name) AS tables_attempted
FROM audit_log
WHERE status = 'DENIED'
GROUP BY changed_by
ORDER BY denied_attempts DESC;

-- ============================================================
-- SUCCESSFUL OPERATIONS AUDIT
-- ============================================================

-- 7. View all ALLOWED/successful operations
SELECT 
    log_id,
    table_name,
    operation,
    record_id,
    TO_CHAR(change_timestamp, 'YYYY-MM-DD HH24:MI:SS') AS change_time,
    changed_by
FROM audit_log
WHERE status = 'ALLOWED' OR status IS NULL
ORDER BY change_timestamp DESC;

-- 8. Operations summary by table
SELECT 
    table_name,
    SUM(CASE WHEN operation = 'INSERT' THEN 1 ELSE 0 END) AS inserts,
    SUM(CASE WHEN operation = 'UPDATE' THEN 1 ELSE 0 END) AS updates,
    SUM(CASE WHEN operation = 'DELETE' THEN 1 ELSE 0 END) AS deletes,
    COUNT(*) AS total_operations
FROM audit_log
WHERE status != 'DENIED' OR status IS NULL
GROUP BY table_name
ORDER BY total_operations DESC;

-- 9. Daily operation counts
SELECT 
    TRUNC(change_timestamp) AS audit_date,
    COUNT(*) AS total_operations,
    SUM(CASE WHEN status = 'DENIED' THEN 1 ELSE 0 END) AS denied,
    SUM(CASE WHEN status = 'ALLOWED' OR status IS NULL THEN 1 ELSE 0 END) AS allowed
FROM audit_log
GROUP BY TRUNC(change_timestamp)
ORDER BY audit_date DESC;

-- ============================================================
-- HOLIDAY MANAGEMENT QUERIES
-- ============================================================

-- 10. View all configured holidays
SELECT 
    holiday_id,
    holiday_name,
    TO_CHAR(holiday_date, 'YYYY-MM-DD Day') AS holiday_date,
    description
FROM holidays
ORDER BY holiday_date;

-- 11. Check upcoming holidays (next 30 days)
SELECT 
    holiday_name,
    TO_CHAR(holiday_date, 'YYYY-MM-DD Day') AS holiday_date,
    holiday_date - TRUNC(SYSDATE) AS days_until
FROM holidays
WHERE holiday_date BETWEEN SYSDATE AND SYSDATE + 30
ORDER BY holiday_date;

-- 12. Check if today is a restricted day
SELECT 
    CASE 
        WHEN TO_CHAR(SYSDATE, 'DY') IN ('MON', 'TUE', 'WED', 'THU', 'FRI') THEN 'YES - Weekday'
        WHEN EXISTS (SELECT 1 FROM holidays WHERE TRUNC(holiday_date) = TRUNC(SYSDATE)) THEN 'YES - Holiday'
        ELSE 'NO - DML Allowed'
    END AS is_restricted_day
FROM dual;

-- ============================================================
-- TRIGGER STATUS QUERIES
-- ============================================================

-- 13. List all triggers in the system
SELECT 
    trigger_name,
    trigger_type,
    triggering_event,
    table_name,
    status
FROM user_triggers
ORDER BY table_name, trigger_name;

-- 14. Count triggers by table
SELECT 
    table_name,
    COUNT(*) AS trigger_count,
    LISTAGG(trigger_name, ', ') WITHIN GROUP (ORDER BY trigger_name) AS trigger_names
FROM user_triggers
GROUP BY table_name
ORDER BY trigger_count DESC;

-- 15. Audit triggers only
SELECT 
    trigger_name,
    table_name,
    triggering_event,
    status
FROM user_triggers
WHERE trigger_name LIKE '%AUDIT%'
ORDER BY table_name;

-- 16. DML restriction triggers
SELECT 
    trigger_name,
    table_name,
    triggering_event,
    status
FROM user_triggers
WHERE trigger_name LIKE '%RESTRICT%' OR trigger_name LIKE '%DML%'
ORDER BY table_name;

-- ============================================================
-- AUDIT ANALYTICS
-- ============================================================

-- 17. Audit activity by hour of day
SELECT 
    TO_CHAR(change_timestamp, 'HH24') AS hour_of_day,
    COUNT(*) AS operation_count
FROM audit_log
GROUP BY TO_CHAR(change_timestamp, 'HH24')
ORDER BY hour_of_day;

-- 18. Most active users
SELECT 
    changed_by,
    COUNT(*) AS total_actions,
    MIN(change_timestamp) AS first_action,
    MAX(change_timestamp) AS last_action
FROM audit_log
GROUP BY changed_by
ORDER BY total_actions DESC;

-- 19. Recent critical table changes (MOTHERS, PREGNANCIES)
SELECT 
    log_id,
    table_name,
    operation,
    record_id,
    TO_CHAR(change_timestamp, 'YYYY-MM-DD HH24:MI:SS') AS change_time,
    changed_by,
    status
FROM audit_log
WHERE table_name IN ('MOTHERS', 'PREGNANCIES', 'MATERNAL_ALERTS')
ORDER BY change_timestamp DESC
FETCH FIRST 20 ROWS ONLY;

-- ============================================================
-- TEST DML RESTRICTION (Run on weekday to test)
-- ============================================================

-- 20. Test INSERT on weekday (should be blocked)
-- Uncomment to test:
-- INSERT INTO mothers (mother_id, first_name, last_name, date_of_birth, phone, sector, cell, village)
-- VALUES (999, 'Test', 'Mother', DATE '1995-01-01', '0780000000', 'TestSector', 'TestCell', 'TestVillage');

-- 21. Verify the denial was logged
SELECT * FROM audit_log 
WHERE table_name = 'MOTHERS' AND status = 'DENIED'
ORDER BY change_timestamp DESC
FETCH FIRST 5 ROWS ONLY;

-- ============================================================
-- End of Audit Queries
-- ============================================================
