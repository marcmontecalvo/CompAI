# Phase 2: CSV Update Script System

**Status**: Not Started
**Est. Effort**: 1-2 weeks
**Dependencies**: Phase 1 (Database Schema)
**Blockers**: None

---

## Overview

Create a command-line tool that allows CompAI administrators to update framework templates via CSV files. This provides a scriptable, version-controlled, and auditable way to make bulk template updates without requiring a UI.

---

## Objectives

- ✅ Define CSV formats for frameworks, controls, policies, and tasks
- ✅ Create validation logic for CSV files
- ✅ Build shell script wrapper for easy execution
- ✅ Implement dry-run mode for preview
- ✅ Create rollback capabilities
- ✅ Generate update reports
- ✅ Support incremental updates (add/update/delete)

---

## CSV File Formats

### 1. Frameworks CSV

**File**: `updates/[date]/frameworks.csv`

**Format**:
```csv
action,framework_id,name,version_major,version_minor,version_patch,changelog,visible,description
update,frk_681fdd150f59a1560a66c89a,HIPAA,1,1,0,"Added breach notification controls\n\nSee CHANGELOG.md for details",true,"Health Insurance Portability and Accountability Act"
create,frk_new_framework,GDPR,1,0,0,"Initial GDPR framework",true,"General Data Protection Regulation"
```

**Fields**:
- `action`: `create`, `update`, or `delete`
- `framework_id`: Unique framework ID (use existing ID for update, new ID for create)
- `name`: Display name
- `version_major`, `version_minor`, `version_patch`: Semantic version numbers
- `changelog`: Markdown changelog (use `\n` for newlines)
- `visible`: `true` or `false` - whether framework appears in UI
- `description`: Framework description

---

### 2. Controls CSV

**File**: `updates/[date]/controls.csv`

**Format**:
```csv
action,control_template_id,name,description,change_type,change_reason
update,ctltpl_xxx123,Access Control - MFA,"All users accessing ePHI must use multi-factor authentication (MFA). MFA must include at least two of the following: something you know (password), something you have (token), something you are (biometric).",minor,"Clarified MFA requirements per OCR guidance"
create,ctltpl_new_control,Breach Notification,"Organization must have procedures for breach notification within 60 days of discovery.",major,"New control required by HIPAA Omnibus Rule"
delete,ctltpl_deprecated,Old Access Control,"",major,"Replaced by ctltpl_xxx123"
```

**Fields**:
- `action`: `create`, `update`, or `delete`
- `control_template_id`: Control template ID
- `name`: Control name
- `description`: Full control description
- `change_type`: `major`, `minor`, or `patch` (helps users understand impact)
- `change_reason`: Why this change was made (appears in changelog)

---

### 3. Policies CSV

**File**: `updates/[date]/policies.csv`

**Format**:
```csv
action,policy_template_id,name,description,frequency,department,content_file,change_type,change_reason
update,poltpl_yyy456,Encryption Policy,"Updated to require TLS 1.3",yearly,IT,policies/encryption_policy_v1.1.json,minor,"Updated encryption standards"
create,poltpl_new_policy,Breach Notification Policy,"Procedures for breach notification",yearly,Legal,policies/breach_notification_v1.0.json,major,"New policy required"
```

**Fields**:
- `action`: `create`, `update`, or `delete`
- `policy_template_id`: Policy template ID
- `name`: Policy name
- `description`: Short description
- `frequency`: `yearly`, `quarterly`, `monthly`, `weekly`, `daily`, `once`
- `department`: `IT`, `Legal`, `HR`, `Finance`, `Operations`, `Executive`
- `content_file`: Path to JSON file with Tiptap content (relative to CSV dir)
- `change_type`: `major`, `minor`, or `patch`
- `change_reason`: Why this change was made

