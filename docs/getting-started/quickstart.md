# Quick Start

Get up and running with Mavric DevEnv in under 5 minutes.

---

## Step 1: Install Claude Code

If you don't have Claude Code installed:

```bash
npm install -g @anthropic-ai/claude-code
claude login
```

---

## Step 2: Install Mavric

Run this in your project directory:

```bash
# Create a new project (or use an existing one)
mkdir my-saas-project
cd my-saas-project

# Install Mavric
curl -fsSL https://raw.githubusercontent.com/mavric/devenv/main/install.sh | bash
```

This adds:

- `.claude/` - AI skills and commands
- `.devenv/` - Development standards and references

---

## Step 3: Start Building

Launch Claude Code:

```bash
claude
```

Then say:

```
I want to build a SaaS for [your idea]
```

Or use a slash command:

```
/start-project
```

---

## What Happens Next

The AI guides you through:

| Phase | What Happens | Output |
|-------|--------------|--------|
| **Discovery** | 90-min structured interview | Requirements document |
| **Scenarios** | Generate Gherkin tests | Executable specifications |
| **Schema** | Design multi-tenant data model | `.apsorc` schema file |
| **Brief** | Synthesize into PRD | Product requirements doc |
| **Build** | Generate backend + auth | Running Apso + BetterAuth |
| **Iterate** | Build features with tests | Complete application |

Each phase requires your approval before proceeding.

---

## Alternative: Quick Backend Setup

If you already have requirements and just need a backend:

```
Set up an Apso backend with BetterAuth authentication for my project
```

This skips discovery and sets up a running backend in ~5 minutes.

---

## Verify Installation

In Claude Code, ask:

```
What skills do you have available?
```

You should see skills like `saas-project-orchestrator`, `discovery-interviewer`, `backend-bootstrapper`, etc.

---

## Updating

Re-run the install command to update:

```bash
curl -fsSL https://raw.githubusercontent.com/mavric/devenv/main/install.sh | bash
```

---

## Next Steps

- [Your First Project](first-project.md) - Detailed walkthrough
- [Installation Guide](installation.md) - Prerequisites and troubleshooting
- [Skills Reference](../skills/index.md) - All available skills
- [Commands Reference](../commands/index.md) - All slash commands
