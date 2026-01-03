# SaaS Project Orchestrator

The meta-skill that coordinates the entire SDLC.

---

## Overview

| Attribute | Value |
|-----------|-------|
| **Name** | saas-project-orchestrator |
| **Type** | Meta-orchestrator |
| **Triggers** | "start new SaaS", "build full-stack app", "create project" |
| **Location** | `.claude/skills/saas-project-orchestrator/` |

---

## What It Does

The SaaS Project Orchestrator manages the complete Software Development Life Cycle from idea to deployment. It:

1. **Coordinates phases** - Runs skills in the correct sequence
2. **Manages gates** - Requires approval before proceeding
3. **Maintains context** - Passes artifacts between phases
4. **Ensures quality** - Validates outputs at each step

---

## The Phases

### Phase 0: Deep Discovery (90 min)

**Skill called:** `discovery-interviewer`

- Conducts structured 90-minute interview
- Extracts complete requirements
- Generates discovery document

**Gate:** User approves discovery (confidence 8+/10)

---

### Phase 1: Test Scenarios

**Skill called:** `test-generator`

- Analyzes discovery workflows
- Generates Gherkin scenarios
- Creates 40-60 test cases

**Gate:** User confirms scenarios capture requirements

---

### Phase 2: Schema Design

**Skill called:** `schema-architect`

- Extracts entities from discovery + scenarios
- Designs multi-tenant schema
- Creates `.apsorc` file

**Gate:** User validates schema supports workflows

---

### Phase 3: Product Brief

**Skill called:** `product-brief-writer`

- Synthesizes all artifacts
- Creates comprehensive PRD
- Documents acceptance criteria

**Gate:** User reviews PRD

---

### Phase 4: Roadmap

- Prioritizes features (MoSCoW)
- Groups into delivery phases
- Creates task breakdown
- Defines MVP scope

**Gate:** User confirms MVP definition

---

### Phase 5: Backend Bootstrap

**Skill called:** `backend-bootstrapper`

- Creates Apso project
- Generates NestJS backend
- Sets up database
- Runs migrations

---

### Phase 6: Frontend Bootstrap

- Creates Next.js project
- Configures routing
- Sets up styling (Tailwind + shadcn)

---

### Phase 7: Authentication

**Skill called:** `auth-bootstrapper`

- Integrates BetterAuth
- Configures providers
- Sets up sessions

---

### Phase 8+: Feature Implementation

**Skill called:** `feature-builder`

- Implements features one by one
- Validates against Gherkin scenarios
- Creates tests

---

## Flow Diagram

```
┌─────────────┐
│   START     │
└──────┬──────┘
       │
       ▼
┌─────────────┐     ┌─────────────┐
│  Discovery  │────▶│   Approve?  │
│  (90 min)   │     │  (8+/10)    │
└─────────────┘     └──────┬──────┘
                           │ Yes
       ┌───────────────────┘
       ▼
┌─────────────┐     ┌─────────────┐
│    Test     │────▶│   Approve?  │
│  Scenarios  │     │             │
└─────────────┘     └──────┬──────┘
                           │ Yes
       ┌───────────────────┘
       ▼
┌─────────────┐     ┌─────────────┐
│   Schema    │────▶│   Approve?  │
│   Design    │     │             │
└─────────────┘     └──────┬──────┘
                           │ Yes
       ┌───────────────────┘
       ▼
┌─────────────┐
│  Product    │
│   Brief     │
└──────┬──────┘
       │
       ▼
┌─────────────┐     ┌─────────────┐
│  Roadmap    │────▶│  Approve    │
│             │     │    MVP?     │
└─────────────┘     └──────┬──────┘
                           │ Yes
       ┌───────────────────┘
       ▼
┌─────────────┐
│   Backend   │
│  Bootstrap  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Frontend   │
│  Bootstrap  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│    Auth     │
│   Setup     │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Features   │◀──┐
│  (iterate)  │───┘
└──────┬──────┘
       │
       ▼
┌─────────────┐
│    DONE     │
└─────────────┘
```

---

## Invocation

### Via Command

```
/start-project
```

### Via Natural Language

```
"I want to build a new SaaS for [idea]"
"Help me create a [type] platform"
"Start a new project"
```

---

## Artifacts Created

| Phase | Artifact |
|-------|----------|
| Discovery | `features/docs/discovery/` |
| Scenarios | `features/api/`, `features/ui/`, `features/e2e/` |
| Schema | `backend/.apsorc` |
| Brief | `features/docs/product-requirements.md` |
| Backend | `backend/` directory |
| Frontend | `frontend/` directory |

---

## Key Behaviors

### Approval Gates

The orchestrator **stops and waits** for approval at each gate. It will not proceed without explicit confirmation.

### Context Passing

Information flows between phases:
- Discovery → informs scenario generation
- Scenarios → inform schema design
- All → synthesized into product brief

### Error Recovery

If a phase fails:
1. Orchestrator reports the error
2. Suggests fixes
3. Can retry the phase
4. Maintains previous phase outputs

---

## Configuration

The orchestrator behavior can be influenced by:

- **rules/** - `.mdc` files that enforce patterns
- **references/** - Documents in skill references folders
- **User preferences** - Stated during conversation

---

## Related Skills

| Skill | Called During |
|-------|---------------|
| [Discovery Interviewer](discovery-interviewer.md) | Phase 0 |
| [Test Generator](test-generator.md) | Phase 1 |
| [Schema Architect](schema-architect.md) | Phase 2 |
| [Product Brief Writer](product-brief-writer.md) | Phase 3 |
| [Backend Bootstrapper](backend-bootstrapper.md) | Phase 5 |
| [Auth Bootstrapper](auth-bootstrapper.md) | Phase 7 |
| [Feature Builder](feature-builder.md) | Phase 8+ |
