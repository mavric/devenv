# Claude Skills for SaaS Development

> Modular intelligence bricks for building production-ready SaaS applications

## What Are Skills?

Skills are **specialized AI modules** that Claude automatically loads when relevant. They're not slash commands (you don't invoke them manually) or subagents (separate AI instances). Skills are **narrow intelligence that Claude orchestrates dynamically** based on context.

Each skill is a "brick" of specialized knowledge. Claude is the "mortar" that connects them intelligently.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│             saas-project-orchestrator (Meta-Skill)           │
│   Guides through entire SDLC, calling worker skills          │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ├─── Phase 0: Discovery (90 min)
                        │    └→ discovery-interviewer ⭐ NEW
                        │         • Comprehensive interview
                        │         • Product management guidance
                        │         • Complete discovery doc
                        │
                        ├─── Phase 1: Test Scenarios
                        │    └→ test-generator
                        │         • Gherkin scenarios from workflows
                        │         • API, UI, E2E layers
                        │         • Acceptance criteria
                        │
                        ├─── Phase 2: Schema Design
                        │    └→ schema-architect
                        │         • Extract from discovery + scenarios
                        │         • Multi-tenant schema
                        │
                        ├─── Phase 3: Product Brief
                        │    └→ product-brief-writer
                        │         • Synthesize discovery + scenarios + schema
                        │
                        ├─── Phase 4: Roadmap & Tasks
                        │    ├→ roadmap-planner (future)
                        │    └→ task-decomposer (future)
                        │
                        ├─── Phase 5: Backend Setup
                        │    ├→ backend-bootstrapper
                        │    └→ environment-configurator (future)
                        │
                        ├─── Phase 6: Frontend Setup
                        │    ├→ frontend-bootstrapper (future)
                        │    └→ api-client-generator (future)
                        │
                        ├─── Phase 7: Authentication
                        │    ├→ auth-implementer (future)
                        │    └→ multi-tenancy-architect (future)
                        │
                        ├─── Phase 8: Feature Implementation
                        │    └→ feature-builder
                        │         • Build to pass scenarios
                        │
                        └─── Phase 9+: Testing & Deployment
                             └→ deployment-orchestrator (future)
