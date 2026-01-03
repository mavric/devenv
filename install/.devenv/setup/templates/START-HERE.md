# Start Here: Apso + BetterAuth Templates

Welcome! This collection provides production-ready `.apsorc` templates for building SaaS applications with BetterAuth authentication.

---

## What You Get

Two professionally designed templates:

1. **Minimal SaaS Template** - 6 entities for MVPs and custom SaaS
2. **Complete SaaS Template** - 11 entities for B2B SaaS with billing

Plus comprehensive documentation to help you choose and customize.

---

## 60-Second Quick Start

```bash
# 1. Choose template (see below)
cp apsorc-templates/minimal-saas-betterauth.json .apsorc

# 2. Generate backend
npx apso generate

# 3. Run migrations
npx apso migrate up

# 4. Start coding
npm run dev
```

You now have:
- Multi-tenant database schema
- BetterAuth authentication
- Type-safe API endpoints
- Drizzle ORM models

---

## Which Template Should I Use?

### Quick Decision

**Building an MVP?** → Use Minimal Template
**Charging customers?** → Use Complete Template
**Still unsure?** → Use Minimal (easier to upgrade later)

### Detailed Decision

Read `TEMPLATE-SELECTOR.md` for an interactive wizard that asks:
- Are you charging customers?
- Do you need subscription billing?
- Do customers work in teams?
- Do you need audit logging?
- Will you offer API access?

---

## Template Comparison

| Feature | Minimal | Complete |
|---------|---------|----------|
| Entities | 6 | 11 |
| Size | 8.3 KB | 23 KB |
| Auth (BetterAuth) | ✓ | ✓ |
| Multi-Tenancy | ✓ | ✓ |
| Stripe Billing | - | ✓ |
| API Keys | - | ✓ |
| Audit Logging | - | ✓ |
| Team Invites | - | ✓ |
| **Best For** | MVPs | B2B SaaS |

---

## What's Included in Both Templates

### BetterAuth Tables (4)
- `user` - Authentication accounts
- `session` - Active sessions
- `account` - OAuth providers
- `verification` - Email/password reset tokens

### Multi-Tenancy (2)
- `Organization` - Tenant workspaces
- `AccountUser` - User-to-org memberships with roles

---

## What's ONLY in Complete Template

- `Subscription` - Stripe billing plans
- `Invoice` - Payment history
- `ApiKey` - API access credentials
- `AuditLog` - Security audit trail
- `Invitation` - Team member invitations

---

## Documentation Guide

### Start Here
1. **START-HERE.md** (this file) - Quick orientation
2. **TEMPLATE-SELECTOR.md** - Interactive decision wizard

### Essential Reading
3. **README.md** - Complete template documentation
4. **INDEX.md** - File navigation and overview

### Reference Guides
5. **QUICK-REFERENCE.md** - Side-by-side comparisons
6. **ENTITY-DIAGRAMS.md** - Visual architecture diagrams

---

## File Structure

```
apsorc-templates/
│
├── Templates (copy one to .apsorc)
│   ├── minimal-saas-betterauth.json     (6 entities)
│   └── complete-saas-betterauth.json    (11 entities)
│
├── Getting Started
│   ├── START-HERE.md                    (you are here)
│   ├── TEMPLATE-SELECTOR.md             (decision wizard)
│   └── INDEX.md                         (navigation)
│
├── Documentation
│   ├── README.md                        (full guide)
│   ├── QUICK-REFERENCE.md               (comparisons)
│   └── ENTITY-DIAGRAMS.md               (architecture)
│
└── Validation
    └── VALIDATION.md                    (quality checks)
```

---

## Reading Order

**If you're in a hurry (5 minutes):**
1. Read this file (START-HERE.md)
2. Copy minimal template
3. Run `npx apso generate`
4. Start coding

**If you want to choose wisely (15 minutes):**
1. Read START-HERE.md (this file)
2. Read TEMPLATE-SELECTOR.md
3. Skim QUICK-REFERENCE.md
4. Copy chosen template
5. Run `npx apso generate`

**If you want deep understanding (1 hour):**
1. Read all documentation in order
2. Study ENTITY-DIAGRAMS.md
3. Compare both templates
4. Customize for your needs
5. Generate and migrate

---

## Common Questions

### Q: Can I customize these templates?
**A:** Yes! They're starting points. Add your own entities to the `.apsorc` file.

### Q: What if I choose the wrong template?
**A:** You can migrate from Minimal → Complete later. See README.md for instructions.

### Q: Do I need to know BetterAuth?
**A:** No. The templates handle the schema. Follow BetterAuth docs for configuration.

### Q: Can I use this in production?
**A:** Yes! These are production-ready templates tested in real SaaS applications.

### Q: What databases are supported?
**A:** PostgreSQL (recommended), MySQL, SQLite. Apso generates the right migrations.

### Q: Is this free to use?
**A:** Yes! MIT licensed. Use in any project, commercial or personal.

