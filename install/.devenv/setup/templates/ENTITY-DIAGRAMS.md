# Entity Relationship Diagrams

Visual representation of both templates showing relationships and multi-tenancy patterns.

---

## Minimal SaaS Template

```
┌─────────────────────────────────────────────────────────────┐
│                    BETTERAUTH CORE                          │
│                  (Authentication Layer)                      │
└─────────────────────────────────────────────────────────────┘

    ┌──────────┐
    │   user   │ (BetterAuth)
    ├──────────┤
    │ id       │──────┐
    │ email    │      │ 1:N
    │ name     │      ├─────────► ┌──────────┐
    │ verified │      │            │ session  │
    └──────────┘      │            ├──────────┤
         │            │            │ id       │
         │ 1:N        │            │ token    │
         │            │            │ userId   │──┐
         ├────────────┘            │ expiresAt│  │ N:1
         │                         └──────────┘  │
         │ 1:N                                   │
         ├─────────────────────────────┐         │
         │                             │         │
         ▼                             ▼         │
    ┌──────────┐                  ┌──────────┐  │
    │ account  │                  │verifica- │  │
    ├──────────┤                  │  tion    │  │
    │ id       │                  ├──────────┤  │
    │ userId   │──────────────────┤identifier│  │
    │ provider │                  │ value    │  │
    │ password │                  │ expiresAt│  │
    └──────────┘                  └──────────┘  │
         │                                       │
         │                                       │
┌────────┴───────────────────────────────────────┴────────┐
│                 MULTI-TENANCY LAYER                     │
│              (Organization Management)                  │
└─────────────────────────────────────────────────────────┘

         │
         │ N:1
         ▼
    ┌──────────────┐
    │AccountUser   │ (Junction Table)
    ├──────────────┤
    │ id           │
    │ userId       │──────┐ N:1
    │ orgId        │──┐   │
    │ role         │  │   │
    └──────────────┘  │   │
                      │   │
                 N:1  │   │
         ┌────────────┘   │
         ▼                │
    ┌──────────────┐      │
    │Organization  │◄─────┘
    ├──────────────┤
    │ id           │
    │ name         │
    │ slug         │
    └──────────────┘
         │
         │
         │  <── ADD YOUR ENTITIES HERE
         │      (Products, Projects, etc)
         │      All reference organizationId
         │
```

**Key Points:**
- 6 entities total
- BetterAuth handles auth (user, session, account, verification)
- Organization provides multi-tenancy
- AccountUser links users to orgs with roles
- Ready to extend with business entities

---

## Complete SaaS Template

```
┌─────────────────────────────────────────────────────────────┐
│                    BETTERAUTH CORE                          │
│                  (Same as Minimal)                          │
└─────────────────────────────────────────────────────────────┘

    [Same user/session/account/verification as above]

┌─────────────────────────────────────────────────────────────┐
│                 MULTI-TENANCY LAYER                         │
└─────────────────────────────────────────────────────────────┘

    ┌──────────────┐
    │Organization  │
    ├──────────────┤
    │ id           │◄─────────┬───────────┬──────────┬─────────┐
    │ name         │          │           │          │         │
    │ slug         │          │           │          │         │
    │ plan         │          │           │          │         │
    │ status       │          │ N:1       │ N:1      │ N:1     │
    │ deletedAt    │          │           │          │         │
    └──────────────┘          │           │          │         │
         │                    │           │          │         │
         │ 1:1                │           │          │         │
         ▼                    │           │          │         │
    ┌──────────────┐          │           │          │         │
    │Subscription  │          │           │          │         │
    ├──────────────┤          │           │          │         │
    │ id           │          │           │          │         │
    │ orgId        │          │           │          │         │
    │ stripeSubId  │          │           │          │         │
    │ plan         │          │           │          │         │
    │ status       │          │           │          │         │
    │ periodEnd    │          │           │          │         │
    └──────────────┘          │           │          │         │
         │                    │           │          │         │
         │ 1:N                │           │          │         │
         ▼                    │           │          │         │
    ┌──────────────┐          │           │          │         │
    │  Invoice     │          │           │          │         │
    ├──────────────┤          │           │          │         │
    │ id           │          │           │          │         │
    │ subId        │──────────┘           │          │         │
    │ orgId        │──────────────────────┘          │         │
    │ amount       │                                 │         │
    │ status       │                                 │         │
    │ paidAt       │                                 │         │
    └──────────────┘                                 │         │
                                                     │         │
    ┌──────────────┐                                 │         │
    │  ApiKey      │                                 │         │
    ├──────────────┤                                 │         │
    │ id           │                                 │         │
    │ orgId        │─────────────────────────────────┘         │
    │ key (hashed) │                                           │
    │ name         │                                           │
    │ expiresAt    │                                           │
    └──────────────┘                                           │
                                                               │
    ┌──────────────┐                                           │
    │  AuditLog    │                                           │
    ├──────────────┤                                           │
    │ id           │                                           │
    │ orgId        │───────────────────────────────────────────┘
    │ userId       │───┐
    │ action       │   │ N:1
    │ entityType   │   │
    │ metadata     │   │
    │ ipAddress    │   │
    └──────────────┘   │
                       │
         ┌─────────────┘
         ▼
    ┌──────────┐
    │   user   │
    ├──────────┤
    │ id       │◄────┐
    │ email    │     │
    └──────────┘     │
                     │ N:1
                     │
    ┌──────────────┐ │
    │ Invitation   │ │
    ├──────────────┤ │
    │ id           │ │
    │ orgId        │─┼──► Organization
    │ email        │ │
    │ role         │ │
    │ token        │ │
    │ invitedBy    │─┘
    │ status       │
    │ expiresAt    │
    └──────────────┘
```

