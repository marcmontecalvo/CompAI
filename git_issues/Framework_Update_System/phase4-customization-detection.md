# Phase 4: Customization Detection & Conflict Resolution

**Status**: Not Started
**Est. Effort**: 1-2 weeks
**Dependencies**: Phase 1 (Database Schema)
**Blockers**: None

---

## Overview

Implement algorithms to detect when organization instances have been customized from templates, identify conflicts when templates are updated, and provide resolution strategies. This is critical for preserving user customizations while allowing template updates.

---

## Objectives

- ✅ Build customization detection algorithm
- ✅ Implement field-level diff comparison
- ✅ Create conflict identification logic
- ✅ Build merge strategies for different conflict types
- ✅ Implement customization flagging on save
- ✅ Create conflict resolution workflow
- ✅ Add customization history tracking

---

## Customization Detection Algorithm

**File**: `apps/app/src/lib/framework-updates/detect-customizations.ts`

```typescript
import { db } from '@/lib/db';
import { isEqual } from 'lodash';

export interface CustomizationResult {
  isCustomized: boolean;
  customizedFields: string[];
  reason: 'modified' | 'detached' | 'synced';
  conflicts?: ConflictDetail[];
}

export interface ConflictDetail {
  field: string;
  currentValue: any;
  templateValue: any;
  conflictType: 'text' | 'structure' | 'reference';
}

/**
 * Detect if a control instance has been customized from its template
 */
export async function detectControlCustomization(
  controlId: string
): Promise<CustomizationResult> {
  const control = await db.control.findUnique({
    where: { id: controlId },
    include: { controlTemplate: true }
  });

  if (!control) {
    throw new Error(`Control ${controlId} not found`);
  }

  // If no template reference, it's fully custom
  if (!control.controlTemplateId || !control.controlTemplate) {
    return {
      isCustomized: true,
      customizedFields: ['*'],
      reason: 'detached'
    };
  }

  const customizedFields: string[] = [];
  const conflicts: ConflictDetail[] = [];

  // Compare name
  if (control.name !== control.controlTemplate.name) {
    customizedFields.push('name');
    conflicts.push({
      field: 'name',
      currentValue: control.name,
      templateValue: control.controlTemplate.name,
      conflictType: 'text'
    });
  }

  // Compare description
  if (control.description !== control.controlTemplate.description) {
    customizedFields.push('description');
    conflicts.push({
      field: 'description',
      currentValue: control.description,
      templateValue: control.controlTemplate.description,
      conflictType: 'text'
    });
  }

  return {
    isCustomized: customizedFields.length > 0,
    customizedFields,
    reason: customizedFields.length > 0 ? 'modified' : 'synced',
    conflicts: conflicts.length > 0 ? conflicts : undefined
  };
}

/**
 * Detect if a policy instance has been customized (includes rich content comparison)
 */
export async function detectPolicyCustomization(
  policyId: string
): Promise<CustomizationResult> {
  const policy = await db.policy.findUnique({
    where: { id: policyId },
    include: { policyTemplate: true }
  });

  if (!policy?.policyTemplate) {
    return {
      isCustomized: true,
      customizedFields: ['*'],
      reason: 'detached'
    };
  }

  const customizedFields: string[] = [];
  const conflicts: ConflictDetail[] = [];

  // Compare name
  if (policy.name !== policy.policyTemplate.name) {
    customizedFields.push('name');
    conflicts.push({
      field: 'name',
      currentValue: policy.name,
      templateValue: policy.policyTemplate.name,
      conflictType: 'text'
    });
  }

  // Compare content (Tiptap JSON) - more complex
  // Note: policy.content is Json[] (versioned), take latest
  const latestContent = policy.content[policy.content.length - 1];
  const templateContent = policy.policyTemplate.content;

  if (!isEqual(normalizeContent(latestContent), normalizeContent(templateContent))) {
    customizedFields.push('content');
    conflicts.push({
      field: 'content',
      currentValue: latestContent,
      templateValue: templateContent,
      conflictType: 'structure'
    });
  }

  // Compare frequency
  if (policy.frequency !== policy.policyTemplate.frequency) {
    customizedFields.push('frequency');
  }

  // Compare department
  if (policy.department !== policy.policyTemplate.department) {
    customizedFields.push('department');
  }

  return {
    isCustomized: customizedFields.length > 0,
    customizedFields,
    reason: customizedFields.length > 0 ? 'modified' : 'synced',
    conflicts: conflicts.length > 0 ? conflicts : undefined
  };
}

/**
 * Normalize Tiptap content for comparison (strip formatting, whitespace)
 */
function normalizeContent(content: any): any {
  if (!content) return null;

  // Create a normalized copy
  const normalized = JSON.parse(JSON.stringify(content));

  // Remove transient fields
  const removeFields = (obj: any) => {
    if (typeof obj !== 'object' || obj === null) return;

    // Remove fields that don't affect content semantics
    delete obj.createdAt;
    delete obj.updatedAt;
    delete obj.id;

    // Recursively process children
    if (obj.content && Array.isArray(obj.content)) {
      obj.content.forEach(removeFields);
    }
  };

  removeFields(normalized);
  return normalized;
}

/**
 * Detect task customizations
 */
export async function detectTaskCustomization(
  taskId: string
): Promise<CustomizationResult> {
  const task = await db.task.findUnique({
    where: { id: taskId },
    include: { taskTemplate: true }
  });

  if (!task?.taskTemplate) {
    return {
      isCustomized: true,
      customizedFields: ['*'],
      reason: 'detached'
    };
  }

  const customizedFields: string[] = [];

  if (task.title !== task.taskTemplate.name) customizedFields.push('title');
  if (task.description !== task.taskTemplate.description) customizedFields.push('description');
  if (task.frequency !== task.taskTemplate.frequency) customizedFields.push('frequency');
  if (task.department !== task.taskTemplate.department) customizedFields.push('department');

  return {
    isCustomized: customizedFields.length > 0,
    customizedFields,
    reason: customizedFields.length > 0 ? 'modified' : 'synced'
  };
}

/**
 * Batch detect customizations for all instances in an organization
 */
export async function detectOrganizationCustomizations(
  organizationId: string,
  frameworkId: string
) {
  const [controls, policies, tasks] = await Promise.all([
    db.control.findMany({
      where: {
        organizationId,
        controlTemplateId: { not: null }
      },
      include: { controlTemplate: true }
    }),
    db.policy.findMany({
      where: {
        organizationId,
        policyTemplateId: { not: null }
      },
      include: { policyTemplate: true }
    }),
    db.task.findMany({
      where: {
        organizationId,
        taskTemplateId: { not: null }
      },
      include: { taskTemplate: true }
    })
  ]);

  const results = {
    controls: [] as { id: string; result: CustomizationResult }[],
    policies: [] as { id: string; result: CustomizationResult }[],
    tasks: [] as { id: string; result: CustomizationResult }[]
  };

  // Detect control customizations
  for (const control of controls) {
    const result = await detectControlCustomization(control.id);
    results.controls.push({ id: control.id, result });
  }

  // Detect policy customizations
  for (const policy of policies) {
    const result = await detectPolicyCustomization(policy.id);
    results.policies.push({ id: policy.id, result });
  }

  // Detect task customizations
  for (const task of tasks) {
    const result = await detectTaskCustomization(task.id);
    results.tasks.push({ id: task.id, result });
  }

  return results;
}
```

