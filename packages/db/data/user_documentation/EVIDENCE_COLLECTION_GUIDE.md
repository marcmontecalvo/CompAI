# Evidence Collection Guide

## Purpose

This guide explains how to collect, organize, and maintain evidence demonstrating HIPAA Security Rule compliance for audit readiness.

---

## Evidence Requirements by Control Category

### Business Associate Management
**Controls**: BAA Management
**Evidence Required**:
- [ ] Current BAA inventory (Excel or database)
- [ ] Signed BAA documents for all business associates
- [ ] BAA renewal tracking log
- [ ] Subcontractor BAA documentation
- [ ] Vendor security assessment results

**Collection Frequency**: Quarterly
**Retention**: 6 years after BAA termination

### Workforce Security & Training
**Controls**: Training, Workforce Security, Access Management, Sanctions
**Evidence Required**:
- [ ] Training completion certificates (all workforce)
- [ ] LMS reports showing 100% completion
- [ ] New hire training log (completion within 30 days)
- [ ] Training materials and curriculum
- [ ] Background check records
- [ ] Access provisioning requests with approvals
- [ ] Quarterly access recertification attestations
- [ ] Termination checklists with access revocation dates
- [ ] Sanction records (if any violations occurred)

**Collection Frequency**: Monthly (training), Quarterly (access), As-needed (sanctions)
**Retention**: 6 years

### ePHI Technical Safeguards
**Controls**: Encryption, Access Controls, Authentication, Session Management
**Evidence Required**:
- [ ] Encryption status reports (devices, databases, transmission)
- [ ] TLS configuration scan results
- [ ] Certificate validity reports
- [ ] MFA enrollment reports
- [ ] Password policy configuration screenshots
- [ ] Session timeout configuration proof
- [ ] MDM compliance reports
- [ ] User access lists with RBAC roles

**Collection Frequency**: Quarterly
**Retention**: 6 years

### Audit & Monitoring
**Controls**: Audit Logging, Integrity Verification, Security Monitoring
**Evidence Required**:
- [ ] Audit log retention confirmation (6 years)
- [ ] Monthly log review reports
- [ ] SIEM dashboard screenshots
- [ ] Anomaly investigation notes
- [ ] Integrity check results (checksums, hashes)
- [ ] Security alert logs

**Collection Frequency**: Monthly
**Retention**: 6 years minimum for logs; reports can match policy retention

### Physical Security
**Controls**: Facility Access, Workstation Security, Device/Media Controls
**Evidence Required**:
- [ ] Badge access logs for ePHI areas
- [ ] Video surveillance confirmation (retention period)
- [ ] Visitor logs
- [ ] Physical security audit reports
- [ ] Workstation security photos (screen placement, privacy)
- [ ] Device inventory with encryption status
- [ ] Media disposal certificates of destruction

**Collection Frequency**: Quarterly
**Retention**: 6 years (certificates), 90 days (badge/visitor logs typically)

### Business Continuity
**Controls**: Backup, DR, Contingency Planning
**Evidence Required**:
- [ ] Backup success logs (daily/weekly/monthly)
- [ ] Restoration test results (monthly samples)
- [ ] Disaster recovery test report (annual)
- [ ] Tabletop exercise attendance and scenarios
- [ ] RTO/RPO measurement data
- [ ] Contingency plan version control history
- [ ] DR plan test results and lessons learned

**Collection Frequency**: Monthly (backups), Annually (DR test)
**Retention**: 6 years

### Incident Response & Breach
**Controls**: Security Incident Procedures, Breach Notification
**Evidence Required**:
- [ ] Incident log (all incidents, breach and non-breach)
- [ ] Incident investigation reports
- [ ] Breach determination documentation (4-part test)
- [ ] Breach notification records (who, when, how)
- [ ] HHS breach portal submission confirmation
- [ ] Post-incident review and lessons learned

**Collection Frequency**: As incidents occur
**Retention**: 6 years minimum

### Risk Management
**Controls**: Risk Assessment, Addressable Specifications, Evaluation
**Evidence Required**:
- [ ] Annual risk assessment report
- [ ] Risk register with current risks
- [ ] Risk mitigation plans
- [ ] Evaluation reports (annual or after significant changes)
- [ ] Addressable specification matrix with decisions
- [ ] Risk acceptance documentation (for non-mitigated risks)

