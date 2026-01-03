---
description: Initialize a new Mavric project with standard structure
---

# Project Initialization

You've invoked the `/init` command to scaffold a new Mavric project.

## What Happens Next

I'll create the standard Mavric project structure with all necessary directories and configuration files.

### Project Structure Created

```
[project-name]/
├── .claude/
│   └── constitution.md         # Project principles (customizable)
├── docs/
│   ├── discovery/              # Requirements documents
│   │   └── .gitkeep
│   ├── scenarios/              # Gherkin test scenarios
│   │   ├── api/
│   │   ├── ui/
│   │   └── e2e/
│   ├── plans/                  # Technical plans
│   │   └── .gitkeep
│   └── .gitkeep
├── backend/                    # Apso backend (created later)
│   └── .gitkeep
├── frontend/                   # Next.js frontend (created later)
│   └── .gitkeep
├── tests/                      # Test implementations
│   ├── step-definitions/
│   └── fixtures/
├── .gitignore
└── README.md
```

### Files Created

#### 1. Constitution (`constitution.md`)
Project principles that guide all development:
- Multi-tenancy requirements
- Testing standards
- Security requirements
- Code quality rules

#### 2. README
Project overview with:
- Quick start guide
- Development workflow
- Available commands

#### 3. Git Configuration
- Standard `.gitignore` for Node.js/TypeScript
- Directory structure with `.gitkeep` files

## Usage

**Initialize in current directory:**
```
/init
```

**Initialize with project name:**
```
/init my-saas-project
```

**Initialize with description:**
```
/init

Project: TaskFlow
Description: A project management SaaS for remote teams
```

## What Happens After Init

1. **Start Discovery** - Run `/start-project` or `/discovery-only`
2. **Design Schema** - Run `/schema` after discovery
3. **Generate Tests** - Run `/tests` after discovery
4. **Create Plan** - Run `/plan` to document architecture
5. **Bootstrap Backend** - Orchestrator handles this
6. **Bootstrap Frontend** - Orchestrator handles this

## Git Integration

After initialization, I'll:
1. Initialize git repository (if not already)
2. Create initial commit with project structure
3. Create `main` branch as default

## Ready?

**Provide your project name and optional description to initialize.**
