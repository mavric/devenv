# /init

Initialize a new Mavric project with standard structure.

---

## Usage

```
/init
```

Or with a project name:

```
/init my-saas-project
```

---

## What It Does

The `/init` command creates the standard Mavric project structure:

```
[project-name]/
├── .claude/
│   └── constitution.md         # Project principles
├── docs/
│   ├── discovery/              # Requirements documents
│   ├── scenarios/              # Gherkin test scenarios
│   │   ├── api/
│   │   ├── ui/
│   │   └── e2e/
│   ├── plans/                  # Technical plans
│   └── .gitkeep
├── backend/                    # Apso backend (created later)
├── frontend/                   # Next.js frontend (created later)
├── tests/
│   ├── step-definitions/       # Cucumber implementations
│   └── fixtures/               # Test data
├── .gitignore
└── README.md
```

---

## Files Created

### Constitution

The `constitution.md` file establishes immutable project principles:

- **Article I:** Discovery-First Principle
- **Article II:** Test-First Imperative
- **Article III:** Multi-Tenancy by Default
- **Article IV:** Type Safety Mandate
- **Article V:** Security by Default
- **Article VI:** Simplicity Principle
- **Article VII:** Documentation as Code
- **Article VIII:** Progressive Delivery
- **Article IX:** Integration-First Testing

### Git Repository

If the directory isn't already a git repository:

1. Initializes git
2. Creates initial commit with structure
3. Sets `main` as default branch

---

## When to Use

Use `/init` when you want to:

- Set up project structure before full discovery
- Prepare a skeleton for team collaboration
- Establish project principles early
- Create consistent directory layout

---

## vs /start-project

| Aspect | `/init` | `/start-project` |
|--------|---------|------------------|
| Scope | Structure only | Full SDLC |
| Time | < 1 minute | 90+ minutes |
| Discovery | No | Yes |
| Code generation | No | Yes |
| Best for | Quick setup | New projects |

---

## After Init

Recommended next steps:

1. **Review constitution** - Customize project principles
2. **Run `/start-project`** - Begin full discovery
3. **Or use individual commands:**
   - `/discovery-only` - Just the interview
   - `/schema` - Design data model
   - `/tests` - Generate test scenarios

---

## See Also

- [/start-project](start-project.md) - Full project orchestration
- [Project Structure](../concepts/project-structure.md) - Directory layout
