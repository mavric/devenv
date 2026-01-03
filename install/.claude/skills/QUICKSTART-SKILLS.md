# Skills Quick Start Guide

> Get up and running with Claude Skills in 5 minutes

## What You Just Got

A complete **skills-based SaaS development system** that transforms your instruction markdown files into reusable, intelligent modules.

### The "Bricks" Analogy

Think of Skills as LEGO bricks:
- Each **skill** = specialized brick (specific purpose)
- **Claude** = intelligent builder (knows which bricks to use and when)
- **Your project** = the structure being built

You don't tell Claude which bricks to use - Claude recognizes what you need and picks the right skills automatically.

## What's Installed

```
.claude/skills/
├── README.md                        # Complete architecture documentation
├── INTEGRATION-GUIDE.md             # Detailed usage patterns
├── QUICKSTART-SKILLS.md            # This file
│
├── saas-project-orchestrator/       # 🎯 META-SKILL
│   └── SKILL.md                     # End-to-end project orchestrator
│
├── product-brief-writer/            # 📋 Product Management
│   └── SKILL.md                     # Creates PRDs
│
├── schema-architect/                # 🏗️ Architecture
│   ├── SKILL.md                     # Designs database schemas
│   └── references/                  # Uses your existing docs!
│       ├── saas-base-template.md
│       └── apso-schema-guide.md
│
├── backend-bootstrapper/            # 💻 Engineering
│   ├── SKILL.md                     # Sets up Apso backend
│   └── references/
│       ├── saas-implementation-guide.md
│       └── saas-tech-stack.md
│
└── feature-builder/                 # ⚡ Feature Development
    └── SKILL.md                     # Implements features full-stack
```

## 3 Ways to Use Skills

### 1. Full Project Creation (Recommended for New Projects)

**Just say:**
```
"I want to build a SaaS application for project management"
```

**What happens:**
- 🎯 `saas-project-orchestrator` activates
- Guides you through entire SDLC
- Calls worker skills automatically
- Delivers production-ready app in 12 weeks

**You get:**
- ✅ Complete PRD
- ✅ Database schema
- ✅ Working backend API
- ✅ Next.js frontend
- ✅ Authentication with multi-tenancy
- ✅ Core features implemented
- ✅ Tests
- ✅ Deployed to production

### 2. Specific Tasks (For Existing Projects)

**Examples:**
```
"Design a database schema for a CRM"
→ schema-architect activates

"Set up the Apso backend"
→ backend-bootstrapper activates

"Implement a commenting feature"
→ feature-builder activates
```

**What happens:**
- Claude recognizes the task type
- Loads the appropriate skill
- Executes the task
- Delivers the output

### 3. Guided Development (Mix of Both)

**Start orchestrated, switch to specific:**
```
"Start a new SaaS project"
→ Orchestrator guides through planning

"Actually, I already have a schema. Just set up the backend."
→ Claude skips schema-architect, activates backend-bootstrapper
```

## Try It Now - 3 Examples

### Example 1: Schema Design (5 minutes)

**You say:**
```
"Design a database schema for a SaaS CRM with organizations, contacts, deals, and activities. Include multi-tenancy."
```

**Expected output:**
- `.apsorc` schema file
- Entity relationship diagram
- Field definitions with types
- Indexes and constraints
- Multi-tenant architecture

### Example 2: Backend Setup (10 minutes)

**Prerequisites:** Have a schema ready (or use example 1)

**You say:**
```
"Set up an Apso backend using this schema"
```

**Expected output:**
- Complete NestJS backend
- REST API with all CRUD endpoints
- PostgreSQL database running
- OpenAPI documentation at localhost:3001/api/docs
- Verified working endpoints

### Example 3: Feature Implementation (30-60 minutes)

**Prerequisites:** Have backend + frontend running

**You say:**
```
"Implement a feature that lets users add comments to deals. Comments should have markdown support and show who wrote them and when."
```

**Expected output:**
- Backend: Comment entity, CRUD endpoints, validation
- Frontend: CommentList, CommentForm, markdown rendering
- Tests: Unit + integration tests
- Working feature you can test

## How Claude Chooses Skills

Claude automatically selects skills based on:

1. **Context Analysis**
   - What's the user asking for?
   - What state is the project in?
   - What skills are available?

2. **Trigger Matching**
   - Each skill has trigger phrases in its description
   - Claude matches your request to skills

3. **Dependency Resolution**
   - If a skill needs another skill's output, Claude calls it first
   - Example: backend-bootstrapper needs schema-architect

4. **Orchestration Intelligence**
   - Meta-skill orchestrates complex flows
   - Worker skills handle specific tasks
   - Claude manages the coordination

## Key Concepts

### Skills vs. Slash Commands

**Slash Commands:**
- You invoke manually: `/command`
- You must remember they exist
- Run once, then done

