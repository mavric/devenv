# Schema Architect

Designs database schemas with multi-tenancy, relationships, and best practices.

---

## Overview

| Attribute | Value |
|-----------|-------|
| **Name** | schema-architect |
| **Type** | Planning skill |
| **Triggers** | "design schema", "data model", "database design" |
| **Output** | `.apsorc` schema file |
| **Location** | `.claude/skills/schema-architect/` |

---

## What It Does

The Schema Architect designs robust, scalable database schemas optimized for SaaS applications. It:

- Extracts entities from discovery documents and scenarios
- Designs relationships (one-to-many, many-to-many)
- Implements multi-tenancy via Organization entity
- Adds appropriate indexes
- Generates Apso-compatible schema

---

## Core Patterns

### Standard SaaS Entities

Every SaaS schema includes these foundation entities:

**Organization (Tenant)**
```json
{
  "id": "uuid",
  "name": "string (required)",
  "slug": "string (unique)",
  "billing_email": "string",
  "stripe_customer_id": "string (nullable)",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

**User**
```json
{
  "id": "uuid",
  "email": "string (unique)",
  "name": "string",
  "organization_id": "uuid (FK → Organization)",
  "role": "enum (admin, member, viewer)",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

---

### Multi-Tenancy Rules

!!! danger "Critical Rule"
    Every product-specific entity MUST have `organization_id` for tenant isolation.

```json
{
  "name": "Project",
  "fields": {
    "id": { "type": "uuid", "primary": true },
    "organization_id": {
      "type": "uuid",
      "required": true,
      "references": "Organization.id"
    },
    "name": { "type": "string", "required": true }
  }
}
```

This ensures:
- Data is scoped to organizations
- No cross-tenant data leakage
- Proper row-level isolation

---

## Design Process

### Step 1: Entity Discovery

Identify the main "things" in the system:

- What nouns appear in workflows?
- What data needs to be stored?
- What has a lifecycle (created, updated, deleted)?

### Step 2: Relationship Mapping

For each entity pair, determine:

- **One-to-one**: User → Profile
- **One-to-many**: Organization → Users
- **Many-to-many**: Users ↔ Projects (via junction table)

### Step 3: Field Definition

For each entity:

- Required vs optional fields
- Data types (string, number, boolean, enum, JSON, timestamp)
- Constraints (unique, min/max, pattern)
- Default values

### Step 4: Optimization

Add:

- Indexes for common queries
- Soft delete flags (`deleted_at`)
- Timestamps (`created_at`, `updated_at`)

---

## Output Format

### Apso Schema (.apsorc)

```json
{
  "service": "my-saas-api",
  "database": {
    "provider": "postgresql",
    "multiTenant": true
  },
  "entities": {
    "Organization": {
      "fields": {
        "id": { "type": "uuid", "primary": true },
        "name": { "type": "string", "required": true },
        "slug": { "type": "string", "unique": true }
      }
    },
    "Project": {
      "fields": {
        "id": { "type": "uuid", "primary": true },
        "organization_id": {
          "type": "uuid",
          "required": true,
          "references": "Organization.id"
        },
        "name": { "type": "string", "required": true },
        "status": {
          "type": "enum",
          "values": ["active", "archived"],
          "default": "active"
        }
      },
      "indexes": [
        ["organization_id", "created_at"]
      ],
      "unique": [
        ["organization_id", "name"]
      ]
    }
  }
}
```

---

## Common Patterns

### Many-to-Many Relationship

```json
{
  "name": "ProjectMember",
  "comment": "Junction table for User-Project relationship",
  "fields": {
    "id": { "type": "uuid", "primary": true },
    "organization_id": { "type": "uuid", "references": "Organization.id" },
    "project_id": { "type": "uuid", "references": "Project.id" },
    "user_id": { "type": "uuid", "references": "User.id" },
    "role": { "type": "enum", "values": ["owner", "editor", "viewer"] }
  },
  "unique": [["project_id", "user_id"]],
  "indexes": [["project_id"], ["user_id"]]
}
```

### Hierarchical Data

```json
{
  "name": "Category",
  "fields": {
    "id": { "type": "uuid", "primary": true },
    "organization_id": { "type": "uuid" },
    "name": { "type": "string", "required": true },
    "parent_id": { "type": "uuid", "references": "Category.id", "nullable": true },
    "level": { "type": "integer" }
  }
}
```

### Polymorphic Associations

```json
{
  "name": "Comment",
  "fields": {
    "id": { "type": "uuid", "primary": true },
    "organization_id": { "type": "uuid" },
    "user_id": { "type": "uuid", "references": "User.id" },
    "commentable_type": { "type": "enum", "values": ["project", "task"] },
    "commentable_id": { "type": "uuid" },
    "content": { "type": "text" }
  },
  "indexes": [["commentable_type", "commentable_id"]]
}
```

---

## Best Practices

### Data Modeling

- **Normalize** - Reduce data duplication
- **Foreign Keys** - Enforce referential integrity
- **Indexes** - Add for common query patterns
- **Enums** - Use for fixed sets of values
- **Timestamps** - Always include `created_at`, `updated_at`

### Multi-Tenancy

- **Org-First** - `organization_id` on every tenant-scoped table
- **Composite Indexes** - Include `org_id` in indexes
- **Unique Constraints** - Scope to organization

### Security

- **No PII in Logs** - Exclude sensitive fields
- **Soft Deletes** - Use `deleted_at` for audit trails
- **Access Control** - Role-based permissions

---

## Invocation

### Via Orchestrator

Automatically called as Phase 2 of `/start-project`.

### Via Natural Language

```
"Design a schema for my task management app"
"Create a data model based on the discovery"
"What entities do I need for this feature?"
```

---

## Related

- [Backend Bootstrapper](backend-bootstrapper.md) (uses schema)
- [Discovery Interviewer](discovery-interviewer.md) (informs schema)
- [Test Generator](test-generator.md) (validates against schema)