```

## Current Skills (v1.0)

### Meta-Orchestrator

**`saas-project-orchestrator`**
- **Purpose:** End-to-end project creation orchestrator
- **Triggers:** "start new SaaS", "build full-stack app", "create project"
- **Calls:** All worker skills in proper sequence
- **Output:** Complete production-ready SaaS application

### Worker Skills

**`discovery-interviewer`** ⭐ NEW
- **Purpose:** Conducts comprehensive 90-minute discovery interviews
- **Triggers:** "start new SaaS", "begin discovery", "extract requirements"
- **Output:** Complete discovery document (15-25 pages)
- **Dependencies:** None (always first skill called)
- **Special:** Includes product management expert guidance for users who don't have answers

**`product-brief-writer`**
- **Purpose:** Creates comprehensive PRDs
- **Triggers:** "write PRD", "document requirements", "product brief"
- **Output:** `features/docs/product-requirements.md`
- **Dependencies:** discovery-interviewer (synthesizes discovery + scenarios + schema)

**`schema-architect`**
- **Purpose:** Designs database schemas with multi-tenancy
- **Triggers:** "design schema", "data model", "database design"
- **Output:** `.apsorc` schema file
- **Dependencies:** product-brief-writer (optional)

**`backend-bootstrapper`**
- **Purpose:** Sets up Apso backend with generated API
- **Triggers:** "setup backend", "create API", "bootstrap server"
- **Output:** Working REST API, database, OpenAPI docs
- **Dependencies:** schema-architect (required)

**`feature-builder`**
- **Purpose:** Implements complete features full-stack
- **Triggers:** "implement feature", "build functionality", "add feature"
- **Output:** Backend + Frontend + Tests for feature
- **Dependencies:** backend-bootstrapper, frontend-bootstrapper

**`test-generator`** ⭐ NEW
- **Purpose:** Creates comprehensive BDD/Gherkin tests
- **Triggers:** "generate tests", "create test scenarios", "add test coverage"
- **Output:** Gherkin feature files, step definitions, test config
- **Dependencies:** None (can be used standalone or with feature-builder)

## Future Skills (Roadmap)

Planned for v1.1-v2.0:

- `roadmap-planner` - Progressive delivery roadmap generation
- `task-decomposer` - Task list generation
- `frontend-bootstrapper` - Next.js setup with shadcn/ui
- `auth-implementer` - Better Auth implementation
- `deployment-orchestrator` - Production deployment
- `api-client-generator` - Type-safe API client generation
- `multi-tenancy-architect` - Multi-tenant patterns
- `code-standards-enforcer` - Automatic SOLID enforcement
- `security-auditor` - Security vulnerability scanning

## How Skills Work Together

### Example: New Project Creation

**User Says:** "I want to build a SaaS for project management"

**Claude's Internal Flow:**

1. **Recognizes Intent** → Loads `saas-project-orchestrator`

2. **Phase 0: Discovery (90 min)**
   - Calls `discovery-interviewer` → Comprehensive interview
   - Extracts: vision, personas, workflows, entities, edge cases, constraints
   - Result: Complete discovery document (15-25 pages)
   - User approval gate (confidence 8+/10)

3. **Phase 1: Test Scenarios**
   - Calls `test-generator` → Creates Gherkin scenarios from workflows
   - Result: 40-60 scenarios (API, UI, E2E)
   - Scenarios = acceptance criteria + tests
   - User approval gate (scenarios capture requirements?)

4. **Phase 2: Schema Design**
   - Calls `schema-architect` → Extracts from discovery + scenarios
   - Result: Multi-tenant .apsorc schema
   - User approval gate (schema supports workflows?)

5. **Phase 3: Product Brief**
   - Calls `product-brief-writer` → Synthesizes discovery + scenarios + schema
   - Result: PRD that references scenarios
   - User approval gate (final review before implementation)

6. **Phase 4: Roadmap & Tasks**
   - Calls `roadmap-planner` → Phases scenarios into delivery waves
   - Calls `task-decomposer` → Creates per-scenario tasks
   - Result: 6-8 phase roadmap, 800+ task checklist

7. **Phase 5: Backend**
   - Calls `backend-bootstrapper` → Sets up Apso with schema
   - Result: Working API at localhost:3001

8. **Phase 6: Frontend**
   - Calls `frontend-bootstrapper` → Creates Next.js app
   - Result: Working UI at localhost:3000

9. **Phase 7: Authentication**
   - Calls `auth-implementer` → Better Auth + multi-tenancy
   - Result: Login/signup flows, org isolation

10. **Phase 8: Features**
    - For each feature/scenario:
      - Calls `feature-builder` → Implements to pass scenarios
      - Result: Working feature validated by automated tests

11. **Phase 9+: Testing & Deployment**
    - Calls `deployment-orchestrator` → Deploys to production
    - Result: Production app with monitoring

### Example: Adding a Single Feature

**User Says:** "Add a commenting system to projects"

**Claude's Internal Flow:**

1. **Recognizes Context** → Existing project, feature request
2. **Loads** `feature-builder` directly (no orchestrator needed)
3. **Implements:**
   - Backend: Comment entity, endpoints, validation
   - Frontend: CommentList, CommentForm components
   - Tests: Unit + integration tests
4. **Result:** Working commenting feature

## Skill Structure

Each skill follows this structure:

```
skill-name/
├── SKILL.md              # Main skill definition (required)
│   ├── YAML frontmatter (name, description, triggers)
│   └── Instructions for Claude
│
├── references/           # Reference documents (optional)
│   ├── methodology.md
│   ├── templates.md
│   └── examples.md
│
└── scripts/              # Executable code (optional)
    └── helper-script.py
```

### SKILL.md Format

```markdown
---
name: skill-name
description: Brief description including trigger phrases
---

# Skill Name

I am [what this skill does]...

## What I Do

## How I Work

## When to Use Me

## Output Format

## Examples
```

**Key Elements:**

1. **`description`** - Critical! Tells Claude when to activate this skill
   - Include trigger phrases users might say
   - Be specific but not too narrow

2. **Instructions** - Clear, actionable steps for Claude to follow

3. **Examples** - Show expected inputs/outputs

4. **References** - Link to methodology documents

## Adding Reference Files

Skills can include reference documents from your existing markdown:

```bash
# Example: Add reference to schema-architect
mkdir .claude/skills/schema-architect/references/
cp saas/saas-base-template.md .claude/skills/schema-architect/references/
cp apso/apso-schema-guide.md .claude/skills/schema-architect/references/
```

Update SKILL.md:
```markdown
## References