---

## Auto-Flag Customizations on Save

**File**: `apps/app/src/actions/control/update-control-action.ts`

```typescript
export const updateControlAction = authWithOrgAccessClient
  .inputSchema(updateControlSchema)
  .action(async ({ parsedInput, ctx }) => {
    const { id, name, description } = parsedInput;

    // Fetch control with template
    const control = await db.control.findUnique({
      where: { id },
      include: { controlTemplate: true }
    });

    // Detect if this update creates a customization
    let isCustomized = control.isCustomized;
    let customizedFields = [...control.customizedFields];

    if (control.controlTemplate) {
      if (name !== control.controlTemplate.name && !customizedFields.includes('name')) {
        customizedFields.push('name');
        isCustomized = true;
      }

      if (
        description !== control.controlTemplate.description &&
        !customizedFields.includes('description')
      ) {
        customizedFields.push('description');
        isCustomized = true;
      }
    }

    // Update control with customization flags
    const updated = await db.control.update({
      where: { id },
      data: {
        name,
        description,
        isCustomized,
        customizedFields,
        syncStatus: isCustomized ? 'conflict' : 'synced'
      }
    });

    // Log audit event
    await db.auditLog.create({
      data: {
        entityType: 'control',
        entityId: id,
        organizationId: ctx.organizationId,
        userId: ctx.userId,
        description: isCustomized
          ? `Control customized: ${customizedFields.join(', ')}`
          : 'Control updated',
        data: { name, description, isCustomized, customizedFields }
      }
    });

    return updated;
  });
```

