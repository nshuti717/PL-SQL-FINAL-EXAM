# Design Decisions

## Maternal & Newborn Early Warning System

**Student:** NSHUTI Sano Delphin | **ID:** 27903

---

## 1. Overview

This document explains the key design decisions made during the development of the Maternal & Newborn Early Warning System database.

---

## 2. Database Design Decisions

### 2.1 Pluggable Database (PDB) Choice

**Decision:** Use Oracle Pluggable Database architecture.

**Rationale:**
- Isolation from other projects in the same Oracle instance
- Easy backup and recovery
- Resource management control
- Modern Oracle best practice

**Alternative Considered:** Schema-level isolation
- Rejected due to less security and no resource control

---

### 2.2 Tablespace Strategy

**Decision:** Create separate tablespaces for data and indexes.

**Configuration:**
- TBS_EWS_DATA: 100MB (Data)
- TBS_EWS_IDX: 50MB (Indexes)

**Rationale:**
- Performance optimization (separate I/O paths)
- Easier space management
- Better backup/recovery options

---

### 2.3 Normalization Level

**Decision:** Normalize to Third Normal Form (3NF).

**Rationale:**
- Eliminates data redundancy
- Ensures data integrity
- Simplifies updates
- Appropriate for OLTP workload

**Trade-offs Accepted:**
- More joins required for complex queries
- Mitigated by views and proper indexing

---

## 3. Risk Scoring Algorithm Design

### 3.1 Score Calculation

**Decision:** Implement WHO-based risk scoring with additive points.

**Algorithm:**
```
Risk Score = 
    + (Severe Hypertension: 30 pts)
    + (Convulsions: 30 pts)
    + (Vaginal Bleeding: 25 pts)
    + (Severe Anemia: 20 pts)
    + (Mild Hypertension: 15 pts)
    + (Fetal Distress: 15 pts)
    + (High Fever: 15 pts)
    + (Severe Headache: 10 pts)
```

**Rationale:**
- Based on WHO maternal danger signs
- Simple additive model for transparency
- Easy to explain to CHWs
- Cumulative risk capture

---

### 3.2 Alert Thresholds

**Decision:** Four-tier alert system with color coding.

| Severity | Score Range | Color | Action |
|----------|-------------|-------|--------|
| RED | ≥50 | 🔴 | Emergency - Auto ambulance |
| ORANGE | 25-49 | 🟠 | Urgent - 24hr referral |
| YELLOW | 15-24 | 🟡 | Routine - Follow-up |
| GREEN | <15 | 🟢 | Normal - Monitor |

**Rationale:**
- Intuitive traffic light system
- Clear action thresholds
- Globally recognized color coding
- Actionable for field workers

---

## 4. Trigger Design Decisions

### 4.1 Alert Generation Trigger

**Decision:** Use AFTER INSERT trigger on MATERNAL_VITALS.

**Rationale:**
- Ensures vital signs are recorded before alert generation
- Access to :NEW values for calculations
- Maintains data integrity

**Alternative Considered:** Application-level alert generation
- Rejected because database triggers ensure alerts are never missed regardless of entry method

---

### 4.2 Audit Trigger Approach

**Decision:** Separate audit triggers per table.

**Rationale:**
- Clearer code organization
- Easier maintenance
- Can enable/disable per table
- Specific field tracking per table

**Alternative Considered:** Single compound trigger
- Rejected due to complexity and less flexibility

---

### 4.3 DML Restriction Design

**Decision:** Use BEFORE triggers with RAISE_APPLICATION_ERROR.

**Implementation:**
```sql
IF is_weekday OR is_holiday THEN
    -- Log attempt first
    INSERT INTO audit_log (status) VALUES ('DENIED');
    -- Then raise error
    RAISE_APPLICATION_ERROR(-20001, 'DML not allowed');
END IF;
```

**Rationale:**
- BEFORE triggers can prevent operation
- Application error provides clear message
- Audit log captures all attempts
- Follows requirement exactly

