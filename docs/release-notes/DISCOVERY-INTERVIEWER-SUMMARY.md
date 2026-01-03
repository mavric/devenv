# Discovery-First Development: The Complete Guide

> "Incomplete or bad information at discovery leads to incomplete or bad implementation later."

---

## What Was Added

Your SaaS development system now includes **comprehensive discovery capability** as the foundation of every project.

### New Skill: discovery-interviewer

**Location:** `.claude/skills/discovery-interviewer/`

**Invoke it by saying:**
```
"I want to build a SaaS for [your idea]"
"Start discovery for my project"
"Begin comprehensive requirements extraction"
```

**What it does:**
Conducts a structured 90-minute interview that extracts complete requirements before any code is written.

---

## The Discovery-First Philosophy

### Traditional Approach (Problems)

```
❌ Idea → Brief description → Start coding
   ↓
   Missing requirements discovered during implementation
   ↓
   Constant rework, scope creep, quality issues
```

### Discovery-First Approach (Solution)

```
✅ Idea → 90-min comprehensive discovery → Complete requirements
   ↓
   Write Gherkin scenarios (acceptance criteria + tests)
   ↓
   Extract schema from scenarios
   ↓
   Implement to pass scenarios
   ↓
   Everything validated automatically
```

---

## The 90-Minute Discovery Interview

### What Happens

The `discovery-interviewer` skill conducts a **comprehensive, structured interview** covering:

#### Section 1: Product Vision (10 min)
- Elevator pitch
- Value proposition
- Business model
- Success metrics

#### Section 2: User Personas (10 min)
- All user types
- Goals and pain points
- User journeys

#### Section 3: Core Workflows (20 min) ⭐ MOST IMPORTANT
For each workflow, extract:
- **Step-by-step user actions** (click this, fill that, see this)
- **Data requirements** (what fields, validation, defaults)
- **Decision points** (if/else paths)
- **Error cases** (what if it fails?)
- **Permissions** (who can do this?)

Example extraction:
```
Workflow: Create Project

1. User clicks "New Project" button
2. Modal appears with form:
   - Project Name (text, required, max 100 chars)
   - Description (textarea, optional, max 500 chars)
   - Due Date (date picker, optional)
   - Status (dropdown: Planning, Active, On Hold)
3. User fills fields
4. User clicks "Create Project"
5. System validates:
   - Name not empty
   - Name unique within org
   - Due date not in past
6. On success:
   - Project created with ID
   - Redirect to project detail page
   - Success message shown
7. On error:
   - Errors shown inline
   - Form data preserved
```

#### Section 4: Data & Entities (15 min)
- Identify all "things" system manages
- Extract attributes, types, constraints
- Map relationships (one-to-many, many-to-many)
- Define multi-tenancy boundaries

#### Section 5: Edge Cases (10 min)
- Boundary conditions (max/min limits)
- Concurrent operations (two users editing)
- Deletion cascades
- Invalid states

#### Section 6: Success Criteria (10 min)
- Acceptance criteria per workflow
- Performance targets
- Quality standards

#### Section 7: Constraints (10 min)
- Technology requirements
- Compliance (GDPR, HIPAA, etc.)
- Integrations
- Timeline

#### Section 8: Review (5 min)
- Completeness check
- Prioritization (MVP vs Future)
- Confidence score (must be 8+/10)

---

## Dual Persona: Interviewer + Product Expert

The discovery-interviewer has **two modes**:

### Mode 1: Interviewer (Extracting)
**When you know the answer:**
```
Q: "What fields do you need on the Create Project form?"
You: "Name, description, due date, and status"
```

### Mode 2: Product Expert (Guiding)
**When you don't know:**
```
Q: "What fields do you need on the Create Project form?"
You: "I'm not sure..."

Response:
"Let me guide you with industry standards. Most project management
SaaS products track:

Essential:
- Name/title (what is it?)
- Description (what's it about?)
- Status (what state?)
- Owner (who's responsible?)

Common additions:
- Due date (when finish?)
- Priority (how important?)
- Tags (how categorize?)

For your use case, which do you need? Any domain-specific fields?"
```

**The product expert:**
- ✅ Presents options with trade-offs
- ✅ Shares industry best practices
- ✅ Helps you think through implications
- ✅ Ensures no question is skipped

---

## Complete Output: Discovery Document

After the 90-minute interview, you receive a **15-25 page discovery document**:

