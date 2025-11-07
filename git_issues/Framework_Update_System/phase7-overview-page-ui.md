# Phase 7: Overview Page UI Updates

**Status**: Not Started
**Est. Effort**: 1 week
**Dependencies**: Phase 1 (Database), Phase 6 (Notifications)
**Blockers**: None

---

## Overview

Add a "Framework Updates" card to the organization Overview page that displays recent updates, unresolved conflicts, and provides quick access to review changes. Include visual indicators (badges) on individual controls, policies, and tasks to show their sync status.

---

## Objectives

- ✅ Create FrameworkUpdatesCard component
- ✅ Add to Overview page draggable cards
- ✅ Implement changelog viewer with clickable items
- ✅ Add sync status badges to Control/Policy/Task pages
- ✅ Create "Review Changes" CTA flow
- ✅ Add dismiss/mark-as-read functionality
- ✅ Implement expandable change details

---

## Component 1: Framework Updates Card

**File**: `apps/app/src/app/(app)/[orgId]/frameworks/components/FrameworkUpdatesCard.tsx`

```typescript
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from '@/components/ui/accordion';
import { AlertCircle, CheckCircle, ChevronRight } from 'lucide-react';
import Link from 'next/link';

interface FrameworkUpdatesCardProps {
  organizationId: string;
  updates: FrameworkUpdate[];
}

interface FrameworkUpdate {
  id: string;
  frameworkName: string;
  fromVersion: string;
  toVersion: string;
  status: 'pending' | 'applied' | 'conflict';
  changeCount: number;
  conflictCount: number;
  appliedAt?: Date;
  changelog: string;
  changedControls: { id: string; name: string; status: string }[];
  changedPolicies: { id: string; name: string; status: string }[];
  changedTasks: { id: string; name: string; status: string }[];
}

export async function FrameworkUpdatesCard({ organizationId }: { organizationId: string }) {
  // Fetch recent updates (last 30 days)
  const updates = await getRecentFrameworkUpdates(organizationId);

  // Count unresolved conflicts
  const conflictCount = updates.filter((u) => u.status === 'conflict').length;

  if (updates.length === 0) {
    return null; // Don't show card if no updates
  }

  return (
    <Card>
      <CardHeader>
        <div className="flex items-center justify-between">
          <div>
            <CardTitle className="flex items-center gap-2">
              Framework Updates
              {conflictCount > 0 && (
                <Badge variant="destructive" className="animate-pulse">
                  {conflictCount} Requiring Review
                </Badge>
              )}
            </CardTitle>
            <CardDescription>Recent framework updates and changes</CardDescription>
          </div>
          {conflictCount > 0 && (
            <Link href={`/${organizationId}/frameworks/updates`}>
              <Button variant="destructive">Review All Conflicts</Button>
            </Link>
          )}
        </div>
      </CardHeader>

      <CardContent className="space-y-4">
        {updates.map((update) => (
          <FrameworkUpdateItem key={update.id} update={update} organizationId={organizationId} />
        ))}
      </CardContent>
    </Card>
  );
}

function FrameworkUpdateItem({
  update,
  organizationId
}: {
  update: FrameworkUpdate;
  organizationId: string;
}) {
  const statusConfig = {
    applied: {
      icon: CheckCircle,
      color: 'text-green-600',
      badge: 'default' as const,
      label: 'Applied'
    },
    conflict: {
      icon: AlertCircle,
      color: 'text-red-600',
      badge: 'destructive' as const,
      label: 'Needs Review'
    },
    pending: {
      icon: AlertCircle,
      color: 'text-yellow-600',
      badge: 'warning' as const,
      label: 'Pending'
    }
  };

  const config = statusConfig[update.status];
  const Icon = config.icon;

  return (
    <div className="border rounded-lg p-4">
      <div className="flex items-start justify-between mb-3">
        <div className="flex items-center gap-3">
          <Icon className={`h-5 w-5 ${config.color}`} />
          <div>
            <h4 className="font-semibold">
              {update.frameworkName} v{update.toVersion}
            </h4>
            <p className="text-sm text-muted-foreground">
              {update.fromVersion} → {update.toVersion}
              {update.appliedAt && ` • ${formatDistanceToNow(update.appliedAt, { addSuffix: true })}`}
            </p>
          </div>
        </div>
        <Badge variant={config.badge}>{config.label}</Badge>
      </div>

      <div className="flex gap-4 text-sm mb-3">
        <div>
          <span className="font-medium">{update.changeCount}</span> changes
        </div>
        {update.conflictCount > 0 && (
          <div className="text-destructive">
            <span className="font-medium">{update.conflictCount}</span> conflicts
          </div>
        )}
      </div>

      <Accordion type="single" collapsible>
        <AccordionItem value="changes">
          <AccordionTrigger>View Changes</AccordionTrigger>
          <AccordionContent>
            <div className="space-y-3">
              {/* Controls */}
              {update.changedControls.length > 0 && (
                <div>
                  <h5 className="text-sm font-medium mb-2">Controls</h5>
                  <div className="space-y-1">
                    {update.changedControls.map((control) => (
                      <Link
                        key={control.id}
                        href={`/${organizationId}/controls/${control.id}`}
                        className="flex items-center gap-2 text-sm hover:underline py-1"
                      >
                        <Badge
                          variant={control.status === 'conflict' ? 'destructive' : 'secondary'}
                          className="text-xs"
                        >
                          {control.status}
                        </Badge>
                        <span>{control.name}</span>
                        <ChevronRight className="h-3 w-3" />
                      </Link>
                    ))}
                  </div>
                </div>
              )}

              {/* Policies */}
              {update.changedPolicies.length > 0 && (
                <div>
                  <h5 className="text-sm font-medium mb-2">Policies</h5>
                  <div className="space-y-1">
                    {update.changedPolicies.map((policy) => (
                      <Link
                        key={policy.id}
                        href={`/${organizationId}/policies/${policy.id}`}
                        className="flex items-center gap-2 text-sm hover:underline py-1"
                      >
                        <Badge
                          variant={policy.status === 'conflict' ? 'destructive' : 'secondary'}
                          className="text-xs"
                        >
                          {policy.status}
                        </Badge>
                        <span>{policy.name}</span>
                        <ChevronRight className="h-3 w-3" />
                      </Link>
                    ))}
                  </div>
                </div>
              )}

              {/* Tasks */}
              {update.changedTasks.length > 0 && (
                <div>
                  <h5 className="text-sm font-medium mb-2">Tasks</h5>
                  <div className="space-y-1">
                    {update.changedTasks.map((task) => (
                      <Link
                        key={task.id}
                        href={`/${organizationId}/tasks/${task.id}`}
                        className="flex items-center gap-2 text-sm hover:underline py-1"
                      >
                        <Badge
                          variant={task.status === 'conflict' ? 'destructive' : 'secondary'}
                          className="text-xs"
                        >
                          {task.status}
                        </Badge>
                        <span>{task.name}</span>
                        <ChevronRight className="h-3 w-3" />
                      </Link>
                    ))}
                  </div>
                </div>
              )}

              {/* Changelog */}
              <div>
                <h5 className="text-sm font-medium mb-2">Changelog</h5>
                <div className="text-sm text-muted-foreground whitespace-pre-wrap bg-muted p-3 rounded">
                  {update.changelog}
                </div>
              </div>
            </div>

            {update.status === 'conflict' && (
              <Link href={`/${organizationId}/frameworks/updates/${update.id}/review`}>
                <Button className="w-full mt-4" variant="destructive">
                  Resolve Conflicts
                </Button>
              </Link>
            )}

            {update.status === 'applied' && (
              <Button
                className="w-full mt-4"
                variant="outline"
                onClick={() => handleDismiss(update.id)}
              >
                Dismiss
              </Button>
            )}
          </AccordionContent>
        </AccordionItem>
      </Accordion>
    </div>
  );
}

async function getRecentFrameworkUpdates(organizationId: string): Promise<FrameworkUpdate[]> {
  const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);

  const notifications = await db.frameworkChangeNotification.findMany({
    where: {
      organizationId,
      createdAt: { gte: thirtyDaysAgo },
      isDismissed: false
    },
    include: {
      campaign: {
        include: {
          framework: true
        }
      }
    },
    orderBy: { createdAt: 'desc' }
  });

  return notifications.map((notif) => ({
    id: notif.campaignId,
    frameworkName: notif.campaign.framework.name,
    fromVersion: notif.campaign.fromVersion,
    toVersion: notif.campaign.toVersion,
    status: notif.conflictCount > 0 ? 'conflict' : 'applied',
    changeCount: notif.changeCount,
    conflictCount: notif.conflictCount,
    appliedAt: notif.createdAt,
    changelog: notif.campaign.changelog || '',
    changedControls: notif.changedControls.map((id) => ({
      id,
      name: 'Control Name', // TODO: Fetch actual names
      status: 'updated'
    })),
    changedPolicies: [],
    changedTasks: []
  }));
}
```