**Key Points:**
- 12 entities total
- All minimal entities PLUS
- Subscription (1:1 with Organization)
- Invoice (N:1 with Subscription)
- ApiKey (N:1 with Organization)
- AuditLog (N:1 with Organization and User)
- Invitation (N:1 with Organization)

---

## Multi-Tenancy Data Flow

### Request Flow (Both Templates)

```
1. Incoming Request
   │
   ├─► Extract session token
   │
   ├─► Lookup session → userId
   │
   ├─► Get user's organizations (via AccountUser)
   │
   ├─► Determine current organizationId
   │   (from header, subdomain, or user selection)
   │
   ├─► Validate user has access to organizationId
   │
   └─► Query data filtered by organizationId

Example API Call:
GET /api/projects
→ Returns only projects WHERE organizationId = current_org
```

### Data Isolation Pattern

```
// Pseudo-code for all queries
const data = await db.select()
  .from(Entity)
  .where(
    and(
      eq(Entity.organizationId, currentOrganizationId),
      // ... other filters
    )
  );

// NEVER expose data across tenants
```

---

## Access Control Layers

### Layer 1: Authentication (BetterAuth)
```
┌─────────────┐
│   session   │ Is user logged in?
└─────────────┘
      │
      ▼
┌─────────────┐
│    user     │ Who is this user?
└─────────────┘
```

### Layer 2: Organization Access (AccountUser)
```
┌──────────────┐
│ AccountUser  │ Which orgs can this user access?
└──────────────┘
      │
      ▼
┌──────────────┐
│Organization  │ Select one organization
└──────────────┘
```

### Layer 3: Role-Based Access (Your Logic)
```
┌──────────────┐
│ AccountUser  │ What's their role?
│   .role      │ (owner, admin, member, viewer)
└──────────────┘
      │
      ▼
  Can they perform this action?
  - owner: all actions
  - admin: manage users, view billing
  - member: create/edit content
  - viewer: read-only
```

### Layer 4: Row-Level Security (RLS)
```
All queries filtered by organizationId

SELECT * FROM projects
WHERE organizationId = current_org_id
  AND (
    -- Additional checks
    deletedAt IS NULL
    AND status != 'archived'
  )
```

---

## Billing Flow (Complete Template Only)

```
1. User Selects Plan
   │
   ├─► Create Stripe Checkout Session
   │
   └─► Redirect to Stripe

2. User Completes Payment
   │
   └─► Stripe sends webhook

3. Webhook Handler
   │
   ├─► Verify webhook signature
   │
   ├─► Update/Create Subscription record
   │   ├─► organizationId
   │   ├─► stripeSubscriptionId
   │   ├─► plan
   │   ├─► status
   │   └─► periodEnd
   │
   └─► Update Organization.plan

4. Invoice Created (via webhook)
   │
   └─► Create Invoice record
       ├─► organizationId
       ├─► subscriptionId
       ├─► amount
       ├─► status
       └─► invoiceUrl
```

---

## API Key Authentication (Complete Template Only)

