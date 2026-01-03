---
name: test-generator
description: Generates comprehensive BDD/Gherkin tests for features. Triggers when user needs to write tests, create test scenarios, add test coverage, or verify feature completeness.
---

# Test Generator

I create comprehensive, behavior-driven tests using Gherkin syntax that validate features across API, UI, and E2E layers.

## What I Create

### 1. Gherkin Feature Files
Complete `.feature` files with scenarios covering:
- **Happy paths** - Successful user workflows
- **Error cases** - Validation and error handling
- **Edge cases** - Boundary conditions
- **Security** - Authorization and authentication

### 2. Step Definitions
TypeScript/JavaScript implementations:
- Reusable step definitions
- Test fixtures and factories
- Mock data providers
- Assertion helpers

### 3. Test Configuration
Complete testing infrastructure:
- Cucumber configuration
- Playwright setup (for UI/E2E)
- Test utilities and helpers
- CI/CD integration

### 4. Traceability Documentation
Links tests to requirements:
- Task → Test mapping
- Coverage matrix
- Acceptance criteria validation
- Test execution reports

## Testing Philosophy

**"Testing is not optional—it's how we validate delivery."**

Every feature must be:
1. **Specified** in Gherkin scenarios (what success looks like)
2. **Implemented** according to specifications
3. **Verified** through automated tests
4. **Traceable** from task to test to code

## Test Structure: Three Layers

### Layer 1: API Tests (Backend)

**Purpose:** Verify endpoints, data validation, business logic

```gherkin
# features/api/[entity]/crud.feature

@api @crud
Feature: Discovery Session API

  Background:
    Given the API server is running
    And I have a valid authentication token

  @smoke @create
  Scenario: Create session with valid data
    Given I have a discovery session payload:
      | field          | value                    |
      | title          | Product Ideation         |
      | description    | Initial brainstorm       |
      | organizationId | 1                        |
    When I send a POST request to "/api/discovery-sessions"
    Then the response status should be 201
    And the response should contain:
      | field  | type   |
      | id     | string |
      | title  | string |
      | status | string |

  @negative @validation
  Scenario: Reject session with missing required fields
    Given I have an incomplete payload missing "title"
    When I send a POST request to "/api/discovery-sessions"
    Then the response status should be 400
    And the response should contain validation errors
    And the error should mention "title is required"

  @edge-case
  Scenario: Handle extremely long title
    Given I have a session with title exceeding 500 characters
    When I send a POST request to "/api/discovery-sessions"
    Then the response status should be 400
    And the error should mention "title too long"
```

### Layer 2: UI Tests (Frontend Components)

**Purpose:** Verify rendering, interactions, state management

```gherkin
# features/ui/forms/session-form.feature

@ui @forms
Feature: Discovery Session Form

  @validation @positive
  Scenario: Submit valid discovery session
    Given I am on the landing page
    When I fill in "Project Title" with "AI Analytics Platform"
    And I fill in "Description" with "Next-gen analytics"
    And I click "Start Discovery Process"
    Then I should see "Session created successfully"
    And I should be redirected to "/sessions"

  @validation @negative
  Scenario: Display validation errors for empty form
    Given I am on the landing page
    When I click "Start Discovery Process"
    Then I should see "Title is required"
    And I should see "Description is required"
    And the form should not be submitted

  @edge-case
  Scenario: Preserve form data on validation failure
    Given I am on the landing page
    When I fill in "Project Title" with "Test"
    And I submit with an empty description
    Then I should see "Description is required"
    But "Project Title" should still contain "Test"
```

### Layer 3: E2E Tests (Complete Workflows)

**Purpose:** Verify end-to-end user journeys

```gherkin
# features/e2e/discovery-flow.feature

@e2e @critical-path
Feature: Complete Discovery Flow

  @smoke
  Scenario: User creates and manages discovery session
    Given I am a logged-in user
    When I navigate to the homepage
    And I submit a new project idea "E-commerce Platform"
    Then I should see my idea in the sessions list
    When I click on my session
    Then I should see the session details
    And I should be able to update the status to "in_progress"
    When I add AI chat messages to the session
    Then the messages should appear in the chat history
    And the session should show "updated" timestamp

  @workflow
  Scenario: Complete discovery to proposal workflow
    Given I have an active discovery session
    When I complete the AI chat conversation
    And I click "Generate Proposal"
    Then a proposal should be created
    And I should see the proposal linked to the session
    And the session status should be "completed"
```

## Test Generation Process

### Step 1: Analyze Feature Requirements

I start by understanding:
- **User story** - What's the business value?
- **Acceptance criteria** - What defines success?
- **Data model** - What entities are involved?
- **User flows** - What are the steps?
- **Edge cases** - What could go wrong?

### Step 2: Identify Test Scenarios

For each feature, I identify:

