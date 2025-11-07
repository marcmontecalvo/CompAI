-- ================================================================================
-- UPDATE HIPAA ORGANIZATION WITH NEW POLICIES AND TASKS
-- Part 4 of Phase 6 Implementation
-- ================================================================================
-- Adds new HIPAA policy and task instances to Premier Care Pediatrics
-- Organization ID: org_690ceac3b099327a2c5d00bc
-- Framework ID: frk_681fdd150f59a1560a66c89a (HIPAA Security Rule)
-- ================================================================================

BEGIN;

-- ================================================================================
-- CREATE NEW POLICY INSTANCES FROM TEMPLATES
-- ================================================================================

INSERT INTO "Policy" (name, description, frequency, department, content, "organizationId", "policyTemplateId", "updatedAt")
SELECT
  pt.name,
  pt.description,
  pt.frequency,
  pt.department,
  ARRAY[pt.content]::jsonb[] as content,
  'org_690ceac3b099327a2c5d00bc' as "organizationId",
  pt.id as "policyTemplateId",
  CURRENT_TIMESTAMP as "updatedAt"
FROM "FrameworkEditorPolicyTemplate" pt
WHERE pt.name IN (
  'Third-Party Risk Management & Business Associate Agreements',
  'HIPAA Security Management Program',
  'HIPAA Security Awareness and Workforce Training Program',
  'Workforce Security, Access Management, and Sanction Policy',
  'ePHI Audit Logging and Monitoring',
  'ePHI Technical Safeguards and Data Integrity',
  'Physical and Environmental Security for ePHI',
  'ePHI Backup, Recovery, and Media Management',
  'Security Incident Response and HIPAA Breach Notification',
  'Group Health Plan ePHI Requirements'
)
AND NOT EXISTS (
  SELECT 1
  FROM "Policy" p
  WHERE p."organizationId" = 'org_690ceac3b099327a2c5d00bc'
    AND p."policyTemplateId" = pt.id
);

-- ================================================================================
-- CREATE NEW TASK INSTANCES FROM TEMPLATES
-- ================================================================================

INSERT INTO "Task" (title, description, frequency, department, "organizationId", "taskTemplateId", "updatedAt")
SELECT
  tt.name,
  tt.description,
  CASE tt.frequency
    WHEN 'monthly' THEN 'monthly'::"TaskFrequency"
    WHEN 'quarterly' THEN 'quarterly'::"TaskFrequency"
    WHEN 'yearly' THEN 'yearly'::"TaskFrequency"
  END as frequency,
  tt.department,
  'org_690ceac3b099327a2c5d00bc' as "organizationId",
  tt.id as "taskTemplateId",
  CURRENT_TIMESTAMP as "updatedAt"
FROM "FrameworkEditorTaskTemplate" tt
WHERE tt.name IN (
  'BAA Inventory Review and Renewal Tracking',
  'Annual HIPAA Security Training and Completion Tracking',
  'Quarterly Access Review and Termination Checklist Compliance',
  'Monthly ePHI Access Log Review and Analysis',
  'Annual HIPAA Security Risk Assessment and Evaluation',
  'Quarterly Facility Access Review and Physical Security Audit',
  'Quarterly Device Inventory and ePHI System Compliance Check',
  'Monthly ePHI Backup Testing and Verification',
  'Annual Disaster Recovery Test and Tabletop Exercise',
  'Quarterly ePHI Integrity Verification and Validation',
  'Quarterly ePHI Access Recertification and RBAC Review',
  'Annual Contingency Plan Test and Update',
  'Annual Addressable Specification Review and Documentation',
  'Quarterly ePHI Encryption Compliance Verification',
  'Semi-Annual HIPAA Policy Review and Update'
)
AND NOT EXISTS (
  SELECT 1
  FROM "Task" t
  WHERE t."organizationId" = 'org_690ceac3b099327a2c5d00bc'
    AND t."taskTemplateId" = tt.id
);

-- ================================================================================
-- LINK NEW POLICIES TO CONTROLS
-- ================================================================================

-- Link newly created policies to controls
INSERT INTO "_ControlToPolicy" ("A", "B")
SELECT DISTINCT
  c.id as control_id,
  p.id as policy_id
FROM "Policy" p
JOIN "FrameworkEditorPolicyTemplate" pt ON p."policyTemplateId" = pt.id
JOIN "_FrameworkEditorControlTemplateToFrameworkEditorPolicyTemplate" ctpt ON pt.id = ctpt."B"
JOIN "FrameworkEditorControlTemplate" ctemp ON ctpt."A" = ctemp.id
JOIN "Control" c ON c."controlTemplateId" = ctemp.id
WHERE p."organizationId" = 'org_690ceac3b099327a2c5d00bc'
  AND c."organizationId" = 'org_690ceac3b099327a2c5d00bc'
  AND NOT EXISTS (
    SELECT 1
    FROM "_ControlToPolicy" cp
    WHERE cp."A" = c.id AND cp."B" = p.id
  )
ON CONFLICT DO NOTHING;

-- ================================================================================
-- LINK NEW TASKS TO CONTROLS
-- ================================================================================

-- Link newly created tasks to controls
INSERT INTO "_ControlToTask" ("A", "B")
SELECT DISTINCT
  c.id as control_id,
  t.id as task_id
FROM "Task" t
JOIN "FrameworkEditorTaskTemplate" tt ON t."taskTemplateId" = tt.id
JOIN "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" cttt ON tt.id = cttt."B"
JOIN "FrameworkEditorControlTemplate" ctemp ON cttt."A" = ctemp.id
JOIN "Control" c ON c."controlTemplateId" = ctemp.id
WHERE t."organizationId" = 'org_690ceac3b099327a2c5d00bc'
  AND c."organizationId" = 'org_690ceac3b099327a2c5d00bc'
  AND NOT EXISTS (
    SELECT 1
    FROM "_ControlToTask" ct
    WHERE ct."A" = c.id AND ct."B" = t.id
  )
ON CONFLICT DO NOTHING;

COMMIT;

-- ================================================================================
-- VERIFICATION QUERIES
-- ================================================================================

-- Show final counts
SELECT
  'Final Policy Count' as metric,
  COUNT(*) as count
FROM "Policy"
WHERE "organizationId" = 'org_690ceac3b099327a2c5d00bc';

SELECT
  'Final Task Count' as metric,
  COUNT(*) as count
FROM "Task"
WHERE "organizationId" = 'org_690ceac3b099327a2c5d00bc';

-- Show new HIPAA-specific policies
SELECT
  name
FROM "Policy"
WHERE "organizationId" = 'org_690ceac3b099327a2c5d00bc'
  AND (name LIKE '%HIPAA%' OR name LIKE '%ePHI%' OR name LIKE '%BAA%')
ORDER BY name;

-- Show new HIPAA-specific tasks
SELECT
  title
FROM "Task"
WHERE "organizationId" = 'org_690ceac3b099327a2c5d00bc'
  AND (title LIKE '%HIPAA%' OR title LIKE '%ePHI%' OR title LIKE '%BAA%')
ORDER BY title;

-- Show policy-control linkages
SELECT
  'Policy-Control Links' as metric,
  COUNT(*) as count
FROM "_ControlToPolicy" cp
JOIN "Policy" p ON cp."B" = p.id
WHERE p."organizationId" = 'org_690ceac3b099327a2c5d00bc';

-- Show task-control linkages
SELECT
  'Task-Control Links' as metric,
  COUNT(*) as count
FROM "_ControlToTask" ct
JOIN "Task" t ON ct."B" = t.id
WHERE t."organizationId" = 'org_690ceac3b099327a2c5d00bc';
