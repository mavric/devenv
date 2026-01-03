# Roadmap & Task List Generator Prompt

> Copy this prompt and fill in the project details to generate both `roadmap.md` and `tasks.md` in one shot.

---

## How to Use

1. Copy the prompt below
2. Fill in the `[PROJECT DETAILS]` section with your specific information
3. Paste into Claude
4. Get both roadmap and task list generated
5. Save outputs to `docs/development/roadmap.md` and `docs/development/tasks.md`

---

## The Prompt

```
I need you to create a comprehensive progressive delivery roadmap and accompanying task list for a new project. Generate TWO documents that work together:

1. **roadmap.md** - The "why" and "how" (phases, goals, validation criteria)
2. **tasks.md** - The "what" (checkbox tasks, step-by-step execution)

---

## PROJECT DETAILS

**Project Name:** [Your project name]

**Project Description:** [1-2 paragraph description of what you're building]

**Target Users:** [Who will use this? e.g., "Founders looking for discovery services", "Internal team members"]

**Core Value Proposition:** [What problem does this solve? What's the main value?]

**Tech Stack:**
- Backend: [e.g., Apso/NestJS, Express, Rails]
- Frontend: [e.g., Next.js, React, Vue]
- Database: [e.g., PostgreSQL, MongoDB]
- Key Libraries: [e.g., Better Auth, Stripe, OpenAI]

**MVP Goal:** [What does success look like? e.g., "10 users complete a discovery session"]

**Timeline:** [e.g., 12 weeks, 16 weeks, 6 months]

**Key Features (in priority order):**
1. [Feature 1 - e.g., "User can submit project ideas"]
2. [Feature 2 - e.g., "AI chat for discovery"]
3. [Feature 3 - e.g., "Generate proposals from conversations"]
4. [Feature 4 - e.g., "Team dashboard for managing sessions"]
5. [Additional features...]

**Validation Strategy:** [How will you validate each phase? e.g., "User testing after each phase", "Metrics-driven"]

**Constraints:**
- [e.g., "Must integrate with existing CRM"]
- [e.g., "Budget: $X/month"]
- [e.g., "Team size: X developers"]

---

## INSTRUCTIONS

Generate both documents following these guidelines:

### For roadmap.md:

**Structure:** 6-8 phases using progressive delivery methodology

**Each Phase Must Include:**
- **Goal:** Clear, testable objective
- **Why This Phase:** Strategic reasoning
- **What You'll Build:** Feature descriptions
- **Timeline:** Realistic time estimate (days/weeks)
- **Success Metrics:** Quantifiable validation criteria
- **Validation Questions:** What you'll learn from users
- **Phase Dependencies:** What must be done before
- **Risk & Mitigation:** What could go wrong

**Progressive Delivery Principles:**
- Each phase delivers working software users can test
- Validate assumptions early and often
- Build incrementally (don't wait for perfection)
- Start with proof of concept, add polish later
- Front-load risk (hardest problems first)

**Phase Progression Should Follow:**
1. **Phase 1:** Proof of concept (core loop, basic functionality)
2. **Phase 2:** Add key value feature
3. **Phase 3:** Add authentication/user management
4. **Phase 4:** Add output/deliverable generation
5. **Phase 5:** Team/collaboration features (if applicable)
6. **Phase 6:** Polish, scale, enterprise features

### For tasks.md:

**Structure:** Checkbox-style task list that accompanies roadmap

**Each Phase Section Must Include:**
- Clear section headers matching roadmap phases
- Subsections for logical task grouping (Backend Setup, Frontend Setup, etc.)
- Individual checkbox tasks with clear acceptance criteria
- Dependencies indicated where necessary
- Realistic time estimates in parentheses (Day 1-3, etc.)

**Task Characteristics:**
- ✅ Actionable (starts with verb: "Create", "Install", "Test", "Deploy")
- ✅ Testable (clear completion criteria)
- ✅ Atomic (can be done in one sitting, usually < 2 hours)
- ✅ Ordered (dependencies clear)
- ✅ Specific (exact commands, file names, endpoints)

**Task Categories Per Phase:**
- Schema & Data Model (if applicable)
- Backend Implementation
- Frontend Implementation
- Testing & Validation
- Deployment
- User Testing
- Phase Validation Criteria

**Include:**
- Installation commands
- Configuration file names
- Specific endpoints to create
- Test scenarios
- Deployment steps
- Validation metrics

### Output Format:

Provide two complete markdown files:

**FILE 1: roadmap.md**
```markdown
# [Project Name] - Progressive Delivery Roadmap

