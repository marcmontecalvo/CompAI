# Phase 8: Automated Testing

**Status**: Not Started
**Est. Effort**: 1.5 weeks
**Dependencies**: All previous phases
**Blockers**: None

---

## Overview

Comprehensive test coverage for the framework update system including unit tests, integration tests, and E2E tests. Ensure reliability, catch regressions, and provide confidence for production deployment.

---

## Objectives

- ✅ Unit tests for core logic (90%+ coverage)
- ✅ Integration tests for database operations
- ✅ E2E tests for critical user flows
- ✅ Test fixtures and factories
- ✅ Mock external dependencies (Novu, Trigger.dev)
- ✅ Performance tests
- ✅ Snapshot tests for UI components

---

## Test Structure

```
apps/app/
├── src/
│   ├── lib/framework-updates/
│   │   ├── __tests__/
│   │   │   ├── detect-customizations.test.ts
│   │   │   ├── resolve-conflicts.test.ts
│   │   │   ├── apply-updates.test.ts
│   │   │   └── notifications.test.ts
│   ├── actions/framework-updates/
│   │   └── __tests__/
│   │       └── update-actions.test.ts
│   ├── jobs/framework-update/
│   │   └── __tests__/
│   │       ├── detector.test.ts
│   │       ├── applier.test.ts
│   │       └── reminder.test.ts
│   └── components/framework-updates/
│       └── __tests__/
│           ├── FrameworkUpdatesCard.test.tsx
│           └── SyncStatusBadge.test.tsx
└── e2e/
    └── tests/
        └── framework-updates/
            ├── admin-create-campaign.spec.ts
            ├── user-resolve-conflicts.spec.ts
            ├── overview-card.spec.ts
            └── notification-flow.spec.ts
```

---

## Unit Tests

### 1. Customization Detection Tests

**File**: `apps/app/src/lib/framework-updates/__tests__/detect-customizations.test.ts`

```typescript
import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import { detectControlCustomization, detectPolicyCustomization } from '../detect-customizations';
import { db } from '@/lib/db';
import { createTestControl, createTestPolicy, cleanupTestData } from '@/test/fixtures';

describe('Customization Detection', () => {
  beforeEach(async () => {
    await cleanupTestData();
  });

  afterEach(async () => {
    await cleanupTestData();
  });

  describe('detectControlCustomization', () => {
    it('should detect name customization', async () => {
      const control = await createTestControl({
        name: 'Custom Name',
        controlTemplate: {
          name: 'Template Name'
        }
      });

      const result = await detectControlCustomization(control.id);

      expect(result.isCustomized).toBe(true);
      expect(result.customizedFields).toContain('name');
      expect(result.reason).toBe('modified');
    });

    it('should detect description customization', async () => {
      const control = await createTestControl({
        name: 'Same Name',
        description: 'Custom Description',
        controlTemplate: {
          name: 'Same Name',
          description: 'Template Description'
        }
      });

      const result = await detectControlCustomization(control.id);

      expect(result.isCustomized).toBe(true);
      expect(result.customizedFields).toContain('description');
    });

    it('should not flag if values match template', async () => {
      const control = await createTestControl({
        name: 'Same Name',
        description: 'Same Description',
        controlTemplate: {
          name: 'Same Name',
          description: 'Same Description'
        }
      });

      const result = await detectControlCustomization(control.id);

      expect(result.isCustomized).toBe(false);
      expect(result.customizedFields).toHaveLength(0);
      expect(result.reason).toBe('synced');
    });

    it('should detect detached control (no template)', async () => {
      const control = await createTestControl({
        controlTemplateId: null
      });

      const result = await detectControlCustomization(control.id);

      expect(result.isCustomized).toBe(true);
      expect(result.customizedFields).toEqual(['*']);
      expect(result.reason).toBe('detached');
    });

    it('should detect multiple customized fields', async () => {
      const control = await createTestControl({
        name: 'Custom Name',
        description: 'Custom Description',
        controlTemplate: {
          name: 'Template Name',
          description: 'Template Description'
        }
      });

      const result = await detectControlCustomization(control.id);

      expect(result.isCustomized).toBe(true);
      expect(result.customizedFields).toContain('name');
      expect(result.customizedFields).toContain('description');
      expect(result.customizedFields).toHaveLength(2);
    });
  });

  describe('detectPolicyCustomization', () => {
    it('should detect content customization in Tiptap JSON', async () => {
      const policy = await createTestPolicy({
        content: [
          {
            type: 'doc',
            content: [
              { type: 'paragraph', content: [{ type: 'text', text: 'Custom content' }] }
            ]
          }
        ],
        policyTemplate: {
          content: {
            type: 'doc',
            content: [
              { type: 'paragraph', content: [{ type: 'text', text: 'Template content' }] }
            ]
          }
        }
      });

      const result = await detectPolicyCustomization(policy.id);

      expect(result.isCustomized).toBe(true);
      expect(result.customizedFields).toContain('content');
    });

    it('should ignore formatting differences in content', async () => {
      // Same content, different whitespace
      const policy = await createTestPolicy({
        content: [
          {
            type: 'doc',
            content: [{ type: 'paragraph', content: [{ type: 'text', text: 'Same content' }] }]
          }
        ],
        policyTemplate: {
          content: {
            type: 'doc',
            content: [
              { type: 'paragraph', content: [{ type: 'text', text: 'Same content  ' }] } // Extra space
            ]
          }
        }
      });

      const result = await detectPolicyCustomization(policy.id);

      expect(result.isCustomized).toBe(false); // Normalized comparison ignores whitespace
    });
  });
});
```