**Policy Content JSON Format** (`content_file`):
```json
{
  "type": "doc",
  "content": [
    {
      "type": "heading",
      "attrs": { "level": 1 },
      "content": [{ "type": "text", "text": "Encryption Policy" }]
    },
    {
      "type": "paragraph",
      "content": [{ "type": "text", "text": "All ePHI must be encrypted..." }]
    }
  ]
}
```

---

### 4. Tasks CSV

**File**: `updates/[date]/tasks.csv`

**Format**:
```csv
action,task_template_id,name,description,frequency,department,change_type,change_reason
update,tsktpl_zzz789,Quarterly Access Review,"Review all user access to ePHI systems and revoke unnecessary access. Document review in access recertification log.",quarterly,IT,minor,"Clarified documentation requirement"
create,tsktpl_new_task,Annual Breach Risk Assessment,"Conduct annual assessment of breach notification procedures.",yearly,Legal,major,"New task per updated HIPAA guidance"
```

**Fields**:
- `action`: `create`, `update`, or `delete`
- `task_template_id`: Task template ID
- `name`: Task name
- `description`: Detailed task description
- `frequency`: `yearly`, `quarterly`, `monthly`, `weekly`, `daily`, `once`, `custom`
- `department`: Same as policies
- `change_type`: `major`, `minor`, or `patch`
- `change_reason`: Why this change was made

---

### 5. Relations CSV

**File**: `updates/[date]/relations.csv`

Maps controls to requirements, controls to policies, controls to tasks.

**Format**:
```csv
action,relation_type,parent_id,child_id
create,requirement_control,reqtpl_164_312_a_1,ctltpl_new_control
create,control_policy,ctltpl_xxx123,poltpl_yyy456
create,control_task,ctltpl_xxx123,tsktpl_zzz789
delete,control_policy,ctltpl_old,poltpl_deprecated
```

**Fields**:
- `action`: `create` or `delete`
- `relation_type`: `requirement_control`, `control_policy`, or `control_task`
- `parent_id`: Parent entity ID (requirement or control)
- `child_id`: Child entity ID (control, policy, or task)

---

## Shell Script Implementation

**File**: `scripts/update-framework.sh`

