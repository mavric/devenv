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
- Implements multi-tenancy via Organization entity with `scopeBy`
- Adds appropriate indexes and unique constraints
- Generates Apso RC schema (version 2 format)

---

## Apso RC Schema Format

!!! danger "Critical: Always Use Version 2 Format"
    The schema MUST follow the official Apso RC schema specification:
    https://github.com/apsoai/cli/blob/main/apsorc.schema.json

### Key Format Rules

1. **`version: 2`** - Required at root level
2. **`entities`** - Must be an ARRAY (not an object)
3. **`relationships`** - Defined separately as an ARRAY
4. **Fields** - Use `name` and `type` as separate properties
5. **Multi-tenancy** - Use `scopeBy: "organizationId"` on tenant-scoped entities

---

## Core Patterns

### Standard SaaS Entities

Every SaaS schema includes these foundation entities:

**Organization (Tenant)**
```json
{
  "name": "Organization",
  "primaryKeyType": "uuid",
  "created_at": true,
  "updated_at": true,
  "fields": [
    { "name": "name", "type": "text", "nullable": false, "length": 255 },
    { "name": "slug", "type": "text", "nullable": false, "unique": true, "length": 100 },
    { "name": "billing_email", "type": "text", "nullable": true },
    { "name": "stripe_customer_id", "type": "text", "nullable": true }
  ]
}
```

**User**
```json
{
  "name": "User",
  "primaryKeyType": "uuid",
  "created_at": true,
  "updated_at": true,
  "fields": [
    { "name": "email", "type": "text", "nullable": false, "unique": true, "length": 255 },
    { "name": "name", "type": "text", "nullable": false, "length": 255 },
    { "name": "role", "type": "enum", "values": ["admin", "member", "viewer"], "nullable": false, "default": "member" }
  ]
}
```

---

### Multi-Tenancy Rules

!!! danger "Critical Rule"
    Every product-specific entity MUST use `scopeBy: "organizationId"` for tenant isolation.

```json
{
  "name": "Project",
  "primaryKeyType": "uuid",
  "scopeBy": "organizationId",
  "created_at": true,
  "updated_at": true,
  "fields": [
    { "name": "name", "type": "text", "nullable": false, "length": 255 },
    { "name": "status", "type": "enum", "values": ["active", "archived"], "nullable": false, "default": "active" }
  ],
  "uniques": [
    { "name": "unique_project_name_per_org", "fields": ["organizationId", "name"] }
  ]
}
```

The `scopeBy` property ensures:
- Data is automatically scoped to organizations
- No cross-tenant data leakage
- Proper row-level isolation
- Apso generates organization-scoped API endpoints

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

### Apso RC Schema (.apsorc)

!!! info "Official Schema Reference"
    Always validate against: https://github.com/apsoai/cli/blob/main/apsorc.schema.json

```json
{
  "$schema": "https://raw.githubusercontent.com/apsoai/cli/main/apsorc.schema.json",
  "version": 2,
  "rootFolder": "src/generated",
  "entities": [
    {
      "name": "Organization",
      "primaryKeyType": "uuid",
      "created_at": true,
      "updated_at": true,
      "fields": [
        { "name": "name", "type": "text", "nullable": false, "length": 255 },
        { "name": "slug", "type": "text", "nullable": false, "unique": true, "length": 100 }
      ]
    },
    {
      "name": "Project",
      "primaryKeyType": "uuid",
      "scopeBy": "organizationId",
      "created_at": true,
      "updated_at": true,
      "fields": [
        { "name": "name", "type": "text", "nullable": false, "length": 255 },
        { "name": "status", "type": "enum", "values": ["active", "archived"], "nullable": false, "default": "active" }
      ],
      "uniques": [
        { "name": "unique_project_name_per_org", "fields": ["organizationId", "name"] }
      ],
      "indexes": [
        { "name": "idx_project_org_created", "fields": ["organizationId", "createdAt"] }
      ]
    }
  ],
  "relationships": [
    { "from": "Project", "to": "Organization", "type": "ManyToOne", "nullable": false }
  ]
}
```

