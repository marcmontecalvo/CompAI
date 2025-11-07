-- ==================================================
-- Re-initialize Premier Care Pediatrics with New HIPAA Controls
-- This script creates control instances for the new HIPAA control templates
-- ==================================================

BEGIN;

-- Get organization and framework instance IDs
\set orgId 'org_690ceac3b099327a2c5d00bc'
\set hipaaFrameworkId 'frk_681fdd150f59a1560a66c89a'

-- Get the framework instance ID for this org
DO $$
DECLARE
  v_framework_instance_id text;
BEGIN
  SELECT id INTO v_framework_instance_id
  FROM "FrameworkInstance"
  WHERE "organizationId" = 'org_690ceac3b099327a2c5d00bc'
    AND "frameworkId" = 'frk_681fdd150f59a1560a66c89a';

  RAISE NOTICE 'Framework Instance ID: %', v_framework_instance_id;
END $$;

-- Create control instances for all HIPAA control templates that don't exist yet
INSERT INTO "Control" (name, description, "organizationId", "controlTemplateId")
SELECT
  ct.name,
  ct.description,
  'org_690ceac3b099327a2c5d00bc' as "organizationId",
  ct.id as "controlTemplateId"
FROM "FrameworkEditorControlTemplate" ct
WHERE ct.id IN (
  -- Get all control templates that are mapped to HIPAA requirements
  SELECT DISTINCT ctr."A"
  FROM "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ctr
  JOIN "FrameworkEditorRequirement" r ON ctr."B" = r.id
  WHERE r."frameworkId" = 'frk_681fdd150f59a1560a66c89a'
)
AND NOT EXISTS (
  -- Only create if control doesn't already exist for this org and template
  SELECT 1
  FROM "Control" c
  WHERE c."organizationId" = 'org_690ceac3b099327a2c5d00bc'
    AND c."controlTemplateId" = ct.id
);

-- Create requirement mappings for all controls
INSERT INTO "RequirementMap" ("controlId", "requirementId", "frameworkInstanceId")
SELECT DISTINCT
  c.id as "controlId",
  r.id as "requirementId",
  fi.id as "frameworkInstanceId"
FROM "Control" c
JOIN "FrameworkEditorControlTemplate" ct ON c."controlTemplateId" = ct.id
JOIN "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ctr ON ct.id = ctr."A"
JOIN "FrameworkEditorRequirement" r ON ctr."B" = r.id
JOIN "FrameworkInstance" fi ON r."frameworkId" = fi."frameworkId"
WHERE c."organizationId" = 'org_690ceac3b099327a2c5d00bc'
  AND fi."organizationId" = 'org_690ceac3b099327a2c5d00bc'
  AND r."frameworkId" = 'frk_681fdd150f59a1560a66c89a'
  AND NOT EXISTS (
    SELECT 1
    FROM "RequirementMap" rm
    WHERE rm."controlId" = c.id
      AND rm."requirementId" = r.id
      AND rm."frameworkInstanceId" = fi.id
  );

COMMIT;

-- Display results
SELECT
  'New Controls Created' as metric,
  COUNT(*) as count
FROM "Control"
WHERE "organizationId" = 'org_690ceac3b099327a2c5d00bc'
  AND "createdAt" > NOW() - INTERVAL '1 minute';

SELECT
  'Total Controls' as metric,
  COUNT(*) as count
FROM "Control"
WHERE "organizationId" = 'org_690ceac3b099327a2c5d00bc';

SELECT
  'Total Requirement Mappings' as metric,
  COUNT(*) as count
FROM "RequirementMap" rm
WHERE rm."frameworkInstanceId" IN (
  SELECT id FROM "FrameworkInstance"
  WHERE "organizationId" = 'org_690ceac3b099327a2c5d00bc'
);

SELECT
  'Unique Requirements Mapped' as metric,
  COUNT(DISTINCT rm."requirementId") as count
FROM "RequirementMap" rm
WHERE rm."frameworkInstanceId" IN (
  SELECT id FROM "FrameworkInstance"
  WHERE "organizationId" = 'org_690ceac3b099327a2c5d00bc'
);
