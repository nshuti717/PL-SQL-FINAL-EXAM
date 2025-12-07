-- ============================================================
-- PHASE V: ADDITIONAL DATA INSERTION SCRIPT
-- Student: NSHUTI Sano Delphin
-- Student ID: 27903
-- Database: TUE_27903_DELPHIN_MATERNALEWS_DB
-- Date: December 2025
-- ============================================================

-- ============================================================
-- INSERT MATERNAL ALERTS (Auto-generated and manual)
-- ============================================================
INSERT INTO maternal_alerts VALUES (seq_alert_id.NEXTVAL, 4, 6, 'Severe Preeclampsia', 'Red', 55, SYSTIMESTAMP-20, 'Acknowledged', 'Patient referred to hospital', 2, SYSTIMESTAMP-19);
INSERT INTO maternal_alerts VALUES (seq_alert_id.NEXTVAL, 4, 7, 'Critical Hypertension', 'Red', 68, SYSTIMESTAMP-5, 'Open', NULL, NULL, NULL);
INSERT INTO maternal_alerts VALUES (seq_alert_id.NEXTVAL, 8, 8, 'Multiple Danger Signs', 'Red', 72, SYSTIMESTAMP-15, 'Escalated', 'Emergency ambulance dispatched', 4, NULL);
INSERT INTO maternal_alerts VALUES (seq_alert_id.NEXTVAL, 2, 4, 'Elevated Blood Pressure', 'Orange', 28, SYSTIMESTAMP-25, 'Resolved', 'Monitored for 48 hours, stabilized', 1, SYSTIMESTAMP-23);
INSERT INTO maternal_alerts VALUES (seq_alert_id.NEXTVAL, 2, 5, 'Preeclampsia Warning', 'Orange', 35, SYSTIMESTAMP-10, 'Open', NULL, NULL, NULL);
INSERT INTO maternal_alerts VALUES (seq_alert_id.NEXTVAL, 10, 13, 'High Blood Pressure', 'Orange', 48, SYSTIMESTAMP-12, 'Acknowledged', 'Scheduled for facility visit', 5, NULL);
INSERT INTO maternal_alerts VALUES (seq_alert_id.NEXTVAL, 7, 11, 'Mild Anemia', 'Yellow', 22, SYSTIMESTAMP-16, 'Resolved', 'Iron supplements prescribed', 4, SYSTIMESTAMP-14);
INSERT INTO maternal_alerts VALUES (seq_alert_id.NEXTVAL, 13, 15, 'Slight BP Elevation', 'Yellow', 25, SYSTIMESTAMP-8, 'Open', NULL, NULL, NULL);
INSERT INTO maternal_alerts VALUES (seq_alert_id.NEXTVAL, 17, 18, 'Severe Hypertension', 'Red', 52, SYSTIMESTAMP-2, 'Open', NULL, NULL, NULL);
INSERT INTO maternal_alerts VALUES (seq_alert_id.NEXTVAL, 20, 21, 'CRITICAL EMERGENCY', 'Red', 85, SYSTIMESTAMP-21, 'Escalated', 'Immediate cesarean required', 10, NULL);
INSERT INTO maternal_alerts VALUES (seq_alert_id.NEXTVAL, 23, 23, 'Moderate Risk', 'Orange', 30, SYSTIMESTAMP-7, 'Acknowledged', 'Close monitoring initiated', 11, NULL);
INSERT INTO maternal_alerts VALUES (seq_alert_id.NEXTVAL, 31, NULL, 'High Risk Pregnancy', 'Red', 58, SYSTIMESTAMP-3, 'Open', NULL, NULL, NULL);
INSERT INTO maternal_alerts VALUES (seq_alert_id.NEXTVAL, 36, NULL, 'Critical Status', 'Red', 65, SYSTIMESTAMP-1, 'Open', NULL, NULL, NULL);
INSERT INTO maternal_alerts VALUES (seq_alert_id.NEXTVAL, 40, NULL, 'Emergency Alert', 'Red', 50, SYSTIMESTAMP, 'Open', NULL, NULL, NULL);
INSERT INTO maternal_alerts VALUES (seq_alert_id.NEXTVAL, 46, NULL, 'High Risk Alert', 'Orange', 47, SYSTIMESTAMP-4, 'Acknowledged', 'Referral in progress', 7, NULL);