---

## Next Steps

### 1. Choose Your Template

**Minimal Template**
```bash
cp apsorc-templates/minimal-saas-betterauth.json .apsorc
```

**Complete Template**
```bash
cp apsorc-templates/complete-saas-betterauth.json .apsorc
```

### 2. Review the Entities

```bash
# List entities
cat .apsorc | jq -r '.entities[].name'

# View structure
cat .apsorc | jq '.'
```

### 3. Generate Backend

```bash
npx apso generate
```

This creates:
- `backend/src/db/schema.ts` - Drizzle models
- `backend/src/db/migrations/` - SQL migrations
- `backend/src/routes/` - API endpoints
- Type definitions

### 4. Configure Database

Edit `backend/.env`:
```env
DATABASE_URL=postgresql://user:pass@localhost:5432/mydb
```

### 5. Run Migrations

```bash
cd backend
npx apso migrate up
```

### 6. Configure BetterAuth

Edit `backend/src/auth.ts` to add OAuth providers:
```typescript
export const auth = betterAuth({
  database: db,
  emailAndPassword: {
    enabled: true,
  },
  socialProviders: {
    google: {
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    },
  },
});
```

### 7. Start Building

```bash
npm run dev
```

Your API is now running with:
- Multi-tenant data isolation
- BetterAuth authentication
- Type-safe database access
- RESTful endpoints

---

## Example Customization

Add a custom entity to either template:

```json
{
  "name": "Task",
  "comment": "Todo tasks for organizations",
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
      "name": "completed",
      "type": "boolean"
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

Add this to `.apsorc` in the `entities` array, then:
```bash
npx apso generate
npx apso migrate create add-tasks
npx apso migrate up
```

---

## Multi-Tenancy Pattern

Both templates implement row-level multi-tenancy:

```typescript
// All queries automatically filter by organization
const tasks = await db.select()
  .from(Task)
  .where(eq(Task.organizationId, currentOrg.id));

// Users can belong to multiple organizations
const userOrgs = await db.select()
  .from(AccountUser)
  .where(eq(AccountUser.userId, currentUser.id));
```

This ensures:
- Complete data isolation between tenants
- Users can switch between organizations
- Role-based access control per organization

---

## Authentication Flow

```
1. User signs up/in (BetterAuth)
   ↓
2. Session created
   ↓
3. Get user's organizations (AccountUser)
   ↓
4. User selects active organization
   ↓
5. All requests scoped to that organization
```

The templates handle the database schema. You implement the auth flow in your frontend/backend code.

---

## Production Checklist

Before deploying:

- [ ] Configure OAuth providers (Google, GitHub, etc)
- [ ] Set up email service (for verification/reset)
- [ ] Configure session duration
- [ ] Set up database backups
- [ ] Add rate limiting
- [ ] Configure CORS
- [ ] Set up monitoring
- [ ] Add error logging
- [ ] Review security headers
- [ ] Test multi-tenancy isolation

See README.md for detailed security best practices.

---

## Support

### Documentation
- Full guide: `README.md`
- Decision help: `TEMPLATE-SELECTOR.md`
- Quick reference: `QUICK-REFERENCE.md`
- Architecture: `ENTITY-DIAGRAMS.md`

### External Resources
- [Apso Docs](https://apsolib.com)
- [BetterAuth Docs](https://better-auth.com)
- [Drizzle ORM Docs](https://orm.drizzle.team)

### Community
- GitHub: [github.com/apsolib/apso](https://github.com/apsolib/apso)
- Discord: Join for help and discussions
- Issues: Report bugs or request features

---

## What to Read Next

**If you chose Minimal Template:**
→ Read README.md section "Extending Minimal Template"

**If you chose Complete Template:**
→ Read ENTITY-DIAGRAMS.md for Stripe billing flow

**If you're still deciding:**
→ Read TEMPLATE-SELECTOR.md for interactive guidance

**If you want to understand the architecture:**
→ Read ENTITY-DIAGRAMS.md for visual ERDs

---

## Success Stories

These templates are based on patterns from:
- Production SaaS applications
- Community best practices
- Real-world scaling challenges
- Security audit requirements

You're starting with battle-tested foundations.

---

## Final Tips

1. **Start simple** - Use Minimal if unsure
2. **Read comments** - Every field is documented
3. **Customize freely** - Add your domain entities
4. **Test multi-tenancy** - Ensure data isolation works
5. **Follow conventions** - PascalCase for custom entities
6. **Join community** - Get help when stuck

---

## Ready to Build?

```bash
# Copy template
cp apsorc-templates/minimal-saas-betterauth.json .apsorc

# Generate
npx apso generate

# Migrate
npx apso migrate up

# Build something amazing
npm run dev
```

You're now ready to build a production-ready SaaS application!

---

**Questions?** Read the other docs or join the community.

**Ready to start?** Run the commands above and start coding.

**Good luck building!**
