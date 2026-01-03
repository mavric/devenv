# Discovery Framework: Structured Interview Techniques

> Proven techniques for extracting complete and accurate requirements

---

## Core Principles

### 1. **Depth Over Breadth**
- Better to fully understand 3 workflows than superficially know 10
- Drill down until you can visualize the exact user experience
- Ask "What happens next?" until the workflow is complete

### 2. **Show, Don't Tell**
- "Walk me through exactly what the user sees and does"
- "What button do they click? What fields appear?"
- Avoid abstract descriptions, get concrete details

### 3. **Edge Cases Are Features**
- Every "what if" is a potential requirement
- Error handling is not an afterthought
- Boundaries define the system's behavior

### 4. **No Assumptions**
- If it's not explicitly stated, ask
- "I'm assuming X, is that correct?"
- Validate your mental model frequently

### 5. **Guide, Don't Lead**
- Present options, don't prescribe solutions
- "Teams typically do A, B, or C. Which fits your case?"
- Let user choose after understanding trade-offs

---

## Interview Structure

### Opening (5 min)
**Goal:** Set context and build rapport

**Technique: The Framing**
```
"We're going to spend 90 minutes together understanding your product deeply.
I'll ask detailed questions about workflows, data, and edge cases.
My goal is to extract enough information that we can write precise test
scenarios and build exactly what you need. If you don't know something,
I'll guide you with industry best practices. Sound good?"
```

**Why this works:** Sets expectations, reduces anxiety about "not knowing", establishes collaborative tone.

---

### Vision & Context (10 min)
**Goal:** Understand the "why" before the "what"

**Technique: The Elevator Pitch**
```
Q: "Describe your SaaS in one sentence. Who is it for, what problem does it solve?"
```

**Follow-up probes:**
- "Why is this problem worth solving?"
- "What makes this different from [alternative]?"
- "How do you know people need this?"

**Technique: The Success Metric**
```
Q: "In 6 months, how do you know this is successful?"
```

**If vague response:**
```
"Let me help. Success could mean:
- X users signed up and active
- $Y monthly recurring revenue
- Z key actions completed per user
- Specific user testimonial like 'This saved me 5 hours/week'

Which of these matters most to you?"
```

---

### Personas & Journeys (10 min)
**Goal:** Identify all user types and their motivations

**Technique: The Role Matrix**
```
Q: "Who are all the different types of people who use your product?"
```

**If stuck:**
```
"Common SaaS personas:
- Admin (full control, manages settings)
- Manager (oversees team, approves actions)
- Member (does the work, limited permissions)
- Viewer (read-only, observes)

Do these fit, or are your roles different?"
```

**Technique: The Goal Extraction**
```
For each persona:
Q: "When [persona] logs in, what are they trying to accomplish?"
```

**Follow-up:**
- "What's a successful session for them?"
- "What would frustrate them?"
- "How often do they use this feature?"

---

### Core Workflows (20 min)
**Goal:** Extract step-by-step user actions

This is the **most critical section**. Use these techniques to go deep.

#### Technique 1: The Walkthrough

**Start broad:**
```
Q: "What are the top 3-5 things users do in your product?"
```

**Then drill into each:**
```
Q: "Let's start with [workflow]. Where does it begin? What does the user click?"
```

**Step-by-step extraction:**
```
1. "What's the very first thing they see?"
2. "What fields or options appear?"
3. "Are any required? Optional?"
4. "What happens when they click [action]?"
5. "What do they see after that completes?"
6. "Can they go back? Cancel? Edit?"
```

**Continue until workflow ends:**
```
"Is that the end of the workflow, or is there more?"
```

#### Technique 2: The Data Table

For forms or data entry, use a structured approach:

```
Q: "What fields are on this form?"

For each field:
- Name of field
- Type (text, number, date, dropdown, etc.)
- Required or optional
- Max length / validation rules
- Default value (if any)
- Help text / placeholder
```

