# Quick Start Guide - Mavric SaaS Development

> The right way to build a SaaS product from scratch

## 🚨 Most Important Rule

**ALWAYS start with discovery. NEVER jump straight to implementation.**

---

## Starting a New Project

When you want to build a new SaaS product, follow this exact sequence:

### Step 1: Discovery (90 minutes)

**Run this command:**
```
/start-project
```

Or manually invoke the skill:
```
Use the saas-project-orchestrator skill
```

This will:
1. **Conduct a 90-minute structured discovery interview**
   - Product vision and business model
   - User personas and their goals
   - Core workflows (step-by-step user actions)
   - Data model (entities and relationships)
   - Edge cases and boundaries
   - Success criteria and metrics
   - Technical constraints and integrations

2. **Generate comprehensive discovery document (15-25 pages)**
   - Complete requirements
   - Detailed workflows
   - Data model design
   - Acceptance criteria
   - Prioritized feature list

3. **Get your approval** (confidence level: 8+/10)

### Step 2: Test Scenarios (Week 1)

The orchestrator will automatically:
- Generate 40-60 Gherkin test scenarios from your workflows
- Create acceptance criteria
- Set up test structure (API, UI, E2E)
- **Deliverable:** Complete test coverage before writing code

### Step 3: Schema Design (Week 1)

The orchestrator will:
- Extract data model from discovery + scenarios
- Design multi-tenant architecture
- Create Apso schema configuration
- **Deliverable:** `.apsorc` file ready for code generation

### Step 4: Product Brief (Week 1)

The orchestrator will:
- Synthesize discovery, scenarios, and schema
- Create comprehensive PRD
- **Deliverable:** Product requirements document

### Step 5: Roadmap & Tasks (Week 1)

The orchestrator will:
- Phase features into delivery waves
- Create detailed task breakdown
- **Deliverable:** Phased roadmap + task list

### Step 6+: Implementation (Weeks 2-12)

The orchestrator will guide you through:
- Backend bootstrap (Apso)
- Frontend bootstrap (Next.js)
- Authentication (Better Auth)
- Feature implementation (full-stack)
- Testing & QA
- Deployment

---

## Why This Order Matters

### The Problem with Skipping Discovery

❌ **What happens when you skip discovery:**
- Missing requirements discovered during implementation
- Need to refactor code and database schema
- Edge cases surface in production (expensive fixes)
- Features don't solve real user problems
- Constant scope creep and rework

💰 **The cost:**
- Fixing requirements post-launch: **100x more expensive**
- 60% of project failures due to poor requirements
- Weeks or months of wasted development time

### The Power of Discovery First

✅ **What happens with discovery:**
- Complete requirements before coding
- All edge cases documented upfront
- Schema designed from actual workflows
- Clear acceptance criteria (test-driven)
- Reduced rework and scope changes

💡 **The benefit:**
- Discovery: **2% of project time**
- Prevents: **80% of implementation issues**
- Validated foundation for everything that follows

---

## Common Scenarios

### Scenario 1: Brand New SaaS Product

**What you say:**
```
"I want to build a new SaaS platform for [description]"
```

**What to do:**
```
1. Run: /start-project
2. Complete 90-minute discovery interview
3. Approve discovery document
4. Let orchestrator handle the rest
```

### Scenario 2: Adding Major Feature to Existing Project

**What you say:**
```
"I want to add [major feature] to my existing product"
```

**What to do:**
```
1. Run: /discovery-only
2. Complete discovery for this feature area
3. Use discovery doc to guide implementation
```

### Scenario 3: Small Feature Enhancement

**What you say:**
```
"Add a comments feature to the project detail page"
```

**What to do:**
```
1. Skip discovery (too small)
2. Use feature-builder skill directly
3. Proceed with implementation
```

### Scenario 4: Bug Fix or Refactor

**What you say:**
```
"Fix the login bug" or "Refactor the auth service"
```

**What to do:**
```
1. Skip discovery (maintenance work)
2. Use debugger or appropriate skill
3. Proceed with fix
```

---

## Available Commands

### `/start-project`
**Use for:** New SaaS projects
**What it does:** Invokes saas-project-orchestrator for full SDLC

### `/discovery-only`
**Use for:** Major features or validation without full orchestration
**What it does:** Runs 90-minute discovery interview only

---

## Tech Stack

Once discovery is complete, you'll build with:

**Backend:**
- Apso (NestJS + PostgreSQL + AWS deployment)
- Auto-generated REST API from schema
- OpenAPI documentation

**Frontend:**
- Next.js 14+ (App Router)
- TypeScript
- Tailwind CSS + shadcn/ui
- React Hook Form + Zod

**Auth:**
- Better Auth
- Email/password + OAuth
- Multi-tenant session management

