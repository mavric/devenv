# Templates

Pre-configured templates for schemas and documents.

---

## Template Types

| Type | Location | Purpose |
|------|----------|---------|
| [Schema Templates](#schema-templates) | `templates/*.json` | Database schemas |
| [Document Templates](#document-templates) | `.claude/templates/` | Project documents |

---

# Schema Templates

Pre-configured `.apsorc` templates for common SaaS patterns.

---

## Which Template?

| Template | Best For | Entities |
|----------|----------|----------|
| [Minimal SaaS](#minimal-saas) | MVPs, prototypes, learning | 6 |
| [Complete SaaS](#complete-saas) | B2B, enterprise, compliance | 11 |

---

## Minimal SaaS

**File:** `templates/minimal-saas-betterauth.json`

**Best for:**
- Starting a new SaaS from scratch
- MVPs and prototypes
- Learning Apso + BetterAuth
- Domain-specific apps with custom data models

### Entities Included

| Entity | Purpose |
|--------|---------|
| `User` | Authentication user |
| `account` | OAuth providers |
| `session` | Active sessions |
| `verification` | Email verification |
| `Organization` | Multi-tenant root |
| `AccountUser` | User-org junction |

### Usage

```bash
cp .devENV/setup/templates/minimal-saas-betterauth.json backend/.apsorc
```

### Extending

Add your domain entities:

```json
{
  "entities": {
    // ... existing entities ...

    "Project": {
      "fields": {
        "id": { "type": "uuid", "primary": true },
        "organizationId": { "type": "uuid" },
        "name": { "type": "string", "required": true },
        "status": { "type": "string", "default": "active" }
      },
      "relationships": [
        {
          "type": "manyToOne",
          "relatedEntity": "Organization",
          "foreignKey": "organizationId"
        }
      ]
    }
  }
}
```

---

## Complete SaaS

**File:** `templates/complete-saas-betterauth.json`

**Best for:**
- B2B SaaS products
- Enterprise applications
- SOC2/GDPR compliance needs
- Production-ready foundations

### Entities Included

Everything in Minimal, plus:

| Entity | Purpose |
|--------|---------|
| `Subscription` | Stripe subscription tracking |
| `Invoice` | Billing history |
| `ApiKey` | API key management |
| `AuditLog` | Security/compliance logging |
| `Invitation` | Team member invitations |

### Features

- **Stripe-ready billing** - Subscription + Invoice entities
- **Audit logging** - Track sensitive actions
- **API key management** - External integrations
- **Team invitations** - Role-based access
- **Soft deletes** - Data retention compliance
- **Production indexes** - Optimized queries

### Usage

```bash
cp .devENV/setup/templates/complete-saas-betterauth.json backend/.apsorc
```

---

## BetterAuth Required Tables

Both templates include these tables (required by BetterAuth):

| Table | Case | Fields |
|-------|------|--------|
| `User` | PascalCase | email, emailVerified, name |
| `session` | lowercase | token, expiresAt, userId |
| `account` | lowercase | providerId, accountId, password |
| `verification` | lowercase | identifier, value, expiresAt |

!!! warning "Do Not Rename"
    BetterAuth expects these exact table names. Don't rename them.

---

## Multi-Tenancy Pattern

Both templates implement multi-tenancy via:

1. **Organization** - Tenant entity
2. **AccountUser** - Links users to orgs with roles
3. **Foreign keys** - All business entities have `organizationId`

```typescript
// Access control pattern
const tasks = await db.select()
  .from(Task)
  .where(eq(Task.organizationId, currentOrg.id));
```

---

## Common Customizations

### Adding Entity

```json
{
  "name": "Task",
  "fields": [
    { "name": "id", "type": "string", "primaryKey": true },
    { "name": "organizationId", "type": "string" },
    { "name": "title", "type": "string" },
    { "name": "status", "type": "string" },
    { "name": "createdAt", "type": "date" }
  ],
  "relationships": [
    {
      "type": "manyToOne",
      "relatedEntity": "Organization",
      "foreignKey": "organizationId"
    }
  ]
}
```

### Adding Soft Deletes

```json
{
  "name": "deletedAt",
  "type": "date",
  "optional": true
}
```

### Adding Indexes

```json
{
  "indexes": [
    {
      "fields": ["organizationId", "createdAt"],
      "comment": "List by org chronologically"
    }
  ]
}
```

---

## Field Types

| Type | Database | Use For |
|------|----------|---------|
| `string` | VARCHAR | Text, IDs, emails |
| `number` | INTEGER | Counts, amounts |
| `boolean` | BOOLEAN | Flags |
| `date` | TIMESTAMP | Dates |
| `json` | JSONB | Metadata |

---

## Migration: Minimal → Complete

To upgrade from Minimal to Complete:

1. Copy missing entities from Complete template
2. Add audit fields to existing entities
3. Generate migration

```bash
npx apso migrate create add-billing-entities
npx apso migrate up
```

---

## Regenerating Code

After modifying `.apsorc`:

```bash
cd backend
apso server scaffold
npm run start:dev
```

!!! warning "Custom Code"
    Custom code in `extensions/` is safe. Code in `autogen/` is overwritten.

---

# Document Templates

Templates for project documentation, generated by the Mavric toolchain.

---

## Available Document Templates

| Template | Purpose | Created By |
|----------|---------|------------|
| `constitution.md` | Project principles | `/init` |
| `discovery-template.md` | Requirements structure | `discovery-interviewer` |
| `technical-plan.md` | Architecture decisions | `/plan` |
| `roadmap-template.md` | Phased delivery | orchestrator |
| `scenario-template.feature` | Gherkin test format | `test-generator` |
| `quickstart.md` | Critical path validation | orchestrator |
| `verification-report.md` | Consistency report | `/verify` |

---

## Constitution

The constitution establishes immutable project principles:

- **Article I:** Discovery-First - Requirements before code
- **Article II:** Test-First - Tests before implementation
- **Article III:** Multi-Tenancy - Organization-scoped data
- **Article IV:** Type Safety - TypeScript everywhere
- **Article V:** Security - Protected by default
- **Article VI:** Simplicity - Simple over clever
- **Article VII:** Documentation - Maintained alongside code
- **Article VIII:** Progressive Delivery - Ship incrementally
- **Article IX:** Integration Testing - Real systems when possible

---

## Customizing Document Templates

### Copy to Your Project

```bash
# Copy constitution template
cp devenv/.claude/templates/constitution.md my-project/.claude/templates/

# Edit for your project's needs
# The toolchain will use your customized version
```

### Template Variables

Templates use `[PLACEHOLDER]` syntax:

| Variable | Replaced With |
|----------|---------------|
| `[PROJECT_NAME]` | Your project name |
| `[DATE]` | Current date |
| `[USER_NAME]` | Stakeholder name |
| `[ENTITY]` | Entity name (dynamic) |
| `[WORKFLOW]` | Workflow name (dynamic) |

---

## Template Locations

```
# Source templates (in devenv)
devenv/.claude/templates/
├── constitution.md
├── discovery-template.md
├── technical-plan.md
├── roadmap-template.md
├── scenario-template.feature
├── quickstart.md
├── verification-report.md
└── README.md

# Project templates (customized)
my-project/.claude/templates/
└── [your customized templates]
```

---

## See Also

- [/init](../commands/init.md) - Initialize project with templates
- [Project Structure](../concepts/project-structure.md) - Directory layout
