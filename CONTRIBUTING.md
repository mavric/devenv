# Contributing to DevEnv

Guidelines for contributing to the Mavric DevEnv project.

---

## Table of Contents

1. [Getting Started](#getting-started)
2. [Project Structure](#project-structure)
3. [Code Style Guidelines](#code-style-guidelines)
4. [Creating New Skills](#creating-new-skills)
5. [Creating New Commands](#creating-new-commands)
6. [Testing Requirements](#testing-requirements)
7. [Pull Request Process](#pull-request-process)
8. [Issue Reporting](#issue-reporting)

---

## Getting Started

### Prerequisites

- Node.js 18.0.0 or higher
- Git
- Claude Code (latest version)

### Development Setup

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/devenv.git
   cd devenv
   ```

2. **Install to a test project**
   ```bash
   # Create a test project
   mkdir ../test-project && cd ../test-project

   # Run the local installer
   ../devenv/install.sh
   ```

3. **Open Claude Code** and verify the skills load correctly

### Repository Layout

```
devenv/
├── install/                  # Files copied to user projects
│   ├── .claude/              # Claude Code configuration
│   │   ├── commands/         # Slash commands
│   │   ├── skills/           # AI skills
│   │   └── templates/        # Prompt templates
│   └── .devenv/              # Development environment
│       ├── docs/             # Reference documentation
│       ├── setup/            # Setup scripts
│       └── standards/        # Development standards
├── docs/                     # MkDocs documentation site
├── install.sh                # Installation script
└── mkdocs.yml                # Documentation config
```

---

## Project Structure

### The `install/` Directory

Everything in `install/` gets copied to user projects. Maintain this structure:

#### `.claude/` - AI Behavior

| Directory | Purpose |
|-----------|---------|
| `commands/` | Slash commands users invoke directly |
| `skills/` | Specialized AI modules |
| `templates/` | Reusable prompt templates |

#### `.devenv/` - Development Environment

| Directory | Purpose |
|-----------|---------|
| `docs/` | Reference documentation |
| `setup/` | Setup scripts and templates |
| `standards/` | Coding standards and patterns |

### The `docs/` Directory

MkDocs documentation for the project website:

```
docs/
├── getting-started/          # Quickstart guides
├── concepts/                 # Core methodology
├── commands/                 # Command documentation
├── skills/                   # Skill documentation
├── standards/                # Standard references
├── reference/                # Technical reference
└── changelog/                # Version history
```

---

## Code Style Guidelines

### TypeScript

Use strict TypeScript configuration:

```json
{
  "compilerOptions": {
    "strict": true,
    "strictNullChecks": true,
    "noImplicitAny": true
  }
}
```

### Explicit Types

```typescript
// Good: Explicit types
interface User {
  id: string;
  email: string;
  name: string | null;
}

async function getUser(id: string): Promise<User | null> {
  return db.user.findUnique({ where: { id } });
}

// Bad: Implicit any
async function getUser(id) {
  return db.user.findUnique({ where: { id } });
}
```

### SOLID Principles

**Single Responsibility**: Each module has one purpose.

```typescript
// Good: Separate concerns
class UserService {
  createUser(data: CreateUserDto): Promise<User> { }
}

class EmailService {
  sendEmail(to: string, body: string): Promise<void> { }
}

// Bad: Mixed responsibilities
class UserManager {
  createUser(data) { }
  sendEmail(to, body) { }
  logActivity(action) { }
}
```

**Dependency Inversion**: Depend on abstractions.

```typescript
// Good: Inject dependencies
class CheckoutService {
  constructor(private paymentProcessor: PaymentProcessor) {}

  async checkout(order: Order) {
    await this.paymentProcessor.processPayment(order.total);
  }
}
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files (components) | PascalCase | `ProjectCard.tsx` |
| Files (utilities) | camelCase | `formatDate.ts` |
| Directories | kebab-case | `user-settings/` |
| Classes | PascalCase | `UserService` |
| Functions | camelCase | `getUserById` |
| Constants | SCREAMING_SNAKE | `MAX_RETRY_COUNT` |
| Interfaces | PascalCase | `User`, `CreateUserDto` |

### Commit Messages

Use conventional commits:

```
feat: add user profile page
fix: resolve null pointer in auth
refactor: simplify payment logic
test: add integration tests
docs: update API documentation
```

---

## Creating New Skills

Skills are specialized AI modules in `.claude/skills/`. Each skill is a "brick of narrow intelligence" focused on one domain.

### Skill Directory Structure

```
skill-name/
├── SKILL.md              # Main skill definition (required)
└── references/           # Reference documents (optional)
    ├── methodology.md
    └── templates/
```

### SKILL.md Format

Every skill must have a `SKILL.md` with YAML frontmatter:

```markdown
---
name: skill-name
description: Brief description of what the skill does. Include trigger phrases that should invoke it.
---

# Skill Name

I am [brief identity statement explaining the skill's purpose].

## What I Do

[List the main capabilities]

## How I Work

[Explain the process or methodology]

## When to Use Me

[List trigger scenarios]

## References

[List any reference files this skill uses]
```

### Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Kebab-case skill identifier |
| `description` | Yes | Includes trigger phrases for auto-loading |

### Skill Best Practices

1. **Single Focus**: Each skill handles one domain
2. **Clear Triggers**: Description includes phrases that invoke the skill
3. **Structured Output**: Define what the skill produces
4. **References**: Use `references/` for supporting documents
5. **Examples**: Include concrete examples in the skill

### Example Skill

```markdown
---
name: schema-architect
description: Designs database schemas with multi-tenancy, relationships, and best practices. Triggers when user needs to design data model, create entities, or plan database structure.
---

# Schema Architect

I design database schemas optimized for SaaS applications with multi-tenancy built in.

## What I Create

- Entity definitions with types and constraints
- Relationships (one-to-many, many-to-many)
- Multi-tenancy via Organization entity
- Complete `.apsorc` schema file

## Key Patterns

- Every entity has `organization_id` for tenant isolation
- Soft deletes with `deleted_at`
- Timestamps: `created_at`, `updated_at`

## When to Use Me

- "Design a schema for..."
- "Create a data model..."
- "What entities do I need for..."
```

---

## Creating New Commands

Commands are slash commands in `.claude/commands/` that users invoke directly.

### Command File Format

Create a markdown file named `command-name.md`:

```markdown
[Instructions for Claude to follow when this command is invoked]

## What This Command Does

[Description]

## Steps

1. [Step 1]
2. [Step 2]
...
```

### Command Best Practices

1. **Clear Name**: Use descriptive kebab-case names
2. **Single Purpose**: One command, one workflow
3. **Invoke Skills**: Commands often invoke skills
4. **Document Output**: Explain what gets created

### Updating Documentation

When adding a command:

1. Add the command file to `install/.claude/commands/`
2. Add documentation to `docs/commands/command-name.md`
3. Update `docs/commands/index.md` with the new command
4. Update `mkdocs.yml` navigation

---

## Testing Requirements

### Philosophy

> "Testing is not optional—it's how we validate delivery."

Every feature must be:
1. **Specified** in Gherkin scenarios
2. **Implemented** according to specs
3. **Verified** through automated tests
4. **Traceable** from task to test to code

### Three-Layer Testing

| Layer | Coverage | Purpose |
|-------|----------|---------|
| API Tests | 40% | Backend endpoints, business logic |
| UI Tests | 45% | Components, forms, interactions |
| E2E Tests | 15% | Complete user workflows |

### Minimum Coverage

| Feature Type | API | UI | E2E | Total |
|--------------|-----|-----|-----|-------|
| CRUD Entity | 8-10 | 5-7 | 2-3 | 15-20 |
| Authentication | 6-8 | 8-10 | 3-4 | 17-22 |
| Payment Flow | 5-6 | 6-8 | 4-5 | 15-19 |

### Required Tags

Every Gherkin scenario needs:

- **Layer tag**: `@api`, `@ui`, or `@e2e`
- **Priority tag**: `@smoke`, `@critical`, or `@regression`

```gherkin
@api @crud @smoke
Scenario: Create project with valid data
  Given I have a valid auth token
  When I POST to "/projects" with valid data
  Then the response status should be 201
```

### Quality Checklist

Before submitting:

- [ ] All tests pass locally
- [ ] No skipped tests without justification
- [ ] Coverage thresholds met (>80%)
- [ ] New features have tests
- [ ] Edge cases covered
- [ ] Tags applied correctly

---

## Pull Request Process

### Before Submitting

1. **Create a branch**
   ```bash
   git checkout -b feat/your-feature-name
   ```

2. **Make changes** following the code style guidelines

3. **Test your changes**
   - Install to a test project
   - Verify skills load and work correctly
   - Run any automated tests

4. **Update documentation** if needed
   - Add/update docs in `docs/`
   - Update `mkdocs.yml` navigation

5. **Commit with conventional messages**
   ```bash
   git commit -m "feat: add new skill for X"
   ```

### PR Requirements

- [ ] Clear description of changes
- [ ] Link to related issue (if applicable)
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] Follows code style guidelines

### Review Process

1. Submit PR against `main` branch
2. Maintainers review within 48 hours
3. Address feedback and update
4. Merge once approved

---

## Issue Reporting

### Bug Reports

Include:

1. **Description**: What happened vs. what you expected
2. **Steps to reproduce**: Detailed steps to trigger the bug
3. **Environment**: OS, Node version, Claude Code version
4. **Logs/Screenshots**: Any relevant error messages

### Feature Requests

Include:

1. **Problem**: What problem does this solve?
2. **Proposed solution**: How should it work?
3. **Alternatives**: Other approaches considered
4. **Use case**: Who benefits from this?

### Questions

For questions about using DevEnv:

1. Check existing documentation first
2. Search closed issues for similar questions
3. Open a discussion if still unclear

---

## Getting Help

- **Documentation**: [mavric.github.io/devenv](https://mavric.github.io/devenv)
- **Issues**: [github.com/mavric/devenv/issues](https://github.com/mavric/devenv/issues)
- **Discussions**: GitHub Discussions for questions

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