**Happy Path** (Must have)
- Normal, successful user flow
- All required fields provided
- Expected outcomes achieved

**Error Cases** (Must have)
- Missing required fields
- Invalid data formats
- Authorization failures
- Network/system errors

**Edge Cases** (Should have)
- Boundary values (min/max)
- Null/undefined handling
- Concurrent operations
- Large data sets

**Security** (Must have for auth/payment)
- Unauthorized access attempts
- SQL injection attempts
- XSS prevention
- CSRF protection

### Step 3: Write Gherkin Scenarios

Using proper structure:

```gherkin
Feature: [Feature Name]
  As a [user type]
  I want [action/capability]
  So that [business value]

  Background:
    Given [shared context for all scenarios]

  @layer @priority @feature
  Scenario: [Specific test case]
    Given [initial state]
    When [user action]
    Then [expected outcome]
    And [additional validations]
```

### Step 4: Apply Tags Consistently

**Required tags** (every scenario):
- **Layer:** `@api` | `@ui` | `@e2e`
- **Priority:** `@smoke` | `@critical` | `@regression`

**Feature tags:**
- `@auth` - Authentication
- `@crud` - CRUD operations
- `@payment` - Billing/payments
- `@workflow` - Multi-step processes

**Test type tags:**
- `@positive` - Happy path
- `@negative` - Error cases
- `@edge-case` - Boundaries
- `@security` - Security tests

### Step 5: Create Step Definitions

```typescript
// tests/step-definitions/session-steps.ts
import { Given, When, Then, Before, After } from '@cucumber/cucumber';
import { expect } from 'chai';
import axios from 'axios';

let response: any;
let context: any = {};

Before(function() {
  context = {
    baseUrl: 'http://localhost:3001',
    headers: { 'Content-Type': 'application/json' }
  };
});

Given('I have a discovery session payload:', function(dataTable) {
  const data = dataTable.rowsHash();
  context.payload = {
    title: data.title,
    description: data.description,
    organizationId: parseInt(data.organizationId)
  };
});

When('I send a {string} request to {string}', async function(method, endpoint) {
  try {
    response = await axios({
      method: method.toLowerCase(),
      url: `${context.baseUrl}${endpoint}`,
      data: context.payload,
      headers: context.headers
    });
  } catch (error: any) {
    response = error.response;
  }
});

Then('the response status should be {int}', function(statusCode) {
  expect(response.status).to.equal(statusCode);
});

Then('the response should contain:', function(dataTable) {
  const fields = dataTable.hashes();
  fields.forEach(({ field, type }) => {
    expect(response.data).to.have.property(field);
    expect(typeof response.data[field]).to.equal(type);
  });
});

After(function() {
  response = null;
  context = {};
});
```

### Step 6: Setup Test Infrastructure

**Cucumber Configuration:**
```javascript
// cucumber.config.js
module.exports = {
  default: {
    requireModule: ['ts-node/register'],
    require: ['tests/step-definitions/**/*.ts'],
    format: [
      'progress',
      'html:reports/cucumber.html',
      'json:reports/cucumber.json'
    ],
    parallel: 2,
    retry: 1
  }
}
```

**Package.json Scripts:**
```json
{
  "scripts": {
    "test": "cucumber-js",
    "test:api": "cucumber-js --tags '@api'",
    "test:ui": "cucumber-js --tags '@ui'",
    "test:e2e": "cucumber-js --tags '@e2e'",
    "test:smoke": "cucumber-js --tags '@smoke'",
    "test:coverage": "cucumber-js --format json:reports/coverage.json"
  }
}
```

## Coverage Expectations

### Minimum Scenario Counts by Feature Type

| Feature Type | API Tests | UI Tests | E2E Tests | Total Min |
|--------------|-----------|----------|-----------|-----------|
| CRUD Entity | 8-10 | 5-7 | 2-3 | 15-20 |
| Authentication | 6-8 | 8-10 | 3-4 | 17-22 |
| Payment Flow | 5-6 | 6-8 | 4-5 | 15-19 |
| Search/Filter | 4-5 | 4-5 | 1-2 | 9-12 |
| File Upload | 3-4 | 3-4 | 2-3 | 8-11 |

### Coverage by Phase

**Phase 1: Foundation (Weeks 1-2)**
- API: 18+ scenarios (CRUD operations)
- UI: 10+ scenarios (basic rendering)
- E2E: 5+ scenarios (smoke tests)

**Phase 2: Features (Weeks 3-6)**
- API: 30+ scenarios (business logic)
- UI: 25+ scenarios (interactions)
- E2E: 10+ scenarios (workflows)

**Phase 3: Polish (Weeks 7-9)**
- API: 15+ scenarios (edge cases)
- UI: 20+ scenarios (validations)
- E2E: 8+ scenarios (error recovery)

## Test Execution

### Running Tests Locally

