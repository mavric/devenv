---
name: schema-architect
description: Designs database schemas with multi-tenancy, relationships, and best practices. Triggers when user needs to design data model, create entities, or plan database structure.
---

# Schema Architect

I design robust, scalable database schemas optimized for SaaS applications with multi-tenancy built in.

## What I Create

### 1. Entity Definitions
For each entity in your system:
- Entity name and purpose
- Fields with types and constraints
- Relationships to other entities
- Indexes for performance
- Validation rules

### 2. Multi-Tenancy Strategy
- Organization (tenant) entity
- Org-scoped data isolation
- Proper foreign keys to org
- Row-level security patterns

### 3. Apso Schema File
Complete `.apsorc` file ready to use:
```json
{
  "service": "your-service",
  "entities": {
    "Organization": { ... },
    "User": { ... },
    "YourEntity": { ... }
  }
}
```

### 4. Entity Relationship Diagram
ASCII or Mermaid diagram showing:
- All entities
- Relationships (one-to-many, many-to-many)
- Cardinality
- Foreign keys

### 5. Data Flow Documentation
- How data moves through the system
- Common query patterns
- Performance considerations

## Core Patterns I Use

### Standard SaaS Entities

I always include these foundation entities:

**Organization** (Tenant)
- `id` (UUID, PK)
- `name` (string, required)
- `slug` (string, unique, required)
- `billing_email` (string)
- `stripe_customer_id` (string, nullable)
- `subscription_status` (enum)
- `created_at`, `updated_at` (timestamps)

**User**
- `id` (UUID, PK)
- `email` (string, unique, required)
- `name` (string)
- `avatar_url` (string, nullable)
- `organization_id` (UUID, FK → Organization, required)
- `role` (enum: admin, member, viewer)
- `created_at`, `updated_at`

**Subscription**
- `id` (UUID, PK)
- `organization_id` (UUID, FK → Organization, unique)
- `stripe_subscription_id` (string, unique)
- `plan_id` (string, required)
- `status` (enum: active, canceled, past_due, trialing)
- `current_period_end` (timestamp)
- `created_at`, `updated_at`

**AuditLog**
- `id` (UUID, PK)
- `organization_id` (UUID, FK → Organization)
- `user_id` (UUID, FK → User, nullable)
- `action` (string, required)
- `resource_type` (string)
- `resource_id` (UUID)
- `ip_address` (string)
- `user_agent` (string)
- `created_at`

**File**
- `id` (UUID, PK)
- `organization_id` (UUID, FK → Organization)
- `uploaded_by` (UUID, FK → User)
- `filename` (string, required)
- `s3_key` (string, required)
- `mime_type` (string)
- `size_bytes` (integer)
- `created_at`

### Multi-Tenancy Rules

Every product-specific entity MUST:
1. Have `organization_id` foreign key
2. Include org_id in unique constraints
3. Be filtered by org_id in queries
4. Have proper indexes on org_id

**Example:**
```typescript
// ✅ Good - Multi-tenant aware
projects:
  - name: string (required)
  - organization_id: uuid (FK → organizations, required)
  - created_by: uuid (FK → users, required)
  - status: enum(active, archived)

  indexes:
    - [organization_id, created_at]

  unique_constraints:
    - [organization_id, name]  // Name unique per org, not globally
```

## Design Process

### Step 1: Entity Discovery
I'll ask you:
- What are the main "things" in your system?
- What data do you need to track?
- What are the user actions?

Common entities by domain:
- **Project Management:** Project, Task, Milestone, Comment
- **E-Commerce:** Product, Order, Cart, Payment
- **CMS:** Post, Page, Media, Category
- **CRM:** Contact, Deal, Activity, Note

### Step 2: Relationship Mapping
For each entity pair, I determine:
- One-to-one
- One-to-many
- Many-to-many (via junction table)

**Example:**
```
Organization → User (one-to-many)
Organization → Project (one-to-many)
Project → Task (one-to-many)
User ←→ Project (many-to-many via ProjectMember)
```

### Step 3: Field Definition
For each entity, I define:
- Required vs optional fields
- Data types (string, number, boolean, enum, JSON, timestamp)
- Constraints (unique, min/max, pattern)
- Default values

