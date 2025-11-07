# Phase 5: Background Jobs (Trigger.dev)

**Status**: Not Started
**Est. Effort**: 1-2 weeks
**Dependencies**: Phase 1 (Database), Phase 4 (Customization Detection)
**Blockers**: None

---

## Overview

Implement scheduled background jobs using Trigger.dev to automatically detect framework template updates, apply updates during maintenance windows, and send reminder notifications for unresolved conflicts.

---

## Objectives

- ✅ Create update detector job (daily)
- ✅ Create update applier job (hourly, checks maintenance windows)
- ✅ Create conflict reminder job (daily)
- ✅ Implement maintenance window logic
- ✅ Add retry and error handling
- ✅ Create monitoring and alerting
- ✅ Add job result logging

---

## Job 1: Framework Update Detector

**File**: `apps/app/src/jobs/framework-update/detector.ts`

**Purpose**: Daily job to detect when framework templates have been updated and create update campaigns

**Schedule**: Daily at 2 AM

```typescript
import { schedules } from '@trigger.dev/sdk/v3';
import { db } from '@/lib/db';
import { novu } from '@/lib/novu';

export const frameworkUpdateDetector = schedules.task({
  id: 'framework-update-detector',
  cron: '0 2 * * *', // 2 AM daily
  maxDuration: 600, // 10 minutes
  run: async (payload, { ctx }) => {
    ctx.logger.info('Starting framework update detection');

    // Get last check timestamp from metadata
    const lastCheck = await getLastCheckTimestamp();

    // Find frameworks updated since last check
    const updatedFrameworks = await db.frameworkEditorFramework.findMany({
      where: {
        updatedAt: { gt: lastCheck },
        publishedAt: { not: null }, // Only published versions
        visible: true
      },
      include: {
        _count: {
          select: { frameworkInstances: true }
        }
      }
    });

    ctx.logger.info(`Found ${updatedFrameworks.length} updated frameworks`);

    for (const framework of updatedFrameworks) {
      const currentVersion = `${framework.majorVersion}.${framework.minorVersion}.${framework.patchVersion}`;

      ctx.logger.info(`Processing framework ${framework.name} v${currentVersion}`);

      // Check if campaign already exists
      const existingCampaign = await db.frameworkUpdateCampaign.findFirst({
        where: {
          frameworkId: framework.id,
          toVersion: currentVersion
        }
      });

      if (existingCampaign) {
        ctx.logger.info('Campaign already exists, skipping');
        continue;
      }

      // Get affected organizations
      const affectedOrgs = await db.organization.findMany({
        where: {
          frameworkInstances: {
            some: { frameworkId: framework.id }
          }
        },
        select: { id: true, name: true }
      });

      ctx.logger.info(`Affects ${affectedOrgs.length} organizations`);

      // Create update campaign
      const campaign = await db.frameworkUpdateCampaign.create({
        data: {
          frameworkId: framework.id,
          fromVersion: framework.previousVersion || '1.0.0',
          toVersion: currentVersion,
          status: 'scheduled',
          scheduledAt: getNextMaintenanceWindow(), // Next Sunday 2 AM
          affectedOrgCount: affectedOrgs.length,
          changelog: framework.changelog,
          createdBy: 'system'
        }
      });

      ctx.logger.info(`Created campaign ${campaign.id}`);

      // Create initial logs for each org
      await db.frameworkUpdateLog.createMany({
        data: affectedOrgs.map((org) => ({
          campaignId: campaign.id,
          organizationId: org.id,
          status: 'pending'
        }))
      });

      // Send notification to org admins
      for (const org of affectedOrgs) {
        await notifyOrganizationAdmins(org.id, {
          workflowId: 'framework-update-available',
          payload: {
            frameworkName: framework.name,
            version: currentVersion,
            changelog: framework.changelog,
            scheduledDate: campaign.scheduledAt,
            campaignId: campaign.id
          }
        });
      }

      ctx.logger.info(`Sent notifications to ${affectedOrgs.length} organizations`);
    }

    // Update last check timestamp
    await saveLastCheckTimestamp(new Date());

    ctx.logger.info('Framework update detection complete');

    return {
      detectedUpdates: updatedFrameworks.length,
      campaignsCreated: updatedFrameworks.length
    };
  }
});

async function getLastCheckTimestamp(): Promise<Date> {
  // Store in database or environment variable
  const metadata = await db.systemMetadata.findUnique({
    where: { key: 'framework_update_last_check' }
  });

  return metadata ? new Date(metadata.value) : new Date(0);
}

async function saveLastCheckTimestamp(timestamp: Date) {
  await db.systemMetadata.upsert({
    where: { key: 'framework_update_last_check' },
    create: { key: 'framework_update_last_check', value: timestamp.toISOString() },
    update: { value: timestamp.toISOString() }
  });
}

function getNextMaintenanceWindow(): Date {
  // Default: Next Sunday at 2 AM
  const now = new Date();
  const nextSunday = new Date(now);
  const daysUntilSunday = (7 - now.getDay()) % 7 || 7;
  nextSunday.setDate(now.getDate() + daysUntilSunday);
  nextSunday.setHours(2, 0, 0, 0);
  return nextSunday;
}
```

