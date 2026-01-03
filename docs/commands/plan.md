# /plan

Create a technical implementation plan.

---

## Usage

```
/plan
```

Or to create a plan from existing artifacts:

```
/plan

Create technical plan from my discovery and schema
```

---

## What It Does

The `/plan` command analyzes your project and creates a comprehensive technical plan:

1. **Reviews Existing Artifacts**
   - Discovery document (requirements)
   - Gherkin scenarios (acceptance criteria)
   - Schema definition (data model)
   - Existing codebase (if any)

2. **Creates Technical Plan**
   - Architecture decisions with rationale
   - Technology choices and justifications
   - Project structure decisions
   - Phase breakdown
   - Risk assessment

3. **Generates Artifacts**
   - `docs/plans/technical-plan.md` - Complete plan
   - `docs/plans/roadmap.md` - Phased delivery
   - `docs/plans/quickstart.md` - Critical path validation

---

## Plan Sections

### 1. Technical Context

- Language/framework versions
- Dependencies and constraints
- Performance requirements
- Compliance needs

### 2. Architecture Decisions

| Layer | Default Choice | Rationale |
|-------|---------------|-----------|
| Backend | NestJS (Apso) | Type-safe, modular |
| Database | PostgreSQL | ACID, proven scale |
| Frontend | Next.js 14 | App Router, SSR |
| Auth | BetterAuth | Self-hosted, flexible |

### 3. Project Structure

```
project/
├── backend/     # Apso backend
├── frontend/    # Next.js app
├── docs/        # All documentation
└── tests/       # Test implementations
```

### 4. Phase Breakdown

- Phase 1: Foundation (Auth, Org, Profile)
- Phase 2: Core Features (Business logic)
- Phase 3: Advanced Features (Integrations)
- Phase 4: Polish & Launch

### 5. Risk Assessment

- Technical risks and mitigations
- Dependency risks
- Timeline risks

---

## Prerequisites

For best results, complete:

- Discovery (`/start-project` or `/discovery-only`)
- Schema design (`/schema`)
- Test scenarios (`/tests`)

---

## Why Plan?

The technical plan:

- Documents architectural decisions before coding
- Provides rationale for technology choices
- Identifies risks early
- Creates clear milestones

---

## After Planning

Next steps:

1. **Review plan** - Approve architecture decisions
2. **Review quickstart** - Confirm critical paths
3. **Bootstrap backend** - Begin implementation
4. **Track progress** - Use roadmap milestones

---

## See Also

- [/verify](verify.md) - Check artifact consistency
- [Development Workflow](../concepts/workflow.md) - Phase guide
