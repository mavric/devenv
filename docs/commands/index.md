# Commands Overview

Slash commands for quick access to common workflows.

---

## What Are Commands?

Commands are shortcuts you can type in Claude Code to invoke specific workflows. They start with `/` and trigger pre-defined behavior.

---

## Available Commands

### Project Lifecycle

| Command | Purpose | When to Use |
|---------|---------|-------------|
| [`/start-project`](start-project.md) | Full SDLC orchestration | New SaaS projects |
| [`/discovery-only`](discovery-only.md) | Discovery interview only | Major features, validation |
| [`/init`](init.md) | Initialize project structure | Quick project setup |

### Development Phases

| Command | Purpose | When to Use |
|---------|---------|-------------|
| [`/schema`](schema.md) | Design database schema | After discovery, before backend |
| [`/tests`](tests.md) | Generate Gherkin tests | After discovery, test-first |
| [`/plan`](plan.md) | Create technical plan | After schema, before implementation |

### Quality & Verification

| Command | Purpose | When to Use |
|---------|---------|-------------|
| [`/verify`](verify.md) | Check artifact consistency | Before major phases, for QA |

### Integration & Export

| Command | Purpose | When to Use |
|---------|---------|-------------|
| [`/ralph-export`](ralph-export.md) | Export to Ralph format | For autonomous development |

---

## Planned Capability Commands

We're expanding commands to provide quick access to each SaaS capability area:

| Command (Planned) | Capability | Purpose |
|-------------------|------------|---------|
| `/billing` | Payments | Set up Stripe integration |
| `/api-keys` | API Keys | Add API key management |
| `/audit` | Audit Logging | Enable compliance logging |
| `/notifications` | Notifications | Multi-channel notifications |
| `/storage` | File Storage | S3/file upload setup |

See [SaaS Capabilities](../concepts/saas-capabilities.md) for the full capability roadmap.

---

## How Commands Work

Commands are defined in `.claude/commands/` as Markdown files. When you type `/command-name`, Claude reads the corresponding file and follows its instructions.

**Example:** Typing `/start-project` loads `.claude/commands/start-project.md` and triggers the saas-project-orchestrator skill.

---

## Creating Custom Commands

You can create your own commands:

1. Create a new `.md` file in `.claude/commands/`
2. Name it `your-command.md`
3. Write instructions for Claude to follow
4. Use it with `/your-command`

**Example custom command:**

```markdown
<!-- .claude/commands/quick-test.md -->

Run the test suite for the current project:

1. Identify the test framework (Jest, Cucumber, etc.)
2. Run the appropriate test command
3. Report results
```

---

## Command vs Skill

| Aspect | Command | Skill |
|--------|---------|-------|
| Invocation | User types `/name` | Auto-loaded by context |
| Purpose | Quick access to workflows | Domain expertise |
| Complexity | Simple, single action | Complex, multi-step |
| Definition | Short Markdown file | Full SKILL.md with references |

Commands often **invoke** skills. For example, `/start-project` invokes the `saas-project-orchestrator` skill.
