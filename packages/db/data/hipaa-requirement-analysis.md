# HIPAA Requirement to Control Template Mapping Analysis

**Generated:** 2025-11-06
**Status:** Phase 1 - Requirement Analysis
**Total HIPAA Requirements:** 77
**Currently Mapped:** 33
**Unmapped:** 44

## Executive Summary

This document provides a comprehensive analysis of all 77 HIPAA Security Rule requirements and maps them to needed control templates. Currently, only 11 control templates exist and ALL are cross-framework (HIPAA + ISO 27001 + SOC 2), leaving 44 requirements with no control template mappings.

## Current Control Template Coverage

### Existing Controls (11 total - ALL cross-framework)

| Control Template | HIPAA Reqs | Total Reqs | Frameworks |
|---|---|---|---|
| Access Rights | 6 | 13 | HIPAA, ISO 27001, SOC 2 |
| Asset Inventory | 2 | 7 | HIPAA, ISO 27001, SOC 2 |
| Change Management | 1 | 9 | HIPAA, ISO 27001, SOC 2 |
| Credential Management | 3 | 6 | HIPAA, ISO 27001, SOC 2 |
| Disaster Recovery Planning | 4 | 9 | HIPAA, ISO 27001, SOC 2 |
| Encryption Key Management | 2 | 6 | HIPAA, ISO 27001, SOC 2 |
| Endpoint Protection | 4 | 10 | HIPAA, ISO 27001, SOC 2 |
| Policy Compliance | 3 | 14 | HIPAA, ISO 27001, SOC 2 |
| Secure Data Transfer | 3 | 9 | HIPAA, ISO 27001, SOC 2 |
| Security Incident Management | 2 | 8 | HIPAA, ISO 27001, SOC 2 |
| Security Monitoring & Detection | 3 | 10 | HIPAA, ISO 27001, SOC 2 |

**Total Coverage:** 33 of 77 requirements (42.9%)

## Required New Control Templates

### Priority 1: HIPAA-Exclusive Administrative Safeguards

#### 1. Business Associate Agreements (BAA) Management
**Type:** HIPAA-Only
**Requirement Count:** 8
**Requirements:**
- 164.308(b.1) - Business associate contracts and other arrangements
- 164.308(b.2) - Subcontractor business associate arrangements
- 164.308(b.3) - Written contract or other arrangement (Required)
- 164.314(a.1) - Business associate contracts standard
- 164.314(a.2.i) - Business associate contracts (Required)
- 164.314(a.2.ii) - Other arrangements
- 164.314(a.2.iii) - Business associate contracts with subcontractors
- 164.314(b.1) - Group health plan requirements

**Control Description:** Implement policies and procedures for establishing, maintaining, and monitoring Business Associate Agreements (BAAs) to ensure third parties handling PHI comply with HIPAA Security Rule requirements.

**Rationale for HIPAA-Only:** BAAs are a unique HIPAA concept related to Protected Health Information (PHI). No equivalent exists in SOC 2 or ISO 27001.

---

#### 2. HIPAA Security Officer & Assigned Responsibility
**Type:** HIPAA-Only
**Requirement Count:** 1
**Requirements:**
- 164.308(a.2) - Assigned security responsibility (Required)

**Control Description:** Designate a HIPAA Security Officer responsible for developing and implementing security policies and procedures required by the HIPAA Security Rule.

**Rationale for HIPAA-Only:** While similar roles exist in other frameworks (ISO 27001 has Information Security Manager), HIPAA specifically requires a designated "security official" with defined responsibilities for PHI protection.

---

#### 3. HIPAA Security Awareness & Workforce Training
**Type:** HIPAA-Only
**Requirement Count:** 5
**Requirements:**
- 164.308(a.5.i) - Security awareness and training standard
- 164.308(a.5.ii.A) - Security reminders (Addressable)
- 164.308(a.5.ii.B) - Protection from malicious software (Addressable)
- 164.308(a.5.ii.C) - Log-in monitoring (Addressable)
- 164.308(a.5.ii.D) - Password management (Addressable)

