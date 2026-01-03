# SaaS Base Template - Standard Features

> Production-ready SaaS template with authentication, authorization, multi-tenancy, billing, and audit logging

## Template Overview

This template provides a complete foundation for building multi-tenant B2B SaaS applications with:
- ✅ Multi-tenant architecture (organization-based)
- ✅ Authentication & Authorization (Better Auth integration)
- ✅ User & Team Management
- ✅ Role-Based Access Control (RBAC)
- ✅ Subscription & Billing (Stripe ready)
- ✅ Audit Logging (compliance-ready)
- ✅ API Keys & Webhooks
- ✅ File Uploads (S3 ready)
- ✅ Email Notifications

**Deployment Time:** ~5 minutes with Apso
**Frontend Setup:** ~2 hours with Next.js + Better Auth
**Production Ready:** Day 1

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Multi-Tenant Structure                    │
│                                                              │
│  Organizations (Tenants)                                     │
│    ├── Users (Members with Roles)                           │
│    ├── Projects/Resources (Your core data)                  │
│    ├── Subscriptions (Billing)                              │
│    ├── API Keys (For integrations)                          │
│    ├── Webhooks (For events)                                │
│    ├── Invitations (For team growth)                        │
│    └── Audit Logs (For compliance)                          │
└─────────────────────────────────────────────────────────────┘
```

---

## Apso Schema Definition

### Prompt for Apso Schema Generator

```
Create a production-ready multi-tenant SaaS backend with the following structure:

SERVICE NAME: [your-saas-name]-api
ENVIRONMENT: development

CORE ENTITIES:

1. Organizations (Multi-Tenant Root)
   - name: string, required, 100 chars max
   - slug: string, unique, required, lowercase, 50 chars max (URL-safe identifier)
   - billing_email: string, email format
   - stripe_customer_id: string, nullable (links to Stripe)
   - subscription_status: enum(trial, active, past_due, canceled, none), default: trial
   - trial_ends_at: timestamp, nullable
   - settings: jsonb, default: {} (org-wide settings)
   - created_at: timestamp, auto
   - updated_at: timestamp, auto

2. Users (Better Auth Integration)
   - id: uuid, primary key (matches Better Auth user.id)
   - email: string, required (synced from Better Auth)
   - name: string, nullable
   - avatar_url: string, nullable
   - org_id: uuid, references organizations, required
   - role: enum(owner, admin, member, viewer), default: member
   - status: enum(active, suspended, pending), default: pending
   - last_login_at: timestamp, nullable
   - created_at: timestamp, auto
   - updated_at: timestamp, auto
   - UNIQUE constraint on (org_id, email)
   - INDEX on org_id
   - INDEX on email

3. Invitations (Team Management)
   - id: uuid, primary key
   - org_id: uuid, references organizations, required
   - email: string, required
   - role: enum(admin, member, viewer), default: member
   - invited_by: uuid, references users, required
   - token: string, unique, required (for invite links)
   - status: enum(pending, accepted, expired), default: pending
   - expires_at: timestamp, required (default: 7 days from now)
   - created_at: timestamp, auto
   - INDEX on org_id
   - INDEX on token
   - INDEX on email

4. Subscriptions (Billing Integration)
   - id: uuid, primary key
   - org_id: uuid, references organizations, required, unique
   - stripe_subscription_id: string, unique, nullable
   - stripe_price_id: string, nullable (current plan)
   - plan_name: string (e.g., "Starter", "Pro", "Enterprise")
   - status: enum(trialing, active, past_due, canceled, paused), default: trialing
   - quantity: integer, default: 1 (for per-seat pricing)
   - current_period_start: timestamp, nullable
   - current_period_end: timestamp, nullable
   - cancel_at_period_end: boolean, default: false
   - trial_ends_at: timestamp, nullable
   - metadata: jsonb, default: {} (extra subscription data)
   - created_at: timestamp, auto
   - updated_at: timestamp, auto
   - INDEX on org_id

5. API Keys (For Integrations)
   - id: uuid, primary key
   - org_id: uuid, references organizations, required
   - name: string, required (e.g., "Production API Key")
   - key_prefix: string, required (e.g., "sk_live_")
   - key_hash: string, required (hashed, never show full key after creation)
   - last_used_at: timestamp, nullable
   - expires_at: timestamp, nullable
   - scopes: jsonb, default: ["read", "write"] (permissions)
   - status: enum(active, revoked), default: active
   - created_by: uuid, references users, required
   - created_at: timestamp, auto
   - INDEX on org_id
   - INDEX on key_prefix