```markdown
# Discovery Document: [Your Project Name]

## Executive Summary
[One paragraph: what, who, why]

## 1. Product Vision
- Elevator pitch
- Value proposition
- Business model
- Success metrics

## 2. User Personas
### [Persona 1]
- Goals
- Pain points
- Journey

### [Persona 2]
...

## 3. Core Workflows
### Workflow 1: Create Project
**Trigger:** User clicks "New Project"

**Steps:**
1. Modal appears with form
2. User fills: Name (required), Description (optional), Due Date, Status
3. User clicks "Create"
4. System validates
5. On success: Redirect + message
6. On error: Show errors, preserve data

**Error Cases:**
- Empty name → "Name is required"
- Duplicate name → "Project exists"
- Invalid date → "Date cannot be in past"

**Permissions:**
- Admin, Manager: Can create
- Member, Viewer: Cannot (button hidden)

**Edge Cases:**
- 100+ projects: Add pagination

[Repeat for all workflows]

## 4. Data Model
### Entity: Project
- id (UUID, auto)
- name (string, required, max 100, unique per org)
- description (text, optional, max 500)
- status (enum: Planning/Active/On Hold, default: Planning)
- due_date (date, optional)
- organization_id (UUID, FK → Organization)
- created_by (UUID, FK → User)
- created_at, updated_at (timestamps, auto)

**Relationships:**
- Belongs to Organization (many-to-one)
- Created by User (many-to-one)
- Has many Tasks (one-to-many)

[Repeat for all entities]

## 5. Edge Cases & Boundaries
**Limits:**
- Max projects per org: 1000
- Max tasks per project: 5000

**Concurrent Editing:**
- Approach: Optimistic locking (last-write-wins with timestamp check)

**Deletion:**
- Delete Project → Soft delete (mark deleted, keep tasks)

## 6. Success Criteria
### Create Project Workflow
**Expected:**
- ✅ Project in database with ID
- ✅ User redirected to detail page
- ✅ Success message shown

**Performance:**
- Form loads <1s
- Submit completes <2s

**Edge Cases Handled:**
- ❌ Duplicates rejected
- ❌ Invalid data prevented

## 7. Constraints & Integration
**Tech Stack:** Next.js, NestJS (Apso), PostgreSQL, Better Auth
**Compliance:** GDPR (EU users)
**Integrations:** Stripe (payments), SendGrid (email)
**Timeline:** 12 weeks to MVP

## 8. Prioritization
### MVP (Phase 1)
1. User authentication
2. Project CRUD
3. Task management

### Post-MVP (Phase 2)
4. Team collaboration
5. Notifications

## Confidence: 9/10

## Next Steps
1. ✅ Discovery complete
2. ⏭️ Generate Gherkin scenarios
3. ⏭️ Extract schema
4. ⏭️ Write product brief
5. ⏭️ Create roadmap
6. ⏭️ Begin implementation
```

---

## How Discovery Integrates with Other Skills

### Updated Orchestration Flow

**Old flow (v1.0):**
```
Orchestrator asks questions → Brief → Schema → Backend → Frontend → Features
```

**New flow (v1.1):**
```
Phase 0: discovery-interviewer → Complete discovery doc
   ↓
Phase 1: test-generator → Gherkin scenarios from workflows
   ↓
Phase 2: schema-architect → Extract from discovery + scenarios
   ↓
Phase 3: product-brief-writer → Synthesize discovery + scenarios + schema
   ↓
Phase 4: roadmap-planner → Phase scenarios into delivery waves
   ↓
Phase 5+: Implementation (backend, frontend, features)
```

### Why This Order?

**1. Discovery First**
- Most important phase
- Quality here determines quality everywhere
- 90 minutes saves weeks of rework

**2. Scenarios Second**
- Workflows from discovery become Gherkin scenarios
- Scenarios serve as BOTH:
  - Acceptance criteria (what defines "done")
  - Automated tests (validation)
- Implementation targets passing these scenarios

**3. Schema Third**
- Extracted from discovery (entity definitions) + scenarios (implicit data needs)
- Example: Scenario says "assign task to user" → implies Task needs `assigned_to` field

**4. Brief Fourth**
- Synthesizes discovery + scenarios + schema
- References scenarios instead of duplicating
- PRD becomes index to other docs

**5. Roadmap Fifth**
- Groups scenarios by priority
- Phases scenarios into delivery waves
- Tasks derived from scenarios

---

## Benefits of Discovery-First

### For You (Builder)

✅ **Clear target**
- You know exactly what to build
- No ambiguity or guesswork
- Implementation is straightforward

✅ **Test-driven**
- Scenarios written before code
- Every feature has acceptance criteria
- Automated validation

✅ **Faster development**
- Less rework (requirements correct upfront)
- Less back-and-forth (edge cases captured)
- Less debugging (scenarios catch issues)

✅ **Better quality**
- Complete requirements → complete implementation
- Edge cases handled → robust system
- Automated tests → confidence in changes

### For Your Users

✅ **Better product**
- Built to solve real problems (discovered in interview)
- Handles edge cases (captured upfront)
- Intuitive workflows (designed with user journey in mind)

✅ **Faster delivery**
- Less pivoting (validated requirements)
- Fewer bugs (test-driven)
- Predictable progress (clear roadmap)

### For Your Business

✅ **Lower cost**
- Build it right once (vs iterate forever)
- Automated testing (vs manual QA)
- Clear scope (vs endless scope creep)

