---
description: Design or update your multi-tenant database schema
---

# Schema Design

You've invoked the `/schema` command to work on your database schema.

## What Happens Next

I'll invoke the **schema-architect** skill to design or update your multi-tenant data model.

### What Schema Architect Does

1. **Analyzes Requirements**
   - Reviews discovery document (if exists)
   - Reviews Gherkin scenarios (if exists)
   - Identifies entities and relationships

2. **Designs Multi-Tenant Schema**
   - Organization as tenant root
   - Row-level data isolation
   - Proper foreign key relationships
   - Indexes for query performance

3. **Generates Artifacts**
   - `.apsorc` schema definition
   - `docs/plans/schema-design.md` documentation
   - Entity relationship diagram (Mermaid)

## Prerequisites

For best results, you should have:
- Discovery document (`docs/discovery/discovery-notes.md`)
- OR Gherkin scenarios (`docs/scenarios/*.feature`)
- OR a clear description of your entities

## Usage Examples

**From discovery document:**
```
/schema
```
I'll extract entities from your existing discovery document.

**For specific entities:**
```
/schema

Design a schema for a project management system with:
- Projects (name, description, status, due_date)
- Tasks (title, description, priority, assigned_to)
- Comments (content, author)
```

**To update existing schema:**
```
/schema

Add a "Tags" entity that can be attached to both Projects and Tasks
```

## Output

You'll get:
- `backend/.apsorc` - Complete Apso schema definition
- `docs/plans/schema-design.md` - Documentation with ERD

## Ready?

**Describe your data model, or say "extract from discovery" to use existing requirements.**