6. Webhooks (Event Subscriptions)
   - id: uuid, primary key
   - org_id: uuid, references organizations, required
   - url: string, required (endpoint URL)
   - events: jsonb, required (array of event types: ["user.created", "project.updated"])
   - secret: string, required (for HMAC signature)
   - status: enum(active, paused, failed), default: active
   - failure_count: integer, default: 0
   - last_success_at: timestamp, nullable
   - last_failure_at: timestamp, nullable
   - created_by: uuid, references users, required
   - created_at: timestamp, auto
   - updated_at: timestamp, auto
   - INDEX on org_id

7. Audit Logs (Compliance & Security)
   - id: uuid, primary key
   - org_id: uuid, references organizations, required
   - user_id: uuid, references users, nullable (can be system)
   - action: string, required (e.g., "user.created", "project.deleted")
   - resource_type: string, required (e.g., "project", "user", "organization")
   - resource_id: uuid, nullable
   - old_values: jsonb, nullable (for updates/deletes)
   - new_values: jsonb, nullable (for creates/updates)
   - ip_address: inet, nullable
   - user_agent: string, nullable
   - metadata: jsonb, default: {} (extra context)
   - created_at: timestamp, auto, immutable (cannot be updated)
   - INDEX on org_id
   - INDEX on user_id
   - INDEX on resource_type, resource_id
   - INDEX on created_at DESC

8. Files (S3 Integration)
   - id: uuid, primary key
   - org_id: uuid, references organizations, required
   - uploaded_by: uuid, references users, required
   - filename: string, required
   - original_filename: string, required
   - mime_type: string, required
   - size_bytes: bigint, required
   - s3_bucket: string, required
   - s3_key: string, required (path in S3)
   - s3_url: string, nullable (public URL if public)
   - is_public: boolean, default: false
   - metadata: jsonb, default: {} (custom file metadata)
   - created_at: timestamp, auto
   - INDEX on org_id
   - INDEX on uploaded_by

9. Notifications (In-App)
   - id: uuid, primary key
   - org_id: uuid, references organizations, required
   - user_id: uuid, references users, required
   - type: enum(info, success, warning, error), default: info
   - title: string, required, 200 chars max
   - message: text, required
   - action_url: string, nullable (link to related resource)
   - read: boolean, default: false
   - read_at: timestamp, nullable
   - created_at: timestamp, auto
   - INDEX on org_id, user_id
   - INDEX on read, created_at DESC

ADDITIONAL REQUIREMENTS:

- Every table MUST include org_id for multi-tenancy (except audit_logs which already has it)
- Add CASCADE DELETE on foreign keys where appropriate
- Ensure all timestamps use UTC
- Add appropriate indexes for performance
- Enable row-level security where supported

GENERATED API ENDPOINTS SHOULD INCLUDE:

- CRUD operations for all entities
- Automatic org_id filtering on all queries
- Proper validation on all inputs
- Error handling with appropriate HTTP status codes
- OpenAPI 3.0 documentation
```

---

## Standard Features Included

### 1. Authentication & Authorization

**Provided by:** Better Auth (integrates with Apso's PostgreSQL)

**Features:**
- ✅ Email/password signup and login
- ✅ Email verification
- ✅ Password reset flow
- ✅ OAuth 2.0 (Google, GitHub, etc.)
- ✅ Session management (JWT or session tokens)
- ✅ MFA/2FA (TOTP, optional)
- ✅ Magic links (passwordless, optional)

**Integration:**
- Better Auth creates its own tables: `better_auth_users`, `better_auth_sessions`, `better_auth_accounts`
- Your Apso `users` table references `better_auth_users.id`
- Session tokens authenticate all API requests

**Code Example:**
```typescript
// After Better Auth login, sync to Apso
const authUser = await signUp.email({ email, password, name })

// Create in Apso users table
await api.users.create({
  id: authUser.data.user.id,  // Use Better Auth user ID
  email: authUser.data.user.email,
  name: authUser.data.user.name,
  org_id: orgId,
  role: 'owner',  // First user is owner
  status: 'active'
})
```

---

### 2. Multi-Tenancy (Organization-Based)

**How it works:**
- Every organization is a separate tenant
- All data scoped by `org_id`
- Users belong to one organization
- Complete data isolation

**Enforcement:**
```typescript
// Every API call automatically filters by org_id
const projects = await api.projects.list({
  org_id: currentUser.org_id  // Always required
})

