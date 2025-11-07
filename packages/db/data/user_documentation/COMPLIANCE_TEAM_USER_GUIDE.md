# Compliance Team User Guide - Daily Operations

## Quick Reference

This guide covers day-to-day HIPAA compliance operations for compliance team members.

---

## Daily Activities

### Morning Routine (15 minutes)
- [ ] Check CompAI dashboard for overdue tasks
- [ ] Review new security alerts or incidents
- [ ] Check policy acknowledgment status
- [ ] Review upcoming deadlines (next 7 days)

### Task Management

**Your Tasks Dashboard**: `/{org-id}/tasks/my-tasks`

**Task Priorities:**
1. **Red (Overdue)**: Complete immediately, escalate if blocked
2. **Yellow (Due in 3 days)**: Begin work, gather evidence
3. **Green (Due >7 days)**: Review requirements, plan approach

**Completing Tasks:**
1. Review task description and evidence requirements
2. Perform task activities
3. Collect evidence (documents, logs, screenshots)
4. Upload evidence to task
5. Add completion notes
6. Mark task complete
7. Review and submit for approval

---

## Weekly Activities

### Monday: Planning
- Review week's task schedule
- Confirm with task owners on status
- Identify any blockers or resource needs
- Schedule meetings if needed

### Wednesday: Mid-Week Check
- Follow up on in-progress tasks
- Review evidence quality
- Send reminders for tasks due Friday
- Update task completion estimates

### Friday: Weekly Review
- Complete weekly compliance report
- Update task completion metrics
- Flag any missed deadlines
- Plan next week's priorities

---

## Monthly Activities

### Week 1: Monthly Tasks
Complete monthly recurring tasks:
- Monthly ePHI Access Log Review (IT Security)
- Monthly ePHI Backup Testing (IT Operations)

### Week 2: Quarterly Check (if applicable)
If quarter-end month:
- BAA Inventory Review
- Access Review and Termination Compliance
- Device Inventory and Compliance Check
- Other quarterly tasks

### Week 3: Compliance Reporting
- Generate monthly compliance report
- Review task completion metrics
- Identify trends or recurring issues
- Present to HIPAA Security Officer

### Week 4: Planning and Process Improvement
- Review next month's task schedule
- Update procedures if needed
- Provide feedback on task templates
- Plan for upcoming audits or assessments

---

## Quarterly Activities

### All Quarterly Tasks (Week 1-2)
- BAA Inventory Review and Renewal Tracking
- Access Review and Termination Checklist Compliance
- Facility Access Review and Physical Security Audit
- Device Inventory and ePHI System Compliance Check
- ePHI Integrity Verification and Validation
- ePHI Access Recertification and RBAC Review
- ePHI Encryption Compliance Verification

### Semi-Annual (Q2 and Q4)
- HIPAA Policy Review and Update

### Quarterly Reporting (Week 3)
- Comprehensive quarterly compliance report
- Present to executive leadership
- Risk register review and updates
- Budget planning for remediation

---

## Annual Activities

### Q1: Planning
- Annual risk assessment planning
- Training schedule for the year
- Budget review and planning
- Policy review schedule

### Q2: Risk Assessment
- Conduct annual HIPAA security risk assessment
- Update risk register
- Develop mitigation plans
- Present findings to leadership

### Q3: DR/BC Testing
- Annual disaster recovery test
- Contingency plan testing
- Tabletop exercises
- Update DR/BC plans

### Q4: Training and Review
- Annual HIPAA training for 100% of workforce
- Annual addressable specification review
- Annual policy review
- Framework evaluation

---

## Evidence Collection

### Required Evidence by Task

**Monthly Tasks:**
- Access logs (SIEM exports, CSV reports)
- Backup logs (success/failure reports)
- Restoration test results

**Quarterly Tasks:**
- BAA inventory spreadsheet
- Manager attestation forms
- Badge access reports
- Device compliance reports
- Encryption verification scans

**Annual Tasks:**
- Training completion certificates
- Risk assessment report
- DR test results
- Policy review documentation

### Evidence Upload Process
1. Name files consistently: `YYYY-MM-TaskName-Evidence.ext`
2. Upload to task in CompAI
3. Add description of what evidence demonstrates
4. Include date evidence was collected
5. Link to related controls if applicable

