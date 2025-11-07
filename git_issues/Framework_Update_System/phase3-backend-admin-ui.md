# Phase 3: Backend Admin UI

**Status**: Not Started
**Est. Effort**: 2-3 weeks
**Dependencies**: Phase 1 (Database Schema)
**Blockers**: None

---

## Overview

Build a web-based administration interface for managing framework templates, creating update campaigns, monitoring rollouts, and resolving conflicts. This provides CompAI platform administrators with full visibility and control over framework updates.

---

## Objectives

- ✅ Create `platform_admin` role and access control
- ✅ Build framework template management UI
- ✅ Create update campaign wizard
- ✅ Build rollout monitoring dashboard
- ✅ Create conflict resolution UI
- ✅ Implement version history viewer
- ✅ Add rollback capabilities

---

## Access Control

### New Role: `platform_admin`

**File**: `apps/app/src/utils/permissions.ts`

```typescript
export const platformAdmin = ac.newRole({
  app: ['create', 'update', 'delete', 'read'],
  frameworks: ['create', 'update', 'delete', 'publish'],  // NEW
  templates: ['create', 'update', 'delete'],  // NEW
  campaigns: ['create', 'update', 'cancel'],  // NEW
  organizations: ['read', 'impersonate'],  // Read-only org access
});
```

### Middleware Protection

**File**: `apps/app/src/middleware.ts`

```typescript
// Add platform admin route protection
if (pathname.startsWith('/platform-admin')) {
  const user = await getUser(request);

  if (!user || !user.roles.includes('platform_admin')) {
    return NextResponse.redirect(new URL('/unauthorized', request.url));
  }
}
```

### Database: Platform Admin Users

Add field to `User` model:

```prisma
model User {
  // ... existing fields ...
  isPlatformAdmin Boolean @default(false)
}
```

---

## Route Structure

All admin pages under `/platform-admin/*`:

```
/platform-admin
├── /frameworks                    # List all framework templates
├── /frameworks/[id]               # Framework detail/edit
├── /frameworks/[id]/controls      # Manage controls
├── /frameworks/[id]/policies      # Manage policies
├── /frameworks/[id]/tasks         # Manage tasks
├── /frameworks/[id]/versions      # Version history
├── /frameworks/[id]/preview       # Preview changes
├── /frameworks/[id]/publish       # Publish new version
├── /campaigns                     # All update campaigns
├── /campaigns/new                 # Create campaign wizard
├── /campaigns/[id]                # Campaign details/monitor
├── /campaigns/[id]/preview        # Preview campaign impact
├── /campaigns/[id]/organizations  # Per-org status
└── /settings                      # Platform admin settings
```

---

## Page 1: Frameworks List

**File**: `apps/app/src/app/platform-admin/frameworks/page.tsx`

**Features**:
- Table showing all framework templates
- Columns: Name, Version, Status, Last Updated, Orgs Using, Actions
- Filters: Visible/Hidden, Has Unpublished Changes
- Search by framework name
- Actions: Edit, View Updates, Create Campaign

**Implementation**:

```typescript
export default async function PlatformAdminFrameworksPage() {
  const frameworks = await db.frameworkEditorFramework.findMany({
    include: {
      _count: {
        select: { frameworkInstances: true }
      }
    },
    orderBy: { updatedAt: 'desc' }
  });

  return (
    <div className="container mx-auto py-8">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">Framework Templates</h1>
        <Button onClick={() => router.push('/platform-admin/frameworks/new')}>
          Create Framework
        </Button>
      </div>

      <DataTable
        columns={frameworkColumns}
        data={frameworks}
        searchable
        filterable
      />
    </div>
  );
}

const frameworkColumns: ColumnDef<FrameworkWithCount>[] = [
  {
    accessorKey: 'name',
    header: 'Framework',
    cell: ({ row }) => (
      <div>
        <div className="font-medium">{row.original.name}</div>
        <div className="text-sm text-muted-foreground">{row.original.description}</div>
      </div>
    ),
  },
  {
    accessorKey: 'version',
    header: 'Version',
    cell: ({ row }) => {
      const { majorVersion, minorVersion, patchVersion, publishedAt } = row.original;
      const version = `${majorVersion}.${minorVersion}.${patchVersion}`;
      return (
        <div>
          <div className="font-mono">{version}</div>
          {publishedAt && (
            <div className="text-xs text-muted-foreground">
              {formatDistanceToNow(publishedAt, { addSuffix: true })}
            </div>
          )}
        </div>
      );
    },
  },
  {
    accessorKey: '_count.frameworkInstances',
    header: 'Organizations',
    cell: ({ row }) => (
      <Badge variant="outline">{row.original._count.frameworkInstances}</Badge>
    ),
  },
  {
    accessorKey: 'visible',
    header: 'Visibility',
    cell: ({ row }) => (
      <Badge variant={row.original.visible ? 'default' : 'secondary'}>
        {row.original.visible ? 'Visible' : 'Hidden'}
      </Badge>
    ),
  },
  {
    id: 'actions',
    cell: ({ row }) => <FrameworkActionsMenu framework={row.original} />,
  },
];
```

