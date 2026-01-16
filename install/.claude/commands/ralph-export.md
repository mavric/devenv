# Ralph Export Command

Export DevEnv artifacts to Ralph format for autonomous development.

---

## Prerequisites

Before running this command, you should have completed:
1. **Discovery** (`/discovery-only` or `/start-project`) → produces discovery output
2. **Test Generation** → produces Gherkin scenarios in `specs/scenarios/`
3. **Schema Design** (`/schema`) → produces `.apsorc` or schema file
4. **Product Brief** (optional) → additional context

---

## What This Command Does

Converts your DevEnv artifacts into Ralph's required format:

| DevEnv Artifact | Ralph Artifact | Purpose |
|-----------------|----------------|---------|
| Discovery output | `PROMPT.md` | Development instructions |
| Gherkin scenarios | `@fix_plan.md` | Ordered tasks with verification |
| Schema design | `specs/` | Technical specifications |
| Tech stack | `@AGENT.md` | Build/run instructions |

---

## Execution Steps

### Step 1: Gather Existing Artifacts

First, locate the DevEnv artifacts in this project:

```
Look for:
- specs/discovery.md or similar discovery output
- specs/scenarios/*.feature (Gherkin files)
- .apsorc or specs/schema.* (database schema)
- product-brief.md or PRD document
```

Read each artifact to understand the project scope.

### Step 2: Generate PROMPT.md

Create `PROMPT.md` with this structure:

```markdown
# [Project Name] - Complete Build (All Phases)

## Context

You are Ralph, an autonomous AI development agent building [project description].

**Approach:** [Development approach - e.g., "Screens-first development"]

---

## Project Overview

[2-3 paragraph summary from discovery output]

**Primary Device:** [Target device/platform]

---

## Tech Stack (Non-Negotiable)

| Layer | Technology |
|-------|------------|
| Framework | [from discovery] |
| Language | [from discovery] |
| UI Library | [from discovery] |
| Styling | [from discovery] |
| Backend | [from discovery] |
| Auth | [from discovery] |
| Database | [from discovery] |

---

## Phase Overview

| Phase | Focus | Auth Required |
|-------|-------|---------------|
| **Phase 1** | Foundation & Layout | No |
| **Phase 2** | All Screens (mock data) | No |
| **Phase 3** | Backend Schema & API | No |
| **Phase 4** | [Domain-specific phase] | No |
| **Phase 5** | Authentication | Yes |
| **Phase 6** | Polish & QA | Yes |

**Work through phases sequentially.** Complete all tasks in a phase before moving to the next.

---

## Phase 1: Foundation & Layout

[Extract from discovery - project setup, layout components, route structure]

### Deliverables
- [List key deliverables]

### Route Structure

```
[List all routes from discovery/scenarios]
```

---

## Phase 2-N: [Phase Names]

[Continue with remaining phases extracted from discovery and scenarios]

---

## Reference Documents

All specifications are in `specs/`:

- `specs/discovery.md` - Full product discovery
- `specs/entity-relationship.md` - Data model
- `specs/scenarios/` - Gherkin test scenarios

---

## Key Principles

- **ONE task per loop** - focus on completing one thing well
- **Search before assuming** - check if something exists before creating
- **Phase order matters** - complete current phase before moving to next
- **No auth until Phase 5** - don't add authentication early
- **Commit frequently** - commit after each completed task

---

## Updating @fix_plan.md (CRITICAL)

**You MUST update @fix_plan.md after completing each task.** This is how progress is tracked.

### After completing a task:
1. Open `@fix_plan.md`
2. Find the task you just completed
3. Change `- [ ]` to `- [x]`
4. Add ` ✓` at the end if verification passed

### Example:
```markdown
# Before
- [ ] Create user list page with search

