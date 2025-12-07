# Data Dictionary

## Maternal & Newborn Early Warning System

**Student:** NSHUTI Sano Delphin | **ID:** 27903

---

## 1. Database Overview

| Attribute | Value |
|-----------|-------|
| Database Name | TUE_27903_DELPHIN_MATERNALEWS_DB |
| Database Type | Oracle 21c XE (Pluggable Database) |
| Character Set | AL32UTF8 |
| Total Tables | 13 |
| Total Sequences | 13 |
| Total Triggers | 19 |

---

## 2. Table Definitions

### 2.1 COMMUNITY_HEALTH_WORKERS

**Purpose:** Stores Community Health Worker profiles and assignments.

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| CHW_ID | NUMBER(10) | PK, NOT NULL | Unique identifier |
| FIRST_NAME | VARCHAR2(50) | NOT NULL | First name |
| LAST_NAME | VARCHAR2(50) | NOT NULL | Last name |
| PHONE | VARCHAR2(15) | NOT NULL, UNIQUE | Contact phone |
| EMAIL | VARCHAR2(100) | UNIQUE | Email address |
| SECTOR | VARCHAR2(50) | NOT NULL | Assigned sector |
| CELL | VARCHAR2(50) | NOT NULL | Assigned cell |
| VILLAGE | VARCHAR2(50) | NOT NULL | Assigned village |
| HIRE_DATE | DATE | DEFAULT SYSDATE | Employment start date |
| STATUS | VARCHAR2(20) | DEFAULT 'ACTIVE' | ACTIVE/INACTIVE/SUSPENDED |
| CREATED_AT | TIMESTAMP | DEFAULT SYSTIMESTAMP | Record creation time |

---

### 2.2 MOTHERS

**Purpose:** Registry of all mothers in the system.

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| MOTHER_ID | NUMBER(10) | PK, NOT NULL | Unique identifier |
| FIRST_NAME | VARCHAR2(50) | NOT NULL | First name |
| LAST_NAME | VARCHAR2(50) | NOT NULL | Last name |
| DATE_OF_BIRTH | DATE | NOT NULL | Birth date |
| NATIONAL_ID | VARCHAR2(20) | UNIQUE | National ID number |
| PHONE | VARCHAR2(15) | | Contact phone |
| SECTOR | VARCHAR2(50) | NOT NULL | Residential sector |
| CELL | VARCHAR2(50) | NOT NULL | Residential cell |
| VILLAGE | VARCHAR2(50) | NOT NULL | Residential village |
| BLOOD_TYPE | VARCHAR2(5) | | Blood type (A+, B-, etc.) |
| EMERGENCY_CONTACT | VARCHAR2(15) | | Emergency phone |
| REGISTRATION_DATE | DATE | DEFAULT SYSDATE | Registration date |
| CREATED_AT | TIMESTAMP | DEFAULT SYSTIMESTAMP | Record creation |

---

### 2.3 PREGNANCIES

**Purpose:** Tracks all pregnancies with risk levels and outcomes.

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| PREGNANCY_ID | NUMBER(10) | PK, NOT NULL | Unique identifier |
| MOTHER_ID | NUMBER(10) | FK → MOTHERS, NOT NULL | Mother reference |
| ASSIGNED_CHW_ID | NUMBER(10) | FK → CHWs, NOT NULL | Assigned CHW |
| LMP_DATE | DATE | NOT NULL | Last menstrual period |
| EXPECTED_DELIVERY_DATE | DATE | NOT NULL | Calculated EDD |
| GRAVIDA | NUMBER(2) | | Number of pregnancies |
| PARA | NUMBER(2) | | Number of deliveries |
| RISK_LEVEL | VARCHAR2(10) | DEFAULT 'LOW' | LOW/MEDIUM/HIGH |
| STATUS | VARCHAR2(20) | DEFAULT 'ACTIVE' | ACTIVE/DELIVERED/COMPLICATED |
| DELIVERY_DATE | DATE | | Actual delivery date |
| DELIVERY_TYPE | VARCHAR2(20) | | NORMAL/CESAREAN/ASSISTED |
| OUTCOME | VARCHAR2(20) | | LIVE_BIRTH/STILLBIRTH |
| CREATED_AT | TIMESTAMP | DEFAULT SYSTIMESTAMP | Record creation |

---

### 2.4 MATERNAL_VITALS

