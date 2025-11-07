-- ==================================================
-- HIPAA Policy & Task Template Creation
-- Phase 6 Implementation
-- ==================================================
-- Creates consolidated policies and recurring tasks for HIPAA controls
-- Includes 3 detailed example policies and all 15 task templates
-- ==================================================

BEGIN;

-- ================================================================================
-- PART 1: POLICY TEMPLATES
-- ================================================================================
-- Creating 9 consolidated policies (Group Health Plan is conditional)
-- 3 policies have full detailed content as examples
-- 6 policies have structure only (can be expanded by compliance writers)
-- ================================================================================

-- =====================================
-- Policy 1: Third-Party Risk Management & Business Associate Agreements
-- Control: 1 (Business Associate Agreements Management)
-- FULL EXAMPLE - Complete Content
-- =====================================
INSERT INTO "FrameworkEditorPolicyTemplate" (name, description, frequency, department, content)
VALUES (
  'Third-Party Risk Management & Business Associate Agreements',
  'Establishes procedures for managing Business Associate Agreements (BAAs) to ensure third parties handling Protected Health Information (PHI) comply with HIPAA Security Rule requirements. Includes BAA execution, subcontractor flow-down provisions, breach notification, and ongoing vendor compliance monitoring.',
  'yearly',
  'admin',
  '[
    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Purpose", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "To ensure that {{COMPANY}} maintains appropriate Business Associate Agreements (BAAs) with all third parties that create, receive, maintain, or transmit electronic Protected Health Information (ePHI) on behalf of the organization. This policy establishes procedures for BAA execution, monitoring, and breach notification in compliance with HIPAA Security Rule requirements.", "type": "text"}]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Scope", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "This policy applies to all business associates, subcontractors, and vendors that access, process, or store ePHI on behalf of {{COMPANY}}. This includes cloud service providers, IT vendors, billing companies, legal services, and any other third parties with ePHI access.", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "{{#if hipaa}}", "type": "text"}, {"type": "hardBreak"}, {"text": "Covers HIPAA Security Rule § 164.308(b)(1), § 164.314(a), and breach notification requirements under § 164.410.", "type": "text"}, {"type": "hardBreak"}, {"text": "{{/if}}", "type": "text"}]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Business Associate Identification", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Identify all third parties that create, receive, maintain, or transmit ePHI on behalf of {{COMPANY}}.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Maintain a Business Associate Inventory listing all vendors with ePHI access, including services provided and BAA execution date.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Review vendor contracts at least quarterly to identify new business associates requiring BAAs.", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "BAA Execution Requirements", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "No ePHI may be disclosed to a business associate without a signed BAA in place.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "BAAs must include required provisions per HIPAA Security Rule § 164.314(a)(2)(i):", "type": "text"}]},
        {"type": "bulletList", "content": [
          {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Compliance with applicable HIPAA requirements", "type": "text"}]}]},
          {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Subcontractor flow-down provisions requiring subcontractors to comply with HIPAA", "type": "text"}]}]},
          {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Security incident reporting to {{COMPANY}}, including breach notification", "type": "text"}]}]},
          {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Termination rights for violations", "type": "text"}]}]},
          {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Return or destruction of ePHI upon contract termination", "type": "text"}]}]}
        ]}
      ]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Legal or compliance team must review and approve all BAAs before execution.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Retain executed BAAs for 6 years from the date of creation or last effective date per HIPAA requirements.", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Subcontractor Management", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Business associates must ensure that any subcontractors they engage also sign BAAs with appropriate HIPAA provisions:", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "BAAs must include flow-down provisions requiring business associate subcontractors to comply with HIPAA Security Rule requirements.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Business associates must provide {{COMPANY}} with a list of subcontractors with ePHI access upon request.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Business associates must notify {{COMPANY}} before engaging new subcontractors with ePHI access.", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Breach Notification Requirements", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "All BAAs must require business associates to notify {{COMPANY}} of security incidents and breaches:", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Report security incidents involving ePHI to {{COMPANY}} immediately upon discovery.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Provide breach notifications within {{BREACH_NOTIFICATION_DAYS}} business days of discovery (recommend 3-5 days).", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Include details of the breach: nature, extent, affected individuals, mitigation steps, and business associate contact information.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Cooperate with {{COMPANY}} breach investigation and notification to HHS/affected individuals as required.", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Ongoing Compliance Monitoring", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Review BAA inventory at least quarterly to ensure all business associates have current BAAs.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Request annual attestations from business associates confirming HIPAA compliance.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "For high-risk business associates, request SOC 2 Type II or equivalent audit reports annually.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Amend BAAs as needed to address regulatory changes or operational updates.", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Contract Termination & ePHI Return", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Upon contract termination, business associates must return or destroy all ePHI as specified in the BAA.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Obtain certification of ePHI destruction or return from business associates within 30 days of termination.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "If return/destruction is infeasible, document the rationale and extend confidentiality protections.", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Policy Compliance", "type": "text"}]},
    {"type": "heading", "attrs": {"level": 3, "textAlign": null}, "content": [{"text": "Compliance Measurement", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Quarterly BAA inventory audit confirms 100% of business associates with ePHI access have signed BAAs on file. Annual business associate attestations collected for all critical vendors.", "type": "text"}]},
    {"type": "heading", "attrs": {"level": 3, "textAlign": null}, "content": [{"text": "Exceptions", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "No exceptions to BAA requirements. Any third party with ePHI access must have a signed BAA before access is granted.", "type": "text"}]},
    {"type": "heading", "attrs": {"level": 3, "textAlign": null}, "content": [{"text": "Non-Compliance", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Failure to obtain BAAs before disclosing ePHI is a HIPAA violation. Immediately terminate ePHI access for any vendor without a signed BAA. Report violations to the HIPAA Security Officer and investigate root cause.", "type": "text"}]}
  ]'::jsonb
);

-- =====================================
-- Policy 2: ePHI Audit Logging and Monitoring
-- Control: 4 (PHI Access Logs & Audit Controls)
-- FULL EXAMPLE - Complete Content
-- =====================================
INSERT INTO "FrameworkEditorPolicyTemplate" (name, description, frequency, department, content)
VALUES (
  'ePHI Audit Logging and Monitoring',
  'Implements hardware, software, and procedural mechanisms to record and examine activity in information systems containing electronic Protected Health Information (ePHI). Includes audit log requirements, log retention, regular log review, and incident detection procedures in compliance with HIPAA Security Rule § 164.312(b).',
  'monthly',
  'it',
  '[
    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Purpose", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "To implement audit controls that record and examine activity in {{COMPANY}} information systems containing or using electronic Protected Health Information (ePHI). This policy ensures comprehensive logging of ePHI access, regular log review, and detection of security incidents in compliance with HIPAA Security Rule technical safeguards.", "type": "text"}]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Scope", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Applies to all information systems, applications, databases, and {{DEVICES}} that create, receive, maintain, or transmit ePHI. Includes {{CRITICAL}} systems, cloud services, and any systems where workforce members authenticate to access ePHI.", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "{{#if hipaa}}", "type": "text"}, {"type": "hardBreak"}, {"text": "Covers HIPAA Security Rule § 164.312(b) (Audit controls), § 164.308(a)(1)(ii)(D) (Information system activity review), and § 164.312(d) (Person or entity authentication).", "type": "text"}, {"type": "hardBreak"}, {"text": "{{/if}}", "type": "text"}]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Audit Logging Requirements", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "All systems containing or accessing ePHI must implement audit logging mechanisms:", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Log all ePHI access attempts, including successful and failed authentication.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Record user identity (unique user ID), date/time, system/application accessed, and actions performed.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Log ePHI data access, modifications, deletions, and exports.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Capture privileged account usage, especially administrative access to ePHI systems.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Record security-relevant events: account changes, permission modifications, system configuration changes.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Ensure logs are tamper-resistant and stored separately from the systems being monitored.", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Log Retention", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Retain audit logs for a minimum of 6 years to comply with HIPAA documentation retention requirements.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Store logs in a centralized logging system (SIEM) with secure access controls.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Implement log backup and recovery procedures to prevent log loss.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Archive older logs to cost-effective storage while maintaining accessibility for investigations.", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Regular Log Review", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Implement procedures for regular review of information system activity:", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Conduct monthly review of ePHI access logs for all systems containing {{DATA}}.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Analyze logs for suspicious patterns: off-hours access, excessive data access, failed login attempts, privilege escalation.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Use automated alerts for critical security events: repeated failed logins, administrative access, bulk data exports.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Document log review findings and any follow-up actions taken.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Escalate anomalies to the HIPAA Security Officer for investigation.", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Authentication Logging", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Implement procedures to verify person or entity identity seeking ePHI access:", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Require unique user identification for all ePHI access - no shared accounts.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Log all authentication attempts with user ID, timestamp, source IP, and success/failure.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Implement multi-factor authentication (MFA) for remote ePHI access and administrative accounts.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Alert on repeated failed authentication attempts indicating potential unauthorized access.", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Incident Detection", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Configure automated monitoring to detect potential security incidents involving ePHI.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Alert on indicators of compromise: malware detection, data exfiltration, unauthorized access patterns.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Investigate and respond to security alerts within {{INCIDENT_RESPONSE_SLA}} hours (recommend 24 hours).", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Follow Security Incident Response policy for confirmed incidents.", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Log Protection", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Restrict access to audit logs to authorized security and IT personnel only.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Implement technical controls to prevent unauthorized modification or deletion of logs.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Use cryptographic integrity protection for logs where feasible.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Alert on attempts to access or modify audit logs.", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Policy Compliance", "type": "text"}]},
    {"type": "heading", "attrs": {"level": 3, "textAlign": null}, "content": [{"text": "Compliance Measurement", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Monthly log review completed for 100% of ePHI systems. Automated alerts configured for all critical security events. Log retention verified at 6+ years for HIPAA compliance.", "type": "text"}]},
    {"type": "heading", "attrs": {"level": 3, "textAlign": null}, "content": [{"text": "Exceptions", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "No exceptions to audit logging for systems containing ePHI. All ePHI systems must implement comprehensive audit controls.", "type": "text"}]},
    {"type": "heading", "attrs": {"level": 3, "textAlign": null}, "content": [{"text": "Non-Compliance", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Systems without adequate audit logging may not be used for ePHI. Failure to review logs monthly is a policy violation. Security incidents detected in logs must be investigated per incident response procedures.", "type": "text"}]}
  ]'::jsonb
);

-- =====================================
-- Policy 3: ePHI Technical Safeguards and Data Integrity
-- Controls: 12, 14, 19, 20 (Integrity, Session Timeout, Unique ID, Encryption)
-- FULL EXAMPLE - Complete Content
-- =====================================
INSERT INTO "FrameworkEditorPolicyTemplate" (name, description, frequency, department, content)
VALUES (
  'ePHI Technical Safeguards and Data Integrity',
  'Implements technical safeguards to protect electronic Protected Health Information (ePHI) including data integrity controls, encryption at rest and in transit, unique user identification, and automatic session termination. Ensures ePHI is protected from improper alteration, unauthorized access, and interception.',
  'quarterly',
  'it',
  '[
    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Purpose", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "To implement technical safeguards that protect the integrity, confidentiality, and security of electronic Protected Health Information (ePHI) at {{COMPANY}}. This policy establishes requirements for encryption, data integrity verification, unique user identification, and automatic session termination in compliance with HIPAA Security Rule technical safeguards.", "type": "text"}]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Scope", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Applies to all {{CRITICAL}} systems, {{DEVICES}}, applications, databases, and networks that create, receive, maintain, transmit, or store ePHI. Includes on-premises systems, cloud services, mobile devices, and any system where workforce members access {{DATA}}.", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "{{#if hipaa}}", "type": "text"}, {"type": "hardBreak"}, {"text": "Covers HIPAA Security Rule § 164.312(c)(1) (Integrity), § 164.312(e) (Transmission security), § 164.312(a)(2)(iii) (Automatic logoff), § 164.312(a)(2)(i) (Unique user identification), and § 164.312(a)(2)(iv) (Encryption and decryption).", "type": "text"}, {"type": "hardBreak"}, {"text": "{{/if}}", "type": "text"}]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "ePHI Data Integrity Controls", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Implement policies and procedures to protect ePHI from improper alteration or destruction:", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Use integrity verification mechanisms (checksums, digital signatures, hash functions) to detect unauthorized modifications to ePHI.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Implement version control for ePHI records to track changes and enable rollback if needed.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Ensure database transaction integrity using ACID properties for ePHI databases.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Configure backups with integrity checking to detect data corruption.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Perform quarterly integrity verification tests on ePHI systems.", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Transmission Security & Encryption in Transit", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Protect ePHI during electronic transmission over networks:", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Require TLS 1.2 or higher for all ePHI transmission over public networks (internet).", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Use VPN with strong encryption for remote access to ePHI systems.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Ensure email containing ePHI uses encrypted transport (TLS) or encrypted email solutions.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Implement integrity controls for transmitted ePHI to detect improper modification without detection.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Verify TLS certificate validity and use strong cipher suites (disable weak ciphers like SSL, TLS 1.0/1.1).", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Encryption at Rest", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Encrypt ePHI stored on systems and devices (addressable specification - implementation recommended):", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Use AES-256 encryption for ePHI stored on {{DEVICES}} (laptops, mobile devices, removable media).", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Enable full-disk encryption on all devices with ePHI access (BitLocker, FileVault, LUKS).", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Use database-level encryption for ePHI databases and cloud storage encryption (e.g., AWS RDS encryption, Azure SQL TDE).", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Implement encryption key management with secure key storage (HSM, key management service).", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Rotate encryption keys per {{COMPANY}} cryptographic key management policy.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "If not implementing encryption at rest, document risk assessment and equivalent alternative measures.", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Unique User Identification", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Assign unique identifiers for all persons accessing ePHI:", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Assign unique user IDs to each workforce member, business associate, and system account.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Prohibit shared accounts or generic user IDs for ePHI access.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Link audit logs to unique user IDs to enable accountability and tracking.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Disable or remove user IDs for terminated workforce members within 24 hours.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Implement strong authentication for user IDs (password complexity, MFA).", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Automatic Session Termination", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Implement electronic procedures to terminate sessions after inactivity (addressable specification - implementation recommended):", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Configure automatic session logoff after {{SESSION_TIMEOUT_MINUTES}} minutes of inactivity (recommend 15-30 minutes based on risk).", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Require re-authentication after session timeout to resume ePHI access.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Implement screen savers with password protection on workstations accessing ePHI.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Use shorter timeouts for high-risk systems or administrative access.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "If not implementing automatic logoff, document risk-based rationale and compensating controls (e.g., physical security).", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Compliance Verification", "type": "text"}]},
    {"type": "bulletList", "content": [
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Perform quarterly encryption compliance checks for all ePHI systems and devices.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Verify TLS configuration and certificate validity for all systems transmitting ePHI.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Conduct quarterly integrity verification tests on ePHI databases and storage.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Review user account inventory quarterly to ensure unique IDs and no shared accounts.", "type": "text"}]}]},
      {"type": "listItem", "content": [{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Test session timeout configuration during security assessments.", "type": "text"}]}]}
    ]},

    {"type": "heading", "attrs": {"level": 2, "textAlign": null}, "content": [{"text": "Policy Compliance", "type": "text"}]},
    {"type": "heading", "attrs": {"level": 3, "textAlign": null}, "content": [{"text": "Compliance Measurement", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Quarterly verification confirms 100% of ePHI systems use encryption in transit (TLS 1.2+) and encryption at rest where implemented. Zero shared accounts for ePHI access. Session timeouts configured on all ePHI systems.", "type": "text"}]},
    {"type": "heading", "attrs": {"level": 3, "textAlign": null}, "content": [{"text": "Exceptions", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Encryption at rest and automatic logoff are addressable specifications. If not implemented, document risk assessment showing the measure is not reasonable/appropriate, and implement equivalent alternative measures. Encryption in transit is required - no exceptions.", "type": "text"}]},
    {"type": "heading", "attrs": {"level": 3, "textAlign": null}, "content": [{"text": "Non-Compliance", "type": "text"}]},
    {"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "Systems without encryption in transit may not transmit ePHI over networks. Shared accounts for ePHI access are prohibited. Any integrity violations must be investigated as potential security incidents.", "type": "text"}]}
  ]'::jsonb
);

-- =====================================
-- Remaining Policies (Structure Only - Content TBD)
-- These provide the framework; full content can be added by compliance writers
-- =====================================

-- Policy 4: HIPAA Security Management Program
INSERT INTO "FrameworkEditorPolicyTemplate" (name, description, frequency, department, content)
VALUES (
  'HIPAA Security Management Program',
  'Establishes the HIPAA security management framework including designation of the HIPAA Security Officer, security risk assessment and management procedures, addressable specification assessment methodology, and security policy documentation requirements.',
  'yearly',
  'it',
  '[{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "[POLICY CONTENT TO BE COMPLETED - Covers Controls 5, 6, 18, 21: Security Officer, Risk Assessment, Addressable Specifications, Policy Documentation]", "type": "text"}]}]'::jsonb
);

-- Policy 5: HIPAA Security Awareness and Workforce Training Program
INSERT INTO "FrameworkEditorPolicyTemplate" (name, description, frequency, department, content)
VALUES (
  'HIPAA Security Awareness and Workforce Training Program',
  'Implements a comprehensive HIPAA security awareness and training program for all workforce members including new hire training, annual refresher training, security reminders, malware protection awareness, login monitoring, and password management best practices.',
  'yearly',
  'hr',
  '[{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "[POLICY CONTENT TO BE COMPLETED - Covers Control 2: HIPAA Training Program]", "type": "text"}]}]'::jsonb
);

-- Policy 6: Workforce Security, Access Management, and Sanction Policy
INSERT INTO "FrameworkEditorPolicyTemplate" (name, description, frequency, department, content)
VALUES (
  'Workforce Security, Access Management, and Sanction Policy',
  'Establishes procedures for workforce authorization, supervision, clearance, and termination related to ePHI access. Implements formal sanction policy for security violations, emergency access procedures, and role-based access controls (RBAC) following the minimum necessary principle.',
  'quarterly',
  'hr',
  '[{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "[POLICY CONTENT TO BE COMPLETED - Covers Controls 3, 13, 15: Workforce Security, Emergency Access, RBAC]", "type": "text"}]}]'::jsonb
);

-- Policy 7: Physical and Environmental Security for ePHI
INSERT INTO "FrameworkEditorPolicyTemplate" (name, description, frequency, department, content)
VALUES (
  'Physical and Environmental Security for ePHI',
  'Implements physical safeguards to limit access to electronic information systems and facilities housing ePHI. Includes facility access controls, facility security plan, access validation procedures, workstation use policies, and device security requirements.',
  'quarterly',
  'it',
  '[{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "[POLICY CONTENT TO BE COMPLETED - Covers Controls 7, 9: Facility Access Controls, Workstation/Device Security]", "type": "text"}]}]'::jsonb
);

-- Policy 8: ePHI Backup, Recovery, and Media Management
INSERT INTO "FrameworkEditorPolicyTemplate" (name, description, frequency, department, content)
VALUES (
  'ePHI Backup, Recovery, and Media Management',
  'Establishes procedures for ePHI backup, disaster recovery, emergency mode operations, contingency plan testing, and secure media disposal. Ensures ePHI availability during emergencies and proper sanitization of media containing ePHI.',
  'monthly',
  'it',
  '[{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "[POLICY CONTENT TO BE COMPLETED - Covers Controls 10, 11, 16: Backup, Emergency Operations, Contingency Testing]", "type": "text"}]}]'::jsonb
);

-- Policy 9: Security Incident Response and HIPAA Breach Notification
INSERT INTO "FrameworkEditorPolicyTemplate" (name, description, frequency, department, content)
VALUES (
  'Security Incident Response and HIPAA Breach Notification',
  'Establishes procedures for identifying, responding to, and reporting security incidents involving ePHI. Includes incident response team, breach determination criteria, breach notification timelines (HHS, affected individuals, media), and documentation requirements in compliance with HIPAA Breach Notification Rule.',
  'yearly',
  'it',
  '[{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "[POLICY CONTENT TO BE COMPLETED - Covers Control 8: Incident Response and Breach Notification]", "type": "text"}]}]'::jsonb
);

-- Policy 10: Group Health Plan ePHI Requirements (Conditional)
INSERT INTO "FrameworkEditorPolicyTemplate" (name, description, frequency, department, content)
VALUES (
  'Group Health Plan ePHI Requirements',
  'Establishes requirements for group health plans to amend plan documents requiring plan sponsors to implement administrative, physical, and technical safeguards protecting ePHI. Ensures adequate separation between health plan and plan sponsor. Only applies to organizations that sponsor group health plans.',
  'yearly',
  'admin',
  '[{"type": "paragraph", "attrs": {"textAlign": null}, "content": [{"text": "[POLICY CONTENT TO BE COMPLETED - Covers Control 17: Group Health Plan Requirements - CONDITIONAL]", "type": "text"}]}]'::jsonb
);

COMMIT;

-- Display policy creation summary
SELECT
  'Policies Created' as metric,
  COUNT(*) as count
FROM "FrameworkEditorPolicyTemplate"
WHERE name LIKE '%HIPAA%' OR name LIKE '%ePHI%' OR name LIKE '%Business Associate%';