✅ **Lower risk**
- Validate assumptions early (90-min interview)
- Clear success metrics (defined upfront)
- Phased delivery (test with users incrementally)

---

## Quick Start: Your First Discovery Session

### 1. Trigger the Discovery Skill

Say to Claude:
```
"I want to build a SaaS for [your idea]"
```

Examples:
- "I want to build a SaaS for project management"
- "I want to build a SaaS to help agencies track client work"
- "I want to build a SaaS for fitness coaches"

### 2. Participate in 90-Minute Interview

The discovery-interviewer will:
- Ask 50-70 questions across 8 sections
- Guide you when you don't know answers
- Dig deep into workflows (step-by-step detail)
- Extract edge cases and constraints

**Your job:**
- Answer questions as completely as you can
- Use concrete examples ("A user named Sarah who...")
- Ask for guidance when unsure
- Review extraction for accuracy

### 3. Review Discovery Document

You'll receive 15-25 page document with:
- Complete workflows (every step documented)
- Data model (every entity defined)
- Edge cases (boundaries captured)
- Success criteria (acceptance defined)

**Approval gate:** Must be 8+/10 confidence before proceeding

### 4. Approve to Continue

Once you approve:
- `test-generator` creates Gherkin scenarios
- `schema-architect` designs database
- `product-brief-writer` creates PRD
- `roadmap-planner` creates delivery phases
- Implementation begins

---

## Example Discovery Sessions

### Example 1: Simple CRUD App

**User:** "I want to build a task management app"

**Discovery extracts:**
- 3 core workflows (create task, update status, assign)
- 2 entities (Task, User)
- 8 edge cases (max tasks, duplicate titles, etc.)
- 15 scenarios generated
- 6 weeks to MVP

### Example 2: Complex Multi-Tenant SaaS

**User:** "I want to build a project management platform for agencies"

**Discovery extracts:**
- 12 core workflows (projects, tasks, time tracking, invoicing, reporting)
- 8 entities (Organization, Project, Task, TimeEntry, Invoice, User, Client, Report)
- 35 edge cases (concurrent editing, billing edge cases, permission boundaries)
- 60 scenarios generated
- 12 weeks to MVP

---

## Documentation

### Skill Files

- **Main skill:** `.claude/skills/discovery-interviewer/SKILL.md`
- **Interview framework:** `.claude/skills/discovery-interviewer/references/discovery-framework.md`
- **Product best practices:** `.claude/skills/discovery-interviewer/references/product-management-playbook.md`

### Integration Docs

- **Updated orchestrator:** `.claude/skills/saas-project-orchestrator/SKILL.md`
- **Skills overview:** `.claude/skills/README.md`
- **Testing integration:** `TESTING-INTEGRATION.md`

---

## Try It Now

**Start your first discovery session:**

```
"I want to build a SaaS application for [your use case]"
```

The `saas-project-orchestrator` will automatically call `discovery-interviewer` as Phase 0.

**Prepare to spend 90 minutes.** This time investment will save you weeks of rework.

---

## FAQs

### Q: Do I really need 90 minutes of discovery?

**A:** Yes. The depth extracted in those 90 minutes determines the quality of everything that follows. Incomplete discovery → incomplete implementation.

### Q: What if I don't have answers to questions?

**A:** The discovery-interviewer includes product management expertise. It will guide you with industry best practices, present options with trade-offs, and help you figure out answers.

### Q: Can I skip discovery for a simple app?

**A:** Even simple apps have workflows, edge cases, and data models. Discovery ensures you capture them upfront rather than discovering them during implementation (which requires rework).

### Q: What if my requirements change later?

**A:** Discovery documents can be updated. Re-run relevant sections with the discovery-interviewer, regenerate affected scenarios, and update implementation. The discovery-first approach makes changes cheaper because you're updating specs (scenarios) before updating code.

### Q: How is this different from just writing a PRD?

**A:** Discovery interviewer is:
1. **Interactive** (asks probing questions vs you writing freely)
2. **Structured** (ensures no gaps vs freeform)
3. **Depth-focused** (drills into workflows vs high-level descriptions)
4. **Guided** (provides PM expertise vs you figure it out alone)
5. **Test-ready** (outputs feed directly into scenarios vs abstract requirements)

---

## What's Next

With discovery-interviewer in place, the complete flow is:

```
Phase 0: Discovery (90 min)
   ↓
Phase 1: Test Scenarios (Gherkin)
   ↓
Phase 2: Schema Design (.apsorc)
   ↓
Phase 3: Product Brief (PRD)
   ↓
Phase 4: Roadmap & Tasks
   ↓
Phase 5-11: Implementation
```

**Your system now supports discovery-driven, test-first development from idea to production.**

---

**Status:** ✅ Complete and ready to use
**Version:** v1.1
**Added:** 2025-11-13

Your SaaS development system now has the foundation for building complete, high-quality products from complete, high-quality requirements.
