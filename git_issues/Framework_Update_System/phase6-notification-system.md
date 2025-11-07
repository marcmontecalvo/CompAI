# Phase 6: Notification System (Novu)

**Status**: Not Started
**Est. Effort**: 1 week
**Dependencies**: Phase 1 (Database), Phase 5 (Background Jobs)
**Blockers**: None

---

## Overview

Create Novu workflows for multi-channel notifications (in-app + email) to inform organization admins about framework updates, conflicts, and reminders. Integrate with existing Novu infrastructure.

---

## Objectives

- ✅ Create 4 Novu workflows
- ✅ Design email templates
- ✅ Configure in-app notification preferences
- ✅ Implement notification persistence
- ✅ Add notification read/dismiss tracking
- ✅ Create notification preferences UI

---

## Novu Workflows

### Workflow 1: framework-update-available

**Trigger**: When new framework version is published and campaign created

**Channels**: In-app + Email

**Email Template**:

```html
Subject: {{frameworkName}} Update Available - Review Before {{scheduledDate}}

Hi {{userName}},

A new version of the {{frameworkName}} compliance framework is available.

Version: {{version}}
Scheduled Update: {{scheduledDate}}

Changes in this update:
{{changelog}}

This update will be automatically applied during your maintenance window on {{scheduledDate}}.
If you have customized any controls, policies, or tasks, they will be flagged for your review.

[Review Changes]({{reviewUrl}})

Questions? Contact support@compai.com

---
CompAI - Compliance Management Platform
```

**In-app Notification**:
```json
{
  "title": "{{frameworkName}} Update Available",
  "body": "Version {{version}} will be applied on {{scheduledDate}}. Review changes.",
  "cta": {
    "label": "Review Changes",
    "url": "/frameworks/updates/{{campaignId}}"
  }
}
```

**Novu Workflow Definition**:

**File**: `packages/novu-workflows/src/framework-update-available.ts`

```typescript
import { workflow } from '@novu/framework';

export const frameworkUpdateAvailable = workflow(
  'framework-update-available',
  async ({ step, payload }) => {
    await step.email('send-email', async () => {
      return {
        subject: `${payload.frameworkName} Update Available - Review Before ${payload.scheduledDate}`,
        body: renderEmailTemplate('framework-update-available', payload)
      };
    });

    await step.inApp('send-in-app', async () => {
      return {
        subject: `${payload.frameworkName} Update Available`,
        body: `Version ${payload.version} will be applied on ${payload.scheduledDate}. Review changes.`,
        data: {
          frameworkName: payload.frameworkName,
          version: payload.version,
          scheduledDate: payload.scheduledDate,
          campaignId: payload.campaignId,
          reviewUrl: payload.reviewUrl
        }
      };
    });
  },
  {
    payloadSchema: {
      type: 'object',
      properties: {
        frameworkName: { type: 'string' },
        version: { type: 'string' },
        scheduledDate: { type: 'string' },
        changelog: { type: 'string' },
        campaignId: { type: 'string' },
        reviewUrl: { type: 'string' },
        userName: { type: 'string' }
      },
      required: ['frameworkName', 'version', 'scheduledDate'],
      additionalProperties: false
    }
  }
);
```

---

### Workflow 2: framework-update-applied

**Trigger**: After successful update with no conflicts

**Channels**: In-app + Email

**Email Template**:

```html
Subject: {{frameworkName}} Updated to v{{version}}

Hi {{userName}},

The {{frameworkName}} compliance framework has been successfully updated.

Version: {{version}}
Changes Applied: {{changeCount}}
Applied: {{appliedDate}}

Summary of changes:
{{changelog}}

All controls, policies, and tasks have been updated to the latest version.
No conflicts were detected with your customizations.

[View Framework]({{frameworkUrl}})

---
CompAI - Compliance Management Platform
```

---

### Workflow 3: framework-update-conflict

**Trigger**: After update with conflicts requiring manual review

**Channels**: In-app + Email + High Priority

**Email Template**:

```html
Subject: ⚠️ Action Required: {{frameworkName}} Update Needs Review

Hi {{userName}},

The {{frameworkName}} framework has been updated, but {{conflictCount}} items require your review.

Version: {{version}}
Items Requiring Review: {{conflictCount}}
Auto-Applied: {{changeCount - conflictCount}}

Your organization has customized some controls, policies, or tasks that were also
updated in the new framework version. Please review these conflicts and choose
how to resolve them:

- Accept Template Update: Use the new version from the framework
- Keep Your Version: Preserve your customizations
- Detach from Template: Permanently customize this item

[Review Conflicts Now]({{reviewUrl}})

⏰ Please resolve these conflicts within 7 days to stay compliant.

---
CompAI - Compliance Management Platform
```

**In-app Notification** (High Priority):
```json
{
  "title": "⚠️ {{frameworkName}} Update Needs Review",
  "body": "{{conflictCount}} items require your attention",
  "priority": "high",
  "cta": {
    "label": "Review Conflicts",
    "url": "/frameworks/updates/{{campaignId}}/review"
  }
}
```

---

### Workflow 4: framework-update-reminder

**Trigger**: Daily for unresolved conflicts > 7 days

**Channels**: Email only (to avoid spam)

**Email Template**:

```html
Subject: Reminder: {{frameworkName}} Update Conflicts Need Resolution

Hi {{userName}},

This is a reminder that your {{frameworkName}} framework update has unresolved conflicts.

Days Waiting: {{daysWaiting}}
Items Requiring Review: {{conflictCount}}

Resolving these conflicts ensures your compliance program stays up-to-date with
the latest regulatory guidance.

[Review Conflicts]({{reviewUrl}})

Need help? Contact support@compai.com

---
CompAI - Compliance Management Platform
```

---

## Notification Preferences

**File**: `apps/app/src/app/(app)/[orgId]/settings/notifications/page.tsx`

Allow users to configure notification preferences:

```typescript
export default function NotificationPreferencesPage({ params }: { params: { orgId: string } }) {
  return (
    <div className="container mx-auto py-8">
      <h1 className="text-3xl font-bold mb-6">Notification Preferences</h1>

      <Card>
        <CardHeader>
          <CardTitle>Framework Updates</CardTitle>
          <CardDescription>
            Configure how you want to be notified about framework updates
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <Label>Update Available Notifications</Label>
              <p className="text-sm text-muted-foreground">
                Notify when new framework versions are published
              </p>
            </div>
            <Switch name="updateAvailable" defaultChecked />
          </div>

          <div className="flex items-center justify-between">
            <div>
              <Label>Conflict Notifications</Label>
              <p className="text-sm text-muted-foreground">
                Notify when updates have conflicts requiring review
              </p>
            </div>
            <Switch name="conflicts" defaultChecked />
          </div>

          <div className="flex items-center justify-between">
            <div>
              <Label>Reminder Frequency</Label>
              <p className="text-sm text-muted-foreground">
                How often to remind about unresolved conflicts
              </p>
            </div>
            <Select defaultValue="daily">
              <SelectTrigger className="w-[180px]">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="daily">Daily</SelectItem>
                <SelectItem value="weekly">Weekly</SelectItem>
                <SelectItem value="never">Never</SelectItem>
              </SelectContent>
            </Select>
          </div>

          <Separator />

          <div>
            <Label>Notification Channels</Label>
            <div className="mt-2 space-y-2">
              <div className="flex items-center space-x-2">
                <Checkbox id="email" defaultChecked />
                <label htmlFor="email" className="text-sm font-medium">
                  Email
                </label>
              </div>
              <div className="flex items-center space-x-2">
                <Checkbox id="in-app" defaultChecked />
                <label htmlFor="in-app" className="text-sm font-medium">
                  In-App Notifications
                </label>
              </div>
            </div>
          </div>
        </CardContent>
        <CardFooter>
          <Button>Save Preferences</Button>
        </CardFooter>
      </Card>
    </div>
  );
}
```

---

## In-App Notification Component

**File**: `apps/app/src/components/notifications/framework-update-notification.tsx`

Custom component to render framework update notifications in the notification bell:

```typescript
import { Inbox } from '@novu/nextjs';

export function FrameworkUpdateNotificationBell() {
  return (
    <Inbox
      applicationIdentifier={process.env.NEXT_PUBLIC_NOVU_APP_ID}
      subscriberId={`${userId}-${orgId}`}
      renderNotification={(notification) => {
        if (notification.workflow === 'framework-update-conflict') {
          return (
            <div className="p-4 border-l-4 border-destructive">
              <div className="flex items-center gap-2">
                <AlertCircle className="h-5 w-5 text-destructive" />
                <span className="font-semibold">{notification.subject}</span>
              </div>
              <p className="text-sm text-muted-foreground mt-1">{notification.body}</p>
              <Button
                variant="destructive"
                size="sm"
                className="mt-2"
                onClick={() => router.push(notification.data.reviewUrl)}
              >
                Review Conflicts
              </Button>
            </div>
          );
        }

        // Default rendering for other notifications
        return (
          <div className="p-4">
            <div className="font-semibold">{notification.subject}</div>
            <p className="text-sm text-muted-foreground">{notification.body}</p>
          </div>
        );
      }}
    />
  );
}
```

---

## Notification Persistence

Store notification records in database for audit trail:

**File**: `apps/app/src/lib/framework-updates/persist-notification.ts`

```typescript
export async function persistNotification(
  organizationId: string,
  campaignId: string,
  notificationType: string,
  payload: any
) {
  // Count changes
  const changeCount = payload.changeCount || 0;
  const conflictCount = payload.conflictCount || 0;

  await db.frameworkChangeNotification.create({
    data: {
      organizationId,
      campaignId,
      title: getNotificationTitle(notificationType, payload),
      message: getNotificationMessage(notificationType, payload),
      changeCount,
      conflictCount,
      changedControls: payload.changedControls || [],
      changedPolicies: payload.changedPolicies || [],
      changedTasks: payload.changedTasks || []
    }
  });
}

function getNotificationTitle(type: string, payload: any): string {
  switch (type) {
    case 'framework-update-available':
      return `${payload.frameworkName} Update Available`;
    case 'framework-update-applied':
      return `${payload.frameworkName} Updated Successfully`;
    case 'framework-update-conflict':
      return `${payload.frameworkName} Update Needs Review`;
    default:
      return 'Framework Update';
  }
}
```

---

## Testing

**File**: `apps/app/src/lib/framework-updates/__tests__/notifications.test.ts`

```typescript
describe('Notification System', () => {
  it('should send update available notification', async () => {
    const mockNovu = jest.spyOn(novu, 'trigger');

    await notifyOrganizationAdmins('org_123', {
      workflowId: 'framework-update-available',
      payload: {
        frameworkName: 'HIPAA',
        version: '1.1.0',
        scheduledDate: '2025-06-01'
      }
    });

    expect(mockNovu).toHaveBeenCalledWith({
      name: 'framework-update-available',
      to: expect.objectContaining({
        subscriberId: expect.stringContaining('org_123')
      }),
      payload: expect.objectContaining({
        frameworkName: 'HIPAA'
      })
    });
  });

  it('should persist notification to database', async () => {
    await persistNotification('org_123', 'camp_456', 'framework-update-conflict', {
      frameworkName: 'HIPAA',
      conflictCount: 5
    });

    const notification = await db.frameworkChangeNotification.findFirst({
      where: { organizationId: 'org_123', campaignId: 'camp_456' }
    });

    expect(notification).toBeDefined();
    expect(notification.conflictCount).toBe(5);
  });
});
```

---

## Success Criteria

- ✅ All 4 workflows configured in Novu
- ✅ Email templates render correctly
- ✅ In-app notifications appear in notification bell
- ✅ Notifications persisted to database
- ✅ Users can configure preferences
- ✅ High-priority notifications visually distinct
- ✅ Notification links route correctly

---

## Estimated Effort

- **Workflow creation**: 2 days
- **Email template design**: 2 days
- **In-app notification UI**: 1 day
- **Preferences page**: 1 day
- **Testing**: 1 day

**Total**: 7 days (1 week)

---

## Next Phase

➡️ **Phase 7**: Overview Page UI Updates