**Example:**
```
"So the Create Project form has:
- Project Name: text, required, max 100 characters, placeholder 'Enter project name'
- Description: textarea, optional, max 500 characters
- Due Date: date picker, optional, no default

Is that correct? Anything missing?"
```

#### Technique 3: The Decision Tree

For workflows with branches:

```
Q: "Are there different paths based on [condition]?"
Q: "What if they choose Option A? Option B?"
```

**Visualize it:**
```
"Let me make sure I understand:
- If [condition], then [outcome A]
- If [different condition], then [outcome B]
- Default case: [outcome C]

Is that right?"
```

#### Technique 4: The Error Case

Always ask:

```
Q: "What if they don't fill in required fields?"
Q: "What if they enter invalid data?"
Q: "What if the operation fails (network error, server error)?"
Q: "What if they try to do this without permission?"
```

**For each error:**
- What error message do they see?
- Where is it displayed?
- Can they retry? Fix and resubmit?
- Is any data preserved?

#### Technique 5: The Permission Check

```
Q: "Can everyone do this, or only certain roles?"
Q: "What happens if an unauthorized user tries this action?"
```

**Options:**
- Button/link hidden (user never sees it)
- Button disabled with tooltip
- Action attempted, error returned
- Redirect to login/upgrade page

#### Technique 6: The Completeness Verification

After documenting workflow:

```
"Let me read back what I've captured. Stop me if anything is wrong or missing:

[Read entire workflow step-by-step]

Did I miss anything?"
```

---

### Data Model (15 min)
**Goal:** Identify entities and relationships

**Technique: The Entity Brainstorm**

```
Q: "What are the main 'things' your system manages?"
```

**If stuck:**
```
"Think about the nouns in your workflows:
- Users create [Projects]
- Projects have [Tasks]
- Tasks assigned to [Team Members]
- Team Members leave [Comments]

What are the [things] in your product?"
```

**Technique: The Attribute Drill-Down**

For each entity:

```
Q: "What information do you need to track about [entity]?"
```

**Structured extraction:**
```
For each attribute:
- Name
- Type (string, number, date, boolean, enum)
- Required or optional
- Unique constraint?
- Default value?
- Max length / validation
```

**Technique: The Relationship Mapper**

```
Q: "How do these entities relate to each other?"
```

**Guide with examples:**
```
"Is it:
- One-to-many? (One Project has many Tasks)
- Many-to-one? (Many Tasks belong to one Project)
- Many-to-many? (Many Users can join many Projects)
- One-to-one? (One User has one Profile)
"
```

**Technique: The Multi-Tenancy Check**

```
Q: "Is data isolated per organization/company/account?"
Q: "Can users belong to multiple organizations?"
```

**Standard guidance:**
```
"Standard SaaS pattern:
- Organization is the tenant (top-level container)
- All data has organization_id foreign key
- Users can belong to one or multiple organizations
- Queries automatically filter by user's current organization

Does this model work for you?"
```

---

### Edge Cases (10 min)
**Goal:** Identify boundaries and failure modes

**Technique: The Boundary Test**

```
Q: "What's the maximum [items] a user can have?"
Q: "What's the minimum? Can they have zero?"
Q: "What happens at scale? (1000+ items)"
```

**If unsure:**
```
"Common limits in SaaS:
- Free tier: 10 projects, 100 tasks
- Pro tier: 100 projects, 10,000 tasks
- Enterprise: Unlimited (with performance considerations)

What limits make sense for your business model?"
```

**Technique: The Concurrent Operation**

```
Q: "What if two users edit the same [entity] at the same time?"
```

**Present options:**
```
"Common approaches:
1. Last-write-wins: Second save overwrites first (simple, data loss risk)
2. Optimistic locking: Detect conflict, show error (more complex, safer)
3. Real-time sync: Both users see changes live (complex, best UX)

Which fits your use case?"
```

**Technique: The Deletion Scenario**

```
Q: "What happens when a [parent entity] is deleted?"
```