```bash
#!/bin/bash
set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Default values
DRY_RUN=false
VERBOSE=false
CSV_DIR=""
FRAMEWORK_ID=""
CREATE_CAMPAIGN=true

# Usage function
usage() {
  cat << EOF
Usage: $0 [OPTIONS]

Update framework templates from CSV files.

OPTIONS:
  -d, --csv-dir DIR       Directory containing CSV files (required)
  -f, --framework ID      Framework ID to update (required)
  -n, --dry-run           Validate and preview changes without applying
  -v, --verbose           Verbose output
  --no-campaign           Don't create update campaign (just update templates)
  -h, --help              Show this help message

EXAMPLES:
  # Dry-run to preview changes
  ./scripts/update-framework.sh -d ./updates/2025-06-01 -f frk_hipaa -n

  # Apply updates and create campaign
  ./scripts/update-framework.sh -d ./updates/2025-06-01 -f frk_hipaa

  # Update templates only (no campaign)
  ./scripts/update-framework.sh -d ./updates/2025-06-01 -f frk_hipaa --no-campaign

CSV DIRECTORY STRUCTURE:
  updates/2025-06-01/
    ├── frameworks.csv
    ├── controls.csv
    ├── policies.csv
    ├── tasks.csv
    ├── relations.csv
    ├── policies/
    │   ├── encryption_policy_v1.1.json
    │   └── breach_notification_v1.0.json
    └── CHANGELOG.md

EOF
  exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--csv-dir)
      CSV_DIR="$2"
      shift 2
      ;;
    -f|--framework)
      FRAMEWORK_ID="$2"
      shift 2
      ;;
    -n|--dry-run)
      DRY_RUN=true
      shift
      ;;
    -v|--verbose)
      VERBOSE=true
      shift
      ;;
    --no-campaign)
      CREATE_CAMPAIGN=false
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Validate required arguments
if [ -z "$CSV_DIR" ] || [ -z "$FRAMEWORK_ID" ]; then
  echo -e "${RED}Error: --csv-dir and --framework are required${NC}"
  usage
fi

# Validate CSV directory exists
if [ ! -d "$CSV_DIR" ]; then
  echo -e "${RED}Error: CSV directory not found: $CSV_DIR${NC}"
  exit 1
fi

# Convert to absolute path
CSV_DIR="$(cd "$CSV_DIR" && pwd)"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Framework Update Tool${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "CSV Directory: $CSV_DIR"
echo "Framework ID:  $FRAMEWORK_ID"
echo "Dry Run:       $DRY_RUN"
echo "Create Campaign: $CREATE_CAMPAIGN"
echo ""

# Step 1: Validate CSV files
echo -e "${YELLOW}Step 1: Validating CSV files...${NC}"

VALIDATION_RESULT=$(node "$PROJECT_ROOT/apps/app/src/scripts/framework-update/validate-csv.js" \
  --csv-dir "$CSV_DIR" \
  --framework "$FRAMEWORK_ID")

if [ $? -ne 0 ]; then
  echo -e "${RED}✗ Validation failed${NC}"
  echo "$VALIDATION_RESULT"
  exit 1
fi

echo -e "${GREEN}✓ Validation passed${NC}"
echo ""

# Step 2: Preview changes
echo -e "${YELLOW}Step 2: Previewing changes...${NC}"

PREVIEW_RESULT=$(node "$PROJECT_ROOT/apps/app/src/scripts/framework-update/preview-changes.js" \
  --csv-dir "$CSV_DIR" \
  --framework "$FRAMEWORK_ID")

echo "$PREVIEW_RESULT"
echo ""

# If dry-run, stop here
if [ "$DRY_RUN" = true ]; then
  echo -e "${BLUE}Dry-run mode: No changes applied${NC}"
  exit 0
fi

# Step 3: Confirm with user
echo -e "${YELLOW}Apply these changes? (yes/no)${NC}"
read -r CONFIRM

if [ "$CONFIRM" != "yes" ]; then
  echo -e "${RED}Aborted by user${NC}"
  exit 0
fi

# Step 4: Apply updates
echo -e "${YELLOW}Step 3: Applying updates...${NC}"

UPDATE_RESULT=$(node "$PROJECT_ROOT/apps/app/src/scripts/framework-update/apply-updates.js" \
  --csv-dir "$CSV_DIR" \
  --framework "$FRAMEWORK_ID" \
  --create-campaign "$CREATE_CAMPAIGN")

if [ $? -ne 0 ]; then
  echo -e "${RED}✗ Update failed${NC}"
  echo "$UPDATE_RESULT"
  exit 1
fi

echo -e "${GREEN}✓ Updates applied successfully${NC}"
echo ""

# Step 5: Generate report
echo -e "${YELLOW}Step 4: Generating report...${NC}"

REPORT_FILE="$CSV_DIR/update-report-$(date +%Y%m%d-%H%M%S).txt"

node "$PROJECT_ROOT/apps/app/src/scripts/framework-update/generate-report.js" \
  --csv-dir "$CSV_DIR" \
  --framework "$FRAMEWORK_ID" \
  --output "$REPORT_FILE"

echo -e "${GREEN}✓ Report generated: $REPORT_FILE${NC}"
echo ""

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Update Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
```

---

## Node.js Helper Scripts

### 1. CSV Validation Script

**File**: `apps/app/src/scripts/framework-update/validate-csv.ts`

