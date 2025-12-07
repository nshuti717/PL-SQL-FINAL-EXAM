-- ============================================================
-- PHASE V: TABLE CREATION SCRIPT
-- Student: NSHUTI Sano Delphin
-- Student ID: 27903
-- Database: TUE_27903_DELPHIN_MATERNALEWS_DB
-- Date: December 2025
-- ============================================================

-- ============================================================
-- STEP 1: Connect to PDB as PDB_ADMIN
-- ============================================================
-- In SQL*Plus: connect pdb_admin/admin123@localhost/TUE_27903_DELPHIN_MATERNALEWS_DB

-- ============================================================
-- TABLE 1: COMMUNITY_HEALTH_WORKERS
-- ============================================================
CREATE TABLE community_health_workers (
    chw_id              NUMBER(10)      PRIMARY KEY,
    national_id         VARCHAR2(16)    NOT NULL UNIQUE,
    full_name           VARCHAR2(100)   NOT NULL,
    phone_number        VARCHAR2(15),
    assigned_sector     VARCHAR2(50),
    assigned_cell       VARCHAR2(50),
    is_active           VARCHAR2(3)     DEFAULT 'Yes' CHECK (is_active IN ('Yes', 'No')),
    created_date        DATE            DEFAULT SYSDATE
) TABLESPACE TBS_EWS_DATA;

-- ============================================================
-- TABLE 2: MOTHERS
-- ============================================================
CREATE TABLE mothers (
    mother_id           NUMBER(10)      PRIMARY KEY,
    assigned_chw_id     NUMBER(10)      REFERENCES community_health_workers(chw_id),
    national_id         VARCHAR2(16)    NOT NULL UNIQUE,
    full_name           VARCHAR2(100)   NOT NULL,
    date_of_birth       DATE            NOT NULL,
    village             VARCHAR2(50),
    sector              VARCHAR2(50),
    district            VARCHAR2(50),
    phone_number        VARCHAR2(15),
    blood_type          VARCHAR2(5)     CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    created_date        DATE            DEFAULT SYSDATE
) TABLESPACE TBS_EWS_DATA;

-- ============================================================
-- TABLE 3: PREGNANCIES
-- ============================================================
CREATE TABLE pregnancies (
    pregnancy_id            NUMBER(10)      PRIMARY KEY,
    mother_id               NUMBER(10)      NOT NULL REFERENCES mothers(mother_id),
    estimated_delivery_date DATE            NOT NULL,
    pregnancy_start_date    DATE            NOT NULL,
    gravida                 NUMBER(2),
    para                    NUMBER(2),
    pregnancy_status        VARCHAR2(20)    DEFAULT 'Active' 
                            CHECK (pregnancy_status IN ('Active', 'Delivered', 'Miscarriage', 'Terminated')),
    risk_level              VARCHAR2(10)    DEFAULT 'Low' 
                            CHECK (risk_level IN ('Low', 'Medium', 'High', 'Critical')),
    last_risk_score         NUMBER(5,2),
    created_date            DATE            DEFAULT SYSDATE
) TABLESPACE TBS_EWS_DATA;

-- ============================================================
-- TABLE 4: MATERNAL_VITALS
-- ============================================================
CREATE TABLE maternal_vitals (
    vital_id                NUMBER(10)      PRIMARY KEY,
    pregnancy_id            NUMBER(10)      NOT NULL REFERENCES pregnancies(pregnancy_id),
    recorded_by_chw         NUMBER(10)      NOT NULL REFERENCES community_health_workers(chw_id),
    visit_date              DATE            DEFAULT SYSDATE,
    gestational_age_weeks   NUMBER(2),
    systolic_bp             NUMBER(3),
    diastolic_bp            NUMBER(3),
    temperature             NUMBER(4,1),
    fetal_heart_rate        NUMBER(3),
    weight_kg               NUMBER(5,2),
    vaginal_bleeding        VARCHAR2(3)     DEFAULT 'No' CHECK (vaginal_bleeding IN ('Yes', 'No')),
    severe_headache         VARCHAR2(3)     DEFAULT 'No' CHECK (severe_headache IN ('Yes', 'No')),
    blurred_vision          VARCHAR2(3)     DEFAULT 'No' CHECK (blurred_vision IN ('Yes', 'No')),
    convulsions             VARCHAR2(3)     DEFAULT 'No' CHECK (convulsions IN ('Yes', 'No')),
    reduced_fetal_movement  VARCHAR2(3)     DEFAULT 'No' CHECK (reduced_fetal_movement IN ('Yes', 'No')),
    hemoglobin_level        NUMBER(4,1),
    hiv_status              VARCHAR2(20),
    malaria_test_result     VARCHAR2(20),
    notes                   VARCHAR2(500)
) TABLESPACE TBS_EWS_DATA;

