# HIPAA Audit Preparation Checklist

## OCR Audit Readiness Checklist

Use this checklist to prepare for HHS Office for Civil Rights (OCR) compliance audits or investigations.

---

## 30 Days Before Audit (If Advance Notice)

### Administrative Preparation

- [ ] **Designate Audit Point of Contact**
  - Primary contact (HIPAA Security Officer)
  - Backup contact
  - Provide contact info to OCR

- [ ] **Assemble Audit Response Team**
  - HIPAA Security Officer (lead)
  - Privacy Officer
  - IT Security Manager
  - Legal Counsel
  - Compliance Manager
  - Executive Sponsor

- [ ] **Schedule Audit Preparation Meetings**
  - Kickoff meeting with audit team
  - Daily standup during audit prep
  - Mock audit walkthrough
  - Final readiness review

- [ ] **Notify Key Stakeholders**
  - Executive leadership
  - Board of Directors
  - Department heads
  - Control owners

### Documentation Review

- [ ] **Review All HIPAA Policies**
  - Verify all 10 policies are current and published
  - Ensure no policies are outdated (>1 year since review)
  - Check all workforce acknowledgments are complete
  - Print PDF copies for audit package

- [ ] **Compile Evidence Repository**
  - Organize all evidence by control category
  - Verify evidence completeness (no gaps)
  - Check evidence currency (not stale)
  - Create index/inventory of all evidence

- [ ] **Update Compliance Matrix**
  - Export from CompAI: HIPAA_COMPLIANCE_MATRIX.csv
  - Verify 100% requirement coverage
  - Add evidence file references to matrix
  - Review for any unmapped requirements

---

## 14 Days Before Audit

### Documentation Preparation

- [ ] **Business Associate Agreements**
  - [ ] Current BAA inventory (Excel/CSV)
  - [ ] All signed BAA documents
  - [ ] Subcontractor BAA flow-down documentation
  - [ ] Vendor risk assessments (recent)
  - [ ] BAA renewal tracking (upcoming expirations)

- [ ] **Workforce Security & Training**
  - [ ] 100% training completion report (LMS export)
  - [ ] Training certificates (all workforce)
  - [ ] New hire training log (30-day completion)
  - [ ] Training materials and curriculum
  - [ ] Background check policy
  - [ ] Access provisioning/deprovisioning logs
  - [ ] Quarterly access recertification attestations
  - [ ] Termination checklists (samples)
  - [ ] Sanction records (if any violations)

- [ ] **Risk Assessment**
  - [ ] Most recent risk assessment report (within 12 months)
  - [ ] Risk register with current risks
  - [ ] Risk mitigation plans
  - [ ] Evaluation following significant changes
  - [ ] Addressable specification matrix with decisions

- [ ] **Technical Safeguards**
  - [ ] Encryption status reports (devices, databases, transmission)
  - [ ] TLS 1.2+ configuration proof
  - [ ] MFA enrollment report
  - [ ] Password policy configuration
  - [ ] Session timeout configuration
  - [ ] Unique user ID documentation (no shared accounts)
  - [ ] RBAC role definitions
  - [ ] Access control lists

- [ ] **Audit Logs**
  - [ ] 6-year log retention confirmation
  - [ ] Recent log review reports (last 6 months)
  - [ ] SIEM configuration documentation
  - [ ] Sample audit logs (ePHI access)
  - [ ] Anomaly investigation examples

- [ ] **Physical Security**
  - [ ] Badge access logs (last 90 days)
  - [ ] Visitor logs (last 90 days)
  - [ ] Physical security audit report (recent)
  - [ ] Workstation security documentation
  - [ ] Media disposal certificates
  - [ ] Facility photos (optional)

- [ ] **Business Continuity**
  - [ ] Backup success logs (last 6 months)
  - [ ] Restoration test results (monthly samples)
  - [ ] Annual DR test report
  - [ ] Contingency plan document
  - [ ] RTO/RPO targets and actual performance
  - [ ] Disaster recovery plan

- [ ] **Incident Response**
  - [ ] Incident response policy
  - [ ] Incident log (all incidents)
  - [ ] Breach determination documentation (if any)
  - [ ] Breach notifications (if any)
  - [ ] HHS breach portal confirmation (if applicable)

---

## 7 Days Before Audit

