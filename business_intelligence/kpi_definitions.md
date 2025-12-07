# KPI Definitions

## Maternal & Newborn Early Warning System

**Student:** NSHUTI Sano Delphin | **ID:** 27903

---

## 1. Overview

This document defines the Key Performance Indicators (KPIs) used to measure the effectiveness of the Maternal & Newborn Early Warning System.

---

## 2. Executive KPIs

### KPI-001: Total Active Pregnancies
| Attribute | Value |
|-----------|-------|
| **Definition** | Count of all pregnancies with status = 'ACTIVE' |
| **Formula** | `COUNT(*) FROM pregnancies WHERE status = 'ACTIVE'` |
| **Target** | N/A (Volume indicator) |
| **Frequency** | Real-time |
| **Owner** | District Health Officer |

```sql
SELECT COUNT(*) AS active_pregnancies 
FROM pregnancies 
WHERE status = 'ACTIVE';
```

---

### KPI-002: High-Risk Pregnancy Rate
| Attribute | Value |
|-----------|-------|
| **Definition** | Percentage of active pregnancies classified as HIGH risk |
| **Formula** | (HIGH risk pregnancies / Total active pregnancies) × 100 |
| **Target** | <15% |
| **Frequency** | Weekly |
| **Owner** | Health Program Manager |

```sql
SELECT 
    ROUND(SUM(CASE WHEN risk_level = 'HIGH' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) 
    AS high_risk_percentage
FROM pregnancies 
WHERE status = 'ACTIVE';
```

---

### KPI-003: Open Alert Count by Severity
| Attribute | Value |
|-----------|-------|
| **Definition** | Number of unresolved alerts grouped by severity |
| **Formula** | `COUNT(*) GROUP BY severity WHERE status = 'OPEN'` |
| **Target** | RED: 0, ORANGE: <5, YELLOW: <20 |
| **Frequency** | Real-time |
| **Owner** | Emergency Response Coordinator |

```sql
SELECT 
    severity,
    COUNT(*) AS open_alerts
FROM maternal_alerts 
WHERE status = 'OPEN'
GROUP BY severity
ORDER BY DECODE(severity, 'RED', 1, 'ORANGE', 2, 'YELLOW', 3);
```

---

### KPI-004: Alert Response Time
| Attribute | Value |
|-----------|-------|
| **Definition** | Average time from alert creation to acknowledgment |
| **Formula** | AVG(acknowledged_at - created_at) |
| **Target** | RED: <30 min, ORANGE: <2 hrs, YELLOW: <24 hrs |
| **Frequency** | Daily |
| **Owner** | Emergency Response Coordinator |

```sql
SELECT 
    severity,
    ROUND(AVG((acknowledged_at - created_at) * 24 * 60), 2) AS avg_response_minutes
FROM maternal_alerts 
WHERE acknowledged_at IS NOT NULL
GROUP BY severity;
```

---

## 3. Operational KPIs

### KPI-005: CHW Caseload
| Attribute | Value |
|-----------|-------|
| **Definition** | Number of active pregnancies per CHW |
| **Formula** | Active pregnancies / Active CHWs |
| **Target** | 15-25 cases per CHW |
| **Frequency** | Weekly |
| **Owner** | CHW Supervisor |

```sql
SELECT 
    c.chw_id,
    c.first_name || ' ' || c.last_name AS chw_name,
    COUNT(p.pregnancy_id) AS active_cases
FROM community_health_workers c
LEFT JOIN pregnancies p ON c.chw_id = p.assigned_chw_id AND p.status = 'ACTIVE'
WHERE c.status = 'ACTIVE'
GROUP BY c.chw_id, c.first_name, c.last_name
ORDER BY active_cases DESC;
```

---

### KPI-006: ANC Visit Completion Rate
| Attribute | Value |
|-----------|-------|
| **Definition** | Percentage of scheduled ANC visits completed on time |
| **Formula** | (Completed visits / Scheduled visits) × 100 |
| **Target** | >85% |
| **Frequency** | Monthly |
| **Owner** | Maternal Health Coordinator |

