# Mavric DevEnv

AI-powered skills for Claude Code that guide you through building production-ready SaaS applications.

## What This Is

A **Claude Code skills pack** that adds:

- **AI Skills** - Specialized modules that guide you through discovery, schema design, backend setup, and feature implementation
- **Slash Commands** - `/start-project`, `/discovery-only`, `/schema`, `/tests`, `/verify`
- **Reference Standards** - Tech stack patterns, testing methodology, and code standards

When you install this into a project and open Claude Code, you get an AI that knows how to build SaaS applications using proven methodologies (BDD, TDD, DDD) instead of just writing code.

## Install

Run this in your project directory:

```bash
curl -fsSL https://raw.githubusercontent.com/mavric/devenv/main/install.sh | bash
```

Then restart Claude Code.

## Usage

Open Claude Code and say:

```
I want to build a SaaS for [your idea]
```

The AI will guide you through:

1. **Discovery** - 90-minute structured interview to extract complete requirements
2. **Scenarios** - Gherkin specs that serve as requirements, tests, and documentation
3. **Schema** - Multi-tenant database design from your scenarios
4. **Implementation** - Backend and frontend code that satisfies the scenarios
5. **Validation** - Automated tests proving everything works

## What Gets Installed

```
your-project/
├── .claude/
│   ├── commands/           # Slash commands
│   │   ├── start-project.md
│   │   └── discovery-only.md
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
    │   ├── saas/           # SaaS patterns and templates
    │   ├── apso/           # Apso schema guide
    │   └── foundations/    # Testing and build methodology
    ├── docs/               # Reference documentation
    └── setup/              # Setup scripts and templates
```

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

## Available Commands

| Command | Description |
|---------|-------------|
| `/start-project` | Start new project with full discovery workflow |
| `/discovery-only` | Run discovery interview without implementation |
| `/schema` | Design or update database schema |
| `/tests` | Generate test scenarios |
| `/verify` | Verify project setup and consistency |

## Documentation

Full documentation: **[mavric.github.io/devenv](https://mavric.github.io/devenv)**

- [Installation Guide](https://mavric.github.io/devenv/getting-started/installation/)
- [First Project Tutorial](https://mavric.github.io/devenv/getting-started/first-project/)
- [Skills Reference](https://mavric.github.io/devenv/skills/discovery-interviewer/)
- [Standards & Patterns](https://mavric.github.io/devenv/standards/)

## Requirements

- **Claude Code** - Latest version
- **Node.js** - 18.0.0 or higher
- **PostgreSQL** - For backend projects

## Updating

Re-run the install command to update:

```bash
curl -fsSL https://raw.githubusercontent.com/mavric/devenv/main/install.sh | bash
```

## License

MIT
