# /verify

Verify consistency across all project artifacts.

---

## Usage

```
/verify
```

---

## What It Does

The `/verify` command checks that all project artifacts are aligned and complete:

### 1. Discovery → Scenarios Alignment

- Every workflow has corresponding Gherkin scenarios
- All acceptance criteria are covered
- Edge cases from discovery are tested

### 2. Scenarios → Schema Alignment

- All entities in scenarios exist in schema
- All entity fields are defined
- Relationships match test expectations

### 3. Schema → API Alignment

- All schema entities have CRUD endpoints
- API responses match schema definitions
- Validation rules are implemented

### 4. Cross-Artifact Consistency

- Naming conventions are consistent
- No orphaned artifacts
- Version alignment across documents

---

## Verification Report

The command generates `docs/verification-report.md`:

```markdown
# Verification Report

## Summary
- Discovery Workflows: 12
- Gherkin Scenarios: 48
- Schema Entities: 8
- API Endpoints: 24

## Coverage Analysis

### Discovery → Scenarios
✅ Create Project: 6 scenarios
✅ Manage Tasks: 8 scenarios
⚠️ Team Invitations: 2 scenarios (missing edge cases)
❌ File Uploads: 0 scenarios (not covered)

## Recommended Actions
1. Add edge case scenarios for Team Invitations
2. Create scenarios for File Uploads workflow

## Confidence Score: 78/100
```

---

## Confidence Score

The score is calculated from:

| Category | Weight |
|----------|--------|
| Discovery Coverage | 20% |
| Scenario Coverage | 25% |
| Schema Alignment | 15% |
| Test Passing | 25% |
| Constitutional Compliance | 15% |

---

## What Gets Checked

| Artifact | Checks |
|----------|--------|
| Discovery | Completeness, workflow coverage |
| Scenarios | Coverage, structure, tags |
| Schema | Entity completeness, relationships |
| API | Endpoint coverage, validation |
| Tests | Passing status, coverage % |

---

## When to Use

Run `/verify`:

- Before major phase transitions
- After adding new features
- Before deployment
- During code review
- For QA checkpoints

---

## Prerequisites

Works best with:

- Discovery document (`docs/discovery/`)
- Gherkin scenarios (`docs/scenarios/`)
- Schema definition (`backend/.apsorc`)
- Backend code (`backend/src/`)

---

## Fixing Gaps

When verification finds issues:

1. **Missing scenarios** - Run `/tests` for uncovered workflows
2. **Missing entities** - Run `/schema` to update
3. **Failing tests** - Fix implementation or update scenarios
4. **Documentation gaps** - Update discovery or plans

---

## See Also

- [/tests](tests.md) - Generate missing scenarios
- [/schema](schema.md) - Update data model
- [Testing Standards](../standards/testing-standards.md) - Quality guidelines