### Field Types

| Type | Description | Extra Properties |
|------|-------------|------------------|
| `text` | String values | `length`, `unique` |
| `integer` | Whole numbers | `min`, `max` |
| `decimal` | Decimal numbers | `precision`, `scale` |
| `boolean` | True/false | `default` |
| `enum` | Fixed set of values | `values` (array) |
| `json` | JSON data | - |
| `timestamp` | Date and time | - |
| `date` | Date only | - |

### Relationship Types

| Type | Description |
|------|-------------|
| `OneToOne` | One entity relates to exactly one other |
| `ManyToOne` | Many entities relate to one (FK on the "from" side) |
| `OneToMany` | One entity relates to many (FK on the "to" side) |
| `ManyToMany` | Many-to-many via junction table |

---

## Common Patterns

### Many-to-Many Relationship

Use a junction entity with two ManyToOne relationships:

```json
{
  "name": "ProjectMember",
  "primaryKeyType": "uuid",
  "scopeBy": "organizationId",
  "created_at": true,
  "fields": [
    { "name": "role", "type": "enum", "values": ["owner", "editor", "viewer"], "nullable": false, "default": "viewer" }
  ],
  "uniques": [
    { "name": "unique_project_user", "fields": ["projectId", "userId"] }
  ]
}
```

With relationships:
```json
[
  { "from": "ProjectMember", "to": "Organization", "type": "ManyToOne", "nullable": false },
  { "from": "ProjectMember", "to": "Project", "type": "ManyToOne", "nullable": false },
  { "from": "ProjectMember", "to": "User", "type": "ManyToOne", "nullable": false }
]
```

### Hierarchical Data (Self-Reference)

```json
{
  "name": "Category",
  "primaryKeyType": "uuid",
  "scopeBy": "organizationId",
  "created_at": true,
  "updated_at": true,
  "fields": [
    { "name": "name", "type": "text", "nullable": false, "length": 255 },
    { "name": "level", "type": "integer", "nullable": false, "default": 0 }
  ]
}
```

With self-referencing relationship:
```json
{ "from": "Category", "to": "Category", "type": "ManyToOne", "nullable": true, "fieldName": "parentId" }
```

### Polymorphic Associations

```json
{
  "name": "Comment",
  "primaryKeyType": "uuid",
  "scopeBy": "organizationId",
  "created_at": true,
  "updated_at": true,
  "fields": [
    { "name": "commentable_type", "type": "enum", "values": ["project", "task"], "nullable": false },
    { "name": "commentable_id", "type": "uuid", "nullable": false },
    { "name": "content", "type": "text", "nullable": false }
  ],
  "indexes": [
    { "name": "idx_comment_polymorphic", "fields": ["commentable_type", "commentable_id"] }
  ]
}
```

With relationship to author:
```json
{ "from": "Comment", "to": "User", "type": "ManyToOne", "nullable": false, "fieldName": "authorId" }
```

---

## Best Practices

### Data Modeling

- **Normalize** - Reduce data duplication
- **Relationships** - Define in separate `relationships` array (not inline)
- **Indexes** - Add for common query patterns with named indexes
- **Enums** - Use for fixed sets of values with `type: "enum"` and `values` array
- **Timestamps** - Set `created_at: true` and `updated_at: true` on entities

### Multi-Tenancy

- **scopeBy** - Use `scopeBy: "organizationId"` on every tenant-scoped entity
- **Composite Indexes** - Include `organizationId` in indexes
- **Unique Constraints** - Scope to organization in `uniques` array

### Apso RC Specific

- **Version 2** - Always include `"version": 2` at root
- **$schema** - Include schema reference for IDE validation
- **Arrays Not Objects** - `entities` and `relationships` must be arrays
- **Field Format** - Each field is `{ "name": "...", "type": "...", ... }`
- **Relationships Separate** - Never inline FK references in fields

### Security

- **No PII in Logs** - Mark sensitive fields appropriately
- **Soft Deletes** - Add `deleted_at: true` on entities for audit trails
- **Access Control** - Role-based permissions via User entity

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
