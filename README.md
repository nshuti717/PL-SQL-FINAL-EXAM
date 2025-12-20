# TUE_27903_DELPHIN_MATERNALEWS_DB

## Community-Based Maternal & Newborn Early Warning System

### PL/SQL Capstone Project - Database Development (INSY 8311)

---

## 👤 Student Information

| Field | Details |
|-------|---------|
| **Student Name** | NSHUTI Sano Delphin |
| **Student ID** | 27903 |
| **Course** | Database Development with PL/SQL (INSY 8311) |
| **Instructor** | Mr. Eric MANIRAGUHA |
| **Institution** | Adventist University of Central Africa (AUCA) |
| **Submission Date** | December 2025 |

---

## 📋 Problem Statement

Rwanda's Community Health Workers (CHWs) face challenges in identifying high-risk pregnancies early enough to prevent maternal and newborn complications. This system provides automated risk scoring based on WHO guidelines, real-time alert generation, and emergency response coordination to reduce maternal mortality.

---

## 🎯 Key Objectives

1. Automate maternal risk assessment using WHO-based algorithms
2. Generate color-coded alerts (RED/ORANGE/YELLOW) for timely intervention
3. Enable automatic ambulance dispatch for emergencies
4. Track ANC visits according to WHO 8-visit model
5. Maintain comprehensive audit trails for compliance
6. Implement DML restrictions on weekdays and public holidays

---

## 📁 Repository Structure

```
TUE_27903_DELPHIN_MATERNALEWS_DB/
├── README.md                          # Project overview (this file)
│
├── database/
│   ├── scripts/                       # All SQL scripts
│   │   ├── phase4_database_setup.sql
│   │   ├── phase5_01_create_tables.sql
│   │   ├── phase5_02_insert_sample_data.sql
│   │   ├── phase5_03_insert_additional_data.sql
│   │   ├── phase5_04_verification_queries.sql
│   │   ├── phase6_01_functions.sql
│   │   ├── phase6_02_procedures.sql
│   │   ├── phase6_03_packages.sql
│   │   ├── phase6_04_cursors.sql
│   │   ├── phase6_05_window_functions.sql
│   │   ├── phase7_01_triggers.sql
│   │   ├── phase7_02_audit_triggers.sql
│   │   └── phase7_03_dml_restriction.sql
│   └── documentation/
│
├── queries/
│   ├── data_retrieval.sql            # Basic SELECT, JOIN, GROUP BY
│   ├── analytics_queries.sql         # Window functions, rankings
│   └── audit_queries.sql             # Audit log queries
│
├── business_intelligence/
│   ├── bi_requirements.md            # BI requirements & stakeholders
│   ├── kpi_definitions.md            # KPI definitions with SQL
│   └── dashboards.md                 # Dashboard mockups
│
├── screenshots/                       # Add your screenshots here
│   ├── oem_monitoring/
│   ├── database_objects/
│   └── test_results/
│
├── documentation/
│   ├── data_dictionary.md            # Complete data dictionary
│   ├── architecture.md               # System architecture
│   └── design_decisions.md           # Design rationale
│
└── presentation/
    ├── Phase8_Final_Report.docx      # Final project report
    └── Phase8_Presentation.pptx      # 10-slide presentation
```

---

## 🗄️ Database Schema

### Tables (13 Total)

| # | Table | Purpose | Records |
|---|-------|---------|---------|
| 1 | COMMUNITY_HEALTH_WORKERS | CHW profiles | 20 |
| 2 | MOTHERS | Mother registry | 50 |
| 3 | PREGNANCIES | Pregnancy tracking | 50 |
| 4 | MATERNAL_VITALS | Vital signs | 25+ |
| 5 | MATERNAL_ALERTS | Generated alerts | 15 |
| 6 | NEWBORNS | Birth records | 9 |
| 7 | NEWBORN_VITALS | Newborn health | 14 |
| 8 | ANC_SCHEDULE | WHO 8-visit schedule | 19 |
| 9 | REFERRALS | Emergency referrals | 9 |
| 10 | AMBULANCES | Fleet management | 5 |
| 11 | VACCINATIONS | Immunizations | 18 |
| 12 | AUDIT_LOG | Audit trails | Dynamic |
| 13 | HOLIDAYS | Public holidays | 9 |

---

## 🔧 PL/SQL Components

### Functions (7)
- `calculate_maternal_risk_score()` - WHO-based risk scoring
- `get_alert_severity()` - Score to color conversion
- `calculate_gestational_age()` - Weeks of pregnancy
- `get_mother_age()` - Age calculation
- `is_high_risk_pregnancy()` - Risk determination
- `count_open_alerts_for_chw()` - Alert counting
- `days_until_delivery()` - EDD countdown