### Mock Audit

- [ ] **Conduct Internal Mock Audit**
  - Simulate OCR audit process
  - Review sample evidence with audit team
  - Identify documentation gaps
  - Practice audit interview responses
  - Time the document retrieval process

- [ ] **Gap Remediation**
  - Address any gaps identified in mock audit
  - Collect missing evidence
  - Update stale documentation
  - Complete any pending tasks

- [ ] **Prepare Audit Package**
  - Organize evidence in folder structure (see below)
  - Create cover letter/index
  - Burn to CD/DVD or package in secure file transfer
  - Print backup copies
  - Have legal counsel review

### Interview Preparation

- [ ] **Brief Key Personnel**
  - HIPAA Security Officer
  - Privacy Officer
  - IT Security Manager
  - Control owners (they may be interviewed)

- [ ] **Prepare Interview Talking Points**
  - Organization's commitment to HIPAA compliance
  - Compliance program structure
  - Key controls and safeguards
  - Continuous improvement efforts
  - Incident response capabilities

- [ ] **Review Common OCR Questions** (see below)

---

## Audit Package Structure

```
HIPAA-Audit-Response-[DATE]/
│
├── 00-INDEX-AND-COVER-LETTER.pdf
│   ├── Response cover letter
│   ├── Index of all provided documents
│   └── Contact information
│
├── 01-COMPLIANCE-MATRIX.xlsx
│   └── Requirement → Control → Evidence mapping
│
├── 02-POLICIES-AND-PROCEDURES/
│   ├── All 10 HIPAA policies (PDF)
│   ├── Policy approval records
│   └── Workforce acknowledgment reports
│
├── 03-WORKFORCE-SECURITY/
│   ├── Training/
│   │   ├── Training completion reports (100%)
│   │   ├── Training certificates (samples or all)
│   │   └── Training materials
│   ├── Access-Management/
│   │   ├── Access provisioning requests
│   │   ├── Quarterly recertification attestations
│   │   └── Termination checklists
│   └── Sanctions/
│       └── Sanction records (if any)
│
├── 04-RISK-MANAGEMENT/
│   ├── Risk-Assessment-Report-[YEAR].pdf
│   ├── Risk-Register-Current.xlsx
│   ├── Risk-Mitigation-Plans.pdf
│   └── Addressable-Specification-Matrix.xlsx
│
├── 05-BUSINESS-ASSOCIATES/
│   ├── BAA-Inventory-Current.xlsx
│   ├── Sample-BAA-[Vendor1].pdf
│   ├── Sample-BAA-[Vendor2].pdf
│   └── Vendor-Risk-Assessments/
│
├── 06-TECHNICAL-SAFEGUARDS/
│   ├── Access-Control/
│   │   ├── RBAC-Role-Definitions.pdf
│   │   ├── Access-Control-Lists.xlsx
│   │   └── MFA-Enrollment-Report.pdf
│   ├── Encryption/
│   │   ├── Encryption-Status-Report.pdf
│   │   ├── TLS-Configuration-Verification.pdf
│   │   └── Certificate-Inventory.xlsx
│   ├── Audit-Logging/
│   │   ├── Log-Retention-Policy.pdf
│   │   ├── Log-Review-Reports (last 6 months)
│   │   └── SIEM-Configuration.pdf
│   └── Authentication/
│       ├── Password-Policy.pdf
│       ├── Session-Timeout-Configuration.pdf
│       └── Unique-User-ID-Documentation.pdf
│
├── 07-PHYSICAL-SAFEGUARDS/
│   ├── Badge-Access-Logs.xlsx
│   ├── Visitor-Logs.xlsx
│   ├── Physical-Security-Audit-Report.pdf
│   ├── Workstation-Security-Policy.pdf
│   └── Media-Disposal-Certificates.pdf
│
├── 08-BUSINESS-CONTINUITY/
│   ├── Data-Backup-Plan.pdf
│   ├── Backup-Success-Logs (last 6 months)
│   ├── Restoration-Test-Results.pdf
│   ├── Disaster-Recovery-Plan.pdf
│   ├── DR-Test-Report-[YEAR].pdf
│   └── Contingency-Plan.pdf
│
├── 09-INCIDENT-RESPONSE/
│   ├── Incident-Response-Policy.pdf
│   ├── Incident-Log-[YEAR].xlsx
│   ├── Breach-Determination-Documentation.pdf (if applicable)
│   ├── Breach-Notifications.pdf (if applicable)
│   └── HHS-Breach-Portal-Confirmation.pdf (if applicable)
│
└── 10-ORGANIZATIONAL/
    ├── HIPAA-Security-Officer-Designation.pdf
    ├── Organizational-Chart.pdf
    ├── Annual-Framework-Evaluation-Report.pdf
    └── Compliance-Metrics-Dashboard.pdf
```

