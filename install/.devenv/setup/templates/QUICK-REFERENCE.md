# Quick Reference: Template Comparison

## Template Overview

| Feature | Minimal | Complete |
|---------|---------|----------|
| **File Size** | 8.3 KB | 23 KB |
| **Entities** | 6 | 12 |
| **Use Case** | MVPs, custom SaaS | Standard B2B SaaS |
| **Setup Time** | 5 minutes | 10 minutes |
| **Stripe Ready** | No | Yes |
| **Audit Logging** | No | Yes |

---

## Entity Comparison

### Core Entities (Both Templates)

| Entity | Purpose | Key Relationships |
|--------|---------|-------------------|
| `user` | BetterAuth accounts | → session, account |
| `session` | Active sessions | → user |
| `account` | OAuth providers | → user |
| `verification` | Email/password reset | (standalone) |
| `Organization` | Tenant/workspace | ← AccountUser |
| `AccountUser` | User-to-org membership | → user, Organization |

### Additional Entities (Complete Only)

| Entity | Purpose | Key Relationships |
|--------|---------|-------------------|
| `Subscription` | Billing plans | → Organization |
| `Invoice` | Payment history | → Organization, Subscription |
| `ApiKey` | API access tokens | → Organization, user |
| `AuditLog` | Security audit trail | → Organization, user |
| `Invitation` | Team invitations | → Organization, user |

---

## Field Counts

### Minimal Template
- **user:** 7 fields
- **session:** 8 fields
- **account:** 10 fields
- **verification:** 6 fields
- **Organization:** 5 fields
- **AccountUser:** 6 fields

**Total:** 42 fields across 6 entities

### Complete Template
- **All minimal fields** +
- **Subscription:** 13 fields
- **Invoice:** 14 fields
- **ApiKey:** 11 fields
- **AuditLog:** 10 fields
- **Invitation:** 11 fields

**Total:** 101 fields across 12 entities

---

## When to Upgrade from Minimal to Complete

### Signs You Need Complete Template:

1. **You need billing**
   - Charging customers monthly/annually
   - Managing subscriptions
   - Generating invoices

2. **You need API access**
   - Customers want programmatic access
   - Building integrations/webhooks
   - Need API key management

3. **You need compliance**
   - SOC2, GDPR, HIPAA requirements
   - Audit trail for security
   - Track all user actions

4. **You have teams**
   - Users invite team members
   - Role-based access control
   - Pending invitation management

### Stick with Minimal if:

- You're pre-revenue (no billing yet)
- API access isn't required
- Compliance isn't a concern
- Single-user accounts only
- You want to iterate fast

---

## Migration Path: Minimal → Complete

### Step 1: Copy Missing Entities

From `complete-saas-betterauth.json`, copy entities you need:

```bash
# Extract specific entities with jq
cat complete-saas-betterauth.json | jq '.entities[] | select(.name == "Subscription")'
```

### Step 2: Add to .apsorc

Paste into your `.apsorc` entities array.

### Step 3: Generate Migration

```bash
npx apso migrate create add-subscriptions
npx apso migrate up
```

### Recommended Addition Order:

1. **Subscription** → Start charging customers
2. **Invoice** → Track payment history
3. **Invitation** → Enable team features
4. **ApiKey** → Launch API access
5. **AuditLog** → Add for compliance

---

## Feature Matrix

| Feature | Minimal | Complete | Notes |
|---------|---------|----------|-------|
| Email/Password Auth | ✓ | ✓ | Via BetterAuth |
| OAuth (Google, GitHub) | ✓ | ✓ | Via BetterAuth |
| Multi-tenancy | ✓ | ✓ | Organization entity |
| Role-based Access | Basic | Advanced | Complete has invitation flow |
| Stripe Billing | - | ✓ | Subscription + Invoice |
| API Keys | - | ✓ | Hashed key storage |
| Audit Logging | - | ✓ | Compliance-ready |
| Soft Deletes | - | ✓ | On critical entities |
| Team Invitations | - | ✓ | Email invite flow |

