# Apso + BetterAuth Template Collection

Production-ready `.apsorc` templates for building multi-tenant SaaS applications with BetterAuth authentication.

---

## Templates

### 1. Minimal SaaS Template
**File:** `minimal-saas-betterauth.json` (8.3 KB)
**Entities:** 6 (user, session, account, verification, Organization, AccountUser)
**Best for:** MVPs, custom SaaS, pre-revenue products

### 2. Complete SaaS Template
**File:** `complete-saas-betterauth.json` (23 KB)
**Entities:** 11 (all minimal + Subscription, Invoice, ApiKey, AuditLog, Invitation)
**Best for:** B2B SaaS, billing-enabled products, compliance requirements

---

## Quick Start

```bash
# 1. Choose template
cp apsorc-templates/minimal-saas-betterauth.json .apsorc
# OR
cp apsorc-templates/complete-saas-betterauth.json .apsorc

# 2. Generate backend
npx apso generate

# 3. Start development
npm run dev
```

---

## Documentation Files

### Essential Reading

1. **README.md** (9.7 KB)
   - Full template documentation
   - When to use each template
   - Common customizations
   - Field type reference
   - Migration strategies
   - Security best practices

2. **TEMPLATE-SELECTOR.md** (8.8 KB)
   - Interactive decision wizard
   - Use case examples
   - Feature checklist
   - Timeline recommendations
   - Team size guidance

### Reference Guides

3. **QUICK-REFERENCE.md** (7.2 KB)
   - Side-by-side template comparison
   - Feature matrix
   - Migration path (Minimal → Complete)
   - Performance considerations
   - Database size estimates

4. **ENTITY-DIAGRAMS.md** (19 KB)
   - Visual ERD diagrams
   - Multi-tenancy patterns
   - Data flow visualizations
   - Access control layers
   - Billing and API flows

5. **INDEX.md** (this file)
   - Table of contents
   - Quick navigation
   - File summaries

---

## Template Comparison

| Feature | Minimal | Complete |
|---------|---------|----------|
| **File Size** | 8.3 KB | 23 KB |
| **Entities** | 6 | 11 |
| **BetterAuth Core** | ✓ | ✓ |
| **Multi-Tenancy** | ✓ | ✓ |
| **Subscription Billing** | - | ✓ |
| **API Keys** | - | ✓ |
| **Audit Logging** | - | ✓ |
| **Team Invitations** | - | ✓ |
| **Soft Deletes** | - | ✓ |
| **Use Case** | MVP, Custom | B2B, Enterprise |

---

## Entity Breakdown

### Both Templates (Core)
```
user            - BetterAuth authentication accounts
session         - Active user sessions
account         - OAuth provider connections
verification    - Email/password reset tokens
Organization    - Multi-tenant workspaces
AccountUser     - User-to-organization memberships
```

### Complete Template Only (Additional)
```
Subscription    - Stripe billing plans
Invoice         - Payment history records
ApiKey          - API access credentials
AuditLog        - Security audit trail
Invitation      - Team member invitations
```

---

## Which Template to Use?

### Use Minimal Template if you:
- Are building an MVP
- Have a unique/custom data model
- Are pre-revenue (no billing yet)
- Want to iterate quickly
- Are learning Apso + BetterAuth

### Use Complete Template if you:
- Need subscription billing (Stripe)
- Are building standard B2B SaaS
- Need compliance (SOC2, GDPR, HIPAA)
- Require API access for customers
- Want team collaboration features

### Still unsure?
**Default to Minimal.** It's easier to add entities later than remove them.

See `TEMPLATE-SELECTOR.md` for an interactive decision wizard.

---

## File Navigation

```
apsorc-templates/
├── minimal-saas-betterauth.json    ← Copy this to .apsorc
├── complete-saas-betterauth.json   ← Or copy this to .apsorc
│
├── README.md                        ← Start here (full guide)
├── TEMPLATE-SELECTOR.md             ← Decision wizard
├── QUICK-REFERENCE.md               ← Quick comparisons
├── ENTITY-DIAGRAMS.md               ← Visual architecture
└── INDEX.md                         ← You are here
```

---

## Common Workflows

### 1. Starting a New Project
```bash
# Read template selector
cat apsorc-templates/TEMPLATE-SELECTOR.md

# Choose template
cp apsorc-templates/minimal-saas-betterauth.json .apsorc

# Generate
npx apso generate
```

### 2. Comparing Templates
```bash
# List entities in each
cat apsorc-templates/minimal-saas-betterauth.json | jq '.entities[].name'
cat apsorc-templates/complete-saas-betterauth.json | jq '.entities[].name'

# View differences
diff <(cat minimal-saas-betterauth.json | jq -S) \
     <(cat complete-saas-betterauth.json | jq -S)
```