**Collection Frequency**: Annually
**Retention**: 6 years

---

## Evidence Collection Methods

### Automated Collection (Preferred)

**API Integrations** (See: [AI_EVIDENCE_COLLECTION_GUIDE.md](../AI_EVIDENCE_COLLECTION_GUIDE.md))
- LMS → Training completion reports
- MDM → Device encryption status
- SIEM → Access logs and anomalies
- Backup System → Backup success/failure logs
- Identity Provider → MFA enrollment, access lists

**Benefits**:
- Real-time or scheduled collection
- Eliminates manual work
- Reduces human error
- Provides continuous monitoring

### Manual Collection

**When to Use**:
- System doesn't have API
- One-time evidence (photos, attestations)
- External evidence (BAAs, certificates)

**Best Practices**:
- Use standardized templates
- Include date and source
- Digital format preferred (scan documents)
- Consistent naming convention

---

## Evidence Naming Convention

**Format**: `YYYY-MM-DD_ControlCategory_EvidenceType_Description.ext`

**Examples**:
- `2024-11-07_Training_LMS-Report_Q4-Completion.xlsx`
- `2024-11-07_BAA_Agreement_AWS-Signed.pdf`
- `2024-11-07_Backup_Test-Results_Monthly-Restore.pdf`
- `2024-11-07_Access_Manager-Attestation_HR-Team.pdf`
- `2024-11-07_Encryption_MDM-Compliance-Report.csv`

**Benefits**:
- Sortable by date
- Easy to find specific evidence
- Clear what it demonstrates
- Audit-ready organization

---

## Evidence Storage

### CompAI Evidence Library

**Primary Storage**: Upload evidence to controls/tasks in CompAI

**Organization**:
```
Evidence Library
├── Business Associate Management
│   ├── 2024-Q4-BAA-Inventory.xlsx
│   ├── 2024-11-01-AWS-BAA-Signed.pdf
│   └── 2024-11-01-Vendor-Assessment.pdf
├── Workforce Security
│   ├── 2024-Q4-Training-Completion.pdf
│   ├── 2024-Q4-Access-Recertification.xlsx
│   └── 2024-11-05-Termination-Checklist-JDoe.pdf
├── Technical Safeguards
│   ├── 2024-Q4-Encryption-Report.pdf
│   ├── 2024-Q4-MFA-Enrollment.xlsx
│   └── 2024-11-01-Certificate-Scan.pdf
└── Audit Logs
    ├── 2024-11-Access-Log-Review.pdf
    ├── 2024-11-Backup-Logs.csv
    └── 2024-11-Anomaly-Investigation.docx
```

### Secondary/Backup Storage

**Requirements**:
- Encrypted at rest
- Access controls (compliance team only)
- Backed up regularly
- Searchable

**Options**:
- SharePoint/OneDrive with restricted access
- Google Drive with encryption
- AWS S3 with encryption and lifecycle policies
- Dedicated compliance software (Vanta, Drata, etc.)

---

## Evidence Quality Standards

### Good Evidence Characteristics
✅ **Complete**: Covers entire period or scope
✅ **Accurate**: No errors or inconsistencies
✅ **Timely**: Collected near time of activity
✅ **Authentic**: From authoritative source
✅ **Clear**: Easy to understand what it demonstrates
✅ **Relevant**: Directly addresses control requirement

### Poor Evidence Examples
❌ Incomplete reports (missing dates or data)
❌ Screenshots without context (no URL, no date)
❌ Undated documents
❌ Handwritten notes without signature
❌ "Trust us" statements without supporting data
❌ Stale evidence (>1 year old for ongoing controls)

### Evidence Checklist
- [ ] Date visible
- [ ] Source system identified
- [ ] Covers required time period
- [ ] All fields/columns populated
- [ ] Signed or authenticated (if applicable)
- [ ] Linked to specific control or task
- [ ] Description added explaining what it demonstrates

---

## Audit Evidence Packages

### Preparing for Audit

When OCR or auditor requests documentation, create evidence packages:

