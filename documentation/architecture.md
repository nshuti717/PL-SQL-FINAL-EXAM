# System Architecture

## Maternal & Newborn Early Warning System

**Student:** NSHUTI Sano Delphin | **ID:** 27903

---

## 1. Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           SYSTEM ARCHITECTURE                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐                   │
│   │ CHW Mobile  │     │ Web Portal  │     │ Admin Panel │                   │
│   │   App       │     │             │     │             │                   │
│   └──────┬──────┘     └──────┬──────┘     └──────┬──────┘                   │
│          │                   │                   │                           │
│          └───────────────────┼───────────────────┘                           │
│                              │                                               │
│                              ▼                                               │
│          ┌───────────────────────────────────────┐                          │
│          │         APPLICATION LAYER              │                          │
│          │    (API / Business Logic Layer)        │                          │
│          └───────────────────┬───────────────────┘                          │
│                              │                                               │
│                              ▼                                               │
│   ┌──────────────────────────────────────────────────────────────────┐      │
│   │                    ORACLE DATABASE LAYER                          │      │
│   │  ┌──────────────────────────────────────────────────────────┐    │      │
│   │  │         TUE_27903_DELPHIN_MATERNALEWS_DB (PDB)           │    │      │
│   │  │                                                           │    │      │
│   │  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐       │    │      │
│   │  │  │   TABLES    │  │  PL/SQL     │  │  TRIGGERS   │       │    │      │
│   │  │  │   (13)      │  │  PACKAGES   │  │   (19)      │       │    │      │
│   │  │  │             │  │  (2)        │  │             │       │    │      │
│   │  │  └─────────────┘  └─────────────┘  └─────────────┘       │    │      │
│   │  │                                                           │    │      │
│   │  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐       │    │      │
│   │  │  │ FUNCTIONS   │  │ PROCEDURES  │  │   VIEWS     │       │    │      │
│   │  │  │   (7)       │  │   (10)      │  │   (2)       │       │    │      │
│   │  │  └─────────────┘  └─────────────┘  └─────────────┘       │    │      │
│   │  │                                                           │    │      │
│   │  │  ┌───────────────────────────────────────────────┐       │    │      │
│   │  │  │              AUDIT_LOG TABLE                   │       │    │      │
│   │  │  │         (Comprehensive Audit Trail)            │       │    │      │
│   │  │  └───────────────────────────────────────────────┘       │    │      │
│   │  └──────────────────────────────────────────────────────────┘    │      │
│   │                                                                   │      │
│   │  ┌─────────────────────┐  ┌─────────────────────┐                │      │
│   │  │   TBS_EWS_DATA      │  │   TBS_EWS_IDX       │                │      │
│   │  │   (Data Tablespace) │  │  (Index Tablespace) │                │      │
│   │  │      100MB          │  │       50MB          │                │      │
│   │  └─────────────────────┘  └─────────────────────┘                │      │
│   └──────────────────────────────────────────────────────────────────┘      │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Database Architecture

### 2.1 Container Database Structure

```
Oracle XE 21c (CDB)
    │
    ├── CDB$ROOT (Container Root)
    │
    ├── PDB$SEED (Seed Database)
    │
    └── TUE_27903_DELPHIN_MATERNALEWS_DB (Pluggable Database)
            │
            ├── PDB_ADMIN (Admin User)
            │
            ├── TBS_EWS_DATA (Data Tablespace - 100MB)
            │
            └── TBS_EWS_IDX (Index Tablespace - 50MB)
```

### 2.2 Tablespace Configuration

| Tablespace | Purpose | Initial Size | Autoextend |
|------------|---------|--------------|------------|
| TBS_EWS_DATA | Data storage | 100 MB | ON (50MB increments) |
| TBS_EWS_IDX | Index storage | 50 MB | ON (25MB increments) |
| TEMP | Temporary operations | Default | Default |

---

## 3. Data Flow Architecture

### 3.1 Vital Signs Recording Flow

