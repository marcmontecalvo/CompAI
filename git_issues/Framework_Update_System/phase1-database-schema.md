# Phase 1: Database Schema Updates

**Status**: Not Started
**Est. Effort**: 1-2 weeks
**Dependencies**: None
**Blockers**: None

---

## Overview

Add versioning, sync tracking, and update campaign management tables to support the framework update system. This phase establishes the data model foundation for tracking template versions, detecting customizations, and managing update rollouts.

---

## Objectives

- ✅ Add version tracking to framework templates
- ✅ Add sync tracking to control/policy/task instances
- ✅ Create update campaign management tables
- ✅ Add organization update preferences
- ✅ Implement change notification tracking
- ✅ Create database migrations
- ✅ Backfill existing data
- ✅ Write rollback procedures

---

## Database Schema Changes

### 1. Framework Template Versioning

**File**: `apps/app/prisma/schema.prisma`

**Add to `FrameworkEditorFramework`**:

```prisma
model FrameworkEditorFramework {
  id          String  @id
  name        String
  version     String  // Keep existing field for display
  description String
  visible     Boolean @default(false)
  createdAt   DateTime @default(now())
  updatedAt   DateTime @default(now()) @updatedAt

  // NEW: Semantic versioning fields
  majorVersion Int      @default(1)
  minorVersion Int      @default(0)
  patchVersion Int      @default(0)

  // NEW: Change tracking
  changelog    String?  // Markdown changelog
  publishedAt  DateTime?  // When this version was published
  publishedBy  String?  // User ID who published

  // NEW: Previous version tracking
  previousVersion String?  // e.g., "1.0.0" before this version

  requirements       FrameworkEditorRequirement[]
  frameworkInstances FrameworkInstance[]
  updateCampaigns    FrameworkUpdateCampaign[]  // NEW

  @@index([visible])
  @@index([publishedAt])
}
```

**Rationale**: Semantic versioning allows clear communication about breaking changes (major), new features (minor), and bug fixes (patch). `publishedAt` enables "draft" template changes that don't trigger updates until published.

---

### 2. Control Instance Sync Tracking

**Add to `Control` model**:

```prisma
model Control {
  id                String @id
  name              String
  description       String
  lastReviewDate    DateTime?
  nextReviewDate    DateTime?
  organizationId    String
  controlTemplateId String?

  // NEW: Sync and customization tracking
  isCustomized     Boolean   @default(false)
  customizedFields String[]  @default([])  // e.g., ["name", "description"]
  lastSyncedAt     DateTime?  // Last sync with template
  templateVersion  String?    // Template version when last synced (e.g., "1.2.3")
  syncStatus       SyncStatus @default(synced)  // NEW ENUM

  organization       Organization
  controlTemplate    FrameworkEditorControlTemplate?
  requirementsMapped RequirementMap[]
  tasks              Task[]
  policies           Policy[]

  @@index([organizationId])
  @@index([controlTemplateId])
  @@index([syncStatus])  // NEW: For finding conflicts
  @@index([isCustomized])  // NEW: For filtering customized items
}
```

**Add new enum**:

```prisma
enum SyncStatus {
  synced        // In sync with template
  outdated      // Template has updates, no conflicts
  conflict      // Template has updates, instance is customized
  detached      // Permanently detached from template
}
```

---

### 3. Policy Instance Sync Tracking

**Add to `Policy` model**:

```prisma
model Policy {
  id               String @id
  name             String
  description      String?
  status           PolicyStatus @default(draft)
  content          Json[]
  frequency        Frequency?
  department       Departments?
  isRequiredToSign Boolean @default(true)
  signedBy         String[] @default([])
  reviewDate       DateTime?
  isArchived       Boolean @default(false)
  displayFormat    PolicyDisplayFormat @default(EDITOR)
  pdfUrl           String?
  createdAt        DateTime @default(now())
  updatedAt        DateTime @updatedAt
  lastArchivedAt   DateTime?
  lastPublishedAt  DateTime?
  organizationId   String
  assigneeId       String?
  approverId       String?
  policyTemplateId String?

  // NEW: Sync and customization tracking
  isCustomized     Boolean   @default(false)
  customizedFields String[]  @default([])
  lastSyncedAt     DateTime?
  templateVersion  String?
  syncStatus       SyncStatus @default(synced)

  organization   Organization
  policyTemplate FrameworkEditorPolicyTemplate?
  controls       Control[]

  @@index([organizationId])
  @@index([policyTemplateId])
  @@index([syncStatus])  // NEW
  @@index([isCustomized])  // NEW
}
```