**Explore options:**
```
"Options for deleting a Project with Tasks:
1. Cascade delete: Delete project and all tasks (permanent, clean)
2. Prevent deletion: Error if tasks exist (safe, user must clean up first)
3. Soft delete: Mark as deleted, keep tasks (recoverable, uses storage)
4. Orphan handling: Delete project, keep tasks unassigned (messy)

Which behavior do you want?"
```

**Technique: The Invalid State**

```
Q: "Can [entity] be in an invalid state?"
```

**Examples:**
```
- Can a task be assigned to a user not in the organization?
- Can a project have a due date before its tasks' due dates?
- Can a user have zero organizations?
- Can an organization have zero users?
```

---

### Success Criteria (10 min)
**Goal:** Define measurable outcomes

**Technique: The Acceptance Test**

For each workflow:

```
Q: "How do you know [workflow] is working correctly?"
Q: "What should happen?"
Q: "What should NOT happen?"
```

**Structure it:**
```
Given [initial state]
When [user action]
Then [expected outcome]
And [additional validation]
```

This naturally feeds into Gherkin scenarios.

**Technique: The Performance Benchmark**

```
Q: "How fast should this be?"
```

**If unsure:**
```
"Industry standards for SaaS:
- Page load: <2 seconds
- API response: <500ms
- Database query: <100ms
- Perceived performance: <100ms (instant feedback)

Which of these apply to your workflows?"
```

**Technique: The Quality Bar**

```
Q: "What level of testing do you want?"
```

**Present standard:**
```
"We recommend:
- 90% overall test coverage
- API layer: 40% of scenarios (backend validation)
- UI layer: 45% of scenarios (user interactions)
- E2E layer: 15% of scenarios (critical paths)

Sound reasonable?"
```

---

### Constraints (10 min)
**Goal:** Understand technical and business boundaries

**Technique: The Technology Stack**

```
Q: "Any technology requirements?"
```

**If unsure:**
```
"Our recommended SaaS stack:
- Frontend: Next.js 14 (React, App Router)
- Backend: NestJS via Apso (REST API generation)
- Database: PostgreSQL (relational, scalable)
- Auth: Better Auth (modern, flexible)
- Hosting: Vercel (frontend) + Railway (backend)

Does this work, or do you have specific requirements?"
```

**Technique: The Compliance Check**

```
Q: "Any compliance requirements? (GDPR, HIPAA, SOC2, etc.)"
```

**If "I don't know":**
```
"Key questions:
- Will you have EU users? → GDPR applies
- Will you store health data? → HIPAA applies
- Will you serve enterprise clients? → SOC2 likely needed

Which of these apply?"
```

**Technique: The Integration Inventory**

```
Q: "Does this need to integrate with existing systems?"
```

**Common integrations:**
- Authentication (SSO, SAML, OAuth)
- Payments (Stripe, PayPal)
- Email (SendGrid, Postmark)
- Storage (S3, Cloudinary)
- Analytics (Mixpanel, Amplitude)
- CRM (Salesforce, HubSpot)

**Technique: The Timeline Reality Check**

```
Q: "What's your target launch date?"
```

**Provide guidance:**
```
"Typical timelines for MVP:
- 3 core workflows: 4-6 weeks
- 5 core workflows: 8-10 weeks
- 7-10 workflows: 12-16 weeks

Based on your [X workflows], I estimate [Y weeks]. Does that work?"
```

---

### Review & Close (5 min)
**Goal:** Validate completeness and set next steps

**Technique: The Completeness Checklist**

```
"Let me check we've covered everything:
- ✅ Product vision and goals
- ✅ User personas and journeys
- ✅ [X] core workflows documented
- ✅ Data model defined
- ✅ Edge cases identified
- ✅ Success criteria established
- ✅ Constraints and integrations listed

Anything missing?"
```

**Technique: The Confidence Score**

```
Q: "On a scale of 1-10, how confident are you in what we've defined?"
```

