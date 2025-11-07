-- ================================================================================
-- HIPAA TASK TEMPLATES
-- Part 2 of Phase 6 Implementation
-- ================================================================================
-- Creating 15 recurring tasks for periodic evidence collection
-- All tasks include clear evidence requirements and AI automation potential
-- ================================================================================

BEGIN;

-- Task 1: BAA Inventory Review and Renewal Tracking
INSERT INTO "FrameworkEditorTaskTemplate" (name, description, frequency, department)
VALUES (
  'BAA Inventory Review and Renewal Tracking',
  'Review Business Associate Inventory to ensure all vendors with ePHI access have current signed BAAs. Track upcoming BAA renewals and amendments. Verify subcontractor BAA flow-down compliance. EVIDENCE: BAA inventory list, BAA documents, expiration tracking, subcontractor documentation. AI POTENTIAL: High (contract system integration, vendor list automation).',
  'quarterly',
  'admin'
);

-- Task 2: Annual HIPAA Security Training and Completion Tracking
INSERT INTO "FrameworkEditorTaskTemplate" (name, description, frequency, department)
VALUES (
  'Annual HIPAA Security Training and Completion Tracking',
  'Ensure 100% of workforce members complete annual HIPAA Security Rule training. Track new hire training completion within 30 days. Maintain training records and certificates. EVIDENCE: Training completion reports, certificates, LMS records, new hire training log. AI POTENTIAL: Very High (LMS API integration, automated tracking).',
  'yearly',
  'hr'
);

-- Task 3: Quarterly Access Review and Termination Checklist Compliance
INSERT INTO "FrameworkEditorTaskTemplate" (name, description, frequency, department)
VALUES (
  'Quarterly Access Review and Termination Checklist Compliance',
  'Conduct manager attestation of workforce ePHI access appropriateness. Verify terminated employee checklist completion and access revocation. Review access modifications for proper approval. EVIDENCE: Manager attestations, termination checklists, access modification logs, deprovisioning evidence. AI POTENTIAL: Medium (access logs automated, attestations require human review).',
  'quarterly',
  'hr'
);

-- Task 4: Monthly ePHI Access Log Review and Analysis
INSERT INTO "FrameworkEditorTaskTemplate" (name, description, frequency, department)
VALUES (
  'Monthly ePHI Access Log Review and Analysis',
  'Review audit logs for all systems containing ePHI. Analyze for suspicious patterns including off-hours access, failed login attempts, privilege escalation, and bulk data exports. Investigate and document any anomalies. EVIDENCE: Log review reports, anomaly findings, investigation notes, SIEM dashboards. AI POTENTIAL: Very High (automated log analysis, SIEM integration, anomaly detection).',
  'monthly',
  'it'
);

-- Task 5: Annual HIPAA Security Risk Assessment and Evaluation
INSERT INTO "FrameworkEditorTaskTemplate" (name, description, frequency, department)
VALUES (
  'Annual HIPAA Security Risk Assessment and Evaluation',
  'Conduct comprehensive HIPAA Security Risk Assessment. Identify and document risks to ePHI confidentiality, integrity, and availability. Create risk mitigation plan. Perform evaluation following environmental or operational changes. EVIDENCE: Risk assessment report, risk register, mitigation plan, evaluation following changes. AI POTENTIAL: Medium (vulnerability scans automated, risk analysis requires judgment).',
  'yearly',
  'it'
);

-- Task 6: Quarterly Facility Access Review and Physical Security Audit
INSERT INTO "FrameworkEditorTaskTemplate" (name, description, frequency, department)
VALUES (
  'Quarterly Facility Access Review and Physical Security Audit',
  'Review facility badge access logs for areas housing ePHI systems. Conduct physical security audit of server rooms, workstation placement, and visitor procedures. Verify maintenance records for physical security systems. EVIDENCE: Badge access reports, physical audit findings, visitor logs, maintenance records, photos. AI POTENTIAL: Medium (badge system integration, camera footage analysis).',
  'quarterly',
  'it'
);

-- Task 7: Quarterly Device Inventory and ePHI System Compliance Check
INSERT INTO "FrameworkEditorTaskTemplate" (name, description, frequency, department)
VALUES (
  'Quarterly Device Inventory and ePHI System Compliance Check',
  'Update device inventory identifying all devices with ePHI access. Verify encryption status, screen lock configuration, and workstation security compliance. Review media disposal records. EVIDENCE: Device inventory, encryption status reports, MDM compliance, disposal records. AI POTENTIAL: Very High (MDM APIs, automated encryption checks, inventory automation).',
  'quarterly',
  'it'
);

