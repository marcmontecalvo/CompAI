# Framework Administrator Guide - HIPAA Security Rule

## Overview

This guide is for CompAI administrators responsible for managing the HIPAA Security Rule framework within their organization. It covers framework initialization, control management, policy maintenance, task assignment, and system administration.

---

## Table of Contents

1. [Framework Administration Basics](#framework-administration-basics)
2. [Initializing HIPAA Framework](#initializing-hipaa-framework)
3. [Managing Controls](#managing-controls)
4. [Managing Policies](#managing-policies)
5. [Managing Tasks](#managing-tasks)
6. [Requirement Mapping](#requirement-mapping)
7. [Evidence Management](#evidence-management)
8. [Reporting and Dashboards](#reporting-and-dashboards)
9. [Updating the Framework](#updating-the-framework)
10. [Troubleshooting](#troubleshooting)

---

## Framework Administration Basics

### Administrator Roles and Permissions

In CompAI, there are several administrative roles:

| Role | Permissions | Typical User |
|------|------------|--------------|
| **Organization Admin** | Full access to all framework features, can initialize frameworks, assign owners | CEO, HIPAA Security Officer |
| **Framework Manager** | Can manage controls, policies, tasks within assigned frameworks | Compliance Manager, IT Security Manager |
| **Control Owner** | Can update assigned controls, upload evidence, mark as implemented | IT Manager, HR Manager, Facilities Manager |
| **Policy Editor** | Can edit and publish policies | Compliance Team, Legal |
| **Task Assignee** | Can complete tasks, upload evidence | Individual contributors |
| **Viewer** | Read-only access to framework | Auditors, Consultants |

### Framework Lifecycle

```
1. Initialization → 2. Customization → 3. Implementation → 4. Monitoring → 5. Maintenance
      ↓                   ↓                    ↓                 ↓               ↓
   Create from       Customize         Implement          Track            Update
   templates         policies &        controls &        compliance        annually &
                     assign owners     complete tasks     metrics          after changes
```

---

## Initializing HIPAA Framework

### Step-by-Step Initialization

#### 1. Navigate to Framework Selection

Path: `/{org-id}/settings/frameworks` or during initial organization setup

#### 2. Select HIPAA Security Rule

- Check the "HIPAA Security Rule" checkbox
- Optionally select additional frameworks (SOC 2, ISO 27001) if needed
- Multi-framework selection will intelligently merge controls to avoid duplication

#### 3. Click "Initialize Framework"

**What Happens Behind the Scenes:**

```sql
-- CompAI executes the following:

-- 1. Create Framework Instance
INSERT INTO "FrameworkInstance" (organizationId, frameworkId, status)
VALUES ('{your-org-id}', 'frk_681fdd150f59a1560a66c89a', 'active');

-- 2. Create 77 Requirement Records
INSERT INTO "Requirement" (name, identifier, frameworkInstanceId, ...)
SELECT name, identifier, '{framework-instance-id}', ...
FROM "FrameworkEditorRequirement"
WHERE frameworkId = 'frk_681fdd150f59a1560a66c89a';

-- 3. Create 32 Control Records (from templates)
INSERT INTO "Control" (name, description, organizationId, controlTemplateId, ...)
SELECT name, description, '{your-org-id}', id, ...
FROM "FrameworkEditorControlTemplate"
WHERE id IN (
  SELECT DISTINCT "A"
  FROM "_FrameworkEditorControlTemplateToFrameworkEditorRequirement"
  WHERE "B" IN (SELECT id FROM "FrameworkEditorRequirement" WHERE frameworkId = 'frk_681fdd150f59a1560a66c89a')
);

-- 4. Map Controls to Requirements (108 mappings)
INSERT INTO "_ControlToRequirement" ("A", "B")
SELECT c.id, r.id
FROM "Control" c
JOIN "FrameworkEditorControlTemplate" ct ON c.controlTemplateId = ct.id
JOIN "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ctr ON ct.id = ctr."A"
JOIN "Requirement" r ON r.requirementTemplateId = ctr."B";

-- 5. Create 10 Policy Records (from templates)
INSERT INTO "Policy" (name, description, content, organizationId, policyTemplateId, ...)
SELECT name, description, ARRAY[content]::jsonb[], '{your-org-id}', id, ...
FROM "FrameworkEditorPolicyTemplate"
WHERE id IN (
  SELECT DISTINCT "B"
  FROM "_FrameworkEditorControlTemplateToFrameworkEditorPolicyTemplate"
  WHERE "A" IN (SELECT controlTemplateId FROM "Control" WHERE organizationId = '{your-org-id}')
);

-- 6. Link Policies to Controls (57 links)
INSERT INTO "_ControlToPolicy" ("A", "B")
SELECT c.id, p.id
FROM "Control" c
JOIN "FrameworkEditorControlTemplate" ct ON c.controlTemplateId = ct.id
JOIN "_FrameworkEditorControlTemplateToFrameworkEditorPolicyTemplate" ctpt ON ct.id = ctpt."A"
JOIN "Policy" p ON p.policyTemplateId = ctpt."B";

-- 7. Create 15 Task Records (from templates)
INSERT INTO "Task" (title, description, frequency, department, organizationId, taskTemplateId, ...)
SELECT name, description, frequency, department, '{your-org-id}', id, ...
FROM "FrameworkEditorTaskTemplate"
WHERE id IN (
  SELECT DISTINCT "B"
  FROM "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate"
  WHERE "A" IN (SELECT controlTemplateId FROM "Control" WHERE organizationId = '{your-org-id}')
);

-- 8. Link Tasks to Controls (36 links)
INSERT INTO "_ControlToTask" ("A", "B")
SELECT c.id, t.id
FROM "Control" c
JOIN "FrameworkEditorControlTemplate" ct ON c.controlTemplateId = ct.id
JOIN "_FrameworkEditorControlTemplateToFrameworkEditorTaskTemplate" cttt ON ct.id = cttt."A"
JOIN "Task" t ON t.taskTemplateId = cttt."B";
```

**Result:**
- 77 requirements covering complete HIPAA Security Rule
- 32 controls addressing all requirements (100% coverage)
- 10 HIPAA-specific policies (3 complete, 7 need content)
- 15 recurring tasks with evidence requirements
- All mappings established (controls ↔ requirements ↔ policies ↔ tasks)

#### 4. Post-Initialization Setup

After initialization, navigate to the framework dashboard to:
- [ ] Review all created controls
- [ ] Assign control owners
- [ ] Review policies (customize the 3 complete ones, complete the 7 incomplete)
- [ ] Assign task owners and set due dates
- [ ] Configure notifications and reminders

---

## Managing Controls

### Control Dashboard

Navigate to: `/{org-id}/frameworks/{framework-id}/controls`

**View Options:**
- **List View**: All controls in a table
- **By Category**: Grouped by Administrative, Physical, Technical Safeguards
- **By Status**: Not Started, In Progress, Implemented, Verified
- **By Owner**: Grouped by assigned control owner

### Control Statuses

| Status | Meaning | Next Action |
|--------|---------|-------------|
| **Not Started** | Control hasn't been initiated | Assign owner, plan implementation |
| **In Progress** | Implementation underway | Complete implementation tasks |
| **Implemented** | Control is in place | Upload evidence, request verification |
| **Verified** | Implementation verified with evidence | Maintain, monitor, update as needed |

### Assigning Control Owners

**Best Practice Ownership:**

| Control | Recommended Owner |
|---------|------------------|
| Business Associate Agreements | Legal/Compliance |
| HIPAA Training | HR/Training Manager |
| Workforce Security & Sanctions | HR Manager |
| Risk Assessment | HIPAA Security Officer |
| Audit Logging | IT Security Manager |
| Access Controls | IT Operations Manager |
| Encryption | IT Security Manager |
| Physical Security | Facilities Manager |
| Backup & Recovery | IT Operations Manager |
| Incident Response | HIPAA Security Officer |

**To Assign:**
1. Click on control name
2. Click "Edit Control"
3. Select owner from dropdown (workspace members)
4. Click "Save"
5. Owner receives notification

### Updating Control Status

**When to Update:**
- **Not Started → In Progress**: When implementation begins
- **In Progress → Implemented**: When control is fully deployed
- **Implemented → Verified**: When evidence is uploaded and reviewed

**How to Update:**
1. Navigate to control detail page
2. Click current status dropdown
3. Select new status
4. Add notes explaining the status change
5. Click "Update Status"

### Adding Implementation Notes

Document your implementation approach:
- What specific technology/tool was used
- Configuration details
- Deviations from standard procedure
- Challenges encountered
- Date of implementation
- Responsible personnel

---

## Managing Policies

### Policy Types in CompAI

**Complete Policies (3):**
1. Third-Party Risk Management & Business Associate Agreements
2. ePHI Audit Logging and Monitoring
3. ePHI Technical Safeguards and Data Integrity

These have full content ready for customization.

**Incomplete Policies (7):**
4. HIPAA Security Management Program
5. HIPAA Security Awareness and Workforce Training Program
6. Workforce Security, Access Management, and Sanction Policy
7. Physical and Environmental Security for ePHI
8. ePHI Backup, Recovery, and Media Management
9. Security Incident Response and HIPAA Breach Notification
10. Group Health Plan ePHI Requirements (if applicable)

These have structure and guidance but need content completion by compliance writer.

### Policy Lifecycle

```
Draft → Review → Approved → Published → Active → Under Review → Updated → Archived
```

### Editing Policies

Navigate to: `/{org-id}/policies/{policy-id}`

**Policy Editor Features:**
- Rich text editor (Tiptap)
- Handlebars variable replacement ({{COMPANY}}, {{CRITICAL}}, etc.)
- Conditional sections ({{#if hipaa}}, {{#if soc2}})
- Version control (track all changes)
- Comment and approval workflow
- PDF export

**To Edit Policy:**
1. Click "Edit Policy"
2. Make changes in editor
3. Replace placeholders:
   - {{COMPANY}} → Your organization name
   - {{CRITICAL}} → List of critical systems
   - {{DATA}} → Types of data you handle
   - {{DEVICES}} → Devices in use
4. Click "Save Draft"
5. Request review from stakeholders

### Policy Approval Workflow

**Recommended Workflow:**
1. **Policy Editor** drafts/updates policy
2. **Department Reviewers** review and comment (IT, HR, Legal)
3. **Compliance Manager** addresses comments, finalizes
4. **Legal Counsel** reviews for regulatory compliance
5. **Executive** (CEO, HIPAA Security Officer) approves
6. **Policy Editor** publishes to workforce

**To Submit for Approval:**
1. Navigate to policy
2. Click "Request Approval"
3. Select approvers (can set multiple stages)
4. Add approval message/context
5. Click "Submit"
6. Approvers receive notification

### Publishing Policies

**Before Publishing:**
- [ ] All placeholders replaced
- [ ] Legal review complete
- [ ] Executive approval obtained
- [ ] Procedures tested and validated

**To Publish:**
1. Click "Publish Policy"
2. Select distribution method:
   - Email to all workforce members
   - Post to internal portal
   - Require electronic acknowledgment
3. Set effective date
4. Click "Publish"

**Post-Publication:**
- Policy status changes to "Active"
- Workforce receives notification
- Acknowledgment tracking begins
- Version is locked (new edits create new version)

### Policy Review Schedule

**HIPAA Requirement:** Policies must be reviewed regularly (recommended annually)

**To Set Review Schedule:**
1. Navigate to policy
2. Click "Policy Settings"
3. Set review frequency (e.g., "Annually")
4. Set next review date
5. Assign reviewer
6. Click "Save"

CompAI will automatically send reminders 30 days before review due date.

---

## Managing Tasks

### Task Dashboard

Navigate to: `/{org-id}/tasks`

**Task Frequencies:**
- **Monthly (2 tasks)**: ePHI Access Log Review, ePHI Backup Testing
- **Quarterly (8 tasks)**: BAA Inventory, Access Review, Facility Audit, Device Inventory, Integrity Verification, Access Recertification, Encryption Verification, Policy Review
- **Yearly (5 tasks)**: HIPAA Training, Risk Assessment, DR Test, Contingency Plan Test, Addressable Spec Review

### Task Assignment

**To Assign Task:**
1. Navigate to task detail page
2. Click "Assign"
3. Select assignee from dropdown
4. Set due date (auto-calculated from frequency)
5. Add instructions/context
6. Click "Save"

**Assignee receives:**
- Email notification
- Calendar invite
- Task appears in their task list

### Task Templates and Evidence Requirements

Each task includes specific evidence requirements:

**Example - Monthly ePHI Access Log Review:**
```
Evidence Required:
- Log review reports
- Anomaly findings
- Investigation notes
- SIEM dashboards

AI Potential: Very High (90%)
- Automated log analysis
- SIEM integration
- Anomaly detection
```

**To View Task Evidence Requirements:**
1. Navigate to task
2. View "Description" field
3. Look for "EVIDENCE:" section
4. Look for "AI POTENTIAL:" section

### Task Completion Workflow

**Process:**
1. Task assignee receives notification
2. Assignee performs task activities
3. Assignee collects evidence (documents, screenshots, logs)
4. Assignee uploads evidence to task
5. Assignee marks task as "Complete"
6. Task owner or compliance manager reviews
7. If approved, task status changes to "Completed"
8. Next occurrence is auto-scheduled based on frequency

**To Complete Task:**
1. Navigate to task
2. Click "Upload Evidence"
3. Drag and drop files or browse
4. Add completion notes
5. Click "Mark Complete"

### Recurring Task Management

**Auto-Scheduling:**
CompAI automatically creates next occurrence when current task is completed:

- Monthly tasks: Creates next month's task
- Quarterly tasks: Creates next quarter's task
- Yearly tasks: Creates next year's task

**To Modify Recurring Schedule:**
1. Navigate to task
2. Click "Edit Recurrence"
3. Adjust frequency, due date, or assignee for future occurrences
4. Click "Save"

### Task Reminders

**Default Reminders:**
- 7 days before due date
- 3 days before due date
- Day of due date
- 1 day overdue (then daily until complete)

**To Customize Reminders:**
1. Navigate to task
2. Click "Reminder Settings"
3. Adjust reminder schedule
4. Select notification method (email, in-app, SMS)
5. Click "Save"

---

## Requirement Mapping

### Understanding the Mapping

Every HIPAA requirement is addressed by one or more controls:

```
Requirement: 164.308(a)(1)(ii)(A) - Risk Analysis
    ↓
Controls:
    - HIPAA Security Risk Analysis and Management
    - HIPAA Security Evaluation & Risk Assessment
    ↓
Policies:
    - HIPAA Security Management Program
    ↓
Tasks:
    - Annual HIPAA Security Risk Assessment and Evaluation
```

### Viewing Requirement Coverage

Navigate to: `/{org-id}/frameworks/{framework-id}/requirements`

**Requirement View Shows:**
- Requirement citation (e.g., 164.308(a)(1)(ii)(A))
- Requirement text
- Implementation specification (Required vs. Addressable)
- Mapped controls (click to view control details)
- Implementation status
- Evidence count

### Coverage Report

Navigate to: `/{org-id}/frameworks/{framework-id}/reports/coverage`

**Report Shows:**
- Total requirements: 77
- Requirements with controls: Should be 77 (100%)
- Requirements without controls: Should be 0
- Controls per requirement (average)
- Requirements by status

**Actions if Coverage < 100%:**
1. Identify unmapped requirements
2. Determine if existing control should be mapped
3. Or create new control if needed
4. Update mapping in database (may require admin/developer)

### Exporting Compliance Matrix

**To Export:**
1. Navigate to framework dashboard
2. Click "Export Compliance Matrix"
3. Select format (CSV, Excel, PDF)
4. Matrix shows: Requirement → Controls → Implementation Status → Evidence

**Use Cases:**
- Share with auditors
- Present to executive leadership
- Gap analysis
- Vendor assessments

---

## Evidence Management

### Evidence Types

| Evidence Type | Examples | Storage Location |
|--------------|----------|------------------|
| **Documents** | Policies, procedures, plans | CompAI Policy Library |
| **Records** | Training certificates, BAAs, logs | Uploaded to controls/tasks |
| **Screenshots** | System configurations, settings | Uploaded to controls/tasks |
| **Reports** | Risk assessment, vulnerability scans | Uploaded to controls/tasks |
| **Logs** | Audit logs, access logs | Centralized SIEM or uploaded extracts |
| **Attestations** | Manager sign-offs, certifications | Uploaded to tasks |

### Uploading Evidence

**To Upload to Control:**
1. Navigate to control detail page
2. Click "Evidence" tab
3. Click "Upload Evidence"
4. Drag and drop files
5. Add description (what it demonstrates)
6. Add date evidence was created
7. Click "Save"

**To Upload to Task:**
1. Navigate to task detail page
2. Complete task activities
3. Click "Upload Evidence"
4. Drag and drop files
5. Add completion notes
6. Click "Mark Complete"

### Evidence Retention

**HIPAA Requirement:** 6 years retention

**CompAI Retention Policy:**
- All evidence stored indefinitely by default
- Automatic backup to secure cloud storage
- Can configure custom retention policies per organization

**To View Evidence Age:**
1. Navigate to evidence library
2. Filter by "Older than X years"
3. Review for archival or deletion

### Evidence Organization

**Best Practices:**
- Use consistent naming conventions (e.g., "2024-Q4-BAA-Inventory.xlsx")
- Tag evidence by control, task, or category
- Include date in file name
- Use folders/categories in evidence library
- Link evidence to multiple controls/tasks if applicable

**Evidence Tagging:**
- Control name (e.g., "Business Associate Agreements")
- Date or quarter (e.g., "2024-Q4")
- Evidence type (e.g., "Training Records", "Audit Logs")
- Department (e.g., "IT", "HR", "Compliance")

---

## Reporting and Dashboards

### Framework Dashboard

Navigate to: `/{org-id}/frameworks/{framework-id}`

**Key Metrics:**
- Overall compliance percentage
- Requirements coverage (should be 100%)
- Controls by status (Not Started, In Progress, Implemented, Verified)
- Policies by status (Draft, Under Review, Published, Active)
- Tasks due this month
- Tasks overdue
- Evidence count
- Last risk assessment date

### Control Status Report

Shows:
- Total controls: 32
- Implemented: X
- In Progress: X
- Not Started: X
- Compliance %: (Implemented / Total) * 100

**Actions by Status:**
- **Not Started**: Assign owner, create implementation plan
- **In Progress**: Follow up on progress, remove blockers
- **Implemented**: Upload evidence, request verification
- **Verified**: Monitor, maintain

### Task Completion Report

Shows:
- Tasks due this period
- Tasks completed on time
- Tasks overdue
- Completion rate %
- Average time to completion

**Filters:**
- By assignee
- By frequency (monthly, quarterly, yearly)
- By department
- By status

### Audit Readiness Score

CompAI calculates an audit readiness score based on:
- % requirements with controls: 25 points
- % controls with evidence: 25 points
- % policies published: 20 points
- % tasks completed on time: 15 points
- Risk assessment recency: 10 points
- Training completion rate: 5 points

**Score Interpretation:**
- 90-100: Audit Ready
- 75-89: Minor gaps, address before audit
- 60-74: Significant gaps, improvement needed
- <60: Not audit ready, major work required

---

## Updating the Framework

### When to Update

Update the framework when:
- **Annually**: Regular review and update (HIPAA requirement)
- **After Major Changes**: System migrations, mergers, new services
- **Regulatory Changes**: HHS updates HIPAA Security Rule
- **Post-Incident**: After security incident or breach
- **Post-Audit**: OCR identifies gaps or issues

### Annual Framework Evaluation

**REQUIRED by 45 CFR § 164.308(a)(8)**

**Process:**
1. Schedule evaluation (typically Q4 or Q1)
2. Review all policies for accuracy
3. Review all controls for continued effectiveness
4. Update risk assessment
5. Review all requirements for continued coverage
6. Update policies/controls/tasks as needed
7. Document evaluation and changes made

**Checklist:**
- [ ] All policies reviewed and updated
- [ ] Risk assessment current (within 12 months)
- [ ] All controls verified as still effective
- [ ] New risks identified and addressed
- [ ] Environmental/operational changes documented
- [ ] Training materials updated
- [ ] Evaluation documented with date and findings

### Adding New Controls

**When Needed:**
- Identified gap in risk assessment
- New regulatory requirement
- New technology or service
- Auditor recommendation

**To Add Custom Control:**
1. Navigate to Controls
2. Click "Add Control"
3. Enter control name and description
4. Select category (Administrative, Physical, Technical)
5. Link to requirements it addresses
6. Assign owner
7. Set implementation target date
8. Click "Save"

### Updating After OCR Guidance

**Process:**
1. Review HHS/OCR guidance announcement
2. Identify affected requirements/controls
3. Assess current implementation
4. Determine if updates needed
5. Update policies/procedures
6. Retrain workforce if needed
7. Document changes and rationale

---

## Troubleshooting

### Common Issues

#### Issue: Framework Initialization Failed

**Symptoms**: Error message during initialization, incomplete framework

**Solutions:**
1. Check database connectivity
2. Verify FrameworkEditorControlTemplate records exist
3. Verify FrameworkEditorRequirement records exist
4. Check for orphaned records in junction tables
5. Re-run initialization from clean state

**Workaround:**
```sql
-- Manual initialization (execute in database)
-- See HIPAA_QUICK_START_GUIDE.md "Initializing HIPAA Framework" section
```

#### Issue: Control Not Showing in Dashboard

**Symptoms**: Control exists but doesn't appear in UI

**Solutions:**
1. Check control's `organizationId` matches your org
2. Verify control is linked to a requirement
3. Clear browser cache
4. Check control's `isArchived` flag is false

#### Issue: Task Not Auto-Scheduling

**Symptoms**: Recurring task doesn't create next occurrence after completion

**Solutions:**
1. Verify task has `frequency` set (monthly, quarterly, yearly)
2. Check task was marked "Completed" (not just closed)
3. Verify task has `taskTemplateId` linking to template
4. Check background job processing is running

#### Issue: Policy Variables Not Replacing

**Symptoms**: {{COMPANY}} still shows in published policy

**Solutions:**
1. Verify variables are in Context table
2. Use exact variable names (case-sensitive)
3. Re-publish policy after adding context
4. Check variable syntax in policy content

#### Issue: Evidence Upload Failing

**Symptoms**: File upload error, evidence not saving

**Solutions:**
1. Check file size (may have limit)
2. Check file type restrictions
3. Verify sufficient storage quota
4. Check network connectivity
5. Try different browser

#### Issue: Requirements Not Showing as Addressed

**Symptoms**: Requirement shows "No Controls Mapped"

**Solutions:**
1. Verify control exists in organization
2. Check `_ControlToRequirement` junction table
3. Verify requirement's `frameworkInstanceId` is correct
4. Re-run requirement mapping script

### Support Contacts

**Technical Support:**
- Email: support@compai.com
- Documentation: [docs.compai.com](https://docs.compai.com)

**HIPAA Compliance Questions:**
- Consult your HIPAA Security Officer
- HHS OCR: https://www.hhs.gov/hipaa/for-professionals/index.html

**Database/API Issues:**
- Check GitHub: [github.com/marcmontecalvo/CompAI](https://github.com/marcmontecalvo/CompAI)
- File issue with detailed error logs

---

## Appendix: Database Schema Reference

### Key Tables

**FrameworkInstance**
- Links organization to framework (e.g., HIPAA)
- Status: active, inactive, archived

**Requirement**
- Individual HIPAA requirements (77 total)
- Links to FrameworkInstance

**Control**
- Organization-specific control implementations (32 for HIPAA)
- Links to ControlTemplate
- Owned by specific users

**Policy**
- Organization-specific policy documents (10 for HIPAA)
- Links to PolicyTemplate
- Versioned content

**Task**
- Recurring compliance tasks (15 for HIPAA)
- Links to TaskTemplate
- Assigned to users

**Junction Tables (Many-to-Many Relationships)**
- `_ControlToRequirement`: Which controls address which requirements
- `_ControlToPolicy`: Which policies support which controls
- `_ControlToTask`: Which tasks verify which controls

---

*Last Updated: 2025-11-07*
*Version: 1.0*
*For framework administration questions, contact your organization's HIPAA Security Officer or Compliance Manager*
