---
title: Home
---

# Mavric DevEnv

<div class="hero" markdown>

<p class="tagline">**AI-powered skills for Claude Code**</p>

A skills pack that guides you through building production-ready SaaS applications using proven methodologies (BDD, TDD, DDD).

```bash
curl -fsSL https://raw.githubusercontent.com/mavric/devenv/main/install.sh | bash
```

[Get Started](getting-started/quickstart.md){ .md-button .md-button--primary }
[Why Mavric?](concepts/why-mavric.md){ .md-button }

</div>

---

## What This Is

A **Claude Code skills pack** that adds:

- **AI Skills** - Specialized modules for discovery, schema design, backend setup, and feature implementation
- **Slash Commands** - `/start-project`, `/discovery-only`, `/schema`, `/tests`, `/verify`, `/ralph-export`
- **Reference Standards** - Tech stack patterns, testing methodology, and code standards

When you install this and open Claude Code, you get an AI that knows how to build SaaS applications using proven methodologies instead of just writing code.

---

## Install

Run this in your project directory:

```bash
curl -fsSL https://raw.githubusercontent.com/mavric/devenv/main/install.sh | bash
```

Then restart Claude Code.

---

## Usage

Open Claude Code and say:

```
I want to build a SaaS for [your idea]
```

The AI guides you through:

1. **Discovery** - 90-minute structured interview to extract complete requirements
2. **Scenarios** - Gherkin specs that serve as requirements, tests, and documentation
3. **Schema** - Multi-tenant database design from your scenarios
4. **Implementation** - Backend and frontend code that satisfies the scenarios
5. **Validation** - Automated tests proving everything works

---

## What Gets Installed

```
your-project/
├── .claude/
│   ├── commands/           # Slash commands
│   │   ├── start-project.md
│   │   ├── discovery-only.md
│   │   └── ...
│   ├── skills/             # AI skills
│   │   ├── saas-project-orchestrator/
│   │   ├── discovery-interviewer/
│   │   ├── schema-architect/
│   │   ├── backend-bootstrapper/
│   │   ├── auth-bootstrapper/
│   │   ├── test-generator/
│   │   ├── feature-builder/
│   │   └── product-brief-writer/
│   └── templates/          # Prompt templates
└── .devenv/
    ├── standards/          # Development standards
    ├── docs/               # Reference documentation
    └── setup/              # Setup scripts and templates
```

---

## Available Skills

| Skill | What It Does |
|-------|--------------|
| `saas-project-orchestrator` | Guides entire project lifecycle |
| `discovery-interviewer` | Conducts structured requirements interview |
| `schema-architect` | Designs database schema from requirements |
| `backend-bootstrapper` | Sets up Apso + NestJS backend |
| `auth-bootstrapper` | Adds BetterAuth authentication |
| `test-generator` | Creates BDD/Gherkin test scenarios |
| `feature-builder` | Implements features full-stack |
| `product-brief-writer` | Generates PRD from discovery |

[View all skills →](skills/index.md)

---

## Available Commands

| Command | Description |
|---------|-------------|
| `/start-project` | Start new project with full discovery workflow |
| `/discovery-only` | Run discovery interview without implementation |
| `/schema` | Design or update database schema |
| `/tests` | Generate test scenarios |
| `/verify` | Verify project setup and consistency |
| `/ralph-export` | Export artifacts to Ralph format |

[View all commands →](commands/index.md)

---

## Requirements

- **Claude Code** - Latest version
- **Node.js** - 18.0.0 or higher
- **PostgreSQL** - For backend projects

---

## The Methodology

Mavric uses **scenario-driven development** - a methodology where Gherkin scenarios serve as requirements, acceptance tests, and living documentation.

```
Human Intent → Discovery → Gherkin Scenarios → Schema → Implementation → Validation
                              │
                              │ defines WHAT gets built
                              ▼
                    ┌─────────────────────────────────┐
                    │  specs/scenarios/               │
                    │  (Single Source of Truth)       │
                    └─────────────────────────────────┘
```

[Learn more about the methodology →](concepts/scenario-driven-development.md)

---

## Next Steps

<div class="feature-grid" markdown>

<div class="feature-card" markdown>
### :material-play-circle: Quick Start
Get up and running in 5 minutes.

[Quick Start →](getting-started/quickstart.md)
</div>

<div class="feature-card" markdown>
### :material-help-circle: Why Mavric?
Deep dive into the methodology vs boilerplates.

[Learn More →](concepts/why-mavric.md)
</div>

<div class="feature-card" markdown>
### :material-compass: Discovery Process
Understand the 90-minute interview.

[Discovery →](concepts/discovery-first.md)
</div>

<div class="feature-card" markdown>
### :material-cog: Skills Reference
Explore all available AI skills.

[Skills →](skills/index.md)
</div>

</div>

---

<div style="text-align: center; margin-top: 2rem; color: var(--md-default-fg-color--light);" markdown>

Built by [Mavric](https://mavric.com)

</div>