---

## Integration with Overview Page

**File**: `apps/app/src/app/(app)/[orgId]/frameworks/components/Overview.tsx`

Add the FrameworkUpdatesCard to the draggable cards section:

```typescript
export default async function Overview({
  frameworksWithControls,
  frameworksWithCompliance,
  allFrameworks,
  organizationId,
  publishedPoliciesScore,
  doneTasksScore,
  currentMember
}: OverviewProps) {
  // Existing data fetching...

  return (
    <div className="space-y-6">
      <DraggableCards>
        <ComplianceOverview
          frameworksWithCompliance={frameworksWithCompliance}
          organizationId={organizationId}
        />

        <FrameworksOverview
          frameworksWithControls={frameworksWithControls}
          frameworksWithCompliance={frameworksWithCompliance}
          allFrameworks={allFrameworks}
          organizationId={organizationId}
        />

        <ToDoOverview
          publishedPoliciesScore={publishedPoliciesScore}
          doneTasksScore={doneTasksScore}
          organizationId={organizationId}
        />

        {/* NEW: Framework Updates Card */}
        <FrameworkUpdatesCard organizationId={organizationId} />
      </DraggableCards>
    </div>
  );
}
```

---

## Component 2: Sync Status Badges

**File**: `apps/app/src/components/framework-updates/SyncStatusBadge.tsx`