-- ============================================================
-- TABLE 5: MATERNAL_ALERTS
-- ============================================================
CREATE TABLE maternal_alerts (
    alert_id            NUMBER(10)      PRIMARY KEY,
    pregnancy_id        NUMBER(10)      NOT NULL REFERENCES pregnancies(pregnancy_id),
    vital_id            NUMBER(10)      REFERENCES maternal_vitals(vital_id),
    alert_type          VARCHAR2(50),
    severity            VARCHAR2(10)    NOT NULL CHECK (severity IN ('Red', 'Orange', 'Yellow', 'Green')),
    risk_score          NUMBER(5,2),
    alert_timestamp     TIMESTAMP       DEFAULT SYSTIMESTAMP,
    status              VARCHAR2(20)    DEFAULT 'Open' CHECK (status IN ('Open', 'Acknowledged', 'Resolved', 'Escalated')),
    response_action     CLOB,
    resolved_by         NUMBER(10)      REFERENCES community_health_workers(chw_id),
    resolved_date       TIMESTAMP
) TABLESPACE TBS_EWS_DATA;

-- ============================================================
-- TABLE 6: NEWBORNS
-- ============================================================
CREATE TABLE newborns (
    newborn_id          NUMBER(10)      PRIMARY KEY,
    pregnancy_id        NUMBER(10)      NOT NULL REFERENCES pregnancies(pregnancy_id),
    birth_date          DATE            NOT NULL,
    gender              VARCHAR2(10)    CHECK (gender IN ('Male', 'Female')),
    birth_weight_kg     NUMBER(4,2),
    birth_length_cm     NUMBER(4,1),
    apgar_1min          NUMBER(2)       CHECK (apgar_1min BETWEEN 0 AND 10),
    apgar_5min          NUMBER(2)       CHECK (apgar_5min BETWEEN 0 AND 10),
    delivery_type       VARCHAR2(20)    CHECK (delivery_type IN ('Normal', 'Cesarean', 'Assisted', 'Vacuum')),
    delivery_location   VARCHAR2(100),
    birth_complications VARCHAR2(500),
    is_alive            VARCHAR2(3)     DEFAULT 'Yes' CHECK (is_alive IN ('Yes', 'No'))
) TABLESPACE TBS_EWS_DATA;

-- ============================================================
-- TABLE 7: NEWBORN_VITALS
-- ============================================================
CREATE TABLE newborn_vitals (
    nb_vital_id             NUMBER(10)      PRIMARY KEY,
    newborn_id              NUMBER(10)      NOT NULL REFERENCES newborns(newborn_id),
    recorded_by_chw         NUMBER(10)      NOT NULL REFERENCES community_health_workers(chw_id),
    check_date              DATE            DEFAULT SYSDATE,
    day_of_life             NUMBER(2),
    weight_kg               NUMBER(4,2),
    temperature             NUMBER(4,1),
    feeding_status          VARCHAR2(30)    CHECK (feeding_status IN ('Breastfeeding Only', 'Mixed Feeding', 'Formula Only', 'Not Feeding Well')),
    umbilical_status        VARCHAR2(30),
    skin_color              VARCHAR2(30),
    breathing_status        VARCHAR2(30),
    danger_signs_present    VARCHAR2(3)     DEFAULT 'No' CHECK (danger_signs_present IN ('Yes', 'No')),
    danger_signs_details    VARCHAR2(500),
    notes                   VARCHAR2(500)
) TABLESPACE TBS_EWS_DATA;

