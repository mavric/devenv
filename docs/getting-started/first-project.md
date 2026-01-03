# Your First Project

A step-by-step walkthrough of building a SaaS application with Mavric DevEnv.

---

## Overview

In this guide, you'll build a complete SaaS application using the discovery-first workflow. The process takes about **2-3 hours** for discovery and planning, then **implementation time varies** based on complexity.

---

## Step 1: Start the Project

Open Claude Code in your terminal and run:

```
/start-project
```

Claude will respond with something like:

> "Great! Since you're starting a new SaaS project, I'll invoke the saas-project-orchestrator skill. This will guide us through discovery, test scenarios, schema design, product brief, and implementation."

---

## Step 2: Complete Discovery Interview

The discovery interview takes approximately **90 minutes** and covers:

### Product Vision (10 min)
Claude will ask about:
- What problem does your product solve?
- Who are your target customers?
- What's your business model?
- What makes your solution unique?

!!! tip "Be Specific"
    Instead of "a project management tool", say "a project management tool for remote engineering teams that integrates with GitHub and Slack."

### User Personas (10 min)
Define 2-3 primary user types:
- What's their role?
- What are their goals?
- What frustrates them?

### Core Workflows (20 min)
This is the most important section. For each workflow:

1. **Name the workflow** (e.g., "User signs up")
2. **List the steps** (1. User clicks signup... 2. Enters email...)
3. **Define validation** (Email must be valid, password 8+ chars)
4. **Handle errors** (What if email exists?)

### Data & Entities (15 min)
Identify what data you need to store:
- What are the main "things" in your system?
- How do they relate to each other?
- What fields does each thing have?

### Edge Cases (10 min)
Think about:
- What could go wrong?
- What happens at scale?
- What are the boundary conditions?

### Success Criteria (10 min)
Define measurable success:
- How will you know the feature works?
- What metrics matter?

### Constraints (10 min)
Document limitations:
- Technical constraints
- Business rules
- Compliance requirements

---

## Step 3: Review Discovery Document

After the interview, Claude generates a **15-25 page discovery document** containing:

- Executive summary
- Detailed user personas
- Complete workflow specifications
- Data model overview
- Edge cases and error handling
- Success criteria
- Technical constraints

!!! warning "Approval Gate"
    You must approve this document before proceeding. Rate your confidence from 1-10.

    - **8-10**: Ready to proceed
    - **6-7**: Minor clarifications needed
    - **Below 6**: Major gaps - continue discovery

---

## Step 4: Generate Test Scenarios

Once discovery is approved, Claude generates Gherkin test scenarios:

```gherkin
Feature: User Registration

  @api @smoke
  Scenario: Successful user registration
    Given I have valid registration data
    When I submit the registration form
    Then a new user account is created
    And a welcome email is sent
    And I am redirected to the dashboard

  @api @negative
  Scenario: Registration with existing email
    Given a user already exists with email "test@example.com"
    When I try to register with email "test@example.com"
    Then I see an error "Email already exists"
    And no duplicate account is created
```

Expect **40-60 scenarios** covering:

- Happy paths
- Error cases
- Edge cases
- Security tests

---

## Step 5: Design the Schema

Claude designs your database schema based on discovery:

```json
{
  "service": "my-saas-api",
  "entities": {
    "Organization": {
      "fields": {
        "id": { "type": "uuid", "primary": true },
        "name": { "type": "string", "required": true },
        "slug": { "type": "string", "unique": true }
      }
    },
    "User": {
      "fields": {
        "id": { "type": "uuid", "primary": true },
        "email": { "type": "string", "unique": true },
        "organization_id": { "type": "uuid", "references": "Organization.id" }
      }
    }
  }
}
```

This becomes your `.apsorc` file for Apso code generation.

---

## Step 6: Generate Product Brief

All artifacts are synthesized into a Product Requirements Document (PRD):

- Feature specifications
- Acceptance criteria
- Technical requirements
- Phased roadmap

---

## Step 7: Implementation

Now you're ready to build! Claude guides you through:

### Backend Bootstrap
```bash
# Automated Apso + BetterAuth setup
./scripts/setup-apso-betterauth.sh
```

This creates:
- NestJS REST API
- PostgreSQL database
- Authentication system
- OpenAPI documentation

### Frontend Bootstrap
Next.js application with:
- BetterAuth client integration
- Tailwind CSS + shadcn/ui
- Type-safe API client

### Feature Development
For each feature, Claude helps you:
1. Write the backend endpoints
2. Build the frontend UI
3. Create tests
4. Verify against Gherkin scenarios

---

## Timeline Expectations

| Phase | Duration | Output |
|-------|----------|--------|
| Discovery | 90 min | Discovery document |
| Test Scenarios | 30 min | Gherkin features |
| Schema Design | 30 min | .apsorc file |
| Product Brief | 30 min | PRD |
| Backend Setup | 30 min | Running API |
| Frontend Setup | 30 min | Running app |
| Core Features | 2-8 weeks | Working MVP |

---

## Example Project

Here's what a simple task management SaaS might look like after this process:

**Discovery Output:**
- 2 personas (Team Lead, Team Member)
- 5 workflows (Create task, Assign task, Complete task, etc.)
- 6 entities (Organization, User, Project, Task, Comment, Activity)
- 45 test scenarios

**Generated Backend:**
- 6 REST controllers
- Full CRUD for all entities
- Multi-tenant isolation
- Authentication with BetterAuth

**Time to MVP:** ~4 weeks

---

## Tips for Success

!!! success "Do"
    - Be specific during discovery
    - Think through edge cases
    - Approve documents carefully
    - Follow the sequence

!!! failure "Don't"
    - Skip discovery for "simple" features
    - Rush through the interview
    - Start coding before approval
    - Ignore generated tests

---

## Next Steps

- [Core Concepts](../concepts/overview.md) - Understand the methodology
- [Skills Reference](../skills/index.md) - Explore available skills
- [Setup Scripts](../setup/index.md) - Automation documentation
