-- ==================================================
-- Map Remaining 15 HIPAA Requirements
-- ==================================================

BEGIN;

-- Map General Rules requirements to HIPAA Security Evaluation & Risk Assessment
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ("A", "B")
SELECT 
  (SELECT id FROM "FrameworkEditorControlTemplate" WHERE name = 'HIPAA Security Evaluation & Risk Assessment' ORDER BY "createdAt" DESC LIMIT 1),
  id
FROM "FrameworkEditorRequirement"
WHERE name IN (
  '164.306(b.1) General Rules',
  '164.306(b.2) General Rules',
  '164.306(c) General Rules',
  '164.306(e) General Rules'
)
OR (name = 'General Rules' AND description LIKE '%confidentiality, integrity, and availability%')
OR (name = 'General Rules' AND description LIKE '%reasonably anticipated threats%')
OR (name = 'General Rules' AND description LIKE '%reasonably anticipated uses or disclosures%')
ON CONFLICT DO NOTHING;

-- Map Addressable Implementation Specifications to existing control
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ("A", "B")
SELECT 
  (SELECT id FROM "FrameworkEditorControlTemplate" WHERE name = 'HIPAA Addressable Specification Assessment' ORDER BY "createdAt" DESC LIMIT 1),
  id
FROM "FrameworkEditorRequirement"
WHERE name IN (
  '164.306(d.1) General Rules',
  '164.306(d.2) General Rules'
)
ON CONFLICT DO NOTHING;

-- Map media disposal and re-use to ePHI Data Backup & Media Management
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ("A", "B")
SELECT 
  (SELECT id FROM "FrameworkEditorControlTemplate" WHERE name = 'ePHI Data Backup & Media Management' ORDER BY "createdAt" DESC LIMIT 1),
  id
FROM "FrameworkEditorRequirement"
WHERE name IN (
  '164.310(d.1.ii) Physical Safeguards',
  '164.310(d.1.i) Physical Safeguards',
  '164.310(d.1.iv) Physical Safeguards'
)
ON CONFLICT DO NOTHING;

-- Map health care clearinghouse isolation to Access Authorization control
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ("A", "B")
SELECT 
  (SELECT id FROM "FrameworkEditorControlTemplate" WHERE name = 'ePHI Access Authorization & Role-Based Controls' ORDER BY "createdAt" DESC LIMIT 1),
  id
FROM "FrameworkEditorRequirement"
WHERE name = '164.308(a.4.ii.A) Administrative safeguards'
ON CONFLICT DO NOTHING;

-- Create new control for Policies & Procedures Documentation
INSERT INTO "FrameworkEditorControlTemplate" (name, description)
VALUES (
  'HIPAA Policies & Procedures Documentation',
  'Maintain written (electronic or paper) policies and procedures implementing HIPAA Security Rule requirements. Document all security policies, procedures, actions, activities, and assessments. Retain documentation for 6 years from date of creation or last effective date, whichever is later. Make documentation available to workforce members responsible for implementing procedures. Review and update documentation regularly based on environmental or operational changes.'
);

-- Map documentation requirements to new control
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ("A", "B")
SELECT 
  (SELECT id FROM "FrameworkEditorControlTemplate" WHERE name = 'HIPAA Policies & Procedures Documentation' ORDER BY "createdAt" DESC LIMIT 1),
  id
FROM "FrameworkEditorRequirement"
WHERE name LIKE '%Policies and procedures and documentation requirements%'
OR name LIKE '164.316(b.1)%'
ON CONFLICT DO NOTHING;

COMMIT;

-- Display final coverage
SELECT 
  'FINAL HIPAA COVERAGE' as status,
  COUNT(DISTINCT r.id) as total_requirements,
  COUNT(DISTINCT CASE WHEN EXISTS (
    SELECT 1 FROM "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ctr WHERE ctr."B" = r.id
  ) THEN r.id END) as mapped_requirements,
  COUNT(DISTINCT CASE WHEN NOT EXISTS (
    SELECT 1 FROM "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ctr WHERE ctr."B" = r.id
  ) THEN r.id END) as unmapped_requirements
FROM "FrameworkEditorRequirement" r
WHERE r."frameworkId" IN (SELECT id FROM "FrameworkEditorFramework" WHERE name LIKE '%HIPAA%');
