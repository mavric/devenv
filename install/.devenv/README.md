# Development Environment

This directory contains everything needed to set up and work with the Apso + BetterAuth development environment.

## Quick Start

**New Project Setup (5 minutes)**:
```bash
./setup/scripts/setup-apso-betterauth.sh
```

**Verify Setup**:
```bash
./setup/scripts/verify-setup.sh
```

## Directory Structure

### `setup/` - Project Setup & Automation
- **scripts/** - Automated setup scripts
  - `setup-apso-betterauth.sh` - Complete project setup
  - `verify-setup.sh` - Health checks
  - `test-auth.sh` - Test authentication
  - More utility scripts...

- **templates/** - Project templates
  - `minimal-saas-betterauth.json` - Minimal SaaS .apsorc
  - `complete-saas-betterauth.json` - Complete SaaS .apsorc

### `docs/` - Documentation
- **reference/** - API & tech stack reference
- **auth/** - BetterAuth integration guides
- **architecture/** - System architecture docs
- **5-MINUTE-QUICKSTART.md** - Fastest manual setup path

### `standards/` - Development Standards
- **foundations/** - Product development foundations
- **rules/** - Code standards & guidelines
- **saas/** - SaaS templates & implementation guides
- **apso/** - Apso-specific documentation

## Key Files

**Start Here**:
- `QUICKSTART.md` - Quick overview
- `SETUP-AUTOMATION.md` - Automation overview
- `docs/5-MINUTE-QUICKSTART.md` - Manual setup guide

**Setup**:
- `setup/scripts/README.md` - All available scripts
- `setup/templates/START-HERE.md` - Template selection

**Reference**:
- `docs/reference/README.md` - Complete reference materials
- `docs/auth/README.md` - Auth documentation hub

## Usage

### Automated Setup
```bash
# Interactive mode (recommended)
./setup/scripts/setup-apso-betterauth.sh

# Automated mode (CI/CD)
./setup/scripts/setup-apso-betterauth.sh \
  --project-name my-saas \
  --backend-port 3001 \
  --frontend-port 3003
```

### Daily Workflow
```bash
./setup/scripts/verify-setup.sh    # Health check
./setup/scripts/restart-servers.sh # Restart servers
./setup/scripts/view-logs.sh both  # View logs
```

### Template Selection
See `setup/templates/START-HERE.md` for help choosing the right .apsorc template.

## Organization Philosophy

- **`.devenv/`** = Reusable development setup, standards, and reference materials
- **`.claude/`** = Reusable AI agent skills and commands
- **`features/`** = Project-specific documentation, tests, and implementation details
- **Root** = Actual application code (backend/, frontend/, etc.)

### Separation of Concerns

**Reusable (portable to new projects):**
- `.devenv/` - Setup scripts, reference docs, standards
- `.claude/` - Skills, commands, patterns

**Project-Specific (unique to this project):**
- `features/docs/` - Discovery, PRD, roadmap, schema docs
- `features/api/`, `features/ui/`, `features/e2e/` - Test scenarios
- `backend/`, `frontend/` - Implementation code

This separation keeps development tooling organized and portable to new projects.
