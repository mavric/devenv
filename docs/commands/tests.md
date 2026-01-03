# /tests

Generate BDD/Gherkin test scenarios for your features.

---

## Usage

```
/tests
```

Or for specific features:

```
/tests

Generate tests for user authentication:
- Login with email/password
- Registration with email verification
- Password reset flow
```

---

## What It Does

The `/tests` command invokes the **test-generator** skill to:

1. **Analyze Requirements**
   - Reviews discovery document workflows
   - Reviews existing feature files
   - Identifies test scenarios needed

2. **Generate Three Test Layers**
   - **API Tests (40%)** - Backend endpoints, validation
   - **UI Tests (45%)** - Frontend components, forms
   - **E2E Tests (15%)** - Complete user journeys

3. **Create Artifacts**
   - `docs/scenarios/api/*.feature` - API tests
   - `docs/scenarios/ui/*.feature` - UI tests
   - `docs/scenarios/e2e/*.feature` - E2E tests
   - `tests/step-definitions/` - TypeScript implementations
   - `docs/traceability-matrix.md` - Coverage mapping

---

## Output Example

```gherkin
@api @auth @smoke
Feature: User Authentication

  Background:
    Given the API server is running

  Scenario: Successful login with valid credentials
    Given I have a registered user "user@example.com"
    When I POST to "/api/auth/signin" with:
      | email    | user@example.com |
      | password | SecurePass123!   |
    Then the response status should be 200
    And the response should contain a valid session token

  @negative
  Scenario: Reject login with invalid password
    Given I have a registered user "user@example.com"
    When I POST to "/api/auth/signin" with wrong password
    Then the response status should be 401
    And the response should contain "Invalid credentials"
```

---

## Test Coverage Targets

| Feature Type | API | UI | E2E | Total |
|--------------|-----|-----|-----|-------|
| CRUD Entity | 8-10 | 5-7 | 2-3 | 15-20 |
| Auth Flow | 6-8 | 8-10 | 3-4 | 17-22 |
| Payment | 5-6 | 6-8 | 4-5 | 15-19 |

---

## Scenario Types

| Type | Tag | Purpose |
|------|-----|---------|
| Happy Path | `@positive` | Successful flows |
| Validation | `@negative` | Error handling |
| Edge Cases | `@edge-case` | Boundaries |
| Security | `@security` | Authorization |

---

## Prerequisites

For best results, have:

- Discovery document (`docs/discovery/`)
- OR clear feature descriptions

---

## Running Tests

After generation:

```bash
# Run all tests
npm test

# Run by layer
npm test -- --tags "@api"
npm test -- --tags "@ui"
npm test -- --tags "@e2e"

# Run smoke tests
npm test -- --tags "@smoke"
```

---

## See Also

- [Test Generator](../skills/test-generator.md) - Full skill reference
- [Testing Standards](../standards/testing-standards.md) - Quality guidelines