**Skills:**
- Claude invokes automatically
- You just describe what you want
- Can chain together in workflows

### Skills vs. Subagents

**Subagents:**
- Separate AI instances
- Work in isolation
- You manage coordination

**Skills:**
- Same Claude instance
- Share context
- Claude manages coordination

### Skills = Narrow Intelligence

Each skill is specialized:
- ✅ product-brief-writer knows PRD structure
- ✅ schema-architect knows database design
- ✅ feature-builder knows full-stack implementation

Claude is the **general intelligence** that orchestrates them.

## Customization

### Add Your Own References

Skills can reference your company-specific docs:

```bash
# Add custom patterns to schema-architect
cp internal/our-schema-conventions.md \
   .claude/skills/schema-architect/references/

# Add your design system to frontend-bootstrapper (when created)
cp design-system.md \
   .claude/skills/frontend-bootstrapper/references/
```

Skills will automatically use this knowledge.

### Create Custom Skills

```bash
# Create new skill
mkdir .claude/skills/my-custom-skill

# Write skill definition
cat > .claude/skills/my-custom-skill/SKILL.md <<'EOF'
---
name: my-custom-skill
description: Does X when user asks for Y
---

# My Custom Skill

I do [specific thing]...
EOF

# Test it
"Use my-custom-skill to [do thing]"
```

## Tips for Best Results

### ✅ Provide Context Upfront

**Bad:**
```
"Build something"
```

**Good:**
```
"Build a SaaS time tracking app for freelancers.
Key features: project tracking, time entries, invoicing.
Timeline: 12 weeks. Tech stack: Apso + Next.js."
```

### ✅ Let Claude Orchestrate

**Bad:**
```
"First use schema-architect, then backend-bootstrapper, then..."
```

**Good:**
```
"Build a backend for my CRM"
```

Claude knows the right sequence.

### ✅ Review and Iterate

After each skill output:
1. Review what was generated
2. Test it
3. Provide feedback if needed
4. Move to next step

### ✅ Be Specific About Features

**Bad:**
```
"Add comments"
```

**Good:**
```
"Add a commenting system where users can comment on projects.
Comments should support markdown, show author and timestamp,
and allow editing/deleting by the author or admins."
```

## What's Next?

### Immediate Next Steps

1. **Try the Orchestrator**
   ```
   "Start a new SaaS project for [your idea]"
   ```

2. **Or Try a Specific Skill**
   ```
   "Design a schema for [your domain]"
   ```

3. **Read the Docs**
   - `.claude/skills/README.md` - Architecture overview
   - `.claude/skills/INTEGRATION-GUIDE.md` - Detailed patterns

### Future Skills (Coming Soon)

These skills are planned for v1.1-v2.0:

- `roadmap-planner` - Generate progressive delivery roadmaps
- `task-decomposer` - Break work into 800+ checkboxes
- `frontend-bootstrapper` - Next.js + shadcn/ui setup
- `auth-implementer` - Better Auth implementation
- `api-client-generator` - Type-safe API clients
- `test-generator` - Comprehensive test suites
- `deployment-orchestrator` - Production deployment
- `code-standards-enforcer` - Automatic SOLID enforcement
- `security-auditor` - Vulnerability scanning

Want to help build these? Each skill is just a SKILL.md file!

## Your Old .devenv Still Works

The skills system **enhances** your existing setup:

| Old Way | New Way (Skills) |
|---------|-----------------|
| Copy .devenv template | Say "start new project" |
| Read markdown guides | Skills reference them automatically |
| Manually follow steps | Claude orchestrates the flow |
| Enforce standards manually | Skills enforce automatically |

**Keep your .devenv directory** - Skills reference those files!

## Getting Help

**Skills not activating?**
- Be more explicit: "Use schema-architect to design this"
- Check skill triggers in SKILL.md files

**Wrong skill activating?**
- Provide more context about what you want
- Say "Actually, use [skill-name] for this"

**Skill output not right?**
- Give specific feedback
- Skills iterate based on your input

**Want to understand architecture?**
- Read `.claude/skills/README.md`
- Read `.claude/skills/INTEGRATION-GUIDE.md`

## Philosophy

> "Each skill is a brick of narrow intelligence. Claude is the mortar that holds them together."

You're not building AGI - you're building **modular intelligence** you actually control.

- Each skill = specialized tool
- Claude = intelligent craftsperson
- Together = complete projects

## Ready?

**Start with the orchestrator:**
```
"I want to build a SaaS application for [your idea]"
```

**Or try a specific skill:**
```
"Design a database schema for [your domain]"
```

Claude will take it from there.

---

**Pro Tip:** The more context you provide upfront, the better Claude can orchestrate skills to build exactly what you need.

**Happy building! 🚀**
