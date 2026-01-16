# Why Mavric?

Understanding how Mavric differs from boilerplates, generators, and other AI coding tools.

---

## The Landscape Today

When developers want to build a SaaS product, they typically reach for one of these tools:

### SaaS Boilerplates

Pre-built codebases you clone and modify:

- [SaaSBold](https://saasbold.com) - Full-stack starter kit
- [BuilderKit.ai](https://www.builderkit.ai) - Next.js with AI integrations
- [Supastarter](https://supastarter.dev) - Next.js + Supabase
- [ixartz SaaS-Boilerplate](https://github.com/ixartz/SaaS-Boilerplate) - Open source template

**What they give you:** Auth, payments, database, UI components, project structure.

**What they don't give you:** Any understanding of what you should build.

### AI Code Generators

Tools that generate code from prompts:

- [GoCodeo SaaSBuilder](https://www.gocodeo.com) - Prompt-based scaffold generation
- [v0.dev](https://v0.dev) - UI component generation
- [Bolt](https://bolt.new) - Full-stack app generation

**What they give you:** Faster code generation from descriptions.

**What they don't give you:** Validation that you're building the right thing.

### AI Coding Assistants

Tools that help you write code faster:

- [Cursor](https://cursor.com) - AI-native IDE
- [Aider](https://aider.chat) - Terminal-based AI pair programmer
- [GitHub Copilot](https://github.com/features/copilot) - AI autocomplete
- [Claude Code](https://claude.com/claude-code) - Anthropic's CLI assistant

**What they give you:** Faster implementation of whatever you're building.

**What they don't give you:** Guidance on what to build or how to structure it.

### Spec-Driven Development Tools

Tools that use specifications to guide AI code generation:

- [GitHub Spec Kit](https://github.com/github/spec-kit) - Markdown-based specification toolkit
- [OpenSpec](https://github.com/Fission-AI/OpenSpec) - Spec-driven development for AI assistants

**What they give you:** Structure for AI-assisted development with documentation-first approach.

**What they don't give you:** Requirements elicitation, executable test specifications, or SaaS-specific patterns.

---

## The Gap in the Market

All of these tools share a common assumption:

!!! warning "The Dangerous Assumption"
    **"You already know what to build."**

But the data tells a different story:

| Statistic | Source |
|-----------|--------|
| 60% of project failures are due to poor requirements | Standish Group |
| Fixing issues post-launch costs 100x more | IBM Systems Sciences Institute |
| 30-50% of projects experience scope creep | PMI |
| Only 29% of projects are considered successful | Standish Group CHAOS Report |

**The problem isn't that developers can't code fast enough. It's that they're coding the wrong thing.**

---

## What Makes Mavric Different

Mavric is built on a simple insight:

!!! quote "The Mavric Principle"
    **The best code is code you didn't have to rewrite because you understood what to build from the start.**

Instead of optimizing for "time to first commit," Mavric optimizes for "time to correct product."

### The Methodology

```
Traditional:  Idea → Code → Test → "Oh no, that's wrong" → Rewrite
Mavric:       Idea → Discovery → Tests → Schema → Code → Done
```

Mavric enforces a **discovery-first methodology**:

1. **Discovery** - 90-minute structured interview extracts complete requirements
2. **Scenarios** - AI generates Gherkin test cases from requirements
3. **Schema** - Data model designed for your actual workflows
4. **Brief** - Complete PRD synthesized from all inputs
5. **Build** - Code generation with tests already written

Each phase requires your approval. No skipping ahead.

---

## Side-by-Side Comparison

### Boilerplate Approach

```
Day 1:    Clone boilerplate ✓
Day 2-5:  Start building features
Day 10:   "Wait, we need multi-tenancy differently"
Day 15:   "The data model doesn't support this workflow"
Day 20:   Major refactoring begins
Day 30:   Still refactoring
Day 45:   Finally building actual features again
```

**Total time to first correct feature: 45+ days**

### Mavric Approach

```
Day 1:    Discovery interview (90 minutes)
Day 1:    Generate test scenarios (30 minutes)
Day 1:    Design schema (30 minutes)
Day 1:    Generate backend (30 minutes)
Day 2:    Start building features with tests passing
Day 5:    First features complete and validated
Day 10:   MVP ready for users
```

**Total time to first correct feature: 2 days**

---

## Feature Comparison

| Capability | Boilerplate | Generator | Spec Kit | Mavric |
|------------|-------------|-----------|----------|--------|
| Get code quickly | Yes | Yes | Yes | Yes |
| Structured requirements | No | No | Yes | **Yes** |
| Requirements discovery | No | No | No | **Yes** |
| Tests before code | No | No | Yes | **Yes** |
| Executable test specs | No | No | No | **Yes** |
| Multi-tenancy by default | Sometimes | Rarely | No | **Always** |
| Schema from workflows | No | No | No | **Yes** |
| Approval gates | No | No | Yes | **Yes** |
| Prevents scope creep | No | No | Partial | **Yes** |
| Living documentation | No | No | Yes | **Yes** |
| SaaS-specific patterns | Sometimes | Rarely | No | **Always** |

---

## The Discovery Difference

What you get after 90 minutes with Mavric's discovery-interviewer:

### Requirements Document (15-25 pages)

```markdown
1. Executive Summary
   - Product overview
   - Value proposition
   - Target market

2. User Personas
   - Detailed profiles with goals and frustrations
   - User journey maps

3. Functional Requirements
   - Every workflow documented step-by-step
   - Validation rules specified
   - Error cases defined
   - Success criteria measurable

4. Data Model
   - Entities and relationships
   - Derived from actual workflows

5. Non-Functional Requirements
   - Performance criteria
   - Security requirements
   - Compliance needs

6. Edge Cases
   - Scale considerations
   - Concurrency handling
   - Integration failure modes
```

### What You Get from a Boilerplate

```markdown
1. README.md
   - "Clone this repo"
   - "Run npm install"
   - "Good luck!"
```

---

## Why Discovery First Works

### The Cost of Change

```
┌────────────────────────────────────────────────────────────┐
│  Cost to fix issues by phase                               │
│                                                            │
│  Requirements:  $1     ████                                │
│  Design:        $5     ████████████████████                │
│  Development:   $10    ████████████████████████████████████│
│  Testing:       $20    (2x development)                    │
│  Production:    $100   (10x development)                   │
└────────────────────────────────────────────────────────────┘
```

Mavric front-loads the discovery work when changes are cheap.

### The Test-First Advantage

With Mavric, tests are written **before** code:

```gherkin
# Generated BEFORE any code exists
Feature: Project Creation

  Scenario: Create project with valid data
    Given I am logged in as "user@example.com"
    And I am on the projects page
    When I click "New Project"
    And I fill in "Name" with "My Project"
    And I fill in "Description" with "A test project"
    And I click "Create"
    Then I should see "Project created successfully"
    And I should be on the project dashboard
    And the project should appear in my projects list
```

When you build the feature, you know exactly what success looks like.

---

## Mavric vs. GitHub Spec Kit

[GitHub Spec Kit](https://github.com/github/spec-kit) is the closest tool to Mavric's philosophy. Both believe in **specifications before code**. But they differ in critical ways.

### Shared Philosophy

Both Mavric and Spec Kit agree that "vibe coding" leads to problems:

| Principle | GitHub Spec Kit | Mavric |
|-----------|----------------|--------|
| Specs before code | Yes | Yes |
| Tests before implementation | Yes | Yes |
| Phase gates/approvals | Yes | Yes |
| AI-assisted development | Yes | Yes |

### Where They Differ

#### 1. Requirements Elicitation

**GitHub Spec Kit** assumes you can describe your feature:

```
/specify "Build a project management system with tasks and deadlines"
```

The AI structures what you provide, but doesn't challenge or expand it.

**Mavric** actively extracts requirements through a 90-minute interview:

```
Discovery Interviewer: "You mentioned deadlines. What happens when
a deadline is missed? Who gets notified? Can deadlines be extended?
What permissions are needed to change them?"
```

Mavric uses business analysis techniques to uncover requirements you didn't know you had.

#### 2. Specification Format

**GitHub Spec Kit** uses Markdown PRDs:

```markdown
## Feature: Project Management

### User Stories
- As a user, I want to create projects
- As a user, I want to add tasks to projects

### Acceptance Criteria
- Projects have names and descriptions
- Tasks can be assigned to users
```

**Mavric** uses executable Gherkin scenarios:

```gherkin
Feature: Project Management

  Scenario: Create project with deadline notification
    Given I am logged in as a project manager
    And my organization has Slack integration enabled
    When I create a project with deadline "2024-03-15"
    Then the project should be created
    And a reminder should be scheduled for 3 days before
    And the Slack channel should receive a notification
```

The difference: **Gherkin scenarios are executable tests**. When the code is written, these scenarios run automatically to verify behavior.

#### 3. Discovery vs. Structuring

| Aspect | GitHub Spec Kit | Mavric |
|--------|----------------|--------|
| **Input** | Your feature description | 90-minute guided interview |
| **Process** | AI structures what you provide | AI challenges and expands your thinking |
| **Output** | Organized PRD | Comprehensive requirements + executable tests |
| **Edge cases** | What you think of | What the interviewer uncovers |
| **Validation** | Document review | Tests that pass or fail |

#### 4. Domain Focus

**GitHub Spec Kit** is general-purpose:

- Works for any type of software
- No opinion on architecture
- Constitution principles are customizable

**Mavric** is SaaS-specific:

- Multi-tenancy built into every schema
- Organization-based data isolation
- Authentication patterns included
- Subscription/billing patterns ready

### The Spec Format Matters

Consider this requirement: "Users can invite team members."

**Markdown spec (Spec Kit style):**

```markdown
### Team Invitations
Users can invite others to their team via email.

**Acceptance Criteria:**
- Email invitation is sent
- Invited user can accept/decline
- Inviter is notified of response
```

**Gherkin spec (Mavric style):**

```gherkin
Feature: Team Invitations

  Scenario: Invite team member with valid email
    Given I am an admin of organization "Acme Corp"
    When I invite "newuser@example.com" to the team
    Then an invitation email should be sent
    And the invitation should expire in 7 days
    And the invitation should appear in pending invitations

  Scenario: Invited user accepts invitation
    Given "newuser@example.com" has a pending invitation to "Acme Corp"
    When they click the invitation link
    And they complete registration
    Then they should be added to "Acme Corp"
    And the inviter should receive a notification
    And the invitation should be marked as accepted

  Scenario: Invitation expires
    Given an invitation was sent 8 days ago
    When the invited user clicks the link
    Then they should see "This invitation has expired"
    And they should be prompted to request a new invitation

  Scenario: Non-admin attempts to invite
    Given I am a regular member of organization "Acme Corp"
    When I try to invite "someone@example.com"
    Then I should see "You don't have permission to invite users"
```

The Gherkin version:

- Covers more edge cases
- Specifies exact behavior
- Becomes automated tests
- Serves as living documentation

### When to Use Each

**Use GitHub Spec Kit when:**

- Building general-purpose software
- Requirements are already well-understood
- You want flexibility in architecture
- Your team prefers Markdown documentation

**Use Mavric when:**

- Building a SaaS product
- Requirements are unclear or evolving
- You want executable test specifications
- You need multi-tenancy from day one
- You want guided requirements discovery

### Complementary, Not Competing

You could potentially use both:

1. Use Mavric's discovery-interviewer to extract requirements
2. Generate Gherkin scenarios as executable specs
3. Use Spec Kit's planning phase for additional structure

But Mavric's integrated approach means you don't have to piece tools together.

---

## The Skill System

Mavric is built on [Claude Code Skills](https://www.anthropic.com/news/skills) - the same infrastructure used by projects like:

- [anthropics/skills](https://github.com/anthropics/skills) - Official Anthropic skills
- [awesome-claude-skills](https://github.com/travisvn/awesome-claude-skills) - Community collections

But while most skill collections are **general-purpose utilities**, Mavric's skills are:

1. **Opinionated** - Enforce the discovery-first methodology
2. **Integrated** - Work together as a complete system
3. **SaaS-focused** - Designed specifically for multi-tenant applications
4. **Orchestrated** - Coordinated by the saas-project-orchestrator

### Mavric Skills

| Skill | Purpose |
|-------|---------|
| `saas-project-orchestrator` | Coordinates entire workflow, enforces phase gates |
| `discovery-interviewer` | Conducts 90-minute structured interview |
| `test-generator` | Creates Gherkin scenarios from requirements |
| `schema-architect` | Designs multi-tenant data models |
| `backend-bootstrapper` | Sets up Apso + BetterAuth backend |
| `auth-bootstrapper` | Adds authentication to existing backends |
| `feature-builder` | Implements features with tests |
| `product-brief-writer` | Synthesizes PRD from all inputs |

---

## When to Use What

### Use a Boilerplate When:

- You've built this exact type of app before
- Requirements are already well-documented
- You just need a starting structure
- Time to market is more important than correctness

### Use Mavric When:

- You're building something new
- Requirements are unclear or evolving
- You want to get it right the first time
- You value documentation and tests
- You're building a multi-tenant SaaS
- You want to prevent scope creep

---

## Real-World Impact

### Without Mavric (Typical SaaS Project)

| Phase | Duration | What Happens |
|-------|----------|--------------|
| Week 1-2 | Setup | Clone boilerplate, customize |
| Week 3-6 | Build | Start coding features |
| Week 7-8 | Realize | "This doesn't support our workflow" |
| Week 9-12 | Refactor | Major architecture changes |
| Week 13-16 | Rebuild | Redo features on new architecture |
| Week 17-20 | Finally | MVP ready for testing |

**Total: 20 weeks to MVP**

### With Mavric

| Phase | Duration | What Happens |
|-------|----------|--------------|
| Day 1 | Discovery | 90-minute interview |
| Day 1-2 | Foundation | Tests, schema, backend generated |
| Week 1-2 | Build | Features with passing tests |
| Week 3-4 | Polish | Refinement, edge cases |
| Week 5 | Launch | MVP ready for users |

**Total: 5 weeks to MVP**

---

## Getting Started

Ready to try the discovery-first approach?

```bash
# Install Claude Code
npm install -g @anthropic-ai/claude-code
claude login

# Install Mavric
mkdir my-saas-project && cd my-saas-project
curl -fsSL https://raw.githubusercontent.com/mavric/devenv/main/install.sh | bash

# Start Claude Code
claude
```

Then run:

```
/start-project
```

The discovery interview will guide you through 90 minutes of structured requirements gathering. At the end, you'll have:

- Complete requirements document
- Gherkin test scenarios
- Multi-tenant database schema
- Product requirements document
- Running backend with authentication

All before writing a single line of custom code.

---

## Learn More

- [Discovery-First Development](discovery-first.md) - Deep dive into the 90-minute interview
- [The Development Workflow](workflow.md) - Phase-by-phase guide
- [Skills Reference](../skills/index.md) - All available skills
- [Quick Start](../getting-started/quickstart.md) - Get running in 5 minutes
