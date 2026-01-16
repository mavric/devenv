# The Development Workflow

Phase-by-phase guide to building with Mavric DevEnv.

---

## Overview

The complete workflow has 6 main phases:

```
Phase 0: Discovery (90 min)
    ↓
Phase 1: Test Scenarios (30 min)
    ↓
Phase 2: Schema Design (30 min)
    ↓
Phase 3: Product Brief (30 min)
    ↓
Phase 4: Roadmap (30 min)
    ↓
Phase 5+: Implementation (weeks)
```

Each phase has an **approval gate**—you must approve before proceeding.

---

## Phase 0: Discovery

**Duration:** 90 minutes
**Skill:** `discovery-interviewer`
**Output:** Discovery document (15-25 pages)

### What Happens

1. Structured interview covering 8 areas
2. Claude asks probing questions
3. You provide answers (or get PM guidance)
4. Claude generates comprehensive document

### Approval Gate

!!! warning "Gate: Discovery Approval"
    Rate your confidence from 1-10:

    - **8-10**: Proceed to test scenarios
    - **6-7**: Minor clarifications needed
    - **Below 6**: Continue discovery

### Artifacts Created

- `features/docs/discovery/discovery-document.md`
- Persona profiles
- Workflow specifications
- Data model overview

---

## Phase 1: Test Scenarios

**Duration:** 30 minutes
**Skill:** `test-generator`
**Output:** 40-60 Gherkin scenarios

### What Happens

1. Claude analyzes discovery workflows
2. Generates Gherkin scenarios for each workflow
3. Covers happy paths, errors, edge cases
4. Applies consistent tags

### Example Output

```gherkin
@api @smoke
Feature: User Registration

  Scenario: Successful registration with email
    Given I am on the registration page
    When I enter valid registration details
    And I submit the form
    Then my account is created
    And I receive a verification email

  @negative
  Scenario: Registration with existing email
    Given a user exists with email "test@example.com"
    When I try to register with "test@example.com"
    Then I see error "Email already exists"
```

### Approval Gate

!!! warning "Gate: Scenario Review"
    Confirm scenarios capture all requirements:

    - All workflows covered?
    - Error cases included?
    - Edge cases addressed?

### Artifacts Created

- `features/api/*.feature`
- `features/ui/*.feature`
- `features/e2e/*.feature`

---

## Phase 2: Schema Design

**Duration:** 30 minutes
**Skill:** `schema-architect`
**Output:** `.apsorc` schema file

### What Happens

1. Claude extracts entities from discovery + scenarios
2. Designs relationships and fields
3. Adds multi-tenancy (organization_id)
4. Creates indexes for common queries
5. Generates Apso schema file

### Example Output

```json
{
  "service": "my-saas-api",
  "entities": {
    "Organization": {
      "fields": {
        "id": { "type": "uuid", "primary": true },
        "name": { "type": "string", "required": true },
        "slug": { "type": "string", "unique": true }
      }
    },
    "User": {
      "fields": {
        "id": { "type": "uuid", "primary": true },
        "email": { "type": "string", "unique": true },
        "organization_id": {
          "type": "uuid",
          "references": "Organization.id"
        }
      }
    }
  }
}
```

### Approval Gate

!!! warning "Gate: Schema Validation"
    Confirm schema supports all workflows:

    - All entities present?
    - Relationships correct?
    - Multi-tenancy configured?

### Artifacts Created

- `backend/.apsorc`
- `features/docs/schema/entity-relationship.md`

---

## Phase 3: Product Brief

**Duration:** 30 minutes
**Skill:** `product-brief-writer`
**Output:** Product Requirements Document

### What Happens

1. Claude synthesizes all previous artifacts
2. Creates comprehensive PRD
3. Includes acceptance criteria (from scenarios)
4. Documents technical requirements

### Document Structure

```
1. Executive Summary
2. Product Overview
3. User Personas
4. Feature Specifications
   - Feature 1
     - Description
     - Acceptance Criteria (from Gherkin)
     - Data Requirements (from Schema)
   - Feature 2...
5. Technical Requirements
6. Non-Functional Requirements
7. Dependencies & Constraints
```

### Artifacts Created

- `features/docs/product-requirements.md`

---

## Phase 4: Roadmap

**Duration:** 30 minutes
**Output:** Phased delivery plan

### What Happens

1. Features prioritized (must-have, should-have, nice-to-have)
2. Grouped into delivery phases
3. MVP scope defined
4. Task breakdown created

### Example Roadmap

```
Phase 1: Foundation (Week 1-2)
├── Backend setup with Apso
├── Authentication with BetterAuth
├── User management
└── Organization management

Phase 2: Core Features (Week 3-6)
├── Project CRUD
├── Task management
├── Basic permissions
└── API documentation

Phase 3: Enhancement (Week 7-9)
├── Comments system
├── Activity feed
├── Search functionality
└── Email notifications

Phase 4: Polish (Week 10-12)
├── Performance optimization
├── Error handling
├── Edge case coverage
└── Production deployment
```

### Approval Gate

!!! warning "Gate: MVP Definition"
    Confirm MVP scope is correct:

    - Core value delivered?
    - Scope appropriate?
    - Timeline realistic?

---

## Phase 5+: Implementation

**Duration:** Variable (weeks to months)
**See:** [Implementation Phases](implementation-phases.md) for detailed guidance

### The Implementation Approach

!!! tip "Screens First, Auth Last"
    Build all UI screens with mock data first, wire up the backend, add billing, then seal with authentication.

### Implementation Phases

| Phase | Focus | Auth Required |
|-------|-------|---------------|
| Foundation | Layout, nav, routes | No |
| Screens | All UI with mock data | No |
| Backend & API | Schema + real data | No |
| Billing | Stripe integration | No |
| Auth | BetterAuth | Yes |
| Polish | QA, performance | Yes |

This approach enables:

- **Faster UI iteration** without auth overhead
- **Parallel frontend/backend development**
- **Earlier stakeholder feedback** on UX
- **Auth as a "seal"** rather than a blocker

### Artifacts Created

- `frontend/` - Complete Next.js application
- `backend/` - Apso RC schema and configuration
- API integrations
- Authentication flows
- Billing integration

---

## Timeline Summary

| Phase | Duration | Cumulative |
|-------|----------|------------|
| Discovery | 90 min | 1.5 hours |
| Test Scenarios | 30 min | 2 hours |
| Schema Design | 30 min | 2.5 hours |
| Product Brief | 30 min | 3 hours |
| Roadmap | 30 min | 3.5 hours |
| Backend Setup | 30 min | 4 hours |
| Feature Development | 2-8 weeks | Varies |

**Total planning time:** ~4 hours
**Total to MVP:** 4-12 weeks (depending on complexity)

---

## Workflow Variations

### For New Projects

Use the full workflow:
```
/start-project
```

### For Major Features

Use focused discovery:
```
/discovery-only
```
Then manually proceed through phases.

### For Small Features

Skip discovery, use feature-builder directly:
```
"Add comments feature to tasks"
```

### For Bug Fixes

Skip all planning:
```
"Fix the login error when..."
```

---

## Next Steps

- [Commands Reference](../commands/index.md) - Available slash commands
- [Skills Reference](../skills/index.md) - Detailed skill documentation
