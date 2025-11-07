# CompAI Enhancement Scoping Document

## Issue #1: Framework Links Not Clickable ✅ FIXED

### Problem
Frameworks displayed on the `/frameworks` overview page were not clickable, preventing users from navigating to framework detail pages.

### Root Cause
The `FrameworksOverview.tsx` component rendered frameworks as static `<div>` elements without any link functionality.

### Solution Implemented
- Added `Link` import from `next/link`
- Wrapped framework display in `<Link href={`/${organizationId}/frameworks/${framework.id}`}>`
- Added hover styles (`hover:bg-muted/50`) to indicate clickability
- File modified: `apps/app/src/app/(app)/[orgId]/frameworks/components/FrameworksOverview.tsx`

### Status: ✅ DEPLOYED
Users can now click on frameworks to view details and access the delete functionality.

---

## Issue #2: HIPAA Framework Content Insufficiency

### Problem
Organizations with only HIPAA selected receive generic SOC 2-style controls/policies instead of HIPAA-specific compliance content. The system shows 11 controls that are ALL cross-framework (HIPAA + SOC 2 + ISO 27001), with **zero HIPAA-specific controls**.

### Current State Analysis

#### Database Architecture (Working Correctly)
The framework initialization system works as designed:
1. User selects frameworks during setup
2. `initializeOrganization()` creates FrameworkInstances
3. System queries Requirements linked to selected frameworks
4. System creates Controls/Tasks/Policies from templates mapped to those Requirements
5. All connections are properly established via RequirementMap

#### Data Gap Analysis
The HIPAA framework in the database has:
- ✅ **77 detailed requirements** (good coverage)
- ❌ **Only 11 control templates** mapped to HIPAA requirements
- ❌ **Zero HIPAA-exclusive control templates** (all 11 are shared with SOC 2/ISO)

Example of what's missing:
| Have (Generic) | Need (HIPAA-Specific) |
|---|---|
| Access Rights | Business Associate Agreements (BAAs) |
| Asset Inventory | PHI Access Logs & Monitoring |
| Endpoint Protection | HIPAA Training & Workforce Authorization |
| | Breach Notification Procedures |
| | Minimum Necessary Access (164.502(b)) |
| | PHI De-identification Procedures |
| | Patient Rights & Privacy Practices |
| | Contingency Planning for ePHI |
| | Sanction Policy for Violations |
| | Audit Controls (164.312(b)) |

### Scope for Issue #2

#### Phase 1: HIPAA Requirement Analysis (4-6 hours)
**Goal:** Map all 77 HIPAA requirements to appropriate control templates

**Tasks:**
1. Export all 77 HIPAA requirements from database
2. Analyze each requirement and categorize:
   - Already covered by existing cross-framework controls
   - Requires HIPAA-specific control template
   - Can be combined with similar requirements
3. Create mapping document showing:
   - Requirement ID + Description
   - Regulatory citation (e.g., 164.308(a)(1)(ii)(A))
   - Proposed control template name
   - Whether it's HIPAA-exclusive or cross-framework

**Deliverable:** `HIPAA_CONTROL_MAPPING.md` with complete requirement → control mapping

#### Phase 2: Control Template Creation (12-16 hours)
**Goal:** Create missing control templates in the database

**Tasks:**
1. Design control template structure for each identified gap
   - Name (clear, actionable)
   - Description (what it accomplishes)
   - Implementation guidance (how to satisfy it)
2. Create FrameworkEditorControlTemplate records
3. Link to appropriate FrameworkEditorRequirements via junction table
4. Ensure proper categorization (admin, technical, physical safeguards)

**Estimate:** 30-40 new HIPAA-specific control templates + 10-15 enhanced cross-framework controls

**SQL Example:**
```sql
-- Example: Business Associate Agreement control template
INSERT INTO "FrameworkEditorControlTemplate" (id, name, description, ...)
VALUES (
  'frk_ct_baa_001',
  'Business Associate Agreements',
  'Maintain executed BAAs with all vendors/subcontractors that create, receive, maintain, or transmit PHI on behalf of the organization. Ensure BAAs meet HIPAA requirements and are reviewed annually.',
  ...
);

-- Link to HIPAA requirement 164.308(b)(1)
INSERT INTO "_FrameworkEditorControlTemplateToFrameworkEditorRequirement" ("A", "B")
VALUES ('frk_ct_baa_001', 'frk_rq_164_308_b_1');
```