-- ============================================================
-- INSERT NEWBORNS (From delivered pregnancies)
-- ============================================================
INSERT INTO newborns VALUES (seq_newborn_id.NEXTVAL, 6, DATE '2024-12-15', 'Female', 3.20, 50.5, 8, 9, 'Normal', 'Muhima Hospital', NULL, 'Yes');
INSERT INTO newborns VALUES (seq_newborn_id.NEXTVAL, 11, DATE '2024-11-20', 'Male', 3.45, 52.0, 9, 10, 'Normal', 'Home with CHW', NULL, 'Yes');
INSERT INTO newborns VALUES (seq_newborn_id.NEXTVAL, 15, DATE '2024-12-30', 'Female', 2.80, 48.5, 7, 8, 'Assisted', 'CHUK Hospital', 'Cord around neck', 'Yes');
INSERT INTO newborns VALUES (seq_newborn_id.NEXTVAL, 21, DATE '2024-11-10', 'Male', 3.65, 53.0, 9, 10, 'Normal', 'Kibagabaga Hospital', NULL, 'Yes');
INSERT INTO newborns VALUES (seq_newborn_id.NEXTVAL, 27, DATE '2024-12-05', 'Female', 3.10, 49.5, 8, 9, 'Normal', 'Home with CHW', NULL, 'Yes');
INSERT INTO newborns VALUES (seq_newborn_id.NEXTVAL, 33, DATE '2024-11-25', 'Male', 2.95, 49.0, 7, 9, 'Normal', 'Masaka Hospital', 'Low birth weight', 'Yes');
INSERT INTO newborns VALUES (seq_newborn_id.NEXTVAL, 38, DATE '2024-12-20', 'Female', 3.30, 51.0, 8, 9, 'Cesarean', 'King Faisal Hospital', 'Breech presentation', 'Yes');
INSERT INTO newborns VALUES (seq_newborn_id.NEXTVAL, 44, DATE '2024-11-15', 'Male', 3.55, 52.5, 9, 10, 'Normal', 'Home with CHW', NULL, 'Yes');
INSERT INTO newborns VALUES (seq_newborn_id.NEXTVAL, 48, DATE '2024-12-10', 'Female', 2.70, 47.5, 6, 8, 'Vacuum', 'CHUK Hospital', 'Prolonged labor', 'Yes');

-- ============================================================
-- INSERT NEWBORN VITALS
-- ============================================================
-- Newborn 1 vitals (Days 1, 3, 7, 14)
INSERT INTO newborn_vitals VALUES (seq_nb_vital_id.NEXTVAL, 1, 3, DATE '2024-12-15', 1, 3.15, 36.8, 'Breastfeeding Only', 'Clean', 'Pink', 'Normal', 'No', NULL, 'Day 1 checkup');
INSERT INTO newborn_vitals VALUES (seq_nb_vital_id.NEXTVAL, 1, 3, DATE '2024-12-18', 3, 3.10, 36.7, 'Breastfeeding Only', 'Drying', 'Pink', 'Normal', 'No', NULL, 'Good progress');
INSERT INTO newborn_vitals VALUES (seq_nb_vital_id.NEXTVAL, 1, 3, DATE '2024-12-22', 7, 3.25, 36.6, 'Breastfeeding Only', 'Healed', 'Pink', 'Normal', 'No', NULL, 'Weight gain');
INSERT INTO newborn_vitals VALUES (seq_nb_vital_id.NEXTVAL, 1, 3, DATE '2024-12-29', 14, 3.50, 36.5, 'Breastfeeding Only', 'Healed', 'Pink', 'Normal', 'No', NULL, 'Excellent');

-- Newborn 2 vitals
INSERT INTO newborn_vitals VALUES (seq_nb_vital_id.NEXTVAL, 2, 6, DATE '2024-11-20', 1, 3.40, 36.9, 'Breastfeeding Only', 'Clean', 'Pink', 'Normal', 'No', NULL, 'Healthy');
INSERT INTO newborn_vitals VALUES (seq_nb_vital_id.NEXTVAL, 2, 6, DATE '2024-11-27', 7, 3.55, 36.7, 'Breastfeeding Only', 'Healing', 'Pink', 'Normal', 'No', NULL, 'Good');