```
┌─────────┐    ┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│   CHW   │───▶│ Record      │───▶│ TRIGGER:     │───▶│ Generate    │
│ Records │    │ Vital Signs │    │ Calculate    │    │ Alert       │
│ Vitals  │    │             │    │ Risk Score   │    │ (if needed) │
└─────────┘    └─────────────┘    └──────────────┘    └──────┬──────┘
                                                              │
                                                              ▼
                                        ┌─────────────────────────────────┐
                                        │     IF Severity = 'RED'         │
                                        │     THEN Auto-dispatch          │
                                        │          Ambulance              │
                                        └─────────────────────────────────┘
```

### 3.2 Alert Processing Flow

```
┌────────────────┐
│ MATERNAL_VITALS│
│    INSERT      │
└───────┬────────┘
        │
        ▼
┌────────────────────────────────┐
│ TRIGGER: trg_vitals_alert      │
│ 1. Calculate risk_score        │
│ 2. Determine severity          │
│ 3. Generate alert if needed    │
└───────────────┬────────────────┘
                │
        ┌───────┴───────┐
        │               │
        ▼               ▼
┌───────────────┐ ┌───────────────┐
│ Score < 15    │ │ Score >= 15   │
│ No Alert      │ │ Create Alert  │
└───────────────┘ └───────┬───────┘
                          │
                ┌─────────┴─────────┐
                │                   │
                ▼                   ▼
        ┌───────────────┐   ┌───────────────┐
        │ Score >= 50   │   │ Score < 50    │
        │ RED Alert     │   │ ORANGE/YELLOW │
        │ + Ambulance   │   │               │
        └───────────────┘   └───────────────┘
```

---

## 4. Security Architecture

### 4.1 User Roles

| Role | Privileges | Purpose |
|------|------------|---------|
| PDB_ADMIN | DBA | Full database administration |
| CHW_USER | Limited DML | CHW data entry |
| SUPERVISOR | Read + Reports | Supervisory access |
| AUDITOR | Read AUDIT_LOG | Compliance monitoring |

### 4.2 DML Restriction Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    DML RESTRICTION CHECK                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐       │
│   │  Is today   │ YES │  Block DML  │     │  Log to     │       │
│   │  a weekday? │────▶│  Operation  │────▶│  AUDIT_LOG  │       │
│   │             │     │             │     │  (DENIED)   │       │
│   └──────┬──────┘     └─────────────┘     └─────────────┘       │
│          │ NO                                                    │
│          ▼                                                       │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐       │
│   │  Is today   │ YES │  Block DML  │     │  Log to     │       │
│   │  a holiday? │────▶│  Operation  │────▶│  AUDIT_LOG  │       │
│   │             │     │             │     │  (DENIED)   │       │
│   └──────┬──────┘     └─────────────┘     └─────────────┘       │
│          │ NO                                                    │
│          ▼                                                       │
│   ┌─────────────┐     ┌─────────────┐                           │
│   │  Allow DML  │────▶│  Log to     │                           │
│   │  Operation  │     │  AUDIT_LOG  │                           │
│   │             │     │  (ALLOWED)  │                           │
│   └─────────────┘     └─────────────┘                           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 5. Component Summary

### 5.1 Database Objects Count

| Object Type | Count |
|-------------|-------|
| Tables | 13 |
| Sequences | 13 |
| Indexes | 13+ |
| Functions | 7 |
| Procedures | 10 |
| Packages | 2 |
| Triggers | 19 |
| Views | 2 |

### 5.2 Trigger Categories

| Category | Count | Purpose |
|----------|-------|---------|
| Business Logic | 8 | Auto-alerts, dispatch, validation |
| Audit | 6 | Log all DML operations |
| DML Restriction | 5 | Block weekday/holiday DML |

---

## 6. Performance Considerations

### 6.1 Indexing Strategy

| Table | Indexed Columns | Purpose |
|-------|-----------------|---------|
| MOTHERS | MOTHER_ID, SECTOR | Fast lookups |
| PREGNANCIES | PREGNANCY_ID, STATUS | Active queries |
| MATERNAL_ALERTS | SEVERITY, STATUS | Alert monitoring |
| AUDIT_LOG | CHANGE_TIMESTAMP | Time-based queries |

### 6.2 Optimization Features

- Tablespace separation (data vs. indexes)
- Sequence-based ID generation
- Compound triggers for efficiency
- Index on frequently filtered columns

---

*Document Version: 1.0 | Last Updated: December 2025*