---

## Job 2: Framework Update Applier

**File**: `apps/app/src/jobs/framework-update/applier.ts`

**Purpose**: Hourly job to check for scheduled campaigns and apply updates during maintenance windows

**Schedule**: Every hour

```typescript
export const frameworkUpdateApplier = schedules.task({
  id: 'framework-update-applier',
  cron: '0 * * * *', // Every hour
  maxDuration: 600, // 10 minutes
  run: async (payload, { ctx }) => {
    ctx.logger.info('Starting framework update applier');

    // Find scheduled campaigns that should run now
    const now = new Date();
    const campaigns = await db.frameworkUpdateCampaign.findMany({
      where: {
        status: 'scheduled',
        scheduledAt: { lte: now }
      },
      include: {
        framework: true
      }
    });

    ctx.logger.info(`Found ${campaigns.length} campaigns ready to run`);

    for (const campaign of campaigns) {
      ctx.logger.info(`Processing campaign ${campaign.id} for ${campaign.framework.name}`);

      // Update campaign status
      await db.frameworkUpdateCampaign.update({
        where: { id: campaign.id },
        data: { status: 'in_progress', startedAt: now }
      });

      try {
        // Get pending organizations
        const pendingLogs = await db.frameworkUpdateLog.findMany({
          where: {
            campaignId: campaign.id,
            status: 'pending'
          },
          include: {
            organization: true
          }
        });

        ctx.logger.info(`Processing ${pendingLogs.length} organizations`);

        // Process each organization
        for (const log of pendingLogs) {
          try {
            // Check if in maintenance window
            if (!isInMaintenanceWindow(log.organization)) {
              ctx.logger.info(`Org ${log.organization.name} not in maintenance window, skipping`);
              continue;
            }

            ctx.logger.info(`Applying update to ${log.organization.name}`);

            // Update the organization
            const result = await applyFrameworkUpdate(
              log.organizationId,
              campaign.frameworkId,
              campaign.toVersion
            );

            // Update log with results
            await db.frameworkUpdateLog.update({
              where: { id: log.id },
              data: {
                status: result.hasConflicts ? 'conflict' : 'applied',
                controlsUpdated: result.controlsUpdated,
                controlsConflict: result.controlsConflict,
                policiesUpdated: result.policiesUpdated,
                policiesConflict: result.policiesConflict,
                tasksUpdated: result.tasksUpdated,
                tasksConflict: result.tasksConflict,
                conflictDetails: result.conflicts,
                appliedAt: new Date()
              }
            });

            // Send notification
            await notifyOrganizationAdmins(log.organizationId, {
              workflowId: result.hasConflicts
                ? 'framework-update-conflict'
                : 'framework-update-applied',
              payload: {
                frameworkName: campaign.framework.name,
                version: campaign.toVersion,
                changeCount: result.controlsUpdated + result.policiesUpdated + result.tasksUpdated,
                conflictCount: result.controlsConflict + result.policiesConflict + result.tasksConflict,
                changelog: campaign.changelog,
                reviewUrl: `/${log.organizationId}/frameworks/updates/${campaign.id}/review`
              }
            });

            // Update campaign stats
            await db.frameworkUpdateCampaign.update({
              where: { id: campaign.id },
              data: {
                successCount: { increment: result.hasConflicts ? 0 : 1 },
                conflictCount: { increment: result.hasConflicts ? 1 : 0 }
              }
            });

            ctx.logger.info(`Update applied to ${log.organization.name}`);
          } catch (error) {
            ctx.logger.error(`Failed to update ${log.organization.name}: ${error.message}`);

            await db.frameworkUpdateLog.update({
              where: { id: log.id },
              data: {
                status: 'failed',
                errorMessage: error.message,
                failedAt: new Date()
              }
            });

            await db.frameworkUpdateCampaign.update({
              where: { id: campaign.id },
              data: { errorCount: { increment: 1 } }
            });
          }
        }

        // Check if campaign is complete
        const remainingPending = await db.frameworkUpdateLog.count({
          where: {
            campaignId: campaign.id,
            status: 'pending'
          }
        });

        if (remainingPending === 0) {
          await db.frameworkUpdateCampaign.update({
            where: { id: campaign.id },
            data: {
              status: 'completed',
              completedAt: new Date()
            }
          });

          ctx.logger.info(`Campaign ${campaign.id} completed`);
        }
      } catch (error) {
        ctx.logger.error(`Campaign ${campaign.id} failed: ${error.message}`);

        await db.frameworkUpdateCampaign.update({
          where: { id: campaign.id },
          data: {
            status: 'failed',
            completedAt: new Date()
          }
        });
      }
    }

    ctx.logger.info('Framework update applier complete');

    return {
      campaignsProcessed: campaigns.length
    };
  }
});

/**
 * Check if organization is in its maintenance window
 */
function isInMaintenanceWindow(org: Organization): boolean {
  if (!org.maintenanceWindow) {
    // Default window: Sunday 2-4 AM
    const now = new Date();
    return now.getDay() === 0 && now.getHours() >= 2 && now.getHours() < 4;
  }

  const window = org.maintenanceWindow as {
    day: string;
    hour: number;
    timezone: string;
  };

  // Convert current time to org's timezone
  const nowInOrgTz = toZonedTime(new Date(), window.timezone);
  const dayMap = { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 };

  return (
    nowInOrgTz.getDay() === dayMap[window.day.toLowerCase()] &&
    nowInOrgTz.getHours() === window.hour
  );
}

/**
 * Apply framework update to a single organization
 */
async function applyFrameworkUpdate(
  organizationId: string,
  frameworkId: string,
  newVersion: string
) {
  const results = {
    hasConflicts: false,
    controlsUpdated: 0,
    controlsConflict: 0,
    policiesUpdated: 0,
    policiesConflict: 0,
    tasksUpdated: 0,
    tasksConflict: 0,
    conflicts: [] as any[]
  };

  await db.$transaction(async (tx) => {
    // Update controls
    const controls = await tx.control.findMany({
      where: {
        organizationId,
        controlTemplateId: { not: null }
      },
      include: { controlTemplate: true }
    });

    for (const control of controls) {
      const customization = await detectControlCustomization(control.id);

      if (customization.isCustomized) {
        // Has conflicts
        results.controlsConflict++;
        results.hasConflicts = true;
        results.conflicts.push({
          type: 'control',
          id: control.id,
          name: control.name,
          customizedFields: customization.customizedFields
        });

        // Update syncStatus to conflict
        await tx.control.update({
          where: { id: control.id },
          data: { syncStatus: 'conflict' }
        });
      } else {
        // Safe to auto-apply
        await tx.control.update({
          where: { id: control.id },
          data: {
            name: control.controlTemplate.name,
            description: control.controlTemplate.description,
            lastSyncedAt: new Date(),
            templateVersion: newVersion,
            syncStatus: 'synced'
          }
        });

        results.controlsUpdated++;
      }
    }

    // Similar for policies and tasks...
  });

  return results;
}
```

