# Testing Quick Start Guide

> 5-minute guide to creating Gherkin tests for your features

---

## 🚀 Quick Setup (< 2 minutes)

```bash
# Install testing dependencies
npm install --save-dev @cucumber/cucumber @playwright/test axios chai

# Create feature directory structure
mkdir -p features/{api,ui,e2e}
mkdir -p tests/step-definitions

# Initialize Cucumber config
cat > cucumber.config.js << 'EOF'
module.exports = {
  default: {
    requireModule: ['ts-node/register'],
    require: ['tests/step-definitions/**/*.ts'],
    format: ['progress', 'html:reports/cucumber.html'],
    parallel: 2
  }
}
EOF

# Add test script to package.json
npm pkg set scripts.test="cucumber-js"
npm pkg set scripts.test:api="cucumber-js --tags @api"
npm pkg set scripts.test:ui="cucumber-js --tags @ui"
npm pkg set scripts.test:e2e="cucumber-js --tags @e2e"
```

---

## 📝 Feature File Template

Copy and customize this template for any new feature:

```gherkin
# features/[layer]/[module]/[feature].feature

Feature: [Feature Name]
  As a [user type]
  I want [goal/desire]
  So that [benefit/value]

  Background:
    Given [common setup for all scenarios]

  @smoke @[layer] @[feature-area]
  Scenario: [Happy path scenario name]
    Given [initial context]
    When [user action]
    Then [expected outcome]

  @[layer] @negative
  Scenario: [Error scenario name]
    Given [initial context]
    When [invalid action]
    Then [error handling]

  @[layer] @edge-case
  Scenario: [Edge case name]
    Given [boundary condition]
    When [action at boundary]
    Then [boundary behavior]
```

---

## 🎯 Common Scenario Patterns

### API Testing Pattern

```gherkin
@api @crud
Feature: [Entity] Management API

  Scenario: Create [entity] with valid data
    Given I have a valid [entity] payload
    When I send a POST request to "/api/[entities]"
    Then the response status should be 201
    And the response should contain the created [entity]

  Scenario: Get [entity] by ID
    Given an [entity] exists with ID "123"
    When I send a GET request to "/api/[entities]/123"
    Then the response status should be 200
    And the response should contain the [entity] details

  Scenario: Handle invalid [entity] creation
    Given I have an invalid [entity] payload
    When I send a POST request to "/api/[entities]"
    Then the response status should be 400
    And the response should contain validation errors
```

### UI Testing Pattern

```gherkin
@ui @forms
Feature: [Form Name] Submission

  Scenario: Submit form with valid data
    Given I am on the [page name] page
    When I fill in the form with valid data:
      | field    | value        |
      | Name     | John Doe     |
      | Email    | john@test.com|
    And I click "Submit"
    Then I should see "Success message"

  Scenario: Form validation prevents invalid submission
    Given I am on the [page name] page
    When I click "Submit" without filling the form
    Then I should see validation errors:
      | field | error              |
      | Name  | Name is required   |
      | Email | Email is required  |
```

### E2E Testing Pattern

```gherkin
@e2e @critical-path
Feature: [User Journey Name]

  Scenario: Complete [workflow name]
    Given I am a logged-in user
    When I navigate to "[start page]"
    And I perform "[action 1]"
    And I complete "[action 2]"
    Then I should see "[success indicator]"
    And the system should "[expected state change]"
```

---

## 🏃 Quick Commands Cheat Sheet

```bash
# Run all tests
npm test

# Run specific layer
npm test -- --tags "@api"
npm test -- --tags "@ui"
npm test -- --tags "@e2e"

# Run priority tests
npm test -- --tags "@smoke"        # Critical paths only
npm test -- --tags "@critical"     # High priority
npm test -- --tags "@regression"   # Full regression

# Run specific feature
npm test features/api/auth/login.feature

# Run with detailed output
npm test -- --format pretty

# Generate HTML report
npm test -- --format html:reports/test-report.html

# Run in parallel (faster)
npm test -- --parallel 4

# Dry run (validate without executing)
npm test -- --dry-run
```

---

## 📁 Step Definition Template

```typescript
// tests/step-definitions/[feature]-steps.ts
import { Given, When, Then, Before, After } from '@cucumber/cucumber';
import { expect } from 'chai';
import axios from 'axios';

// Test context
let response: any;
let context: any = {};

Before(function() {
  // Setup before each scenario
  context = {
    baseUrl: 'http://localhost:3001',
    headers: { 'Content-Type': 'application/json' }
  };
});

// Reusable step definitions
Given('I have a valid {string} payload', function(entity) {
  context.payload = {
    // Add valid test data
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
  } catch (error) {
    response = error.response;
  }
});

Then('the response status should be {int}', function(statusCode) {
  expect(response.status).to.equal(statusCode);
});

Then('the response should contain {string}', function(field) {
  expect(response.data).to.have.property(field);
});

After(function() {
  // Cleanup after each scenario
  response = null;
  context = {};
});
```

---

## ✅ Testing Checklist

### Before Writing Tests
- [ ] User story has clear acceptance criteria
- [ ] Feature file created in correct directory
- [ ] Scenarios cover: happy path, error case, edge case
- [ ] Tags applied (@layer, @priority, @feature)

### Writing Tests
- [ ] Feature description uses business language
- [ ] Scenarios are independent (no dependencies)
- [ ] Steps are reusable and parameterized
- [ ] Data tables used for complex inputs

### After Writing Tests
- [ ] Tests run successfully locally
- [ ] All scenarios have step definitions
- [ ] No pending/undefined steps
- [ ] Test report generated

---

## 🏷️ Tag Quick Reference

### Required Tags (Every Scenario)
- `@api` | `@ui` | `@e2e` - Layer
- `@smoke` | `@critical` | `@regression` - Priority

### Feature Tags
- `@auth` - Authentication
- `@crud` - CRUD operations
- `@payment` - Billing/payments
- `@workflow` - Multi-step processes

### Test Type Tags
- `@positive` - Happy path
- `@negative` - Error cases
- `@edge-case` - Boundaries
- `@performance` - Speed tests

---

## 📊 Coverage Targets by Phase

| Phase | Week | Min Scenarios | API | UI | E2E |
|-------|------|--------------|-----|----|----|
| MVP | 1-2 | 30 | 10 | 15 | 5 |
| Features | 3-6 | 60 | 20 | 30 | 10 |
| Polish | 7-9 | 40 | 12 | 20 | 8 |
| Launch | 10-12 | 30 | 8 | 12 | 10 |

---

## 🔧 Troubleshooting

### Common Issues

**"Step definition not found"**
```bash
# Check step definition path in cucumber.config.js
# Ensure TypeScript compilation:
npm install --save-dev ts-node @types/node
```

**"Cannot find module"**
```bash
# Install missing dependencies
npm install --save-dev @cucumber/cucumber @playwright/test
```

**"Tests timing out"**
```javascript
// Increase timeout in step definition
this.setDefaultTimeout(30 * 1000); // 30 seconds
```

**"Parallel execution failing"**
```javascript
// Reduce parallel count in cucumber.config.js
parallel: 1 // Run sequentially
```

---

## 📚 Learn More

- **Full methodology:** See `foundations/testing-methodology.md`
- **Standards & rules:** See `rules/testing-standards.mdc`
- **Roadmap integration:** See `foundations/roadmap-generator-prompt.md`
- **Lightbulb example:** See `/features/` directory in main project

---

**Last Updated:** 2025-01-13
**Version:** 1.0
**Time to First Test:** < 5 minutes