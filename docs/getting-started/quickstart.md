# Quick Start

Get up and running with Mavric AI Toolchain in 5 minutes.

---

## Prerequisites

Before you begin, ensure you have:

| Requirement | Purpose |
|-------------|---------|
| **Claude Code** | AI-powered CLI that runs all toolchain commands |
| **Node.js** >= 18.0.0 | JavaScript runtime |
| **npm** >= 9.0.0 | Package manager |
| **PostgreSQL** >= 13.0 | Database |

!!! warning "Claude Code Required"
    Mavric AI Toolchain is designed to work **inside Claude Code**. All commands shown in this documentation are run within a Claude Code session, not in a standard terminal.

### Install Claude Code

If you don't have Claude Code installed:

```bash
npm install -g @anthropic-ai/claude-code
```

Then authenticate:

```bash
claude login
```

### Verify Prerequisites

```bash
# Check versions
node --version   # Should be v18.x.x or higher
npm --version    # Should be 9.x.x or higher
psql --version   # Should be 13.x or higher
```

---

## Step 1: Install Mavric

Run the one-line installer in your project directory:

```bash
# Create your project folder
mkdir my-saas-project
cd my-saas-project

# Install Mavric
curl -fsSL https://raw.githubusercontent.com/mavric/devenv/main/install.sh | bash
```

That's it! The installer adds:

- `.claude/` - AI skills and commands
- `.devenv/` - Development standards and references

!!! tip "Initialize Git"
    After installing, initialize your repo:
    ```bash
    git init
    git add .
    git commit -m "Initial commit: Mavric toolchain setup"
    ```

---

## Step 2: Start Claude Code

Launch Claude Code in your project directory:

```bash
claude
```

Claude Code will automatically detect the `.claude/` folder and load all skills and commands.

---

## Step 3: Choose Your Path

### Option A: Start a New SaaS Project

If you're building a **new SaaS product**, use the full orchestration. In Claude Code, run:

```
/start-project
```

This triggers the complete SDLC workflow:

1. **Discovery Interview** - 90-minute requirements gathering
2. **Test Scenarios** - Gherkin acceptance criteria
3. **Schema Design** - Multi-tenant data model
4. **Product Brief** - Complete PRD
5. **Implementation** - Backend, auth, and frontend

!!! tip "Best for"
    New SaaS products, greenfield projects, or when you want comprehensive requirements gathering.

---

### Option B: Bootstrap Backend Quickly

If you already have requirements and just need a backend, tell Claude Code:

```
Set up an Apso backend with BetterAuth authentication for my project
```

Claude Code will use the **backend-bootstrapper** skill to:

- Create the Apso NestJS backend
- Configure BetterAuth authentication
- Set up PostgreSQL database
- Generate REST API endpoints
- Start the development servers

**In about 5 minutes, you'll have a running backend.**

---

### Option C: Run Discovery Only

If you want to gather requirements without full implementation:

```
/discovery-only
```

This runs just the 90-minute discovery interview and outputs:

- `discovery-notes.md` - Complete interview transcript
- `discovery-summary.md` - Structured requirements summary

---

## Step 4: Verify Setup

After setup completes, verify everything works by asking Claude Code:

```
Verify my backend setup is working correctly
```

Or manually check:

```bash
curl http://localhost:3001/health          # Backend health
curl http://localhost:3001/api/docs        # OpenAPI docs
open http://localhost:3003                  # Frontend
```

---

## What's Next?

<div class="feature-grid" markdown>

<div class="feature-card" markdown>
### Learn the Workflow
Understand discovery-first development.

[Development Workflow →](../concepts/workflow.md)
</div>

<div class="feature-card" markdown>
### Explore Skills
See what each AI skill can do.

[Skills Reference →](../skills/index.md)
</div>

</div>

---

## Common Issues

??? question "Claude Code doesn't recognize commands"
    Make sure you're in a directory that contains the `.claude/` folder, or that the toolchain is properly installed.

    ```
    # In Claude Code, check what skills are available
    What skills do you have available?
    ```

??? question "PostgreSQL connection refused"
    Ensure PostgreSQL is running:

    ```bash
    # macOS
    brew services start postgresql

    # Linux
    sudo systemctl start postgresql
    ```

??? question "Port already in use"
    Ask Claude Code to help:

    ```
    Port 3001 is already in use. Can you help me find what's using it and restart the server on a different port?
    ```

??? question "Node version too old"
    ```bash
    # Using nvm
    nvm install 20
    nvm use 20

    # Or update directly (macOS)
    brew upgrade node
    ```
