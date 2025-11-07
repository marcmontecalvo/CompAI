# ePHI Backup, Recovery, and Media Management

**Policy Type**: HIPAA Security Policy
**Frequency**: Yearly Review
**Department**: IT
**Status**: ⚠️ NEEDS COMPLIANCE WRITER

---

## Coverage

This policy consolidates requirements for the following HIPAA Security Rule controls:
- **Control 8**: ePHI Data Backup & Media Management
- **Control 9**: Emergency Mode Operations & ePHI Availability
- **Control 11**: Disaster Recovery Planning
- **Control 16**: Contingency Plan Testing & Revision

---

## Purpose

**[POLICY CONTENT TO BE COMPLETED BY COMPLIANCE WRITER]**

This policy should establish comprehensive backup, recovery, and business continuity procedures including:
- Data backup procedures for all ePHI systems
- Backup frequency and retention requirements
- Backup testing and restoration procedures
- Secure backup storage and encryption
- Disaster recovery planning and capabilities
- Emergency mode operations for ePHI availability
- Contingency plan testing and updates
- Media management throughout lifecycle

---

## Scope

**[TO BE COMPLETED]**

Should apply to:
- All systems containing ePHI (databases, applications, file storage)
- Production and non-production environments with ePHI
- Cloud and on-premises infrastructure
- Critical business applications dependent on ePHI
- Backup media and storage systems
- Disaster recovery and business continuity processes

---

## Policy Statements

**[TO BE COMPLETED - See guidance below]**

### Required Sections:

#### 1. ePHI Data Backup Requirements
- Backup frequency (daily incremental, weekly full recommended minimum)
- Systems requiring backup (all ePHI databases, applications, file storage)
- Backup retention periods (daily for 30 days, weekly for 6 months, monthly for 7 years)
- Backup technology standards (snapshots, replication, tape, cloud)
- Backup encryption requirements (AES-256)
- Off-site or geo-redundant backup storage
- Backup monitoring and alerting

#### 2. Backup Testing and Restoration
- Monthly backup verification (automated checksums)
- Monthly restoration tests (sample data)
- Quarterly full restoration tests (test environment)
- Annual disaster recovery test (comprehensive)
- Restoration time objectives (RTO)
- Recovery point objectives (RPO)
- Documentation of test results

#### 3. Disaster Recovery Planning
- Disaster scenarios (fire, flood, ransomware, system failure)
- Recovery strategies (failover, restore from backup, alternate site)
- RTO targets per system criticality (critical: 4 hours, high: 24 hours, medium: 72 hours)
- RPO targets (critical: 1 hour, high: 24 hours, medium: 7 days)
- Disaster recovery site or cloud region
- Disaster recovery procedures and runbooks
- Communication plans during disasters

#### 4. Emergency Mode Operations
- Critical ePHI systems identification
- Minimum required ePHI for emergency operations
- Emergency access procedures
- Downtime procedures (manual processes, temporary systems)
- Transition back to normal operations
- Emergency mode testing

#### 5. Business Continuity Planning
- Business impact analysis (identify critical ePHI-dependent processes)
- Maximum tolerable downtime by process
- Alternate work locations and facilities
- Emergency staffing and roles
- Vendor dependencies and SLAs
- Supply chain continuity

#### 6. Contingency Plan Testing and Revision
- Annual disaster recovery tabletop exercises
- Annual full disaster recovery test
- Contingency plan walkthrough with key personnel
- Test scenario design and execution
- Lessons learned and plan updates
- Testing following significant changes (environmental, operational, technology)

#### 7. Media Management
- Media inventory and tracking (tapes, drives, USB devices)
- Secure storage of backup media
- Media rotation and retention
- Media transportation security (encrypted, couriered)
- Media disposal and sanitization
- Media reuse procedures

#### 8. Cloud Backup and Recovery
- Cloud backup service provider selection (BAA required)
- Cloud storage encryption (provider and customer-managed keys)
- Geographic redundancy and replication
- Cloud-to-cloud backup (if primary is cloud)
- Vendor lock-in mitigation
- Data retrieval procedures and costs

---

## Responsibilities

**[TO BE COMPLETED]**

Should define roles for:
- IT Operations Team (backup execution, monitoring, restoration)
- System Administrators (backup configuration, testing)
- HIPAA Security Officer (contingency plan oversight, testing coordination)
- Business Continuity Manager (DR planning, BCP, tabletop exercises)
- Application Owners (RTO/RPO requirements, emergency procedures)
- Executive Leadership (declaration of disaster, emergency authorization)

---

## Procedures

**[TO BE COMPLETED]**

Should include detailed procedures for:

### Daily Backup Procedure
1. Automated backup execution (nightly)
2. Backup completion verification
3. Backup integrity check (checksums)
4. Off-site replication or transfer
5. Backup monitoring alert review
6. Failed backup investigation and retry
7. Documentation in backup log

