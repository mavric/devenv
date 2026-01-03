# Testing Standards

Testing requirements and practices.

---

## Testing Philosophy

> "Tests are not optional—they're how we validate delivery."

Every feature must be:
1. **Specified** in Gherkin scenarios
2. **Implemented** according to specs
3. **Verified** through automated tests
4. **Traceable** from task to test to code

---

## Three-Layer Testing

### Layer 1: API Tests (40%)

Test backend endpoints, validation, business logic.

```gherkin
@api @crud
Feature: Project API

  @smoke
  Scenario: Create project with valid data
    Given I have a valid auth token
    And I have a project payload:
      | name        | Test Project |
      | description | A test       |
    When I POST to "/projects"
    Then the response status should be 201
    And the response should contain "id"
```

### Layer 2: UI Tests (45%)

Test frontend rendering, interactions, state.

```gherkin
@ui @forms
Feature: Project Form

  Scenario: Submit valid project
    Given I am on the new project page
    When I fill in "Name" with "My Project"
    And I click "Create"
    Then I should see "Project created"
```

### Layer 3: E2E Tests (15%)

Test complete user journeys.

```gherkin
@e2e @critical
Feature: Project Workflow

  Scenario: Create and manage project
    Given I am logged in as "user@example.com"
    When I create a project "E-commerce"
    Then I should see it in my projects
    When I add a task "Setup database"
    Then the task should appear in the project
```

---

## Tag Requirements

### Required Tags (Every Scenario)

| Tag | Purpose |
|-----|---------|
| `@api` / `@ui` / `@e2e` | Layer |
| `@smoke` / `@critical` / `@regression` | Priority |

### Usage

```gherkin
# Run by layer
npm test -- --tags "@api"

# Run by priority
npm test -- --tags "@smoke"

# Run critical API tests
npm test -- --tags "@api and @critical"
```

---

## Coverage Expectations

### Minimum Scenarios

| Feature Type | API | UI | E2E | Total |
|--------------|-----|-----|-----|-------|
| CRUD Entity | 8-10 | 5-7 | 2-3 | 15-20 |
| Authentication | 6-8 | 8-10 | 3-4 | 17-22 |
| Payment Flow | 5-6 | 6-8 | 4-5 | 15-19 |

### Scenario Types

Every feature needs:

- **Happy paths** - Normal, successful flows
- **Error cases** - Validation failures, edge cases
- **Security tests** - Authorization, input validation

---

## Writing Good Scenarios

### Do

```gherkin
# ✅ Specific and testable
Scenario: Reject registration with existing email
  Given a user exists with email "test@example.com"
  When I register with email "test@example.com"
  Then I should see "Email already exists"
  And no new user should be created
```

### Don't

```gherkin
# ❌ Vague and untestable
Scenario: Handle bad registration
  Given some users exist
  When I try to register badly
  Then it should fail
```

---

## Step Definitions

### Pattern

```typescript
import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from 'chai';

let context: any = {};

Given('I have a project payload:', function(dataTable) {
  context.payload = dataTable.rowsHash();
});

When('I POST to {string}', async function(endpoint) {
  context.response = await fetch(`${BASE_URL}${endpoint}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${context.token}`
    },
    body: JSON.stringify(context.payload)
  });
});

Then('the response status should be {int}', function(status) {
  expect(context.response.status).to.equal(status);
});
```

### Reusability

Create reusable steps:

```typescript
// Common steps
Given('I am authenticated as {string}', async function(email) {
  context.token = await login(email, 'password');
});

Given('I have a valid auth token', async function() {
  context.token = await login('test@example.com', 'password');
});
```

---

## Unit Testing

### Service Tests

```typescript
describe('ProjectService', () => {
  let service: ProjectService;
  let mockRepo: jest.Mocked<ProjectRepository>;

  beforeEach(() => {
    mockRepo = { create: jest.fn(), findOne: jest.fn() } as any;
    service = new ProjectService(mockRepo);
  });

  describe('create', () => {
    it('should create project with valid data', async () => {
      const dto = { name: 'Test', organizationId: 'org-1' };
      mockRepo.create.mockResolvedValue({ id: '1', ...dto });

      const result = await service.create(dto);

      expect(result.id).toBe('1');
      expect(mockRepo.create).toHaveBeenCalledWith(dto);
    });

    it('should throw on duplicate name', async () => {
      mockRepo.create.mockRejectedValue(new Error('Duplicate'));

      await expect(service.create({ name: 'Existing' }))
        .rejects.toThrow('Duplicate');
    });
  });
});
```

### Component Tests

```typescript
import { render, screen, fireEvent } from '@testing-library/react';

describe('ProjectForm', () => {
  it('submits with valid data', async () => {
    const onSubmit = jest.fn();
    render(<ProjectForm onSubmit={onSubmit} />);

    fireEvent.change(screen.getByLabelText('Name'), {
      target: { value: 'My Project' }
    });
    fireEvent.click(screen.getByText('Create'));

    await waitFor(() => {
      expect(onSubmit).toHaveBeenCalledWith({ name: 'My Project' });
    });
  });

  it('shows validation error for empty name', async () => {
    render(<ProjectForm onSubmit={jest.fn()} />);

    fireEvent.click(screen.getByText('Create'));

    expect(await screen.findByText('Name is required')).toBeInTheDocument();
  });
});
```

---

## CI/CD Integration

### GitHub Actions

```yaml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install
        run: npm ci

      - name: Smoke tests
        run: npm test -- --tags "@smoke"

      - name: Full suite
        run: npm test

      - name: Upload report
        uses: actions/upload-artifact@v4
        with:
          name: test-report
          path: reports/
```

---

## Quality Checklist

Before PR:

- [ ] All tests pass locally
- [ ] No skipped tests without justification
- [ ] Coverage thresholds met (>80%)
- [ ] New features have tests
- [ ] Edge cases covered
- [ ] Step definitions reusable
- [ ] Tags applied correctly