## Overview
[Project description and goals]

## Success Criteria
[Define overall MVP success]

## Timeline
[Total timeline with phase breakdown]

---

## Phase 1: [Phase Name] (Week X)

### Goal
[Clear objective]

### Why This Phase
[Strategic reasoning]

### What You'll Build
[Feature list]

### Timeline
[Estimate]

### Architecture Decisions
[Key technical decisions]

### Implementation Details
[Technical approach]

### Success Metrics
[Quantifiable criteria]

### Validation Questions
[What you'll learn]

### Phase Completion Checklist
[High-level deliverables]

---

[Repeat for each phase]

---

## Post-MVP Roadmap
[What comes after MVP]

## Risk Management
[Key risks and mitigation]

## Appendix
[Technical notes, references]
```

**FILE 2: tasks.md**
```markdown
# [Project Name] Development Task List

> Checkbox task tracker for the progressive delivery roadmap

This task list accompanies [roadmap.md](./roadmap.md). Check off tasks as you complete them.

---

## Phase 1: [Phase Name] (Week X)

**Goal:** [Phase goal]
**Deliverable:** [What users can do]

### Backend Setup (Day 1-X)

**Schema & Code Generation:**
- [ ] Install Apso CLI: `npm install -g @apso/apso-cli`
- [ ] Create backend project: `apso server new --name [project]-backend`
- [ ] [More specific tasks...]

**Environment Setup:**
- [ ] Create `.env` file with database credentials
- [ ] [More specific tasks...]

### Frontend Setup (Day X-Y)

**Next.js App:**
- [ ] Create Next.js app: `npx create-next-app@latest client --typescript --tailwind --app`
- [ ] [More specific tasks...]

### Testing & Deployment

- [ ] Test full flow: [describe user flow]
- [ ] [More specific tasks...]

### Phase 1 Validation
- [ ] **Goal:** [Metric]
- [ ] **Metric:** [Specific number]
- [ ] **Question:** [What to validate]
- [ ] **Feedback:** [How to collect]

---

[Repeat for each phase]

---

## Success Criteria Summary

**Phase 1:** [Brief success criteria]
**Phase 2:** [Brief success criteria]
[etc...]

**Overall MVP Success:**
- [ ] [Key metric 1]
- [ ] [Key metric 2]
- [ ] [Key metric 3]

---

**Roadmap:** [roadmap.md](./roadmap.md)
**Schema:** [Link to schema if applicable]

**Version:** 1.0
**Last Updated:** [Date]
**Status:** Ready to execute
```

---

## ADDITIONAL REQUIREMENTS

1. **Be Specific:** Use actual file paths, command examples, endpoint names
2. **Be Realistic:** Time estimates should be achievable
3. **Be Complete:** Don't leave gaps or say "etc." - spell it out
4. **Be Validated:** Include metrics and validation criteria for every phase
5. **Be Progressive:** Each phase should build on the previous one
6. **Be User-Focused:** Always describe what users can do, not just features

---

## EXAMPLES TO REFERENCE

**Good Phase Structure (from Lightbulb):**
- Phase 1: Proof of Concept - Users can submit ideas and see them stored (2 weeks)
- Phase 2: Discovery Chat - Users can chat with AI about their project (2 weeks)
- Phase 3: Auth & Sessions - Users can create accounts and save progress (2 weeks)
- Phase 4: Proposal Generation - Users can extract requirements and generate proposals (2 weeks)
- Phase 5: Team Features - Team can manage sessions (2 weeks)
- Phase 6: Polish & Launch - Production-ready, polished experience (2 weeks)

**Good Task Specificity:**
❌ Bad: "Set up authentication"
✅ Good: "Install Better Auth: `npm install better-auth`, Create auth.ts config, Add signup endpoint"

❌ Bad: "Create frontend"
✅ Good: "Create Next.js app: `npx create-next-app@latest client --typescript --tailwind --app`"

---

## OUTPUT

Please generate both complete files now, using the project details I provided above. Make them detailed, specific, and immediately actionable.
```

---

## Example Usage

Here's how you'd fill it in for a new project:

```
I need you to create a comprehensive progressive delivery roadmap and accompanying task list for a new project. Generate TWO documents that work together:

1. **roadmap.md** - The "why" and "how" (phases, goals, validation criteria)
2. **tasks.md** - The "what" (checkbox tasks, step-by-step execution)

---

## PROJECT DETAILS

**Project Name:** TaskMaster Pro

**Project Description:** A team task management tool that uses AI to help break down complex projects into manageable tasks, estimate timelines, and identify blockers. Unlike other task managers, it actively assists in project planning rather than just tracking tasks.

**Target Users:** Product managers and engineering leads managing complex software projects

**Core Value Proposition:** Reduces project planning time from hours to minutes while improving accuracy using AI analysis of project descriptions.

**Tech Stack:**
- Backend: Apso (NestJS + PostgreSQL)
- Frontend: Next.js 14 with TypeScript
- Database: PostgreSQL
- Key Libraries: OpenAI GPT-4, Better Auth, React Query, Tailwind + shadcn/ui

**MVP Goal:** 20+ product managers successfully plan a project and execute at least 50% of AI-generated tasks

**Timeline:** 14 weeks

**Key Features (in priority order):**
1. Users can create projects and paste in descriptions
2. AI breaks down project into phases and tasks
3. Users can edit, reorder, and manage generated tasks
4. Team collaboration - assign tasks, track progress
5. AI learns from completed projects to improve estimates
6. Integration with GitHub/Jira for task sync

**Validation Strategy:** Weekly user testing sessions with 3-5 PMs, track task completion rates, survey after each phase

**Constraints:**
- Must integrate with existing Slack workspace
- Budget: $150/month for MVP
- Team size: 2 developers
- Must be production-ready by Q2

---

[Rest of prompt continues...]
```

---

## Tips for Best Results

### Be Specific About:
- **Tech choices:** Don't say "a database" - say "PostgreSQL 14"
- **User flows:** Describe exact steps users take
- **Success metrics:** Use numbers (e.g., "10 users" not "some users")
- **Timeline:** Be realistic based on team size

### Common Mistakes:
- ❌ Vague features ("user management" vs. "email/password signup with email verification")
- ❌ Missing dependencies ("add chat" without mentioning database schema changes)
- ❌ Unrealistic timelines (complex features in 1 day)
- ❌ No validation (building features without testing with users)

### Good Project Descriptions Include:
- ✅ The problem you're solving
- ✅ Who experiences this problem
- ✅ What success looks like (metrics)
- ✅ What makes this different/unique
- ✅ Any technical constraints

---

## Post-Generation Checklist

After Claude generates the roadmap and tasks:

- [ ] Review phase order - does it make sense?
- [ ] Check time estimates - are they realistic for your team?
- [ ] Verify validation criteria - can you actually measure these?
- [ ] Confirm dependencies - is anything missing?
- [ ] Test first phase - can you start immediately?
- [ ] Share with team - get feedback before starting

---

## Customizing the Output

Claude will generate based on your inputs, but you can iterate:

**"The timeline is too aggressive, add 2 weeks to each phase"**

**"Phase 3 should come before Phase 2 because we need auth first"**

**"Add more specific tasks for the database schema setup"**

**"Include E2E testing requirements in each phase"**

---

## Saving the Files

```bash
# Create docs directory
mkdir -p docs/development

# Save roadmap
# (Copy Claude's first output)
vim docs/development/roadmap.md

# Save tasks
# (Copy Claude's second output)
vim docs/development/tasks.md

# Commit to git
git add docs/development/
git commit -m "docs: add project roadmap and task list"
```

---

## Related Documents

- **[product-development-foundation.md](./product-development-foundation.md)** - Detailed methodology behind this approach
- **[build-checklist.md](./build-checklist.md)** - Generic checklist template
- **[../README.template.md](../README.template.md)** - Project README template

---

**Version:** 1.0
**Last Updated:** 2025-01-12
**Maintained By:** Mavric Engineering