#### Phase 3: Policy & Task Template Alignment (8-10 hours)
**Goal:** Ensure policies and tasks support new control templates

**Tasks:**
1. Review existing policy templates for HIPAA coverage
2. Create HIPAA-specific policy templates:
   - Notice of Privacy Practices
   - Patient Rights Procedures
   - Breach Notification Plan
   - Sanction Policy
3. Create task templates for HIPAA-specific activities:
   - Annual BAA review
   - PHI access log audits
   - HIPAA training completion tracking
   - Risk analysis updates
4. Link new templates to control templates

**Deliverable:** 5-8 new HIPAA policy templates, 10-15 new HIPAA task templates

#### Phase 4: Testing & Validation (4-6 hours)
**Goal:** Verify complete HIPAA initialization

**Tasks:**
1. Create test organization with HIPAA-only framework
2. Verify all 77 requirements are mapped to controls
3. Verify HIPAA-specific controls/policies/tasks are created
4. Verify no "generic" controls appear without HIPAA context
5. Test with HIPAA + SOC 2 combination to ensure no duplication

**Test Cases:**
- [ ] HIPAA-only org gets PHI-specific controls
- [ ] HIPAA + SOC 2 org gets merged controls without duplication
- [ ] All 77 HIPAA requirements are addressable through controls
- [ ] HIPAA-specific policies reference correct regulations

#### Phase 5: Documentation (2-4 hours)
**Goal:** Document HIPAA coverage for compliance purposes

**Tasks:**
1. Create HIPAA compliance matrix showing:
   - Requirement citation
   - Control(s) that address it
   - Policy/task that implements it
2. Add inline citations to policy templates
3. Document how to add new requirements in future

**Deliverable:** `HIPAA_COMPLIANCE_MATRIX.md`

### Total Estimate for Issue #2: 30-42 hours

