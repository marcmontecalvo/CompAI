# ePHI Audit Logging and Monitoring

**Policy Type**: HIPAA Security Policy
**Frequency**: Yearly Review
**Department**: IT
**Status**: ✅ COMPLETE

---

## Purpose

To establish comprehensive audit logging and monitoring procedures for all systems that create, receive, maintain, or transmit electronic Protected Health Information (ePHI). This policy ensures that {{COMPANY}} maintains audit trails sufficient to detect, investigate, and respond to unauthorized access, security incidents, and potential HIPAA breaches involving ePHI.

---

## Scope

This policy applies to:
- All information systems containing ePHI
- Applications accessing ePHI databases
- Network devices routing ePHI traffic
- Authentication systems controlling ePHI access
- Backup systems storing ePHI
- Cloud platforms hosting ePHI

---

## Policy Statements

### 1. Audit Logging Requirements

{{COMPANY}} shall implement and maintain audit logging for all ePHI systems that capture:
- User access events (login, logout, failed authentication)
- ePHI viewing, creation, modification, and deletion
- Administrative actions (user provisioning, permission changes)
- Security configuration changes
- System startup and shutdown events
- Privilege escalation attempts
- Data export and bulk access events

### 2. Audit Log Content

All audit logs shall include at minimum:
- Date and timestamp (synchronized via NTP)
- User identifier (unique user ID, not shared credentials)
- Action performed (read, write, delete, modify)
- ePHI record or resource accessed
- Source IP address or workstation identifier
- Success or failure status
- Application or system name

### 3. Log Protection and Integrity

Audit logs shall be protected from unauthorized access, modification, or deletion:
- Read-only access for all users except designated security personnel
- Centralized log aggregation to secure SIEM or log management system
- Encryption of logs in transit and at rest
- Integrity validation using cryptographic hashes or digital signatures
- Segregation of duties (log reviewers cannot modify logs)

### 4. Log Retention

{{COMPANY}} shall retain audit logs for a minimum of 6 years from creation date or date last in effect, whichever is later, in compliance with HIPAA requirements. Retention includes:
- Active logs readily available for review (90 days)
- Archived logs stored in secure, encrypted format (remainder of retention period)
- Backup copies maintained in geographically separate location

### 5. Log Monitoring and Review

{{COMPANY}} shall implement automated and manual log monitoring:
- **Automated Monitoring**: Real-time SIEM alerts for suspicious activity patterns
- **Monthly Review**: IT security team reviews access logs for anomalies
- **Quarterly Reporting**: Management review of log monitoring findings
- **Ad-Hoc Review**: On-demand log review for security incident investigation

### 6. Alerting and Incident Response

Automated alerts shall be configured for:
- Multiple failed login attempts (potential brute force)
- After-hours access to ePHI systems
- Privileged account usage
- Bulk ePHI export or download
- Access from unusual geographic locations
- Disabled or deleted audit logging
- Unauthorized configuration changes

### 7. ePHI Integrity Monitoring

{{COMPANY}} shall implement integrity controls to detect unauthorized ePHI modification:
- Checksums or cryptographic hashes for ePHI at rest
- Database transaction logs with rollback capability
- File integrity monitoring (FIM) for critical ePHI files
- Validation of data during transmission (TLS integrity checks)

### 8. Log Review Documentation

All log reviews shall be documented including:
- Date of review
- Reviewer name and title
- Time period covered
- Anomalies or security events identified
- Investigation actions taken
- Findings and resolution

---

## Responsibilities

### HIPAA Security Officer
- Oversee audit logging program
- Review monthly log analysis reports
- Ensure compliance with audit logging requirements
- Coordinate breach investigations involving log analysis

### IT Security Team
- Implement and maintain logging infrastructure
- Configure SIEM rules and alerts
- Conduct monthly log reviews
- Investigate security alerts and anomalies
- Document log review findings

### System Administrators
- Enable audit logging on all ePHI systems
- Ensure log data flows to central SIEM
- Monitor log storage capacity
- Respond to logging system failures
- Do not access or modify audit logs (segregation of duties)

### Application Owners
- Identify ePHI access events requiring logging
- Coordinate with IT to enable application-level logging
- Participate in security incident investigations
- Report suspected unauthorized ePHI access

---

## Procedures

### Enabling Audit Logging for New ePHI Systems

