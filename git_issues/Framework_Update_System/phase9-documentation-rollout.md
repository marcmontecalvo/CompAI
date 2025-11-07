# Phase 9: Documentation & Rollout

**Status**: Not Started
**Est. Effort**: 1 week
**Dependencies**: All previous phases
**Blockers**: None

---

## Overview

Create comprehensive documentation for platform admins and organization users, establish rollout procedures, and deploy the framework update system to production with proper monitoring and support processes.

---

## Objectives

- ✅ Write platform admin documentation
- ✅ Update organization user documentation
- ✅ Create changelog template
- ✅ Establish rollout schedule
- ✅ Configure monitoring and alerts
- ✅ Train support team
- ✅ Perform production deployment

---

## Admin Documentation

**File**: `packages/db/data/user_documentation/FRAMEWORK_UPDATE_ADMIN_GUIDE.md`

```markdown
# Framework Update System - Admin Guide

## Overview

The Framework Update System allows CompAI platform administrators to manage compliance framework templates, publish updates, and control rollout to organizations.

## Prerequisites

- Platform admin role (`isPlatformAdmin: true`)
- Access to `/platform-admin/*` routes
- Understanding of semantic versioning

---

## Publishing Framework Updates

### Method 1: CSV Upload (Bulk Updates)

Best for: Large updates with many controls/policies/tasks

**Step 1**: Prepare CSV files

Create update directory:
```bash
mkdir -p updates/2025-06-01-hipaa-1.1.0
```

Create CSV files (see [CSV Format Reference](#csv-format-reference))

**Step 2**: Validate CSVs
```bash
./scripts/update-framework.sh \
  --csv-dir updates/2025-06-01-hipaa-1.1.0 \
  --framework frk_hipaa \
  --dry-run
```

**Step 3**: Apply updates
```bash
./scripts/update-framework.sh \
  --csv-dir updates/2025-06-01-hipaa-1.1.0 \
  --framework frk_hipaa
```

### Method 2: Admin UI (Individual Changes)

Best for: Small updates, single control/policy changes

**Step 1**: Navigate to framework editor
- Go to `/platform-admin/frameworks`
- Click framework to edit

**Step 2**: Make changes
- Edit controls, policies, or tasks inline
- Add changelog notes
- Bump version (major/minor/patch)

**Step 3**: Publish
- Click "Publish Version"
- Review impact analysis
- Schedule or publish immediately

---

## Creating Update Campaigns

After publishing a framework version, create an update campaign:

**Option 1**: Automatic (Recommended)
- Framework Update Detector job runs daily
- Automatically creates campaigns for published updates
- Schedules for next maintenance window

**Option 2**: Manual
- Navigate to `/platform-admin/campaigns/new`
- Complete 5-step wizard:
  1. Select framework
  2. Review changes
  3. Analyze impact
  4. Schedule rollout
  5. Confirm and create

---

## Monitoring Campaign Rollout

**Dashboard**: `/platform-admin/campaigns/[id]`

**Key Metrics**:
- Overall progress (%)
- Applied count (success)
- Conflict count (needs review)
- Failed count (errors)
- Pending count (not yet in maintenance window)

**Per-Organization View**:
- Filter by status
- View conflict details
- Export results to CSV

**Rollback**:
- Available within 24 hours of update
- Navigate to campaign page
- Click "Rollback" (requires confirmation)
- Creates new campaign to revert changes

---

## Troubleshooting

### Campaign Stuck in "In Progress"

**Cause**: Job may have crashed or timed out

**Solution**:
1. Check Trigger.dev logs for errors
2. Manually trigger applier job:
   ```bash
   npx trigger-cli run framework-update-applier
   ```
3. If still stuck, manually complete:
   ```sql
   UPDATE "FrameworkUpdateCampaign"
   SET status = 'completed', completedAt = NOW()
   WHERE id = 'camp_xxx';
   ```

### High Conflict Rate (>50%)

**Cause**: Template changes conflict with common customizations

**Solution**:
1. Review conflict details per org
2. Consider providing guidance to users on recommended resolution
3. For future updates: minimize changes to commonly customized fields

### Organization Not Receiving Updates

**Cause**: Outside maintenance window or autoApply disabled

**Solution**:
1. Check org's maintenance window setting:
   ```sql
   SELECT maintenanceWindow FROM "Organization" WHERE id = 'org_xxx';
   ```
2. Verify campaign is scheduled
3. Check if org has `autoApplyUpdates = false`

---

## Best Practices

### Version Bumping

- **Patch (1.0.X)**: Bug fixes, typo corrections
- **Minor (1.X.0)**: New controls/policies, enhancements
- **Major (X.0.0)**: Breaking changes, major restructuring

### Changelog Writing

- Use clear, concise language
- Explain "why" not just "what"
- Group changes by category (Added, Changed, Removed)
- Include regulatory references if applicable

**Example**:
```markdown
## Version 1.1.0 (2025-06-01)

### Added
- Control AC-20: Breach Notification Procedures (required by HIPAA Omnibus Rule)
- Task: Quarterly Breach Risk Assessment

### Changed
- Control AC-1: Clarified MFA requirements per OCR guidance
- Policy 7: Updated encryption standards to require TLS 1.3 (TLS 1.2 deprecated)

### Removed
- Control AC-5: Consolidated into AC-1 and AC-2
```

### Testing Before Production

1. Test in staging environment first
2. Create campaign for 1-2 pilot organizations
3. Monitor for 48 hours
4. Rollout to remaining orgs if successful

### Communication

- Notify organizations 7 days before scheduled update
- Provide summary of changes in plain language
- Offer office hours or support for questions
- Send follow-up after update with confirmation

---

## CSV Format Reference

[Include comprehensive CSV format documentation from Phase 2]

---

## Support Escalation

**Level 1**: Organization admin contacts support
- Support checks campaign status
- Provides guidance on conflict resolution

**Level 2**: Persistent errors or bugs
- Escalate to engineering
- Provide campaign ID, organization ID, error logs

**Level 3**: Rollback required
- Contact platform admin
- Requires executive approval
- Document reason for rollback
```

---

## User Documentation Updates

**Update File**: `packages/db/data/user_documentation/FRAMEWORK_ADMINISTRATOR_GUIDE.md`

Add new section:

```markdown
## Framework Updates

### What are Framework Updates?

Framework updates occur when CompAI publishes new versions of compliance frameworks (e.g., HIPAA, SOC 2) with:
- New controls or policies required by regulations
- Clarifications based on regulatory guidance
- Bug fixes or improvements

### How Updates Work

1. **Notification**: You'll receive an email and in-app notification when an update is available
2. **Automatic Application**: Updates are applied during your maintenance window (default: Sunday 2 AM)
3. **Conflict Review**: If you've customized items that were also updated, you'll need to review conflicts
4. **Confirmation**: You'll receive confirmation once the update is complete

### Customizations vs. Template Sync

**Customized Items**: Items you've edited to fit your organization
**Template Items**: Items unchanged from the framework template

When you customize an item, it's flagged. Future template updates to that item will require your review.

### Reviewing Conflicts

When an update has conflicts:

1. Go to Framework Overview page
2. Click "Review Conflicts" in the Framework Updates card
3. For each conflict, choose:
   - **Accept Template Update**: Use the new version (overwrites your customization)
   - **Keep Your Version**: Preserve your customization (ignore template update)
   - **Detach from Template**: Permanently make this item custom

### Maintenance Windows

Configure when updates are applied:

1. Go to Settings → Organization
2. Set Maintenance Window (day, time, timezone)
3. Updates will only apply during this window

Default: Sunday 2:00 AM in your organization's timezone

### Auto-Apply vs. Manual Review

**Auto-Apply** (default):
- Non-conflicting changes apply automatically
- Conflicting changes flagged for review

**Manual Review** (optional):
- All changes require your approval
- Configure in Settings → Notifications

### Best Practices

- Review conflicts within 7 days (you'll receive reminders)
- Minimize customizations to reduce conflicts
- Read changelogs before resolving conflicts
- Contact support if unsure how to resolve
```

---

## Changelog Template

**File**: `packages/db/data/framework-templates/CHANGELOG_TEMPLATE.md`

```markdown
# Framework Changelog Template

Use this template for all framework version changelogs.

## Version [X.Y.Z] ([YYYY-MM-DD])

### Added
- [New Control/Policy/Task]: [Description]
  - **Why**: [Regulatory reason or business justification]
  - **Impact**: [What users need to do]

### Changed
- [Control/Policy/Task Name]: [What changed]
  - **Before**: [Old behavior]
  - **After**: [New behavior]
  - **Why**: [Reason for change]

### Deprecated
- [Control/Policy/Task Name]: [What's being phased out]
  - **Replacement**: [What to use instead]
  - **Timeline**: [When it will be removed]

### Removed
- [Control/Policy/Task Name]: [What was removed]
  - **Why**: [Reason for removal]
  - **Alternative**: [What users should do instead]

### Fixed
- [Bug or issue]: [What was fixed]

---

## Example

## Version 1.1.0 (2025-06-01)

### Added
- Control AC-20: Breach Notification Procedures
  - **Why**: Required by HIPAA Omnibus Rule for all covered entities
  - **Impact**: Organizations must document breach notification procedures and test annually

### Changed
- Control AC-1: Multi-Factor Authentication
  - **Before**: "MFA recommended for privileged access"
  - **After**: "MFA required for all remote ePHI access"
  - **Why**: HHS OCR guidance 2024 mandates MFA for remote access

- Policy 7: Encryption Policy
  - **Before**: TLS 1.2 required
  - **After**: TLS 1.3 required, TLS 1.2 permitted until 2026
  - **Why**: NIST recommendation to phase out TLS 1.2

### Removed
- Control AC-5: Legacy Access Control
  - **Why**: Functionality consolidated into AC-1 and AC-2
  - **Alternative**: Review AC-1 and AC-2 for equivalent controls
```

---

## Rollout Schedule

### Week 1: Staging Deployment

**Objectives**:
- Deploy to staging environment
- Complete smoke tests
- Verify background jobs run

**Tasks**:
- [ ] Deploy database migrations
- [ ] Deploy application code
- [ ] Configure Trigger.dev jobs
- [ ] Configure Novu workflows
- [ ] Test CSV script
- [ ] Test admin UI flows
- [ ] Test user conflict resolution

**Go/No-Go Criteria**:
- All smoke tests pass
- No critical bugs
- Performance benchmarks met

---

### Week 2: Pilot Organizations (5 orgs)

**Objectives**:
- Test with real organizations
- Gather feedback
- Identify edge cases

**Tasks**:
- [ ] Select 5 pilot organizations (diverse sizes, industries)
- [ ] Notify pilots of participation
- [ ] Create test update campaign
- [ ] Monitor campaign closely
- [ ] Collect feedback via survey
- [ ] Fix any critical issues

**Go/No-Go Criteria**:
- >80% success rate
- No data loss incidents
- Positive pilot feedback

---

### Week 3: Gradual Rollout (25% → 50% → 100%)

**Objectives**:
- Rollout to all organizations in stages
- Monitor for issues at each stage
- Support teams ready

**Tasks**:
- [ ] Day 1: Enable for 25% of organizations (stratified sampling)
- [ ] Day 3: Monitor metrics, address issues
- [ ] Day 5: Enable for 50% of organizations
- [ ] Day 7: Monitor metrics
- [ ] Day 10: Enable for 100% of organizations

**Rollback Trigger**:
- Success rate < 70%
- Multiple critical bugs reported
- Data integrity issues

---

### Week 4: Monitoring & Optimization

**Objectives**:
- Ensure system stability
- Optimize performance
- Document learnings

**Tasks**:
- [ ] Monitor all campaigns
- [ ] Analyze conflict patterns
- [ ] Optimize slow queries
- [ ] Update documentation based on real usage
- [ ] Conduct retrospective

---

## Monitoring & Alerts

### Metrics to Track

**Application Metrics**:
- Campaign success rate (target: >95%)
- Average conflict rate (target: <10%)
- Update application time (target: <60s per org)
- Notification delivery rate (target: >99%)

**Infrastructure Metrics**:
- Background job success rate (target: >99%)
- Job duration (detector: <10min, applier: <10min)
- Database query performance
- API response times

**Business Metrics**:
- Organizations using frameworks
- Average time to resolve conflicts
- Support ticket volume

### Alerts

Configure alerts in monitoring system:

**Critical** (PagerDuty):
- Campaign failure rate >10%
- Background job failing for >2 consecutive runs
- Data integrity issues detected

**Warning** (Email/Slack):
- Campaign success rate <95%
- Conflict rate >20%
- Job duration >80% of timeout

**Info** (Slack):
- New campaign created
- Campaign completed
- Large number of conflicts (>100 for single org)

---

## Support Team Training

### Training Session (2 hours)

**Agenda**:
1. Framework Update System Overview (30 min)
2. Common User Questions & Answers (30 min)
3. Admin Dashboard Demo (30 min)
4. Troubleshooting Guide (30 min)

**Materials**:
- Training slides
- Demo environment access
- Troubleshooting cheat sheet
- Escalation paths

### Support Playbook

**Common Issues**:

| Issue | Diagnosis | Resolution |
|-------|-----------|------------|
| "I didn't receive notification" | Check email delivery logs | Resend via admin dashboard |
| "Update caused errors" | Check campaign logs | Escalate to engineering |
| "Can't resolve conflict" | Guide through resolution UI | Offer phone support |
| "Want to rollback" | Check if within 24hr window | Platform admin initiates rollback |

---

## Production Deployment Checklist

### Pre-Deployment

- [ ] All tests passing (unit, integration, E2E)
- [ ] Code reviewed and approved
- [ ] Database migrations tested in staging
- [ ] Performance benchmarks met
- [ ] Security review completed
- [ ] Documentation finalized
- [ ] Support team trained
- [ ] Rollback plan documented
- [ ] Stakeholders notified

### Deployment Steps

1. [ ] Create database backup
2. [ ] Set maintenance mode (optional)
3. [ ] Run database migrations
4. [ ] Deploy application code
5. [ ] Configure background jobs
6. [ ] Configure notifications
7. [ ] Verify health checks
8. [ ] Run smoke tests
9. [ ] Monitor for 1 hour
10. [ ] Announce deployment complete

### Post-Deployment

- [ ] Monitor metrics for 48 hours
- [ ] Verify first background job runs
- [ ] Send announcement to users
- [ ] Update status page
- [ ] Schedule retrospective (1 week)

---

## Success Criteria

- ✅ Admin documentation complete and published
- ✅ User documentation updated
- ✅ Changelog template adopted
- ✅ Monitoring configured and alerts firing
- ✅ Support team trained
- ✅ Production deployment successful
- ✅ No critical bugs in first week
- ✅ Positive user feedback (survey)

---

## Estimated Effort

- **Admin documentation**: 2 days
- **User documentation**: 1 day
- **Training materials**: 1 day
- **Rollout execution**: 4 days (staged)
- **Monitoring setup**: 1 day

**Total**: 9 days (1 week with rollout)

---

## Completion

✅ All phases complete! Framework Update System is production-ready.
