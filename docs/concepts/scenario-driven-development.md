# Scenario-Driven Development

Understanding DevEnv's methodology in the context of the 2025 AI-assisted development landscape.

---

## The 2025 Landscape

AI-assisted software development has evolved rapidly. The industry now recognizes a spectrum from unstructured "vibe coding" to disciplined "spec-driven development":

```
Vibe Coding ←─────────────────────────────────────────→ Spec-Driven Development
    │                                                           │
"Just prompt it"                                    "Specification is the artifact"
    │                                                           │
    └── Fast prototypes                             Structured requirements ──┘
        Technical debt                              Phase gates
        No documentation                            Living documentation
```

DevEnv occupies a specific position in this landscape: **Scenario-Driven Development with Opinionated Architecture**.

---

## What is Scenario-Driven Development?

Scenario-Driven Development (SDD) is DevEnv's methodology that combines:

1. **Discovery-First Requirements** - Structured interviews extract requirements you didn't know you had
2. **Gherkin Scenarios as the Central Artifact** - Executable specifications that serve triple duty
3. **Opinionated Architectural Guardrails** - Pre-defined standards constrain AI execution

```
                    ┌─────────────────────────────────┐
                    │  .devenv/standards/             │
                    │  (Architectural Guardrails)     │
                    └───────────────┬─────────────────┘
                                    │ constrains HOW
                                    ▼
Human Intent → Discovery → Gherkin Scenarios → Schema → Implementation → Validation
                              │
                              │ defines WHAT
                              ▼
                    ┌─────────────────────────────────┐
                    │  specs/scenarios/               │
                    │  (Single Source of Truth)       │
                    └─────────────────────────────────┘
```

### Two Layers of Control

| Layer | Controls | Examples |
|-------|----------|----------|
| **Scenarios** | What gets built (behavior) | Feature acceptance criteria, edge cases, error handling |
| **Standards** | How it gets built (architecture) | Tech stack, multi-tenancy patterns, API conventions |

---

## How DevEnv Differs from Alternatives

### vs. Vibe Coding

"Vibe coding" was coined by OpenAI's Andrej Karpathy in early 2025. It describes the practice of prompting AI iteratively without formal specifications—useful for prototypes but problematic for production systems.

| Aspect | Vibe Coding | DevEnv |
|--------|-------------|--------|
| **Input** | Ad-hoc prompts | 90-minute discovery interview |
| **Artifact** | Chat history | Gherkin scenarios |
| **Testing** | Optional, after the fact | Required, before code |
| **Architecture** | Whatever AI generates | Constrained by standards |
| **Documentation** | None | Living scenarios + PRD |

**When vibe coding works:** Quick prototypes, throwaway experiments, personal projects.

**When DevEnv works:** Production systems, team projects, anything that needs maintenance.

### vs. GitHub Spec Kit

