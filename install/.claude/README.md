# Claude Code Configuration

This directory contains Claude Code agent configurations for intelligent development assistance.

## Directory Structure

### `commands/` - Slash Commands
Custom slash commands for common workflows:
- `/start-project` - Start new SaaS project with discovery
- `/discovery-only` - Run discovery interview only

### `skills/` - Specialized Agents
AI agents with specific capabilities:

**Project Management**:
- `saas-project-orchestrator` - Complete project lifecycle
- `discovery-interviewer` - Product discovery sessions
- `product-brief-writer` - PRD documentation

**Backend Development**:
- `backend-bootstrapper` - Pure Apso backend setup
- `auth-bootstrapper` - BetterAuth authentication integration
- `schema-architect` - Database schema design

**Feature Development**:
- `feature-builder` - Full-stack feature implementation
- `test-generator` - BDD test generation

## Usage

### Invoke Skills
Skills are automatically available in Claude Code:

```
User: "Setup Apso backend"
→ backend-bootstrapper skill activates

User: "Add authentication to my backend"
→ auth-bootstrapper skill activates

User: "Run discovery for new feature"
→ discovery-interviewer skill activates

User: "Build the user dashboard feature"
→ feature-builder skill activates
```

### Use Commands
Type slash commands in Claude Code:

```
/start-project
→ Runs complete project orchestration

/discovery-only
→ Runs discovery interview without full setup
```

## Skill Capabilities

### backend-bootstrapper
**Pure Apso backend setup**

Creates production-ready NestJS backends with:
- Apso service configuration (.apsorc)
- REST API with OpenAPI docs
- PostgreSQL database setup
- Multi-tenancy support
- CRUD endpoints for all entities
- Development environment

### auth-bootstrapper
**BetterAuth authentication integration**

Functions:
1. `setup-backend-with-auth` - New backend with auth (5 min, 0 manual steps)
2. `add-auth-to-existing` - Add auth to existing backend (3 min)
3. `fix-auth-issues` - Auto-fix common problems (1 min)
4. `verify-auth-setup` - Comprehensive testing (2 min)

Includes:
- .apsorc auth entity templates
- Automated fix scripts
- Verification commands
- Complete troubleshooting

### Other Skills
See individual `SKILL.md` files in each skill directory for:
- Capabilities
- Usage examples
- Reference materials
- Troubleshooting

## Organization Philosophy

**`.claude/`** = AI behavior and intelligence (reusable skills)
**`.devenv/`** = Development environment and standards (reusable setup)
**`features/`** = Project-specific documentation and tests

### Where Skills Output Files

**Project-Specific Outputs → `features/`:**
- Discovery documents → `features/docs/discovery/`
- Product requirements → `features/docs/product-requirements.md`
- Roadmaps → `features/docs/roadmap/`
- Test scenarios → `features/api/`, `features/ui/`, `features/e2e/`
- Schema documentation → `features/docs/schema/`

**Reusable Reference Materials → `.devenv/`:**
- Setup guides → `.devenv/docs/`
- Architecture patterns → `.devenv/docs/architecture/`
- Auth integration docs → `.devenv/docs/auth/`
- Development standards → `.devenv/standards/`

Skills in `.claude/` can reference materials in `.devenv/` for comprehensive knowledge, and output project-specific content to `features/`.

## Adding New Skills

1. Create directory: `.claude/skills/my-skill/`
2. Add `SKILL.md` with agent instructions
3. Add `references/` directory with knowledge
4. Skill automatically available in Claude Code

See existing skills for examples.