**Payments:**
- Stripe (subscriptions + billing)

**Infrastructure:**
- Vercel (frontend)
- AWS via Apso (backend)
- PostgreSQL (database)

**Monitoring:**
- Sentry (errors)
- PostHog (analytics)

---

## Documentation Structure

```
lightbulb-v2/
├── QUICKSTART.md              ← You are here
├── rules/
│   ├── new-project-workflow.mdc  ← Enforces discovery-first
│   ├── process-task-list.mdc     ← Task execution guidelines
│   ├── code-structure.mdc        ← Code organization standards
│   └── testing-guide.mdc         ← Testing standards
├── saas/
│   ├── saas-tech-stack.md        ← Complete tech stack details
│   ├── saas-implementation-guide.md  ← Step-by-step implementation
│   └── saas-feature-catalog.md   ← Common SaaS features
├── apso/
│   └── apso-schema-guide.md      ← Apso CLI and schema reference
└── .claude/
    ├── commands/
    │   ├── start-project.md      ← /start-project command
    │   └── discovery-only.md     ← /discovery-only command
    └── skills/
        ├── saas-project-orchestrator/
        ├── discovery-interviewer/
        ├── schema-architect/
        ├── feature-builder/
        └── ... (more skills)
```

---

## Success Checklist

Before starting implementation, ensure you have:

- [ ] Run discovery (90 min structured interview)
- [ ] Received discovery document (15-25 pages)
- [ ] Reviewed and approved discovery (confidence 8+/10)
- [ ] Have clear data model (entities + relationships)
- [ ] Have detailed workflows (step-by-step user actions)
- [ ] Have acceptance criteria defined
- [ ] Have edge cases documented
- [ ] Know what success looks like

If you can't check all boxes, **go back and complete discovery.**

---

## What NOT To Do

❌ **Don't say:**
- "Let's create a Next.js project"
- "Can we start with the database schema?"
- "I want to build [X], let's start coding"

✅ **Do say:**
- "I want to build [X], help me start properly"
- "Run discovery for my new SaaS idea"
- "/start-project"

---

## Getting Help

**For questions about:**
- **Discovery process:** See `.claude/skills/discovery-interviewer/SKILL.md`
- **Project orchestration:** See `.claude/skills/saas-project-orchestrator/SKILL.md`
- **Tech stack:** See `saas/saas-tech-stack.md`
- **Implementation:** See `saas/saas-implementation-guide.md`

**For project-specific rules:**
- See `rules/` directory for all development guidelines

---

## The Golden Rule

**Discovery → Scenarios → Schema → Brief → Roadmap → Implementation**

In that exact order. No exceptions for new projects.

---

## Example: Correct Flow

```
User: "I want to build a product discovery SaaS platform"

Claude: "Great! Since you're starting a new SaaS project, I'll invoke
the saas-project-orchestrator skill. This will guide us through:

1. Deep Discovery (90 min) - Extract complete requirements
2. Test Scenarios - Acceptance criteria as Gherkin
3. Schema Design - Data model from workflows
4. Product Brief - Synthesized PRD
5. Implementation - Building with validation

Let me start the orchestrator now..."

[Invokes saas-project-orchestrator skill]
[Conducts 90-minute discovery interview]
[Generates discovery document]
[Waits for approval]
[Proceeds with test scenarios, schema, etc.]
[Finally begins implementation in Week 2]
```

**Result:** Quality foundation → Quality implementation

---

## Example: Incorrect Flow

```
User: "I want to build a product discovery SaaS platform"

Claude (WRONG): "Let me create implementation todos...
- Set up Next.js project
- Create database schema
- Build authentication
..."

[Jumps straight to building without discovery]
```

**Result:** Missing requirements → Rework → Wasted time

---

## Timeline Expectations

**Week 0 (Discovery):**
- 90-minute structured interview
- Discovery document generation
- Review and approval

**Week 1 (Planning):**
- Test scenario generation (40-60 Gherkin scenarios)
- Schema design (Apso .apsorc file)
- Product brief (PRD)
- Roadmap + task breakdown

**Week 2-12 (Implementation):**
- Backend bootstrap (Apso)
- Frontend bootstrap (Next.js)
- Authentication (Better Auth)
- Core features
- Testing
- Deployment

**Total to MVP: 12 weeks**
**Total to Market Ready: 24 weeks**
**Total to Enterprise Ready: 48 weeks**

---

## Remember

> "Incomplete or bad information at discovery leads to incomplete or bad implementation later."

**Always invest the 90 minutes upfront.** It will save you weeks or months on the backend.

---

## Ready to Start?

Run this command to begin:
```
/start-project
```

And tell me about your SaaS idea!

---

**Last Updated:** 2025-01-14
**Version:** 1.0
**Next Review:** After first 10 projects