-- Task 8: Monthly ePHI Backup Testing and Verification
INSERT INTO "FrameworkEditorTaskTemplate" (name, description, frequency, department)
VALUES (
  'Monthly ePHI Backup Testing and Verification',
  'Verify backup completion for all systems containing ePHI. Conduct backup restoration test. Validate backup integrity and secure storage. Document backup retention compliance. EVIDENCE: Backup logs, restoration test results, integrity verification, backup inventory. AI POTENTIAL: Very High (backup system APIs, automated restore tests, monitoring integration).',
  'monthly',
  'it'
);

-- Task 9: Annual Disaster Recovery Test and Tabletop Exercise
INSERT INTO "FrameworkEditorTaskTemplate" (name, description, frequency, department)
VALUES (
  'Annual Disaster Recovery Test and Tabletop Exercise',
  'Conduct disaster recovery test simulating system failure. Measure RTO/RPO against targets. Perform tabletop exercise with key personnel. Validate emergency mode operations and ePHI availability procedures. Update DR plan based on findings. EVIDENCE: DR test plan and results, tabletop attendance, RTO/RPO measurements, plan updates. AI POTENTIAL: Low (coordinated testing requires human oversight).',
  'yearly',
  'it'
);

-- Task 10: Quarterly ePHI Integrity Verification and Validation
INSERT INTO "FrameworkEditorTaskTemplate" (name, description, frequency, department)
VALUES (
  'Quarterly ePHI Integrity Verification and Validation',
  'Run integrity checks (checksums, hash verifications) on ePHI databases and storage. Verify transmission integrity controls. Document any integrity violations. EVIDENCE: Integrity check results, hash verification logs, transmission validation, violation reports. AI POTENTIAL: Very High (automated checksums, hash verification scripts, integrity monitoring).',
  'quarterly',
  'it'
);

-- Task 11: Quarterly ePHI Access Recertification and RBAC Review
INSERT INTO "FrameworkEditorTaskTemplate" (name, description, frequency, department)
VALUES (
  'Quarterly ePHI Access Recertification and RBAC Review',
  'Managers attest to appropriateness of workforce ePHI access. Review RBAC role definitions and assignments. Verify minimum necessary principle application. Document access modifications and approvals. EVIDENCE: Manager attestations, RBAC documentation, access lists, modification logs. AI POTENTIAL: Medium (access lists automated, manager review requires human judgment).',
  'quarterly',
  'it'
);

-- Task 12: Annual Contingency Plan Test and Update
INSERT INTO "FrameworkEditorTaskTemplate" (name, description, frequency, department)
VALUES (
  'Annual Contingency Plan Test and Update',
  'Test contingency plan procedures including ePHI backup restoration and emergency access. Document test scenarios and outcomes. Update plan based on test findings and environmental changes. EVIDENCE: Test results, scenarios, plan revisions, change documentation. AI POTENTIAL: Low (coordinated testing requires human oversight).',
  'yearly',
  'it'
);

-- Task 13: Annual Addressable Specification Review and Documentation
INSERT INTO "FrameworkEditorTaskTemplate" (name, description, frequency, department)
VALUES (
  'Annual Addressable Specification Review and Documentation',
  'Review all HIPAA addressable specifications. Document implementation decisions with rationale. For non-implemented specifications, document risk assessment and equivalent alternative measures. Update addressable specification matrix. EVIDENCE: Addressable spec matrix, implementation decisions, risk assessments, alternative measures. AI POTENTIAL: Low (requires legal/compliance judgment).',
  'yearly',
  'it'
);

-- Task 14: Quarterly ePHI Encryption Compliance Verification
INSERT INTO "FrameworkEditorTaskTemplate" (name, description, frequency, department)
VALUES (
  'Quarterly ePHI Encryption Compliance Verification',
  'Verify encryption at rest for all ePHI systems and devices. Validate TLS 1.2+ configuration for systems transmitting ePHI. Check certificate validity. Review key management procedures. Document any unencrypted ePHI exceptions. EVIDENCE: Encryption status reports, TLS configuration, certificate scans, key management logs. AI POTENTIAL: Very High (automated TLS checks, certificate monitoring, encryption APIs).',
  'quarterly',
  'it'
);

-- Task 15: Semi-Annual HIPAA Policy Review and Update
INSERT INTO "FrameworkEditorTaskTemplate" (name, description, frequency, department)
VALUES (
  'Semi-Annual HIPAA Policy Review and Update',
  'Review all HIPAA security policies for accuracy and completeness. Update policies based on regulatory changes, environmental changes, or operational updates. Ensure policy distribution to workforce. Verify 6-year retention. EVIDENCE: Policy review log, change history, distribution records, version control. AI POTENTIAL: Medium (version tracking automated, content review requires human judgment).',
  'quarterly',
  'it'
);

COMMIT;

-- Display task creation summary
SELECT
  'Tasks Created' as metric,
  COUNT(*) as count
FROM "FrameworkEditorTaskTemplate"
WHERE description LIKE '%ePHI%' OR description LIKE '%HIPAA%' OR description LIKE '%BAA%';