**Purpose:** Records vital signs during pregnancy visits.

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| VITAL_ID | NUMBER(10) | PK, NOT NULL | Unique identifier |
| PREGNANCY_ID | NUMBER(10) | FK → PREGNANCIES, NOT NULL | Pregnancy reference |
| RECORDED_BY | NUMBER(10) | FK → CHWs, NOT NULL | Recording CHW |
| SYSTOLIC_BP | NUMBER(3) | | Systolic blood pressure (mmHg) |
| DIASTOLIC_BP | NUMBER(3) | | Diastolic blood pressure (mmHg) |
| TEMPERATURE | NUMBER(4,1) | | Body temperature (°C) |
| WEIGHT_KG | NUMBER(5,2) | | Weight in kilograms |
| HEMOGLOBIN | NUMBER(4,1) | | Hemoglobin level (g/dL) |
| FETAL_HEART_RATE | NUMBER(3) | | Fetal heart rate (bpm) |
| HAS_CONVULSIONS | CHAR(1) | DEFAULT 'N' | Y/N flag |
| HAS_BLEEDING | CHAR(1) | DEFAULT 'N' | Y/N flag |
| HAS_HEADACHE | CHAR(1) | DEFAULT 'N' | Y/N flag |
| HAS_BLURRED_VISION | CHAR(1) | DEFAULT 'N' | Y/N flag |
| NOTES | VARCHAR2(500) | | Additional notes |
| RECORDED_AT | TIMESTAMP | DEFAULT SYSTIMESTAMP | Recording time |
| CREATED_AT | TIMESTAMP | DEFAULT SYSTIMESTAMP | Record creation |

---

### 2.5 MATERNAL_ALERTS

**Purpose:** Auto-generated alerts based on risk scores.

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| ALERT_ID | NUMBER(10) | PK, NOT NULL | Unique identifier |
| PREGNANCY_ID | NUMBER(10) | FK → PREGNANCIES, NOT NULL | Pregnancy reference |
| VITAL_ID | NUMBER(10) | FK → VITALS | Triggering vital record |
| SEVERITY | VARCHAR2(10) | NOT NULL | RED/ORANGE/YELLOW |
| RISK_SCORE | NUMBER(3) | | Calculated risk score |
| ALERT_MESSAGE | VARCHAR2(500) | | Alert description |
| STATUS | VARCHAR2(20) | DEFAULT 'OPEN' | OPEN/ACKNOWLEDGED/RESOLVED |
| ACKNOWLEDGED_BY | NUMBER(10) | FK → CHWs | Acknowledging CHW |
| ACKNOWLEDGED_AT | TIMESTAMP | | Acknowledgment time |
| RESOLVED_AT | TIMESTAMP | | Resolution time |
| CREATED_AT | TIMESTAMP | DEFAULT SYSTIMESTAMP | Alert creation time |

---

### 2.6 NEWBORNS

**Purpose:** Records newborn information after delivery.

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| NEWBORN_ID | NUMBER(10) | PK, NOT NULL | Unique identifier |
| PREGNANCY_ID | NUMBER(10) | FK → PREGNANCIES, NOT NULL | Pregnancy reference |
| GENDER | VARCHAR2(10) | NOT NULL | MALE/FEMALE |
| BIRTH_WEIGHT_KG | NUMBER(4,2) | | Birth weight |
| BIRTH_LENGTH_CM | NUMBER(4,1) | | Birth length |
| APGAR_1MIN | NUMBER(2) | | 1-minute Apgar score |
| APGAR_5MIN | NUMBER(2) | | 5-minute Apgar score |
| DELIVERY_TYPE | VARCHAR2(20) | | NORMAL/CESAREAN/ASSISTED |
| COMPLICATIONS | VARCHAR2(200) | | Birth complications |
| STATUS | VARCHAR2(20) | DEFAULT 'HEALTHY' | Health status |
| CREATED_AT | TIMESTAMP | DEFAULT SYSTIMESTAMP | Record creation |

---

### 2.7 REFERRALS