### 3. Customizing a Template
```bash
# Copy template
cp apsorc-templates/complete-saas-betterauth.json .apsorc

# Edit with your favorite editor
code .apsorc

# Add your custom entities to the "entities" array
# Then generate
npx apso generate
```

### 4. Upgrading Minimal to Complete
```bash
# Extract entities you need from complete template
cat apsorc-templates/complete-saas-betterauth.json | jq '.entities[] | select(.name == "Subscription")'

# Add to your existing .apsorc
# Then create migration
npx apso migrate create add-subscriptions
npx apso migrate up
```

---

## Key Features

### Multi-Tenancy Built-In
Both templates support multi-tenant architecture:
- Organizations as tenant entities
- AccountUser junction table for user-org relationships
- All business entities reference `organizationId`
- Row-level security patterns included

### BetterAuth Integration
Both templates use correct BetterAuth table names:
- `user` (lowercase) - required by BetterAuth
- `session` (lowercase) - required by BetterAuth
- `account` (lowercase) - required by BetterAuth
- `verification` (lowercase) - required by BetterAuth

Custom entities use PascalCase (e.g., Organization, AccountUser).

### Production-Ready
All templates include:
- Proper field types (string, number, date, boolean, json)
- Relationships and foreign keys
- Indexes for common queries
- Comments explaining every field
- Best practice patterns

---

## Example: Adding a Custom Entity

Add this to either template's `entities` array:

```json
{
  "name": "Project",
  "comment": "Customer projects within organizations",
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
      "name": "name",
      "type": "string",
      "comment": "Project display name"
    },
    {
      "name": "status",
      "type": "string",
      "comment": "active, completed, archived"
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
    }
  ],
  "indexes": [
    {
      "fields": ["organizationId", "status"],
      "comment": "List org projects by status"
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

## Template Validation

Both templates are:
- Valid JSON (tested with jq)
- Schema-compliant (.apsorc format)
- BetterAuth-compatible (correct table names)
- Production-tested
- Actively maintained

---

## Database Support

Both templates work with:
- PostgreSQL (recommended)
- MySQL/MariaDB
- SQLite (development only)

Apso generates database-specific migrations automatically.

---

## Authentication Providers

BetterAuth (included in both templates) supports:
- Email/Password
- Google OAuth
- GitHub OAuth
- Apple Sign In
- Microsoft Azure AD
- Custom OAuth providers

Configure in `backend/src/auth.ts` after generation.

---

## Next Steps After Choosing Template

1. **Copy template to .apsorc**
   ```bash
   cp apsorc-templates/[chosen-template].json .apsorc
   ```

2. **Review entities**
   - Read field comments
   - Understand relationships
   - Plan customizations

3. **Generate backend**
   ```bash
   npx apso generate
   ```

4. **Configure BetterAuth**
   - Set up OAuth providers
   - Configure email service
   - Set session duration

5. **Run migrations**
   ```bash
   npx apso migrate up
   ```

6. **Start building**
   - Add business logic
   - Create frontend UI
   - Connect to database

---

## Support & Resources

### Documentation
- Full guide: `README.md`
- Quick reference: `QUICK-REFERENCE.md`
- Decision help: `TEMPLATE-SELECTOR.md`
- Architecture: `ENTITY-DIAGRAMS.md`

### External Links
- [Apso Documentation](https://apsolib.com)
- [BetterAuth Docs](https://better-auth.com)
- [Multi-Tenancy Guide](https://apsolib.com/guides/multi-tenancy)

### Community
- GitHub: [apsolib/apso](https://github.com/apsolib/apso)
- Discord: [Join community](https://discord.gg/apso)
- Issues: [Report bugs](https://github.com/apsolib/apso/issues)

---

## Version Information

**Template Version:** 1.0.0
**Last Updated:** November 2025
**Compatible With:**
- Apso: 1.0.0+
- BetterAuth: 1.0.0+
- Node.js: 18+
- TypeScript: 5.0+

---

## License

These templates are MIT licensed. Use freely in your projects, commercial or personal.

---

## Contributing

Found an issue or want to improve the templates?

1. Open an issue on GitHub
2. Submit a pull request
3. Join the Discord community
4. Share your use case

---

## Acknowledgments

These templates combine best practices from:
- BetterAuth authentication patterns
- Apso multi-tenancy architecture
- Production SaaS applications
- Community feedback and testing

Built with love by the Apso community.