---

### 4. Task Instance Sync Tracking

**Add to `Task` model**:

```prisma
model Task {
  id              String @id
  title           String
  description     String
  status          TaskStatus @default(todo)
  frequency       TaskFrequency?
  department      Departments?
  order           Int @default(0)
  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt
  lastCompletedAt DateTime?
  reviewDate      DateTime?
  organizationId  String
  assigneeId      String?
  taskTemplateId  String?

  // NEW: Sync and customization tracking
  isCustomized     Boolean   @default(false)
  customizedFields String[]  @default([])
  lastSyncedAt     DateTime?
  templateVersion  String?
  syncStatus       SyncStatus @default(synced)

  organization Organization
  taskTemplate FrameworkEditorTaskTemplate?
  controls     Control[]
  vendors      Vendor[]
  risks        Risk[]
  evidenceAutomations EvidenceAutomation[]

  @@index([organizationId])
  @@index([taskTemplateId])
  @@index([syncStatus])  // NEW
  @@index([isCustomized])  // NEW
}
```

**Critical Preservation Fields**: When updating tasks, these fields MUST be preserved:
- `status`, `lastCompletedAt`, `reviewDate` (completion tracking)
- `assigneeId`, `order` (user configuration)
- `evidenceAutomations` (evidence links)

---

### 5. Update Campaign Management

**New table for tracking update campaigns**:

```prisma
model FrameworkUpdateCampaign {
  id                String   @id @default(cuid())
  frameworkId       String
  fromVersion       String   // e.g., "1.0.0"
  toVersion         String   // e.g., "1.1.0"
  status            UpdateCampaignStatus @default(draft)

  // Scheduling
  scheduledAt       DateTime?
  startedAt         DateTime?
  completedAt       DateTime?

  // Statistics
  affectedOrgCount  Int      @default(0)
  successCount      Int      @default(0)
  conflictCount     Int      @default(0)
  errorCount        Int      @default(0)

  // Metadata
  changelog         String?  // Markdown changelog for this update
  createdBy         String   // User ID who created campaign
  createdAt         DateTime @default(now())
  updatedAt         DateTime @updatedAt

  framework FrameworkEditorFramework @relation(fields: [frameworkId], references: [id], onDelete: Cascade)
  logs      FrameworkUpdateLog[]

  @@index([frameworkId])
  @@index([status])
  @@index([scheduledAt])
}

enum UpdateCampaignStatus {
  draft        // Being prepared
  scheduled    // Scheduled for future execution
  in_progress  // Currently running
  completed    // Finished successfully
  failed       // Finished with errors
  cancelled    // Manually cancelled
}
```

---

### 6. Per-Organization Update Logs

**New table for tracking update results per organization**:

```prisma
model FrameworkUpdateLog {
  id                String   @id @default(cuid())
  campaignId        String
  organizationId    String
  status            UpdateLogStatus

  // Details
  controlsUpdated   Int      @default(0)
  controlsConflict  Int      @default(0)
  policiesUpdated   Int      @default(0)
  policiesConflict  Int      @default(0)
  tasksUpdated      Int      @default(0)
  tasksConflict     Int      @default(0)

  conflictDetails   Json?    // Detailed conflict information
  errorMessage      String?

  // Timestamps
  startedAt         DateTime?
  appliedAt         DateTime?
  failedAt          DateTime?

  campaign     FrameworkUpdateCampaign @relation(fields: [campaignId], references: [id], onDelete: Cascade)
  organization Organization @relation(fields: [organizationId], references: [id], onDelete: Cascade)

  @@unique([campaignId, organizationId])
  @@index([organizationId])
  @@index([status])
}

enum UpdateLogStatus {
  pending    // Not yet processed
  applied    // Successfully applied
  conflict   // Has conflicts needing review
  skipped    // Skipped (e.g., maintenance window not met)
  failed     // Failed with error
}
```