```typescript
import fs from 'fs';
import path from 'path';
import { parse } from 'csv-parse/sync';
import { z } from 'zod';

// Zod schemas for validation
const FrameworkRowSchema = z.object({
  action: z.enum(['create', 'update', 'delete']),
  framework_id: z.string().min(1),
  name: z.string().min(1),
  version_major: z.coerce.number().int().min(1),
  version_minor: z.coerce.number().int().min(0),
  version_patch: z.coerce.number().int().min(0),
  changelog: z.string().optional(),
  visible: z.enum(['true', 'false']),
  description: z.string().min(1),
});

const ControlRowSchema = z.object({
  action: z.enum(['create', 'update', 'delete']),
  control_template_id: z.string().min(1),
  name: z.string().min(1),
  description: z.string(),
  change_type: z.enum(['major', 'minor', 'patch']),
  change_reason: z.string().min(1),
});

// Similar schemas for policies, tasks, relations...

interface ValidationResult {
  valid: boolean;
  errors: string[];
  warnings: string[];
  stats: {
    frameworks: { create: number; update: number; delete: number };
    controls: { create: number; update: number; delete: number };
    policies: { create: number; update: number; delete: number };
    tasks: { create: number; update: number; delete: number };
  };
}

export async function validateCSVFiles(
  csvDir: string,
  frameworkId: string
): Promise<ValidationResult> {
  const result: ValidationResult = {
    valid: true,
    errors: [],
    warnings: [],
    stats: {
      frameworks: { create: 0, update: 0, delete: 0 },
      controls: { create: 0, update: 0, delete: 0 },
      policies: { create: 0, update: 0, delete: 0 },
      tasks: { create: 0, update: 0, delete: 0 },
    },
  };

  // Validate frameworks.csv
  const frameworksCsvPath = path.join(csvDir, 'frameworks.csv');
  if (!fs.existsSync(frameworksCsvPath)) {
    result.errors.push('frameworks.csv not found');
    result.valid = false;
    return result;
  }

  try {
    const frameworksCsv = fs.readFileSync(frameworksCsvPath, 'utf-8');
    const frameworkRows = parse(frameworksCsv, { columns: true, skip_empty_lines: true });

    for (const [index, row] of frameworkRows.entries()) {
      try {
        const validatedRow = FrameworkRowSchema.parse(row);

        // Check if this row is for the target framework
        if (validatedRow.framework_id === frameworkId) {
          result.stats.frameworks[validatedRow.action]++;

          // Additional business logic validation
          if (validatedRow.action === 'update') {
            // Verify framework exists in database
            const exists = await checkFrameworkExists(validatedRow.framework_id);
            if (!exists) {
              result.errors.push(
                `Row ${index + 2}: Framework ${validatedRow.framework_id} not found in database (action: update)`
              );
              result.valid = false;
            }
          }

          if (validatedRow.action === 'create') {
            // Verify framework doesn't exist
            const exists = await checkFrameworkExists(validatedRow.framework_id);
            if (exists) {
              result.errors.push(
                `Row ${index + 2}: Framework ${validatedRow.framework_id} already exists (action: create)`
              );
              result.valid = false;
            }
          }
        }
      } catch (error) {
        result.errors.push(`frameworks.csv row ${index + 2}: ${error.message}`);
        result.valid = false;
      }
    }
  } catch (error) {
    result.errors.push(`Failed to parse frameworks.csv: ${error.message}`);
    result.valid = false;
  }

  // Validate controls.csv
  const controlsCsvPath = path.join(csvDir, 'controls.csv');
  if (fs.existsSync(controlsCsvPath)) {
    try {
      const controlsCsv = fs.readFileSync(controlsCsvPath, 'utf-8');
      const controlRows = parse(controlsCsv, { columns: true, skip_empty_lines: true });

      for (const [index, row] of controlRows.entries()) {
        try {
          const validatedRow = ControlRowSchema.parse(row);
          result.stats.controls[validatedRow.action]++;

          // Check for duplicate IDs
          // Check for orphaned relations
          // etc.
        } catch (error) {
          result.errors.push(`controls.csv row ${index + 2}: ${error.message}`);
          result.valid = false;
        }
      }
    } catch (error) {
      result.errors.push(`Failed to parse controls.csv: ${error.message}`);
      result.valid = false;
    }
  } else {
    result.warnings.push('controls.csv not found (skipping control updates)');
  }

  // Validate policy content JSON files
  const policiesCsvPath = path.join(csvDir, 'policies.csv');
  if (fs.existsSync(policiesCsvPath)) {
    const policiesCsv = fs.readFileSync(policiesCsvPath, 'utf-8');
    const policyRows = parse(policiesCsv, { columns: true, skip_empty_lines: true });

    for (const row of policyRows) {
      if (row.content_file) {
        const contentPath = path.join(csvDir, row.content_file);
        if (!fs.existsSync(contentPath)) {
          result.errors.push(
            `Policy content file not found: ${row.content_file} (referenced in policies.csv)`
          );
          result.valid = false;
        } else {
          try {
            const content = JSON.parse(fs.readFileSync(contentPath, 'utf-8'));
            // Validate Tiptap structure
            if (!content.type || content.type !== 'doc') {
              result.errors.push(
                `Invalid Tiptap content in ${row.content_file}: missing or invalid "type: doc"`
              );
              result.valid = false;
            }
          } catch (error) {
            result.errors.push(`Invalid JSON in ${row.content_file}: ${error.message}`);
            result.valid = false;
          }
        }
      }
    }
  }

  // Validate relations.csv
  const relationsCsvPath = path.join(csvDir, 'relations.csv');
  if (fs.existsSync(relationsCsvPath)) {
    // Validate that parent/child IDs reference entities in other CSVs
    // Check for circular dependencies
    // etc.
  }

  return result;
}

// Helper function to check if framework exists
async function checkFrameworkExists(frameworkId: string): Promise<boolean> {
  const { db } = await import('@/lib/db');
  const framework = await db.frameworkEditorFramework.findUnique({
    where: { id: frameworkId },
  });
  return !!framework;
}

// CLI wrapper
if (require.main === module) {
  const args = process.argv.slice(2);
  const csvDir = args[args.indexOf('--csv-dir') + 1];
  const frameworkId = args[args.indexOf('--framework') + 1];

  validateCSVFiles(csvDir, frameworkId)
    .then((result) => {
      if (!result.valid) {
        console.error('Validation failed:');
        result.errors.forEach((err) => console.error(`  ✗ ${err}`));
        process.exit(1);
      }

      console.log('Validation passed:');
      console.log(`  Frameworks: ${JSON.stringify(result.stats.frameworks)}`);
      console.log(`  Controls: ${JSON.stringify(result.stats.controls)}`);
      console.log(`  Policies: ${JSON.stringify(result.stats.policies)}`);
      console.log(`  Tasks: ${JSON.stringify(result.stats.tasks)}`);

      if (result.warnings.length > 0) {
        console.log('\nWarnings:');
        result.warnings.forEach((warn) => console.log(`  ⚠ ${warn}`));
      }
    })
    .catch((error) => {
      console.error('Validation error:', error);
      process.exit(1);
    });
}
```

