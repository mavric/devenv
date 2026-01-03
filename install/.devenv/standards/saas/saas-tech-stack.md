# SaaS Tech Stack - Mavric Standard

> Prescriptive, opinionated tech stack for building modern SaaS products with Apso

## Executive Summary

**Apso** is Mavric's internal developer platform that generates NestJS backend code and automates deployment to AWS. Define your data schema once, and Apso generates a complete NestJS/TypeORM backend with REST APIs, PostgreSQL database, and deployment infrastructure. The generated backend code lives in your repository (`/server`) where you can extend and customize it.

**Standard Stack:** Next.js + TypeScript frontend (`/client`), Apso-generated NestJS backend (`/server`), Better Auth for authentication, Stripe for billing.

**Core Principle:** Use code generation and managed services aggressively. Build only what differentiates your product.

---

## The Stack

### Backend & Database: **Apso**

**What it is:**
Apso is a Schema-Driven Backend Builder and Internal Developer Platform (IDP) that generates NestJS backend code and automates deployment to AWS. It's both a code generator (produces backend code that lives in your repo) and a platform service (handles infrastructure and deployment).

**What it provides:**
- ✅ **Generated NestJS/TypeORM backend code** (lives in your repository at `/server`)
- ✅ PostgreSQL database (fully relational, auto-generated schema)
- ✅ REST API endpoints (OpenAPI 3-compliant, CRUD operations)
- ✅ AWS deployment automation (Lambda/ECS, RDS, API Gateway, CloudWatch)
- ✅ Admin dashboards and schema documentation
- ✅ OpenAPI documentation (auto-generated per service)
- ✅ Environment management (dev, staging, production)
- ✅ 100+ pre-built schema templates

**How to use:**
1. Install Apso CLI: `npm install -g @apso/cli`
2. Define your data schema (see APSO_SCHEMA_PROMPT.md)
3. Generate code: `npx @apso/cli generate --schema schema.md`
4. Apso generates NestJS backend code in `/server` (customizable)
5. Deploy to AWS: `npx @apso/cli deploy --env production`
6. Consume API from your Next.js frontend (`/client`)

**Cost:** Platform service (internal to Mavric)

**CLI:** https://www.npmjs.com/package/@apso/cli
**Docs:** https://app.staging.apso.cloud/docs

**Under the hood:**
- Runtime: TypeScript
- Framework: NestJS
- ORM: TypeORM
- Database: PostgreSQL
- Hosting: AWS Lambda or ECS
- API Gateway: AWS API Gateway
- Logging: AWS CloudWatch
- Infrastructure: AWS CDK

---

### Frontend: **Next.js + TypeScript**

**Why:** Modern SSR/ISR React framework, best-in-class DX, Vercel deployment

**Stack:**
- **Framework:** Next.js 14+ (App Router)
- **Language:** TypeScript
- **UI Library:** Tailwind CSS + shadcn/ui
- **State Management:** React Context + Zustand (for complex state)
- **Forms:** React Hook Form + Zod
- **API Client:** Fetch API / Axios (with Apso OpenAPI types)

**Cost:** Free (Vercel free tier) → $20/mo (Pro) → $350/mo (Enterprise)

---

### Authentication & Sessions: **Better Auth**

**Why:** Lightweight, modern auth library with excellent DX, integrates with Apso