When designing schemas, I reference:
- `references/saas-base-template.md` - Standard SaaS entities
- `references/apso-schema-guide.md` - Apso-specific patterns
```

Claude will read these files when the skill activates, gaining all that knowledge instantly.

## Benefits of This Architecture

### 1. Modular Intelligence
Each skill is a specialized "brick" of knowledge. Add, remove, or update skills independently.

### 2. Automatic Orchestration
Claude knows when to load skills and in what order. You don't manage this manually.

### 3. Context Retention
The orchestrator maintains state across all skill invocations. Decisions made early inform later phases.

### 4. Reusability
Skills work standalone or as part of orchestrated flows. Use `feature-builder` alone or as part of full project creation.

### 5. Shareability
Skills can be exported and shared. Your custom skills become bricks others can use.

### 6. Evolutionary
Start with basic skills, add more sophisticated ones over time. The architecture scales.

## Usage Patterns

### Pattern 1: Full Project Creation
```
User: "Build a SaaS for time tracking"
→ Orchestrator runs entire SDLC
→ Complete application delivered
```

### Pattern 2: Specific Task
```
User: "Design the database schema for a CRM"
→ schema-architect activates
→ Schema file delivered
```

### Pattern 3: Feature Addition
```
User: "Add export to CSV functionality"
→ feature-builder activates
→ Feature implemented full-stack
```

### Pattern 4: Maintenance
```
User: "Audit security of auth system"
→ security-auditor activates (future)
→ Security report delivered
```

## Best Practices

### For Skill Design

✅ **Single Responsibility** - One skill, one job
✅ **Clear Triggers** - Obvious when skill should activate
✅ **Documented Output** - User knows what to expect
✅ **Reference Files** - Include methodology documents
✅ **Examples** - Show inputs and outputs

### For Skill Usage

✅ **Let Claude Orchestrate** - Don't try to manually invoke skills
✅ **Provide Context** - More context = better skill selection
✅ **Iterate** - Skills improve based on usage feedback
✅ **Validate** - Review skill outputs, provide corrections

### For Skill Development

✅ **Test Standalone** - Each skill should work independently
✅ **Test Orchestrated** - Skills should work in flows
✅ **Version Control** - Track skill changes
✅ **Document Dependencies** - What other skills are needed?

## Installation

### Global Skills (All Projects)
```bash
# Skills available across all projects
~/.claude/skills/
├── saas-project-orchestrator/
├── product-brief-writer/
├── schema-architect/
└── ...
```

### Project-Specific Skills
```bash
# Skills for this project only
/path/to/project/.claude/skills/
├── custom-skill/
└── ...
```

Claude auto-discovers from both locations.

## Skill Marketplace (Future)

Vision: A marketplace where developers share skills

```bash
# Future commands
claude-skill install time-tracking-schema
claude-skill publish my-custom-skill
claude-skill search "database design"
```

For now, skills are copied manually into `.claude/skills/`.

## Upgrading from Instructions to Skills

Your current `.devenv/` structure maps to skills:

| Current File | Future Skill |
|--------------|--------------|
| `foundations/product-development-foundation.md` | `product-brief-writer` |
| `foundations/roadmap-generator-prompt.md` | `roadmap-planner` |
| `saas/saas-base-template.md` | `schema-architect` references |
| `saas/saas-implementation-guide.md` | `backend-bootstrapper` references |
| `rules/*.mdc` files | `code-standards-enforcer` |

## Contributing

To add a new skill:

1. Create skill directory: `.claude/skills/skill-name/`
2. Write SKILL.md with YAML frontmatter
3. Add reference files (optional)
4. Test the skill standalone
5. Test the skill in orchestrated flows
6. Document in this README

## Version History

- **v1.1** (Current) - Discovery-first approach
  - `discovery-interviewer` ⭐ NEW - Comprehensive 90-min interview with PM expertise
  - `test-generator` ⭐ NEW - Gherkin scenarios from workflows
  - Updated `saas-project-orchestrator` - Now calls discovery-interviewer as Phase 0
  - Updated flow: Discovery → Scenarios → Schema → Brief → Roadmap

- **v1.0** - Initial skills
  - `saas-project-orchestrator`
  - `product-brief-writer`
  - `schema-architect`
  - `backend-bootstrapper`
  - `feature-builder`

- **v1.2** (Planned) - Frontend skills
  - `frontend-bootstrapper`
  - `auth-implementer`
  - `api-client-generator`

- **v2.0** (Planned) - Complete SDLC
  - All 20 planned skills
  - Skill marketplace integration
  - Cross-project skill sharing

## Philosophy

> "AGI will be created brick by brick. We won't know when the wall is complete until suddenly, it is."
> — Inspired by Nick Bostrom's Superintelligence

Skills are the bricks. Claude is the mortar. Together, they build complete applications.

Each skill masters one narrow domain. The breakthrough is Claude's ability to orchestrate them intelligently based on context.

This isn't AGI - but it's the closest practical implementation we have today.

---

**Ready to build?**

Activate the orchestrator:
```
"I want to build a SaaS application for [your idea]"
```

Or use a specific skill:
```
"Design a database schema for [your domain]"
"Implement a [feature name] feature"
```

Claude will handle the rest.