**If <8:**
```
"What feels unclear or uncertain? Let's dig deeper on those areas."
```

**Technique: The Prioritization**

```
Q: "If you had to launch with only 3 workflows, which would they be?"
```

This reveals true priorities and helps phase the roadmap.

**Technique: The Handoff**

```
"Perfect! I'll now create your complete discovery document.
Next, I'll hand this to the test-generator to create Gherkin scenarios
from your workflows. After that, schema-architect will design your database.

Ready to proceed?"
```

---

## Advanced Techniques

### Handling Uncertainty

**When user says "I don't know":**

❌ **Don't skip it:**
```
"Okay, we'll figure that out later."
```

✅ **Guide with options:**
```
"That's okay! Let me share how similar products handle this:
[Option A]: [Pros/Cons]
[Option B]: [Pros/Cons]
[Option C]: [Pros/Cons]

Which resonates with your vision?"
```

### Dealing with Scope Creep

**When user adds "and also...":**

✅ **Acknowledge and defer:**
```
"Great idea! That's a solid feature for post-MVP.
Let me capture it in a 'Future Enhancements' section.
For now, let's stay focused on the core [X workflows]
that get you to launch. Sound good?"
```

### Detecting Hidden Complexity

**Warning signs:**
- User says "simple" or "just" ("It's just a CRUD app")
- Workflows seem too linear (no error cases)
- Missing permissions discussion
- No edge cases mentioned

**Probe deeper:**
```
"You said 'simple CRUD' - let's make sure:
- What if two users edit the same record simultaneously?
- What if a user tries to delete something being used elsewhere?
- Who can do CRUD operations? Everyone or specific roles?
- How do you handle large datasets (1000+ records)?

These details matter for a production app."
```

### Extracting Examples

**When workflow is abstract:**

```
"Let's use a concrete example.
Imagine a user named Sarah who's a [persona].
Walk me through exactly what Sarah does when she [workflow]."
```

Examples ground abstract concepts.

---

## Output Quality Standards

A complete discovery session produces:

### 1. Executable Workflows
- Every step actionable
- Every field specified
- Every error case handled
- Every permission checked

### 2. Implementable Data Model
- Every entity defined
- Every attribute typed
- Every relationship mapped
- Every constraint specified

### 3. Testable Acceptance Criteria
- Every outcome measurable
- Every success case defined
- Every failure case defined
- Every edge case considered

### 4. Traceable Requirements
- Every workflow links to persona
- Every entity links to workflow
- Every criterion links to outcome
- Every feature links to value

---

## Common Pitfalls to Avoid

### ❌ Pitfall 1: Rushing
**Symptom:** Skipping follow-up questions to "move faster"
**Fix:** 90 minutes is the minimum. Take time to go deep.

### ❌ Pitfall 2: Assuming
**Symptom:** "I think they mean X, so I'll write that down"
**Fix:** Always confirm. "I'm assuming X, is that correct?"

### ❌ Pitfall 3: Accepting Vagueness
**Symptom:** User says "users can manage projects" and you don't probe
**Fix:** "What does 'manage' mean? Create, edit, delete, all three?"

### ❌ Pitfall 4: Skipping Error Cases
**Symptom:** Only happy paths documented
**Fix:** For every workflow, ask "What could go wrong?"

### ❌ Pitfall 5: Missing Personas
**Symptom:** All workflows described from single user perspective
**Fix:** "Who else uses this? Do they have different permissions/workflows?"

---

## Success Metrics

A successful discovery session:

✅ Takes 90 minutes (not 30, not 180)
✅ Produces 15-25 page document
✅ Documents 3-7 core workflows in detail
✅ Identifies 5-15 entities with full attributes
✅ Captures 20-40 edge cases
✅ Results in 8+ confidence score from user
✅ Enables Gherkin generation without follow-up questions

---

**Remember:** The quality of discovery determines the quality of implementation. 90 minutes spent here saves weeks of rework later.