---

### 2. Conflict Resolution Tests

**File**: `apps/app/src/lib/framework-updates/__tests__/resolve-conflicts.test.ts`

```typescript
import { resolveControlConflict, ResolutionStrategy } from '../resolve-conflicts';

describe('Conflict Resolution', () => {
  describe('accept strategy', () => {
    it('should overwrite customizations with template values', async () => {
      const control = await createTestControl({
        name: 'Custom Name',
        description: 'Custom Description',
        isCustomized: true,
        customizedFields: ['name', 'description'],
        controlTemplate: {
          name: 'Template Name',
          description: 'Template Description'
        }
      });

      await resolveControlConflict(control.id, 'accept');

      const updated = await db.control.findUnique({ where: { id: control.id } });

      expect(updated.name).toBe('Template Name');
      expect(updated.description).toBe('Template Description');
      expect(updated.isCustomized).toBe(false);
      expect(updated.customizedFields).toHaveLength(0);
      expect(updated.syncStatus).toBe('synced');
    });
  });

  describe('keep strategy', () => {
    it('should preserve customizations', async () => {
      const control = await createTestControl({
        name: 'Custom Name',
        isCustomized: true,
        customizedFields: ['name']
      });

      await resolveControlConflict(control.id, 'keep');

      const updated = await db.control.findUnique({ where: { id: control.id } });

      expect(updated.name).toBe('Custom Name'); // Unchanged
      expect(updated.isCustomized).toBe(true); // Still customized
      expect(updated.syncStatus).toBe('synced'); // But marked as synced
    });
  });

  describe('detach strategy', () => {
    it('should break template link', async () => {
      const control = await createTestControl({
        controlTemplateId: 'tpl_123'
      });

      await resolveControlConflict(control.id, 'detach');

      const updated = await db.control.findUnique({ where: { id: control.id } });

      expect(updated.controlTemplateId).toBeNull();
      expect(updated.syncStatus).toBe('detached');
      expect(updated.customizedFields).toEqual(['*']);
    });
  });
});
```

---

### 3. Update Application Tests

**File**: `apps/app/src/lib/framework-updates/__tests__/apply-updates.test.ts`

```typescript
describe('Apply Framework Updates', () => {
  it('should auto-apply non-customized controls', async () => {
    const org = await createTestOrg();
    const control = await createTestControl({
      organizationId: org.id,
      name: 'Old Name',
      isCustomized: false,
      controlTemplate: {
        name: 'New Name'
      }
    });

    await applyFrameworkUpdate(org.id, 'frk_hipaa', '1.1.0');

    const updated = await db.control.findUnique({ where: { id: control.id } });

    expect(updated.name).toBe('New Name');
    expect(updated.templateVersion).toBe('1.1.0');
  });

  it('should flag customized controls as conflicts', async () => {
    const org = await createTestOrg();
    const control = await createTestControl({
      organizationId: org.id,
      name: 'Custom Name',
      isCustomized: true,
      customizedFields: ['name']
    });

    const result = await applyFrameworkUpdate(org.id, 'frk_hipaa', '1.1.0');

    expect(result.hasConflicts).toBe(true);
    expect(result.controlsConflict).toBe(1);

    const updated = await db.control.findUnique({ where: { id: control.id } });
    expect(updated.syncStatus).toBe('conflict');
  });

  it('should preserve task completion data', async () => {
    const task = await createTestTask({
      status: 'done',
      lastCompletedAt: new Date('2025-01-01'),
      reviewDate: new Date('2025-04-01'),
      isCustomized: false
    });

    await applyFrameworkUpdate(task.organizationId, 'frk_hipaa', '1.1.0');

    const updated = await db.task.findUnique({ where: { id: task.id } });

    expect(updated.status).toBe('done'); // Preserved
    expect(updated.lastCompletedAt).toEqual(new Date('2025-01-01')); // Preserved
    expect(updated.reviewDate).toEqual(new Date('2025-04-01')); // Preserved
  });
});
```