// Apso API ensures no cross-org data leakage
```

**Organization Structure:**
```typescript
interface Organization {
  id: string
  name: string
  slug: string  // URL-friendly: acme-corp
  billing_email: string
  stripe_customer_id?: string
  subscription_status: 'trial' | 'active' | 'past_due' | 'canceled' | 'none'
  trial_ends_at?: Date
  settings: Record<string, any>  // JSON for org settings
}
```

---

### 3. Role-Based Access Control (RBAC)

**Built-in Roles:**

| Role | Permissions | Use Case |
|------|-------------|----------|
| **Owner** | Full access + billing + delete org | Founder, original creator |
| **Admin** | Full access except billing/delete org | Management team |
| **Member** | Create, read, update own resources | Standard employees |
| **Viewer** | Read-only access | Clients, stakeholders |

**Permission Checks:**
```typescript
// In API route
export async function DELETE(request: Request) {
  const user = await getCurrentUser(request)

  if (user.role !== 'owner' && user.role !== 'admin') {
    return new Response('Forbidden', { status: 403 })
  }

  // Proceed with delete
}
```

**Custom Roles (Phase 3):**
Can be added later with granular permissions table

---

### 4. Team Management

**Features:**
- ✅ Invite users via email
- ✅ Set role on invitation
- ✅ Expiring invite links (7 days default)
- ✅ Resend invitations
- ✅ Revoke pending invitations
- ✅ Remove team members

**Invitation Flow:**
```typescript
// 1. Admin creates invitation
const invite = await api.invitations.create({
  org_id: currentUser.org_id,
  email: 'newuser@example.com',
  role: 'member',
  invited_by: currentUser.id,
  token: generateSecureToken(),
  expires_at: addDays(new Date(), 7)
})

// 2. Send email with invite link
await sendEmail({
  to: invite.email,
  subject: `Join ${org.name} on MyApp`,
  html: `<a href="${APP_URL}/accept-invite/${invite.token}">Accept Invitation</a>`
})

// 3. Recipient clicks link, creates Better Auth account
// 4. Link Better Auth user to org with specified role
```

---

### 5. Subscription & Billing

**Stripe Integration Ready:**

```typescript
interface Subscription {
  org_id: string
  stripe_subscription_id: string
  stripe_price_id: string  // Which plan
  plan_name: string  // "Starter", "Pro", "Enterprise"
  status: 'trialing' | 'active' | 'past_due' | 'canceled'
  quantity: number  // For per-seat billing
  current_period_end: Date
  cancel_at_period_end: boolean
}
```

**Webhook Handling:**
```typescript
// Stripe webhook updates subscription status
stripe.webhooks.on('customer.subscription.updated', async (subscription) => {
  await api.subscriptions.update(subscription.id, {
    status: subscription.status,
    current_period_end: new Date(subscription.current_period_end * 1000)
  })
})
```

**Usage Metering (Optional):**
Add `usage_records` table for tracking API calls, storage, etc.

---

### 6. API Keys & Integrations

**For third-party access to your API:**

```typescript
// Create API key
const apiKey = await api.apiKeys.create({
  org_id: currentUser.org_id,
  name: 'Production API Key',
  key_prefix: 'sk_live_',
  key_hash: hashApiKey(fullKey),  // Only store hash
  scopes: ['read', 'write'],
  created_by: currentUser.id
})

// Return full key ONCE (never show again)
return {
  key: `sk_live_${randomString()}`,  // Show to user once
  key_prefix: 'sk_live_...'  // Show in UI always
}
```

**Authentication:**
```typescript
// API route with API key auth
const apiKey = request.headers.get('X-API-Key')
const hashedKey = hashApiKey(apiKey)

const keyRecord = await api.apiKeys.findByHash(hashedKey)
if (!keyRecord || keyRecord.status !== 'active') {
  return new Response('Invalid API key', { status: 401 })
}

// Update last_used_at
await api.apiKeys.update(keyRecord.id, {
  last_used_at: new Date()
})
```

---

### 7. Webhooks (Outgoing)

**Event Subscriptions:**
```typescript
// Customer registers webhook
const webhook = await api.webhooks.create({
  org_id: currentUser.org_id,
  url: 'https://customer.com/webhooks',
  events: ['project.created', 'project.updated', 'project.deleted'],
  secret: generateWebhookSecret(),  // For HMAC
  created_by: currentUser.id
})

