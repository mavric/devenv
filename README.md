# Specification-Driven Development System

> AI-guided application of 50+ years of proven software engineering practices for building production-ready SaaS.

---

## What This Is

A **complete methodology and toolset** for building high-quality SaaS applications by combining:
- **Business Analysis (BA)** - Structured requirements extraction
- **Behavior-Driven Development (BDD)** - Executable specifications
- **Test-Driven Development (TDD)** - Validation-first implementation
- **Domain-Driven Design (DDD)** - Business-aligned architecture

**Guided by AI** to ensure consistent, rigorous application of these proven techniques.

**Location:** `~/projects/mavric/devenv`

---

## 🚀 First Time Here?

**New to this system?** Start here:
- 📦 [INSTALLATION.md](./INSTALLATION.md) - Setup & first project guide (10 min)
- 📘 [SPECIFICATION-DRIVEN-GUIDE.md](./SPECIFICATION-DRIVEN-GUIDE.md) - Overview (15 min read)
- 🎯 [QUICKSTART.md](./QUICKSTART.md) - Detailed walkthrough (20 min read)

**Already set up?** Jump to [Quick Start](#quick-start) below.

---

## Quick Start

### For a New SaaS Project

**Say this to Claude:**
```
"I want to build a SaaS application for [your idea]"
```

**What happens:**
1. **Discovery (90 min)** - AI conducts structured interview extracting complete requirements
2. **Scenarios** - AI generates Gherkin scenarios from workflows (acceptance criteria + tests)
3. **Schema** - AI designs database from scenarios (multi-tenant, DDD patterns)
4. **Product Brief** - AI synthesizes discovery + scenarios into PRD
5. **Roadmap** - AI phases scenarios into delivery waves
6. **Implementation** - AI guides you through building to satisfy scenarios
7. **Validation** - Automated tests prove correctness at every step

**Result:** Production-ready SaaS in 12 weeks with 90%+ test coverage.

📘 **Full Guide:** [SPECIFICATION-DRIVEN-GUIDE.md](./SPECIFICATION-DRIVEN-GUIDE.md)

---

## How It Works

### The Revolutionary Insight

**Traditional approach:**
```
"AI, write me code for X"
   ↓
AI generates code (may or may not be what you need)
```

**Our approach:**
```
"I want to build X"
   ↓
AI guides you through proven methodologies:
   → Structured discovery (90-min BA interview)
   → Gherkin scenarios (executable specifications)
   → Schema extraction (DDD patterns)
   → Implementation (TDD to pass scenarios)
   → Validation (automated testing)
   ↓
You get the RIGHT thing, built RIGHT, with PROOF it works
```

### The Architecture

This system has two complementary parts:

#### 1. AI Skills (The Guides) - `.claude/skills/`

Specialized AI modules that guide you through the development process:

**Meta-Orchestrator:**
- `saas-project-orchestrator` - Guides through entire SDLC (11 phases)

**Worker Skills:**
- `discovery-interviewer` - 90-minute structured BA interview
- `test-generator` - Creates Gherkin scenarios from workflows
- `schema-architect` - Designs database from scenarios
- `product-brief-writer` - Creates comprehensive PRD
- `backend-bootstrapper` - Sets up Apso backend
- `feature-builder` - Implements features to pass scenarios

#### 2. Reference Materials (The Knowledge Base)

Documentation and templates that the skills use:

**foundations/** - Universal methodology
- Product development framework
- Testing methodology
- Build checklists

**saas/** - SaaS patterns (for SaaS projects)
- Standard tech stack
- Base schema template (auth, billing, multi-tenancy)
- Implementation guide
- Feature catalog

**apso/** - Apso patterns (for Apso projects)
- Schema syntax reference
- Best practices

**rules/** - Claude Code enforcement
- SOLID principles
- Security standards
- Testing standards
- Code structure

### How They Work Together

**Example: "Design a schema for my SaaS"**

1. `schema-architect` skill activates (the guide)
2. It reads `saas/saas-base-template.md` (standard entities)
3. It reads `apso/apso-schema-guide.md` (Apso syntax)
4. It guides you through schema design using that knowledge

**Analogy:**
- **Skills** = Expert consultants who guide you
- **Reference materials** = Library the consultants use

---

## The Complete Flow

```
Phase 0: Discovery (90 min)
   ↓ [Complete requirements extracted]
Phase 1: Gherkin Scenarios
   ↓ [Acceptance criteria + tests written]
Phase 2: Schema Design
   ↓ [Data model extracted from scenarios]
Phase 3: Product Brief
   ↓ [PRD synthesized]
Phase 4: Roadmap & Tasks
   ↓ [Delivery phases planned]
Phase 5-11: Implementation
   ↓ [Code satisfies scenarios]
Result: Production-Ready SaaS
```

**Key principle:** Each phase refines the previous, adding precision.

---

## What's Included

```
devenv/
├── SPECIFICATION-DRIVEN-GUIDE.md  # Start here! Overview & quick start
├── METHODOLOGY.md                 # Complete methodology guide
├── QUICKSTART.md                  # "I want to build a SaaS" walkthrough
├── TESTING-INTEGRATION.md         # BDD/Gherkin testing approach
├── TESTING_QUICK_START.md         # 5-minute test setup
├── USAGE.md                       # Detailed usage patterns
│
├── .claude/skills/                # AI Skills (Process Guides)
│   ├── saas-project-orchestrator/ # Meta-orchestrator
│   ├── discovery-interviewer/     # Discovery skill
│   ├── test-generator/            # Gherkin scenario creation
│   ├── schema-architect/          # Database design
│   ├── product-brief-writer/      # PRD creation
│   ├── backend-bootstrapper/      # Backend setup
│   ├── feature-builder/           # Feature implementation
│   └── README.md                  # Skills documentation
│
├── rules/                         # 🚦 Claude Code enforcement rules
│   ├── contribution-standards.mdc # SOLID, code standards
│   ├── security-standards.mdc     # Security best practices
│   ├── testing-standards.mdc      # Testing requirements
│   ├── code-structure.mdc         # File organization
│   ├── local-development.mdc      # Dev environment
│   └── process-task-list.mdc      # Task tracking
│
├── foundations/                   # 🏗️ Universal methodology
│   ├── product-development-foundation.md # 12-week MVP framework
│   ├── testing-methodology.md            # Testing approach
│   ├── roadmap-generator-prompt.md       # Legacy roadmap generator
│   └── build-checklist.md                # Build task checklist
│
├── saas/                          # 💼 SaaS patterns (knowledge base)
│   ├── saas-tech-stack.md         # Mavric's standard stack
│   ├── saas-base-template.md      # Standard SaaS schema
│   ├── saas-implementation-guide.md # Implementation patterns
│   └── saas-feature-catalog.md    # Feature library
│
├── apso/                          # ⚡ Apso patterns (knowledge base)
│   └── apso-schema-guide.md       # Apso schema reference
│
├── docs/                          # 📚 Documentation
│   └── release-notes/             # Version history and summaries
│
├── publication/                   # 📰 Research & blog materials
│   ├── RESEARCH-PROMPT.md         # Research guide for team
│   ├── RESEARCH-BRIEF.md          # Quick research brief
│   └── BLOG-OUTLINE.md            # Blog post structure
│
└── templates/                     # 📋 Template files
    └── README.template.md         # Project README template
```

---

## The Five Core Principles

### 1. Specification as Code
Gherkin scenarios ARE:
- Requirements (what to build)
- Tests (automated validation)
- Documentation (always current)
- Single source of truth (no divergence)

### 2. Progressive Refinement
Discovery → Scenarios → Schema → Brief → Code
Each step refines the previous with approval gates.

### 3. Single Source of Truth
Scenarios = The authoritative specification
Everything else references scenarios.

### 4. AI as Methodologist
AI guides process (how to extract requirements)
Human provides domain knowledge (what requirements are)
Partnership: Human judgment + AI rigor = Quality

### 5. Validation at Every Step
Approval gates after each phase:
- Discovery complete?
- Scenarios correct?
- Schema adequate?
- Code passes tests?

---

## Why This Works

### The Problem: The Killer Combination

**It's not just incomplete requirements - it's rushing to execute WITH incomplete requirements:**

```
Incomplete Requirements + Time Pressure + Premature Execution
                              ↓
    Building Wrong Thing Fast → Expensive Rework → Missed Deadlines
```

**The vicious cycle:**
1. "We need to ship in 12 weeks!" (deadline pressure)
2. "No time for thorough requirements" (rushed discovery)
3. "Let's just start coding" (premature execution)
4. "Wait, that's not right..." (reality hits)
5. "Now we need to rebuild..." (expensive rework - 30% of time)
6. "We need 4 more weeks..." (missed deadlines)
7. "Just ship it, fix later" (technical debt)

**The cost:**
- 60-80% of project failures from this pattern
- 30% of developer time spent on rework
- $100+ to fix in production what costs $1 to fix in requirements

### The Solution: Fast Discovery → Faster Delivery

**The counterintuitive truth:** 90 minutes of structured discovery ACCELERATES delivery.

**Traditional approach (rushing):**
```
2 hours discovery (rushed) + 40 hours coding (wrong) + 20 hours rework
= 66 hours total, 60% quality
```

**Specification-driven (invest upfront):**
```
1.5 hours discovery (complete) + 2 hours scenarios + 30 hours coding (right) + 4 hours rework
= 37.5 hours total, 95% quality
```

**Result: 43% faster + 80% fewer defects**

**The math:**
```
Spend 90 minutes upfront → Save 28.5 hours overall
15:1 return on investment
```

---

## When to Use This

### ✅ Perfect For:
- Greenfield SaaS products
- B2B enterprise software
- Mission-critical applications
- Regulated industries (healthcare, finance)
- Any project where quality matters

### ❌ Consider Alternatives:
- Exploratory prototypes (throwaway code)
- Marketing websites (content-focused)
- Single-user internal tools
- Extremely rapid pivoting (daily changes)

### The Sweet Spot:
Products with **clear business value** requiring **long-term maintenance** where **quality matters**.

**ROI:** Saves 43% time + 80% fewer defects.

---

## Getting Started Today

### Step 1: Read the Methodology (30 min)
Open [METHODOLOGY.md](./METHODOLOGY.md) and read:
- The Core Insight
- Why Traditional Development Fails
- The Five Core Principles
- How AI Changes Everything

### Step 2: Try a Discovery Session (90 min)
Say to Claude:
```
"Let's do a practice discovery interview for a simple task manager"
```

Experience the 90-minute structured interview.

### Step 3: Build Something Real (12 weeks)
Say to Claude:
```
"I want to build a SaaS for [your actual idea]"
```

Build your real project using the full methodology.

---

## What Makes This Revolutionary

### Not New: The Techniques
- Business Analysis: 50+ years old
- BDD/Gherkin: 20+ years old
- TDD: 25+ years old
- DDD: 20+ years old

### Not New: AI
- LLMs exist
- AI coding assistants exist

### Revolutionary: The Combination

**AI applies proven techniques with perfect consistency.**

Traditional: Humans try to follow methodologies (inconsistently)
Our approach: AI guides humans through methodologies (consistently)

Result: **Enterprise-grade quality accessible to everyone.**

---

## The Paradigm Shift

**From:**
- "AI generates code" (tool)
- "Move fast and break things" (speed over quality)
- "Quality requires heroics" (specialists, overtime)

**To:**
- "AI guides development" (methodologist)
- "Move fast and build right things" (speed AND quality)
- "Quality is the default" (methodology, not heroics)

**This is the future of software development.**

---

## Documentation Guide

### 🚀 Getting Started
1. [INSTALLATION.md](./INSTALLATION.md) - Setup & first project (start here!)
2. [SPECIFICATION-DRIVEN-GUIDE.md](./SPECIFICATION-DRIVEN-GUIDE.md) - Overview & quick start
3. [QUICKSTART.md](./QUICKSTART.md) - "I want to build a SaaS" walkthrough
4. [METHODOLOGY.md](./METHODOLOGY.md) - Complete methodology (read this!)

### 🧪 Testing
- [TESTING-INTEGRATION.md](./TESTING-INTEGRATION.md) - BDD/Gherkin approach
- [TESTING_QUICK_START.md](./TESTING_QUICK_START.md) - 5-minute setup

### 🔧 Usage
- [USAGE.md](./USAGE.md) - Detailed usage patterns
- [.claude/skills/README.md](./.claude/skills/README.md) - Skills documentation

### 📚 Deep Dives
- [docs/release-notes/](./docs/release-notes/) - Version history
- [publication/](./publication/) - Research materials

---

## Success Metrics

By the end of your journey, you'll have:
- ✅ Production-ready SaaS application
- ✅ 90%+ test coverage
- ✅ Complete traceability (scenarios → code)
- ✅ Living documentation
- ✅ Validated with users

---

## Version History

### v1.1 (Current) - Discovery-First
**Date:** 2025-11-13

**Added:**
- `discovery-interviewer` skill - 90-minute structured BA interview with PM expertise
- `test-generator` skill - Gherkin scenarios from workflows
- Updated `saas-project-orchestrator` - Now calls discovery as Phase 0
- Complete methodology documentation (METHODOLOGY.md)
- Specification-driven guide (SPECIFICATION-DRIVEN-GUIDE.md)
- Testing integration docs

**Flow:** Discovery → Scenarios → Schema → Brief → Roadmap → Implementation

### v1.0 - Initial Skills System
**Date:** 2025-01-12

**Initial:**
- Skills architecture
- `saas-project-orchestrator`
- `product-brief-writer`
- `schema-architect`
- `backend-bootstrapper`
- `feature-builder`
- Claude Code rules
- SaaS patterns
- Apso patterns

---

## The Promise

**Every developer, every team, every organization** can achieve **enterprise-grade quality** through **AI-guided application of proven techniques**.

Not by working harder.
By working smarter.

Not by replacing human judgment.
By augmenting it with tireless, consistent rigor.

**Welcome to Specification-Driven Development.**

---

## Next Steps

**Ready to build?**

Say to Claude:
```
"I want to build a SaaS application for [your idea]"
```

The orchestrator will guide you through the entire process.

---

**Status:** Production-Ready (v1.1)
**Last Updated:** 2025-11-14
**Maintained By:** Mavric Engineering