-- Newborn 3 vitals (some concerns)
INSERT INTO newborn_vitals VALUES (seq_nb_vital_id.NEXTVAL, 3, 7, DATE '2024-12-30', 1, 2.75, 37.2, 'Not Feeding Well', 'Clean', 'Slightly Yellow', 'Fast', 'Yes', 'Jaundice, feeding difficulty', 'Monitor closely');
INSERT INTO newborn_vitals VALUES (seq_nb_vital_id.NEXTVAL, 3, 7, DATE '2025-01-02', 3, 2.70, 36.9, 'Mixed Feeding', 'Clean', 'Less Yellow', 'Normal', 'No', NULL, 'Improving');

-- Additional newborn vitals
INSERT INTO newborn_vitals VALUES (seq_nb_vital_id.NEXTVAL, 4, 9, DATE '2024-11-10', 1, 3.60, 36.8, 'Breastfeeding Only', 'Clean', 'Pink', 'Normal', 'No', NULL, 'Perfect');
INSERT INTO newborn_vitals VALUES (seq_nb_vital_id.NEXTVAL, 5, 9, DATE '2024-12-05', 1, 3.05, 36.7, 'Breastfeeding Only', 'Clean', 'Pink', 'Normal', 'No', NULL, 'Normal');
INSERT INTO newborn_vitals VALUES (seq_nb_vital_id.NEXTVAL, 6, 12, DATE '2024-11-25', 1, 2.90, 37.1, 'Breastfeeding Only', 'Clean', 'Slightly Pale', 'Normal', 'No', NULL, 'Low weight');
INSERT INTO newborn_vitals VALUES (seq_nb_vital_id.NEXTVAL, 7, 13, DATE '2024-12-20', 1, 3.25, 36.6, 'Breastfeeding Only', 'Clean', 'Pink', 'Normal', 'No', NULL, 'Post cesarean');
INSERT INTO newborn_vitals VALUES (seq_nb_vital_id.NEXTVAL, 8, 14, DATE '2024-11-15', 1, 3.50, 36.8, 'Breastfeeding Only', 'Clean', 'Pink', 'Normal', 'No', NULL, 'Healthy');
INSERT INTO newborn_vitals VALUES (seq_nb_vital_id.NEXTVAL, 9, 15, DATE '2024-12-10', 1, 2.65, 37.3, 'Not Feeding Well', 'Clean', 'Yellow', 'Fast', 'Yes', 'Severe jaundice', 'Phototherapy needed');

-- ============================================================
-- INSERT ANC SCHEDULES (WHO 8-visit model)
-- ============================================================
-- Pregnancy 1 ANC schedule
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 1, 1, DATE '2024-08-15', DATE '2024-08-15', 'Completed', 12, 'First visit');
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 1, 2, DATE '2024-10-15', DATE '2024-10-17', 'Completed', 20, 'Second visit');
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 1, 3, DATE '2024-11-15', DATE '2024-11-15', 'Completed', 26, 'Third visit');
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 1, 4, DATE '2024-12-15', DATE '2024-12-16', 'Completed', 30, 'Fourth visit');
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 1, 5, DATE '2025-01-05', NULL, 'Scheduled', 34, NULL);
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 1, 6, DATE '2025-01-19', NULL, 'Scheduled', 36, NULL);
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 1, 7, DATE '2025-02-02', NULL, 'Scheduled', 38, NULL);
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 1, 8, DATE '2025-02-16', NULL, 'Scheduled', 40, NULL);

-- Pregnancy 2 ANC schedule
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 2, 1, DATE '2024-07-20', DATE '2024-07-20', 'Completed', 12, 'Initial');
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 2, 2, DATE '2024-09-20', DATE '2024-09-22', 'Completed', 20, NULL);
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 2, 3, DATE '2024-10-20', DATE '2024-10-20', 'Completed', 26, NULL);
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 2, 4, DATE '2024-11-20', DATE '2024-11-21', 'Completed', 30, NULL);
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 2, 5, DATE '2024-12-10', DATE '2024-12-10', 'Completed', 34, 'Elevated BP noted');
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 2, 6, DATE '2024-12-24', NULL, 'Missed', 36, 'Patient did not attend');
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 2, 7, DATE '2025-01-07', NULL, 'Scheduled', 38, NULL);
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 2, 8, DATE '2025-01-21', NULL, 'Scheduled', 40, NULL);