Show sync status on individual control/policy/task pages:

```typescript
import { Badge } from '@/components/ui/badge';
import { AlertCircle, CheckCircle, Unlink } from 'lucide-react';
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from '@/components/ui/tooltip';

interface SyncStatusBadgeProps {
  syncStatus: 'synced' | 'outdated' | 'conflict' | 'detached';
  templateVersion?: string;
  lastSyncedAt?: Date;
  customizedFields?: string[];
}

export function SyncStatusBadge({
  syncStatus,
  templateVersion,
  lastSyncedAt,
  customizedFields
}: SyncStatusBadgeProps) {
  const config = {
    synced: {
      icon: CheckCircle,
      variant: 'default' as const,
      label: 'Up to Date',
      description: `Synced with template v${templateVersion}`
    },
    outdated: {
      icon: AlertCircle,
      variant: 'warning' as const,
      label: 'Update Available',
      description: 'Template has updates'
    },
    conflict: {
      icon: AlertCircle,
      variant: 'destructive' as const,
      label: 'Needs Review',
      description: `Conflicts in: ${customizedFields?.join(', ')}`
    },
    detached: {
      icon: Unlink,
      variant: 'secondary' as const,
      label: 'Custom',
      description: 'Detached from template'
    }
  };

  const { icon: Icon, variant, label, description } = config[syncStatus];

  return (
    <TooltipProvider>
      <Tooltip>
        <TooltipTrigger asChild>
          <Badge variant={variant} className="cursor-help">
            <Icon className="h-3 w-3 mr-1" />
            {label}
          </Badge>
        </TooltipTrigger>
        <TooltipContent>
          <div className="space-y-1">
            <p className="font-medium">{description}</p>
            {lastSyncedAt && (
              <p className="text-xs text-muted-foreground">
                Last synced: {formatDistanceToNow(lastSyncedAt, { addSuffix: true })}
              </p>
            )}
          </div>
        </TooltipContent>
      </Tooltip>
    </TooltipProvider>
  );
}
```

