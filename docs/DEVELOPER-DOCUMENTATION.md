# Developer Documentation: Mavric DevEnv

> A comprehensive guide to the Specification-Driven Development System for building production-ready SaaS applications.

---

## Table of Contents

1. [Overview](#overview)
2. [Project Structure](#project-structure)
3. [The .claude Folder](#the-claude-folder)
   - [Commands](#commands)
   - [Skills](#skills)
4. [The .devENV Folder](#the-devenv-folder)
   - [Setup Scripts](#setup-scripts)
   - [Templates](#templates)
   - [Documentation](#documentation)
   - [Standards & Rules](#standards--rules)
5. [How Skills Work](#how-skills-work)
6. [The Development Workflow](#the-development-workflow)
7. [Quick Reference](#quick-reference)

---

## Overview

This project is a **Specification-Driven Development System** that combines proven software engineering methodologies with AI assistance to build high-quality SaaS applications. It integrates:

- **Business Analysis (BA)** - Structured requirements extraction
- **Behavior-Driven Development (BDD)** - Executable Gherkin specifications
- **Test-Driven Development (TDD)** - Validation-first implementation
- **Domain-Driven Design (DDD)** - Business-aligned architecture

The system is organized into two main configuration directories:

| Directory | Purpose |
|-----------|---------|
| `.claude/` | AI behavior, skills, and slash commands |
| `.devENV/` | Development environment, setup scripts, standards, and reference materials |

---

## Project Structure

```
devenv/
├── .claude/                    # AI Skills & Commands
│   ├── commands/               # Slash commands (/start-project, /discovery-only)
│   ├── skills/                 # Specialized AI agents
│   │   ├── saas-project-orchestrator/
│   │   ├── discovery-interviewer/
│   │   ├── backend-bootstrapper/
│   │   ├── auth-bootstrapper/
│   │   ├── schema-architect/
│   │   ├── test-generator/
│   │   ├── feature-builder/
│   │   └── product-brief-writer/
│   └── settings.local.json     # Claude Code settings
│
├── .devENV/                    # Development Environment
│   ├── setup/                  # Automation scripts & templates
│   │   ├── scripts/            # Shell scripts for setup
│   │   └── templates/          # .apsorc templates
│   ├── docs/                   # Reference documentation
│   │   ├── auth/               # BetterAuth integration guides
│   │   ├── architecture/       # System architecture docs
│   │   └── reference/          # API patterns, tech stack
│   └── standards/              # Development standards
│       ├── foundations/        # Core methodologies
│       └── rules/              # Claude Code enforcement rules
│
├── foundations/                # Universal methodology docs
├── saas/                       # SaaS-specific patterns
├── apso/                       # Apso backend patterns
├── rules/                      # Claude Code rules (legacy location)
└── *.md                        # Top-level documentation
```

---

## The .claude Folder

The `.claude/` folder contains Claude Code's AI configuration - the "intelligence" that guides development.

### Commands

Commands are slash commands that users can invoke directly in Claude Code.

| Command | File | Purpose |
|---------|------|---------|
| `/start-project` | `commands/start-project.md` | Start a new SaaS project with full SDLC orchestration |
| `/discovery-only` | `commands/discovery-only.md` | Run 90-minute discovery interview without full orchestration |

#### /start-project

**When to use:** Starting a brand new SaaS product from scratch.

**What it does:**
1. Invokes the `saas-project-orchestrator` skill
2. Begins with 90-minute structured discovery
3. Generates test scenarios, schema, product brief
4. Creates phased roadmap
5. Guides through implementation

**File location:** `.claude/commands/start-project.md`

#### /discovery-only

**When to use:**
- Major new feature area for existing project
- Validating an idea before committing to build
- Re-discovering a stalled project

**What it does:**
- Runs the 90-minute discovery interview
- Produces complete discovery document (15-25 pages)
- Stops there - you choose next steps

**File location:** `.claude/commands/discovery-only.md`

---

### Skills

Skills are specialized AI modules that Claude automatically loads based on context. Each skill is a "brick" of narrow intelligence focused on one domain.

#### Skill Structure

Every skill follows this structure:

```
skill-name/
├── SKILL.md              # Main skill definition (required)
│   └── Contains:
│       - YAML frontmatter (name, description, triggers)
│       - Detailed instructions for Claude
│       - Examples and usage patterns
├── references/           # Reference documents (optional)
│   ├── methodology.md
│   └── templates/
└── README.md             # Human-readable overview (optional)
```

#### Available Skills

##### saas-project-orchestrator (Meta-Orchestrator)

**File:** `.claude/skills/saas-project-orchestrator/SKILL.md`

**Purpose:** Orchestrates the entire SDLC from idea to deployment.

**Triggers:** "start new SaaS", "build full-stack app", "create project"

**Phases it manages:**
- Phase 0: Deep Discovery (90 min)
- Phase 1: Test Scenarios (Gherkin)
- Phase 2: Schema Design
- Phase 3: Product Brief
- Phase 4: Roadmap & Tasks
- Phase 5-11: Implementation through Deployment

**Key philosophy:** Calls other skills in the correct sequence with approval gates between phases.

---

##### discovery-interviewer

**File:** `.claude/skills/discovery-interviewer/SKILL.md`

**Purpose:** Conducts comprehensive 90-minute structured discovery interviews.

**Triggers:** "start discovery", "extract requirements", "begin interview"

**Interview structure (90 minutes):**
1. Product Vision (10 min)
2. User Personas (10 min)
3. Core Workflows (20 min)
4. Data & Entities (15 min)
5. Edge Cases (10 min)
6. Success Criteria (10 min)
7. Constraints (10 min)
8. Review (5 min)

**Output:** Complete discovery document (15-25 pages) covering:
- Executive summary
- Detailed workflows with validation and error cases
- Complete data model
- Edge cases and boundaries
- Success criteria
- Technical constraints

**Special feature:** When you don't know an answer, the skill provides Product Management guidance with best practices and industry standards.

---

##### schema-architect

**File:** `.claude/skills/schema-architect/SKILL.md`

**Purpose:** Designs database schemas with multi-tenancy, relationships, and best practices.

**Triggers:** "design schema", "data model", "database design"

**What it creates:**
- Entity definitions with types, constraints, validation
- Relationships (one-to-many, many-to-many)
- Multi-tenancy via Organization entity
- Indexes for performance
- Complete `.apsorc` schema file

**Key patterns:**
- Every entity has `organization_id` for tenant isolation
- Standard SaaS entities: Organization, User, Subscription, AuditLog
- Soft deletes with `deleted_at`
- Timestamps: `created_at`, `updated_at`

---

##### backend-bootstrapper

**File:** `.claude/skills/backend-bootstrapper/SKILL.md`

**Purpose:** Sets up production-ready Apso backends with NestJS REST APIs.

**Triggers:** "setup backend", "create API", "bootstrap server"

**What it creates:**
1. Apso service configuration (`.apsorc`)
2. Generated NestJS backend with REST API
3. PostgreSQL database setup
4. CRUD endpoints for all entities
5. OpenAPI documentation
6. Docker Compose for local development

**Generated structure:**
```
backend/
├── src/
│   ├── autogen/           # ⚠️ NEVER MODIFY - Auto-generated
│   │   ├── Entity/        # Generated entity modules
│   │   └── guards/        # Auth & scope guards
│   ├── extensions/        # ✅ Your custom code
│   └── common/            # Shared utilities
├── .apsorc                # Schema definition
└── docker-compose.yml     # Local database
```

**Key principle:** Files in `autogen/` are overwritten on every `apso server scaffold` run. Put custom code in `extensions/`.

---

##### auth-bootstrapper

**File:** `.claude/skills/auth-bootstrapper/SKILL.md`

**Purpose:** Adds BetterAuth authentication to Apso backends with zero manual steps.

**Triggers:** "add authentication", "setup auth", "integrate BetterAuth"

**Four core functions:**
1. `setup-backend-with-auth` - Complete new backend with auth (5 min)
2. `add-auth-to-existing` - Add auth to existing backend (3 min)
3. `fix-auth-issues` - Auto-fix common problems (1 min)
4. `verify-auth-setup` - Comprehensive testing (2 min)

**BetterAuth entities created:**
- `User` (PascalCase) - Authentication user
- `account` (lowercase) - OAuth/credential providers
- `session` (lowercase) - Active user sessions
- `verification` (lowercase) - Email verification tokens

**Critical insight:** Passwords are stored in the `account` table (not `user`). The `account.providerId` must be `"credential"` for password login to work.

---

##### test-generator

**File:** `.claude/skills/test-generator/SKILL.md`

**Purpose:** Creates comprehensive BDD/Gherkin tests for features.

**Triggers:** "generate tests", "create scenarios", "add test coverage"

**Three test layers:**
1. **API Tests (40%)** - Backend endpoints and business logic
2. **UI Tests (45%)** - Frontend components and interactions
3. **E2E Tests (15%)** - Complete user journeys

**What it creates:**
- Gherkin `.feature` files
- TypeScript step definitions
- Cucumber configuration
- Traceability matrix (task → test mapping)

**Tag system:**
- Layer: `@api`, `@ui`, `@e2e`
- Priority: `@smoke`, `@critical`, `@regression`
- Type: `@positive`, `@negative`, `@edge-case`, `@security`

---

##### feature-builder

**File:** `.claude/skills/feature-builder/SKILL.md`

**Purpose:** Implements complete features full-stack (backend + frontend + tests).

**Triggers:** "implement feature", "build functionality", "add feature"

**What it does:**
- Creates backend endpoints and validation
- Builds frontend UI components
- Writes unit and integration tests
- Ensures code passes Gherkin scenarios

---

##### product-brief-writer

**File:** `.claude/skills/product-brief-writer/SKILL.md`

**Purpose:** Creates comprehensive Product Requirements Documents (PRDs).

**Triggers:** "write PRD", "document requirements", "product brief"

**What it synthesizes:**
- Discovery document (vision, personas)
- Gherkin scenarios (acceptance criteria)
- Schema design (data model)

---

## The .devENV Folder

The `.devENV/` folder contains the development environment configuration - setup scripts, templates, documentation, and standards.

### Setup Scripts

**Location:** `.devENV/setup/scripts/`

| Script | Purpose |
|--------|---------|
| `setup-apso-betterauth.sh` | Complete automated setup for Apso + BetterAuth |
| `verify-setup.sh` | Comprehensive health checks and validation |
| `test-auth.sh` | Test authentication flows |
| `stop-servers.sh` | Stop development servers |
| `restart-servers.sh` | Restart both servers |
| `view-logs.sh` | View server logs in real-time |
| `fresh-start.sh` | Complete project reset |

#### setup-apso-betterauth.sh

**The main setup script.** Fully automates Apso + BetterAuth setup.

**Usage:**
```bash
# Interactive mode (recommended)
./scripts/setup-apso-betterauth.sh

# Automated mode (CI/CD)
./scripts/setup-apso-betterauth.sh \
  --project-name my-saas \
  --backend-port 3001 \
  --frontend-port 3003
```

**Options:**
- `--project-name NAME` - Project name
- `--backend-port PORT` - Backend port (default: 3001)
- `--frontend-port PORT` - Frontend port (default: 3003)
- `--db-name NAME` - Database name
- `--db-password PASS` - Database password
- `--skip-install` - Skip npm install
- `--skip-db` - Skip database setup

**What it does:**
1. Checks prerequisites (Node.js, PostgreSQL)
2. Creates backend with Apso + BetterAuth
3. Creates frontend with Next.js + BetterAuth
4. Configures environment variables
5. Initializes database and migrations
6. Starts development servers
7. Verifies everything works

**Estimated time:** 5 minutes

---

### Templates

**Location:** `.devENV/setup/templates/`

| Template | Use Case |
|----------|----------|
| `minimal-saas-betterauth.json` | MVP/prototype, clean foundations |
| `complete-saas-betterauth.json` | Full B2B SaaS with billing, audit logs |

#### Minimal Template

**Best for:** MVPs, prototypes, learning Apso

**Includes:**
- BetterAuth core tables (user, session, account, verification)
- Organization entity (multi-tenancy)
- AccountUser junction table

#### Complete Template

**Best for:** B2B SaaS, enterprise apps, compliance requirements

**Includes everything in Minimal, plus:**
- Subscription management (Stripe-ready)
- Invoice tracking
- API key management
- Audit logging
- Team invitations
- Soft deletes

---

### Documentation

**Location:** `.devENV/docs/`

```
docs/
├── 5-MINUTE-QUICKSTART.md      # Fastest setup path
├── auth/                        # BetterAuth guides
│   ├── COMPLETE_AUTH_INTEGRATION_GUIDE.md
│   ├── NEXTJS_BETTER_AUTH_FRONTEND.md
│   └── TROUBLESHOOTING_AUTH.md
├── architecture/                # System architecture
│   ├── ai-orchestrated-setup-system.md
│   └── VISUAL_GUIDE.md
└── reference/                   # Technical reference
    ├── TECH-STACK-COMPLETE.md
    ├── API-PATTERNS-REFERENCE.md
    └── BETTERAUTH-APSO-REFERENCE.md
```

---

### Standards & Rules

**Location:** `.devENV/standards/`

Standards are split into two categories:

#### Foundations (Methodology)

**Location:** `.devENV/standards/foundations/`

| File | Content |
|------|---------|
| `product-development-foundation.md` | 12-week MVP framework |
| `testing-methodology.md` | BDD/TDD approach |
| `build-checklist.md` | Build task checklist |

#### Rules (Claude Code Enforcement)

**Location:** `.devENV/standards/rules/`

Rules are `.mdc` files that Claude Code automatically applies. They enforce coding standards and workflows.

| Rule | Purpose | Always Applied? |
|------|---------|-----------------|
| `new-project-workflow.mdc` | Enforces discovery-first for new projects | Yes (Critical) |
| `contribution-standards.mdc` | SOLID principles, TypeScript best practices | Yes |
| `code-structure.mdc` | File organization standards | Yes |
| `security-standards.mdc` | Security best practices | Yes |
| `testing-standards.mdc` | Testing requirements | Yes |
| `testing-guide.mdc` | Comprehensive testing patterns | Yes |
| `local-development.mdc` | Dev environment setup | Yes |
| `process-task-list.mdc` | Task tracking guidelines | Yes |

##### Key Rule: new-project-workflow.mdc

**This is the most critical rule.** It enforces that NEW projects MUST go through discovery before any implementation.

**Trigger phrases that invoke discovery:**
- "I want to build a new SaaS..."
- "Help me create a platform..."
- "Build me a [description] SaaS"

**What it prevents:**
- Jumping straight to implementation
- Creating files before discovery
- Writing code without requirements

---

## How Skills Work

### Skill Loading

Claude automatically loads skills when:
1. User's request matches the skill's trigger phrases (in the `description` field)
2. Context suggests the skill is relevant
3. Another skill calls it (orchestration)

### Skill Architecture

```
┌─────────────────────────────────────────────────────────────┐
│             saas-project-orchestrator (Meta-Skill)           │
│   Guides through entire SDLC, calling worker skills          │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ├─── Phase 0: discovery-interviewer
                        ├─── Phase 1: test-generator
                        ├─── Phase 2: schema-architect
                        ├─── Phase 3: product-brief-writer
                        ├─── Phase 4: roadmap-planner (future)
                        ├─── Phase 5: backend-bootstrapper
                        ├─── Phase 6: frontend-bootstrapper (future)
                        ├─── Phase 7: auth-bootstrapper
                        └─── Phase 8+: feature-builder
```

### Skill Output Locations

Skills output files to specific locations:

| Content Type | Output Location |
|--------------|-----------------|
| Discovery documents | `features/docs/discovery/` |
| Product requirements | `features/docs/product-requirements.md` |
| Test scenarios | `features/api/`, `features/ui/`, `features/e2e/` |
| Schema docs | `features/docs/schema/` |
| Backend code | `backend/` |
| Frontend code | `frontend/` |

---

## The Development Workflow

### For New Projects

```
Step 1: Start Discovery
────────────────────────
Run: /start-project
Or say: "I want to build a SaaS for [idea]"

↓

Step 2: Complete Discovery Interview (90 min)
─────────────────────────────────────────────
The discovery-interviewer guides you through:
- Product vision & business model
- User personas & journeys
- Core workflows (step-by-step)
- Data model & entities
- Edge cases & boundaries
- Success criteria
- Technical constraints

Output: 15-25 page discovery document

↓

Step 3: Approval Gate
─────────────────────
Review discovery document
Confidence level must be 8+/10

↓

Step 4: Test Scenarios
──────────────────────
test-generator creates Gherkin scenarios from workflows
Output: 40-60 scenarios (API, UI, E2E)

↓

Step 5: Schema Design
─────────────────────
schema-architect extracts data model
Output: .apsorc file

↓

Step 6: Product Brief
─────────────────────
product-brief-writer synthesizes all artifacts
Output: Product Requirements Document

↓

Step 7: Implementation (Weeks 2-12)
───────────────────────────────────
- backend-bootstrapper: Apso REST API
- auth-bootstrapper: BetterAuth integration
- feature-builder: Full-stack features
- test-generator: Test coverage
```

### For Existing Projects

```
Adding a Major Feature
──────────────────────
Run: /discovery-only
Complete focused discovery
Use feature-builder for implementation

Adding a Small Feature
──────────────────────
Skip discovery (too small)
Use feature-builder directly

Bug Fixes / Refactoring
───────────────────────
Skip discovery
Use appropriate debugging tools
```

---

## Quick Reference

### Slash Commands

| Command | When to Use |
|---------|-------------|
| `/start-project` | New SaaS project (full SDLC) |
| `/discovery-only` | Major feature, idea validation |

### Key Skills

| Skill | Trigger Phrases |
|-------|-----------------|
| `saas-project-orchestrator` | "build new SaaS", "start project" |
| `discovery-interviewer` | "run discovery", "extract requirements" |
| `schema-architect` | "design schema", "data model" |
| `backend-bootstrapper` | "setup backend", "create API" |
| `auth-bootstrapper` | "add auth", "setup authentication" |
| `test-generator` | "generate tests", "create scenarios" |
| `feature-builder` | "implement feature", "build feature" |

### Setup Scripts

```bash
# Complete setup
./scripts/setup-apso-betterauth.sh

# Verify setup
./scripts/verify-setup.sh

# Daily development
./scripts/restart-servers.sh
./scripts/view-logs.sh both
./scripts/stop-servers.sh
```

### Directory Philosophy

| Directory | Contains | Portable? |
|-----------|----------|-----------|
| `.claude/` | AI skills & commands | Yes - reuse across projects |
| `.devENV/` | Setup, standards, docs | Yes - reuse across projects |
| `features/` | Project-specific tests & docs | No - unique to project |
| `backend/`, `frontend/` | Application code | No - unique to project |

### Core Principle

> **Discovery → Scenarios → Schema → Brief → Roadmap → Implementation**
>
> In that exact order. No exceptions for new projects.

---

## Additional Resources

- **Methodology:** `METHODOLOGY.md` - Complete development methodology
- **Quick Start:** `QUICKSTART.md` - Walkthrough guide
- **Installation:** `INSTALLATION.md` - Setup instructions
- **Testing:** `TESTING-INTEGRATION.md` - BDD/Gherkin approach
- **Usage Patterns:** `USAGE.md` - Detailed usage examples

---

**Last Updated:** 2025-12-22
**Version:** 1.0
**Maintained By:** Mavric Engineering