---

### 7. Organization Update Preferences

**Add to `Organization` model**:

```prisma
model Organization {
  id          String @id
  name        String
  slug        String @unique
  // ... existing fields ...

  // NEW: Update preferences
  maintenanceWindow      Json?    // { day: "sunday", hour: 2, timezone: "America/New_York" }
  autoApplyUpdates       Boolean  @default(false)  // Auto-apply non-conflicting updates
  updateNotificationDays Int      @default(7)      // Notify N days before scheduled update

  // ... existing relations ...
  updateLogs      FrameworkUpdateLog[]  // NEW
}
```

**maintenanceWindow JSON structure**:
```json
{
  "day": "sunday",        // or "monday", "tuesday", etc.
  "hour": 2,              // 0-23 (hour in org's timezone)
  "timezone": "America/New_York"
}
```

---

### 8. Change Notification Tracking

**New table for in-app notification persistence**:

```prisma
model FrameworkChangeNotification {
  id             String   @id @default(cuid())
  organizationId String
  campaignId     String

  // Notification details
  title          String
  message        String
  changeCount    Int      @default(0)
  conflictCount  Int      @default(0)

  // Specific changes
  changedControls String[] @default([])  // Control IDs
  changedPolicies String[] @default([])  // Policy IDs
  changedTasks    String[] @default([])  // Task IDs

  // Status
  isRead         Boolean  @default(false)
  isDismissed    Boolean  @default(false)

  createdAt      DateTime @default(now())
  readAt         DateTime?
  dismissedAt    DateTime?

  organization Organization @relation(fields: [organizationId], references: [id], onDelete: Cascade)
  campaign     FrameworkUpdateCampaign @relation(fields: [campaignId], references: [id], onDelete: Cascade)

  @@index([organizationId])
  @@index([isRead])
  @@index([createdAt])
}
```

**Add relation to Organization**:
```prisma
model Organization {
  // ... existing fields ...
  changeNotifications FrameworkChangeNotification[]  // NEW
}
```

**Add relation to FrameworkUpdateCampaign**:
```prisma
model FrameworkUpdateCampaign {
  // ... existing fields ...
  notifications FrameworkChangeNotification[]  // NEW
}
```

---

## Migration Strategy

### Migration 1: Add Version Fields to Templates

**File**: `apps/app/prisma/migrations/[timestamp]_add_framework_versioning/migration.sql`

```sql
-- Add version tracking fields to FrameworkEditorFramework
ALTER TABLE "FrameworkEditorFramework" ADD COLUMN "majorVersion" INTEGER NOT NULL DEFAULT 1;
ALTER TABLE "FrameworkEditorFramework" ADD COLUMN "minorVersion" INTEGER NOT NULL DEFAULT 0;
ALTER TABLE "FrameworkEditorFramework" ADD COLUMN "patchVersion" INTEGER NOT NULL DEFAULT 0;
ALTER TABLE "FrameworkEditorFramework" ADD COLUMN "changelog" TEXT;
ALTER TABLE "FrameworkEditorFramework" ADD COLUMN "publishedAt" TIMESTAMP(3);
ALTER TABLE "FrameworkEditorFramework" ADD COLUMN "publishedBy" TEXT;
ALTER TABLE "FrameworkEditorFramework" ADD COLUMN "previousVersion" TEXT;

-- Add indexes
CREATE INDEX "FrameworkEditorFramework_publishedAt_idx" ON "FrameworkEditorFramework"("publishedAt");
```

---

### Migration 2: Add Sync Tracking to Instances

**File**: `apps/app/prisma/migrations/[timestamp]_add_sync_tracking/migration.sql`