---

## 5. Data Model Decisions

### 5.1 Pregnancy-Mother Relationship

**Decision:** Separate PREGNANCIES table linked to MOTHERS.

**Rationale:**
- One mother can have multiple pregnancies
- Historical tracking maintained
- Cleaner data model
- Easy outcome analysis

---

### 5.2 Vital Signs Storage

**Decision:** One row per visit in MATERNAL_VITALS.

**Rationale:**
- Complete snapshot per visit
- Easy trend analysis with LAG/LEAD
- Simpler queries
- Clear audit trail

**Alternative Considered:** EAV (Entity-Attribute-Value) model
- Rejected due to query complexity

---

### 5.3 Alert Status Tracking

**Decision:** Status field with timestamps for each state.

**Fields:**
- STATUS: OPEN/ACKNOWLEDGED/RESOLVED
- CREATED_AT: Alert creation
- ACKNOWLEDGED_AT: When seen
- RESOLVED_AT: When closed

**Rationale:**
- Clear lifecycle tracking
- Response time calculation
- Audit compliance
- Performance metrics

---

## 6. PL/SQL Design Decisions

### 6.1 Package Architecture

**Decision:** Two packages - EWS_CORE_PKG and EWS_REPORTS_PKG.

**Rationale:**
- Separation of concerns
- Core operations vs. reporting
- Easier maintenance
- Clear API surface

---

### 6.2 Function vs. Procedure Choice

**Decision:** 
- Functions: Calculations that return values
- Procedures: Actions with side effects

**Examples:**
- `calculate_maternal_risk_score()` → Function (returns NUMBER)
- `sp_dispatch_ambulance()` → Procedure (performs DML)

**Rationale:**
- Clear semantic distinction
- Functions can be used in SQL
- Procedures for complex workflows

---

### 6.3 Exception Handling Strategy

**Decision:** Custom exceptions with meaningful error codes.

**Error Code Ranges:**
- -20001 to -20099: DML Restriction errors
- -20100 to -20199: Validation errors
- -20200 to -20299: Business rule errors

**Rationale:**
- Easy error categorization
- Clear troubleshooting
- Client application handling

---

## 7. BI Design Decisions

### 7.1 Dashboard Approach

**Decision:** SQL-based KPIs with potential Oracle APEX integration.

**Rationale:**
- No additional tools required
- Queries can power any frontend
- Flexible implementation
- Low cost

---

### 7.2 KPI Selection

**Decision:** Focus on actionable metrics.

**Criteria for KPI selection:**
1. Measurable from existing data
2. Actionable insight
3. Clear target/threshold
4. Relevant to stakeholders

---

## 8. Security Decisions

### 8.1 User Privileges

**Decision:** Principle of least privilege.

**Implementation:**
- PDB_ADMIN: Full access (developer)
- CHW_USER: INSERT/UPDATE only (future)
- SUPERVISOR: SELECT + reports (future)

**Rationale:**
- Security best practice
- Limits damage from compromise
- Audit compliance

---

### 8.2 Audit Trail Completeness

**Decision:** Log ALL operations including denied attempts.

**Rationale:**
- Complete audit trail
- Security monitoring
- Compliance requirement
- Pattern detection

---

## 9. Lessons Learned

### 9.1 What Worked Well

1. **Modular trigger design** - Easy to test and maintain
2. **Comprehensive audit logging** - Invaluable for debugging
3. **WHO-based risk scoring** - Credible and effective
4. **Separate tablespaces** - Clean organization

### 9.2 Challenges Faced

1. **Compound trigger complexity** - Simplified to separate triggers
2. **Risk score calibration** - Required iteration
3. **Weekend testing** - DML restriction made testing tricky

### 9.3 Future Improvements

1. Add predictive analytics with ML models
2. Implement real-time notifications
3. Add mobile API layer
4. Implement data archival strategy

---

*Document Version: 1.0 | Last Updated: December 2025*