---

## Conflict Resolution Strategies

**File**: `apps/app/src/lib/framework-updates/resolve-conflicts.ts`

```typescript
export type ResolutionStrategy = 'accept' | 'keep' | 'detach' | 'merge';

export interface ConflictResolution {
  controlId?: string;
  policyId?: string;
  taskId?: string;
  strategy: ResolutionStrategy;
  mergedValue?: any; // For custom merges
}

/**
 * Apply conflict resolution for a control
 */
export async function resolveControlConflict(
  controlId: string,
  strategy: ResolutionStrategy
) {
  const control = await db.control.findUnique({
    where: { id: controlId },
    include: { controlTemplate: true }
  });

  if (!control?.controlTemplate) {
    throw new Error('Control has no template to resolve against');
  }

  switch (strategy) {
    case 'accept':
      // Accept template update, overwrite customizations
      await db.control.update({
        where: { id: controlId },
        data: {
          name: control.controlTemplate.name,
          description: control.controlTemplate.description,
          isCustomized: false,
          customizedFields: [],
          syncStatus: 'synced',
          lastSyncedAt: new Date(),
          templateVersion: control.controlTemplate.version // Assume version exists
        }
      });
      break;

    case 'keep':
      // Keep customizations, mark as synced (ignore template changes)
      await db.control.update({
        where: { id: controlId },
        data: {
          syncStatus: 'synced',
          lastSyncedAt: new Date()
        }
      });
      break;

    case 'detach':
      // Permanently detach from template
      await db.control.update({
        where: { id: controlId },
        data: {
          controlTemplateId: null, // Break template link
          syncStatus: 'detached',
          customizedFields: ['*']
        }
      });
      break;

    case 'merge':
      // Custom merge (not implemented here, would require manual intervention)
      throw new Error('Merge strategy requires manual implementation');
  }

  // Log resolution
  await db.auditLog.create({
    data: {
      entityType: 'control',
      entityId: controlId,
      organizationId: control.organizationId,
      description: `Conflict resolved: ${strategy}`,
      data: { strategy, templateId: control.controlTemplateId }
    }
  });
}

/**
 * Batch apply resolutions for an entire update campaign
 */
export async function batchResolveConflicts(
  organizationId: string,
  campaignId: string,
  resolutions: ConflictResolution[]
) {
  await db.$transaction(async (tx) => {
    for (const resolution of resolutions) {
      if (resolution.controlId) {
        await resolveControlConflict(resolution.controlId, resolution.strategy);
      } else if (resolution.policyId) {
        // Similar for policies
      } else if (resolution.taskId) {
        // Similar for tasks
      }
    }

    // Update campaign log
    await tx.frameworkUpdateLog.update({
      where: {
        campaignId_organizationId: {
          campaignId,
          organizationId
        }
      },
      data: {
        status: 'applied',
        appliedAt: new Date()
      }
    });
  });
}
```

---

## Smart Conflict Detection

Identify which changes are true conflicts vs. safe to auto-apply:

```typescript
export interface ConflictAnalysis {
  isSafeToAutoApply: boolean;
  reason: string;
  conflictType: 'none' | 'minor' | 'major';
}

/**
 * Analyze if a template update conflicts with customizations
 */
export function analyzeConflict(
  currentValue: any,
  templateValue: any,
  customizedFields: string[]
): ConflictAnalysis {
  // No customizations = safe to auto-apply
  if (customizedFields.length === 0) {
    return {
      isSafeToAutoApply: true,
      reason: 'No customizations detected',
      conflictType: 'none'
    };
  }

  // If only non-conflicting fields customized, still safe
  const nonConflictingFields = ['order', 'assigneeId']; // User-specific, not content
  const hasContentCustomization = customizedFields.some(
    (field) => !nonConflictingFields.includes(field)
  );

  if (!hasContentCustomization) {
    return {
      isSafeToAutoApply: true,
      reason: 'Only non-content fields customized',
      conflictType: 'minor'
    };
  }

  // Check if template changes different fields than customizations
  // Example: User customized name, template updated description = no conflict
  const templateChangedFields = detectChangedFields(currentValue, templateValue);
  const hasOverlap = customizedFields.some((field) => templateChangedFields.includes(field));

  if (!hasOverlap) {
    return {
      isSafeToAutoApply: true,
      reason: 'Template changes different fields than customizations',
      conflictType: 'minor'
    };
  }

  // True conflict: both user and template changed same field
  return {
    isSafeToAutoApply: false,
    reason: 'User and template both modified same fields',
    conflictType: 'major'
  };
}

function detectChangedFields(oldValue: any, newValue: any): string[] {
  const changed: string[] = [];

  if (typeof oldValue !== 'object' || typeof newValue !== 'object') {
    return changed;
  }

  for (const key of Object.keys(newValue)) {
    if (!isEqual(oldValue[key], newValue[key])) {
      changed.push(key);
    }
  }

  return changed;
}
```

---

## Testing

**File**: `apps/app/src/lib/framework-updates/__tests__/detect-customizations.test.ts`

```typescript
describe('Customization Detection', () => {
  it('should detect name customization', async () => {
    const result = await detectControlCustomization('ctl_custom_name');

    expect(result.isCustomized).toBe(true);
    expect(result.customizedFields).toContain('name');
    expect(result.reason).toBe('modified');
  });

  it('should not flag if values match template', async () => {
    const result = await detectControlCustomization('ctl_unchanged');

    expect(result.isCustomized).toBe(false);
    expect(result.customizedFields).toHaveLength(0);
  });

  it('should detect detached control', async () => {
    const result = await detectControlCustomization('ctl_no_template');

    expect(result.isCustomized).toBe(true);
    expect(result.reason).toBe('detached');
  });
});

describe('Conflict Analysis', () => {
  it('should identify safe auto-apply scenario', () => {
    const analysis = analyzeConflict(
      { name: 'Old', description: 'Custom Desc' },
      { name: 'New', description: 'Custom Desc' }, // Only name changed
      ['description'] // User customized description
    );

    expect(analysis.isSafeToAutoApply).toBe(true);
    expect(analysis.conflictType).toBe('minor');
  });

  it('should identify true conflict', () => {
    const analysis = analyzeConflict(
      { name: 'Old', description: 'Old Desc' },
      { name: 'New', description: 'New Desc' }, // Description changed
      ['description'] // User also changed description
    );

    expect(analysis.isSafeToAutoApply).toBe(false);
    expect(analysis.conflictType).toBe('major');
  });
});
```

---

## Success Criteria

- ✅ Detection algorithm identifies all customization types
- ✅ Policy content comparison handles Tiptap JSON correctly
- ✅ Conflict analysis distinguishes safe vs. unsafe updates
- ✅ Resolution strategies apply correctly (accept/keep/detach)
- ✅ Customizations auto-flagged on save
- ✅ Unit tests cover all detection scenarios (90%+ coverage)
- ✅ Performance: Batch detection completes <5s per 1000 items

---

## Gotchas

1. **Tiptap JSON Comparison**: Formatting changes vs. content changes
   - Solution: Normalize before comparison

2. **Task Status Preservation**: Don't flag status as customization
   - Solution: Exclude status, lastCompletedAt, reviewDate from comparison

3. **False Positives**: Whitespace differences flagged as customizations
   - Solution: Trim and normalize text before comparison

---

## Estimated Effort

- **Detection algorithm**: 3 days
- **Auto-flagging on save**: 2 days
- **Conflict resolution**: 3 days
- **Smart analysis**: 2 days
- **Testing**: 2 days

**Total**: 12 days (1.5-2 weeks)

---

## Next Phase

➡️ **Phase 5**: Background Jobs (Trigger.dev)