---

## Job 3: Conflict Reminder

**File**: `apps/app/src/jobs/framework-update/conflict-reminder.ts`

**Purpose**: Daily reminder for organizations with unresolved conflicts

**Schedule**: Daily at 10 AM

```typescript
export const conflictReminder = schedules.task({
  id: 'conflict-reminder',
  cron: '0 10 * * *', // 10 AM daily
  run: async (payload, { ctx }) => {
    ctx.logger.info('Starting conflict reminder job');

    // Find orgs with conflicts older than 7 days
    const sevenDaysAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);

    const orgsWithConflicts = await db.frameworkUpdateLog.findMany({
      where: {
        status: 'conflict',
        appliedAt: { lt: sevenDaysAgo }
      },
      include: {
        organization: true,
        campaign: {
          include: { framework: true }
        }
      }
    });

    ctx.logger.info(`Found ${orgsWithConflicts.length} organizations with unresolved conflicts`);

    for (const log of orgsWithConflicts) {
      await notifyOrganizationAdmins(log.organizationId, {
        workflowId: 'framework-update-reminder',
        payload: {
          frameworkName: log.campaign.framework.name,
          version: log.campaign.toVersion,
          conflictCount: log.controlsConflict + log.policiesConflict + log.tasksConflict,
          daysWaiting: Math.floor((Date.now() - log.appliedAt.getTime()) / (24 * 60 * 60 * 1000)),
          reviewUrl: `/${log.organizationId}/frameworks/updates/${log.campaignId}/review`
        }
      });
    }

    ctx.logger.info(`Sent ${orgsWithConflicts.length} reminder notifications`);

    return {
      remindersSent: orgsWithConflicts.length
    };
  }
});
```

