# /ralph-export

Export DevEnv artifacts to Ralph format for autonomous development.

---

## Overview

The `/ralph-export` command bridges DevEnv's discovery-first workflow with [Ralph](https://github.com/frankbria/ralph-claude-code), an autonomous development loop for Claude Code.

**Use this when:** You've completed discovery and scenario generation, and want Ralph to autonomously implement the features.

---

## What Ralph Needs

Ralph requires three core files to operate:

| File | Purpose | DevEnv Source |
|------|---------|---------------|
| `PROMPT.md` | Development instructions, context, rules | Discovery output |
| `@fix_plan.md` | Ordered task list with VERIFY items | Gherkin scenarios |
| `@AGENT.md` | Build commands, file locations | Tech stack config |

The `/ralph-export` command generates all three from your DevEnv artifacts.

---

## Prerequisites

Before running this command, you should have completed:

1. **Discovery** (`/discovery-only` or `/start-project`)
2. **Test Generation** (produces Gherkin scenarios in `specs/scenarios/`)
3. **Schema Design** (`/schema`)

---

## Usage

```
/ralph-export
```

The command will:

1. Locate your DevEnv artifacts (discovery docs, scenarios, schema)
2. Generate `PROMPT.md` with development context and rules
3. Convert Gherkin scenarios to `@fix_plan.md` tasks with VERIFY items
4. Create `@AGENT.md` with build/run instructions
5. Organize specs for Ralph to reference

---

## Generated Files

### PROMPT.md

Contains everything Ralph needs to understand the project:

```markdown
# [Project Name] - Complete Build (All Phases)

## Context
You are Ralph, an autonomous AI development agent building [description].

## Tech Stack (Non-Negotiable)
| Layer | Technology |
|-------|------------|
| Framework | Next.js 14 |
| Backend | Apso + NestJS |
| Auth | BetterAuth |
...

## Updating @fix_plan.md (CRITICAL)
You MUST update @fix_plan.md after completing each task...

## RALPH_STATUS Block
At the end of EVERY response, include:
---RALPH_STATUS---
STATUS: IN_PROGRESS | COMPLETE | BLOCKED
...
---END_RALPH_STATUS---
```

### @fix_plan.md

Converts Gherkin scenarios to Ralph's task format:

```markdown
# [Project Name] - Fix Plan

**Instructions:**
- Work through phases sequentially
- Each task has VERIFY items - don't mark [x] until verified
- Use BDD tests for verification

---

## PHASE 1: Foundation

### 1.1 Project Setup

- [ ] Initialize project with Next.js
  - VERIFY: `npm run dev` starts without errors
  - VERIFY: `http://localhost:3000` returns 200

- [ ] Set up authentication
  - VERIFY: Login page renders
  - VERIFY: Registration flow works

---

### PHASE 1 GATE

- [ ] `npm run build` completes
- [ ] All routes return 200
- [ ] Git: All changes committed

---

## PHASE 2: Core Features
...
```

### @AGENT.md

Build and run instructions:

```markdown
# Agent Build Instructions

## Development Commands

```bash
npm install
npm run dev
npm run build
npm run test:bdd
```

## Key File Locations

```
src/
├── app/           # Pages/routes
├── components/    # UI components
└── lib/           # Utilities
```

## Git Workflow

Commit after each completed task:
```bash
git add .
git commit -m "feat(component): description"
```
```

---

## Ralph Integration

After export, you can run Ralph:

```bash
# Install Ralph (if not already)
curl -fsSL https://raw.githubusercontent.com/frankbria/ralph-claude-code/main/install.sh | bash

# Start autonomous development
ralph --monitor
```

Ralph will:

1. Read `PROMPT.md` for context and rules
2. Work through `@fix_plan.md` tasks
3. Mark tasks `[x]` when VERIFY items pass
4. Report status via `RALPH_STATUS` blocks
5. Exit when `EXIT_SIGNAL: true`

---

## Artifact Mapping

| DevEnv Output | Ralph Input | Key Content |
|---------------|-------------|-------------|
| Discovery output | `PROMPT.md` | Project overview, phases, tech stack |
| Gherkin scenarios | `@fix_plan.md` | Tasks with VERIFY items, phase gates |
| Schema design | `specs/` | Entity definitions, relationships |
| Tech stack | `@AGENT.md` | Build commands, file locations |

---

## Critical Ralph Requirements

The export ensures these Ralph requirements are met:

### PROMPT.md Must Have:
- RALPH_STATUS block format
- EXIT_SIGNAL rules
- @fix_plan.md update instructions
- Error recovery rules
- BDD verification approach

### @fix_plan.md Must Have:
- Instructions header (error handling, stuck detection)
- VERIFY items under each task
- Phase gates between phases
- `[x]` format for completed tasks
- `[~] BLOCKED:` format for stuck tasks

### @AGENT.md Must Have:
- Project init commands
- Dev/build/test commands
- File location map
- Git workflow requirements

---

## Example Workflow

```
1. Start with DevEnv
   /start-project
   ↓
   Discovery interview (90 min)
   ↓
   Generate scenarios
   ↓
   Design schema

2. Export to Ralph
   /ralph-export
   ↓
   PROMPT.md created
   @fix_plan.md created
   @AGENT.md created

3. Run Ralph
   ralph --monitor
   ↓
   Autonomous implementation
   ↓
   EXIT_SIGNAL: true when complete
```

---

## Tips

- **Gherkin scenarios = tasks**: Each scenario becomes one or more tasks in @fix_plan.md
- **VERIFY items are critical**: Ralph uses these to know when a task is done
- **Phase gates prevent drift**: Don't skip gates even if tempting
- **EXIT_SIGNAL prevents premature exit**: Ralph only stops when explicitly told

---

## Learn More

- [Scenario-Driven Development](../concepts/scenario-driven-development.md) - How DevEnv fits in the landscape
- [Ralph Claude Code](https://github.com/frankbria/ralph-claude-code) - Ralph documentation
- [/tests Command](tests.md) - Generate Gherkin scenarios
- [/schema Command](schema.md) - Design database schema