---

## Integration Tests

### Database Transaction Tests

**File**: `apps/app/src/lib/framework-updates/__tests__/integration/apply-updates.integration.test.ts`

```typescript
describe('Framework Update Integration', () => {
  it('should complete full update flow in transaction', async () => {
    const org = await createTestOrg();

    // Create framework instance
    await createFrameworkInstance(org.id, 'frk_hipaa');

    // Create 10 controls, 5 policies, 3 tasks
    await createTestControls(10, { organizationId: org.id });
    await createTestPolicies(5, { organizationId: org.id });
    await createTestTasks(3, { organizationId: org.id });

    // Update template
    await updateFrameworkTemplate('frk_hipaa', {
      majorVersion: 1,
      minorVersion: 1,
      patchVersion: 0
    });

    // Create campaign
    const campaign = await createUpdateCampaign({
      frameworkId: 'frk_hipaa',
      fromVersion: '1.0.0',
      toVersion: '1.1.0'
    });

    // Apply update
    await applyFrameworkUpdate(org.id, 'frk_hipaa', '1.1.0');

    // Verify all entities updated
    const controls = await db.control.findMany({
      where: { organizationId: org.id }
    });

    expect(controls.every((c) => c.templateVersion === '1.1.0')).toBe(true);

    // Verify log created
    const log = await db.frameworkUpdateLog.findFirst({
      where: { campaignId: campaign.id, organizationId: org.id }
    });

    expect(log).toBeDefined();
    expect(log.status).toBe('applied');
  });

  it('should rollback on error', async () => {
    const org = await createTestOrg();

    // Mock database error mid-transaction
    jest.spyOn(db.control, 'update').mockRejectedValueOnce(new Error('Database error'));

    await expect(applyFrameworkUpdate(org.id, 'frk_hipaa', '1.1.0')).rejects.toThrow();

    // Verify no partial updates
    const controls = await db.control.findMany({
      where: { organizationId: org.id, templateVersion: '1.1.0' }
    });

    expect(controls).toHaveLength(0); // Transaction rolled back
  });
});
```

---

## E2E Tests

### Admin Create Campaign Flow

**File**: `apps/app/e2e/tests/framework-updates/admin-create-campaign.spec.ts`

```typescript
import { test, expect } from '@playwright/test';

test.describe('Platform Admin - Create Update Campaign', () => {
  test.beforeEach(async ({ page }) => {
    // Login as platform admin
    await page.goto('/login');
    await page.fill('[name="email"]', 'admin@compai.com');
    await page.fill('[name="password"]', 'password');
    await page.click('button[type="submit"]');
  });

  test('should complete campaign creation wizard', async ({ page }) => {
    await page.goto('/platform-admin/campaigns/new');

    // Step 1: Select framework
    await page.selectOption('[name="frameworkId"]', 'frk_hipaa');
    await expect(page.locator('text=Current version: 1.0.0')).toBeVisible();
    await page.click('button:has-text("Next")');

    // Step 2: Review changes
    await expect(page.locator('text=Review Changes')).toBeVisible();
    await page.fill('[name="changelog"]', 'Updated encryption standards to TLS 1.3');
    await page.click('button:has-text("Next")');

    // Step 3: Impact analysis
    await expect(page.locator('text=Affected Organizations')).toBeVisible();
    await expect(page.locator('text=15 organizations')).toBeVisible();
    await page.click('button:has-text("Continue to Schedule")');

    // Step 4: Schedule
    await page.click('[value="scheduled"]');
    await page.fill('[name="scheduledAt"]', '2025-06-01T02:00');
    await page.click('button:has-text("Next")');

    // Step 5: Confirm
    await expect(page.locator('text=Create Campaign')).toBeVisible();
    await page.click('button:has-text("Create Campaign")');

    // Verify success
    await expect(page.locator('text=Campaign created successfully')).toBeVisible();
    await expect(page).toHaveURL(/\/platform-admin\/campaigns\/[a-z0-9]+/);
  });

  test('should show validation errors', async ({ page }) => {
    await page.goto('/platform-admin/campaigns/new');

    // Skip framework selection
    await page.click('button:has-text("Next")');

    // Should show error
    await expect(page.locator('text=Please select a framework')).toBeVisible();
  });
});
```

### User Resolve Conflicts Flow

**File**: `apps/app/e2e/tests/framework-updates/user-resolve-conflicts.spec.ts`

