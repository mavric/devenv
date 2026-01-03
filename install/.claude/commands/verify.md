---
description: Verify consistency across all project artifacts
---

# Artifact Verification

You've invoked the `/verify` command to check consistency across your project artifacts.

## What Happens Next

I'll analyze all your project artifacts and verify they're aligned and complete.

### What This Command Checks

#### 1. Discovery → Scenarios Alignment
- Every workflow in discovery has corresponding Gherkin scenarios
- All acceptance criteria are covered by test scenarios
- Edge cases from discovery are tested

#### 2. Scenarios → Schema Alignment
- All entities referenced in scenarios exist in schema
- All entity fields used in tests are defined
- Relationships match test expectations

#### 3. Schema → API Alignment
- All schema entities have CRUD endpoints
- API responses match schema definitions
- Validation rules are implemented

#### 4. Cross-Artifact Consistency
- Naming conventions are consistent
- No orphaned artifacts (tests without features, etc.)
- Version alignment across documents

### Verification Report

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

### Scenarios → Schema
✅ Project entity: All fields covered
✅ Task entity: All fields covered
⚠️ Comment entity: Missing "edited_at" field in tests

### Schema → API
✅ All CRUD endpoints implemented
✅ Validation rules match schema
⚠️ Missing pagination on /tasks endpoint

## Recommended Actions
1. Add edge case scenarios for Team Invitations
2. Create scenarios for File Uploads workflow
3. Add "edited_at" field tests for Comments
4. Implement pagination on /tasks endpoint

## Confidence Score: 78/100
```

## What Gets Verified

| Artifact | Checks |
|----------|--------|
| Discovery | Completeness, workflow coverage |
| Scenarios | Coverage, structure, tags |
| Schema | Entity completeness, relationships |
| API | Endpoint coverage, validation |
| Frontend | Component coverage, routes |
| Tests | Passing status, coverage % |

## Prerequisites

This command works best when you have:
- Discovery document (`docs/discovery/`)
- Gherkin scenarios (`docs/scenarios/`)
- Schema definition (`backend/.apsorc`)
- Backend code (`backend/src/`)

## Output

You'll get:
- `docs/verification-report.md` - Detailed verification report
- List of gaps and recommended actions
- Confidence score for project readiness

## Ready?

**Say "verify" to run the full artifact consistency check.**
