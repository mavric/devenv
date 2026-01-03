# Core Concepts Overview

Understanding the methodology that makes Mavric different from boilerplates and generators.

---

## The Mavric Methodology

Mavric is not a boilerplate. It's not a code generator. It's an **AI-driven SaaS builder** with an opinionated methodology:

!!! quote "The Core Insight"
    **The best code is code you didn't have to rewrite because you understood what to build from the start.**

While tools like [SaaSBold](https://saasbold.com), [BuilderKit.ai](https://www.builderkit.ai), and [Divjoy](https://divjoy.com) give you code quickly, they assume you already know what to build. The data says otherwise:

- **60%** of project failures are due to poor requirements
- Fixing issues post-launch costs **100x more**
- **30-50%** of projects experience scope creep

Mavric addresses this by enforcing a **discovery-first** approach.

---

## The Core Sequence

```
Discovery → Scenarios → Schema → Brief → Implementation
```

**No skipping. No shortcuts. Each phase requires your approval.**

| Phase | What Happens | Why It Matters |
|-------|--------------|----------------|
| **Discovery** | 90-minute structured interview | Extract complete requirements before writing code |
| **Scenarios** | Generate Gherkin test cases | Define success criteria in executable form |
| **Schema** | Design multi-tenant data model | Build the right structure for your workflows |
| **Brief** | Synthesize PRD | Single source of truth for the product |
| **Implementation** | Generate and build | Code with confidence, tests already passing |

---

## How This Differs from Alternatives

### vs. Boilerplates (SaaSBold, BuilderKit, etc.)

| Aspect | Boilerplate | Mavric |
|--------|-------------|--------|
| Starting point | Generic code structure | Your specific requirements |
| Requirements | "Figure it out yourself" | 90-minute guided interview |
| Data model | Pre-defined, modify later | Designed for your workflows |
| Tests | Maybe some examples | Generated before code |
| Documentation | README only | Complete PRD + living docs |

**Boilerplates optimize for "time to first commit." Mavric optimizes for "time to correct product."**

### vs. AI Coding Assistants (Cursor, Aider, Copilot)

| Aspect | Coding Assistant | Mavric |
|--------|-----------------|--------|
| Focus | Write code faster | Build the right thing |
| Methodology | None - you drive | Enforced discovery-first |
| Project structure | Whatever you choose | Consistent, opinionated |
| Tests | If you ask | Always generated first |
| Multi-tenancy | If you know how | Built-in by default |

**Assistants help you code faster. Mavric ensures you're coding the right thing.**

### vs. AI Generators (v0, Bolt, GoCodeo)

| Aspect | Generator | Mavric |
|--------|-----------|--------|
| Input | Prompt/description | Structured discovery |
| Output | Code snapshot | Complete project with tests |
| Iteration | Generate again | Approval gates, incremental |
| Understanding | "Best guess" | Validated requirements |

**Generators are prompt → code. Mavric is methodology → validated product.**

---

## The Four Methodologies Combined

Mavric integrates four proven software engineering practices:

### 1. Business Analysis (BA)

The discovery interview applies BA techniques:

- Stakeholder interviews
- Requirements elicitation
- Workflow mapping
- Edge case identification

**Output:** Complete requirements document (15-25 pages)

### 2. Behavior-Driven Development (BDD)

Test scenarios are written in Gherkin before implementation:

```gherkin
Feature: User Registration

  Scenario: Successful registration with valid email
    Given I am on the registration page
    When I fill in "Email" with "user@example.com"
    And I fill in "Password" with "SecurePass123"
    And I click "Register"
    Then I should see "Please verify your email"
    And I should receive a verification email
```

**Output:** Executable specifications that serve as tests and documentation

### 3. Test-Driven Development (TDD)

Tests are generated **before** code:

1. Discovery defines requirements
2. Test generator creates Gherkin scenarios
3. Backend is generated
4. Features are built to pass tests

**Output:** Code that's validated against specifications from day one

### 4. Domain-Driven Design (DDD)

The schema architect designs data models that mirror your business domain:

- Entities map to business concepts
- Relationships reflect real workflows
- Multi-tenancy built into the foundation
- Aggregates defined by business boundaries

**Output:** Data model that grows with your product

---

## The Skill System

Mavric is built on [Claude Code Skills](https://www.anthropic.com/news/skills), similar to collections like [awesome-claude-skills](https://github.com/travisvn/awesome-claude-skills). But Mavric's skills are:

### Opinionated

They enforce the methodology. You can't skip discovery to get to code.

### Integrated

Skills work together as a system:

```
saas-project-orchestrator
        │
        ├── discovery-interviewer
        ├── test-generator
        ├── schema-architect
        ├── product-brief-writer
        ├── backend-bootstrapper
        └── feature-builder
```

### SaaS-Focused

Every skill is designed for multi-tenant B2B/B2C SaaS, covering common capability areas:

| Capability | Support |
|------------|---------|
| Authentication | BetterAuth integration |
| Multi-Tenancy | Organization entity + scoped data |
| Team Management | Roles, invitations |
| Billing & Payments | Stripe-ready templates |
| API Keys | External integrations |
| Audit Logging | Compliance tracking |

See [SaaS Capabilities](saas-capabilities.md) for the complete capability roadmap and expansion plan.

---

## Quality Gates

The orchestrator enforces approval at each phase:

| Gate | Criteria | Why |
|------|----------|-----|
| **Discovery Approval** | Confidence ≥ 8/10 | Ensures requirements are complete |
| **Scenario Review** | All workflows covered | Validates acceptance criteria |
| **Schema Validation** | Supports all workflows | Confirms data model fits |
| **MVP Definition** | Clear scope | Prevents scope creep |

You must explicitly approve each gate. This prevents:

- Premature coding
- Skipped requirements
- Scope creep
- Rework later

---

## Artifacts Produced

After running through the Mavric workflow:

```
my-saas/
├── docs/
│   ├── discovery/
│   │   ├── discovery-notes.md       # Full interview transcript
│   │   └── discovery-summary.md     # Structured requirements
│   ├── scenarios/
│   │   ├── auth.feature             # Auth test scenarios
│   │   ├── projects.feature         # Domain test scenarios
│   │   └── ...
│   └── product-requirements.md      # Complete PRD
│
├── backend/
│   ├── .apsorc                      # Schema definition
│   ├── src/
│   │   ├── autogen/                 # Generated code (don't edit)
│   │   └── extensions/              # Your custom logic
│   ├── test/                        # Test implementations
│   └── .env                         # Configuration
│
└── frontend/
    └── ...                          # Next.js application
```

Compare to a boilerplate:

```
my-saas/
├── README.md                        # "Good luck!"
├── src/
└── ...                              # Generic structure
```

---

## When Mavric is Right

Use Mavric when:

- Building a **new SaaS product**
- Requirements are **unclear or evolving**
- You want **tests before code**
- You need **multi-tenancy from day one**
- You want **documented, defensible decisions**
- You're working with **stakeholders who need visibility**

Use a boilerplate when:

- You've built this exact thing before
- Requirements are already complete and documented
- You just need a starting structure
- Speed to first commit matters more than correctness

---

## Next Steps

- [Why Mavric?](why-mavric.md) - Detailed comparison with alternatives
- [SaaS Capabilities](saas-capabilities.md) - Feature areas and expansion roadmap
- [Discovery-First Development](discovery-first.md) - The 90-minute interview
- [Project Structure](project-structure.md) - File organization
- [Development Workflow](workflow.md) - Phase-by-phase guide