-- ============================================================
-- TABLE 8: ANC_SCHEDULE
-- ============================================================
CREATE TABLE anc_schedule (
    schedule_id         NUMBER(10)      PRIMARY KEY,
    pregnancy_id        NUMBER(10)      NOT NULL REFERENCES pregnancies(pregnancy_id),
    visit_number        NUMBER(1)       NOT NULL CHECK (visit_number BETWEEN 1 AND 8),
    scheduled_date      DATE            NOT NULL,
    actual_date         DATE,
    status              VARCHAR2(20)    DEFAULT 'Scheduled' 
                        CHECK (status IN ('Scheduled', 'Completed', 'Missed', 'Rescheduled')),
    gestational_week    NUMBER(2),
    notes               VARCHAR2(500),
    CONSTRAINT uk_anc_pregnancy_visit UNIQUE (pregnancy_id, visit_number)
) TABLESPACE TBS_EWS_DATA;

-- ============================================================
-- TABLE 9: REFERRALS
-- ============================================================
CREATE TABLE referrals (
    referral_id             NUMBER(10)      PRIMARY KEY,
    alert_id                NUMBER(10)      REFERENCES maternal_alerts(alert_id),
    pregnancy_id            NUMBER(10)      NOT NULL REFERENCES pregnancies(pregnancy_id),
    newborn_id              NUMBER(10)      REFERENCES newborns(newborn_id),
    referring_chw           NUMBER(10)      NOT NULL REFERENCES community_health_workers(chw_id),
    ambulance_id            NUMBER(10),
    referral_date           DATE            DEFAULT SYSDATE,
    referral_time           TIMESTAMP       DEFAULT SYSTIMESTAMP,
    to_facility             VARCHAR2(100),
    referral_reason         VARCHAR2(500),
    urgency_level           VARCHAR2(20)    CHECK (urgency_level IN ('Emergency', 'Urgent', 'Routine')),
    transport_mode          VARCHAR2(30),
    patient_arrived_time    TIMESTAMP,
    outcome                 VARCHAR2(200),
    status                  VARCHAR2(20)    DEFAULT 'Pending' 
                            CHECK (status IN ('Pending', 'In Transit', 'Arrived', 'Completed', 'Cancelled'))
) TABLESPACE TBS_EWS_DATA;

-- ============================================================
-- TABLE 10: AMBULANCES
-- ============================================================
CREATE TABLE ambulances (
    ambulance_id        NUMBER(10)      PRIMARY KEY,
    vehicle_number      VARCHAR2(20)    NOT NULL UNIQUE,
    based_at_facility   VARCHAR2(100),
    current_status      VARCHAR2(20)    DEFAULT 'Available' 
                        CHECK (current_status IN ('Available', 'Dispatched', 'Maintenance', 'Out of Service')),
    driver_name         VARCHAR2(100),
    driver_phone        VARCHAR2(15),
    last_service_date   DATE,
    notes               VARCHAR2(200)
) TABLESPACE TBS_EWS_DATA;

-- Add FK to referrals after ambulances table exists
ALTER TABLE referrals ADD CONSTRAINT fk_referral_ambulance 
    FOREIGN KEY (ambulance_id) REFERENCES ambulances(ambulance_id);

-- ============================================================
-- TABLE 11: VACCINATIONS
-- ============================================================
CREATE TABLE vaccinations (
    vaccination_id      NUMBER(10)      PRIMARY KEY,
    mother_id           NUMBER(10)      REFERENCES mothers(mother_id),
    newborn_id          NUMBER(10)      REFERENCES newborns(newborn_id),
    administered_by     NUMBER(10)      REFERENCES community_health_workers(chw_id),
    vaccine_type        VARCHAR2(50)    NOT NULL,
    dose_number         NUMBER(1),
    vaccination_date    DATE,
    next_dose_date      DATE,
    batch_number        VARCHAR2(50),
    site_of_injection   VARCHAR2(30),
    adverse_reaction    VARCHAR2(3)     DEFAULT 'No' CHECK (adverse_reaction IN ('Yes', 'No')),
    reaction_details    VARCHAR2(200),
    CONSTRAINT chk_vacc_recipient CHECK (
        (mother_id IS NOT NULL AND newborn_id IS NULL) OR 
        (mother_id IS NULL AND newborn_id IS NOT NULL)
    )
) TABLESPACE TBS_EWS_DATA;

