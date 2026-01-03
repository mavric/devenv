# Project Structure

How Mavric DevEnv organizes files and directories.

---

## Two Configuration Directories

Mavric DevEnv uses two main configuration directories:

```
your-project/
├── .claude/         # AI Skills & Commands
└── .devENV/         # Development Environment
```

These are **portable**—copy them to any project to get the full Mavric DevEnv experience.

---

## .claude/ Directory

Contains AI behavior configuration for Claude Code.

```
.claude/
├── commands/                    # Slash commands
│   ├── start-project.md         # /start-project command
│   └── discovery-only.md        # /discovery-only command
│
├── skills/                      # AI skill modules
│   ├── saas-project-orchestrator/
│   │   ├── SKILL.md             # Skill definition
│   │   └── references/          # Reference documents
│   ├── discovery-interviewer/
│   ├── schema-architect/
│   ├── backend-bootstrapper/
│   ├── auth-bootstrapper/
│   ├── test-generator/
│   ├── feature-builder/
│   └── product-brief-writer/
│
└── settings.local.json          # Claude Code settings
```

### Commands

Slash commands are simple Markdown files that define what happens when a user types `/command-name`.

**Example: `commands/start-project.md`**
```markdown
You want to start a new SaaS project. I'll invoke the
saas-project-orchestrator skill to guide you through:

0. Deep Discovery (90 min)
1. Test Scenarios (Gherkin)
2. Schema Design
3. Product Brief
4. Roadmap & Tasks
5. Implementation
```

### Skills

Each skill is a directory containing:

| File | Purpose |
|------|---------|
| `SKILL.md` | Main skill definition with YAML frontmatter |
| `references/` | Supporting documents, templates, examples |
| `README.md` | Human-readable overview (optional) |

**SKILL.md Structure:**
```markdown
---
name: skill-name
description: What this skill does. Triggers when...
---

# Skill Name

Detailed instructions for Claude on how to execute this skill.

## What I Create
...

## Process
...

## Examples
...
```

---

## .devENV/ Directory

Contains the development environment configuration.

```
.devENV/
├── setup/                       # Automation
│   ├── scripts/                 # Shell scripts
│   │   ├── setup-apso-betterauth.sh
│   │   ├── verify-setup.sh
│   │   ├── stop-servers.sh
│   │   ├── restart-servers.sh
│   │   └── view-logs.sh
│   └── templates/               # .apsorc templates
│       ├── minimal-saas-betterauth.json
│       └── complete-saas-betterauth.json
│
├── docs/                        # Reference documentation
│   ├── auth/                    # BetterAuth guides
│   ├── architecture/            # System architecture
│   └── reference/               # API patterns, tech stack
│
└── standards/                   # Development standards
    ├── foundations/             # Core methodologies
    └── rules/                   # Claude Code rules (.mdc files)
```

### Scripts

Shell scripts for automation:

| Script | Purpose |
|--------|---------|
| `setup-apso-betterauth.sh` | Complete project setup |
| `verify-setup.sh` | Health checks |
| `stop-servers.sh` | Stop dev servers |
| `restart-servers.sh` | Restart dev servers |
| `view-logs.sh` | View server logs |

### Templates

Pre-configured `.apsorc` files:

| Template | Use Case |
|----------|----------|
| `minimal-saas-betterauth.json` | MVPs, prototypes |
| `complete-saas-betterauth.json` | Full B2B SaaS |

### Rules

`.mdc` files that Claude Code automatically applies:

| Rule | Purpose |
|------|---------|
| `new-project-workflow.mdc` | Enforces discovery-first |
| `contribution-standards.mdc` | SOLID, TypeScript best practices |
| `code-structure.mdc` | File organization |
| `security-standards.mdc` | Security requirements |
| `testing-standards.mdc` | Testing requirements |

---

## Generated Project Structure

When you run the setup scripts, this structure is created:

```
my-project/
├── backend/                     # Apso NestJS backend
│   ├── src/
│   │   ├── autogen/             # ⚠️ NEVER MODIFY
│   │   │   ├── Entity/          # Generated modules
│   │   │   └── guards/          # Auth guards
│   │   ├── extensions/          # ✅ Your custom code
│   │   └── common/              # Shared utilities
│   ├── .apsorc                  # Schema definition
│   ├── .env                     # Environment variables
│   └── docker-compose.yml       # Local database
│
├── frontend/                    # Next.js frontend
│   ├── app/                     # App router pages
│   ├── components/              # React components
│   ├── lib/                     # Utilities, auth client
│   └── .env.local               # Environment variables
│
├── features/                    # Test scenarios & docs
│   ├── api/                     # API test features
│   ├── ui/                      # UI test features
│   ├── e2e/                     # E2E test features
│   └── docs/                    # Project documentation
│       ├── discovery/           # Discovery documents
│       └── schema/              # Schema documentation
│
├── .claude/                     # AI configuration
└── .devENV/                     # Dev environment
```

---

## The autogen/ vs extensions/ Split

This is **critical** to understand:

### autogen/ (Generated Code)

```
src/autogen/
├── User/
│   ├── User.entity.ts
│   ├── User.controller.ts
│   ├── User.service.ts
│   └── dtos/User.dto.ts
├── Organization/
└── guards/
```

!!! danger "Never Modify autogen/"
    Files in `autogen/` are **overwritten** every time you run `apso server scaffold`.

    Any changes you make will be lost!

### extensions/ (Custom Code)

```
src/extensions/
├── User/
│   ├── User.controller.ts    # Add custom endpoints
│   └── User.service.ts       # Add business logic
└── auth/
    └── auth.service.ts       # Custom auth logic
```

!!! success "Put Custom Code in extensions/"
    Files in `extensions/` are **safe**—never overwritten by Apso.

**How it works:**

1. Apso generates base functionality in `autogen/`
2. You extend/override in `extensions/`
3. NestJS module system wires them together

---

## Output Locations by Artifact

| Artifact Type | Location |
|---------------|----------|
| Discovery documents | `features/docs/discovery/` |
| Test scenarios | `features/api/`, `features/ui/`, `features/e2e/` |
| Schema documentation | `features/docs/schema/` |
| Product brief | `features/docs/product-requirements.md` |
| Backend code | `backend/src/` |
| Frontend code | `frontend/` |

---

## Portability

The `.claude/` and `.devENV/` directories are designed to be portable:

```bash
# Copy to new project
cp -r .claude /path/to/new-project/
cp -r .devENV /path/to/new-project/
```

The generated `backend/`, `frontend/`, and `features/` directories are **project-specific** and should not be copied between projects.

---

## Next Steps

- [Development Workflow](workflow.md) - The full phase-by-phase process
- [Skills Reference](../skills/index.md) - Detailed skill documentation