**Usage in Control Detail Page**:

**File**: `apps/app/src/app/(app)/[orgId]/controls/[id]/page.tsx`

```typescript
export default async function ControlDetailPage({ params }: { params: { id: string; orgId: string } }) {
  const control = await db.control.findUnique({
    where: { id: params.id },
    include: { controlTemplate: true }
  });

  return (
    <div className="container mx-auto py-8">
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <h1 className="text-3xl font-bold">{control.name}</h1>

          {/* NEW: Sync Status Badge */}
          <SyncStatusBadge
            syncStatus={control.syncStatus}
            templateVersion={control.templateVersion}
            lastSyncedAt={control.lastSyncedAt}
            customizedFields={control.customizedFields}
          />
        </div>

        {control.syncStatus === 'conflict' && (
          <Link href={`/${params.orgId}/frameworks/updates/resolve/${control.id}`}>
            <Button variant="destructive">Resolve Conflict</Button>
          </Link>
        )}
      </div>

      {/* Rest of control detail page */}
    </div>
  );
}
```

---

## Component 3: Dismiss Action

**File**: `apps/app/src/actions/framework-updates/dismiss-update-action.ts`

```typescript
export const dismissUpdateAction = authWithOrgAccessClient
  .inputSchema(z.object({ notificationId: z.string() }))
  .action(async ({ parsedInput, ctx }) => {
    await db.frameworkChangeNotification.update({
      where: {
        id: parsedInput.notificationId,
        organizationId: ctx.organizationId // Security: ensure org ownership
      },
      data: {
        isDismissed: true,
        dismissedAt: new Date()
      }
    });

    return { success: true };
  });
```

---

## Testing

**File**: `apps/app/e2e/tests/framework-updates/overview-card.spec.ts`

```typescript
test.describe('Framework Updates Card', () => {
  test('should show updates card on overview', async ({ page }) => {
    await page.goto('/test-org/frameworks');

    await expect(page.locator('text=Framework Updates')).toBeVisible();
  });

  test('should show conflict badge for unresolved conflicts', async ({ page }) => {
    await page.goto('/test-org/frameworks');

    const badge = page.locator('text=Requiring Review');
    await expect(badge).toBeVisible();
  });

  test('should navigate to conflict resolution', async ({ page }) => {
    await page.goto('/test-org/frameworks');

    await page.click('button:has-text("Review All Conflicts")');

    await expect(page).toHaveURL(/\/frameworks\/updates\/.*\/review/);
  });

  test('should dismiss applied update', async ({ page }) => {
    await page.goto('/test-org/frameworks');

    await page.click('button:has-text("View Changes")');
    await page.click('button:has-text("Dismiss")');

    // Should disappear from list
    await expect(page.locator('text=HIPAA v1.1.0')).not.toBeVisible();
  });
});
```

---

## Success Criteria

- ✅ Framework Updates card appears on Overview page
- ✅ Card shows unresolved conflicts prominently
- ✅ Changelog is expandable with clickable items
- ✅ Links navigate to correct controls/policies/tasks
- ✅ Sync status badges show on detail pages
- ✅ Dismiss functionality works
- ✅ E2E tests pass

---

## Estimated Effort

- **FrameworkUpdatesCard component**: 3 days
- **SyncStatusBadge component**: 1 day
- **Integration with Overview**: 1 day
- **Dismiss functionality**: 1 day
- **E2E tests**: 1 day

**Total**: 7 days (1 week)

---

## Next Phase

➡️ **Phase 8**: Automated Testing
