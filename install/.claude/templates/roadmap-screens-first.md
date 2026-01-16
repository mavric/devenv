# Development Roadmap: [PROJECT_NAME] (Screens-First)

**Created:** [DATE]
**Last Updated:** [DATE]
**Status:** Planning | In Progress | Complete
**Approach:** Screens-First Development

---

## Why Screens-First?

This roadmap uses a **screens-first** approach where:
1. All UI is built first with mock data (Phases 1-2)
2. Backend/API is added after screens work (Phase 3)
3. Complex features like billing come next (Phase 4)
4. Authentication is added last (Phase 5)
5. Polish and QA finalizes everything (Phase 6)

**Benefits:**
- Faster visual feedback and stakeholder validation
- UI/UX issues caught before backend investment
- Easier to demo and test without auth complexity
- Backend schema informed by actual UI needs

---

## Phase Overview

| Phase | Focus | Auth Required | Duration |
|-------|-------|---------------|----------|
| **Phase 1** | Foundation & Layout | No | Week 1 |
| **Phase 2** | All Screens (mock data) | No | Week 2-3 |
| **Phase 3** | Backend Schema & API | No | Week 4-5 |
| **Phase 4** | Billing & Payments | No | Week 6 |
| **Phase 5** | Authentication | Yes | Week 7-8 |
| **Phase 6** | Polish & QA | Yes | Week 9-10 |

**Work through phases sequentially.** Complete all tasks in a phase before moving to the next.

---

## Phase 1: Foundation & Layout

**Goal:** Project scaffolding with layout and navigation working (no auth)
**Exit Criteria:** All routes exist, layout responsive, navigation works

### Deliverables

#### 1.1 Project Setup
- [ ] Initialize Next.js 15 with TypeScript and App Router
- [ ] Configure Tailwind CSS + shadcn/ui design system
- [ ] Set up project-appropriate color scheme
- [ ] Configure development environment

#### 1.2 Layout Components
- [ ] `GlobalNav` - Sidebar navigation (240px)
- [ ] `AppLayout` - Main wrapper
- [ ] `EntityLayout` - Entity detail wrapper
- [ ] `EntityHeader` - Breadcrumb + actions
- [ ] `EntityTabs` - Sub-navigation

#### 1.3 Route Structure
- [ ] Create all 30+ routes as page shells
- [ ] Dashboard route
- [ ] List pages for each entity
- [ ] Detail pages with tabs
- [ ] Settings pages

#### 1.4 Responsive Design
- [ ] Mobile-responsive layout
- [ ] Primary device optimization (tablet/desktop)
- [ ] Dark/light theme support

### Phase 1 Checklist
- [ ] Layout components created
- [ ] All routes navigable
- [ ] Responsive on all devices
- [ ] Theme toggle works

---

## Phase 2: All Screens (Mock Data)

**Goal:** Every screen fully built with mock data
**Exit Criteria:** Complete UI, all interactions work with mock data

### Deliverables

#### 2.1 Dashboard
- [ ] Summary cards/metrics
- [ ] Recent activity
- [ ] Quick actions
- [ ] Charts/graphs

#### 2.2 List Pages
For each entity:
- [ ] Data table with sorting
- [ ] Search and filters
- [ ] Card/table view toggle
- [ ] Pagination
- [ ] Empty states
- [ ] Loading states

#### 2.3 Detail Pages
For each entity:
- [ ] Overview tab
- [ ] Related data tabs
- [ ] Edit/delete actions
- [ ] Status badges

#### 2.4 Forms
- [ ] Create modals/pages
- [ ] Edit modals/pages
- [ ] Form validation (Zod)
- [ ] Error states

#### 2.5 Schedule/Calendar (if applicable)
- [ ] Day view
- [ ] Week view
- [ ] Month view
- [ ] Event creation

#### 2.6 Reports (if applicable)
- [ ] Report filters
- [ ] Data visualization
- [ ] Export functionality

### Phase 2 Checklist
- [ ] All list pages complete
- [ ] All detail pages complete
- [ ] All forms working with mock data
- [ ] All interactions functional
- [ ] Loading and error states

---

## Phase 3: Backend Schema & API

**Goal:** Real API replacing mock data
**Exit Criteria:** All screens fetch from real API

### Deliverables

#### 3.1 Schema Design
- [ ] Define all entities in `.apsorc`
- [ ] Configure relationships
- [ ] Add validation rules
- [ ] Enable multi-tenancy

#### 3.2 Apso Setup
- [ ] Initialize Apso service
- [ ] Configure database connection
- [ ] Generate NestJS backend
- [ ] Run migrations

**Important:** Follow APSO-SETUP-LEARNINGS.md for configuration.