// When event occurs, send webhook
async function notifyWebhooks(orgId: string, event: string, payload: any) {
  const webhooks = await api.webhooks.list({
    org_id: orgId,
    status: 'active',
    events: { contains: event }
  })

  for (const webhook of webhooks) {
    await sendWebhook(webhook, event, payload)
  }
}
```

---

### 8. Audit Logging

**Automatic Tracking:**
- Who did what
- When they did it
- What changed (old vs. new values)
- IP address and user agent
- Immutable (cannot be edited)

**Example:**
```typescript
// Automatically log all important actions
async function updateProject(id: string, updates: any) {
  const old = await api.projects.get(id)
  const updated = await api.projects.update(id, updates)

  // Log to audit trail
  await api.auditLogs.create({
    org_id: currentUser.org_id,
    user_id: currentUser.id,
    action: 'project.updated',
    resource_type: 'project',
    resource_id: id,
    old_values: old,
    new_values: updated,
    ip_address: request.ip,
    user_agent: request.headers['user-agent']
  })

  return updated
}
```

**Compliance Exports:**
```typescript
// Export audit logs for compliance
const logs = await api.auditLogs.list({
  org_id: currentUser.org_id,
  created_at: {
    gte: startDate,
    lte: endDate
  },
  orderBy: { created_at: 'desc' }
})

// Convert to CSV for auditors
const csv = convertToCSV(logs)
```

---

### 9. File Uploads (S3 Integration)

**Secure File Management:**
```typescript
// 1. Generate presigned URL (backend)
const { uploadUrl, fileId } = await generateUploadUrl({
  org_id: currentUser.org_id,
  filename: 'report.pdf',
  mime_type: 'application/pdf',
  size_bytes: 1024000
})

// 2. Upload directly to S3 (frontend)
await fetch(uploadUrl, {
  method: 'PUT',
  body: file,
  headers: {
    'Content-Type': file.type
  }
})

// 3. Confirm upload (backend creates file record)
await api.files.create({
  id: fileId,
  org_id: currentUser.org_id,
  uploaded_by: currentUser.id,
  filename: 'report_20250110.pdf',
  original_filename: 'report.pdf',
  mime_type: 'application/pdf',
  size_bytes: 1024000,
  s3_bucket: 'my-app-files',
  s3_key: `orgs/${orgId}/files/${fileId}.pdf`,
  is_public: false
})
```

---

### 10. In-App Notifications

**Real-time Alerts:**
```typescript
// Create notification
await api.notifications.create({
  org_id: currentUser.org_id,
  user_id: targetUserId,
  type: 'success',
  title: 'Project created',
  message: 'Your new project "Q1 Campaign" is ready',
  action_url: `/projects/${projectId}`,
  read: false
})

// Get unread count
const unreadCount = await api.notifications.count({
  org_id: currentUser.org_id,
  user_id: currentUser.id,
  read: false
})

// Mark as read
await api.notifications.update(notificationId, {
  read: true,
  read_at: new Date()
})
```

---

## Frontend Integration

### Setup Steps

**1. Install Dependencies**
```bash
npm install better-auth axios zod react-hook-form @hookform/resolvers
npx shadcn-ui@latest init
```

**2. Configure Better Auth**
```typescript
// lib/auth.ts
import { betterAuth } from "better-auth"
import { pgAdapter } from "better-auth/adapters/postgres"

export const auth = betterAuth({
  database: pgAdapter({
    host: process.env.APSO_DB_HOST,
    database: process.env.APSO_DB_NAME,
    user: process.env.APSO_DB_USER,
    password: process.env.APSO_DB_PASSWORD,
    ssl: { rejectUnauthorized: false }
  }),
  emailAndPassword: { enabled: true },
  socialProviders: {
    google: {
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!
    }
  }
})
```

**3. Create API Client**
```typescript
// lib/api-client.ts
import axios from 'axios'

export const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_APSO_API_URL
})