```sql
-- Create SyncStatus enum
CREATE TYPE "SyncStatus" AS ENUM ('synced', 'outdated', 'conflict', 'detached');

-- Add sync fields to Control
ALTER TABLE "Control" ADD COLUMN "isCustomized" BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE "Control" ADD COLUMN "customizedFields" TEXT[] DEFAULT ARRAY[]::TEXT[];
ALTER TABLE "Control" ADD COLUMN "lastSyncedAt" TIMESTAMP(3);
ALTER TABLE "Control" ADD COLUMN "templateVersion" TEXT;
ALTER TABLE "Control" ADD COLUMN "syncStatus" "SyncStatus" NOT NULL DEFAULT 'synced';

-- Add indexes
CREATE INDEX "Control_syncStatus_idx" ON "Control"("syncStatus");
CREATE INDEX "Control_isCustomized_idx" ON "Control"("isCustomized");

-- Add sync fields to Policy
ALTER TABLE "Policy" ADD COLUMN "isCustomized" BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE "Policy" ADD COLUMN "customizedFields" TEXT[] DEFAULT ARRAY[]::TEXT[];
ALTER TABLE "Policy" ADD COLUMN "lastSyncedAt" TIMESTAMP(3);
ALTER TABLE "Policy" ADD COLUMN "templateVersion" TEXT;
ALTER TABLE "Policy" ADD COLUMN "syncStatus" "SyncStatus" NOT NULL DEFAULT 'synced';

CREATE INDEX "Policy_syncStatus_idx" ON "Policy"("syncStatus");
CREATE INDEX "Policy_isCustomized_idx" ON "Policy"("isCustomized");

-- Add sync fields to Task
ALTER TABLE "Task" ADD COLUMN "isCustomized" BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE "Task" ADD COLUMN "customizedFields" TEXT[] DEFAULT ARRAY[]::TEXT[];
ALTER TABLE "Task" ADD COLUMN "lastSyncedAt" TIMESTAMP(3);
ALTER TABLE "Task" ADD COLUMN "templateVersion" TEXT;
ALTER TABLE "Task" ADD COLUMN "syncStatus" "SyncStatus" NOT NULL DEFAULT 'synced';

CREATE INDEX "Task_syncStatus_idx" ON "Task"("syncStatus");
CREATE INDEX "Task_isCustomized_idx" ON "Task"("isCustomized");
```

---

### Migration 3: Create Update Campaign Tables

**File**: `apps/app/prisma/migrations/[timestamp]_create_update_campaign_tables/migration.sql`