---

### 2. Preview Changes Script

**File**: `apps/app/src/scripts/framework-update/preview-changes.ts`

```typescript
import { parse } from 'csv-parse/sync';
import fs from 'fs';
import path from 'path';
import chalk from 'chalk';
import { db } from '@/lib/db';

interface ChangePreview {
  frameworks: { action: string; id: string; name: string; version: string }[];
  controls: { action: string; id: string; name: string; oldName?: string }[];
  policies: { action: string; id: string; name: string; oldName?: string }[];
  tasks: { action: string; id: string; name: string; oldName?: string }[];
}

export async function previewChanges(
  csvDir: string,
  frameworkId: string
): Promise<ChangePreview> {
  const preview: ChangePreview = {
    frameworks: [],
    controls: [],
    policies: [],
    tasks: [],
  };

  // Parse frameworks.csv
  const frameworksCsvPath = path.join(csvDir, 'frameworks.csv');
  if (fs.existsSync(frameworksCsvPath)) {
    const frameworksCsv = fs.readFileSync(frameworksCsvPath, 'utf-8');
    const frameworkRows = parse(frameworksCsv, { columns: true });

    for (const row of frameworkRows) {
      if (row.framework_id === frameworkId) {
        const version = `${row.version_major}.${row.version_minor}.${row.version_patch}`;
        preview.frameworks.push({
          action: row.action,
          id: row.framework_id,
          name: row.name,
          version,
        });
      }
    }
  }

  // Parse controls.csv
  const controlsCsvPath = path.join(csvDir, 'controls.csv');
  if (fs.existsSync(controlsCsvPath)) {
    const controlsCsv = fs.readFileSync(controlsCsvPath, 'utf-8');
    const controlRows = parse(controlsCsv, { columns: true });

    for (const row of controlRows) {
      // Fetch current control if updating
      let oldName;
      if (row.action === 'update') {
        const existingControl = await db.frameworkEditorControlTemplate.findUnique({
          where: { id: row.control_template_id },
          select: { name: true },
        });
        oldName = existingControl?.name;
      }

      preview.controls.push({
        action: row.action,
        id: row.control_template_id,
        name: row.name,
        oldName,
      });
    }
  }

  // Similar for policies and tasks...

  return preview;
}

// CLI wrapper
if (require.main === module) {
  const args = process.argv.slice(2);
  const csvDir = args[args.indexOf('--csv-dir') + 1];
  const frameworkId = args[args.indexOf('--framework') + 1];

  previewChanges(csvDir, frameworkId).then((preview) => {
    console.log(chalk.blue('\n━━━ Change Preview ━━━\n'));

    if (preview.frameworks.length > 0) {
      console.log(chalk.yellow('Frameworks:'));
      preview.frameworks.forEach((f) => {
        const actionColor =
          f.action === 'create' ? chalk.green : f.action === 'delete' ? chalk.red : chalk.cyan;
        console.log(`  ${actionColor(f.action.toUpperCase())} ${f.name} (${f.version})`);
      });
      console.log('');
    }

    if (preview.controls.length > 0) {
      console.log(chalk.yellow('Controls:'));
      preview.controls.forEach((c) => {
        const actionColor =
          c.action === 'create' ? chalk.green : c.action === 'delete' ? chalk.red : chalk.cyan;
        const nameDisplay = c.oldName && c.oldName !== c.name ? `${c.oldName} → ${c.name}` : c.name;
        console.log(`  ${actionColor(c.action.toUpperCase())} ${nameDisplay}`);
      });
      console.log('');
    }

    // Similar for policies and tasks...

    console.log(
      chalk.blue(
        `\nTotal: ${preview.controls.length + preview.policies.length + preview.tasks.length} changes\n`
      )
    );
  });
}
```