1. **System Classification**: Identify system as containing/accessing ePHI
2. **Logging Assessment**: Determine available logging capabilities
3. **Configuration**: Enable comprehensive audit logging per policy requirements
4. **SIEM Integration**: Configure log forwarding to central SIEM
5. **Alert Setup**: Configure automated alerts for suspicious activity
6. **Testing**: Validate logs are captured and forwarded correctly
7. **Documentation**: Document logging configuration in system inventory

### Monthly ePHI Access Log Review

1. **Log Retrieval**: Pull audit logs for all ePHI systems (last 30 days)
2. **Automated Analysis**: Run SIEM queries for suspicious patterns:
   - Failed login attempts exceeding threshold
   - Off-hours access (outside business hours)
   - Privilege escalation events
   - Bulk data exports or downloads
   - Access from unexpected locations
3. **Manual Review**: Security analyst reviews flagged events
4. **Investigation**: Follow up on legitimate anomalies
5. **Documentation**: Complete log review report with findings
6. **Management Report**: Provide summary to HIPAA Security Officer

### Security Incident Log Investigation

1. **Incident Notification**: Security team notified of potential ePHI breach
2. **Log Preservation**: Immediately preserve all relevant logs
3. **Timeline Construction**: Use logs to build incident timeline
4. **Scope Determination**: Identify all affected ePHI and users
5. **Root Cause Analysis**: Determine how incident occurred
6. **Evidence Collection**: Export logs as evidence for investigation
7. **Breach Assessment**: Determine if incident constitutes HIPAA breach
8. **Corrective Actions**: Implement controls to prevent recurrence

### Quarterly Integrity Verification

1. **Checksum Generation**: Generate checksums for ePHI databases
2. **Baseline Comparison**: Compare against previous quarter baseline
3. **Anomaly Detection**: Identify unexpected changes
4. **Investigation**: Review transaction logs for anomalies
5. **Validation**: Confirm changes are authorized
6. **Documentation**: Document integrity verification results

---

## Technical Controls

### SIEM Configuration

{{COMPANY}} shall implement a Security Information and Event Management (SIEM) system with:
- Centralized log aggregation from all ePHI systems
- Real-time correlation and alerting
- Long-term log storage and retention
- Search and investigation capabilities
- Compliance reporting dashboards
- Role-based access control for log review

### Logging Standards

All systems shall implement logging using industry-standard formats:
- Syslog (RFC 5424) for network devices and Linux systems
- Windows Event Log for Windows systems
- Application-specific logging (database audit logs, web server logs)
- Cloud platform native logging (AWS CloudTrail, Azure Monitor)

### Time Synchronization

All systems shall synchronize time using Network Time Protocol (NTP):
- Primary NTP server with authoritative time source
- Secondary NTP server for redundancy
- Maximum time drift: ±1 second
- Monitoring of NTP synchronization status

---

## Related Policies

{{#if hipaa}}
- HIPAA Security Management Program
- Security Incident Response & HIPAA Breach Notification
- ePHI Technical Safeguards and Data Integrity
{{/if}}

{{#if soc2}}
- Security Logging and Monitoring
- Incident Response & Breach Notification
{{/if}}

---

## References

- 45 CFR § 164.308(a)(1)(ii)(D) - Information System Activity Review
- 45 CFR § 164.308(a)(5)(ii)(C) - Log-in Monitoring
- 45 CFR § 164.312(b) - Audit Controls
- 45 CFR § 164.312(c)(1) - Integrity Controls
- 45 CFR § 164.316(b)(2)(i) - Retention of Documentation (6 years)
- NIST SP 800-92 - Guide to Computer Security Log Management

---

## Exceptions

Limited exceptions to this policy may be granted for:
- Legacy systems unable to support modern logging (requires risk acceptance)
- Third-party cloud services with alternative audit mechanisms (requires BAA)
- Medical devices with limited logging capabilities (requires compensating controls)

All exceptions require approval from HIPAA Security Officer and must be documented with:
- Business justification
- Risk assessment
- Compensating controls
- Annual re-evaluation

---

## Document Control

- **Policy Owner**: Chief Information Security Officer / HIPAA Security Officer
- **Review Frequency**: Annually or upon significant system changes
- **Next Review Date**: [To be set upon adoption]
- **Revision History**:
  - v1.0 - Initial policy creation
  - [Future revisions to be documented here]

---

## Approval

This policy has been reviewed and approved by:

- [ ] Chief Information Security Officer / HIPAA Security Officer
- [ ] Chief Technology Officer
- [ ] Chief Privacy Officer
- [ ] Chief Executive Officer

**Effective Date**: _________________

**Last Updated**: _________________