---

## Reporting

### Daily Dashboard
- Overdue tasks count
- Tasks due today
- Recent incident alerts
- Policy acknowledgment status

### Weekly Report (to HIPAA Security Officer)
- Tasks completed this week
- Tasks in progress
- Blocked or delayed tasks
- Issues or risks identified

### Monthly Report (to Leadership)
- Task completion rate (target: 100%)
- Compliance metrics (encryption, training, BAAs)
- Incidents or breaches
- Resource needs

### Quarterly Report (to Executive/Board)
- Overall compliance status
- Risk assessment updates
- Audit readiness score
- Budget and resources

---

## Common Scenarios

### Scenario: Task is Blocked

**Example**: "Cannot complete BAA review - vendor not responding"

**Actions:**
1. Document the blocker in task notes
2. Escalate to procurement or legal
3. Set follow-up reminder (3 business days)
4. If unresolved after 7 days, escalate to HIPAA Security Officer
5. Update task due date if approved

### Scenario: Evidence is Missing

**Example**: "Need backup logs but can't access backup system"

**Actions:**
1. Contact system owner or IT team
2. Request access or ask them to export logs
3. Document request date in task
4. Follow up every 2 days
5. Escalate if not resolved within 1 week

### Scenario: Security Incident Reported

**Example**: "Workforce member reports suspicious email"

**Actions:**
1. Immediately notify HIPAA Security Officer and IT Security
2. Do NOT delay - report within 1 hour for critical incidents
3. Document incident details (who, what, when, where)
4. Preserve evidence (don't delete emails, logs)
5. Follow incident response policy
6. Do NOT notify individuals or media without approval

### Scenario: Control Owner Not Responding

**Example**: "HR hasn't provided termination checklists for access review"

**Actions:**
1. Send reminder via email and CompAI notification
2. CC their manager if no response in 2 business days
3. Escalate to HIPAA Security Officer if no response in 5 business days
4. Document all communication attempts
5. Flag as risk in compliance report

---

## Tips for Success

### Task Management
- Set up daily email digest of your tasks
- Use calendar integration to block time for task work
- Start quarterly tasks early (first week of quarter)
- Don't wait until due date to begin work

### Evidence Quality
- Higher quality > more quantity
- Screenshots should show dates and URLs
- Reports should include date ranges
- Name files descriptively
- Include metadata (who created, when, what system)

### Communication
- Overcommunicate rather than undercommunicate
- Document all decisions and rationale
- Use CompAI comments for collaboration
- Keep HIPAA Security Officer informed of issues

### Continuous Improvement
- Suggest improvements to task procedures
- Share automation ideas
- Document lessons learned
- Provide feedback on policies

---

## Tools and Resources

### CompAI Features
- Dashboard: `/{org-id}/dashboard`
- My Tasks: `/{org-id}/tasks/my-tasks`
- Evidence Library: `/{org-id}/evidence`
- Policies: `/{org-id}/policies`
- Controls: `/{org-id}/controls`

### External Tools
- SIEM/log management system
- Backup system
- MDM (Mobile Device Management)
- LMS (Learning Management System)
- BAA repository/contract system

### Documentation
- [HIPAA Quick Start Guide](HIPAA_QUICK_START_GUIDE.md)
- [Framework Administrator Guide](FRAMEWORK_ADMINISTRATOR_GUIDE.md)
- [Evidence Collection Guide](EVIDENCE_COLLECTION_GUIDE.md)
- [Audit Preparation Checklist](AUDIT_PREPARATION_CHECKLIST.md)
- [AI Evidence Collection Guide](../AI_EVIDENCE_COLLECTION_GUIDE.md)

### HHS/OCR Resources
- [HHS HIPAA Website](https://www.hhs.gov/hipaa/index.html)
- [Security Rule Guidance](https://www.hhs.gov/hipaa/for-professionals/security/guidance/index.html)
- [Breach Notification Rule](https://www.hhs.gov/hipaa/for-professionals/breach-notification/index.html)

---

*Last Updated: 2025-11-07*
*Version: 1.0*
*For questions, contact your HIPAA Security Officer*
