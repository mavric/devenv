# /start-project

Start a new SaaS project with full SDLC orchestration.

---

## Usage

```
/start-project
```

Or simply say:
- "I want to build a new SaaS..."
- "Help me create a [type] platform"
- "Start a new project for..."

---

## What It Does

This command invokes the `saas-project-orchestrator` skill, which guides you through the entire Software Development Life Cycle:

### Phase 0: Discovery (90 min)
Comprehensive requirements interview covering:
- Product vision
- User personas
- Core workflows
- Data model
- Edge cases
- Success criteria

### Phase 1: Test Scenarios
Generates 40-60 Gherkin scenarios from your workflows.

### Phase 2: Schema Design
Creates multi-tenant database schema (`.apsorc` file).

### Phase 3: Product Brief
Synthesizes all artifacts into a PRD.

### Phase 4: Roadmap
Creates phased delivery plan with task breakdown.

### Phase 5+: Implementation
Guides through backend, frontend, auth, and feature development.

---

## Example Session

```
You: /start-project

Claude: Great! Since you're starting a new SaaS project, I'll invoke
the saas-project-orchestrator skill. This will guide us through:

0. Deep Discovery (90 min)
1. Test Scenarios (Gherkin)
2. Schema Design
3. Product Brief
4. Roadmap & Tasks
5. Implementation

Let me start the orchestrator now...

[Discovery Interview Begins]

Claude: Let's start with your product vision.

1. What problem does your product solve?
2. Who experiences this problem most acutely?
3. What's your business model?

You: [Answers questions...]
```

---

## When to Use

| Scenario | Use /start-project? |
|----------|---------------------|
| Brand new SaaS product | **Yes** |
| New application from scratch | **Yes** |
| Major pivot/rewrite | **Yes** |
| Adding feature to existing project | No - use `/discovery-only` |
| Small enhancement | No - just ask directly |
| Bug fix | No - just ask directly |

---

## Output Artifacts

After completing the workflow, you'll have:

| Artifact | Location |
|----------|----------|
| Discovery document | `features/docs/discovery/` |
| Gherkin scenarios | `features/api/`, `features/ui/`, `features/e2e/` |
| Schema file | `backend/.apsorc` |
| Product brief | `features/docs/product-requirements.md` |
| Running backend | `backend/` |
| Running frontend | `frontend/` |

---

## Related

- [Discovery-First Development](../concepts/discovery-first.md)
- [Development Workflow](../concepts/workflow.md)
- [SaaS Project Orchestrator Skill](../skills/saas-project-orchestrator.md)