### Monthly Backup Restoration Test
1. Select random ePHI system and data set
2. Initiate restoration to test environment
3. Validate data integrity after restore
4. Compare checksums with original
5. Document restoration time (measure RTO)
6. Document test results and pass/fail
7. Remediate any failures identified

### Annual Disaster Recovery Test
1. Define disaster scenario (e.g., data center failure)
2. Assemble DR team and stakeholders
3. Activate disaster recovery procedures
4. Failover to DR site or restore from backup
5. Validate ePHI system availability and integrity
6. Measure actual RTO/RPO achieved
7. Document test results and gaps
8. Update DR plan based on findings

### Disaster Declaration and Activation
1. Incident assessment (scope, impact, duration estimate)
2. Disaster declaration by executive leadership
3. DR team notification and assembly
4. Communication to workforce and stakeholders
5. Execute disaster recovery procedures
6. ePHI system restoration or failover
7. Emergency mode operations if needed
8. Return to normal operations
9. Post-incident review and lessons learned

### Media Disposal Procedure
1. Identify media for disposal (expired retention, end of life)
2. Remove media from service
3. Wipe media using approved method (DoD 5220.22-M)
4. Physical destruction if wiping not possible (shred, crush, incinerate)
5. Certificate of destruction obtained
6. Update media inventory
7. Disposal documentation retained (6 years)

---

## Recovery Objectives

**[TO BE COMPLETED]**

Example RTO/RPO matrix:

| System Criticality | RTO (Recovery Time) | RPO (Data Loss) | Backup Frequency |
|--------------------|---------------------|-----------------|------------------|
| Critical (EHR, core ePHI systems) | 4 hours | 1 hour | Continuous replication + hourly snapshots |
| High (scheduling, billing) | 24 hours | 4 hours | Hourly snapshots |
| Medium (reporting, analytics) | 72 hours | 24 hours | Daily backups |
| Low (test environments) | 1 week | 1 week | Weekly backups |

---

## Related Policies

{{#if hipaa}}
- HIPAA Security Management Program
- ePHI Technical Safeguards and Data Integrity
- Security Incident Response & HIPAA Breach Notification
- Physical and Environmental Security for ePHI (environmental controls)
{{/if}}

{{#if soc2}}
- Backup, Business Continuity & Disaster Recovery
- Retention & Secure Disposal
{{/if}}

---

## References

- 45 CFR § 164.308(a)(7)(i) - Contingency Plan (Required)
- 45 CFR § 164.308(a)(7)(ii)(A) - Data Backup Plan (Required)
- 45 CFR § 164.308(a)(7)(ii)(B) - Disaster Recovery Plan (Required)
- 45 CFR § 164.308(a)(7)(ii)(C) - Emergency Mode Operation Plan (Required)
- 45 CFR § 164.308(a)(7)(ii)(D) - Testing and Revision Procedures (Addressable)
- 45 CFR § 164.308(a)(7)(ii)(E) - Applications and Data Criticality Analysis (Addressable)
- 45 CFR § 164.310(d)(2)(iv) - Data Backup and Storage (Addressable)
- NIST SP 800-34 - Contingency Planning Guide for Federal Information Systems

---

## Document Control

- **Policy Owner**: Chief Technology Officer / HIPAA Security Officer
- **Review Frequency**: Annually or after significant incidents
- **Next Review Date**: [To be set upon adoption]
- **Content Status**: **⚠️ REQUIRES COMPLIANCE WRITER COMPLETION**
- **Revision History**:
  - v0.1 - Template structure created
  - [To be updated when content completed]

---

## Approval

**[TO BE COMPLETED AFTER CONTENT FINALIZATION]**

- [ ] Chief Technology Officer
- [ ] HIPAA Security Officer
- [ ] Business Continuity Manager
- [ ] Chief Information Security Officer
- [ ] Chief Executive Officer

**Effective Date**: _________________

**Last Updated**: _________________

---

## Notes for Compliance Writer

Backup and disaster recovery are Required Implementation Specifications under HIPAA. Key considerations:

1. **3-2-1 Rule**: Best practice - 3 copies of data, 2 different media types, 1 off-site copy
2. **RTO/RPO**: Define realistic targets based on business impact analysis; test to validate achievability
3. **Ransomware**: Immutable backups or air-gapped backups critical for ransomware recovery
4. **Testing**: Annual testing is Addressable but industry best practice is quarterly at minimum
5. **Cloud Considerations**: If using cloud backups, ensure BAA with provider and understand data retrieval costs
6. **Dependencies**: Map application dependencies to ensure recovery order is correct
7. **Communication Plans**: DR plans must include communication procedures (workforce, patients, partners)
8. **Post-Disaster**: Plan for transition back to normal operations, not just the disaster response

Coordinate with Business Continuity Manager (if separate from IT) and application owners to ensure comprehensive coverage.