// Add auth token
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('auth_token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Type-safe methods
export const apiClient = {
  organizations: {
    get: (id: string) => api.get(`/organizations/${id}`),
    update: (id: string, data: any) => api.put(`/organizations/${id}`, data)
  },
  users: {
    list: (orgId: string) => api.get('/users', { params: { org_id: orgId } }),
    get: (id: string) => api.get(`/users/${id}`),
    update: (id: string, data: any) => api.put(`/users/${id}`, data),
    delete: (id: string) => api.delete(`/users/${id}`)
  },
  invitations: {
    create: (data: any) => api.post('/invitations', data),
    list: (orgId: string) => api.get('/invitations', { params: { org_id: orgId } }),
    resend: (id: string) => api.post(`/invitations/${id}/resend`),
    revoke: (id: string) => api.delete(`/invitations/${id}`)
  }
  // ... add all other resources
}
```

---

## Standard Pages Included

### 1. Authentication Pages
- `/login` - Email/password + social login
- `/signup` - Create account + organization
- `/forgot-password` - Password reset request
- `/reset-password` - Set new password
- `/verify-email` - Email verification

### 2. Dashboard Pages
- `/dashboard` - Overview with stats
- `/settings` - Account settings
- `/settings/profile` - User profile
- `/settings/organization` - Org settings
- `/settings/team` - Team management
- `/settings/billing` - Subscription & billing
- `/settings/api-keys` - API key management
- `/settings/webhooks` - Webhook configuration

### 3. Admin Pages
- `/admin/users` - User management
- `/admin/audit-logs` - Audit trail viewer
- `/admin/usage` - Usage metrics

---

## Security Features

### ✅ Included by Default

1. **Multi-Tenancy Isolation**
   - All queries filter by `org_id`
   - No cross-org data leakage

2. **Authentication**
   - Secure password hashing (bcrypt)
   - Session management
   - CSRF protection

3. **Authorization**
   - Role-based access control
   - Resource-level permissions

4. **Audit Logging**
   - Immutable audit trail
   - Track all sensitive actions

5. **API Security**
   - API key authentication
   - Rate limiting (add with Redis)
   - CORS configuration

6. **Data Protection**
   - Encrypted connections (TLS)
   - Secure file uploads (presigned URLs)
   - Webhook signature verification (HMAC)

---

## What's NOT Included (Add Later)

These are Phase 2-3 features:

- ❌ SSO/SAML (Enterprise auth)
- ❌ Real-time collaboration (CRDT)
- ❌ Advanced RBAC (custom permissions)
- ❌ Workflow automation
- ❌ AI features
- ❌ Multi-region deployment
- ❌ Advanced analytics/reporting

**Why:** Start simple, add complexity as needed.

---

## Deployment Checklist

### Apso Backend
- [ ] Copy schema definition to Apso
- [ ] Generate and deploy to dev environment
- [ ] Test API endpoints via OpenAPI docs
- [ ] Deploy to production environment
- [ ] Save API URLs and database credentials

### Better Auth Setup
- [ ] Run `npx better-auth generate` to create auth tables
- [ ] Configure database connection to Apso PostgreSQL
- [ ] Set up OAuth providers (Google, GitHub)
- [ ] Test authentication flow

### Frontend Setup
- [ ] Create Next.js project
- [ ] Install and configure Better Auth
- [ ] Create API client with Apso URL
- [ ] Build authentication pages
- [ ] Build dashboard and settings pages
- [ ] Deploy to Vercel

### Integrations
- [ ] Set up Stripe account
- [ ] Configure Stripe webhook endpoint
- [ ] Set up Postmark for emails
- [ ] Configure AWS S3 bucket for files
- [ ] Add Sentry for error tracking
- [ ] Add PostHog for analytics

### Production Readiness
- [ ] Test authentication flows end-to-end
- [ ] Test multi-tenancy isolation
- [ ] Test billing integration
- [ ] Set up monitoring and alerts
- [ ] Write API documentation
- [ ] Create admin user guide

---

## Cost Estimates

### MVP (Phase 1)
- Apso: Internal platform (no cost)
- Vercel: $0 (free tier)
- Better Auth: $0 (open source)
- Stripe: 2.9% + $0.30/transaction
- Postmark: $10/mo (10K emails)
- AWS S3: ~$5/mo
- Sentry: $0 (free tier)
- **Total: ~$15/mo + transaction fees**

### At Scale (1,000 users)
- Apso: Internal platform
- Vercel: $20/mo (Pro)
- Redis: $5/mo
- Postmark: $50/mo
- AWS S3: $20/mo
- Sentry: $26/mo
- PostHog: $50/mo
- **Total: ~$171/mo + transaction fees**

---

## Next Steps

1. **Review** this template definition
2. **Customize** the schema for your specific product (add your core resources)
3. **Deploy** to Apso (5 minutes)
4. **Integrate** with Next.js + Better Auth (2-4 hours)
5. **Build** your unique features on top of this foundation

---

**Template Version:** 1.0
**Last Updated:** 2025-01-10
**Maintained by:** Mavric
**Status:** Production-ready