-- Pregnancy 5 ANC schedule (early pregnancy)
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 5, 1, DATE '2024-10-05', DATE '2024-10-05', 'Completed', 12, 'First visit');
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 5, 2, DATE '2024-12-05', DATE '2024-12-05', 'Completed', 20, 'All normal');
INSERT INTO anc_schedule VALUES (seq_schedule_id.NEXTVAL, 5, 3, DATE '2025-01-05', NULL, 'Scheduled', 26, NULL);

-- ============================================================
-- INSERT REFERRALS
-- ============================================================
INSERT INTO referrals VALUES (seq_referral_id.NEXTVAL, 1, 4, NULL, 2, 1, SYSDATE-20, SYSTIMESTAMP-20, 'CHUK Hospital', 'Severe preeclampsia - emergency', 'Emergency', 'Ambulance', SYSTIMESTAMP-19.5, 'Admitted to ICU, stabilized', 'Completed');
INSERT INTO referrals VALUES (seq_referral_id.NEXTVAL, 3, 8, NULL, 4, 3, SYSDATE-15, SYSTIMESTAMP-15, 'King Faisal Hospital', 'Multiple danger signs - critical', 'Emergency', 'Ambulance', SYSTIMESTAMP-14.5, 'Emergency cesarean performed', 'Completed');
INSERT INTO referrals VALUES (seq_referral_id.NEXTVAL, 10, 20, NULL, 10, 2, SYSDATE-21, SYSTIMESTAMP-21, 'Muhima Hospital', 'Critical emergency - immediate intervention', 'Emergency', 'Ambulance', SYSTIMESTAMP-20.8, 'Mother and baby saved', 'Completed');
INSERT INTO referrals VALUES (seq_referral_id.NEXTVAL, 6, 10, NULL, 5, 4, SYSDATE-12, SYSTIMESTAMP-12, 'Kibagabaga Hospital', 'High blood pressure management', 'Urgent', 'Family transport', SYSTIMESTAMP-11, 'Medication adjusted', 'Completed');
INSERT INTO referrals VALUES (seq_referral_id.NEXTVAL, 9, 17, NULL, 8, 1, SYSDATE-2, SYSTIMESTAMP-2, 'CHUK Hospital', 'Severe hypertension - urgent', 'Emergency', 'Ambulance', NULL, NULL, 'In Transit');
INSERT INTO referrals VALUES (seq_referral_id.NEXTVAL, 12, 31, NULL, 13, NULL, SYSDATE-3, SYSTIMESTAMP-3, 'Huye Hospital', 'High risk pregnancy monitoring', 'Urgent', 'Own transport', NULL, NULL, 'Pending');
INSERT INTO referrals VALUES (seq_referral_id.NEXTVAL, 14, 40, NULL, 1, 2, SYSDATE, SYSTIMESTAMP, 'Kigali Central Hospital', 'Emergency alert triggered', 'Emergency', 'Ambulance', NULL, NULL, 'In Transit');
INSERT INTO referrals VALUES (seq_referral_id.NEXTVAL, NULL, 6, 3, 7, NULL, SYSDATE-5, SYSTIMESTAMP-5, 'CHUK Neonatal', 'Newborn jaundice - phototherapy', 'Urgent', 'Ambulance', SYSTIMESTAMP-4.5, 'Phototherapy completed', 'Completed');
INSERT INTO referrals VALUES (seq_referral_id.NEXTVAL, NULL, 48, 9, 15, 5, SYSDATE-3, SYSTIMESTAMP-3, 'King Faisal Neonatal', 'Severe neonatal jaundice', 'Emergency', 'Ambulance', SYSTIMESTAMP-2.5, 'Under treatment', 'Arrived');

