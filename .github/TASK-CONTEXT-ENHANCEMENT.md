# TASK: Context Enhancement - Enhanced Setup Wizard & Firecrawl Integration

**Status:** Not Started
**Priority:** Medium
**Estimated Effort:** 38-50 hours
**Created:** 2025-11-06

## Issue Summary

The Settings > Context feature is a critical component that shapes AI-generated policies, but currently has shallow coverage. The setup wizard only asks 13 basic questions with limited character constraints (300 char max for company description).

Enhanced context collection would significantly improve the quality and relevance of AI-generated compliance content by providing deeper organizational understanding.

## Current Limitations

- Only 13 setup wizard questions
- Shallow questions with 300 character limits
- No automatic extraction from company website
- No proactive gap detection
- Context cannot be reviewed/edited before onboarding completion
- Context not structured by category for targeted AI usage

## Implementation Plan

### Phase 1: Enhanced Questions (6-8 hours)
- [ ] Add 6-7 deeper setup wizard questions:
  - Business model & revenue streams
  - Primary customer/patient types
  - Data collection methods & touchpoints
  - Critical business processes
  - Existing compliance programs
  - Third-party integrations & data sharing
  - Incident history & security posture
- [ ] Increase character limits for detailed responses (300 → 1000 chars)
- [ ] Add optional "skip" for non-applicable questions
- [ ] Update database schema if needed

### Phase 2: Firecrawl Website Scraping (12-16 hours)
- [ ] Integrate Firecrawl API during setup wizard
- [ ] Auto-extract from "About Us", "Services", "Privacy Policy" pages
- [ ] Parse and structure extracted content
- [ ] Present extracted info for user confirmation/editing
- [ ] Store as additional context entries
- [ ] Handle edge cases (no website, private pages, scraping failures)
- [ ] Add cost estimation and confirmation step

### Phase 3: Context Review UI (8-10 hours)
- [ ] Create pre-onboarding context review page
- [ ] Allow editing of all collected context before finalizing
- [ ] Show scraped vs manually entered context
- [ ] Add "Add Additional Context" button
- [ ] Implement save/continue workflow
- [ ] Add validation for required fields

### Phase 4: Enhanced AI Usage (6-8 hours)
- [ ] Structure context into categories:
  - Company Profile
  - Technical Infrastructure
  - Security & Compliance
  - Data & Privacy
  - Business Operations
- [ ] Modify `getOrganizationContext()` to return structured data
- [ ] Update AI prompts to use categorized context
- [ ] Add context relevance scoring for different use cases
- [ ] Test improved policy generation quality

### Phase 5: Gap Detection (6-8 hours)
- [ ] Implement context completeness scoring
- [ ] Create proactive prompts for missing critical context
- [ ] Add "Improve Context" workflow in Settings > Context
- [ ] Show context gaps in dashboard/overview
- [ ] Add AI suggestions for missing information
- [ ] Create periodic context refresh reminders

## Expected Results

After completion:
- Richer, more detailed organizational context collected during setup
- Automatic extraction of company information from website
- Ability to review and edit context before completing onboarding
- Improved AI-generated policy quality and relevance
- Proactive identification of context gaps
- Structured context categories for targeted AI usage

## Technical Details

**Files to modify:**
- `apps/app/src/app/(app)/setup/lib/constants.ts` - Add new questions
- `apps/app/src/jobs/tasks/onboarding/onboard-organization-helpers.ts` - Update `getOrganizationContext()`
- `packages/db/prisma/schema/context.prisma` - Add category field
- `apps/app/src/app/(app)/[orgId]/policies/[policyId]/actions/regenerate-policy.ts` - Use structured context
- New files for Firecrawl integration and context review UI

**New Dependencies:**
- Firecrawl API integration (already configured with `FIRECRAWL_API_KEY`)

**Cost Considerations:**
- Firecrawl: ~$0.65 per organization (5-10 pages @ $0.10-0.15/page)
- Estimated monthly cost for 100 new orgs: $65-130/month

**Related Documentation:**
- See `SCOPING_DOCUMENT.md` for detailed technical specifications and code examples

## Success Metrics

- [ ] Setup wizard includes at least 6 new deeper questions
- [ ] Firecrawl successfully extracts content from 90%+ of websites
- [ ] Users can review/edit all context before onboarding completion
- [ ] Context completeness score shown in UI
- [ ] AI-generated policies show measurable improvement in relevance
- [ ] Gap detection identifies missing critical context
- [ ] All automated tests pass
