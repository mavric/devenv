# Setup Overview

How to install and set up Mavric DevEnv.

---

## Install

Run this in your project directory:

```bash
curl -fsSL https://raw.githubusercontent.com/mavric/devenv/main/install.sh | bash
```

This adds:

- `.claude/` - AI skills and commands
- `.devenv/` - Development standards and references

Then restart Claude Code.

---

## What Gets Installed

```
your-project/
├── .claude/
│   ├── commands/           # Slash commands
│   │   ├── start-project.md
│   │   ├── discovery-only.md
│   │   ├── schema.md
│   │   ├── tests.md
│   │   └── verify.md
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
    │   ├── saas/           # SaaS patterns
    │   ├── apso/           # Apso schema guide
    │   └── foundations/    # Testing methodology
    ├── docs/               # Reference documentation
    └── setup/              # Setup scripts
```

---

## Prerequisites

| Requirement | Minimum | Purpose |
|-------------|---------|---------|
| **Claude Code** | Latest | AI interface |
| **Node.js** | 18.0.0 | Runtime |
| **PostgreSQL** | 13.0 | Database (for backend projects) |

### Install Prerequisites

=== "macOS"

    ```bash
    # Install Node.js and PostgreSQL
    brew install node postgresql
    brew services start postgresql
    ```

=== "Ubuntu/Debian"

    ```bash
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs postgresql postgresql-client
    sudo systemctl start postgresql
    ```

---

## Usage

Open Claude Code and say:

```
I want to build a SaaS for [your idea]
```

Or use slash commands:

| Command | Description |
|---------|-------------|
| `/start-project` | Full discovery workflow |
| `/discovery-only` | Discovery interview only |
| `/schema` | Design database schema |
| `/tests` | Generate test scenarios |
| `/verify` | Verify project consistency |

---

## Approaches

### Full Project Orchestration

For new SaaS projects:

```
/start-project
```

Runs through discovery, scenarios, schema, brief, and implementation.

### Quick Backend Setup

If you already have requirements:

```
Set up an Apso backend with BetterAuth authentication.
Project name: my-saas
```

Creates a running backend in ~5 minutes.

### Add Auth to Existing Project

If you have an Apso backend without auth:

```
Add BetterAuth authentication to my existing backend
```

---

## Updating

Re-run the install command:

```bash
curl -fsSL https://raw.githubusercontent.com/mavric/devenv/main/install.sh | bash
```

Your project files are preserved - only `.claude/` and `.devenv/` are updated.

---

## Troubleshooting

### Skills not loading

Make sure you're in a directory with `.claude/` folder:

```bash
ls -la .claude/
```

### Database connection issues

```bash
# Check PostgreSQL is running
pg_isready

# Start if needed (macOS)
brew services start postgresql
```

### Port conflicts

```
Port 3001 is already in use. Find what's using it and help me resolve it.
```

---

## Next Steps

- [Quick Start](../getting-started/quickstart.md) - Get running in 5 minutes
- [Templates](templates.md) - Available schema templates
- [Backend Bootstrapper](../skills/backend-bootstrapper.md) - Backend setup details