-- ============================================================
-- INSERT VACCINATIONS
-- ============================================================
-- Maternal vaccinations (Tetanus Toxoid)
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, 1, NULL, 1, 'Tetanus Toxoid (TT)', 1, DATE '2024-08-15', DATE '2024-09-15', 'TT-2024-001', 'Left arm', 'No', NULL);
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, 1, NULL, 1, 'Tetanus Toxoid (TT)', 2, DATE '2024-09-15', DATE '2025-09-15', 'TT-2024-015', 'Left arm', 'No', NULL);
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, 2, NULL, 1, 'Tetanus Toxoid (TT)', 1, DATE '2024-07-20', DATE '2024-08-20', 'TT-2024-022', 'Left arm', 'No', NULL);
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, 2, NULL, 1, 'Tetanus Toxoid (TT)', 2, DATE '2024-08-20', DATE '2025-08-20', 'TT-2024-045', 'Left arm', 'No', NULL);
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, 3, NULL, 2, 'Tetanus Toxoid (TT)', 1, DATE '2024-09-10', DATE '2024-10-10', 'TT-2024-067', 'Left arm', 'No', NULL);
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, 5, NULL, 3, 'Tetanus Toxoid (TT)', 1, DATE '2024-10-05', DATE '2024-11-05', 'TT-2024-089', 'Left arm', 'No', NULL);
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, 5, NULL, 3, 'Tetanus Toxoid (TT)', 2, DATE '2024-11-05', DATE '2025-11-05', 'TT-2024-102', 'Left arm', 'No', NULL);

-- Newborn vaccinations (BCG, OPV, Hepatitis B)
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, NULL, 1, 3, 'BCG', 1, DATE '2024-12-15', NULL, 'BCG-2024-201', 'Right arm', 'No', NULL);
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, NULL, 1, 3, 'OPV', 0, DATE '2024-12-15', DATE '2025-01-26', 'OPV-2024-201', 'Oral', 'No', NULL);
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, NULL, 1, 3, 'Hepatitis B', 1, DATE '2024-12-15', DATE '2025-01-15', 'HBV-2024-201', 'Right thigh', 'No', NULL);
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, NULL, 2, 6, 'BCG', 1, DATE '2024-11-20', NULL, 'BCG-2024-188', 'Right arm', 'No', NULL);
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, NULL, 2, 6, 'OPV', 0, DATE '2024-11-20', DATE '2025-01-01', 'OPV-2024-188', 'Oral', 'No', NULL);
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, NULL, 2, 6, 'Hepatitis B', 1, DATE '2024-11-20', DATE '2024-12-20', 'HBV-2024-188', 'Right thigh', 'No', NULL);
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, NULL, 4, 9, 'BCG', 1, DATE '2024-11-10', NULL, 'BCG-2024-175', 'Right arm', 'No', NULL);
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, NULL, 4, 9, 'OPV', 0, DATE '2024-11-10', DATE '2024-12-22', 'OPV-2024-175', 'Oral', 'No', NULL);
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, NULL, 5, 9, 'BCG', 1, DATE '2024-12-05', NULL, 'BCG-2024-210', 'Right arm', 'No', NULL);
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, NULL, 7, 13, 'BCG', 1, DATE '2024-12-20', NULL, 'BCG-2024-225', 'Right arm', 'No', NULL);
INSERT INTO vaccinations VALUES (seq_vaccination_id.NEXTVAL, NULL, 8, 14, 'BCG', 1, DATE '2024-11-15', NULL, 'BCG-2024-182', 'Right arm', 'No', NULL);

COMMIT;

-- ============================================================
-- VERIFY ALL DATA COUNTS
-- ============================================================
SELECT 'MATERNAL_ALERTS' AS table_name, COUNT(*) AS row_count FROM maternal_alerts
UNION ALL
SELECT 'NEWBORNS', COUNT(*) FROM newborns
UNION ALL
SELECT 'NEWBORN_VITALS', COUNT(*) FROM newborn_vitals
UNION ALL
SELECT 'ANC_SCHEDULE', COUNT(*) FROM anc_schedule
UNION ALL
SELECT 'REFERRALS', COUNT(*) FROM referrals
UNION ALL
SELECT 'VACCINATIONS', COUNT(*) FROM vaccinations;

-- ============================================================
-- FINAL DATA SUMMARY
-- ============================================================
SELECT 
    (SELECT COUNT(*) FROM community_health_workers) AS chw_count,
    (SELECT COUNT(*) FROM mothers) AS mother_count,
    (SELECT COUNT(*) FROM pregnancies) AS pregnancy_count,
    (SELECT COUNT(*) FROM maternal_vitals) AS vitals_count,
    (SELECT COUNT(*) FROM maternal_alerts) AS alert_count,
    (SELECT COUNT(*) FROM newborns) AS newborn_count,
    (SELECT COUNT(*) FROM referrals) AS referral_count,
    (SELECT COUNT(*) FROM vaccinations) AS vaccination_count
FROM DUAL;
