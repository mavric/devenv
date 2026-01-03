---
description: Generate BDD/Gherkin test scenarios for your features
---

# Test Generation

You've invoked the `/tests` command to generate Gherkin test scenarios.

## What Happens Next

I'll invoke the **test-generator** skill to create comprehensive BDD tests.

### What Test Generator Does

1. **Analyzes Requirements**
   - Reviews discovery document workflows
   - Reviews existing feature files
   - Identifies test scenarios needed

2. **Generates Three Test Layers**
   - **API Tests (40%)** - Backend endpoints, validation, business logic
   - **UI Tests (45%)** - Frontend components, forms, interactions
   - **E2E Tests (15%)** - Complete user journeys

3. **Creates Artifacts**
   - `docs/scenarios/api/*.feature` - API test scenarios
   - `docs/scenarios/ui/*.feature` - UI test scenarios
   - `docs/scenarios/e2e/*.feature` - E2E test scenarios
   - `tests/step-definitions/` - TypeScript implementations
   - `docs/traceability-matrix.md` - Test coverage mapping

## Prerequisites

For best results, you should have:
- Discovery document with workflows (`docs/discovery/`)
- OR clear feature descriptions

## Usage Examples

**From discovery document:**
```
/tests
```
I'll generate scenarios for all workflows in your discovery document.

**For specific feature:**
```
/tests

Generate tests for user authentication:
- Login with email/password
- Registration with email verification
- Password reset flow
- Session management
```

**To add coverage:**
```
/tests

Add edge case tests for the Project CRUD feature
```

## Test Coverage Targets

| Feature Type | API | UI | E2E | Total |
|--------------|-----|-----|-----|-------|
| CRUD Entity | 8-10 | 5-7 | 2-3 | 15-20 |
| Auth Flow | 6-8 | 8-10 | 3-4 | 17-22 |
| Payment | 5-6 | 6-8 | 4-5 | 15-19 |

## Output

You'll get:
- Complete `.feature` files with Gherkin scenarios
- Step definitions ready to implement
- Traceability matrix linking tests to requirements

## Ready?

**Describe the feature to test, or say "generate from discovery" to use existing workflows.**