---

## Common OCR Audit Questions

### Administrative Safeguards

**Q: "Who is your designated HIPAA Security Officer?"**
- Provide name, title, date of appointment
- Show formal designation document
- Explain their authority and responsibilities

**Q: "When was your most recent risk assessment conducted?"**
- Provide date (must be within 12 months)
- Show risk assessment report
- Explain risk mitigation actions taken

**Q: "How do you train workforce members on HIPAA?"**
- Explain training program (annual + new hire within 30 days)
- Show LMS reports with 100% completion
- Provide sample training materials

**Q: "What is your process for workforce termination?"**
- Explain termination checklist
- Show sample checklists with access revocation dates
- Demonstrate immediate access revocation capability

**Q: "How do you handle HIPAA violations?"**
- Explain sanction policy
- Provide examples (if any violations occurred)
- Show documentation of sanctions applied

### Physical Safeguards

**Q: "How do you control physical access to ePHI?"**
- Explain badge access system
- Show badge access logs
- Describe visitor procedures

**Q: "How do you secure workstations?"**
- Explain workstation placement (screens away from public)
- Describe screen lock policies (timeout settings)
- Show clean desk policy

**Q: "How do you dispose of devices containing ePHI?"**
- Explain disposal procedures (wiping or physical destruction)
- Provide certificates of destruction
- Show media disposal tracking log

### Technical Safeguards

**Q: "How do you control ePHI access?"**
- Explain RBAC implementation
- Show role definitions and assignments
- Demonstrate minimum necessary principle

**Q: "Do you use unique user IDs?"**
- Confirm no shared accounts
- Show user provisioning process
- Demonstrate audit trail linking actions to individuals

**Q: "Is ePHI encrypted?"**
- Provide encryption status reports (devices, databases, transmission)
- Explain TLS 1.2+ for transmission
- Show encryption key management procedures