---

### 3. Apply Updates Script

**File**: `apps/app/src/scripts/framework-update/apply-updates.ts`

```typescript
import { parse } from 'csv-parse/sync';
import fs from 'fs';
import path from 'path';
import { db } from '@/lib/db';

export async function applyUpdates(
  csvDir: string,
  frameworkId: string,
  createCampaign: boolean
): Promise<void> {
  await db.$transaction(async (tx) => {
    // 1. Update framework
    const frameworksCsvPath = path.join(csvDir, 'frameworks.csv');
    if (fs.existsSync(frameworksCsvPath)) {
      const frameworksCsv = fs.readFileSync(frameworksCsvPath, 'utf-8');
      const frameworkRows = parse(frameworksCsv, { columns: true });

      for (const row of frameworkRows) {
        if (row.framework_id === frameworkId) {
          if (row.action === 'update') {
            const currentFramework = await tx.frameworkEditorFramework.findUnique({
              where: { id: frameworkId },
            });

            await tx.frameworkEditorFramework.update({
              where: { id: frameworkId },
              data: {
                name: row.name,
                description: row.description,
                visible: row.visible === 'true',
                previousVersion: `${currentFramework.majorVersion}.${currentFramework.minorVersion}.${currentFramework.patchVersion}`,
                majorVersion: parseInt(row.version_major),
                minorVersion: parseInt(row.version_minor),
                patchVersion: parseInt(row.version_patch),
                changelog: row.changelog.replace(/\\n/g, '\n'),
                publishedAt: new Date(),
              },
            });
          }
        }
      }
    }

    // 2. Update controls
    const controlsCsvPath = path.join(csvDir, 'controls.csv');
    if (fs.existsSync(controlsCsvPath)) {
      const controlsCsv = fs.readFileSync(controlsCsvPath, 'utf-8');
      const controlRows = parse(controlsCsv, { columns: true });

      for (const row of controlRows) {
        if (row.action === 'create') {
          await tx.frameworkEditorControlTemplate.create({
            data: {
              id: row.control_template_id,
              name: row.name,
              description: row.description,
            },
          });
        } else if (row.action === 'update') {
          await tx.frameworkEditorControlTemplate.update({
            where: { id: row.control_template_id },
            data: {
              name: row.name,
              description: row.description,
            },
          });
        } else if (row.action === 'delete') {
          // Soft delete: set deletedAt timestamp
          // Hard delete would orphan instances
          await tx.frameworkEditorControlTemplate.delete({
            where: { id: row.control_template_id },
          });
        }
      }
    }

    // 3. Update policies (with JSON content)
    const policiesCsvPath = path.join(csvDir, 'policies.csv');
    if (fs.existsSync(policiesCsvPath)) {
      const policiesCsv = fs.readFileSync(policiesCsvPath, 'utf-8');
      const policyRows = parse(policiesCsv, { columns: true });

      for (const row of policyRows) {
        let content = null;
        if (row.content_file) {
          const contentPath = path.join(csvDir, row.content_file);
          content = JSON.parse(fs.readFileSync(contentPath, 'utf-8'));
        }

        if (row.action === 'create') {
          await tx.frameworkEditorPolicyTemplate.create({
            data: {
              id: row.policy_template_id,
              name: row.name,
              description: row.description,
              frequency: row.frequency,
              department: row.department,
              content: content || {},
            },
          });
        } else if (row.action === 'update') {
          await tx.frameworkEditorPolicyTemplate.update({
            where: { id: row.policy_template_id },
            data: {
              name: row.name,
              description: row.description,
              frequency: row.frequency,
              department: row.department,
              ...(content && { content }),
            },
          });
        }
      }
    }

    // 4. Update tasks
    // (Similar to controls)

    // 5. Update relations
    const relationsCsvPath = path.join(csvDir, 'relations.csv');
    if (fs.existsSync(relationsCsvPath)) {
      const relationsCsv = fs.readFileSync(relationsCsvPath, 'utf-8');
      const relationRows = parse(relationsCsv, { columns: true });

      for (const row of relationRows) {
        if (row.relation_type === 'requirement_control') {
          if (row.action === 'create') {
            // Add control to requirement's controlTemplates array
            await tx.frameworkEditorRequirement.update({
              where: { id: row.parent_id },
              data: {
                controlTemplates: {
                  connect: { id: row.child_id },
                },
              },
            });
          } else if (row.action === 'delete') {
            await tx.frameworkEditorRequirement.update({
              where: { id: row.parent_id },
              data: {
                controlTemplates: {
                  disconnect: { id: row.child_id },
                },
              },
            });
          }
        }
        // Similar for control_policy and control_task
      }
    }

    // 6. Create update campaign if requested
    if (createCampaign) {
      const framework = await tx.frameworkEditorFramework.findUnique({
        where: { id: frameworkId },
      });

      const affectedOrgs = await tx.frameworkInstance.count({
        where: { frameworkId },
      });

      await tx.frameworkUpdateCampaign.create({
        data: {
          frameworkId,
          fromVersion: framework.previousVersion || '1.0.0',
          toVersion: `${framework.majorVersion}.${framework.minorVersion}.${framework.patchVersion}`,
          status: 'scheduled',
          scheduledAt: getNextSundayAt2AM(),
          affectedOrgCount: affectedOrgs,
          changelog: framework.changelog,
          createdBy: 'system', // TODO: Get from auth context
        },
      });
    }
  });
}

function getNextSundayAt2AM(): Date {
  const now = new Date();
  const nextSunday = new Date(now);
  nextSunday.setDate(now.getDate() + ((7 - now.getDay()) % 7 || 7));
  nextSunday.setHours(2, 0, 0, 0);
  return nextSunday;
}

// CLI wrapper
if (require.main === module) {
  const args = process.argv.slice(2);
  const csvDir = args[args.indexOf('--csv-dir') + 1];
  const frameworkId = args[args.indexOf('--framework') + 1];
  const createCampaign = args[args.indexOf('--create-campaign') + 1] === 'true';

  applyUpdates(csvDir, frameworkId, createCampaign)
    .then(() => {
      console.log('Updates applied successfully!');
    })
    .catch((error) => {
      console.error('Failed to apply updates:', error);
      process.exit(1);
    });
}
```