[GitHub Spec Kit](https://github.com/github/spec-kit) shares DevEnv's belief in specifications before code. Both use phase gates and AI assistants. The differences are in the details:

| Aspect | GitHub Spec Kit | DevEnv |
|--------|-----------------|--------|
| **Discovery** | You describe the feature | AI interviews you for 90 minutes |
| **Specification format** | Markdown PRDs | Executable Gherkin scenarios |
| **Test integration** | Separate concern | Scenarios ARE the tests |
| **Domain focus** | General-purpose | SaaS-specific (multi-tenancy, auth, billing) |
| **Architecture** | You decide | Opinionated standards provided |

**GitHub Spec Kit's strength:** Flexibility, works for any software type.

**DevEnv's strength:** Discovery process uncovers requirements; executable specs prevent ambiguity.

### vs. Ralph (Autonomous Development)

[Ralph](https://github.com/frankbria/ralph-claude-code) is an autonomous development loop that runs Claude Code continuously until completion. It's excellent at execution but assumes you already have specifications.

| Aspect | Ralph | DevEnv |
|--------|-------|--------|
| **Focus** | Autonomous execution | Requirements + execution |
| **Input** | PROMPT.md, @fix_plan.md | "I want to build a SaaS for X" |
| **Discovery** | None (imports PRD) | 90-minute structured interview |
| **Artifacts** | Task lists with VERIFY items | Gherkin scenarios |
| **Execution** | Autonomous loop | Human-in-the-loop with gates |

**Ralph's strength:** Autonomous execution with intelligent exit detection.

**DevEnv's strength:** Discovery and specification before execution.

**They work together:** DevEnv's `/ralph-export` command converts scenarios to Ralph's format for autonomous execution.

### vs. Raw BDD Tools (Cucumber, SpecFlow)

Traditional BDD tools like Cucumber focus on test execution. DevEnv uses Gherkin for a broader purpose.

| Aspect | Traditional BDD | DevEnv |
|--------|-----------------|--------|
| **Who writes scenarios** | QA/developers | AI from discovery |
| **When scenarios are written** | After requirements | AS requirements |
| **Purpose** | Test automation | Requirements + tests + docs |
| **AI integration** | Limited | Native |

**Traditional BDD's strength:** Mature tooling, team familiarity.

**DevEnv's strength:** AI generates comprehensive scenarios from discovery, not manually written.

---

## The Triple-Duty Gherkin Principle

In DevEnv, Gherkin scenarios serve three purposes simultaneously:

### 1. Requirements Specification

```gherkin
Feature: Team Invitations

  Scenario: Admin invites new team member
    Given I am an admin of organization "Acme Corp"
    When I invite "newuser@example.com" to the team
    Then an invitation email should be sent
    And the invitation should expire in 7 days
```

This scenario documents:
- Who can invite (admins)
- What happens (email sent)
- Business rules (7-day expiration)

### 2. Acceptance Tests

The same scenario becomes an automated test:

```javascript
Given('I am an admin of organization {string}', async (orgName) => {
  await loginAsAdmin(orgName);
});

When('I invite {string} to the team', async (email) => {
  await invitePage.sendInvitation(email);
});

Then('an invitation email should be sent', async () => {
  expect(await emailService.lastSentTo()).toBeTruthy();
});
```

### 3. Living Documentation

Scenarios serve as always-current documentation because:
- They're verified by tests (if tests pass, docs are accurate)
- They're written in plain language (stakeholders can read them)
- They cover edge cases (not just happy paths)

---

## The Guardrails Advantage

A core problem with AI-assisted development is **architectural inconsistency**. Without constraints:

- One feature uses JWT, another uses sessions
- One API returns `{ data: ... }`, another returns raw objects
- One component uses React Query, another uses fetch directly

DevEnv solves this with **opinionated standards** in `.devenv/standards/`:

```
.devenv/standards/
├── apso/                 # Backend schema patterns
├── saas/                 # Multi-tenancy, billing, auth patterns
└── foundations/          # Testing methodology, code structure
```

These standards:

1. **Constrain AI behavior** - Claude Code follows the standards, not arbitrary patterns
2. **Encode proven patterns** - Multi-tenancy, authentication, billing done right
3. **Reduce decision fatigue** - Tech stack already chosen, patterns already defined
4. **Enable team consistency** - Everyone gets the same architecture

### Example: Multi-Tenancy

Without guardrails, you might ask for "user management" and get:

```javascript
// AI-generated: No multi-tenancy
const users = await db.query('SELECT * FROM users');
```

With DevEnv standards, you get:

```javascript
// DevEnv: Multi-tenancy built in
const users = await db.query(
  'SELECT * FROM users WHERE organization_id = $1',
  [context.organizationId]
);
```

The standards document that **every query must be scoped to organization**. The AI follows this constraint.

---

## The Complete Picture

DevEnv combines four elements that other tools provide separately:

| Element | Vibe Coding | Spec Kit | Ralph | BDD Tools | DevEnv |
|---------|-------------|----------|-------|-----------|--------|
| Discovery process | - | - | - | - | Yes |
| Specification format | - | Markdown | Task lists | Gherkin | Gherkin |
| Architectural guardrails | - | Constitution | - | - | Standards |
| Autonomous execution | - | Via agents | Yes | - | Via Ralph |
| Executable tests | - | - | VERIFY items | Yes | Yes |
| SaaS patterns | - | - | - | - | Yes |

---

## When to Use What

### Use Vibe Coding When:
- Building a quick prototype
- Experimenting with ideas
- Personal projects with no maintenance needs

### Use GitHub Spec Kit When:
- Building general-purpose software (not SaaS)
- Requirements are already well-understood
- You want flexibility in architecture choices
- Your team prefers Markdown specifications

### Use Ralph When:
- You already have comprehensive specifications
- You want autonomous execution overnight
- You need to batch large implementation tasks

### Use DevEnv When:
- Building a SaaS product from scratch
- Requirements are unclear or need extraction
- You want executable specifications (Gherkin)
- You need multi-tenancy from day one
- You want opinionated architecture that "just works"

### Use DevEnv + Ralph Together When:
- You want discovery-first requirements
- Then autonomous execution of the implementation
- Run `/ralph-export` to bridge the two

---

## The Workflow

```
┌────────────────────────────────────────────────────────────────┐
│                                                                 │
│   1. DISCOVERY                                                  │
│      "Tell me about your SaaS idea..."                         │
│      ↓                                                          │
│      90-minute structured interview                             │
│      ↓                                                          │
│      Requirements document                                      │
│                                                                 │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│   2. SCENARIOS                                                  │
│      AI generates Gherkin from requirements                     │
│      ↓                                                          │
│      40-60 scenarios covering all workflows                     │
│      ↓                                                          │
│      Human approval gate                                        │
│                                                                 │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│   3. SCHEMA                                                     │
│      Extract entities from scenarios                            │
│      ↓                                                          │
│      Design multi-tenant data model                             │
│      ↓                                                          │
│      Human approval gate                                        │
│                                                                 │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│   4. IMPLEMENTATION                                             │
│      Constrained by .devenv/standards/                          │
│      ↓                                                          │
│      Build features to pass scenarios                           │
│      ↓                                                          │
│      Or: /ralph-export for autonomous execution                 │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## Learn More

- [Why Mavric?](why-mavric.md) - Detailed comparison with boilerplates and generators
- [Discovery-First Development](discovery-first.md) - The 90-minute interview process
- [The Development Workflow](workflow.md) - Phase-by-phase implementation guide
- [/ralph-export Command](../commands/ralph-export.md) - Bridge to autonomous development

---

## References

- [GitHub Spec Kit](https://github.com/github/spec-kit) - Spec-driven development toolkit
- [Ralph Claude Code](https://github.com/frankbria/ralph-claude-code) - Autonomous development loop
- [Thoughtworks: Spec-Driven Development](https://www.thoughtworks.com/en-us/insights/blog/agile-engineering-practices/spec-driven-development-unpacking-2025-new-engineering-practices) - Industry analysis
- [MIT Technology Review: From Vibe Coding to Context Engineering](https://www.technologyreview.com/2025/11/05/1127477/from-vibe-coding-to-context-engineering-2025-in-software-development/) - 2025 landscape overview