**Q: "How do you audit ePHI access?"**
- Explain audit logging (what's logged, where, retention)
- Show log review process and frequency
- Provide sample log review reports

**Q: "Do you have multi-factor authentication?"**
- Explain MFA implementation (remote access, privileged accounts)
- Show MFA enrollment statistics
- Demonstrate MFA enforcement

### Business Continuity

**Q: "How do you back up ePHI?"**
- Explain backup frequency and retention
- Show backup success logs
- Demonstrate restoration capability with test results

**Q: "Do you have a disaster recovery plan?"**
- Provide DR plan document
- Show annual DR test results
- Explain RTO/RPO and how they're measured

**Q: "What happens in a disaster?"**
- Explain emergency mode operations
- Describe ePHI availability procedures
- Show contingency plan testing results

### Breach Notification

**Q: "Have you had any security incidents involving ePHI?"**
- Provide incident log
- Explain incident response process
- Show breach determination methodology (4-part test)

**Q: "If yes, how did you handle breach notification?"**
- Provide breach notification records
- Show notification to individuals (within 60 days)
- Show HHS notification (breach portal confirmation)

**Q: "How do business associates notify you of breaches?"**
- Explain BAA breach notification requirements (30 days)
- Show example of BA breach notification received (if applicable)

---

## Red Flags to Avoid

❌ **Incomplete Training Records** - OCR expects 100%, no exceptions
❌ **Stale Risk Assessment** - Must be within 12 months
❌ **Missing BAAs** - Every business associate must have signed BAA
❌ **No Audit Logging** - Critical ePHI systems without logging is major finding
❌ **Weak Passwords** - Passwords not meeting complexity requirements
❌ **No MFA** - Especially for remote access or privileged accounts
❌ **Unencrypted ePHI** - While addressable, lack of encryption requires strong justification
❌ **No Sanctions** - If violations occur but no sanctions applied, shows policy not enforced
❌ **Outdated Policies** - Policies not reviewed in >1 year
❌ **Disorganized Evidence** - Cannot produce evidence quickly = poor compliance program

---

## Post-Audit Actions

### After On-Site Visit

- [ ] **Send Thank You Note**
  - Thank OCR auditors for professionalism
  - Reiterate commitment to compliance
  - Provide any follow-up information requested

- [ ] **Debrief with Audit Team**
  - What went well?
  - What could be improved?
  - Any surprises or unexpected questions?
  - Document lessons learned

- [ ] **Address Immediate Findings**
  - If OCR identified any gaps during visit, address immediately
  - Don't wait for formal audit report
  - Document remediation actions

### After Receiving Audit Report

- [ ] **Review Findings Carefully**
  - Understand each finding
  - Categorize by severity
  - Assess resource needs for remediation

- [ ] **Develop Corrective Action Plan (CAP)**
  - For each finding, document:
    - Root cause
    - Corrective action
    - Responsible party
    - Target completion date
    - How you'll prevent recurrence
  - Prioritize critical findings

- [ ] **Implement Corrective Actions**
  - Execute CAP
  - Document all actions taken
  - Collect evidence of remediation
  - Update policies/procedures as needed

- [ ] **Respond to OCR**
  - Submit response within required timeframe (typically 30 days)
  - Provide evidence of corrective actions
  - Be thorough and transparent
  - Have legal counsel review response

- [ ] **Monitor Ongoing Compliance**
  - Ensure corrective actions remain effective
  - Schedule follow-up reviews
  - Update risk register with lessons learned
  - Share findings with organization

---

## Audit Readiness Score

Calculate your organization's audit readiness using this scorecard:

| Category | Points | Your Score | Max |
|----------|--------|------------|-----|
| **Risk Assessment** | | | 15 |
| Current (within 12 months) | 10 | | |
| Risk mitigation plans documented | 5 | | |
| **Policies** | | | 15 |
| All 10 policies published | 10 | | |
| 100% workforce acknowledgment | 5 | | |
| **Training** | | | 15 |
| 100% workforce completion | 10 | | |
| New hires within 30 days | 5 | | |
| **Business Associates** | | | 10 |
| 100% BAAs signed | 10 | | |
| **Access Controls** | | | 10 |
| RBAC implemented | 5 | | |
| Quarterly recertification | 5 | | |
| **Technical Safeguards** | | | 15 |
| Encryption (devices, databases, transmission) | 5 | | |
| MFA for remote/privileged access | 5 | | |
| Audit logging enabled | 5 | | |
| **Physical Security** | | | 5 |
| Badge access system | 3 | | |
| Visitor logs | 2 | | |
| **Business Continuity** | | | 10 |
| Backup tested monthly | 5 | | |
| DR test annually | 5 | | |
| **Incident Response** | | | 5 |
| Incident response plan | 3 | | |
| Incident log maintained | 2 | | |
| **TOTAL** | | | **100** |

**Score Interpretation:**
- **90-100**: Audit Ready - minor improvements may be needed
- **75-89**: Mostly Ready - address gaps identified
- **60-74**: Significant Gaps - 30-60 days work needed
- **<60**: Not Ready - 60-90 days work needed

---

## Emergency Audit Preparation (No Advance Notice)

If OCR shows up unannounced or gives <10 days notice:

**Day 1:**
- [ ] Designate audit point of contact immediately
- [ ] Assemble audit response team
- [ ] Notify legal counsel
- [ ] Begin evidence collection (prioritize critical items)

**Day 2-3:**
- [ ] Compile policies, risk assessment, BAAs, training records
- [ ] Create quick index of available evidence
- [ ] Brief HIPAA Security Officer on potential questions

**Day 4-7:**
- [ ] Complete evidence package (as much as possible)
- [ ] Conduct quick mock audit (2 hours)
- [ ] Prepare talking points for interviews

**During Audit:**
- Be professional, cooperative, and honest
- Don't volunteer information not requested
- Take time to find complete answers (don't guess)
- Document all requests and what was provided
- Have legal counsel available by phone

---

*Last Updated: 2025-11-07*
*Version: 1.0*
*For audit preparation assistance, consult your HIPAA Security Officer and Legal Counsel*