---

## Page 2: Framework Editor

**File**: `apps/app/src/app/platform-admin/frameworks/[id]/page.tsx`

**Features**:
- Tabs: Overview, Controls, Policies, Tasks, Relations
- Inline editing with live preview
- Version bump controls (major/minor/patch)
- Changelog editor (markdown with preview)
- Publish button (creates new version)

**Implementation**:

```typescript
export default async function FrameworkEditorPage({ params }: { params: { id: string } }) {
  const framework = await db.frameworkEditorFramework.findUnique({
    where: { id: params.id },
    include: {
      requirements: {
        include: {
          controlTemplates: true
        }
      }
    }
  });

  return (
    <div className="container mx-auto py-8">
      <FrameworkEditorHeader framework={framework} />

      <Tabs defaultValue="overview">
        <TabsList>
          <TabsTrigger value="overview">Overview</TabsTrigger>
          <TabsTrigger value="controls">Controls</TabsTrigger>
          <TabsTrigger value="policies">Policies</TabsTrigger>
          <TabsTrigger value="tasks">Tasks</TabsTrigger>
          <TabsTrigger value="changelog">Changelog</TabsTrigger>
        </TabsList>

        <TabsContent value="overview">
          <FrameworkOverviewTab framework={framework} />
        </TabsContent>

        <TabsContent value="controls">
          <ControlTemplatesTab frameworkId={framework.id} />
        </TabsContent>

        <TabsContent value="policies">
          <PolicyTemplatesTab frameworkId={framework.id} />
        </TabsContent>

        <TabsContent value="tasks">
          <TaskTemplatesTab frameworkId={framework.id} />
        </TabsContent>

        <TabsContent value="changelog">
          <ChangelogEditorTab framework={framework} />
        </TabsContent>
      </Tabs>
    </div>
  );
}
```

**Control Templates Tab Component**:

```typescript
function ControlTemplatesTab({ frameworkId }: { frameworkId: string }) {
  const [controls, setControls] = useState<ControlTemplate[]>([]);
  const [editingControl, setEditingControl] = useState<ControlTemplate | null>(null);

  return (
    <div className="space-y-4">
      <div className="flex justify-between">
        <h2 className="text-2xl font-bold">Control Templates</h2>
        <Button onClick={() => setEditingControl({ id: '', name: '', description: '' })}>
          Add Control
        </Button>
      </div>

      <DataTable
        columns={controlTemplateColumns}
        data={controls}
        onRowClick={(control) => setEditingControl(control)}
      />

      {editingControl && (
        <ControlEditorDialog
          control={editingControl}
          onSave={handleSaveControl}
          onCancel={() => setEditingControl(null)}
        />
      )}
    </div>
  );
}
```

---

## Page 3: Update Campaign Wizard

**File**: `apps/app/src/app/platform-admin/campaigns/new/page.tsx`

**Multi-step wizard**:

**Step 1**: Select Framework
- Dropdown of all frameworks
- Show current version
- Show number of affected organizations

**Step 2**: Review Changes
- Auto-detect changes since last published version
- Show diff for each changed control/policy/task
- Allow editing changelog

**Step 3**: Impact Analysis
- List all affected organizations
- Estimate number of conflicts (based on `isCustomized` flag)
- Show per-org customization count

**Step 4**: Schedule
- Immediate execution
- Scheduled (date/time picker)
- Staged rollout (5% → 25% → 100%)
- Per-org maintenance windows

**Step 5**: Confirm & Create
- Summary of all selections
- Create campaign button

**Implementation**:

```typescript
export default function CreateCampaignWizard() {
  const [step, setStep] = useState(1);
  const [formData, setFormData] = useState({
    frameworkId: '',
    changelog: '',
    scheduleType: 'immediate',
    scheduledAt: null,
    stagingStrategy: 'all-at-once',
  });

  return (
    <div className="container mx-auto py-8 max-w-4xl">
      <h1 className="text-3xl font-bold mb-6">Create Update Campaign</h1>

      <StepIndicator currentStep={step} totalSteps={5} />

      {step === 1 && (
        <SelectFrameworkStep
          value={formData.frameworkId}
          onChange={(id) => setFormData({ ...formData, frameworkId: id })}
          onNext={() => setStep(2)}
        />
      )}

      {step === 2 && (
        <ReviewChangesStep
          frameworkId={formData.frameworkId}
          changelog={formData.changelog}
          onChangelogChange={(changelog) => setFormData({ ...formData, changelog })}
          onNext={() => setStep(3)}
          onBack={() => setStep(1)}
        />
      )}

      {step === 3 && (
        <ImpactAnalysisStep
          frameworkId={formData.frameworkId}
          onNext={() => setStep(4)}
          onBack={() => setStep(2)}
        />
      )}

      {step === 4 && (
        <ScheduleStep
          scheduleType={formData.scheduleType}
          scheduledAt={formData.scheduledAt}
          stagingStrategy={formData.stagingStrategy}
          onChange={(data) => setFormData({ ...formData, ...data })}
          onNext={() => setStep(5)}
          onBack={() => setStep(3)}
        />
      )}

      {step === 5 && (
        <ConfirmStep
          formData={formData}
          onConfirm={handleCreateCampaign}
          onBack={() => setStep(4)}
        />
      )}
    </div>
  );
}
```

**Impact Analysis Component**:

```typescript
async function ImpactAnalysisStep({ frameworkId, onNext, onBack }) {
  const analysis = await analyzeUpdateImpact(frameworkId);

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold">Impact Analysis</h2>

      <Alert>
        <AlertCircle className="h-4 w-4" />
        <AlertTitle>Affected Organizations</AlertTitle>
        <AlertDescription>
          This update will affect <strong>{analysis.totalOrgs}</strong> organizations.
        </AlertDescription>
      </Alert>

      <Card>
        <CardHeader>
          <CardTitle>Estimated Conflicts</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-3 gap-4">
            <div>
              <div className="text-3xl font-bold">{analysis.estimatedControlConflicts}</div>
              <div className="text-sm text-muted-foreground">Control Conflicts</div>
            </div>
            <div>
              <div className="text-3xl font-bold">{analysis.estimatedPolicyConflicts}</div>
              <div className="text-sm text-muted-foreground">Policy Conflicts</div>
            </div>
            <div>
              <div className="text-3xl font-bold">{analysis.estimatedTaskConflicts}</div>
              <div className="text-sm text-muted-foreground">Task Conflicts</div>
            </div>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>High-Risk Organizations</CardTitle>
          <CardDescription>Organizations with many customizations</CardDescription>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Organization</TableHead>
                <TableHead>Customized Items</TableHead>
                <TableHead>Est. Conflicts</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {analysis.highRiskOrgs.map((org) => (
                <TableRow key={org.id}>
                  <TableCell>{org.name}</TableCell>
                  <TableCell>{org.customizedCount}</TableCell>
                  <TableCell>
                    <Badge variant="destructive">{org.estimatedConflicts}</Badge>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      <div className="flex justify-between">
        <Button variant="outline" onClick={onBack}>Back</Button>
        <Button onClick={onNext}>Continue to Schedule</Button>
      </div>
    </div>
  );
}
```

---

## Page 4: Campaign Monitoring Dashboard

**File**: `apps/app/src/app/platform-admin/campaigns/[id]/page.tsx`

**Features**:
- Real-time progress bar
- Per-org status table with filtering
- Error logs
- Rollback button (if within 24 hours)
- Export results to CSV

**Implementation**:

```typescript
export default async function CampaignMonitorPage({ params }: { params: { id: string } }) {
  const campaign = await db.frameworkUpdateCampaign.findUnique({
    where: { id: params.id },
    include: {
      framework: true,
      logs: {
        include: { organization: true },
        orderBy: { startedAt: 'desc' }
      }
    }
  });

  const stats = {
    total: campaign.affectedOrgCount,
    applied: campaign.successCount,
    conflict: campaign.conflictCount,
    failed: campaign.errorCount,
    pending: campaign.affectedOrgCount - campaign.successCount - campaign.conflictCount - campaign.errorCount,
  };

  const progressPercent = ((stats.applied + stats.conflict) / stats.total) * 100;

  return (
    <div className="container mx-auto py-8">
      <div className="mb-6">
        <h1 className="text-3xl font-bold">{campaign.framework.name} Update</h1>
        <p className="text-muted-foreground">
          {campaign.fromVersion} → {campaign.toVersion}
        </p>
        <Badge variant={statusBadgeVariant(campaign.status)}>{campaign.status}</Badge>
      </div>

      <div className="grid gap-6">
        {/* Progress Section */}
        <Card>
          <CardHeader>
            <CardTitle>Overall Progress</CardTitle>
          </CardHeader>
          <CardContent>
            <Progress value={progressPercent} className="mb-4" />
            <div className="grid grid-cols-5 gap-4 text-center">
              <div>
                <div className="text-2xl font-bold">{stats.total}</div>
                <div className="text-sm text-muted-foreground">Total</div>
              </div>
              <div>
                <div className="text-2xl font-bold text-green-600">{stats.applied}</div>
                <div className="text-sm text-muted-foreground">Applied</div>
              </div>
              <div>
                <div className="text-2xl font-bold text-yellow-600">{stats.conflict}</div>
                <div className="text-sm text-muted-foreground">Conflicts</div>
              </div>
              <div>
                <div className="text-2xl font-bold text-red-600">{stats.failed}</div>
                <div className="text-sm text-muted-foreground">Failed</div>
              </div>
              <div>
                <div className="text-2xl font-bold text-gray-600">{stats.pending}</div>
                <div className="text-sm text-muted-foreground">Pending</div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Per-Org Status Table */}
        <Card>
          <CardHeader>
            <div className="flex justify-between items-center">
              <CardTitle>Organization Status</CardTitle>
              <div className="flex gap-2">
                <Button variant="outline" onClick={handleExportCSV}>
                  Export CSV
                </Button>
                {canRollback(campaign) && (
                  <Button variant="destructive" onClick={handleRollback}>
                    Rollback
                  </Button>
                )}
              </div>
            </div>
          </CardHeader>
          <CardContent>
            <DataTable
              columns={campaignLogColumns}
              data={campaign.logs}
              filterable={{
                column: 'status',
                options: ['applied', 'conflict', 'failed', 'pending']
              }}
            />
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
```

---

## Page 5: Conflict Resolution UI

**File**: `apps/app/src/app/[orgId]/frameworks/updates/[campaignId]/review/page.tsx`

**Note**: This is org-admin facing, not platform admin.

**Features**:
- Three-column diff view (Current | Template | Action)
- Bulk actions: Accept All | Keep All | Detach All
- Per-item actions: Accept | Keep | Detach | Merge
- Preview impact of each choice
- Save and apply button

**Implementation**:

```typescript
export default async function ConflictReviewPage({
  params
}: {
  params: { orgId: string; campaignId: string };
}) {
  const conflicts = await getConflictsForOrganization(params.orgId, params.campaignId);

  return (
    <div className="container mx-auto py-8">
      <h1 className="text-3xl font-bold mb-6">Review Framework Update Conflicts</h1>

      <Alert className="mb-6">
        <AlertCircle className="h-4 w-4" />
        <AlertTitle>Action Required</AlertTitle>
        <AlertDescription>
          You have {conflicts.length} items with conflicts that need your review before the update
          can be completed.
        </AlertDescription>
      </Alert>

      <Card className="mb-6">
        <CardHeader>
          <CardTitle>Bulk Actions</CardTitle>
        </CardHeader>
        <CardContent className="flex gap-2">
          <Button onClick={() => handleBulkAction('accept')}>Accept All Template Updates</Button>
          <Button variant="outline" onClick={() => handleBulkAction('keep')}>
            Keep All Customizations
          </Button>
          <Button variant="destructive" onClick={() => handleBulkAction('detach')}>
            Detach All from Template
          </Button>
        </CardContent>
      </Card>

      <div className="space-y-4">
        {conflicts.map((conflict) => (
          <ConflictDiffCard key={conflict.id} conflict={conflict} />
        ))}
      </div>

      <div className="flex justify-end mt-6">
        <Button size="lg" onClick={handleApplyResolutions}>
          Apply Resolutions
        </Button>
      </div>
    </div>
  );
}

function ConflictDiffCard({ conflict }) {
  const [action, setAction] = useState<'accept' | 'keep' | 'detach' | null>(null);

  return (
    <Card>
      <CardHeader>
        <div className="flex justify-between items-center">
          <div>
            <CardTitle>{conflict.name}</CardTitle>
            <CardDescription>Control ID: {conflict.id}</CardDescription>
          </div>
          <Badge variant="destructive">Conflict</Badge>
        </div>
      </CardHeader>
      <CardContent>
        <div className="grid grid-cols-3 gap-4 mb-4">
          {/* Current Version */}
          <div>
            <h3 className="font-semibold mb-2">Your Current Version</h3>
            <div className="bg-muted p-4 rounded">
              <div className="font-medium">{conflict.current.name}</div>
              <div className="text-sm mt-2">{conflict.current.description}</div>
            </div>
          </div>

          {/* Template Version */}
          <div>
            <h3 className="font-semibold mb-2">Template Update</h3>
            <div className="bg-blue-50 p-4 rounded">
              <div className="font-medium">{conflict.template.name}</div>
              <div className="text-sm mt-2">{conflict.template.description}</div>
            </div>
            <div className="mt-2">
              <DiffHighlight
                oldText={conflict.current.description}
                newText={conflict.template.description}
              />
            </div>
          </div>

          {/* Action Selection */}
          <div>
            <h3 className="font-semibold mb-2">Your Choice</h3>
            <div className="space-y-2">
              <Button
                variant={action === 'accept' ? 'default' : 'outline'}
                className="w-full"
                onClick={() => setAction('accept')}
              >
                Accept Template Update
              </Button>
              <Button
                variant={action === 'keep' ? 'default' : 'outline'}
                className="w-full"
                onClick={() => setAction('keep')}
              >
                Keep My Version
              </Button>
              <Button
                variant={action === 'detach' ? 'destructive' : 'outline'}
                className="w-full"
                onClick={() => setAction('detach')}
              >
                Detach from Template
              </Button>
            </div>
            {action && (
              <Alert className="mt-4">
                <AlertDescription>{getActionDescription(action)}</AlertDescription>
              </Alert>
            )}
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
```

---

## Components

### Key Shared Components

**File**: `apps/app/src/components/platform-admin/DiffHighlight.tsx`

```typescript
import { diffWords } from 'diff';

export function DiffHighlight({ oldText, newText }: { oldText: string; newText: string }) {
  const diff = diffWords(oldText, newText);

  return (
    <div className="font-mono text-sm">
      {diff.map((part, index) => (
        <span
          key={index}
          className={cn({
            'bg-red-200 line-through': part.removed,
            'bg-green-200': part.added,
          })}
        >
          {part.value}
        </span>
      ))}
    </div>
  );
}
```

---

## Testing Requirements

### E2E Tests

**File**: `apps/app/e2e/tests/platform-admin/framework-update.spec.ts`

```typescript
test.describe('Platform Admin - Framework Updates', () => {
  test('should create update campaign', async ({ page }) => {
    await page.goto('/platform-admin/campaigns/new');

    // Step 1: Select framework
    await page.selectOption('[name="frameworkId"]', 'frk_hipaa');
    await page.click('button:has-text("Next")');

    // Step 2: Review changes
    await expect(page.locator('text=Review Changes')).toBeVisible();
    await page.fill('[name="changelog"]', 'Updated encryption standards');
    await page.click('button:has-text("Next")');

    // Step 3: Impact analysis
    await expect(page.locator('text=Affected Organizations')).toBeVisible();
    await page.click('button:has-text("Continue")');

    // Step 4: Schedule
    await page.click('[value="immediate"]');
    await page.click('button:has-text("Next")');

    // Step 5: Confirm
    await page.click('button:has-text("Create Campaign")');

    await expect(page.locator('text=Campaign created successfully')).toBeVisible();
  });
});
```

---

## Success Criteria

- ✅ Platform admin can access `/platform-admin/*` routes
- ✅ Non-admin users are redirected with 403 error
- ✅ Framework list loads all templates with correct counts
- ✅ Framework editor allows inline editing
- ✅ Update campaign wizard completes all 5 steps
- ✅ Campaign monitoring shows real-time progress
- ✅ Conflict resolution UI shows three-column diff
- ✅ E2E tests cover main workflows

---

## Estimated Effort

- **Access control setup**: 1 day
- **Frameworks list page**: 2 days
- **Framework editor**: 4 days
- **Campaign wizard**: 4 days
- **Campaign monitoring**: 3 days
- **Conflict resolution UI**: 3 days
- **E2E tests**: 2 days

**Total**: 19 days (3-4 weeks)

---

## Next Phase

➡️ **Phase 4**: Customization Detection & Conflict Resolution
