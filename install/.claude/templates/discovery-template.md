# Discovery Document: [PROJECT_NAME]

**Date:** [DATE]
**Interviewer:** Claude (Discovery Interviewer)
**Stakeholder:** [USER_NAME]
**Duration:** 90 minutes
**Confidence Level:** [X]/10

---

## Executive Summary

[One paragraph summarizing the product, target users, key workflows, and success criteria. This should be readable by anyone to understand what the product does.]

---

## 1. Product Vision

### 1.1 Elevator Pitch

> [One sentence: Who is it for, what problem does it solve, what's unique about it]

### 1.2 Value Proposition

**Primary Value:** [The #1 thing users will love]

**Differentiators:**
- [DIFFERENTIATOR_1]
- [DIFFERENTIATOR_2]
- [DIFFERENTIATOR_3]

### 1.3 Business Model

| Attribute | Value |
|-----------|-------|
| Revenue Model | [Subscription / Usage-based / Freemium] |
| Pricing Tiers | [TIER_1, TIER_2, TIER_3] |
| Target Market | [B2B / B2C / Both] |
| Market Size | [ESTIMATE] |

### 1.4 Success Metrics

| Metric | 6-Month Target | Measurement |
|--------|----------------|-------------|
| Active Users | [NUMBER] | Monthly active users |
| Revenue | $[AMOUNT] | MRR |
| Engagement | [METRIC] | [DEFINITION] |
| [CUSTOM] | [TARGET] | [DEFINITION] |

---

## 2. User Personas

### 2.1 [PERSONA_1_NAME]

**Role:** [Job title or role]

**Demographics:**
- Industry: [INDUSTRY]
- Company Size: [SIZE]
- Technical Level: [Low / Medium / High]

**Goals:**
1. [GOAL_1]
2. [GOAL_2]
3. [GOAL_3]

**Pain Points:**
1. [PAIN_1]
2. [PAIN_2]
3. [PAIN_3]

**User Journey:**
1. Discovery: [How they find the product]
2. First Use: [What they do first]
3. Daily Use: [Regular usage pattern]
4. Power Use: [Advanced features they use]

### 2.2 [PERSONA_2_NAME]

[Repeat structure above]

---

## 3. Core Workflows

### 3.1 Workflow: [WORKFLOW_NAME]

**Persona:** [Which persona uses this]
**Frequency:** [Daily / Weekly / Monthly / One-time]
**Priority:** [P1 / P2 / P3]

#### Trigger
[What causes this workflow to start]

#### Steps

| Step | User Action | System Response | Validation |
|------|-------------|-----------------|------------|
| 1 | [ACTION] | [RESPONSE] | [RULES] |
| 2 | [ACTION] | [RESPONSE] | [RULES] |
| 3 | [ACTION] | [RESPONSE] | [RULES] |

#### Success State
[What the user sees/experiences when workflow completes successfully]

#### Error Cases

| Error Condition | Error Message | Recovery |
|-----------------|---------------|----------|
| [CONDITION] | "[MESSAGE]" | [HOW_TO_RECOVER] |

#### Permissions
- **Can do:** [ROLES]
- **Cannot do:** [ROLES] - [What they see instead]

#### Edge Cases
- [EDGE_CASE_1]: [How to handle]
- [EDGE_CASE_2]: [How to handle]

---

### 3.2 Workflow: [WORKFLOW_NAME_2]

[Repeat structure above for each workflow]

---

## 4. Data Model

### 4.1 Entity: [ENTITY_NAME]

**Description:** [What this entity represents]

| Field | Type | Required | Constraints | Default |
|-------|------|----------|-------------|---------|
| id | UUID | Yes | Auto-generated | - |
| [FIELD_1] | [TYPE] | [Yes/No] | [CONSTRAINTS] | [DEFAULT] |
| [FIELD_2] | [TYPE] | [Yes/No] | [CONSTRAINTS] | [DEFAULT] |
| organizationId | UUID | Yes | FK → Organization | - |
| createdAt | Timestamp | Yes | Auto | Now |
| updatedAt | Timestamp | Yes | Auto | Now |

**Relationships:**
- Belongs to: [ENTITY] (many-to-one)
- Has many: [ENTITY] (one-to-many)
- Many-to-many: [ENTITY] (via [JUNCTION_TABLE])

**Indexes:**
- `[FIELD]` - [Reason for index]
- `organizationId, [FIELD]` - [Reason for composite index]

### 4.2 Entity: [ENTITY_NAME_2]

[Repeat structure above for each entity]

---

## 5. Edge Cases & Boundaries

### 5.1 Limits

| Limit | Value | Rationale | What happens at limit |
|-------|-------|-----------|----------------------|
| [LIMIT_1] | [VALUE] | [WHY] | [BEHAVIOR] |
| [LIMIT_2] | [VALUE] | [WHY] | [BEHAVIOR] |

### 5.2 Concurrent Operations

| Scenario | Approach | User Experience |
|----------|----------|-----------------|
| Same entity edited | [Last-write-wins / Optimistic lock / Merge] | [MESSAGE_SHOWN] |
| Bulk operations | [Queue / Batch / Stream] | [FEEDBACK_SHOWN] |

### 5.3 Deletion Behavior

| Entity | On Delete | Reason |
|--------|-----------|--------|
| [ENTITY_1] | [Soft delete / Hard delete / Cascade / Prevent] | [RATIONALE] |
| [ENTITY_2] | [Behavior] | [RATIONALE] |

### 5.4 Invalid State Prevention

| Invalid State | Prevention | Error Message |
|---------------|------------|---------------|
| [STATE_1] | [VALIDATION] | "[MESSAGE]" |
| [STATE_2] | [VALIDATION] | "[MESSAGE]" |

---

## 6. Success Criteria

### 6.1 Workflow: [WORKFLOW_NAME]

**Expected Outcomes:**
- [ ] [OUTCOME_1]
- [ ] [OUTCOME_2]
- [ ] [OUTCOME_3]

**User Experience Standards:**
- Form loads in < [X]s
- Action completes in < [X]s
- Clear feedback on [success/failure/progress]

**Acceptance Criteria:**
```gherkin
Scenario: [SUCCESS_CASE]
  Given [PRECONDITION]
  When [ACTION]
  Then [EXPECTED_RESULT]
```

### 6.2 Performance Targets

| Metric | Target | Measurement |
|--------|--------|-------------|
| API Response Time | < [X]ms (p95) | [ENDPOINT] |
| Page Load Time | < [X]s (p95) | [PAGE] |
| Concurrent Users | [NUMBER] | Load test |

### 6.3 Quality Standards

| Standard | Target |
|----------|--------|
| Test Coverage | [X]% |
| Accessibility | WCAG [LEVEL] |
| Security | OWASP Top 10 addressed |

---

## 7. Constraints & Integration

### 7.1 Technical Constraints

| Constraint | Details | Impact |
|------------|---------|--------|
| Tech Stack | [REQUIREMENT] | [IMPACT] |
| Hosting | [REQUIREMENT] | [IMPACT] |
| Compliance | [GDPR/HIPAA/etc] | [IMPACT] |

### 7.2 External Integrations

| Service | Purpose | Priority | Complexity |
|---------|---------|----------|------------|
| [SERVICE_1] | [PURPOSE] | [P1/P2/P3] | [Low/Med/High] |
| [SERVICE_2] | [PURPOSE] | [P1/P2/P3] | [Low/Med/High] |

### 7.3 Timeline

| Milestone | Target Date | Dependencies |
|-----------|-------------|--------------|
| MVP | [DATE] | [DEPS] |
| Beta | [DATE] | [DEPS] |
| Launch | [DATE] | [DEPS] |

---

## 8. Prioritization

### 8.1 MVP Scope (Phase 1)

**Must Have:**
1. [WORKFLOW/FEATURE]
2. [WORKFLOW/FEATURE]
3. [WORKFLOW/FEATURE]

**Rationale:** [Why these are essential for launch]

### 8.2 Post-MVP (Phase 2)

**Should Have:**
1. [WORKFLOW/FEATURE]
2. [WORKFLOW/FEATURE]

### 8.3 Future (Phase 3+)

**Nice to Have:**
1. [WORKFLOW/FEATURE]
2. [WORKFLOW/FEATURE]

---

## 9. Open Questions

| Question | Context | Priority | Owner |
|----------|---------|----------|-------|
| [QUESTION_1] | [CONTEXT] | [High/Med/Low] | [WHO_DECIDES] |
| [QUESTION_2] | [CONTEXT] | [High/Med/Low] | [WHO_DECIDES] |

---

## 10. Sign-off

**Discovery Completeness:**
- [X] All core workflows documented
- [X] All entities defined
- [X] All personas identified
- [X] Edge cases captured
- [X] Success criteria defined
- [X] Constraints documented
- [X] Prioritization agreed

**Confidence Level:** [X]/10

**Areas of Clarity:** [List clear areas]

**Areas Needing More Detail:** [List unclear areas]

---

**Approved by:** _________________

**Date:** _______

---

## Next Steps

1. [ ] Generate Gherkin scenarios from workflows
2. [ ] Extract schema from data model
3. [ ] Create technical plan
4. [ ] Bootstrap backend
5. [ ] Bootstrap frontend