**Control Description:** Implement a security awareness and training program for all workforce members, including periodic security reminders, malware protection training, login monitoring awareness, and password management best practices.

**Rationale for HIPAA-Only:** While security awareness exists in other frameworks, HIPAA has specific requirements for workforce training on PHI protection, patient privacy, and healthcare-specific threat vectors.

---

#### 4. Workforce Security & Sanction Policy
**Type:** HIPAA-Only
**Requirement Count:** 6
**Requirements:**
- 164.308(a.3.i) - Workforce security standard
- 164.308(a.3.ii.A) - Authorization and/or supervision (Addressable)
- 164.308(a.3.ii.B) - Workforce clearance procedure (Addressable)
- 164.308(a.3.ii.C) - Termination procedures (Required)
- 164.308(a.1.ii.C) - Sanction policy (Required)
- 164.306(a.4) - Ensure compliance with this subpart by its workforce

**Control Description:** Implement procedures for workforce authorization, supervision, clearance, and termination. Apply appropriate sanctions against workforce members who fail to comply with security policies.

**Rationale for HIPAA-Only:** HIPAA requires specific workforce procedures related to PHI access, including formal sanction policies for violations.

---

#### 5. PHI Access Logs & Audit Controls
**Type:** HIPAA-Specific (could be cross-framework but PHI-focused)
**Requirement Count:** 3
**Requirements:**
- 164.312(b) - Audit controls standard (Required)
- 164.308(a.1.ii.D) - Information system activity review (Required)
- 164.312(d) - Person or entity authentication (Required)

**Control Description:** Implement hardware, software, and procedural mechanisms that record and examine activity in information systems containing ePHI. Review logs regularly to detect security incidents.

**Rationale for HIPAA-Specific:** While similar to "Security Monitoring & Detection," this control focuses specifically on PHI access audit trails and authentication required by HIPAA.

---

#### 6. HIPAA Security Evaluation & Risk Assessment
**Type:** HIPAA-Specific
**Requirement Count:** 4
**Requirements:**
- 164.308(a.8) - Evaluation standard (Required)
- 164.308(a.1.ii.A) - Risk analysis (Required)
- 164.308(a.1.ii.B) - Risk management (Required)
- 164.308(a.1.i) - Security management process

**Control Description:** Perform periodic technical and non-technical evaluations of security controls. Conduct risk analysis and implement risk management procedures specific to ePHI protection.

**Rationale for HIPAA-Specific:** While overlaps with existing "Policy Compliance," HIPAA requires specific evaluations of ePHI safeguards and environmental/operational changes.

---

#### 7. Physical Facility Access Controls for ePHI
**Type:** HIPAA-Specific
**Requirement Count:** 6
**Requirements:**
- 164.310(a.1) - Facility access controls standard
- 164.310(a.2.i) - Contingency operations (Addressable)
- 164.310(a.2.ii) - Facility security plan (Addressable)
- 164.310(a.2.iii) - Access control and validation procedures (Addressable)
- 164.310(a.2.iv) - Maintenance records (Addressable)
- 164.310(b) - Workstation use standard

**Control Description:** Limit physical access to electronic information systems and facilities housing ePHI. Implement facility security plan, access validation, and workstation use policies.

**Rationale for HIPAA-Specific:** HIPAA has specific requirements for physical safeguards protecting ePHI systems, including workstation use and location.

---

#### 8. Workstation & Device Security for ePHI
**Type:** HIPAA-Specific
**Requirement Count:** 2
**Requirements:**
- 164.310(c) - Workstation security standard
- 164.310(d.1) - Device and media controls standard

**Control Description:** Implement physical safeguards for workstations that access ePHI. Establish policies for receipt, removal, and disposal of hardware and electronic media containing ePHI.

**Rationale for HIPAA-Specific:** While overlaps with "Endpoint Protection," HIPAA requires specific physical safeguards for devices accessing PHI.

---

#### 9. ePHI Data Backup & Media Management
**Type:** HIPAA-Specific
**Requirement Count:** 4
**Requirements:**
- 164.308(a.7.i) - Contingency plan standard
- 164.308(a.7.ii.A) - Data backup plan (Required)
- 164.310(d.2.i) - Disposal (Required)
- 164.310(d.2.iv) - Data backup and storage (Addressable)