```sql
SELECT 
    ROUND(SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) 
    AS completion_rate
FROM anc_schedule
WHERE scheduled_date <= SYSDATE;
```

---

### KPI-007: Ambulance Availability
| Attribute | Value |
|-----------|-------|
| **Definition** | Percentage of ambulances available for dispatch |
| **Formula** | (Available ambulances / Total ambulances) × 100 |
| **Target** | >60% |
| **Frequency** | Real-time |
| **Owner** | Fleet Manager |

```sql
SELECT 
    ROUND(SUM(CASE WHEN status = 'AVAILABLE' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) 
    AS availability_rate
FROM ambulances;
```

---

### KPI-008: Referral Completion Rate
| Attribute | Value |
|-----------|-------|
| **Definition** | Percentage of referrals successfully completed |
| **Formula** | (Completed referrals / Total referrals) × 100 |
| **Target** | >95% |
| **Frequency** | Weekly |
| **Owner** | Referral Coordinator |

```sql
SELECT 
    ROUND(SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) 
    AS completion_rate
FROM referrals;
```

---

## 4. Quality KPIs

### KPI-009: Data Entry Timeliness
| Attribute | Value |
|-----------|-------|
| **Definition** | Percentage of vital signs entered within 24 hours of recording |
| **Formula** | (Timely entries / Total entries) × 100 |
| **Target** | >95% |
| **Frequency** | Daily |
| **Owner** | Data Quality Manager |

```sql
SELECT 
    ROUND(SUM(CASE WHEN (created_at - recorded_at) < 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) 
    AS timeliness_rate
FROM maternal_vitals;
```

---

### KPI-010: Risk Score Accuracy
| Attribute | Value |
|-----------|-------|
| **Definition** | Correlation between calculated risk scores and actual outcomes |
| **Formula** | Manual validation required |
| **Target** | >90% accuracy |
| **Frequency** | Quarterly |
| **Owner** | Clinical Quality Team |

---

## 5. Audit KPIs

### KPI-011: DML Restriction Compliance
| Attribute | Value |
|-----------|-------|
| **Definition** | Number of blocked DML attempts on restricted days |
| **Formula** | `COUNT(*) FROM audit_log WHERE status = 'DENIED'` |
| **Target** | 100% enforcement |
| **Frequency** | Daily |
| **Owner** | System Administrator |

```sql
SELECT 
    TRUNC(change_timestamp) AS date,
    COUNT(*) AS denied_operations
FROM audit_log 
WHERE status = 'DENIED'
GROUP BY TRUNC(change_timestamp)
ORDER BY date DESC;
```

---

### KPI-012: System Activity Volume
| Attribute | Value |
|-----------|-------|
| **Definition** | Total number of database operations logged |
| **Formula** | `COUNT(*) FROM audit_log` |
| **Target** | N/A (Volume indicator) |
| **Frequency** | Daily |
| **Owner** | Database Administrator |

```sql
SELECT 
    table_name,
    operation,
    COUNT(*) AS operation_count
FROM audit_log
GROUP BY table_name, operation
ORDER BY operation_count DESC;
```

---

## 6. KPI Dashboard Summary

| KPI | Current | Target | Status |
|-----|---------|--------|--------|
| Active Pregnancies | 50 | - | 📊 |
| High-Risk Rate | 12% | <15% | ✅ |
| Open RED Alerts | 0 | 0 | ✅ |
| Open ORANGE Alerts | 3 | <5 | ✅ |
| CHW Avg Caseload | 2.5 | 15-25 | ⚠️ |
| ANC Completion | 88% | >85% | ✅ |
| Ambulance Available | 80% | >60% | ✅ |
| Referral Completion | 100% | >95% | ✅ |

---

*Document Version: 1.0 | Last Updated: December 2025*