---

## Utility: Novu Notification Helper

**File**: `apps/app/src/lib/framework-updates/notifications.ts`

```typescript
import { novu } from '@/lib/novu';
import { db } from '@/lib/db';

export async function notifyOrganizationAdmins(
  organizationId: string,
  notification: {
    workflowId: string;
    payload: any;
  }
) {
  // Get all admins/owners for organization
  const admins = await db.member.findMany({
    where: {
      organizationId,
      role: { in: ['owner', 'admin'] }
    },
    include: { user: true }
  });

  if (admins.length === 0) {
    console.warn(`No admins found for organization ${organizationId}`);
    return;
  }

  // Trigger notification for each admin
  await novu.triggerBulk({
    events: admins.map((admin) => ({
      name: notification.workflowId,
      to: {
        subscriberId: `${admin.userId}-${organizationId}`,
        email: admin.user.email
      },
      payload: {
        ...notification.payload,
        organizationId,
        userName: admin.user.name || admin.user.email
      }
    }))
  });
}
```

---

## Testing

**File**: `apps/app/src/jobs/framework-update/__tests__/applier.test.ts`

```typescript
describe('Framework Update Applier', () => {
  it('should apply update during maintenance window', async () => {
    // Create test org with maintenance window
    const org = await createTestOrg({
      maintenanceWindow: {
        day: 'sunday',
        hour: 2,
        timezone: 'America/New_York'
      }
    });

    // Mock current time to be Sunday 2 AM ET
    jest.useFakeTimers().setSystemTime(getSunday2AMET());

    // Create campaign
    const campaign = await createTestCampaign({
      status: 'scheduled',
      scheduledAt: new Date()
    });

    // Run job
    await frameworkUpdateApplier.run({}, mockContext);

    // Verify update was applied
    const log = await db.frameworkUpdateLog.findFirst({
      where: { organizationId: org.id, campaignId: campaign.id }
    });

    expect(log.status).toBe('applied');
  });

  it('should skip org outside maintenance window', async () => {
    const org = await createTestOrg({
      maintenanceWindow: {
        day: 'sunday',
        hour: 2,
        timezone: 'America/New_York'
      }
    });

    // Mock Monday 2 AM
    jest.useFakeTimers().setSystemTime(getMonday2AMET());

    await frameworkUpdateApplier.run({}, mockContext);

    const log = await db.frameworkUpdateLog.findFirst({
      where: { organizationId: org.id }
    });

    expect(log.status).toBe('pending');
  });
});
```

---

## Success Criteria

- ✅ Detector job runs daily and creates campaigns
- ✅ Applier job applies updates during maintenance windows
- ✅ Conflicts are detected and flagged
- ✅ Notifications sent to org admins
- ✅ Jobs handle errors gracefully (retry logic)
- ✅ Job logs captured in database
- ✅ Monitoring alerts on job failures

---

## Estimated Effort

- **Detector job**: 2 days
- **Applier job**: 4 days
- **Conflict reminder**: 1 day
- **Maintenance window logic**: 2 days
- **Testing**: 2 days

**Total**: 11 days (2 weeks)

---

## Next Phase

➡️ **Phase 6**: Notification System (Novu)