### Procedures (10)
- `sp_register_mother()` - Mother registration
- `sp_register_pregnancy()` - Pregnancy registration
- `sp_record_vital_signs()` - Vital signs + auto-alert
- `sp_generate_alert()` - Alert creation
- `sp_dispatch_ambulance()` - Emergency dispatch
- `sp_generate_anc_schedule()` - WHO 8-visit generation
- `sp_complete_referral()` - Referral closure
- `sp_record_delivery()` - Delivery recording
- `sp_administer_vaccination()` - Vaccination tracking
- `sp_chw_daily_report()` - Daily summary

### Packages (2)
- **EWS_CORE_PKG** - Core EWS functions
- **EWS_REPORTS_PKG** - Reporting and analytics

### Triggers (19)
| Type | Count | Purpose |
|------|-------|---------|
| Business Logic | 8 | Auto-alerts, dispatch, validation |
| Audit | 6 | Log all DML operations |
| DML Restriction | 5 | Block weekday/holiday DML |

---

## 🚨 Risk Scoring Algorithm

### Risk Factors
| Condition | Points |
|-----------|--------|
| Severe Hypertension (BP ≥160/110) | +30 |
| Convulsions / Eclampsia | +30 |
| Vaginal Bleeding | +25 |
| Severe Anemia (Hb < 7 g/dL) | +20 |
| Mild Hypertension (BP ≥140/90) | +15 |
| Fetal Distress (abnormal FHR) | +15 |
| High Fever (≥38.5°C) | +15 |
| Severe Headache / Vision | +10 |

### Alert Thresholds
| Severity | Score | Action |
|----------|-------|--------|
| 🔴 RED | ≥50 | Emergency - Auto ambulance |
| 🟠 ORANGE | 25-49 | Urgent - 24hr referral |
| 🟡 YELLOW | 15-24 | Routine - Follow-up |
| 🟢 GREEN | <15 | Normal - Monitor |

---

## 📊 Business Intelligence

### KPIs Tracked
- Total Active Pregnancies
- High-Risk Pregnancy Rate (Target: <15%)
- Open Alerts by Severity
- Alert Response Time
- CHW Caseload Distribution
- ANC Completion Rate (Target: >85%)
- Ambulance Availability (Target: >60%)

### Dashboards
1. **Executive Summary** - KPI cards, trends
2. **Audit Dashboard** - Violations, denials
3. **CHW Performance** - Workload, metrics
4. **Alert Response** - Real-time monitoring

---

## 🚀 Quick Start

### 1. Connect to PDB
```sql
sqlplus sys as sysdba
ALTER SESSION SET CONTAINER = TUE_27903_DELPHIN_MATERNALEWS_DB;
```

### 2. Connect as Admin
```sql
sqlplus pdb_admin/admin123@localhost:1521/TUE_27903_DELPHIN_MATERNALEWS_DB
```

### 3. Run Scripts (in order)
```sql
@phase5_01_create_tables.sql
@phase5_02_insert_sample_data.sql
@phase6_01_functions.sql
@phase6_02_procedures.sql
@phase6_03_packages.sql
@phase7_01_triggers.sql
@phase7_02_audit_triggers.sql
@phase7_03_dml_restriction.sql
```

---

## 📸 Screenshots Required

Add screenshots to `/screenshots/` folder:
- [ ] ER diagram with all tables
- [ ] Database structure (SQL Developer)
- [ ] Sample data (5-10 rows)
- [ ] Procedures/triggers in editor
- [ ] Test results and execution
- [ ] Audit log entries
- [ ] DML restriction test (denied on weekday)

---

## 🛠️ Technologies Used

- **Database:** Oracle 21c XE (Pluggable Database)
- **Language:** PL/SQL
- **Tools:** SQL Developer, SQL*Plus
- **Diagrams:** draw.io
- **Documentation:** Microsoft Word, PowerPoint
- **Version Control:** Git, GitHub

---

## ✅ Phase Completion Status

| Phase | Description | Status |
|-------|-------------|--------|
| I | Problem Statement | ✅ |
| II | Business Process (BPMN) | ✅ |
| III | Logical Model (ERD) | ✅ |
| IV | Database Creation | ✅ |
| V | Tables & Data | ✅ |
| VI | PL/SQL Programming | ✅ |
| VII | Triggers & Auditing | ✅ |
| VIII | Documentation & BI | ✅ |

---

## 📧 Contact

**NSHUTI Sano Delphin**
- Student ID: 27903
- GitHub: [@nshuti717](https://github.com/nshuti717)

---

## 📜 Submission

**Instructor:** Mr. Eric MANIRAGUHA  
**Email:** eric.maniraguha@auca.ac.rw  
**Deadline:** December 7, 2025

---

*"Whatever you do, work at it with all your heart, as working for the Lord, not for human masters." — Colossians 3:23 (NIV)*
