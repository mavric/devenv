# Discovery-First Development

The most important concept in Mavric DevEnv.

---

## Why Discovery First?

!!! danger "The Cost of Skipping Discovery"
    - 60% of project failures are due to poor requirements
    - Fixing issues post-launch costs **100x more**
    - Average project experiences 30-50% scope creep
    - Teams waste weeks building the wrong thing

Discovery takes **90 minutes**. It prevents **weeks of rework**.

---

## The 90-Minute Interview

The discovery interview is structured into 8 sections:

### 1. Product Vision (10 min)

**Questions asked:**

- What problem does your product solve?
- Who experiences this problem?
- What's your business model?
- What makes your solution unique?
- Who are your competitors?

**Output:** Clear value proposition and market positioning.

---

### 2. User Personas (10 min)

Define 2-3 primary user types:

**For each persona:**

- Role/title
- Goals (what they want to achieve)
- Frustrations (current pain points)
- Technical proficiency
- Usage frequency

**Example:**
```
Persona: Team Lead (Sarah)
- Goal: Track team progress without micromanaging
- Frustration: Current tools require too many clicks
- Technical: Moderate - comfortable with web apps
- Usage: Daily, 15-30 minutes
```

---

### 3. Core Workflows (20 min)

This is the **most important section**. For each workflow:

**Define:**

1. **Trigger** - What starts this workflow?
2. **Steps** - Numbered sequence of actions
3. **Validation** - What makes input valid?
4. **Errors** - What can go wrong?
5. **Success** - What's the end state?

**Example:**
```
Workflow: User Creates Project

Trigger: User clicks "New Project" button

Steps:
1. System displays project creation form
2. User enters project name (required, 3-100 chars)
3. User enters description (optional, max 500 chars)
4. User selects team members (optional)
5. User clicks "Create"
6. System validates input
7. System creates project
8. System redirects to project dashboard

Validation:
- Name: Required, 3-100 characters, unique per organization
- Description: Optional, max 500 characters

Errors:
- Name missing → "Project name is required"
- Name too short → "Name must be at least 3 characters"
- Name duplicate → "A project with this name already exists"

Success:
- Project appears in project list
- User sees project dashboard
- Team members receive notification
```

---

### 4. Data & Entities (15 min)

Identify what data you need:

**Questions:**

- What are the main "things" in your system?
- What information do you track about each thing?
- How do things relate to each other?
- What's unique about each thing?

**Example Output:**
```
Entities:
- Organization (tenant)
- User (belongs to organization)
- Project (belongs to organization)
- Task (belongs to project)
- Comment (belongs to task)

Relationships:
- Organization 1:N Users
- Organization 1:N Projects
- Project 1:N Tasks
- Task 1:N Comments
- User 1:N Comments
```

---

### 5. Edge Cases (10 min)

Think about boundaries:

**Categories:**

- **Scale**: What happens with 1,000 projects? 10,000 users?
- **Concurrency**: Two users editing the same task?
- **Permissions**: Who can see/edit what?
- **Data lifecycle**: What happens on delete? Archive?
- **Integration failures**: External API down?

---

### 6. Success Criteria (10 min)

Define measurable success:

**For each feature:**

- How do you know it works?
- What metrics matter?
- What's the acceptance threshold?

**Example:**
```
Feature: User Registration
Success Criteria:
- User can sign up with email/password
- User receives verification email within 30 seconds
- User can log in after verification
- User sees their dashboard after login
```

---

### 7. Constraints (10 min)

Document limitations:

**Categories:**

- **Technical**: Must use PostgreSQL, must support mobile
- **Business**: GDPR compliance, SOC2 requirements
- **Integration**: Must integrate with Slack, GitHub
- **Performance**: Page load < 2s, API response < 200ms

---

### 8. Review (5 min)

Summarize and validate:

- Recap key decisions
- Identify any gaps
- Confirm understanding
- Rate confidence (1-10)

---

## The Discovery Document

After the interview, Claude generates a comprehensive document:

**Structure:**

```
1. Executive Summary
   - Product overview
   - Key value propositions
   - Target market

2. User Personas
   - Detailed persona profiles
   - User journey maps

3. Functional Requirements
   - Complete workflow specifications
   - Validation rules
   - Error handling

4. Data Model
   - Entity definitions
   - Relationships
   - Key fields

5. Non-Functional Requirements
   - Performance criteria
   - Security requirements
   - Compliance needs

6. Edge Cases & Boundaries
   - Scale considerations
   - Error scenarios
   - Integration points

7. Success Criteria
   - Feature acceptance criteria
   - Metrics definitions

8. Constraints & Assumptions
   - Technical constraints
   - Business rules
   - Dependencies
```

**Length:** 15-25 pages, depending on complexity.

---

## When to Use Discovery

| Scenario | Use Discovery? |
|----------|---------------|
| New SaaS product | **Yes** - Full 90 minutes |
| Major new feature | **Yes** - Focused 30-45 minutes |
| Small enhancement | No - Too small |
| Bug fix | No - Not applicable |
| Refactoring | No - Not applicable |

---

## Handling "I Don't Know"

During discovery, you might not know the answer to every question. That's okay!

The discovery-interviewer skill includes **Product Management guidance**:

!!! tip "PM Guidance Example"
    **Q: What should the password requirements be?**

    *If you don't know, here's industry best practice:*
    - Minimum 8 characters
    - At least one uppercase letter
    - At least one number
    - Consider allowing passphrases (longer, no complexity requirements)
    - Never store passwords in plaintext (use bcrypt/argon2)

---

## Common Mistakes

!!! failure "Mistakes to Avoid"
    - **Vague workflows**: "User creates account" → Be specific about every step
    - **Missing error cases**: Always define what happens when things go wrong
    - **Assuming edge cases**: Document them explicitly
    - **Skipping for "simple" features**: Even simple features have edge cases

---

## Next Steps

- [Project Structure](project-structure.md) - How files are organized
- [Development Workflow](workflow.md) - The full phase-by-phase process