# After
- [x] Create user list page with search ✓
```

### Why this matters:
- The loop counts completed tasks to track progress
- Exit conditions check @fix_plan.md completion percentage
- If you don't mark tasks complete, the loop runs forever

**At the END of EVERY response, you must have updated @fix_plan.md for any tasks you completed.**

---

## Verification Approach (BDD E2E Testing)

**Every VERIFY item in @fix_plan.md must be tested using the BDD E2E test suite.**

### How to Run Verification Tests

```bash
# Start dev server
npm run dev &
sleep 5

# Run BDD tests
npm run test:bdd

# Run specific feature
npx bddgen && npx playwright test --grep "@feature-tag"
```

### If Verification Fails

1. Read the test failure output
2. Check if step definition is missing
3. Fix the issue, re-run tests
4. **DO NOT mark task [x] until tests pass**

---

## Error Recovery (CRITICAL)

When you encounter errors:

### Build/Compile Errors
1. **DO NOT loop endlessly** on the same error
2. If same error persists after 2 attempts, try different approach
3. If stuck for 3+ attempts: add `// TODO: Fix this` and move on

### ESLint/TypeScript Errors
- Warnings are OK - only errors block
- For unused vars: prefix with underscore (`_unusedVar`)
- If truly stuck: use `as any` temporarily with `// TODO: fix type`

### Recovery Principle
**Progress over perfection.** Working code with TODOs is better than being stuck.

---

## Status Reporting (CRITICAL)

At the end of EVERY response, include:

```
---RALPH_STATUS---
STATUS: IN_PROGRESS | COMPLETE | BLOCKED
CURRENT_PHASE: 1 | 2 | 3 | 4 | 5 | 6
TASKS_COMPLETED_THIS_LOOP: <number>
FILES_MODIFIED: <number>
TESTS_STATUS: PASSING | FAILING | NOT_RUN
WORK_TYPE: IMPLEMENTATION | TESTING | DOCUMENTATION | REFACTORING
EXIT_SIGNAL: false | true
RECOMMENDATION: <one line summary of what to do next>
---END_RALPH_STATUS---
```

### When to set EXIT_SIGNAL: true

Set `EXIT_SIGNAL: true` ONLY when ALL of these are true:
1. ALL items in @fix_plan.md are marked [x]
2. `npm run dev` works without errors
3. `npm run build` succeeds
4. All routes work and are navigable
5. Authentication is working (if applicable)
6. No TypeScript or ESLint errors
7. Core user flows tested and working

---

## Current Task

Check @fix_plan.md and work on the highest priority incomplete task.
```

### Step 3: Generate @fix_plan.md

Create `@fix_plan.md` from Gherkin scenarios:

```markdown
# [Project Name] - Complete Build Fix Plan (All Phases)

**Instructions:**
- Work through phases sequentially. Complete ALL tasks in a phase before moving to the next.
- Each task has verification criteria. Do NOT mark a task [x] until verification passes.
- Each phase ends with a PHASE GATE. ALL gate checks must pass before proceeding.
- Reference Gherkin scenarios in `specs/scenarios/` for acceptance criteria.

**Error Handling Rules:**
- If a task fails verification 3 times, mark it with `[~]` (partial) and add `BLOCKED: <reason>`
- Move to the next task - don't get stuck in loops
- Warnings in build output are acceptable - only errors block progress
- Use `// TODO:` comments for issues to fix later, then continue

**Stuck Detection:**
- If you've attempted the same fix 3+ times, STOP and move on
- Progress is more important than perfection - Phase 6 is for cleanup

**Verification Rules:**
- VERIFY items MUST pass before marking [x]
- Use BDD E2E tests for verification
- If verification fails, fix the code - don't skip it

---

## PHASE 1: Foundation & Layout

### 1.1 Project Setup

- [ ] Initialize project with [framework]
  - VERIFY: `npm run dev` starts without errors
  - VERIFY: `http://localhost:3000` returns 200

- [ ] Set up styling framework
  - VERIFY: Styles render correctly

