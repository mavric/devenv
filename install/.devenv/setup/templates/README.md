# Apso + BetterAuth Templates

Production-ready `.apsorc` templates for building SaaS applications with BetterAuth authentication.

## Which Template Should I Use?

### Minimal SaaS Template (`minimal-saas-betterauth.json`)

**Use this when:**
- Starting a new SaaS project from scratch
- You want clean foundations to build on
- Your data model is unique and doesn't fit standard SaaS patterns
- You prefer to add features incrementally

**What's included:**
- BetterAuth core tables (user, session, account, verification)
- Organization entity (for multi-tenancy)
- AccountUser junction table (user-to-org relationships)
- Basic fields only, ready to extend

**Perfect for:**
- MVPs and prototypes
- Domain-specific SaaS (vertical SaaS)
- Projects with custom billing/subscription logic
- Learning Apso + BetterAuth integration

---

### Complete SaaS Template (`complete-saas-betterauth.json`)

**Use this when:**
- Building a standard B2B SaaS product
- You need billing/subscriptions out of the box
- You want team collaboration features (invitations, roles)
- Compliance requires audit logging

**What's included:**
Everything in Minimal, PLUS:
- Subscription management (Stripe integration ready)
- Invoice tracking
- API key management
- Audit logging (security compliance)
- Team invitations
- Soft deletes on critical entities
- Production-grade indexes

**Perfect for:**
- B2B SaaS products
- Enterprise applications
- Projects requiring SOC2/GDPR compliance
- Teams building standard SaaS features

---

## Quick Start

### 1. Choose Your Template

```bash
# Copy minimal template
cp apsorc-templates/minimal-saas-betterauth.json .apsorc

# OR copy complete template
cp apsorc-templates/complete-saas-betterauth.json .apsorc
```

### 2. Customize (Optional)

Edit `.apsorc` to:
- Add domain-specific entities
- Modify field names/types
- Add custom relationships
- Configure indexes for your access patterns

### 3. Generate Backend

```bash
npx apso generate
```

This creates:
- Database schema and migrations
- Drizzle ORM models
- Type-safe API endpoints
- Database client configuration

---

## Template Details

### BetterAuth Required Tables

Both templates include these tables (DO NOT rename):

| Table | Purpose | Key Fields |
|-------|---------|------------|
| `user` | Authentication accounts | email, emailVerified, name |
| `session` | Active sessions | token, expiresAt, userId |
| `account` | OAuth providers | providerId, accountId, password |
| `verification` | Email/password reset | identifier, value, expiresAt |

### Multi-Tenancy Setup

Both templates support multi-tenancy via:

1. **Organization** - Your tenant entity
2. **AccountUser** - Links users to orgs with roles
3. **Foreign keys** - All business entities reference `organizationId`

**Access control pattern:**
```typescript
// Always filter by organization
const tasks = await db.select()
  .from(Task)
  .where(eq(Task.organizationId, currentOrg.id));
```

---

## Common Customizations

### Adding a New Entity