### Risks & Considerations
- **Legal Compliance:** Recommendations should be reviewed by compliance expert
- **Database Migration:** Need migration script to add templates to existing installations
- **Backward Compatibility:** Existing HIPAA orgs won't automatically get new controls (need migration strategy)
- **AI Context:** Some controls may require enhanced Context data (see Issue #3)

---

## Issue #3: Context Feature Enhancement

### Current State Analysis

#### How Context Works Today
1. **Data Collection:** Setup wizard asks 13 questions (see `/setup/lib/constants.ts`)
2. **Storage:** Answers stored in `Context` table as question/answer pairs
3. **Usage:** Context is retrieved and passed to AI for:
   - Vendor extraction (`extractVendorsFromContext`)
   - Risk identification
   - Policy generation/regeneration
   - Vendor risk assessments

#### Current Setup Wizard Questions
1. Which compliance frameworks do you need?
2. What is your company name?
3. What's your company website?
4. **Describe your company in a few sentences** (300 char max) ⚠️
5. What industry is your company in? (dropdown)
6. How many employees do you have? (dropdown)
7. What devices do your team members use? (multi-select)
8. How do team members sign in? (multi-select)
9. What software do you use? (multi-select)
10. How does your team work? (remote/hybrid/office)
11. Where do you host applications/data? (multi-select)
12. What types of data do you handle? (multi-select)
13. Where is your data located? (geographic regions)

#### Context Usage in Policy Generation
From `regenerate-policy.ts` lines 50-55:
```typescript
const contextEntries = await db.context.findMany({
  where: { organizationId: session.activeOrganizationId },
  orderBy: { createdAt: 'asc' },
});
const contextHub = contextEntries.map((c) => `${c.question}\n${c.answer}`).join('\n');
```

The entire context is passed as a string to the AI for policy customization.

### Problem Analysis

#### Current Limitations
1. **Shallow Company Description:** Only 300 characters for "describe your company"
   - Not enough context for industry-specific policies
   - Misses key business processes
   - No information about:
     - Products/services offered
     - Customer types (B2B, B2C, Government)
     - Data flows
     - Critical business functions
2. **No Website Scraping:** Website URL is collected but not used
   - Website contains rich information about business model
   - Could extract: services, customer types, locations, technology stack
3. **Generic Dropdowns:** Multi-select options may miss nuances
   - "Other" selected frequently without details
   - No free-form follow-up questions
4. **No Process Documentation:** Missing context about:
   - How customer data is collected
   - Data retention policies
   - Third-party integrations
   - Critical business processes

### Scope for Issue #3

#### Phase 1: Enhanced Context Questions (6-8 hours)
**Goal:** Add deeper context collection without overwhelming users

**Proposed New Questions:**
```typescript
// Add to setup wizard after existing questions
{
  key: 'businessModel',
  question: 'What is your primary business model?',
  options: ['B2B SaaS', 'B2C Platform', 'Healthcare Provider',
            'Financial Services', 'E-commerce', 'Other'],
},
{
  key: 'customerTypes',
  question: 'Who are your primary customers?',
  placeholder: 'e.g., Small businesses, Enterprise, Healthcare providers, Consumers',
  multiline: true,
  maxLength: 500,
},
{
  key: 'dataCollection',
  question: 'How do you collect customer/patient data?',
  placeholder: 'e.g., Web forms, Mobile app, API integrations, Point-of-sale',
  multiline: true,
  maxLength: 500,
},
{
  key: 'criticalProcesses',
  question: 'What are your 3-5 most critical business processes?',
  placeholder: 'e.g., Payment processing, Patient scheduling, Data analytics',
  multiline: true,
  maxLength: 800,
},
{
  key: 'dataRetention',
  question: 'How long do you retain customer/patient data?',
  options: ['Less than 1 year', '1-3 years', '3-7 years', '7+ years',
            'As required by law', 'Indefinitely'],
},
{
  key: 'thirdPartyIntegrations',
  question: 'List key third-party services you integrate with',
  placeholder: 'e.g., Stripe for payments, Twilio for communications, AWS for hosting',
  multiline: true,
  maxLength: 500,
},
{
  key: 'physicalLocations',
  question: 'Do you have physical office locations?',
  placeholder: 'List cities/countries or select "Fully Remote"',
  multiline: true,
  maxLength: 300,
},
```

**Changes:**
- Increase company description from 300 → 800 chars
- Add 6-7 new targeted questions
- Add conditional questions based on framework selection
  - HIPAA: PHI handling procedures, patient rights processes
  - PCI DSS: Payment processing details, cardholder data flows
  - SOC 2: Critical systems, RTO/RPO targets

**File to Modify:** `apps/app/src/app/(app)/setup/lib/constants.ts`

#### Phase 2: Firecrawl Website Scraping (12-16 hours)
**Goal:** Automatically extract context from company website

**Implementation Plan:**

1. **Trigger During Setup:**
   - After user enters website URL
   - Show "Analyzing your website..." loader
   - Scrape in background while user continues questions

2. **Firecrawl Integration:**
```typescript
// New file: apps/app/src/lib/firecrawl.ts
import FirecrawlApp from '@mendable/firecrawl-js';

const firecrawl = new FirecrawlApp({ apiKey: process.env.FIRECRAWL_API_KEY });

export async function scrapeCompanyWebsite(url: string) {
  const result = await firecrawl.scrapeUrl(url, {
    formats: ['markdown'],
    onlyMainContent: true,
  });

  return result.markdown;
}

export async function extractBusinessContext(markdown: string) {
  // Use OpenAI to extract structured data from markdown
  const { object } = await generateObject({
    model: openai('gpt-4.1-mini'),
    schema: businessContextSchema,
    system: `Extract business context from this company website content.
      Focus on: services offered, customer types, industry focus,
      technology stack, locations, and business model.`,
    prompt: markdown,
  });

  return object;
}
```

3. **What to Extract:**
   - Services/products offered
   - Target customers (B2B/B2C/Industry)
   - Technology stack (from job postings, case studies)
   - Geographic presence (from "About" page)
   - Security/compliance mentions (existing certifications)
   - Company size indicators (team photos, "About Us")

4. **Storage:**
```typescript
// Store extracted context with special tag
await db.context.createMany({
  data: [
    {
      organizationId,
      question: 'Services Offered (from website)',
      answer: extractedContext.services,
      tags: ['website-scrape', 'automated'],
    },
    // ... more context entries
  ],
});
```

5. **Error Handling:**
   - Graceful degradation if scraping fails
   - Don't block setup completion
   - Allow manual override/editing of extracted data

**Files to Create/Modify:**
- Create: `apps/app/src/lib/firecrawl.ts`
- Create: `apps/app/src/jobs/tasks/onboarding/scrape-website.ts`
- Modify: `apps/app/src/app/(app)/setup/actions/create-organization.ts`
- Modify: `apps/app/src/app/(app)/setup/components/FrameworkSelection.tsx` (add loader)

#### Phase 3: Context Review & Enhancement UI (8-10 hours)
**Goal:** Allow users to review/edit auto-generated context

**New Component:** Context Review Step (between setup and onboarding)
```typescript
// New page: apps/app/src/app/(app)/setup/review/page.tsx
export default function ContextReviewPage() {
  return (
    <div>
      <h1>Review Your Organization Profile</h1>
      <p>We've compiled information about your organization.
         Please review and edit as needed.</p>

      <ContextReviewForm
        contexts={combinedContext} // manual + scraped
        onSave={handleSave}
      />
    </div>
  );
}
```

**Features:**
- Display all collected context (manual + scraped)
- Highlight auto-generated vs manually entered
- Allow inline editing
- Add new context entries
- Preview how context will affect policies (sample generation)

**Files to Create:**
- Create: `apps/app/src/app/(app)/setup/review/page.tsx`
- Create: `apps/app/src/app/(app)/setup/review/components/ContextReviewForm.tsx`

#### Phase 4: Enhanced Context Usage in AI (6-8 hours)
**Goal:** Better utilize context in policy generation

**Current State:**
```typescript
// Simple concatenation
const contextHub = contextEntries.map((c) => `${c.question}\n${c.answer}`).join('\n');
```

**Enhanced Approach:**
```typescript
// Structured context with categorization
function buildEnhancedContext(contextEntries: Context[]) {
  const byCategory = {
    company: contextEntries.filter(c => c.tags.includes('company')),
    technical: contextEntries.filter(c => c.tags.includes('technical')),
    data: contextEntries.filter(c => c.tags.includes('data')),
    processes: contextEntries.filter(c => c.tags.includes('processes')),
    automated: contextEntries.filter(c => c.tags.includes('website-scrape')),
  };

  return `
COMPANY PROFILE:
${formatContextSection(byCategory.company)}

TECHNICAL INFRASTRUCTURE:
${formatContextSection(byCategory.technical)}

DATA HANDLING:
${formatContextSection(byCategory.data)}

BUSINESS PROCESSES:
${formatContextSection(byCategory.processes)}

ADDITIONAL CONTEXT (from website):
${formatContextSection(byCategory.automated)}
  `.trim();
}
```

**Add Context Tags:**
- Modify setup wizard to tag questions by category
- Add tags to database: `tags: ['company', 'technical', 'data', 'processes', 'onboarding']`
- Update policy generation prompts to reference specific sections

**Files to Modify:**
- Modify: `apps/app/src/jobs/tasks/onboarding/update-policies-helpers.ts`
- Modify: `apps/app/src/app\(app)\[orgId]\policies\[policyId]\actions\regenerate-policy.ts`
- Modify: Database schema to make tags more structured

#### Phase 5: Context Gaps Detection (6-8 hours)
**Goal:** Proactively identify missing context and prompt users

**Implementation:**
```typescript
// New function in onboarding-helpers.ts
async function detectContextGaps(
  organizationId: string,
  frameworks: Framework[]
): Promise<ContextGap[]> {
  const context = await db.context.findMany({
    where: { organizationId }
  });

  const gaps: ContextGap[] = [];

  // Framework-specific gaps
  if (frameworks.some(f => f.name === 'HIPAA')) {
    if (!hasAnswer(context, 'PHI handling')) {
      gaps.push({
        priority: 'high',
        question: 'How do you handle Protected Health Information (PHI)?',
        reason: 'Required for HIPAA policy customization',
      });
    }
  }

  // Industry-specific gaps
  if (hasAnswer(context, 'Healthcare', 'industry')) {
    if (!hasAnswer(context, 'patient rights')) {
      gaps.push({
        priority: 'medium',
        question: 'How do patients exercise their rights (access, amendments)?',
        reason: 'Important for Privacy Practices policy',
      });
    }
  }

  return gaps;
}
```

**Display Gaps:**
- Show in `/settings/context-hub` with "Fill Missing Context" CTA
- Periodic reminders (after 30 days if high-priority gaps remain)
- Link from policy editor: "Need better policies? Add more context"

**Files to Create/Modify:**
- Create: `apps/app/src/lib/context-gaps.ts`
- Modify: `apps/app/src/app/(app)/[orgId]/settings/context-hub/page.tsx`

### Total Estimate for Issue #3: 38-50 hours

### Phased Rollout Plan

**Phase 1 - Quick Wins (Week 1):**
- Add 5-7 new context questions to wizard
- Increase description field limits
- No breaking changes

**Phase 2 - Website Scraping (Week 2-3):**
- Implement Firecrawl integration
- Add background job for scraping
- Test with 10-20 sample company websites

**Phase 3 - Context Review (Week 3):**
- Build review UI
- Allow editing before onboarding starts
- Add "Skip for now" option

**Phase 4 - Enhanced AI Usage (Week 4):**
- Improve context formatting for AI
- Add structured context categories
- Update policy generation prompts

**Phase 5 - Gap Detection (Week 5):**
- Build gap detection logic
- Add UI for filling gaps
- Monitor adoption metrics

### Success Metrics
- **Context Completeness:** % of orgs with >80% context questions answered
- **Policy Quality:** User ratings of generated policies (before/after)
- **Time to Value:** Days from signup to published policies (target: <2 days)
- **Firecrawl Success Rate:** % of websites successfully scraped
- **Gap Fill Rate:** % of identified gaps filled within 30 days

### Risks & Considerations
- **User Fatigue:** Too many questions may cause drop-off
  - Mitigation: Make new questions optional, show progress bar
- **Firecrawl API Costs:** $0.50-1.00 per website scrape
  - Mitigation: Cache results, only scrape once per org
- **Bad Scrape Data:** Some websites may have incomplete/wrong info
  - Mitigation: Always allow manual review and editing
- **Privacy:** Scraping customer websites raises questions
  - Mitigation: Clear disclosure, only scrape public pages, allow opt-out

---

## Priority & Sequencing

### Recommended Order:
1. **Issue #1: Framework Links** ✅ DONE (deployed)
2. **Issue #3 Phase 1: Enhanced Questions** (Quick win, low risk)
3. **Issue #2 Phase 1-2: HIPAA Controls** (High value, addresses data gap)
4. **Issue #3 Phase 2: Website Scraping** (High value, medium complexity)
5. **Issue #2 Phase 3-5: Complete HIPAA** (Complete the work)
6. **Issue #3 Phase 3-5: Context Enhancements** (Polish and optimize)

### Why This Order?
- Issue #1 already done ✅
- Issue #3 Phase 1 is quick and improves immediate experience
- Issue #2 addresses core compliance problem (HIPAA content gap)
- Issue #3 Phase 2 (scraping) amplifies Issue #2 benefits
- Complete each issue fully before moving to next phase

---

## Technical Dependencies

### Required Services:
- ✅ OpenAI API (already configured)
- ✅ Firecrawl API (already configured)
- ✅ Trigger.dev (already configured)
- ✅ PostgreSQL (already configured)

### New Environment Variables Needed:
None - all services already configured!

### Database Migrations Needed:
1. **Add tags to Context table** (for categorization)
2. **Add new FrameworkEditorControlTemplate records** (HIPAA controls)
3. **Add junction table records** (link controls to requirements)
4. **Add new PolicyTemplate records** (HIPAA policies)
5. **Add new TaskTemplate records** (HIPAA tasks)

---

## Cost Analysis

### Development Time:
- Issue #1: ✅ Done
- Issue #2: 30-42 hours
- Issue #3: 38-50 hours
- **Total: 68-92 hours** (1.5-2 months for 1 developer)

### API Costs (per organization onboarding):
- OpenAI GPT-4.1-mini: ~$0.15-0.30 (existing)
- Firecrawl website scrape: ~$0.50-1.00 (new)
- **Total per org: ~$0.65-1.30**

### Monthly Costs (100 new orgs/month):
- **~$65-130/month** (very affordable)

---

## Next Steps

1. **Review & Approve Scope** - Stakeholder sign-off
2. **Create Jira/Linear Tickets** - Break down into trackable tasks
3. **Set Up Testing Environment** - Dedicated test org for HIPAA
4. **Begin Issue #3 Phase 1** - Quick wins with enhanced questions
5. **Parallel Track Issue #2 Phase 1** - HIPAA requirement analysis

---

## Questions for Product/Compliance Team

1. **HIPAA Controls:** Do you have existing compliance documentation we can reference?
2. **Legal Review:** Should HIPAA-specific policies be reviewed by legal counsel?
3. **Backward Compatibility:** Should existing HIPAA orgs automatically get new controls?
4. **Website Scraping:** Any privacy concerns with scraping customer websites?
5. **Context Storage:** Any PII considerations for storing detailed business context?

---

*Document created: 2025-11-06*
*Last updated: 2025-11-06*
*Author: Claude Code*