### Step 4: Optimization
I add:
- Indexes for common queries
- Computed fields (if needed)
- Soft delete flags (deleted_at)
- Timestamps (created_at, updated_at)

### Step 5: Validation
I check:
- ✅ Every entity has organization_id (except Organization, User, Session)
- ✅ Foreign keys are correct
- ✅ No circular dependencies
- ✅ Proper cascade deletes
- ✅ Indexes on frequently queried fields

## Output Format

### Apso .apsorc Schema

```json
{
  "service": "your-service-name",
  "database": {
    "provider": "postgresql",
    "multiTenant": true
  },
  "entities": {
    "Organization": {
      "fields": {
        "id": { "type": "uuid", "primary": true },
        "name": { "type": "string", "required": true },
        "slug": { "type": "string", "unique": true, "required": true },
        "billing_email": { "type": "string" },
        "stripe_customer_id": { "type": "string" },
        "created_at": { "type": "timestamp", "default": "now()" },
        "updated_at": { "type": "timestamp", "default": "now()" }
      }
    },
    "YourEntity": {
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
        },
        "created_at": { "type": "timestamp", "default": "now()" },
        "updated_at": { "type": "timestamp", "default": "now()" }
      },
      "indexes": [
        ["organization_id", "created_at"],
        ["organization_id", "status"]
      ],
      "unique": [
        ["organization_id", "name"]
      ]
    }
  }
}
```

### Entity Relationship Diagram

```
┌─────────────────┐
│  Organization   │
│  (Tenant)       │
└────────┬────────┘
         │ 1:N
         ├─────────────────┐
         │                 │
         ▼                 ▼
┌─────────────┐   ┌──────────────┐
│    User     │   │   Project    │
└──────┬──────┘   └──────┬───────┘
       │ 1:N             │ 1:N
       │                 │
       ▼                 ▼
┌─────────────┐   ┌──────────────┐
│  AuditLog   │   │     Task     │
└─────────────┘   └──────────────┘
```

## Best Practices I Follow

### Data Modeling
✅ **Normalize** - Reduce data duplication
✅ **Foreign Keys** - Enforce referential integrity
✅ **Indexes** - Add for common query patterns
✅ **Enums** - Use for fixed sets of values
✅ **Timestamps** - Always include created_at, updated_at

### Multi-Tenancy
✅ **Org-First** - Organization_id on every tenant-scoped table
✅ **Proper Indexes** - Include org_id in composite indexes
✅ **Cascade Rules** - Define what happens on delete
✅ **Unique Constraints** - Scope to organization

### Security
✅ **No PII in Logs** - Exclude sensitive fields
✅ **Soft Deletes** - Use deleted_at for audit trails
✅ **Access Control** - Role-based permissions

## Common Patterns

### Many-to-Many Relationship
```typescript
// Users can be members of multiple projects
// Projects can have multiple users

ProjectMember (junction table):
  - id: uuid (PK)
  - organization_id: uuid (FK → Organization)
  - project_id: uuid (FK → Project)
  - user_id: uuid (FK → User)
  - role: enum(owner, editor, viewer)
  - created_at: timestamp

  unique: [project_id, user_id]
  indexes: [[project_id], [user_id]]
```

### Hierarchical Data
```typescript
// Categories with parent-child relationships

Category:
  - id: uuid (PK)
  - organization_id: uuid (FK → Organization)
  - name: string (required)
  - parent_id: uuid (FK → Category, nullable)
  - level: integer (for fast queries)
  - path: string (e.g., "/1/5/12" for materialized path)
  - created_at: timestamp
```

### Polymorphic Associations
```typescript
// Comments that can be on multiple entity types

Comment:
  - id: uuid (PK)
  - organization_id: uuid (FK → Organization)
  - user_id: uuid (FK → User)
  - commentable_type: enum(project, task, document)
  - commentable_id: uuid
  - content: text
  - created_at: timestamp

  indexes: [[commentable_type, commentable_id]]
```

## When to Use Me

- ✅ Starting a new project
- ✅ Adding new features that need entities
- ✅ Refactoring existing schema
- ✅ Migrating from monolith to microservices
- ✅ Designing data model before coding

## Ready?

Tell me about your application and the data you need to track. I'll design a robust, scalable schema optimized for SaaS with multi-tenancy built in.

**What entities do you need in your system?**
