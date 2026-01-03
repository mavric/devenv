---
title: Home
---

# Mavric AI Toolchain

<div class="hero" markdown>

<p class="tagline">**AI-Driven SaaS Builder for Claude Code**</p>

Stop generating boilerplate. Start building the right product.

[Get Started](getting-started/quickstart.md){ .md-button .md-button--primary }
[Why Mavric?](concepts/why-mavric.md){ .md-button }

</div>

---

## The Problem with Boilerplates

Most developers building SaaS products reach for a **boilerplate** or **generator**:

- [BuilderKit.ai](https://www.builderkit.ai) - Next.js templates with AI apps
- [SaaSBold](https://saasbold.com) - Full-stack SaaS starter kit
- [Divjoy](https://divjoy.com) - React codebase generator

**These give you code. But code isn't the problem.**

!!! danger "The Real Problem"
    **60% of software projects fail due to poor requirements, not poor code.**

    Boilerplates help you build faster. They don't help you build the *right thing*.

---

## A Different Approach

Mavric AI Toolchain is an **AI-driven SaaS builder** that works inside [Claude Code](https://claude.com/claude-code). Instead of generating boilerplate and hoping you figure out what to build, Mavric:

1. **Extracts requirements** through structured 90-minute discovery interviews
2. **Generates test scenarios** that define what success looks like
3. **Designs your schema** based on actual workflows, not assumptions
4. **Then builds the code** - with tests already written

```
┌─────────────────────────────────────────────────────────┐
│  Traditional Approach                                    │
│  ─────────────────────                                  │
│  Idea → Boilerplate → Code → "What did we miss?" → Fix  │
│                                          ↑              │
│                                   (expensive rework)     │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│  Mavric Approach                                        │
│  ───────────────                                        │
│  Idea → Discovery → Tests → Schema → Code → Deploy      │
│              ↑                                          │
│       (90 min investment, prevents weeks of rework)     │
└─────────────────────────────────────────────────────────┘
```

---

## How It Works

In Claude Code, run:

```
/start-project
```

Mavric orchestrates a complete workflow:

| Phase | What Happens | Output |
|-------|--------------|--------|
| **Discovery** | 90-min structured interview | Requirements document |
| **Scenarios** | AI generates Gherkin tests | Executable specifications |
| **Schema** | Multi-tenant data design | `.apsorc` schema file |
| **Brief** | Synthesize into PRD | Product requirements doc |
| **Build** | Generate backend + auth | Running Apso + BetterAuth |
| **Iterate** | Build features with tests | Complete application |

Each phase requires your approval before proceeding. No runaway AI.

---

## Why This Works

### Boilerplates Give You Structure

```
my-saas/
├── src/
├── components/
├── lib/
└── ... (you figure out the rest)
```

### Mavric Gives You a Complete System

```
my-saas/
├── docs/
│   ├── discovery-notes.md      # What you're building and why
│   ├── product-requirements.md # Complete PRD
│   └── scenarios/              # Gherkin acceptance criteria
├── backend/
│   ├── .apsorc                 # Schema designed for YOUR workflows
│   ├── src/autogen/            # Generated REST API
│   └── src/extensions/         # Your custom logic
└── frontend/
    └── ...                     # Connected to your backend
```

---

## The Core Philosophy

!!! quote "Discovery First"
    **"Incomplete or bad information at discovery leads to incomplete or bad implementation later."**

Traditional tools optimize for **speed to first commit**. Mavric optimizes for **speed to correct product**.

| Metric | Boilerplate | Mavric |
|--------|-------------|--------|
| Time to first code | 5 minutes | 2 hours |
| Requirements documented | No | Yes |
| Tests written before code | No | Yes |
| Multi-tenancy designed | Maybe | Always |
| Scope creep prevented | No | Yes |
| **Time to correct product** | Weeks-months | Days |

---

## Built on Claude Code Skills

Mavric uses Claude Code's [skills system](https://www.anthropic.com/news/skills) - specialized AI modules that handle specific tasks:

| Skill | Purpose |
|-------|---------|
| `saas-project-orchestrator` | Coordinates the entire workflow |
| `discovery-interviewer` | Conducts 90-minute requirements interview |
| `schema-architect` | Designs multi-tenant data models |
| `test-generator` | Creates Gherkin acceptance scenarios |
| `backend-bootstrapper` | Sets up Apso + BetterAuth |
| `feature-builder` | Implements features with tests |

Similar to [awesome-claude-skills](https://github.com/travisvn/awesome-claude-skills) collections, but **opinionated and integrated** into a complete methodology.

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| **AI Interface** | Claude Code |
| **Backend** | Apso (NestJS + PostgreSQL) |
| **Frontend** | Next.js 14+ (App Router) |
| **Auth** | BetterAuth |
| **Testing** | Cucumber/Gherkin (BDD) |
| **Payments** | Stripe |

---

## Quick Start

**1. Install Claude Code**
```bash
npm install -g @anthropic-ai/claude-code
claude login
```

**2. Clone Mavric**
```bash
git clone https://github.com/mavric/devenv.git
cd devenv
```

**3. Start Building**
```bash
claude
```

Then in Claude Code:
```
/start-project
```

---

## Next Steps

<div class="feature-grid" markdown>

<div class="feature-card" markdown>
### :material-help-circle: Why Mavric?
Deep dive into the methodology vs boilerplates.

[Learn More →](concepts/why-mavric.md)
</div>

<div class="feature-card" markdown>
### :material-play-circle: Quick Start
Get up and running in 5 minutes.

[Quick Start →](getting-started/quickstart.md)
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
