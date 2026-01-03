# SaaS Capabilities

Mavric AI Toolchain provides specialized skills and commands for building production-ready SaaS applications. This page outlines the SaaS capability areas we support—and our roadmap for expansion.

---

## Our Approach

Building SaaS applications involves solving the same problems repeatedly:

- How do users authenticate?
- How do you isolate tenant data?
- How do you handle billing?
- How do you manage team permissions?

**Mavric provides pre-built patterns for each capability area**, so you focus on your unique product features—not reinventing infrastructure.

### Capability Lifecycle

Each SaaS capability follows this progression:

```
[Template] → [Skill] → [Command] → [Verified Pattern]
     ↓           ↓          ↓              ↓
  Schema     Automated   Quick      Battle-tested
  patterns   setup       access     implementation
```

1. **Template** - Schema patterns in `.apsorc` templates
2. **Skill** - AI-assisted setup and configuration
3. **Command** - Direct slash command access
4. **Verified Pattern** - Documented, tested, production-ready

---

## Capability Status

| Capability | Template | Skill | Command | Status |
|------------|:--------:|:-----:|:-------:|--------|
| [Authentication](#authentication) | ✅ | ✅ | - | **Available** |
| [Multi-Tenancy](#multi-tenancy) | ✅ | ✅ | - | **Available** |
| [Team Management](#team-management) | ✅ | ✅ | - | **Available** |
| [Billing & Payments](#billing-payments) | ✅ | - | - | **Planned** |
| [API Keys](#api-keys) | ✅ | - | - | **Planned** |
| [Audit Logging](#audit-logging) | ✅ | - | - | **Planned** |
| [Notifications](#notifications) | - | - | - | **Roadmap** |
| [File Storage](#file-storage) | - | - | - | **Roadmap** |
| [Search](#search) | - | - | - | **Roadmap** |
| [Webhooks](#webhooks) | - | - | - | **Roadmap** |
| [Admin Portal](#admin-portal) | - | - | - | **Roadmap** |
| [Analytics](#analytics) | - | - | - | **Roadmap** |
| [Onboarding Flows](#onboarding-flows) | - | - | - | **Roadmap** |

---

## Available Capabilities

### Authentication

**Status:** ✅ Template + ✅ Skill

Secure user authentication with BetterAuth integration.

| Feature | Support |
|---------|---------|
| Email/password | ✅ |
| OAuth providers | ✅ |
| Magic links | ✅ |
| Email verification | ✅ |
| Password reset | ✅ |
| Session management | ✅ |
| JWT tokens | ✅ |

**Resources:**

- Skill: [Auth Bootstrapper](../skills/auth-bootstrapper.md)
- Template: `minimal-saas-betterauth.json`
- Entities: `User`, `account`, `session`, `verification`

**Usage:**

```
Set up BetterAuth authentication for my backend
```

---

### Multi-Tenancy

**Status:** ✅ Template + ✅ Skill

Organization-scoped data isolation for B2B SaaS.

| Feature | Support |
|---------|---------|
| Organization entity | ✅ |
| User-org relationships | ✅ |
| Data isolation | ✅ |
| Cross-tenant prevention | ✅ |
| Org-scoped queries | ✅ |

**Resources:**

- Skill: [Schema Architect](../skills/schema-architect.md)
- Template: Both templates include multi-tenancy
- Entities: `Organization`, `AccountUser`

**Pattern:**

```typescript
// All business entities scoped to organization
const tasks = await db.select()
  .from(Task)
  .where(eq(Task.organizationId, currentOrg.id));
```

---

### Team Management

**Status:** ✅ Template + ✅ Skill

Role-based team membership and invitations.

| Feature | Support |
|---------|---------|
| Team invitations | ✅ |
| Role assignment | ✅ |
| Member listing | ✅ |
| Permission checks | ✅ |

**Resources:**

- Template: `complete-saas-betterauth.json`
- Entities: `AccountUser` (with role), `Invitation`

---

## Planned Capabilities

### Billing & Payments { #billing-payments }

**Status:** ✅ Template (Skill planned)

Stripe integration for subscriptions and payments.

| Feature | Template | Skill (Planned) |
|---------|:--------:|:---------------:|
| Subscription entity | ✅ | - |
| Invoice entity | ✅ | - |
| Stripe webhook handling | - | 🔜 |
| Checkout session | - | 🔜 |
| Customer portal | - | 🔜 |
| Usage-based billing | - | 🔜 |

**Template entities:** `Subscription`, `Invoice`

**Planned skill:** `billing-bootstrapper`

```
# Future usage
Set up Stripe billing for my SaaS
```

---

### API Keys

**Status:** ✅ Template (Skill planned)

Secure API key management for external integrations.

| Feature | Template | Skill (Planned) |
|---------|:--------:|:---------------:|
| API key entity | ✅ | - |
| Key generation | - | 🔜 |
| Key rotation | - | 🔜 |
| Rate limiting | - | 🔜 |
| Scope permissions | - | 🔜 |

**Template entity:** `ApiKey`

**Planned skill:** `api-key-bootstrapper`

---

### Audit Logging

**Status:** ✅ Template (Skill planned)

Compliance-ready audit trails for sensitive actions.

| Feature | Template | Skill (Planned) |
|---------|:--------:|:---------------:|
| AuditLog entity | ✅ | - |
| Automatic logging | - | 🔜 |
| Event types | - | 🔜 |
| Retention policies | - | 🔜 |
| Export/archive | - | 🔜 |

**Template entity:** `AuditLog`

**Planned skill:** `audit-bootstrapper`

---

## Roadmap Capabilities

These capabilities are on our roadmap. Templates and skills will be added in future releases.

### Notifications

Multi-channel notification system.

| Planned Feature |
|-----------------|
| Email notifications (Resend, SendGrid) |
| In-app notifications |
| Push notifications |
| Notification preferences |
| Digest/batching |

---

### File Storage

Secure file upload and storage.

| Planned Feature |
|-----------------|
| S3-compatible storage |
| Signed upload URLs |
| File metadata |
| Image processing |
| Virus scanning |

---

### Search

Full-text search capabilities.

| Planned Feature |
|-----------------|
| PostgreSQL full-text search |
| Typesense/Meilisearch integration |
| Search indexing |
| Faceted search |
| Search analytics |

---

### Webhooks

Event delivery to external systems.

| Planned Feature |
|-----------------|
| Webhook endpoints |
| Event subscriptions |
| Retry logic |
| Signature verification |
| Webhook logs |

---

### Admin Portal

Internal administration interface.

| Planned Feature |
|-----------------|
| User management |
| Organization management |
| System metrics |
| Feature flags |
| Support tools |

---

### Analytics

Usage and business analytics.

| Planned Feature |
|-----------------|
| Event tracking |
| Usage metrics |
| Revenue analytics |
| Cohort analysis |
| Dashboard components |

---

### Onboarding Flows

Guided user onboarding.

| Planned Feature |
|-----------------|
| Onboarding checklists |
| Progress tracking |
| Tooltips/tours |
| Activation metrics |
| A/B testing |

---

## Requesting Capabilities

Have a SaaS capability you'd like to see?

1. **Check existing patterns** - It may already be possible with current tools
2. **Request via GitHub** - Open an issue at [mavrictech/devenv](https://github.com/mavrictech/devenv/issues)
3. **Contribute** - PRs welcome for new capabilities

---

## Building Custom Capabilities

You can extend Mavric with your own capabilities:

### 1. Create a Template

Add entities to your `.apsorc`:

```json
{
  "name": "MyFeature",
  "fields": [
    { "name": "id", "type": "string", "primaryKey": true },
    { "name": "organizationId", "type": "string" }
  ]
}
```

### 2. Create a Skill

Add a skill in `.claude/skills/`:

```
.claude/skills/my-feature-bootstrapper/
├── SKILL.md
└── reference/
```

### 3. Create a Command

Add a command in `.claude/commands/`:

```markdown
---
description: Set up my feature
---
# My Feature

Invoke the my-feature-bootstrapper skill...
```

---

## See Also

- [Templates Reference](../setup/templates.md) - Schema templates
- [Skills Overview](../skills/index.md) - Available skills
- [Commands Overview](../commands/index.md) - Available commands