**What it provides:**
- ✅ Email/password authentication
- ✅ OAuth 2.0 (Google, GitHub, etc.)
- ✅ Session management
- ✅ Password reset flows
- ✅ Email verification
- ✅ MFA/2FA (TOTP)
- ✅ Database adapters (works with Apso's PostgreSQL)

**Integration with Apso:**
1. Better Auth manages auth tables in Apso's PostgreSQL
2. Apso REST API protected by Better Auth sessions
3. Frontend uses Better Auth client for login/signup
4. Session tokens verified by middleware

**Setup:**
```bash
npm install better-auth @better-auth/cli
```

**Cost:** Free (open source)

**Docs:** https://www.better-auth.com/docs

**Add-on for Enterprise (Phase 3):**
- **WorkOS** for SSO/SAML ($0 for first 1M MAU, then $0.05/MAU)

---

### Payments & Billing: **Stripe**

**Why:** Industry standard, handles all complexity (PCI, tax, invoicing, proration)

**What it provides:**
- ✅ Payment processing (cards, ACH, international)
- ✅ Subscription management
- ✅ Usage-based billing (metering)
- ✅ Invoicing and receipts
- ✅ Tax calculation (global)
- ✅ Webhooks for payment events
- ✅ Customer portal

**Integration with Apso:**
1. Apso stores `stripe_customer_id` on user records
2. Frontend uses Stripe Checkout or Elements
3. Webhooks hit Apso API to update subscription status
4. Apso queries Stripe API for billing data

**Cost:** 2.9% + $0.30 per transaction (US), higher for international

**Docs:** https://stripe.com/docs

---

### File Storage: **AWS S3**

**Why:** Scalable, secure, CDN integration, already in Apso's AWS account

**What it provides:**
- ✅ Object storage (files, images, documents)
- ✅ CDN integration (CloudFront)
- ✅ Presigned URLs for secure uploads
- ✅ Versioning and lifecycle policies

**Integration with Apso:**
1. Apso generates presigned URLs for direct browser → S3 uploads
2. File metadata stored in Apso's PostgreSQL
3. CloudFront serves files with caching

**Cost:** $0.023/GB/month (first 50TB), $0.09/GB transfer

---

### Email: **SendGrid** or **Postmark**

**Why:** Deliverability experts, transactional email reliability

**Recommendation:** Postmark for transactional (better deliverability), SendGrid for marketing

**What it provides:**
- ✅ Transactional email delivery
- ✅ Email templates
- ✅ Bounce/spam handling
- ✅ Open/click tracking
- ✅ Webhooks for delivery events

**Integration with Apso:**
1. Apso backend sends emails via SendGrid/Postmark API
2. Templates stored in email service
3. Webhooks update email status in Apso

**Cost:**
- Postmark: $10/mo for 10K emails
- SendGrid: $15/mo for 40K emails

---

### Real-Time Features: **Socket.io + Redis**

**Why:** Apso provides REST, not WebSocket. Need separate service for real-time.

**What it provides:**
- ✅ Real-time notifications (in-app)
- ✅ Presence indicators (who's online)
- ✅ Live updates (optional: collaboration)

**Architecture:**
1. Separate Node.js service for WebSocket (Socket.io)
2. Redis Pub/Sub for scaling across instances
3. Socket.io authenticates using Better Auth sessions
4. Publishes events from Apso API → Redis → Socket.io → clients

**Cost:**
- Redis Cloud: $0 (free tier 30MB) → $5/mo (250MB)
- Socket.io server: AWS ECS or Lambda (minimal cost)

**Alternative:** For MVP, skip real-time and use polling. Add in Phase 2.

---

### Error Tracking: **Sentry**

**Why:** Best-in-class error tracking, free tier generous

**What it provides:**
- ✅ Error capture (frontend + backend)
- ✅ Stack traces and context
- ✅ Release tracking
- ✅ Performance monitoring
- ✅ Alert rules

**Cost:** Free for 5K errors/month → $26/mo → $80/mo

---

### Analytics: **PostHog**

**Why:** Open source, privacy-friendly, product analytics + feature flags + session replay

**What it provides:**
- ✅ Event tracking
- ✅ User analytics
- ✅ Funnels and cohorts
- ✅ Feature flags
- ✅ Session replay
- ✅ A/B testing

**Alternative:** Mixpanel (more mature, higher cost)

**Cost:** Free for 1M events/month → $0.00045/event after

---

### CI/CD: **GitHub Actions**

**Why:** Free for public repos, integrated with GitHub

**What it does:**
- ✅ Run tests on PR
- ✅ Lint and type-check
- ✅ Deploy to Vercel (frontend)
- ✅ Deploy to Apso (backend schema updates)

**Cost:** Free for public repos, $0.008/minute for private repos

---

### AI Integration: **OpenAI** or **Claude (Anthropic)**

**Why:** Best-in-class LLMs for features like AI search, copilots, content generation

**What it provides:**
- ✅ GPT-4 / Claude 3.5 for text generation
- ✅ Embeddings for semantic search
- ✅ Function calling for tool use
- ✅ Vision models for image analysis

**Use cases:**
- AI search (embed content, query with embeddings)
- AI copilot (chat interface in product)
- Content generation (emails, summaries, etc.)

**Cost:**
- OpenAI: $0.01/1K tokens (GPT-4o), $0.13/1M tokens (embeddings)
- Anthropic: $3/1M input tokens, $15/1M output tokens (Claude 3.5)

---

## Feature Implementation Matrix

| Feature Category | Solution | Phase | Notes |
|------------------|----------|-------|-------|
| **Database** | Apso (PostgreSQL) | 1 | Auto-generated schema |
| **REST API** | Apso (NestJS + TypeORM) | 1 | OpenAPI 3 compliant |
| **Deployment** | Apso (AWS Lambda/ECS) | 1 | One-click deploy |
| **Frontend** | Next.js + TypeScript | 1 | Vercel hosting |
| **UI Components** | Tailwind + shadcn/ui | 1 | Copy-paste components |
| **Authentication** | Better Auth | 1 | Email/password + OAuth |
| **Session Management** | Better Auth | 1 | JWT or session tokens |
| **User Profiles** | Apso (database) + Better Auth | 1 | User table in Apso |
| **Team/Org Management** | Apso (database) | 1 | Define in schema |
| **Payments** | Stripe | 1 | Checkout + subscriptions |
| **Email (Transactional)** | Postmark | 1 | Sending via Apso backend |
| **File Upload** | AWS S3 (presigned URLs) | 1 | Via Apso |
| **Error Tracking** | Sentry | 1 | Frontend + backend |
| **Analytics** | PostHog | 1 | Product analytics |
| **Feature Flags** | PostHog (built-in) | 1 | A/B testing + rollouts |
| **RBAC (Basic)** | Apso (database) + Better Auth | 2 | Roles table in Apso |
| **Audit Logging** | Apso (database) | 2 | Immutable logs table |
| **Webhooks (Outgoing)** | Apso (custom endpoints) | 2 | Send from Apso backend |
| **Real-Time Notifications** | Socket.io + Redis | 2 | Separate service |
| **CSV Import/Export** | Apso (custom endpoints) | 2 | Bulk operations |
| **Advanced Search** | ElasticSearch or Algolia | 2 | If needed for scale |
| **SSO/SAML** | WorkOS | 3 | Enterprise auth |
| **Advanced RBAC** | Custom in Apso | 3 | Fine-grained permissions |
| **Workflow Automation** | Custom (Apso + frontend) | 3 | No-code builder |
| **Real-Time Collaboration** | Yjs + Hocuspocus | 3 | Only if core feature |
| **Multi-Region** | Apso (multiple AWS regions) | 3 | For enterprise |
| **AI Search** | OpenAI Embeddings + pgvector | 2-3 | Semantic search |
| **AI Copilot** | OpenAI GPT-4 + RAG | 3 | Chat assistant |

---

## What You DON'T Build from Scratch

**Apso Generates for You:**
- ❌ Backend boilerplate (Apso generates NestJS code)
- ❌ Database schema (Apso generates TypeORM entities)
- ❌ CRUD API endpoints (Apso generates controllers/services)
- ❌ AWS infrastructure (Apso provides deployment automation)
- ❌ API documentation (Apso generates OpenAPI specs)
- ❌ Environment management (Apso provides tooling)

**Note:** You get the generated NestJS code in `/server` and can customize/extend it as needed.

**Managed Services Replace:**
- ❌ Authentication system (use Better Auth)
- ❌ Payment processing (use Stripe)
- ❌ Email delivery (use Postmark/SendGrid)
- ❌ File storage infrastructure (use S3)
- ❌ Error tracking (use Sentry)

**You Build:**
- ✅ Frontend UI/UX (Next.js + Tailwind + shadcn)
- ✅ Custom business logic (extend generated NestJS services)
- ✅ Custom API endpoints (beyond CRUD, in `/server`)
- ✅ Workflow automation (if needed)
- ✅ Complex real-time features (if core to product)
- ✅ Integrations with third parties
- ✅ AI features (using OpenAI/Claude APIs)

---

## Cost Breakdown by Phase

### Phase 1: MVP (Weeks 1-12)

| Service | Cost/Month |
|---------|------------|
| Apso | Internal platform (no cost) |
| Vercel (Next.js) | $0 (free tier) |
| Better Auth | $0 (open source) |
| Stripe | 2.9% + $0.30/transaction |
| Postmark | $10 (10K emails) |
| AWS S3 | ~$5 (storage + transfer) |
| Sentry | $0 (free tier) |
| PostHog | $0 (free tier) |
| **Total** | **~$15/mo + transaction fees** |

### Phase 2: Market Ready (Weeks 13-24)

| Service | Cost/Month |
|---------|------------|
| All Phase 1 services | ~$15 |
| Vercel Pro | $20 |
| Redis Cloud | $5 |
| Socket.io server (ECS) | ~$20 |
| PostHog (paid) | $50 (for scale) |
| Sentry (paid) | $26 |
| **Total** | **~$136/mo + transaction fees** |

### Phase 3: Enterprise (Weeks 25-48)

| Service | Cost/Month |
|---------|------------|
| All Phase 2 services | ~$136 |
| WorkOS (SSO) | $0 (first 1M MAU) |
| Algolia (if needed) | $1/1K searches |
| ElasticSearch (AWS) | ~$100 (managed) |
| SOC 2 audit | $50K-100K (one-time) |
| **Total** | **~$236-336/mo + audit costs** |

**Note:** Apso's internal platform cost is absorbed by Mavric. Typical SaaS would pay $500-2000/mo for equivalent backend infrastructure.

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                   Frontend (/client)                         │
│  Next.js + TypeScript + Tailwind + shadcn/ui               │
│  (Hosted on Vercel)                                         │
└──────────────┬──────────────────────────────────────────────┘
               │
               │ REST API calls
               │ (Generated API client)
               ▼
┌─────────────────────────────────────────────────────────────┐
│              Backend (/server) - NestJS                      │
│  • Generated by Apso (NestJS + TypeORM code)                │
│  • Lives in your repository                                 │
│  • Customizable and extensible                              │
│  • REST API endpoints (CRUD + custom)                       │
│  • Deployed to AWS via Apso tooling                         │
└──────────┬──────────────────┬────────────────────┬──────────┘
           │                  │                    │
           │                  │                    │
           ▼                  ▼                    ▼
    ┌──────────┐       ┌──────────┐        ┌──────────┐
    │ Better   │       │  Stripe  │        │   AWS    │
    │  Auth    │       │ Payments │        │    S3    │
    │ (Tables) │       │  (API)   │        │ (Files)  │
    └──────────┘       └──────────┘        └──────────┘
           │
           │
           ▼
    ┌──────────────────────────────────────┐
    │   PostgreSQL (managed by Apso)       │
    │   • users, sessions (Better Auth)    │
    │   • organizations, projects          │
    │   • subscriptions (linked to Stripe) │
    │   • audit_logs                       │
    └──────────────────────────────────────┘

    ┌────────────────────────────────────────┐
    │  Real-Time Service (Optional, Phase 2) │
    │  Socket.io + Redis Pub/Sub             │
    │  (For notifications, presence)         │
    └────────────────────────────────────────┘

    ┌──────────────────────────────────────┐
    │  External Services                    │
    │  • Postmark (email)                  │
    │  • Sentry (errors)                   │
    │  • PostHog (analytics)               │
    │  • OpenAI / Claude (AI)              │
    └──────────────────────────────────────┘
```

---

## How Apso + Better Auth Work Together

### 1. Initial Setup

**Step 1:** Install Apso CLI
```bash
npm install -g @apso/cli
cd server
npx @apso/cli init
```

**Step 2:** Define your schema
```
I need a SaaS with:
- Users (email, name, avatar)
- Organizations (name, billing)
- Projects (name, description, owner)
- Subscriptions (linked to Stripe)
```

**Step 3:** Generate backend code
```bash
npx @apso/cli generate --schema ../context/APSO_SCHEMA_PROMPT.md
```

Apso generates:
- NestJS backend code with TypeORM entities
- PostgreSQL database schema
- REST API endpoints (CRUD for all resources)
- OpenAPI documentation
- AWS deployment configuration

**Step 4:** Install dependencies and start server
```bash
npm install
npm run start:dev
```

**Step 5:** Add Better Auth tables to Apso's PostgreSQL
```bash
npx better-auth generate
```

This creates:
- `users` table (email, password_hash, etc.)
- `sessions` table (token, user_id, expires_at)
- `accounts` table (OAuth providers)

**Step 6:** Configure Better Auth to use Apso's database
```typescript
// auth.ts
import { betterAuth } from "better-auth"
import { pgAdapter } from "better-auth/adapters/postgres"

export const auth = betterAuth({
  database: pgAdapter({
    host: process.env.APSO_DB_HOST,
    database: process.env.APSO_DB_NAME,
    user: process.env.APSO_DB_USER,
    password: process.env.APSO_DB_PASSWORD,
    ssl: true
  }),
  emailAndPassword: {
    enabled: true
  },
  socialProviders: {
    google: {
      clientId: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET
    }
  }
})
```

### 2. Authentication Flow

**Signup/Login (Frontend):**
```typescript
// app/login/page.tsx
import { signIn } from "@/lib/auth-client"

export default function LoginPage() {
  async function handleLogin(email: string, password: string) {
    const result = await signIn.email({
      email,
      password
    })

    if (result.success) {
      // Redirect to dashboard
      router.push("/dashboard")
    }
  }

  return <LoginForm onSubmit={handleLogin} />
}
```

**Session Verification (Middleware):**
```typescript
// middleware.ts
import { auth } from "@/lib/auth"

export async function middleware(request: NextRequest) {
  const session = await auth.api.getSession({
    headers: request.headers
  })

  if (!session) {
    return NextResponse.redirect("/login")
  }

  // Add user to request
  request.headers.set("x-user-id", session.user.id)
  return NextResponse.next()
}
```

**Protecting Apso API Calls:**
```typescript
// app/api/projects/route.ts
import { auth } from "@/lib/auth"

export async function GET(request: Request) {
  // Verify session
  const session = await auth.api.getSession({
    headers: request.headers
  })

  if (!session) {
    return new Response("Unauthorized", { status: 401 })
  }

  // Call Apso API with user context
  const projects = await apsoClient.projects.list({
    user_id: session.user.id
  })

  return Response.json(projects)
}
```

### 3. Multi-Tenancy with Organizations

**Schema in Apso:**
```
organizations:
  - id (uuid)
  - name (string)
  - created_at (timestamp)

users:
  - id (uuid)
  - email (string)
  - name (string)
  - org_id (uuid, references organizations)

projects:
  - id (uuid)
  - org_id (uuid, references organizations)
  - name (string)
  - created_at (timestamp)
```

**Enforcing Org Isolation:**
```typescript
// Every Apso API call filters by org_id
const projects = await apsoClient.projects.list({
  org_id: session.user.org_id  // From Better Auth session
})

// Apso's generated API ensures all queries include org_id filter
// This prevents data leakage across organizations
```

---

## Implementation Phases

### Phase 1: MVP Foundation (Weeks 1-12)

**Week 1-2: Apso Setup**
- [ ] Install Apso CLI: `npm install -g @apso/cli`
- [ ] Define data schema (see APSO_SCHEMA_PROMPT.md)
- [ ] Generate backend code: `npx @apso/cli generate`
- [ ] Install dependencies: `cd server && npm install`
- [ ] Test locally: `npm run start:dev`
- [ ] Deploy to AWS: `npx @apso/cli deploy --env dev`
- [ ] Test API endpoints via OpenAPI docs (http://localhost:3001/api/docs)

**Week 3-4: Frontend Setup**
- [ ] Create Next.js project (`npx create-next-app`)
- [ ] Install Tailwind + shadcn/ui
- [ ] Set up TypeScript + ESLint + Prettier
- [ ] Deploy to Vercel

**Week 5-6: Authentication**
- [ ] Install Better Auth
- [ ] Generate auth tables in Apso's PostgreSQL
- [ ] Configure Better Auth (email/password + Google OAuth)
- [ ] Build login/signup pages (Next.js)
- [ ] Implement middleware for protected routes
- [ ] Test auth flow end-to-end

**Week 7-8: Core Product**
- [ ] Build main UI (dashboard, list views, detail views)
- [ ] Connect frontend to Apso REST API
- [ ] Implement CRUD operations for core resources
- [ ] Add loading states and error handling

**Week 9-10: Payments**
- [ ] Set up Stripe account
- [ ] Create products/prices in Stripe
- [ ] Build checkout page (Stripe Checkout or Elements)
- [ ] Implement webhooks in Apso for payment events
- [ ] Store `stripe_customer_id` in Apso database
- [ ] Test subscription flow

**Week 11-12: Polish & Launch**
- [ ] Add Sentry for error tracking
- [ ] Add PostHog for analytics
- [ ] Set up email notifications (Postmark)
- [ ] Deploy to production (Apso + Vercel)
- [ ] Test with real users

**MVP Complete:** Basic auth, CRUD, payments, deployed

---

### Phase 2: Market Ready (Weeks 13-24)

**Week 13-15: Enhanced Auth**
- [ ] Add MFA/2FA (Better Auth)
- [ ] Add passwordless login (magic links)
- [ ] Build team invitations flow
- [ ] Implement basic RBAC (admin, member, viewer roles)

**Week 16-18: Real-Time Features**
- [ ] Set up Redis Cloud
- [ ] Create Socket.io server (Node.js + Express)
- [ ] Implement in-app notifications
- [ ] Add notification center UI
- [ ] Connect Apso events → Socket.io

**Week 19-21: Audit & Compliance**
- [ ] Add audit_logs table in Apso
- [ ] Log all create/update/delete actions
- [ ] Build audit log viewer (admin)
- [ ] Add GDPR export functionality
- [ ] Write privacy policy + terms

**Week 22-24: API & Integrations**
- [ ] Complete Apso API for all resources
- [ ] Add webhooks (outgoing) from Apso
- [ ] Build API key management UI
- [ ] Add CSV import/export
- [ ] Set up feature flags (PostHog)

**Market Ready Complete:** MFA, real-time, audit logs, API

---

### Phase 3: Enterprise (Weeks 25-48)

**Week 25-28: SSO/SAML**
- [ ] Set up WorkOS account
- [ ] Integrate WorkOS with Better Auth
- [ ] Build SSO configuration UI for admins
- [ ] Test with Okta/Google Workspace
- [ ] Add SCIM for user provisioning

**Week 29-32: Advanced RBAC**
- [ ] Build custom roles UI (admin can define roles)
- [ ] Add permissions table in Apso
- [ ] Implement fine-grained permissions checks
- [ ] Add resource-level permissions

**Week 33-40: Workflow Automation**
- [ ] Design workflow builder UI (no-code)
- [ ] Implement trigger system (events in Apso)
- [ ] Build action system (HTTP calls, Apso API, etc.)
- [ ] Add workflow debugging tools

**Week 41-48: Enterprise Features**
- [ ] Multi-region deployment (Apso)
- [ ] White-labeling support (custom domains, branding)
- [ ] Advanced analytics (cohorts, funnels)
- [ ] Start SOC 2 audit process

**Enterprise Ready Complete:** SSO, custom roles, workflows, SOC 2 in progress

---

## Key Decisions Made

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Backend | Apso | Eliminates backend/DevOps work, instant API |
| Frontend | Next.js + TypeScript | Modern, SSR, best DX, Vercel integration |
| UI | Tailwind + shadcn/ui | Fast, consistent, copy-paste components |
| Auth | Better Auth | Lightweight, modern, integrates with Apso |
| Database | PostgreSQL (via Apso) | Relational, ACID, mature, auto-generated |
| Payments | Stripe | Industry standard, handles all complexity |
| Email | Postmark | Best deliverability for transactional |
| File Storage | AWS S3 | Scalable, secure, already in Apso AWS account |
| Errors | Sentry | Best-in-class, free tier generous |
| Analytics | PostHog | Open source, privacy-friendly, feature flags built-in |
| Real-Time | Socket.io + Redis | Standard, scales with Redis Pub/Sub |
| AI | OpenAI / Claude | Best LLMs for search, copilots, generation |
| CI/CD | GitHub Actions | Free, integrated with GitHub |

---

## Next Steps

1. **Read:** SAAS_IMPLEMENTATION_GUIDE.md for detailed implementation steps
2. **Set up:** Apso account and first project
3. **Define:** Your data schema in Apso
4. **Follow:** Week-by-week implementation guide
5. **Deploy:** MVP in 8-12 weeks

---

**Last Updated:** 2025-01-10
**Stack Version:** 1.0
**Apso Platform:** https://app.staging.apso.cloud/