**Control Description:** Create and maintain retrievable exact copies of ePHI. Implement procedures for secure disposal of ePHI and media. Establish contingency plans for ePHI availability.

**Rationale for HIPAA-Specific:** While "Disaster Recovery Planning" exists, HIPAA has specific requirements for ePHI backup and media disposal.

---

#### 10. Emergency Mode Operations & ePHI Availability
**Type:** HIPAA-Specific
**Requirement Count:** 3
**Requirements:**
- 164.308(a.7.ii.B) - Disaster recovery plan (Required)
- 164.308(a.7.ii.C) - Emergency mode operation plan (Required)
- 164.308(a.7.ii.E) - Applications and data criticality analysis (Addressable)

**Control Description:** Establish procedures to enable continuation of critical business processes for protection of ePHI during and after emergency situations.

**Rationale for HIPAA-Specific:** HIPAA requires specific emergency mode operations for ePHI access during disasters.

---

#### 11. ePHI Integrity Controls
**Type:** HIPAA-Specific
**Requirement Count:** 2
**Requirements:**
- 164.312(c.1) - Integrity standard
- 164.312(e.2.i) - Integrity controls (Addressable)

**Control Description:** Implement policies and procedures to protect ePHI from improper alteration or destruction. Ensure transmitted ePHI is not improperly modified without detection.

**Rationale for HIPAA-Specific:** HIPAA requires specific integrity controls for ePHI both at rest and in transit.

---

#### 12. Unique User Identification for ePHI Access
**Type:** Cross-framework (but map to HIPAA reqs)
**Requirement Count:** 1
**Requirements:**
- 164.312(a.2.i) - Unique user identification (Required)

**Control Description:** Assign unique identifiers for tracking user access to ePHI systems.

**Rationale:** Can leverage existing "Access Rights" or "Credential Management" controls.

---

#### 13. Emergency Access Procedures for ePHI
**Type:** HIPAA-Specific
**Requirement Count:** 2
**Requirements:**
- 164.312(a.2.ii) - Emergency access procedure (Required)
- 164.308(a.4.i) - Information access management standard

**Control Description:** Establish procedures for obtaining ePHI during emergencies. Implement policies for authorizing access to ePHI.

**Rationale for HIPAA-Specific:** HIPAA requires specific emergency access procedures to ensure patient care continuity.

---

#### 14. Automatic Session Logoff for ePHI Systems
**Type:** HIPAA-Specific
**Requirement Count:** 1
**Requirements:**
- 164.312(a.2.iii) - Automatic logoff (Addressable)

**Control Description:** Terminate electronic sessions after predetermined period of inactivity.

**Rationale for HIPAA-Specific:** HIPAA requires automatic logoff for systems accessing ePHI to prevent unauthorized access.

---

#### 15. ePHI Encryption & Decryption
**Type:** Cross-framework (but map to HIPAA reqs)
**Requirement Count:** 2
**Requirements:**
- 164.312(a.2.iv) - Encryption and decryption (Addressable)
- 164.312(e.2.ii) - Encryption (Addressable)

**Control Description:** Implement mechanisms to encrypt and decrypt ePHI at rest and in transit.

**Rationale:** Can leverage existing "Encryption Key Management" and "Secure Data Transfer" controls.

---

#### 16. Access Authorization & Isolation for ePHI
**Type:** HIPAA-Specific
**Requirement Count:** 4
**Requirements:**
- 164.308(a.4.ii.B) - Access authorization (Addressable)
- 164.308(a.4.ii.C) - Access establishment and modification (Addressable)
- 164.312(a.1) - Access control standard
- 164.308(a.3.ii.B) - Workforce clearance procedure (Addressable)

**Control Description:** Implement procedures to determine appropriate ePHI access levels, grant access, and modify access as job responsibilities change.

**Rationale for HIPAA-Specific:** HIPAA requires specific access authorization procedures based on workforce roles and ePHI sensitivity.

---