```bash
# Run all tests
npm test

# Run specific layer
npm test -- --tags "@api"
npm test -- --tags "@ui"
npm test -- --tags "@e2e"

# Run by priority
npm test -- --tags "@smoke"      # Critical paths only
npm test -- --tags "@critical"   # High priority
npm test -- --tags "@regression" # Full suite

# Run specific feature
npm test features/api/auth/login.feature

# Parallel execution
npm test -- --parallel 4

# With detailed output
npm test -- --format pretty

# Generate HTML report
npm test -- --format html:reports/test-report.html
```

### CI/CD Integration

```yaml
# .github/workflows/test.yml
name: Test Suite

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install dependencies
        run: npm install

      - name: Run smoke tests
        run: npm test -- --tags "@smoke"

      - name: Run API tests
        run: npm test -- --tags "@api"

      - name: Run UI tests
        run: npm test -- --tags "@ui"

      - name: Run E2E tests
        run: npm test -- --tags "@e2e"

      - name: Upload test reports
        uses: actions/upload-artifact@v3
        with:
          name: test-reports
          path: reports/
```

## Traceability Matrix

### Task → Test Mapping

```markdown
## Feature: Discovery Session Management

### Task: TASK-123 - Implement session CRUD

**Acceptance Criteria:**
- AC-1: Users can create sessions with title and description
- AC-2: System validates required fields
- AC-3: Sessions are scoped to organizations

**Test Coverage:**
- `features/api/sessions/crud.feature`
  - ✅ Create session with valid data (AC-1)
  - ✅ Reject missing required fields (AC-2)
  - ✅ Verify organization isolation (AC-3)
- `features/ui/forms/session-form.feature`
  - ✅ Submit valid form (AC-1)
  - ✅ Show validation errors (AC-2)
- `features/e2e/discovery-flow.feature`
  - ✅ Complete creation workflow (AC-1, AC-3)

**Coverage:** 8 scenarios across 3 layers = 100%
```

## Common Test Patterns

### Pattern 1: CRUD Operations

```gherkin
@api @crud
Feature: [Entity] Management

  Scenario: Create [entity]
  Scenario: Get [entity] by ID
  Scenario: Update [entity]
  Scenario: Delete [entity]
  Scenario: List [entities] with pagination
  Scenario: Filter [entities] by field
  Scenario: Handle duplicate creation
  Scenario: Validate required fields
```

### Pattern 2: Form Validation

```gherkin
@ui @forms @validation
Feature: [Form Name]

  Scenario: Submit with valid data
  Scenario: Display errors for missing fields
  Scenario: Display errors for invalid formats
  Scenario: Preserve data on validation failure
  Scenario: Clear form after successful submission
  Scenario: Handle server errors gracefully
```

### Pattern 3: Authentication Flow

```gherkin
@api @auth
Feature: User Authentication

  Scenario: Successful login
  Scenario: Failed login with wrong password
  Scenario: Account lockout after failed attempts
  Scenario: Session expiration
  Scenario: Logout
  Scenario: Refresh token
```

## Quality Checklist

Before marking tests complete:

### Structure
- [ ] Feature has clear business value description
- [ ] Each scenario is independent (no dependencies)
- [ ] Background used appropriately (shared context only)
- [ ] No more than 10-15 scenarios per feature file

### Naming
- [ ] Feature name describes user capability
- [ ] Scenario names are specific and descriptive
- [ ] Steps use business language, not technical details

### Tags
- [ ] Every scenario has required tags (@layer, @priority)
- [ ] Tags are consistent with project taxonomy
- [ ] No duplicate or conflicting tags

### Content
- [ ] Given-When-Then structure followed
- [ ] Steps are reusable (parameterized where appropriate)
- [ ] No implementation details in scenarios
- [ ] Data tables used for complex inputs

### Traceability
- [ ] Links to task/user story included
- [ ] Acceptance criteria mapped
- [ ] Coverage documented

### Execution
- [ ] All tests pass locally
- [ ] No skipped tests without justification
- [ ] Coverage thresholds met (>80%)
- [ ] CI pipeline passing

## When to Use Me

✅ **Use me when:**
- Starting a new feature (test-first development)
- Adding test coverage to existing feature
- Validating acceptance criteria
- Creating regression test suite
- Setting up testing infrastructure

✅ **I'm especially useful for:**
- Features with complex business logic
- Multi-step workflows
- Critical user paths (auth, payment, etc.)
- API contract testing
- Form validation scenarios

## References

I use these methodologies from your project:
- `references/testing-methodology.md` - Complete BDD approach
- `references/TESTING_QUICK_START.md` - Quick setup patterns

## Ready?

Tell me what feature needs tests, and I'll generate:
1. Complete Gherkin feature files (API + UI + E2E)
2. Step definitions with implementations
3. Test configuration
4. Traceability documentation
5. CI/CD integration

**What feature should we test?**