```sql
-- Create enums
CREATE TYPE "UpdateCampaignStatus" AS ENUM ('draft', 'scheduled', 'in_progress', 'completed', 'failed', 'cancelled');
CREATE TYPE "UpdateLogStatus" AS ENUM ('pending', 'applied', 'conflict', 'skipped', 'failed');

-- Create FrameworkUpdateCampaign table
CREATE TABLE "FrameworkUpdateCampaign" (
    "id" TEXT NOT NULL,
    "frameworkId" TEXT NOT NULL,
    "fromVersion" TEXT NOT NULL,
    "toVersion" TEXT NOT NULL,
    "status" "UpdateCampaignStatus" NOT NULL DEFAULT 'draft',
    "scheduledAt" TIMESTAMP(3),
    "startedAt" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3),
    "affectedOrgCount" INTEGER NOT NULL DEFAULT 0,
    "successCount" INTEGER NOT NULL DEFAULT 0,
    "conflictCount" INTEGER NOT NULL DEFAULT 0,
    "errorCount" INTEGER NOT NULL DEFAULT 0,
    "changelog" TEXT,
    "createdBy" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FrameworkUpdateCampaign_pkey" PRIMARY KEY ("id")
);

-- Create FrameworkUpdateLog table
CREATE TABLE "FrameworkUpdateLog" (
    "id" TEXT NOT NULL,
    "campaignId" TEXT NOT NULL,
    "organizationId" TEXT NOT NULL,
    "status" "UpdateLogStatus" NOT NULL,
    "controlsUpdated" INTEGER NOT NULL DEFAULT 0,
    "controlsConflict" INTEGER NOT NULL DEFAULT 0,
    "policiesUpdated" INTEGER NOT NULL DEFAULT 0,
    "policiesConflict" INTEGER NOT NULL DEFAULT 0,
    "tasksUpdated" INTEGER NOT NULL DEFAULT 0,
    "tasksConflict" INTEGER NOT NULL DEFAULT 0,
    "conflictDetails" JSONB,
    "errorMessage" TEXT,
    "startedAt" TIMESTAMP(3),
    "appliedAt" TIMESTAMP(3),
    "failedAt" TIMESTAMP(3),

    CONSTRAINT "FrameworkUpdateLog_pkey" PRIMARY KEY ("id")
);

-- Add foreign keys
ALTER TABLE "FrameworkUpdateCampaign" ADD CONSTRAINT "FrameworkUpdateCampaign_frameworkId_fkey"
    FOREIGN KEY ("frameworkId") REFERENCES "FrameworkEditorFramework"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "FrameworkUpdateLog" ADD CONSTRAINT "FrameworkUpdateLog_campaignId_fkey"
    FOREIGN KEY ("campaignId") REFERENCES "FrameworkUpdateCampaign"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "FrameworkUpdateLog" ADD CONSTRAINT "FrameworkUpdateLog_organizationId_fkey"
    FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Add indexes
CREATE INDEX "FrameworkUpdateCampaign_frameworkId_idx" ON "FrameworkUpdateCampaign"("frameworkId");
CREATE INDEX "FrameworkUpdateCampaign_status_idx" ON "FrameworkUpdateCampaign"("status");
CREATE INDEX "FrameworkUpdateCampaign_scheduledAt_idx" ON "FrameworkUpdateCampaign"("scheduledAt");

CREATE UNIQUE INDEX "FrameworkUpdateLog_campaignId_organizationId_key" ON "FrameworkUpdateLog"("campaignId", "organizationId");
CREATE INDEX "FrameworkUpdateLog_organizationId_idx" ON "FrameworkUpdateLog"("organizationId");
CREATE INDEX "FrameworkUpdateLog_status_idx" ON "FrameworkUpdateLog"("status");
```

---

### Migration 4: Add Organization Update Preferences

**File**: `apps/app/prisma/migrations/[timestamp]_add_org_update_preferences/migration.sql`

```sql
-- Add update preference fields to Organization
ALTER TABLE "Organization" ADD COLUMN "maintenanceWindow" JSONB;
ALTER TABLE "Organization" ADD COLUMN "autoApplyUpdates" BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE "Organization" ADD COLUMN "updateNotificationDays" INTEGER NOT NULL DEFAULT 7;
```

---

### Migration 5: Create Change Notification Table

**File**: `apps/app/prisma/migrations/[timestamp]_create_change_notification_table/migration.sql`

```sql
-- Create FrameworkChangeNotification table
CREATE TABLE "FrameworkChangeNotification" (
    "id" TEXT NOT NULL,
    "organizationId" TEXT NOT NULL,
    "campaignId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "changeCount" INTEGER NOT NULL DEFAULT 0,
    "conflictCount" INTEGER NOT NULL DEFAULT 0,
    "changedControls" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "changedPolicies" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "changedTasks" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "isDismissed" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "readAt" TIMESTAMP(3),
    "dismissedAt" TIMESTAMP(3),

    CONSTRAINT "FrameworkChangeNotification_pkey" PRIMARY KEY ("id")
);

-- Add foreign keys
ALTER TABLE "FrameworkChangeNotification" ADD CONSTRAINT "FrameworkChangeNotification_organizationId_fkey"
    FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "FrameworkChangeNotification" ADD CONSTRAINT "FrameworkChangeNotification_campaignId_fkey"
    FOREIGN KEY ("campaignId") REFERENCES "FrameworkUpdateCampaign"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Add indexes
CREATE INDEX "FrameworkChangeNotification_organizationId_idx" ON "FrameworkChangeNotification"("organizationId");
CREATE INDEX "FrameworkChangeNotification_isRead_idx" ON "FrameworkChangeNotification"("isRead");
CREATE INDEX "FrameworkChangeNotification_createdAt_idx" ON "FrameworkChangeNotification"("createdAt");
```

