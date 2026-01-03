---
description: Run discovery interview without full project orchestration
---

# Discovery Interview Only

You've invoked the `/discovery-only` command to run just the discovery phase.

## What This Does

I'll conduct a **90-minute structured discovery interview** using the **discovery-interviewer** skill.

### Interview Structure

1. **Product Vision** (10 min) - The why and business model
2. **User Personas** (10 min) - Who uses it and their goals
3. **Core Workflows** (20 min) - Step-by-step user actions
4. **Data & Entities** (15 min) - What information to manage
5. **Edge Cases** (10 min) - What could go wrong
6. **Success Criteria** (10 min) - How we measure success
7. **Constraints** (10 min) - Technical limitations
8. **Review** (5 min) - Completeness check

### Output

**Discovery Document:**
- Executive summary
- Detailed workflows with validation and error cases
- Complete data model with entities and relationships
- Edge cases and boundaries
- Success criteria for each workflow
- Technical constraints and integrations
- Prioritized feature list (MVP vs Future)

## When To Use This

✅ **Use `/discovery-only` when:**
- Major new feature area for existing project
- Exploring an idea before committing to build
- Validating requirements with stakeholders
- Re-discovering a stalled project
- You want discovery doc without full orchestration

❌ **Use `/start-project` instead when:**
- Starting a brand new SaaS project
- Want full SDLC orchestration (discovery → deployment)
- Want automatic generation of scenarios, schema, roadmap

## After Discovery

You can choose to:
- Generate Gherkin scenarios (invoke test-generator)
- Design schema (invoke schema-architect)
- Create product brief (invoke product-brief-writer)
- Stop here and implement manually
- Hand off to saas-project-orchestrator for full build

## Ready?

I'm invoking the discovery-interviewer now.

**What are you building? Tell me about your product idea.**
