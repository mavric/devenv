# Skills Overview

Specialized AI modules for each development phase.

---

## What Are Skills?

Skills are domain-specific AI modules that Claude automatically loads based on context. Each skill provides deep expertise in a narrow area.

Think of skills as **specialized assistants**:
- The Schema Architect knows everything about database design
- The Test Generator knows BDD/Gherkin best practices
- The Backend Bootstrapper knows Apso inside and out

---

## Available Skills

### Orchestration

| Skill | Purpose |
|-------|---------|
| [SaaS Project Orchestrator](saas-project-orchestrator.md) | Coordinates entire SDLC |

### Planning & Discovery

| Skill | Purpose |
|-------|---------|
| [Discovery Interviewer](discovery-interviewer.md) | 90-minute requirements extraction |
| [Schema Architect](schema-architect.md) | Database and entity design |
| [Product Brief Writer](product-brief-writer.md) | PRD synthesis |

### Implementation

| Skill | Purpose |
|-------|---------|
| [Backend Bootstrapper](backend-bootstrapper.md) | Apso/NestJS setup |
| [Auth Bootstrapper](auth-bootstrapper.md) | BetterAuth integration |
| [Feature Builder](feature-builder.md) | Full-stack feature implementation |

### Quality

| Skill | Purpose |
|-------|---------|
| [Test Generator](test-generator.md) | BDD/Gherkin test creation |

---

## SaaS Capability Coverage

Skills are organized around SaaS capability areas. Each capability progresses from template support to full skill automation.

| Capability | Current Skill | Status |
|------------|---------------|--------|
| Authentication | Auth Bootstrapper | **Available** |
| Multi-Tenancy | Schema Architect | **Available** |
| Team Management | Schema Architect | **Available** |
| Billing & Payments | - | **Planned** |
| API Keys | - | **Planned** |
| Audit Logging | - | **Planned** |
| Notifications | - | **Roadmap** |
| File Storage | - | **Roadmap** |

See [SaaS Capabilities](../concepts/saas-capabilities.md) for the complete capability roadmap.

### Planned Skills

We're expanding skill coverage for each SaaS capability:

- `billing-bootstrapper` - Stripe integration, subscriptions, checkout
- `api-key-bootstrapper` - Key management, rate limiting
- `audit-bootstrapper` - Compliance logging, event tracking
- `notification-bootstrapper` - Multi-channel notifications
- `storage-bootstrapper` - S3/file upload integration

---

## Skill Architecture

```
┌─────────────────────────────────────────────────────────────┐
│             saas-project-orchestrator (Meta-Skill)           │
│   Coordinates entire SDLC, calls worker skills in sequence   │
└───────────────────────┬─────────────────────────────────────┘
                        │
        ┌───────────────┼───────────────┐
        │               │               │
        ▼               ▼               ▼
┌───────────────┐ ┌───────────────┐ ┌───────────────┐
│   Discovery   │ │    Schema     │ │    Backend    │
│  Interviewer  │ │   Architect   │ │  Bootstrapper │
└───────────────┘ └───────────────┘ └───────────────┘
```

The orchestrator calls specialized skills in the correct sequence with approval gates between phases.

---

## How Skills Are Loaded

Skills are loaded automatically when:

1. **Trigger phrases match** - Your request matches the skill's description
2. **Context suggests** - Related files or conversation history
3. **Another skill calls** - Orchestration chain

### Trigger Examples

| You Say | Skill Loaded |
|---------|--------------|
| "Design a database schema" | Schema Architect |
| "Generate tests for this feature" | Test Generator |
| "Setup the backend with auth" | Auth Bootstrapper |
| "I want to build a new SaaS" | SaaS Project Orchestrator |

---

## Skill File Structure

Each skill lives in `.claude/skills/skill-name/`:

```
skill-name/
├── SKILL.md              # Main definition (required)
├── references/           # Supporting documents
│   ├── methodology.md
│   ├── templates/
│   └── examples/
└── README.md             # Human overview (optional)
```

### SKILL.md Structure

```markdown
---
name: skill-name
description: What this skill does. Triggers when user needs to...
---

# Skill Name

I [what I do in first person].

## What I Create
...

## My Process
1. Step one
2. Step two
...

## Examples
...
```

---

## Skill Outputs

Each skill produces specific artifacts:

| Skill | Output Location |
|-------|-----------------|
| Discovery Interviewer | `features/docs/discovery/` |
| Test Generator | `features/api/`, `features/ui/`, `features/e2e/` |
| Schema Architect | `backend/.apsorc` |
| Product Brief Writer | `features/docs/product-requirements.md` |
| Backend Bootstrapper | `backend/` |
| Auth Bootstrapper | `backend/src/extensions/auth/` |
| Feature Builder | Various (backend + frontend) |

---

## Invoking Skills Manually

You can invoke skills directly by describing what you need:

```
"Use the schema-architect skill to design my database"

"I need the test-generator to create scenarios for user registration"

"Run the auth-bootstrapper to add authentication"
```

---

## Creating Custom Skills

You can create your own skills:

1. Create directory: `.claude/skills/your-skill/`
2. Create `SKILL.md` with frontmatter
3. Add references if needed
4. Test with trigger phrases

**Minimal SKILL.md:**

```markdown
---
name: your-skill
description: Does X when user needs Y.
---

# Your Skill

I help with [specific task].

## What I Do

1. First thing
2. Second thing

## Example

[Example of usage]
```

---

## Best Practices

### When Building Skills

- **Single responsibility** - One skill, one domain
- **Clear triggers** - Specific description phrases
- **Documented process** - Step-by-step instructions
- **Examples included** - Show expected inputs/outputs
- **References organized** - Supporting docs in `references/`

### When Using Skills

- **Let orchestrator decide** - For new projects, use `/start-project`
- **Be specific** - Clear requests get better skill matching
- **Check outputs** - Verify artifacts before proceeding
- **Approve gates** - Don't skip approval checkpoints