---

## Data Backfill Strategy

After migrations are applied, backfill existing data:

**File**: `apps/app/src/scripts/backfill-framework-sync-data.ts`

```typescript
import { db } from '@/lib/db';

async function backfillFrameworkSyncData() {
  console.log('Starting framework sync data backfill...');

  // 1. Set initial version for all existing frameworks
  await db.frameworkEditorFramework.updateMany({
    where: { majorVersion: 0 }, // Only update if not set
    data: {
      majorVersion: 1,
      minorVersion: 0,
      patchVersion: 0,
      publishedAt: new Date(),
    }
  });

  // 2. Set lastSyncedAt for all existing controls
  const controls = await db.control.findMany({
    where: { lastSyncedAt: null },
    select: { id: true, createdAt: true }
  });

  for (const control of controls) {
    await db.control.update({
      where: { id: control.id },
      data: {
        lastSyncedAt: control.createdAt,
        templateVersion: '1.0.0',
        syncStatus: 'synced'
      }
    });
  }

  // 3. Detect existing customizations
  const controlsWithTemplates = await db.control.findMany({
    where: { controlTemplateId: { not: null } },
    include: { controlTemplate: true }
  });

  for (const control of controlsWithTemplates) {
    const customizedFields = [];

    if (control.name !== control.controlTemplate.name) {
      customizedFields.push('name');
    }

    if (control.description !== control.controlTemplate.description) {
      customizedFields.push('description');
    }

    if (customizedFields.length > 0) {
      await db.control.update({
        where: { id: control.id },
        data: {
          isCustomized: true,
          customizedFields,
          syncStatus: 'synced' // Already in sync, just customized
        }
      });
    }
  }

  // 4. Repeat for policies and tasks
  // (Similar logic as controls)

  console.log('Backfill complete!');
}

// Run: npx tsx apps/app/src/scripts/backfill-framework-sync-data.ts
backfillFrameworkSyncData().catch(console.error);
```

---

## Rollback Procedures

### Rollback Migration 5 (Change Notifications)

```sql
DROP TABLE "FrameworkChangeNotification";
```

### Rollback Migration 4 (Org Preferences)

```sql
ALTER TABLE "Organization" DROP COLUMN "maintenanceWindow";
ALTER TABLE "Organization" DROP COLUMN "autoApplyUpdates";
ALTER TABLE "Organization" DROP COLUMN "updateNotificationDays";
```

### Rollback Migration 3 (Update Campaign Tables)

```sql
DROP TABLE "FrameworkUpdateLog";
DROP TABLE "FrameworkUpdateCampaign";
DROP TYPE "UpdateCampaignStatus";
DROP TYPE "UpdateLogStatus";
```

### Rollback Migration 2 (Sync Tracking)

```sql
ALTER TABLE "Control" DROP COLUMN "isCustomized";
ALTER TABLE "Control" DROP COLUMN "customizedFields";
ALTER TABLE "Control" DROP COLUMN "lastSyncedAt";
ALTER TABLE "Control" DROP COLUMN "templateVersion";
ALTER TABLE "Control" DROP COLUMN "syncStatus";

ALTER TABLE "Policy" DROP COLUMN "isCustomized";
ALTER TABLE "Policy" DROP COLUMN "customizedFields";
ALTER TABLE "Policy" DROP COLUMN "lastSyncedAt";
ALTER TABLE "Policy" DROP COLUMN "templateVersion";
ALTER TABLE "Policy" DROP COLUMN "syncStatus";

ALTER TABLE "Task" DROP COLUMN "isCustomized";
ALTER TABLE "Task" DROP COLUMN "customizedFields";
ALTER TABLE "Task" DROP COLUMN "lastSyncedAt";
ALTER TABLE "Task" DROP COLUMN "templateVersion";
ALTER TABLE "Task" DROP COLUMN "syncStatus";

DROP TYPE "SyncStatus";
```

