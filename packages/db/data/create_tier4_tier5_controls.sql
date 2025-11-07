-- ==================================================
-- TIER 4 & 5 HIPAA CONTROL TEMPLATES
-- Creating remaining controls to complete coverage
-- ==================================================

BEGIN;

-- =====================================
-- Tier 4 Controls
-- =====================================

-- Control 13: Emergency Access Procedures for ePHI
INSERT INTO "FrameworkEditorControlTemplate" (name, description)
VALUES (
  'Emergency Access Procedures for ePHI',
  'Establish and document procedures for obtaining necessary ePHI during emergency situations to ensure patient care continuity. Implement policies for authorizing access to ePHI based on workforce roles, ensuring access is limited to minimum necessary. Define break-glass procedures for emergency access while maintaining audit trails and subsequent review processes.'
);

INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ("A", "B")
SELECT
  (SELECT id FROM "FrameworkEditorControlTemplate" WHERE name = 'Emergency Access Procedures for ePHI' ORDER BY "createdAt" DESC LIMIT 1),
  id
FROM "FrameworkEditorRequirement"
WHERE name IN (
  '164.312(a.2.ii) Technical Safeguards',
  '164.308(a.4.i) Administrative safeguards'
)
AND "frameworkId" IN (SELECT id FROM "FrameworkEditorFramework" WHERE name LIKE '%HIPAA%');

-- Control 14: Automatic Session Logoff for ePHI Systems
INSERT INTO "FrameworkEditorControlTemplate" (name, description)
VALUES (
  'Automatic Session Logoff for ePHI Systems',
  'Implement electronic procedures that automatically terminate sessions accessing ePHI after a predetermined period of inactivity. Configure timeout settings based on risk analysis and operational requirements. Ensure logoff procedures maintain data integrity and prevent data loss while protecting against unauthorized access via unattended workstations.'
);

INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ("A", "B")
SELECT
  (SELECT id FROM "FrameworkEditorControlTemplate" WHERE name = 'Automatic Session Logoff for ePHI Systems' ORDER BY "createdAt" DESC LIMIT 1),
  id
FROM "FrameworkEditorRequirement"
WHERE name = '164.312(a.2.iii) Technical Safeguards'
AND "frameworkId" IN (SELECT id FROM "FrameworkEditorFramework" WHERE name LIKE '%HIPAA%');

-- Control 15: ePHI Access Authorization & Role-Based Controls
INSERT INTO "FrameworkEditorControlTemplate" (name, description)
VALUES (
  'ePHI Access Authorization & Role-Based Controls',
  'Implement procedures to determine and authorize appropriate ePHI access levels for workforce members based on roles and responsibilities. Establish access establishment and modification processes tied to hiring, role changes, and termination. Conduct workforce clearance procedures to ensure appropriate access authorization. Implement role-based access controls (RBAC) following minimum necessary principle.'
);

INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ("A", "B")
SELECT
  (SELECT id FROM "FrameworkEditorControlTemplate" WHERE name = 'ePHI Access Authorization & Role-Based Controls' ORDER BY "createdAt" DESC LIMIT 1),
  id
FROM "FrameworkEditorRequirement"
WHERE name IN (
  '164.308(a.4.ii.B) Administrative safeguards',
  '164.308(a.4.ii.C) Administrative safeguards',
  '164.312(a.1) Technical Safeguards'
)
AND "frameworkId" IN (SELECT id FROM "FrameworkEditorFramework" WHERE name LIKE '%HIPAA%');

-- Control 16: Contingency Plan Testing & Revision
INSERT INTO "FrameworkEditorControlTemplate" (name, description)
VALUES (
  'Contingency Plan Testing & Revision',
  'Implement procedures for periodic testing and revision of contingency plans protecting ePHI. Conduct tabletop exercises, simulations, and actual failover tests at least annually. Document test results, identified gaps, and remediation actions. Update contingency plans based on test findings, environmental changes, and operational updates to ensure continued effectiveness.'
);

INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ("A", "B")
SELECT
  (SELECT id FROM "FrameworkEditorControlTemplate" WHERE name = 'Contingency Plan Testing & Revision' ORDER BY "createdAt" DESC LIMIT 1),
  id
FROM "FrameworkEditorRequirement"
WHERE name = '164.308(a.7.ii.D) Administrative safeguards'
AND "frameworkId" IN (SELECT id FROM "FrameworkEditorFramework" WHERE name LIKE '%HIPAA%');

-- =====================================
-- Tier 5 Controls (Administrative)
-- =====================================

-- Control 17: Group Health Plan ePHI Safeguards
INSERT INTO "FrameworkEditorControlTemplate" (name, description)
VALUES (
  'Group Health Plan ePHI Safeguards',
  'For group health plans, amend plan documents to incorporate provisions requiring plan sponsors to implement administrative, physical, and technical safeguards protecting ePHI. Ensure adequate separation between health plan and plan sponsor is supported by security measures. Require plan sponsors to report security incidents. Applies specifically to group health plans as defined by HIPAA.'
);

INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ("A", "B")
SELECT
  (SELECT id FROM "FrameworkEditorControlTemplate" WHERE name = 'Group Health Plan ePHI Safeguards' ORDER BY "createdAt" DESC LIMIT 1),
  id
FROM "FrameworkEditorRequirement"
WHERE name LIKE '164.314(b.2)%'
AND "frameworkId" IN (SELECT id FROM "FrameworkEditorFramework" WHERE name LIKE '%HIPAA%');

-- Control 18: HIPAA Addressable Specification Assessment
INSERT INTO "FrameworkEditorControlTemplate" (name, description)
VALUES (
  'HIPAA Addressable Specification Assessment',
  'Document assessment and implementation decisions for all addressable specifications in HIPAA Security Rule. For each addressable specification, assess whether it is reasonable and appropriate safeguard given organization size, capabilities, and costs. If implementing, document how. If not implementing, document why not and what alternative equivalent measures are in place. Maintain documentation for compliance audits.'
);

INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ("A", "B")
SELECT
  (SELECT id FROM "FrameworkEditorControlTemplate" WHERE name = 'HIPAA Addressable Specification Assessment' ORDER BY "createdAt" DESC LIMIT 1),
  id
FROM "FrameworkEditorRequirement"
WHERE name LIKE '164.306(d.3)%'
AND "frameworkId" IN (SELECT id FROM "FrameworkEditorFramework" WHERE name LIKE '%HIPAA%')
LIMIT 3;

-- =====================================
-- Additional critical controls for complete coverage
-- =====================================

-- Control 19: Unique User Identification & Authentication
INSERT INTO "FrameworkEditorControlTemplate" (name, description)
VALUES (
  'Unique User Identification & Authentication for ePHI Access',
  'Assign unique name and/or number for identifying and tracking user identity for all persons or entities accessing ePHI systems. Implement procedures to verify that person or entity seeking access is the one claimed. Prohibit shared credentials for ePHI access. Maintain user access logs tied to unique identifiers to enable audit and accountability.'
);

INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ("A", "B")
SELECT
  (SELECT id FROM "FrameworkEditorControlTemplate" WHERE name = 'Unique User Identification & Authentication for ePHI Access' ORDER BY "createdAt" DESC LIMIT 1),
  id
FROM "FrameworkEditorRequirement"
WHERE name IN (
  '164.312(a.2.i) Technical Safeguards',
  '164.312(d) Technical Safeguards'
)
AND "frameworkId" IN (SELECT id FROM "FrameworkEditorFramework" WHERE name LIKE '%HIPAA%');

-- Control 20: ePHI Encryption at Rest and In Transit
INSERT INTO "FrameworkEditorControlTemplate" (name, description)
VALUES (
  'ePHI Encryption at Rest and In Transit',
  'Implement mechanisms to encrypt and decrypt electronic Protected Health Information (ePHI) stored on systems and when transmitted over networks. Use industry-standard encryption algorithms (AES-256 for data at rest, TLS 1.2+ for data in transit). Maintain encryption key management procedures. While addressable under HIPAA, encryption is strongly recommended and often required by state laws and business associate agreements.'
);

INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ("A", "B")
SELECT
  (SELECT id FROM "FrameworkEditorControlTemplate" WHERE name = 'ePHI Encryption at Rest and In Transit' ORDER BY "createdAt" DESC LIMIT 1),
  id
FROM "FrameworkEditorRequirement"
WHERE name IN (
  '164.312(a.2.iv) Technical Safeguards',
  '164.312(e.2.ii) Technical Safeguards'
)
AND "frameworkId" IN (SELECT id FROM "FrameworkEditorFramework" WHERE name LIKE '%HIPAA%');

COMMIT;

-- Display final summary
SELECT
  'ALL TIERS COMPLETE' as status,
  COUNT(*) as total_new_controls
FROM "FrameworkEditorControlTemplate"
WHERE name LIKE '%ePHI%' OR name LIKE '%HIPAA%' OR name LIKE '%PHI%' OR name LIKE '%Business Associate%';

-- Display comprehensive mapping summary
SELECT
  'HIPAA CONTROL COVERAGE' as metric,
  COUNT(DISTINCT ct.id) as total_hipaa_controls,
  COUNT(DISTINCT r.id) as total_requirements_mapped
FROM "FrameworkEditorControlTemplate" ct
JOIN "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ctr ON ct.id = ctr."A"
JOIN "FrameworkEditorRequirement" r ON ctr."B" = r.id
WHERE r."frameworkId" IN (SELECT id FROM "FrameworkEditorFramework" WHERE name LIKE '%HIPAA%');