---

## Database Size Estimates

### Minimal Template
**Empty database:** ~5 MB
**10,000 users:** ~50 MB
**100,000 users:** ~500 MB

### Complete Template
**Empty database:** ~8 MB
**10,000 users + billing:** ~100 MB
**100,000 users + billing:** ~1 GB

*Estimates include indexes and metadata*

---

## API Endpoint Count

After `npx apso generate`:

### Minimal Template
- `/api/users` (CRUD)
- `/api/organizations` (CRUD)
- `/api/account-users` (CRUD)
- Auth endpoints (BetterAuth)

**Total:** ~15 endpoints

### Complete Template
- All minimal endpoints +
- `/api/subscriptions` (CRUD)
- `/api/invoices` (Read-only)
- `/api/api-keys` (CRUD)
- `/api/audit-logs` (Read-only)
- `/api/invitations` (CRUD)

**Total:** ~35 endpoints

---

## Index Count

### Minimal Template: 3 indexes
- `AccountUser(userId, organizationId)` - unique
- `AccountUser(organizationId)` - filter
- `Organization(slug)` - unique

### Complete Template: 15+ indexes
- All minimal indexes +
- Subscription lookups (3)
- Invoice queries (3)
- API key auth (3)
- Audit log filters (4)
- Invitation lookups (3)

---

## Performance Considerations

### Minimal Template
- **Pros:** Lightweight, fast writes, simple queries
- **Cons:** Manual index management for growth
- **Best for:** <100K users, simple data model

### Complete Template
- **Pros:** Optimized for common SaaS queries, pre-indexed
- **Cons:** More disk space, slightly slower writes
- **Best for:** >100K users, complex queries, compliance

---

## Security Features

| Security Feature | Minimal | Complete |
|------------------|---------|----------|
| Hashed passwords | ✓ | ✓ |
| Session management | ✓ | ✓ |
| OAuth tokens | ✓ | ✓ |
| API key hashing | - | ✓ |
| Audit trail | - | ✓ |
| IP tracking | Session only | Full audit |
| Soft deletes | - | ✓ |
| Token expiration | Verification | All tokens |

---

## Cost Implications

### Minimal Template
- **Database:** $10-50/month (Postgres on Vercel/Supabase)
- **Auth:** Free (BetterAuth is open source)
- **Total:** ~$10-50/month

### Complete Template
- **Database:** $20-100/month (larger storage for audit logs)
- **Auth:** Free
- **Stripe:** 2.9% + 30¢ per transaction
- **Total:** ~$20-100/month + payment processing

---

## Quick Decision Guide

### Choose Minimal if:
```
[ ] Building MVP
[ ] Pre-revenue
[ ] Custom data model
[ ] Learning Apso
[ ] Want to iterate fast
```

### Choose Complete if:
```
[ ] Launching with billing
[ ] B2B SaaS product
[ ] Need compliance (SOC2, GDPR)
[ ] Team collaboration features
[ ] API access required
```

### Not sure?
**Start with Minimal.** You can always add entities later.

---

## Common Customizations by Template

### Minimal Template Users Typically Add:
1. Domain-specific entities (Products, Projects, etc)
2. File uploads entity
3. Notification preferences
4. Custom user fields

### Complete Template Users Typically Add:
1. Usage/metering data
2. Feature flags
3. Webhooks
4. Data exports

---

## Template File Locations

```
apsorc-templates/
├── minimal-saas-betterauth.json    # 8.3 KB
├── complete-saas-betterauth.json   # 23 KB
├── README.md                        # 9.7 KB (full guide)
└── QUICK-REFERENCE.md              # This file
```

## Getting Started

```bash
# Choose template
cp apsorc-templates/minimal-saas-betterauth.json .apsorc
# OR
cp apsorc-templates/complete-saas-betterauth.json .apsorc

# Generate backend
npx apso generate

# Start development
npm run dev
```

---

## Support

- Full guide: See `README.md` in this directory
- Apso docs: https://apsolib.com
- BetterAuth docs: https://better-auth.com