#### 17. Security Incident Response & Breach Notification
**Type:** HIPAA-Only
**Requirement Count:** 3
**Requirements:**
- 164.308(a.6.i) - Security incident procedures standard
- 164.308(a.6.ii) - Response and reporting (Required)
- 164.314(a.2.i.C) - Report security incidents to covered entity

**Control Description:** Implement policies and procedures to address security incidents, including identification, response, reporting, and breach notification as required by HIPAA Breach Notification Rule.

**Rationale for HIPAA-Only:** While "Security Incident Management" exists, HIPAA has specific breach notification requirements for PHI incidents.

---

#### 18. Testing & Revision of Contingency Plans
**Type:** HIPAA-Specific
**Requirement Count:** 1
**Requirements:**
- 164.308(a.7.ii.D) - Testing and revision procedures (Addressable)

**Control Description:** Implement procedures for periodic testing and revision of contingency plans.

**Rationale for HIPAA-Specific:** HIPAA requires specific testing of ePHI contingency procedures.

---

#### 19. Group Health Plan Document Requirements
**Type:** HIPAA-Only
**Requirement Count:** 1
**Requirements:**
- 164.314(b.2) - Implementation specifications for group health plans (Required)

**Control Description:** Amend plan documents to require plan sponsors to implement safeguards for ePHI and report security incidents.

**Rationale for HIPAA-Only:** Applies only to group health plans - highly specific to HIPAA/healthcare context.

---

#### 20. Addressable Implementation Specifications
**Type:** HIPAA-Only
**Requirement Count:** 2
**Requirements:**
- 164.306(d.3) - Addressable implementation specifications
- 164.306(d.3.ii.A-C) - Addressable specification assessment requirements

**Control Description:** Document assessment of addressable specifications and implementation decisions.

**Rationale for HIPAA-Only:** HIPAA's "addressable" vs "required" specification framework is unique to this regulation.

---

## Implementation Priority

### Tier 1 (Critical - Start Immediately)
1. Business Associate Agreements (BAA) Management - 8 requirements
2. HIPAA Security Awareness & Workforce Training - 5 requirements
3. Workforce Security & Sanction Policy - 6 requirements
4. PHI Access Logs & Audit Controls - 3 requirements

**Tier 1 Total:** 22 requirements

### Tier 2 (High Priority)
5. HIPAA Security Officer & Assigned Responsibility - 1 requirement
6. HIPAA Security Evaluation & Risk Assessment - 4 requirements
7. Physical Facility Access Controls for ePHI - 6 requirements
8. Security Incident Response & Breach Notification - 3 requirements

**Tier 2 Total:** 14 requirements

### Tier 3 (Medium Priority)
9. Workstation & Device Security for ePHI - 2 requirements
10. ePHI Data Backup & Media Management - 4 requirements
11. Emergency Mode Operations & ePHI Availability - 3 requirements
12. ePHI Integrity Controls - 2 requirements

**Tier 3 Total:** 11 requirements

### Tier 4 (Lower Priority - Enhance Existing)
13. Emergency Access Procedures for ePHI - 2 requirements (can map to existing)
14. Automatic Session Logoff for ePHI Systems - 1 requirement
15. Access Authorization & Isolation for ePHI - 4 requirements (overlap with Access Rights)

**Tier 4 Total:** 7 requirements

### Tier 5 (Administrative)
19. Group Health Plan Document Requirements - 1 requirement
20. Addressable Implementation Specifications - 2 requirements

**Tier 5 Total:** 3 requirements

---

## Summary Statistics

- **Total New Controls Needed:** 20
- **HIPAA-Only Controls:** 8
- **HIPAA-Specific Controls:** 10
- **Cross-Framework (map to existing):** 2
- **Total Requirements to Map:** 44 unmapped + improve coverage for 33 mapped = 77 total

## Next Steps

1. ✅ **Phase 1 Complete:** Requirement analysis and control mapping
2. **Phase 2:** Create control template records in database (start with Tier 1)
3. **Phase 3:** Create policy and task templates for each control
4. **Phase 4:** Test framework initialization with HIPAA-only organization
5. **Phase 5:** Document compliance matrix and coverage