---

## Testing Requirements

### Unit Tests

**File**: `apps/app/src/scripts/framework-update/__tests__/validate-csv.test.ts`

```typescript
describe('CSV Validation', () => {
  it('should validate correct frameworks.csv', async () => {
    const result = await validateCSVFiles('./test-fixtures/valid-update', 'frk_hipaa');
    expect(result.valid).toBe(true);
    expect(result.errors).toHaveLength(0);
  });

  it('should reject invalid version numbers', async () => {
    const result = await validateCSVFiles('./test-fixtures/invalid-version', 'frk_hipaa');
    expect(result.valid).toBe(false);
    expect(result.errors).toContain(expect.stringContaining('version'));
  });

  it('should reject missing policy content files', async () => {
    const result = await validateCSVFiles('./test-fixtures/missing-content', 'frk_hipaa');
    expect(result.valid).toBe(false);
    expect(result.errors).toContain(expect.stringContaining('not found'));
  });
});
```

---

## Success Criteria

- ✅ Shell script runs without errors
- ✅ Validation catches all CSV format errors
- ✅ Dry-run mode shows accurate preview
- ✅ Updates apply correctly to database
- ✅ Relations are created/deleted properly
- ✅ Update campaign is created when requested
- ✅ Rollback works (database transaction)
- ✅ Report is generated with change summary
- ✅ Unit tests cover validation logic (90%+ coverage)

---

## Gotchas & Mitigations

### 1. CSV Encoding Issues

**Gotcha**: Special characters (quotes, commas, newlines) can break CSV parsing.

**Mitigation**:
- Use proper CSV escaping (quotes around fields with commas)
- For multi-line content (changelogs), use `\n` in CSV, replace in code
- For rich content (policies), use separate JSON files

### 2. Transaction Timeouts

**Gotcha**: Large updates (hundreds of controls) might timeout.

**Mitigation**:
- Process in batches of 50 items
- Show progress indicator
- Use longer transaction timeout for large updates

### 3. Version Conflicts

**Gotcha**: Concurrent updates to same framework.

**Mitigation**:
- Check current version before applying update
- Fail if version mismatch
- Require linear version progression

---

## Estimated Effort

- **CSV format design**: 0.5 days
- **Shell script**: 1 day
- **Validation script**: 2 days
- **Preview script**: 1 day
- **Apply script**: 2 days
- **Testing**: 1.5 days
- **Documentation**: 0.5 days

**Total**: 8.5 days (1.5-2 weeks)

---

## Next Phase

➡️ **Phase 3**: Backend Admin UI