### Rollback Migration 1 (Framework Versioning)

```sql
DROP INDEX "FrameworkEditorFramework_publishedAt_idx";

ALTER TABLE "FrameworkEditorFramework" DROP COLUMN "majorVersion";
ALTER TABLE "FrameworkEditorFramework" DROP COLUMN "minorVersion";
ALTER TABLE "FrameworkEditorFramework" DROP COLUMN "patchVersion";
ALTER TABLE "FrameworkEditorFramework" DROP COLUMN "changelog";
ALTER TABLE "FrameworkEditorFramework" DROP COLUMN "publishedAt";
ALTER TABLE "FrameworkEditorFramework" DROP COLUMN "publishedBy";
ALTER TABLE "FrameworkEditorFramework" DROP COLUMN "previousVersion";
```

---

## Testing Requirements

### Unit Tests

**File**: `apps/app/src/lib/framework-updates/__tests__/schema.test.ts`

```typescript
describe('Framework Update Schema', () => {
  it('should create framework with semantic version', async () => {
    const framework = await db.frameworkEditorFramework.create({
      data: {
        id: 'test_framework',
        name: 'Test Framework',
        version: '1.0.0',
        description: 'Test',
        majorVersion: 1,
        minorVersion: 0,
        patchVersion: 0
      }
    });

    expect(framework.majorVersion).toBe(1);
  });

  it('should track control customizations', async () => {
    const control = await db.control.update({
      where: { id: 'test_control' },
      data: {
        isCustomized: true,
        customizedFields: ['name', 'description']
      }
    });

    expect(control.isCustomized).toBe(true);
    expect(control.customizedFields).toContain('name');
  });

  it('should create update campaign', async () => {
    const campaign = await db.frameworkUpdateCampaign.create({
      data: {
        frameworkId: 'test_framework',
        fromVersion: '1.0.0',
        toVersion: '1.1.0',
        createdBy: 'test_user'
      }
    });

    expect(campaign.status).toBe('draft');
  });
});
```

---

## Success Criteria

- ✅ All migrations run successfully without errors
- ✅ Prisma schema validates with `npx prisma validate`
- ✅ Database can be created fresh with `npx prisma db push`
- ✅ Backfill script successfully populates existing data
- ✅ All indexes created and performant
- ✅ Foreign key constraints properly cascade
- ✅ Unit tests pass with 90%+ coverage
- ✅ Rollback procedures tested and documented

---

## Dependencies

**Phase 2** (CSV Update Script) depends on:
- `FrameworkEditorFramework` version fields

**Phase 4** (Customization Detection) depends on:
- `SyncStatus` enum
- `isCustomized` and `customizedFields` columns

**Phase 5** (Background Jobs) depends on:
- All tables from this phase

---

## Gotchas & Mitigations

### 1. Large Table Migrations

**Gotcha**: Adding columns to large tables (Control, Policy, Task) can lock tables during migration.

**Mitigation**:
- Run migrations during low-traffic periods
- Add columns as nullable first, then set defaults in batches
- Use `pgroll` for zero-downtime migrations if needed

### 2. Backfill Performance

**Gotcha**: Backfilling millions of records can be slow.

**Mitigation**:
- Process in batches of 1000 records
- Use `findMany` with cursor pagination
- Run backfill as background job with progress tracking

### 3. Version Number Conflicts

**Gotcha**: Multiple template updates in same day might conflict.

**Mitigation**:
- Use semantic versioning strictly
- Require version bump in admin UI
- Prevent publishing without version change

---

## Estimated Effort

- **Schema design**: 0.5 days
- **Migration writing**: 1 day
- **Backfill script**: 1 day
- **Testing migrations**: 1 day
- **Unit tests**: 1 day
- **Documentation**: 0.5 days

**Total**: 5 days (1 week)

---

## Next Phase

➡️ **Phase 2**: CSV Update Script System