-- ============================================================
-- TABLE 12: AUDIT_LOG
-- ============================================================
CREATE TABLE audit_log (
    log_id              NUMBER(10)      PRIMARY KEY,
    table_name          VARCHAR2(50)    NOT NULL,
    action_type         VARCHAR2(10)    NOT NULL CHECK (action_type IN ('INSERT', 'UPDATE', 'DELETE')),
    action_timestamp    TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    performed_by        VARCHAR2(50),
    record_id           NUMBER(10),
    old_values          CLOB,
    new_values          CLOB,
    action_status       VARCHAR2(10)    DEFAULT 'ALLOWED' CHECK (action_status IN ('ALLOWED', 'DENIED')),
    denial_reason       VARCHAR2(200),
    ip_address          VARCHAR2(50)
) TABLESPACE TBS_EWS_DATA;

-- ============================================================
-- TABLE 13: HOLIDAYS
-- ============================================================
CREATE TABLE holidays (
    holiday_id          NUMBER(10)      PRIMARY KEY,
    holiday_date        DATE            NOT NULL UNIQUE,
    holiday_name        VARCHAR2(100)   NOT NULL,
    description         VARCHAR2(200),
    is_national         VARCHAR2(3)     DEFAULT 'Yes' CHECK (is_national IN ('Yes', 'No'))
) TABLESPACE TBS_EWS_DATA;

-- ============================================================
-- CREATE SEQUENCES FOR PRIMARY KEYS
-- ============================================================
CREATE SEQUENCE seq_chw_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_mother_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pregnancy_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_vital_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_alert_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_newborn_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_nb_vital_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_schedule_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_referral_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ambulance_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_vaccination_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_audit_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_holiday_id START WITH 1 INCREMENT BY 1;

-- ============================================================
-- CREATE INDEXES FOR PERFORMANCE
-- ============================================================
CREATE INDEX idx_mothers_chw ON mothers(assigned_chw_id) TABLESPACE TBS_EWS_IDX;
CREATE INDEX idx_pregnancies_mother ON pregnancies(mother_id) TABLESPACE TBS_EWS_IDX;
CREATE INDEX idx_pregnancies_status ON pregnancies(pregnancy_status) TABLESPACE TBS_EWS_IDX;
CREATE INDEX idx_vitals_pregnancy ON maternal_vitals(pregnancy_id) TABLESPACE TBS_EWS_IDX;
CREATE INDEX idx_vitals_date ON maternal_vitals(visit_date) TABLESPACE TBS_EWS_IDX;
CREATE INDEX idx_alerts_pregnancy ON maternal_alerts(pregnancy_id) TABLESPACE TBS_EWS_IDX;
CREATE INDEX idx_alerts_severity ON maternal_alerts(severity) TABLESPACE TBS_EWS_IDX;
CREATE INDEX idx_alerts_status ON maternal_alerts(status) TABLESPACE TBS_EWS_IDX;
CREATE INDEX idx_newborns_pregnancy ON newborns(pregnancy_id) TABLESPACE TBS_EWS_IDX;
CREATE INDEX idx_referrals_pregnancy ON referrals(pregnancy_id) TABLESPACE TBS_EWS_IDX;
CREATE INDEX idx_referrals_status ON referrals(status) TABLESPACE TBS_EWS_IDX;
CREATE INDEX idx_anc_pregnancy ON anc_schedule(pregnancy_id) TABLESPACE TBS_EWS_IDX;
CREATE INDEX idx_audit_timestamp ON audit_log(action_timestamp) TABLESPACE TBS_EWS_IDX;

-- ============================================================
-- VERIFY ALL TABLES CREATED
-- ============================================================
SELECT table_name, tablespace_name, num_rows 
FROM user_tables 
ORDER BY table_name;

-- ============================================================
-- VERIFY ALL SEQUENCES CREATED
-- ============================================================
SELECT sequence_name, last_number 
FROM user_sequences 
ORDER BY sequence_name;

-- ============================================================
-- VERIFY ALL INDEXES CREATED
-- ============================================================
SELECT index_name, table_name, tablespace_name 
FROM user_indexes 
WHERE index_name LIKE 'IDX_%'
ORDER BY table_name;
