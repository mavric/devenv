# Product Brief Writer

Creates comprehensive Product Requirements Documents (PRDs).

---

## Overview

| Attribute | Value |
|-----------|-------|
| **Name** | product-brief-writer |
| **Type** | Planning skill |
| **Triggers** | "write PRD", "document requirements", "product brief" |
| **Output** | Product Requirements Document |
| **Location** | `.claude/skills/product-brief-writer/` |

---

## What It Does

The Product Brief Writer synthesizes all planning artifacts into a comprehensive PRD:

- Discovery document (vision, personas)
- Gherkin scenarios (acceptance criteria)
- Schema design (data model)

---

## Output Structure

```markdown
# Product Requirements Document

## 1. Executive Summary
- Product overview
- Key value propositions
- Target market
- Business model

## 2. Product Overview
- Vision statement
- Problem being solved
- Solution approach
- Competitive positioning

## 3. User Personas
- Primary personas
- User journey maps
- Key needs and frustrations

## 4. Feature Specifications

### Feature: [Name]
**Description:** [What it does]

**User Story:**
As a [persona], I want [action] so that [benefit].

**Acceptance Criteria:**
```gherkin
Given [context]
When [action]
Then [result]
```

**Data Requirements:**
- Entity: [name]
- Fields: [list]

**UI/UX Notes:**
- [Design considerations]

---

## 5. Technical Requirements
- Architecture overview
- Technology stack
- Integration points
- Security requirements

## 6. Non-Functional Requirements
- Performance (response times, throughput)
- Scalability (expected load)
- Availability (uptime requirements)
- Security (compliance, encryption)

## 7. Data Model
- Entity relationship diagram
- Key entities and fields
- Relationships

## 8. Dependencies & Constraints
- External dependencies
- Technical constraints
- Business rules
- Compliance requirements

## 9. Success Metrics
- KPIs to track
- Success thresholds
- Measurement approach

## 10. Appendices
- Glossary
- References
- Change log
```

---

## Synthesis Process

### Step 1: Gather Artifacts

Reads:
- `features/docs/discovery/` - Discovery document
- `features/*.feature` - Gherkin scenarios
- `backend/.apsorc` - Schema definition

### Step 2: Extract Key Information

From discovery:
- Vision and goals
- User personas
- Workflows

From scenarios:
- Acceptance criteria
- Edge cases
- Error handling

From schema:
- Entities and fields
- Relationships
- Constraints

### Step 3: Synthesize

Combines into coherent document:
- Features linked to scenarios
- Data requirements from schema
- Non-functional from constraints

### Step 4: Format

Produces professional PRD:
- Clear sections
- Consistent formatting
- Cross-references

---

## Feature Specification Format

Each feature gets this format:

```markdown
### Feature: User Registration

**Priority:** P0 (Must Have)

**Description:**
Allow new users to create accounts with email/password authentication.

**User Story:**
As a prospective user, I want to create an account so that I can access
the platform's features.

**Acceptance Criteria:**

| # | Criterion | Source |
|---|-----------|--------|
| 1 | User can register with email/password | Discovery 3.1 |
| 2 | System validates email format | Scenario @validation |
| 3 | Password must be 8+ characters | Scenario @validation |
| 4 | Duplicate email rejected | Scenario @negative |
| 5 | Welcome email sent on success | Discovery 3.1.5 |

**Data Requirements:**

| Entity | Fields Used |
|--------|-------------|
| User | email, name, password_hash |
| account | userId, providerId, password |

**UI/UX Notes:**
- Single-page registration form
- Real-time validation feedback
- Link to sign-in for existing users

**Error Handling:**

| Error | Message | Recovery |
|-------|---------|----------|
| Duplicate email | "Email already exists" | Link to sign-in |
| Weak password | "Password too weak" | Show requirements |
```

---

## Quality Checklist

Before finalizing, verify:

- [ ] All discovery workflows covered
- [ ] All Gherkin scenarios referenced
- [ ] All schema entities documented
- [ ] Acceptance criteria are testable
- [ ] Non-functional requirements specified
- [ ] Dependencies identified
- [ ] Success metrics defined

---

## Invocation

### Via Orchestrator

Automatically called as Phase 3 of `/start-project`.

### Via Natural Language

```
"Create a product brief from the discovery"
"Write a PRD for this feature"
"Document the requirements"
```

---

## Tips

### Do

- Include all scenarios as acceptance criteria
- Reference source documents
- Keep features atomic
- Define measurable success

### Don't

- Add features not in discovery
- Skip non-functional requirements
- Leave criteria vague
- Forget dependencies

---

## Related

- [Discovery Interviewer](discovery-interviewer.md) (input source)
- [Test Generator](test-generator.md) (scenarios)
- [Schema Architect](schema-architect.md) (data model)