```typescript
test.describe('User - Resolve Conflicts', () => {
  test('should resolve control conflict by accepting template', async ({ page }) => {
    await page.goto('/test-org/frameworks/updates/camp_123/review');

    // Should show conflict
    await expect(page.locator('text=3 items with conflicts')).toBeVisible();

    // Expand first conflict
    await page.click('[data-testid="conflict-ctl_1"]');

    // Should show 3-column diff
    await expect(page.locator('text=Your Current Version')).toBeVisible();
    await expect(page.locator('text=Template Update')).toBeVisible();
    await expect(page.locator('text=Your Choice')).toBeVisible();

    // Choose "Accept Template Update"
    await page.click('button:has-text("Accept Template Update")');

    // Apply resolutions
    await page.click('button:has-text("Apply Resolutions")');

    // Verify success
    await expect(page.locator('text=Conflicts resolved successfully')).toBeVisible();
  });

  test('should use bulk actions', async ({ page }) => {
    await page.goto('/test-org/frameworks/updates/camp_123/review');

    // Click "Accept All Template Updates"
    await page.click('button:has-text("Accept All Template Updates")');

    // Confirm dialog
    await page.click('button:has-text("Confirm")');

    // Verify all resolved
    await expect(page.locator('text=All conflicts resolved')).toBeVisible();
  });
});
```

---

## Test Fixtures

**File**: `apps/app/test/fixtures/framework-updates.ts`

```typescript
import { db } from '@/lib/db';

export async function createTestControl(overrides: Partial<Control> = {}) {
  const template = overrides.controlTemplate
    ? await db.frameworkEditorControlTemplate.create({
        data: {
          id: `tpl_${Date.now()}`,
          name: overrides.controlTemplate.name || 'Template Control',
          description: overrides.controlTemplate.description || 'Template Description'
        }
      })
    : null;

  return db.control.create({
    data: {
      id: `ctl_${Date.now()}`,
      name: overrides.name || 'Test Control',
      description: overrides.description || 'Test Description',
      organizationId: overrides.organizationId || 'org_test',
      controlTemplateId: template?.id,
      isCustomized: overrides.isCustomized ?? false,
      customizedFields: overrides.customizedFields || [],
      syncStatus: overrides.syncStatus || 'synced',
      ...overrides
    }
  });
}

export async function createTestCampaign(overrides: Partial<FrameworkUpdateCampaign> = {}) {
  return db.frameworkUpdateCampaign.create({
    data: {
      id: `camp_${Date.now()}`,
      frameworkId: overrides.frameworkId || 'frk_hipaa',
      fromVersion: overrides.fromVersion || '1.0.0',
      toVersion: overrides.toVersion || '1.1.0',
      status: overrides.status || 'draft',
      affectedOrgCount: overrides.affectedOrgCount || 0,
      createdBy: overrides.createdBy || 'system',
      ...overrides
    }
  });
}

export async function cleanupTestData() {
  await db.frameworkUpdateLog.deleteMany({ where: { campaignId: { startsWith: 'camp_test' } } });
  await db.frameworkUpdateCampaign.deleteMany({ where: { id: { startsWith: 'camp_test' } } });
  await db.control.deleteMany({ where: { id: { startsWith: 'ctl_test' } } });
  // etc.
}
```

---

## Performance Tests

**File**: `apps/app/src/lib/framework-updates/__tests__/performance.test.ts`

```typescript
describe('Performance Tests', () => {
  it('should detect customizations for 1000 controls in <5s', async () => {
    const controls = await createTestControls(1000);

    const start = Date.now();
    await detectOrganizationCustomizations('org_test', 'frk_hipaa');
    const duration = Date.now() - start;

    expect(duration).toBeLessThan(5000);
  });

  it('should apply updates to 100 orgs in <60s', async () => {
    const orgs = await createTestOrgs(100);

    const start = Date.now();
    for (const org of orgs) {
      await applyFrameworkUpdate(org.id, 'frk_hipaa', '1.1.0');
    }
    const duration = Date.now() - start;

    expect(duration).toBeLessThan(60000);
  });
});
```

---

## Success Criteria

- ✅ Unit test coverage > 90%
- ✅ All integration tests pass
- ✅ E2E tests cover critical user journeys
- ✅ Performance benchmarks met
- ✅ Tests run in CI/CD pipeline
- ✅ No flaky tests

---

## Estimated Effort

- **Unit tests**: 4 days
- **Integration tests**: 2 days
- **E2E tests**: 3 days
- **Test fixtures**: 1 day
- **Performance tests**: 1 day

**Total**: 11 days (1.5 weeks)

---

## Next Phase

➡️ **Phase 9**: Documentation & Rollout
