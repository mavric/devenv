---
description: Create a technical implementation plan
---

# Technical Planning

You've invoked the `/plan` command to create a technical implementation plan.

## What Happens Next

I'll analyze your project and create a comprehensive technical plan document.

### What This Command Does

1. **Reviews Existing Artifacts**
   - Discovery document (requirements)
   - Gherkin scenarios (acceptance criteria)
   - Schema definition (data model)
   - Existing codebase (if any)

2. **Creates Technical Plan**
   - Architecture decisions with rationale
   - Technology choices
   - Project structure
   - Phase breakdown
   - Risk assessment

3. **Generates Artifacts**
   - `docs/plans/technical-plan.md` - Complete technical plan
   - `docs/plans/architecture.md` - Architecture decisions
   - `docs/plans/roadmap.md` - Phased delivery plan

## Prerequisites

For best results, you should have completed:
- Discovery (`/start-project` or `/discovery-only`)
- Schema design (`/schema`)
- Test scenarios (`/tests`)

## Plan Sections

### 1. Technical Context
- Language/framework versions
- Dependencies and constraints
- Performance requirements
- Compliance needs

### 2. Architecture Decisions
- Backend: Apso (NestJS + PostgreSQL)
- Frontend: Next.js 14 (App Router)
- Auth: BetterAuth
- Deployment: Vercel + Railway

### 3. Project Structure
```
my-project/
├── backend/          # Apso backend
├── frontend/         # Next.js frontend
├── docs/
│   ├── discovery/    # Requirements
│   ├── scenarios/    # Gherkin tests
│   └── plans/        # Technical plans
└── tests/            # Test implementations
```

### 4. Phase Breakdown
- Phase 1: Foundation (Auth + Core CRUD)
- Phase 2: Features (Business logic)
- Phase 3: Polish (Edge cases, performance)
- Phase 4: Launch (Deployment, monitoring)

### 5. Risk Assessment
- Technical risks and mitigations
- Dependency risks
- Timeline risks

## Output

You'll get:
- `docs/plans/technical-plan.md` - Complete plan document
- `docs/plans/roadmap.md` - Phased delivery timeline
- Clear next steps for implementation

## Ready?

**Say "create plan" to analyze your project and generate the technical plan.**