```
1. User Creates API Key
   │
   ├─► Generate random key
   │   (e.g., "sk_live_abc123...")
   │
   ├─► Show plaintext ONCE
   │
   └─► Store hashed version
       ├─► organizationId
       ├─► key (bcrypt hash)
       ├─► prefix ("sk_live_")
       └─► expiresAt

2. API Request with Key
   │
   ├─► Extract key from header
   │   Authorization: Bearer sk_live_abc123...
   │
   ├─► Hash incoming key
   │
   ├─► Lookup by hash
   │
   ├─► Validate not expired
   │
   ├─► Extract organizationId
   │
   └─► Set context for request
       (all queries filtered by this orgId)
```

---

## Audit Log Pattern (Complete Template Only)

```
Track These Actions:
┌────────────────────────────┐
│ USER ACTIONS               │
├────────────────────────────┤
│ - user.login               │
│ - user.logout              │
│ - user.password_changed    │
│ - user.email_changed       │
└────────────────────────────┘

┌────────────────────────────┐
│ ORG ACTIONS                │
├────────────────────────────┤
│ - org.created              │
│ - org.deleted              │
│ - org.member_added         │
│ - org.member_removed       │
│ - org.role_changed         │
└────────────────────────────┘

┌────────────────────────────┐
│ BILLING ACTIONS            │
├────────────────────────────┤
│ - subscription.created     │
│ - subscription.cancelled   │
│ - payment.succeeded        │
│ - payment.failed           │
└────────────────────────────┘

┌────────────────────────────┐
│ DATA ACTIONS               │
├────────────────────────────┤
│ - data.exported            │
│ - data.deleted             │
│ - api_key.created          │
│ - api_key.revoked          │
└────────────────────────────┘

Create Audit Entry:
{
  organizationId,
  userId,
  action: "org.member_added",
  entityType: "AccountUser",
  entityId: "user-123",
  metadata: {
    role: "admin",
    invitedBy: "user-456"
  },
  ipAddress: req.ip,
  userAgent: req.headers["user-agent"]
}
```

---

## Entity Dependencies

### Minimal Template
```
user (independent)
  └─► session
  └─► account
  └─► AccountUser
        └─► Organization

verification (independent)
```

Safe deletion order (bottom to top):
1. AccountUser
2. Organization
3. session
4. account
5. user

### Complete Template
```
user (independent)
  └─► session
  └─► account
  └─► AccountUser
  └─► AuditLog
  └─► ApiKey
  └─► Invitation

Organization (independent)
  └─► AccountUser
  └─► Subscription
        └─► Invoice
  └─► ApiKey
  └─► AuditLog
  └─► Invitation
```

Safe deletion order:
1. Invoice
2. AuditLog
3. ApiKey
4. Invitation
5. AccountUser
6. Subscription
7. Organization
8. session
9. account
10. user

---

## Index Strategy Visualization

### Minimal Template Indexes
```
AccountUser:
  [userId, organizationId] (UNIQUE) ← Prevent duplicates
  [organizationId]                  ← List org members

Organization:
  [slug] (UNIQUE)                   ← Subdomain routing
```

### Complete Template Indexes
```
Subscription:
  [organizationId] (UNIQUE)         ← One sub per org
  [stripeSubscriptionId]            ← Webhook lookups
  [status, currentPeriodEnd]        ← Find expiring

Invoice:
  [organizationId, createdAt]       ← Billing history
  [stripeInvoiceId] (UNIQUE)        ← Webhook sync
  [status]                          ← Unpaid invoices

ApiKey:
  [key] (UNIQUE)                    ← Authentication
  [organizationId]                  ← List org keys
  [prefix]                          ← Key identification

AuditLog:
  [organizationId, createdAt]       ← Audit timeline
  [userId, createdAt]               ← User activity
  [action]                          ← Filter by action
  [entityType, entityId]            ← Entity history

Invitation:
  [token] (UNIQUE)                  ← Accept invite
  [organizationId, status]          ← Pending invites
  [email, organizationId, status]   ← Prevent dupes
```

---

## Summary

### Minimal Template
- **Focus:** Clean foundation for custom SaaS
- **Complexity:** Low
- **Best for:** MVPs, unique domains, learning

### Complete Template
- **Focus:** Production-ready B2B SaaS
- **Complexity:** Medium
- **Best for:** Standard SaaS, billing, teams, compliance

Both templates are production-ready and follow best practices for multi-tenant architecture.
