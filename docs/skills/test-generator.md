# Test Generator

Creates comprehensive BDD/Gherkin tests for features.

---

## Overview

| Attribute | Value |
|-----------|-------|
| **Name** | test-generator |
| **Type** | Quality skill |
| **Triggers** | "generate tests", "create scenarios", "add test coverage" |
| **Output** | Gherkin `.feature` files + step definitions |
| **Location** | `.claude/skills/test-generator/` |

---

## What It Creates

### 1. Gherkin Feature Files

Complete `.feature` files covering:
- Happy paths
- Error cases
- Edge cases
- Security tests

### 2. Step Definitions

TypeScript implementations:
- Reusable step definitions
- Test fixtures
- Mock data providers
- Assertion helpers

### 3. Test Configuration

- Cucumber configuration
- Playwright setup (for E2E)
- CI/CD integration

---

## Three Test Layers

### Layer 1: API Tests (40%)

**Purpose:** Verify endpoints, validation, business logic.

```gherkin
# features/api/sessions/crud.feature

@api @crud
Feature: Discovery Session API

  Background:
    Given the API server is running
    And I have a valid authentication token

  @smoke @create
  Scenario: Create session with valid data
    Given I have a discovery session payload:
      | field          | value              |
      | title          | Product Ideation   |
      | description    | Initial brainstorm |
    When I send a POST request to "/api/sessions"
    Then the response status should be 201
    And the response should contain:
      | field  | type   |
      | id     | string |
      | title  | string |
```

---

### Layer 2: UI Tests (45%)

**Purpose:** Verify rendering, interactions, state.

```gherkin
# features/ui/forms/session-form.feature

@ui @forms
Feature: Discovery Session Form

  @validation @positive
  Scenario: Submit valid session
    Given I am on the landing page
    When I fill in "Project Title" with "AI Platform"
    And I click "Start Discovery"
    Then I should see "Session created"
    And I should be redirected to "/sessions"

  @validation @negative
  Scenario: Display validation errors
    Given I am on the landing page
    When I click "Start Discovery"
    Then I should see "Title is required"
```

---

### Layer 3: E2E Tests (15%)

**Purpose:** Verify complete user journeys.

```gherkin
# features/e2e/discovery-flow.feature

@e2e @critical-path
Feature: Complete Discovery Flow

  @smoke
  Scenario: User creates and manages session
    Given I am a logged-in user
    When I navigate to the homepage
    And I submit a new project idea "E-commerce"
    Then I should see my idea in the list
    When I click on my session
    Then I should see session details
```

---

## Tag System

### Required Tags (Every Scenario)

| Tag | Purpose |
|-----|---------|
| `@api` / `@ui` / `@e2e` | Layer |
| `@smoke` / `@critical` / `@regression` | Priority |

### Feature Tags

| Tag | Purpose |
|-----|---------|
| `@auth` | Authentication |
| `@crud` | CRUD operations |
| `@payment` | Billing/payments |
| `@workflow` | Multi-step processes |

### Test Type Tags

| Tag | Purpose |
|-----|---------|
| `@positive` | Happy path |
| `@negative` | Error cases |
| `@edge-case` | Boundaries |
| `@security` | Security tests |

---

## Test Generation Process

### Step 1: Analyze Requirements

From discovery document:
- User stories
- Acceptance criteria
- Data model
- Edge cases

### Step 2: Identify Scenarios

For each feature:

| Type | Coverage |
|------|----------|
| Happy Path | Required |
| Error Cases | Required |
| Edge Cases | Should have |
| Security | Required for auth/payment |

### Step 3: Write Gherkin

Using proper structure:

```gherkin
Feature: [Feature Name]
  As a [user type]
  I want [action]
  So that [value]

  Background:
    Given [shared context]

  @tags
  Scenario: [Specific test case]
    Given [initial state]
    When [user action]
    Then [expected outcome]
```

### Step 4: Create Step Definitions

```typescript
// tests/step-definitions/session-steps.ts
import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from 'chai';

Given('I have a discovery session payload:', function(dataTable) {
  const data = dataTable.rowsHash();
  this.payload = {
    title: data.title,
    description: data.description
  };
});

When('I send a {string} request to {string}', async function(method, url) {
  this.response = await fetch(`${this.baseUrl}${url}`, {
    method,
    body: JSON.stringify(this.payload)
  });
});

Then('the response status should be {int}', function(status) {
  expect(this.response.status).to.equal(status);
});
```

---

## Coverage Expectations

| Feature Type | API | UI | E2E | Total |
|--------------|-----|-----|-----|-------|
| CRUD Entity | 8-10 | 5-7 | 2-3 | 15-20 |
| Authentication | 6-8 | 8-10 | 3-4 | 17-22 |
| Payment Flow | 5-6 | 6-8 | 4-5 | 15-19 |
| Search/Filter | 4-5 | 4-5 | 1-2 | 9-12 |

---

## Running Tests

```bash
# All tests
npm test

# By layer
npm test -- --tags "@api"
npm test -- --tags "@ui"
npm test -- --tags "@e2e"

# By priority
npm test -- --tags "@smoke"
npm test -- --tags "@critical"

# Generate report
npm test -- --format html:reports/test-report.html
```

---

## Traceability Matrix

Link tests to requirements:

```markdown
## Feature: Session Management

### Task: TASK-123 - Implement session CRUD

**Acceptance Criteria:**
- AC-1: Users can create sessions
- AC-2: System validates required fields

**Test Coverage:**
- `features/api/sessions/crud.feature`
  - ✅ Create session with valid data (AC-1)
  - ✅ Reject missing required fields (AC-2)
- `features/ui/forms/session-form.feature`
  - ✅ Submit valid form (AC-1)
  - ✅ Show validation errors (AC-2)

**Coverage:** 100%
```

---

## Invocation

### Via Orchestrator

Automatically called as Phase 1 of `/start-project`.

### Via Natural Language

```
"Generate tests for the user registration feature"
"Create Gherkin scenarios from the discovery"
"Add test coverage for the payment flow"
```

---

## Related

- [Discovery Interviewer](discovery-interviewer.md) (input source)
- [Feature Builder](feature-builder.md) (validates against tests)