[Continue converting each Gherkin scenario to tasks with VERIFY items]

---

### 🚦 PHASE 1 GATE

**ALL checks must pass before proceeding to Phase 2:**

- [ ] `npm run build` completes without errors
- [ ] `npm run lint` passes
- [ ] ALL routes return HTTP 200
- [ ] Git: All changes committed

---

## PHASE 2: [Phase Name]

**Gherkin References:**
- `specs/scenarios/[feature].feature`

[Continue with remaining phases]
```

### Step 4: Generate @AGENT.md

Create `@AGENT.md` with build instructions:

```markdown
# [Project Name] - Agent Build Instructions

## Project Type

[Framework] with [Language], [Styling], and [UI Library]

## Project Initialization

If starting fresh, initialize the project:

```bash
[Project init commands from tech stack]
```

## Development Commands

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Run TypeScript check
npx tsc --noEmit

# Run linter
npm run lint

# Build for production
npm run build

# Run tests
npm run test:bdd
```

## Key File Locations

```
src/
├── app/                    # Pages/routes
├── components/
│   ├── ui/                 # UI components
│   ├── layout/             # Layout components
│   └── shared/             # Shared components
├── lib/                    # Utilities
└── styles/                 # Global styles
```

## Phase-Specific Notes

### Phase 1
- NO authentication - skip any auth setup
- NO API calls - use mock data
- Focus on navigation and layout

### Phase 2
- Build all screens with mock data
- No backend integration yet

[Continue with phase notes]

## Git Workflow Requirements

Before moving to the next task:

1. **Commit with clear messages:**
   ```bash
   git add .
   git commit -m "feat(component): add description"
   ```

2. **Use conventional commits:**
   - `feat:` - new feature
   - `fix:` - bug fix
   - `style:` - styling
   - `refactor:` - refactoring

3. **Update @fix_plan.md** - mark completed items

## Feature Completion Checklist

Before marking a task complete:

- [ ] `npm run dev` works without errors
- [ ] Route is accessible and renders
- [ ] No TypeScript errors
- [ ] No ESLint errors
- [ ] Changes committed
- [ ] @fix_plan.md updated
```

### Step 5: Copy Specs

Ensure the `specs/` folder contains:

```
specs/
├── discovery.md           # From discovery-interviewer
├── entity-relationship.md # From schema-architect
├── apsorc-schema.json     # Or your schema file
├── roadmap.md             # Phase breakdown (optional)
└── scenarios/             # Gherkin feature files
    ├── ui/                # UI tests
    ├── api/               # API tests
    └── e2e/               # End-to-end tests
```

### Step 6: Verify Structure

After generation, verify this structure exists:

```
project/
├── PROMPT.md              # ✓ Development instructions
├── @fix_plan.md           # ✓ Prioritized tasks
├── @AGENT.md              # ✓ Build instructions
├── specs/
│   ├── discovery.md       # ✓ Requirements
│   ├── scenarios/         # ✓ Gherkin tests
│   └── ...
└── [project files]
```

---

## Output

After running this command, you should have:

1. **PROMPT.md** - Complete development instructions for Ralph
2. **@fix_plan.md** - All tasks from scenarios with VERIFY items and phase gates
3. **@AGENT.md** - Build/run/test commands
4. **specs/** - All reference documents and Gherkin scenarios

---

## Next Steps

1. Review generated files for accuracy
2. Adjust phase structure if needed
3. Run `ralph --monitor` to start autonomous development
4. Ralph will work through @fix_plan.md tasks
5. Tests provide exit criteria for Ralph's loop

---

## Tips

- **Gherkin scenarios = tasks**: Each scenario becomes one or more tasks in @fix_plan.md
- **VERIFY items are critical**: Ralph uses these to know when a task is done
- **Phase gates prevent drift**: Don't skip gates even if tempting
- **EXIT_SIGNAL prevents premature exit**: Ralph only stops when explicitly told