#### 3.3 API Client
- [ ] Create typed API client
- [ ] Implement React Query hooks
- [ ] Add error handling
- [ ] Configure organization context headers

#### 3.4 Data Seeding
- [ ] Create seed script
- [ ] Seed test organization
- [ ] Seed test users
- [ ] Seed sample data

#### 3.5 Wire Up Screens
- [ ] Replace mock data with API calls
- [ ] Test all CRUD operations
- [ ] Verify filtering and search
- [ ] Test pagination

### Phase 3 Checklist
- [ ] Schema complete and valid
- [ ] API server running
- [ ] All endpoints tested
- [ ] Frontend connected to real API
- [ ] Data seeded for testing

---

## Phase 4: Billing & Payments (if applicable)

**Goal:** Stripe integration for subscriptions/payments
**Exit Criteria:** Users can subscribe, payments process correctly

### Deliverables

#### 4.1 Stripe Setup
- [ ] Create Stripe products/prices
- [ ] Configure webhook endpoint
- [ ] Set up test mode

#### 4.2 Subscription Flow
- [ ] Plan selection page
- [ ] Checkout flow
- [ ] Success/cancel handling
- [ ] Subscription management

#### 4.3 Billing Portal
- [ ] View invoices
- [ ] Update payment method
- [ ] Cancel subscription
- [ ] Plan upgrades/downgrades

#### 4.4 Billing Logic
- [ ] Entitlement checks
- [ ] Usage tracking (if needed)
- [ ] Invoice generation

### Phase 4 Checklist
- [ ] Stripe webhook working
- [ ] Checkout flow complete
- [ ] Portal accessible
- [ ] Test payments successful

---

## Phase 5: Authentication

**Goal:** Real authentication with BetterAuth
**Exit Criteria:** Users can register, login, and access org-scoped data

### Deliverables

#### 5.1 BetterAuth Setup
- [ ] Configure BetterAuth server
- [ ] Set up session management
- [ ] Configure OAuth providers (optional)

#### 5.2 Auth Pages
- [ ] Login page
- [ ] Registration page
- [ ] Forgot password
- [ ] Reset password
- [ ] Email verification

#### 5.3 Protected Routes
- [ ] Auth middleware
- [ ] Session validation
- [ ] Redirect logic

#### 5.4 Organization Context
- [ ] Organization selection
- [ ] Multi-org support (if needed)
- [ ] Invite flow

#### 5.5 Remove Test Mode
- [ ] Remove E2E_TEST_MODE bypass
- [ ] Clean up test context
- [ ] Final auth testing

### Phase 5 Checklist
- [ ] Registration works
- [ ] Login/logout works
- [ ] Protected routes enforced
- [ ] Organization scoping works
- [ ] Password reset works

---

## Phase 6: Polish & QA

**Goal:** Production-ready quality
**Exit Criteria:** Ready for public launch

### Deliverables

#### 6.1 Testing
- [ ] Unit test coverage
- [ ] Integration tests
- [ ] E2E test suite
- [ ] Manual QA checklist

#### 6.2 Performance
- [ ] API optimization
- [ ] Frontend bundle optimization
- [ ] Database indexes
- [ ] Caching strategy

#### 6.3 Security
- [ ] Security audit
- [ ] OWASP checklist
- [ ] Dependency audit
- [ ] Compliance review (HIPAA, etc.)

#### 6.4 Deployment
- [ ] Production environment
- [ ] CI/CD pipeline
- [ ] Monitoring (Sentry)
- [ ] Analytics

#### 6.5 Documentation
- [ ] User documentation
- [ ] API documentation
- [ ] Deployment runbook

### Phase 6 Checklist
- [ ] 80%+ test coverage
- [ ] Security issues resolved
- [ ] Performance targets met
- [ ] Documentation complete
- [ ] Production deployed

---

## E2E Test Mode Pattern

During Phases 1-4, use E2E test mode to bypass authentication:

### Frontend (.env.local)
```bash
NEXT_PUBLIC_E2E_TEST_MODE=true
E2E_TEST_MODE=true
```

### Middleware
```typescript
const isTestMode = process.env.NEXT_PUBLIC_E2E_TEST_MODE === "true"
  || process.env.E2E_TEST_MODE === "true";

if (isTestMode) {
  return NextResponse.next(); // Skip auth
}
```

### Test Context
Create a test context provider to:
- Fetch organization from seeded data
- Allow switching between test users
- Set X-Organization-Id and X-User-Id headers

**Remove all test mode code in Phase 5.**

---

## Progress Tracking

### Current Status
**Phase:** [1/2/3/4/5/6]
**Week:** [X] of [10]

### Recent Completions
- [DATE]: [MILESTONE]

### Blockers
- [ ] [BLOCKER]

---

**Last Updated:** [DATE]