**Purpose:** Emergency referral tracking.

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| REFERRAL_ID | NUMBER(10) | PK, NOT NULL | Unique identifier |
| PREGNANCY_ID | NUMBER(10) | FK → PREGNANCIES, NOT NULL | Pregnancy reference |
| ALERT_ID | NUMBER(10) | FK → ALERTS | Triggering alert |
| AMBULANCE_ID | NUMBER(10) | FK → AMBULANCES | Dispatched ambulance |
| URGENCY_LEVEL | VARCHAR2(20) | NOT NULL | EMERGENCY/URGENT/ROUTINE |
| REASON | VARCHAR2(200) | | Referral reason |
| DESTINATION_FACILITY | VARCHAR2(100) | | Target health facility |
| STATUS | VARCHAR2(20) | DEFAULT 'PENDING' | PENDING/IN_TRANSIT/COMPLETED |
| DEPARTURE_TIME | TIMESTAMP | | Ambulance departure |
| ARRIVAL_TIME | TIMESTAMP | | Arrival at facility |
| COMPLETED_AT | TIMESTAMP | | Referral completion |
| CREATED_AT | TIMESTAMP | DEFAULT SYSTIMESTAMP | Record creation |

---

### 2.8 AMBULANCES

**Purpose:** Ambulance fleet management.

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| AMBULANCE_ID | NUMBER(10) | PK, NOT NULL | Unique identifier |
| VEHICLE_NUMBER | VARCHAR2(20) | NOT NULL, UNIQUE | License plate |
| DRIVER_NAME | VARCHAR2(100) | | Driver name |
| DRIVER_PHONE | VARCHAR2(15) | | Driver contact |
| BASE_LOCATION | VARCHAR2(100) | | Base station |
| STATUS | VARCHAR2(20) | DEFAULT 'AVAILABLE' | AVAILABLE/DISPATCHED/MAINTENANCE |
| LAST_SERVICE_DATE | DATE | | Last maintenance |
| CREATED_AT | TIMESTAMP | DEFAULT SYSTIMESTAMP | Record creation |

---

### 2.9 ANC_SCHEDULE

**Purpose:** WHO 8-visit ANC scheduling.

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| SCHEDULE_ID | NUMBER(10) | PK, NOT NULL | Unique identifier |
| PREGNANCY_ID | NUMBER(10) | FK → PREGNANCIES, NOT NULL | Pregnancy reference |
| VISIT_NUMBER | NUMBER(2) | NOT NULL | Visit number (1-8) |
| SCHEDULED_DATE | DATE | NOT NULL | Planned visit date |
| ACTUAL_DATE | DATE | | Actual visit date |
| STATUS | VARCHAR2(20) | DEFAULT 'SCHEDULED' | SCHEDULED/COMPLETED/MISSED |
| NOTES | VARCHAR2(200) | | Visit notes |
| CREATED_AT | TIMESTAMP | DEFAULT SYSTIMESTAMP | Record creation |

---

### 2.10 AUDIT_LOG

**Purpose:** Comprehensive audit trail for all operations.

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| LOG_ID | NUMBER(10) | PK, NOT NULL | Unique identifier |
| TABLE_NAME | VARCHAR2(50) | NOT NULL | Affected table |
| OPERATION | VARCHAR2(10) | NOT NULL | INSERT/UPDATE/DELETE |
| RECORD_ID | NUMBER(10) | | Affected record ID |
| OLD_VALUES | CLOB | | Previous values (JSON) |
| NEW_VALUES | CLOB | | New values (JSON) |
| CHANGED_BY | VARCHAR2(50) | | User who made change |
| CHANGE_TIMESTAMP | TIMESTAMP | DEFAULT SYSTIMESTAMP | Change time |
| STATUS | VARCHAR2(20) | | ALLOWED/DENIED |

---

### 2.11 HOLIDAYS

**Purpose:** Rwanda public holidays for DML restriction.

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| HOLIDAY_ID | NUMBER(10) | PK, NOT NULL | Unique identifier |
| HOLIDAY_NAME | VARCHAR2(100) | NOT NULL | Holiday name |
| HOLIDAY_DATE | DATE | NOT NULL, UNIQUE | Holiday date |
| DESCRIPTION | VARCHAR2(200) | | Description |
| CREATED_AT | TIMESTAMP | DEFAULT SYSTIMESTAMP | Record creation |

---

## 3. Relationships Summary

```
COMMUNITY_HEALTH_WORKERS (1) ──────< (M) PREGNANCIES
MOTHERS (1) ──────< (M) PREGNANCIES
PREGNANCIES (1) ──────< (M) MATERNAL_VITALS
PREGNANCIES (1) ──────< (M) MATERNAL_ALERTS
PREGNANCIES (1) ──────< (M) NEWBORNS
PREGNANCIES (1) ──────< (M) REFERRALS
PREGNANCIES (1) ──────< (M) ANC_SCHEDULE
AMBULANCES (1) ──────< (M) REFERRALS
```

---

*Document Version: 1.0 | Last Updated: December 2025*