**Package Structure**:
```
HIPAA-Audit-Response-YYYY-MM-DD/
├── 00-Cover-Letter.pdf
├── 01-Compliance-Matrix.xlsx
├── 02-Policies/
│   ├── All published policies (PDF)
│   └── Policy distribution records
├── 03-Training/
│   ├── Training completion reports
│   └── Training materials
├── 04-Risk-Assessment/
│   ├── Risk assessment report
│   └── Risk register
├── 05-BAAs/
│   ├── BAA inventory
│   └── Sample BAAs (or all if requested)
├── 06-Technical-Controls/
│   ├── Encryption reports
│   ├── Access control documentation
│   └── Audit log samples
├── 07-Physical-Security/
│   ├── Facility access reports
│   └── Physical security audit
├── 08-Business-Continuity/
│   ├── Backup logs
│   └── DR test results
└── 09-Incidents/
    └── Incident log (if any)
```

**Cover Letter Should Include**:
- Response to specific audit request items
- Index of provided evidence
- Contact information
- Attestation of completeness and accuracy

---

## Evidence Gaps and Remediation

### Identifying Gaps

**Regular Gap Analysis** (Quarterly):
1. Review each control
2. Check if evidence exists
3. Check if evidence is current
4. Check if evidence meets quality standards
5. Document any gaps

**Common Gaps**:
- No evidence for recently implemented control
- Evidence older than 1 year
- Incomplete log retention
- Missing signatures or approvals
- No test results for backup/DR

### Remediation Actions

**For Missing Evidence**:
1. Determine if activity actually occurred
2. If yes: Collect retroactive evidence (logs, attestations)
3. If no: Activity was never done - high risk, escalate immediately
4. Document gap and remediation plan
5. Set reminder to collect evidence next occurrence

**For Incomplete Evidence**:
1. Identify what's missing
2. Reach out to source system or personnel
3. Obtain missing elements
4. Replace incomplete evidence with complete version
5. Document remediation in compliance notes

**For Stale Evidence**:
1. Schedule collection of current evidence
2. Complete task/activity if not yet done
3. Upload new evidence
4. Archive old evidence (don't delete - 6 year retention)

---

## Retention and Disposal

### Retention Requirements

**HIPAA Requirement**: 6 years from creation date or date last in effect, whichever is later (45 CFR § 164.316(b)(2)(i))

**Examples**:
- Policy effective 2020-2025, updated 2025: Retain until 2031 (6 years from 2025)
- Training certificate dated 2024: Retain until 2030
- Risk assessment completed 2024: Retain until 2030

### Disposal Process

**After Retention Period Expires**:
1. Review for any ongoing legal holds
2. Confirm retention period (6 years) has passed
3. Securely delete or shred evidence
4. Document disposal date and method
5. Update evidence inventory

**Secure Disposal Methods**:
- Electronic: Secure deletion (overwrite), not just "delete"
- Paper: Cross-cut shredding (certificate of destruction)
- Media: Physical destruction or DoD-standard wiping

---

## Evidence Collection Calendar

### Monthly (Every Month)
- Access log review reports
- Backup test results
- Security monitoring reports

### Quarterly (Jan, Apr, Jul, Oct)
- BAA inventory
- Access recertification attestations
- Device encryption reports
- Physical security audit reports
- Integrity verification results
- Encryption compliance scans

### Semi-Annually (Jun, Dec)
- Policy review documentation

### Annually (Dec or as scheduled)
- Training completion certificates
- Risk assessment report
- DR test results
- Contingency plan test results
- Addressable specification matrix
- Framework evaluation report

---

## Tips for Efficient Evidence Collection

1. **Automate Where Possible**: See AI_EVIDENCE_COLLECTION_GUIDE.md for ~900 hours/year savings

2. **Collect as You Go**: Don't wait until audit - collect evidence when activity occurs

3. **Use Templates**: Standardized templates for reports, attestations, checklists

4. **Calendar Reminders**: Set recurring reminders for evidence collection

5. **Single Source of Truth**: One evidence repository, not scattered across systems

6. **Quality Over Quantity**: Better to have 3 high-quality pieces of evidence than 20 poor ones

7. **Cross-Reference**: Link evidence to multiple controls if applicable

8. **Document Exceptions**: If can't collect evidence, document why and alternative approach

---

*Last Updated: 2025-11-07*
*Version: 1.0*
*See also: AI_EVIDENCE_COLLECTION_GUIDE.md for automation opportunities*
