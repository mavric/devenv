# /discovery-only

Run the 90-minute discovery interview without full orchestration.

---

## Usage

```
/discovery-only
```

Or say:
- "Run discovery for this feature"
- "I need to extract requirements"
- "Let's do a discovery session"

---

## What It Does

This command invokes the `discovery-interviewer` skill directly, running just the discovery phase:

1. **90-minute structured interview** covering all 8 areas
2. **Discovery document generation** (15-25 pages)
3. **Stops there** - you decide what's next

Unlike `/start-project`, this does NOT automatically proceed to test scenarios, schema design, or implementation.

---

## When to Use

| Scenario | Use /discovery-only? |
|----------|----------------------|
| Major feature for existing project | **Yes** |
| Validating an idea before committing | **Yes** |
| Re-discovering a stalled project | **Yes** |
| Brand new project (full SDLC) | No - use `/start-project` |
| Small feature | No - too heavyweight |

---

## Example Session

```
You: /discovery-only

Claude: You want to run discovery for a major new feature or product area.
I'll conduct a 90-minute structured interview covering:

1. Product Vision (10 min)
2. User Personas (10 min)
3. Core Workflows (20 min)
4. Data & Entities (15 min)
5. Edge Cases (10 min)
6. Success Criteria (10 min)
7. Constraints (10 min)
8. Review (5 min)

Let's begin. Tell me about what you want to build...

[Interview proceeds...]

Claude: [After interview completes]

Here's your discovery document. You can now:
- Generate test scenarios from this
- Design a schema
- Create a product brief
- Or stop here and implement manually

What would you like to do next?
```

---

## After Discovery

Once discovery is complete, you can manually invoke other skills:

### Generate Test Scenarios
```
"Generate Gherkin scenarios from the discovery document"
```

### Design Schema
```
"Create a schema based on the discovery"
```

### Create Product Brief
```
"Write a PRD from the discovery and scenarios"
```

### Proceed to Implementation
```
"Let's start implementing based on the discovery"
```

---

## Output Artifacts

| Artifact | Location |
|----------|----------|
| Discovery document | `features/docs/discovery/` |

---

## Comparison

| Aspect | /start-project | /discovery-only |
|--------|----------------|-----------------|
| Scope | Full SDLC | Discovery only |
| Duration | Hours to weeks | 90 minutes |
| Auto-proceeds | Yes | No |
| Best for | New projects | Feature validation |

---

## Related

- [/start-project](start-project.md)
- [Discovery-First Development](../concepts/discovery-first.md)
- [Discovery Interviewer Skill](../skills/discovery-interviewer.md)