```json
{
  "name": "Task",
  "comment": "Todo tasks owned by organizations",
  "fields": [
    {
      "name": "id",
      "type": "string",
      "primaryKey": true
    },
    {
      "name": "organizationId",
      "type": "string",
      "comment": "Foreign key for multi-tenancy"
    },
    {
      "name": "title",
      "type": "string"
    },
    {
      "name": "createdAt",
      "type": "date"
    }
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

Add to any entity:
```json
{
  "name": "deletedAt",
  "type": "date",
  "optional": true,
  "comment": "Soft delete timestamp"
}
```

### Adding Audit Fields

Standard timestamp pattern:
```json
{
  "name": "createdAt",
  "type": "date",
  "comment": "Creation timestamp"
},
{
  "name": "updatedAt",
  "type": "date",
  "comment": "Last update timestamp"
}
```

---

## Entity Naming Conventions

**BetterAuth tables:** lowercase (required by BetterAuth)
- `user`, `session`, `account`, `verification`

**Your entities:** PascalCase (recommended)
- `Organization`, `AccountUser`, `Subscription`, `Invoice`

**Why?** BetterAuth expects specific table names. Your custom entities use PascalCase for consistency with TypeScript models.

---

## Field Types Reference

| Type | Database Type | Use For |
|------|---------------|---------|
| `string` | VARCHAR/TEXT | Text, IDs, emails |
| `number` | INTEGER/BIGINT | Counts, amounts (cents) |
| `boolean` | BOOLEAN | Flags, status |
| `date` | TIMESTAMP | Dates, timestamps |
| `json` | JSONB | Metadata, flexible data |

---

## Index Strategies

### When to Add Indexes

**Always index:**
- Foreign keys (for joins)
- Unique constraints (email, slug)
- Query filters (status, role)
- Sort fields (createdAt)

**Example:**
```json
"indexes": [
  {
    "fields": ["organizationId", "createdAt"],
    "comment": "List org tasks chronologically"
  },
  {
    "fields": ["status"],
    "comment": "Filter by task status"
  }
]
```

**Don't over-index:** Each index adds write overhead. Only index fields you query frequently.

---

## Multi-Tenancy Patterns

### Pattern 1: Organization-Scoped Data

**Best for:** Most SaaS features
```json
{
  "name": "Project",
  "fields": [
    {
      "name": "organizationId",
      "type": "string"
    }
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

### Pattern 2: User-Owned Data

**Best for:** Personal settings, preferences
```json
{
  "name": "UserPreference",
  "fields": [
    {
      "name": "userId",
      "type": "string"
    }
  ],
  "relationships": [
    {
      "type": "manyToOne",
      "relatedEntity": "user",
      "foreignKey": "userId"
    }
  ]
}
```

---

## Subscription/Billing Notes

The **Complete Template** includes Stripe-ready entities:

### Subscription
- Tracks plan, status, renewal dates
- Synced via Stripe webhooks
- One-to-one with Organization

### Invoice
- Historical billing records
- PDF/URL links from Stripe
- Enables customer billing portal

### Webhook Setup Required
```typescript
// backend/src/webhooks/stripe.ts
stripe.webhooks.construct(
  request.body,
  signature,
  process.env.STRIPE_WEBHOOK_SECRET
);
```

---

## Security Best Practices

### 1. Never Store Plaintext Secrets
```json
{
  "name": "password",
  "type": "string",
  "comment": "ALWAYS hash with bcrypt/argon2"
},
{
  "name": "key",
  "type": "string",
  "comment": "Hash API keys, show plaintext once"
}
```

### 2. Use Audit Logging
Track sensitive actions:
- User role changes
- Data exports
- Payment method updates
- Organization deletions

### 3. Implement Soft Deletes
Enables:
- Accidental deletion recovery
- Compliance with data retention policies
- Audit trails

---

## Migration Strategy

### Starting from Minimal → Complete

1. **Copy missing entities** from complete template
2. **Add audit fields** to existing entities
3. **Create migration** with `npx apso migrate`
4. **Test thoroughly** before production

### Database Migrations

Apso generates migrations automatically:
```bash
# Generate migration
npx apso migrate create add-subscriptions

# Apply migration
npx apso migrate up
```

---

## Common Questions

### Q: Can I rename BetterAuth tables?
**A:** No. BetterAuth expects exact names: `user`, `session`, `account`, `verification`.

### Q: Should I use soft deletes everywhere?
**A:** Only on entities where you need recovery/audit trails. Skip for temporary data (sessions, tokens).

### Q: How do I add email/username login?
**A:** BetterAuth includes this by default. Configure providers in `backend/src/auth.ts`.

### Q: Can I use MongoDB instead of Postgres?
**A:** Apso supports PostgreSQL, MySQL, SQLite. BetterAuth supports those + MongoDB (requires adapter).

### Q: Where do I add custom user fields?
**A:** Add to `user` entity in `.apsorc`. BetterAuth allows custom fields.

---

## Example: Extending Minimal Template

Add a Task entity for a todo app:

```json
{
  "name": "Task",
  "comment": "User tasks within organizations",
  "fields": [
    {
      "name": "id",
      "type": "string",
      "primaryKey": true
    },
    {
      "name": "organizationId",
      "type": "string",
      "comment": "Multi-tenancy: task belongs to org"
    },
    {
      "name": "title",
      "type": "string",
      "comment": "Task title/description"
    },
    {
      "name": "status",
      "type": "string",
      "comment": "todo, in_progress, done"
    },
    {
      "name": "assignedTo",
      "type": "string",
      "optional": true,
      "comment": "User ID (from AccountUser)"
    },
    {
      "name": "createdAt",
      "type": "date"
    },
    {
      "name": "updatedAt",
      "type": "date"
    }
  ],
  "relationships": [
    {
      "type": "manyToOne",
      "relatedEntity": "Organization",
      "foreignKey": "organizationId"
    },
    {
      "type": "manyToOne",
      "relatedEntity": "user",
      "foreignKey": "assignedTo"
    }
  ],
  "indexes": [
    {
      "fields": ["organizationId", "status"],
      "comment": "List tasks by org and status"
    },
    {
      "fields": ["assignedTo"],
      "comment": "Find user's assigned tasks"
    }
  ]
}
```

Then regenerate:
```bash
npx apso generate
npx apso migrate up
```

---

## Resources

- [Apso Documentation](https://apsolib.com)
- [BetterAuth Docs](https://better-auth.com)
- [Multi-Tenancy Guide](https://apsolib.com/guides/multi-tenancy)
- [Database Schema Design](https://apsolib.com/guides/schema-design)

---

## Support

Found a bug or have questions?
- GitHub Issues: [apsolib/apso](https://github.com/apsolib/apso)
- Discord: [Join community](https://discord.gg/apso)
- Docs: [apsolib.com/docs](https://apsolib.com/docs)

---

## License

These templates are MIT licensed. Use freely in your projects.
