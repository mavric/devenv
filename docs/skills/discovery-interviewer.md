# Discovery Interviewer

Conducts comprehensive 90-minute structured discovery interviews.

---

## Overview

| Attribute | Value |
|-----------|-------|
| **Name** | discovery-interviewer |
| **Type** | Planning skill |
| **Triggers** | "run discovery", "extract requirements", "start interview" |
| **Duration** | 90 minutes |
| **Output** | Discovery document (15-25 pages) |
| **Location** | `.claude/skills/discovery-interviewer/` |

---

## What It Does

The Discovery Interviewer extracts complete requirements through a structured conversation. It ensures nothing is missed by covering all 8 essential areas.

---

## The Interview Structure

### Section 1: Product Vision (10 min)

**Questions:**
- What problem does your product solve?
- Who experiences this problem?
- What's your business model?
- What makes your solution unique?
- Who are your competitors?

**Output:** Clear value proposition and positioning.

---

### Section 2: User Personas (10 min)

**For each persona (2-3):**
- Role/title
- Goals
- Frustrations
- Technical proficiency
- Usage frequency

**Output:** Detailed persona profiles.

---

### Section 3: Core Workflows (20 min)

**For each workflow:**
- Trigger (what starts it)
- Steps (numbered sequence)
- Validation rules
- Error handling
- Success criteria

**Output:** Complete workflow specifications.

!!! tip "Most Important Section"
    This is where most requirements live. Be thorough!

---

### Section 4: Data & Entities (15 min)

**Questions:**
- What are the main "things" in your system?
- What information do you track?
- How do things relate?
- What's unique about each thing?

**Output:** Entity list with relationships.

---

### Section 5: Edge Cases (10 min)

**Categories:**
- Scale (what happens with many users/records?)
- Concurrency (simultaneous actions?)
- Permissions (who can see/edit what?)
- Data lifecycle (delete, archive?)
- Integration failures

**Output:** Edge case documentation.

---

### Section 6: Success Criteria (10 min)

**For each feature:**
- How do you know it works?
- What metrics matter?
- Acceptance thresholds

**Output:** Measurable success criteria.

---

### Section 7: Constraints (10 min)

**Categories:**
- Technical (must use X, must support Y)
- Business (compliance, regulations)
- Integration (external systems)
- Performance (response times, scale)

**Output:** Documented constraints.

---

### Section 8: Review (5 min)

- Summarize key decisions
- Identify gaps
- Confirm understanding
- Rate confidence (1-10)

---

## PM Guidance Feature

When you don't know an answer, the skill provides **Product Management guidance**:

!!! example "PM Guidance Example"
    **Q:** What should the password requirements be?

    **PM Guidance:** If you're unsure, here's industry best practice:

    - Minimum 8 characters
    - At least one uppercase letter
    - At least one number
    - Consider passphrases (longer, no complexity)
    - Never store plaintext (use bcrypt/argon2)
    - Consider "Have I Been Pwned" integration

This feature helps you make informed decisions even without domain expertise.

---

## Output: Discovery Document

The skill generates a comprehensive document:

```
1. Executive Summary
   - Product overview
   - Key value propositions
   - Target market

2. User Personas
   - Detailed profiles
   - User journey maps

3. Functional Requirements
   - Workflow specifications
   - Validation rules
   - Error handling

4. Data Model
   - Entity definitions
   - Relationships
   - Key fields

5. Non-Functional Requirements
   - Performance
   - Security
   - Compliance

6. Edge Cases & Boundaries
   - Scale considerations
   - Error scenarios

7. Success Criteria
   - Feature acceptance
   - Metrics

8. Constraints
   - Technical
   - Business
```

**Length:** 15-25 pages depending on complexity.

---

## Invocation

### Via Orchestrator

Automatically called as Phase 0 of `/start-project`.

### Via Command

```
/discovery-only
```

### Via Natural Language

```
"Run discovery for my new feature"
"I need to extract requirements"
"Let's do a discovery session"
```

---

## Tips for Good Discovery

### Do

- Be specific in answers
- Think through edge cases
- Mention constraints early
- Describe real user scenarios

### Don't

- Give vague answers ("users create stuff")
- Skip error cases
- Assume obvious things
- Rush through sections

---

## Approval Gate

After the interview:

**Rate your confidence (1-10):**

| Score | Meaning | Action |
|-------|---------|--------|
| 8-10 | Complete | Proceed to next phase |
| 6-7 | Minor gaps | Clarify specific areas |
| Below 6 | Major gaps | Continue discovery |

---

## Related

- [Discovery-First Development](../concepts/discovery-first.md)
- [SaaS Project Orchestrator](saas-project-orchestrator.md)
- [Test Generator](test-generator.md) (next phase)
