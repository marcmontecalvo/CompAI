-- ================================================================================
-- HIPAA TEMPLATE TO CONTROL LINKAGE
-- Part 3 of Phase 6 Implementation
-- ================================================================================
-- Links policy and task templates to their corresponding control templates
-- Based on PHASE_6_POLICY_TASK_ANALYSIS.md mappings
-- Uses exact control names from database
-- ================================================================================

BEGIN;

-- ================================================================================
-- POLICY TEMPLATE TO CONTROL TEMPLATE MAPPINGS
-- ================================================================================

-- Policy 1: Third-Party Risk Management & Business Associate Agreements
-- Maps to Control: Business Associate Agreements (BAA) Management
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorPolicyTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorPolicyTemplate"
   WHERE name = 'Third-Party Risk Management & Business Associate Agreements'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name = 'Business Associate Agreements (BAA) Management'
AND (SELECT id FROM "FrameworkEditorPolicyTemplate"
     WHERE name = 'Third-Party Risk Management & Business Associate Agreements'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Policy 2: HIPAA Security Management Program
-- Maps to Controls: Security Officer, Risk Assessment, Addressable Specs, Policy Documentation
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorPolicyTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorPolicyTemplate"
   WHERE name = 'HIPAA Security Management Program'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name IN (
  'HIPAA Security Officer & Assigned Responsibility',
  'HIPAA Security Evaluation & Risk Assessment',
  'HIPAA Addressable Specification Assessment',
  'HIPAA Policies & Procedures Documentation',
  'Policy Compliance'
)
AND (SELECT id FROM "FrameworkEditorPolicyTemplate"
     WHERE name = 'HIPAA Security Management Program'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Policy 3: HIPAA Security Awareness and Workforce Training Program
-- Maps to Controls: HIPAA Training, Workforce Security & Sanction, Access Authorization
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorPolicyTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorPolicyTemplate"
   WHERE name = 'HIPAA Security Awareness and Workforce Training Program'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name IN (
  'HIPAA Security Awareness & Workforce Training',
  'Workforce Security & Sanction Policy',
  'ePHI Access Authorization & Role-Based Controls',
  'Access Rights'
)
AND (SELECT id FROM "FrameworkEditorPolicyTemplate"
     WHERE name = 'HIPAA Security Awareness and Workforce Training Program'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Policy 4: Workforce Security, Access Management, and Sanction Policy
-- Maps to Controls: Workforce Security, Access Authorization, Access Rights, Credential Management
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorPolicyTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorPolicyTemplate"
   WHERE name = 'Workforce Security, Access Management, and Sanction Policy'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name IN (
  'Workforce Security & Sanction Policy',
  'ePHI Access Authorization & Role-Based Controls',
  'Access Rights',
  'Credential Management'
)
AND (SELECT id FROM "FrameworkEditorPolicyTemplate"
     WHERE name = 'Workforce Security, Access Management, and Sanction Policy'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Policy 5: ePHI Audit Logging and Monitoring
-- Maps to Controls: PHI Access Logs & Audit Controls, ePHI Integrity Controls, Security Monitoring
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorPolicyTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorPolicyTemplate"
   WHERE name = 'ePHI Audit Logging and Monitoring'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name IN (
  'PHI Access Logs & Audit Controls',
  'ePHI Integrity Controls',
  'Security Monitoring & Detection'
)
AND (SELECT id FROM "FrameworkEditorPolicyTemplate"
     WHERE name = 'ePHI Audit Logging and Monitoring'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Policy 6: ePHI Technical Safeguards and Data Integrity
-- Maps to Controls: Workstation Security, Unique User ID, Encryption, Secure Transfer, Endpoint Protection
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorPolicyTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorPolicyTemplate"
   WHERE name = 'ePHI Technical Safeguards and Data Integrity'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name IN (
  'Workstation & Device Security for ePHI',
  'Unique User Identification & Authentication for ePHI Access',
  'ePHI Encryption at Rest and In Transit',
  'Secure Data Transfer',
  'Endpoint Protection',
  'Encryption Key Management',
  'Automatic Session Logoff for ePHI Systems',
  'Emergency Access Procedures for ePHI'
)
AND (SELECT id FROM "FrameworkEditorPolicyTemplate"
     WHERE name = 'ePHI Technical Safeguards and Data Integrity'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Policy 7: Physical and Environmental Security for ePHI
-- Maps to Control: Physical Facility Access Controls for ePHI
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorPolicyTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorPolicyTemplate"
   WHERE name = 'Physical and Environmental Security for ePHI'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name = 'Physical Facility Access Controls for ePHI'
AND (SELECT id FROM "FrameworkEditorPolicyTemplate"
     WHERE name = 'Physical and Environmental Security for ePHI'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Policy 8: ePHI Backup, Recovery, and Media Management
-- Maps to Controls: ePHI Data Backup, Emergency Mode Operations, Disaster Recovery, Contingency Plan Testing
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorPolicyTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorPolicyTemplate"
   WHERE name = 'ePHI Backup, Recovery, and Media Management'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name IN (
  'ePHI Data Backup & Media Management',
  'Emergency Mode Operations & ePHI Availability',
  'Disaster Recovery Planning',
  'Contingency Plan Testing & Revision'
)
AND (SELECT id FROM "FrameworkEditorPolicyTemplate"
     WHERE name = 'ePHI Backup, Recovery, and Media Management'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Policy 9: Security Incident Response and HIPAA Breach Notification
-- Maps to Controls: Security Incident Response & HIPAA Breach, Security Incident Management
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorPolicyTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorPolicyTemplate"
   WHERE name = 'Security Incident Response and HIPAA Breach Notification'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name IN (
  'Security Incident Response & HIPAA Breach Notification',
  'Security Incident Management'
)
AND (SELECT id FROM "FrameworkEditorPolicyTemplate"
     WHERE name = 'Security Incident Response and HIPAA Breach Notification'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Policy 10: Group Health Plan ePHI Requirements
-- Maps to Control: Group Health Plan ePHI Safeguards
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorPolicyTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorPolicyTemplate"
   WHERE name = 'Group Health Plan ePHI Requirements'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name = 'Group Health Plan ePHI Safeguards'
AND (SELECT id FROM "FrameworkEditorPolicyTemplate"
     WHERE name = 'Group Health Plan ePHI Requirements'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- ================================================================================
-- TASK TEMPLATE TO CONTROL TEMPLATE MAPPINGS
-- ================================================================================

-- Task 1: BAA Inventory Review and Renewal Tracking
-- Maps to Control: Business Associate Agreements (BAA) Management
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorTaskTemplate"
   WHERE name = 'BAA Inventory Review and Renewal Tracking'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name = 'Business Associate Agreements (BAA) Management'
AND (SELECT id FROM "FrameworkEditorTaskTemplate"
     WHERE name = 'BAA Inventory Review and Renewal Tracking'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Task 2: Annual HIPAA Security Training and Completion Tracking
-- Maps to Control: HIPAA Security Awareness & Workforce Training
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorTaskTemplate"
   WHERE name = 'Annual HIPAA Security Training and Completion Tracking'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name = 'HIPAA Security Awareness & Workforce Training'
AND (SELECT id FROM "FrameworkEditorTaskTemplate"
     WHERE name = 'Annual HIPAA Security Training and Completion Tracking'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Task 3: Quarterly Access Review and Termination Checklist Compliance
-- Maps to Controls: Workforce Security & Sanction Policy, ePHI Access Authorization & Role-Based Controls, Access Rights
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorTaskTemplate"
   WHERE name = 'Quarterly Access Review and Termination Checklist Compliance'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name IN (
  'Workforce Security & Sanction Policy',
  'ePHI Access Authorization & Role-Based Controls',
  'Access Rights'
)
AND (SELECT id FROM "FrameworkEditorTaskTemplate"
     WHERE name = 'Quarterly Access Review and Termination Checklist Compliance'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Task 4: Monthly ePHI Access Log Review and Analysis
-- Maps to Controls: PHI Access Logs & Audit Controls, Security Monitoring & Detection
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorTaskTemplate"
   WHERE name = 'Monthly ePHI Access Log Review and Analysis'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name IN (
  'PHI Access Logs & Audit Controls',
  'Security Monitoring & Detection'
)
AND (SELECT id FROM "FrameworkEditorTaskTemplate"
     WHERE name = 'Monthly ePHI Access Log Review and Analysis'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Task 5: Annual HIPAA Security Risk Assessment and Evaluation
-- Maps to Control: HIPAA Security Evaluation & Risk Assessment
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorTaskTemplate"
   WHERE name = 'Annual HIPAA Security Risk Assessment and Evaluation'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name = 'HIPAA Security Evaluation & Risk Assessment'
AND (SELECT id FROM "FrameworkEditorTaskTemplate"
     WHERE name = 'Annual HIPAA Security Risk Assessment and Evaluation'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Task 6: Quarterly Facility Access Review and Physical Security Audit
-- Maps to Control: Physical Facility Access Controls for ePHI
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorTaskTemplate"
   WHERE name = 'Quarterly Facility Access Review and Physical Security Audit'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name = 'Physical Facility Access Controls for ePHI'
AND (SELECT id FROM "FrameworkEditorTaskTemplate"
     WHERE name = 'Quarterly Facility Access Review and Physical Security Audit'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Task 7: Quarterly Device Inventory and ePHI System Compliance Check
-- Maps to Controls: Workstation & Device Security for ePHI, Asset Inventory, Endpoint Protection
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorTaskTemplate"
   WHERE name = 'Quarterly Device Inventory and ePHI System Compliance Check'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name IN (
  'Workstation & Device Security for ePHI',
  'Asset Inventory',
  'Endpoint Protection'
)
AND (SELECT id FROM "FrameworkEditorTaskTemplate"
     WHERE name = 'Quarterly Device Inventory and ePHI System Compliance Check'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Task 8: Monthly ePHI Backup Testing and Verification
-- Maps to Controls: ePHI Data Backup & Media Management
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorTaskTemplate"
   WHERE name = 'Monthly ePHI Backup Testing and Verification'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name = 'ePHI Data Backup & Media Management'
AND (SELECT id FROM "FrameworkEditorTaskTemplate"
     WHERE name = 'Monthly ePHI Backup Testing and Verification'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Task 9: Annual Disaster Recovery Test and Tabletop Exercise
-- Maps to Controls: Disaster Recovery Planning, Emergency Mode Operations & ePHI Availability, Contingency Plan Testing & Revision
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorTaskTemplate"
   WHERE name = 'Annual Disaster Recovery Test and Tabletop Exercise'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name IN (
  'Disaster Recovery Planning',
  'Emergency Mode Operations & ePHI Availability',
  'Contingency Plan Testing & Revision'
)
AND (SELECT id FROM "FrameworkEditorTaskTemplate"
     WHERE name = 'Annual Disaster Recovery Test and Tabletop Exercise'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Task 10: Quarterly ePHI Integrity Verification and Validation
-- Maps to Control: ePHI Integrity Controls
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorTaskTemplate"
   WHERE name = 'Quarterly ePHI Integrity Verification and Validation'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name = 'ePHI Integrity Controls'
AND (SELECT id FROM "FrameworkEditorTaskTemplate"
     WHERE name = 'Quarterly ePHI Integrity Verification and Validation'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Task 11: Quarterly ePHI Access Recertification and RBAC Review
-- Maps to Controls: ePHI Access Authorization & Role-Based Controls, Access Rights
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorTaskTemplate"
   WHERE name = 'Quarterly ePHI Access Recertification and RBAC Review'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name IN (
  'ePHI Access Authorization & Role-Based Controls',
  'Access Rights'
)
AND (SELECT id FROM "FrameworkEditorTaskTemplate"
     WHERE name = 'Quarterly ePHI Access Recertification and RBAC Review'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Task 12: Annual Contingency Plan Test and Update
-- Maps to Control: Contingency Plan Testing & Revision
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorTaskTemplate"
   WHERE name = 'Annual Contingency Plan Test and Update'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name = 'Contingency Plan Testing & Revision'
AND (SELECT id FROM "FrameworkEditorTaskTemplate"
     WHERE name = 'Annual Contingency Plan Test and Update'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Task 13: Annual Addressable Specification Review and Documentation
-- Maps to Control: HIPAA Addressable Specification Assessment
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorTaskTemplate"
   WHERE name = 'Annual Addressable Specification Review and Documentation'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name = 'HIPAA Addressable Specification Assessment'
AND (SELECT id FROM "FrameworkEditorTaskTemplate"
     WHERE name = 'Annual Addressable Specification Review and Documentation'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Task 14: Quarterly ePHI Encryption Compliance Verification
-- Maps to Controls: ePHI Encryption at Rest and In Transit, Encryption Key Management
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorTaskTemplate"
   WHERE name = 'Quarterly ePHI Encryption Compliance Verification'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name IN (
  'ePHI Encryption at Rest and In Transit',
  'Encryption Key Management'
)
AND (SELECT id FROM "FrameworkEditorTaskTemplate"
     WHERE name = 'Quarterly ePHI Encryption Compliance Verification'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

-- Task 15: Semi-Annual HIPAA Policy Review and Update
-- Maps to Controls: HIPAA Policies & Procedures Documentation, Policy Compliance, Change management
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" ("A", "B")
SELECT
  ct.id,
  (SELECT id FROM "FrameworkEditorTaskTemplate"
   WHERE name = 'Semi-Annual HIPAA Policy Review and Update'
   ORDER BY "createdAt" DESC LIMIT 1)
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.name IN (
  'HIPAA Policies & Procedures Documentation',
  'Policy Compliance',
  'Change management'
)
AND (SELECT id FROM "FrameworkEditorTaskTemplate"
     WHERE name = 'Semi-Annual HIPAA Policy Review and Update'
     ORDER BY "createdAt" DESC LIMIT 1) IS NOT NULL
ON CONFLICT DO NOTHING;

COMMIT;

-- Display linkage summary
SELECT
  'Policy-Control Links Created' as metric,
  COUNT(*) as count
FROM "_FrameworkEditorControlTemplateToFrameworkEditorPolicyTemplate";

SELECT
  'Task-Control Links Created' as metric,
  COUNT(*) as count
FROM "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate";

-- Verify HIPAA controls have at least one policy or task
SELECT
  ct.name as control_name,
  COUNT(DISTINCT pct."B") as policy_count,
  COUNT(DISTINCT tct."B") as task_count
FROM "FrameworkEditorControlTemplate" ct
JOIN "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ctr ON ct.id = ctr."A"
JOIN "FrameworkEditorRequirement" r ON ctr."B" = r.id
LEFT JOIN "_FrameworkEditorControlTemplateToFrameworkEditorPolicyTemplate" pct ON ct.id = pct."A"
LEFT JOIN "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" tct ON ct.id = tct."A"
WHERE r."frameworkId" = 'frk_681fdd150f59a1560a66c89a'
GROUP BY ct.id, ct.name
ORDER BY (COUNT(DISTINCT pct."B") + COUNT(DISTINCT tct."B")), ct.name;
