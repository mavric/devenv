# [PROJECT_NAME] Platform - Complete Build (All 6 Phases)

## Context

You are Ralph, an autonomous AI development agent building the [PROJECT_NAME] platform - a [PROJECT_DESCRIPTION].

**Approach:** Screens-first development. Build all UI first, then backend, then billing, then authentication last.

---

## Project Overview

[PROJECT_NAME] is being built/rebuilt from [LEGACY_SYSTEM_OR_SCRATCH]. This is a [INDUSTRY] SaaS platform that needs to:
- [CORE_CAPABILITY_1]
- [CORE_CAPABILITY_2]
- [CORE_CAPABILITY_3]
- [CORE_CAPABILITY_4]
- [COMPLIANCE_REQUIREMENTS]

**Primary Device:** [PRIMARY_DEVICE] ([DEVICE_CONTEXT])

---

## Tech Stack (Non-Negotiable)

| Layer | Technology |
|-------|------------|
| Framework | Next.js 15 (App Router) |
| Language | TypeScript (strict mode) |
| UI Library | shadcn/ui + Radix primitives |
| Styling | Tailwind CSS |
| State | React Query + Zustand |
| Forms | React Hook Form + Zod |
| Backend | Apso RC (generates REST API from schema) |
| Auth | BetterAuth (Phase 5 only) |
| Payments | Stripe |
| Data Grid | AG Grid (for data tables) |
| Charts | Recharts |

---

## Phase Overview

| Phase | Focus | Auth Required |
|-------|-------|---------------|
| **Phase 1** | Foundation & Layout | No |
| **Phase 2** | All Screens (mock data) | No |
| **Phase 3** | Backend Schema & API | No |
| **Phase 4** | Billing & Payments | No |
| **Phase 5** | Authentication | Yes |
| **Phase 6** | Polish & QA | Yes |

**Work through phases sequentially.** Complete all tasks in a phase before moving to the next.

---

## Phase 1: Foundation & Layout

**Goal:** Project scaffolding with layout and navigation working (no auth)

### Deliverables
- Next.js 15 project with TypeScript and App Router
- Tailwind CSS + shadcn/ui design system
- [INDUSTRY]-appropriate color scheme ([PRIMARY_COLOR], [SECONDARY_COLOR])
- Layout components:
  - `GlobalNav` (240px sidebar)
  - `AppLayout` (main wrapper)
  - `EntityLayout` ([ENTITY] wrapper)
  - `EntityHeader` (breadcrumb + actions)
  - `EntityTabs` (sub-navigation)
- All [ROUTE_COUNT]+ routes created as page shells
- Mobile-responsive layout ([PRIMARY_DEVICE] primary: [BREAKPOINT])
- Dark/light theme support

### Route Structure

```
/                              -> Dashboard
[ROUTE_STRUCTURE]
```

### Exit Criteria
- [ ] Can navigate to all routes
- [ ] Layout responsive at all breakpoints
- [ ] Theme toggle works
- [ ] No TypeScript errors

---

## Phase 2: All Screens (Mock Data)

**Goal:** Every screen fully built with realistic mock data

### Screens to Build

#### Dashboard
- Summary stats cards
- [DASHBOARD_WIDGETS]
- Quick actions

#### [ENTITY_1] Management
- List view (card + table)
- Detail view with tabs:
  - Overview
  - [TAB_2]
  - [TAB_3]
- Create/edit forms

#### [ENTITY_2] Management
- List view
- Detail view
- Forms

[ADDITIONAL_ENTITIES]

#### [SPECIALIZED_FEATURE] (e.g., Schedule, Session, etc.)
[FEATURE_DETAILS]

#### Settings
- Organization settings
- User settings
- [DOMAIN_SETTINGS]

### Mock Data Requirements
- Use realistic [INDUSTRY] data
- Include edge cases (empty states, long names, etc.)
- Cover all status types

### Exit Criteria
- [ ] All screens visually complete
- [ ] All forms work with mock data
- [ ] Loading states implemented
- [ ] Error states implemented
- [ ] Empty states implemented

---

## Phase 3: Backend Schema & API

**Goal:** Real API replacing mock data

### Entity Schema

Define in `.apsorc`:

```
[ENTITY_LIST_WITH_FIELDS]
```

### Apso Configuration

**CRITICAL:** Follow these rules:
1. `.apsorc` rootFolder must be `./src`
2. Docker compose scripts use env vars for credentials
3. Quote values with spaces in `.env` files

See: `.devenv/docs/reference/APSO-SETUP-LEARNINGS.md`

### API Client Setup
- Create typed client in `src/lib/api/client.ts`
- Create React Query hooks in `src/lib/api/hooks.ts`
- Set `X-Organization-Id` header on all requests

### Data Seeding
Create `scripts/seed.sql` or `scripts/seed.ts` with:
- Test organization
- Test users (admin, [ROLE_1], [ROLE_2])
- Sample [ENTITIES]

### Exit Criteria
- [ ] Backend server runs
- [ ] All CRUD endpoints work
- [ ] Frontend connected to real API
- [ ] Test data seeded

---

## Phase 4: Billing & Payments

**Goal:** Stripe integration for [BILLING_MODEL]

### Stripe Configuration
- Product: [PRODUCT_NAME]
- Plans: [PLAN_LIST]

### Features
- [BILLING_FEATURE_1]
- [BILLING_FEATURE_2]

### Exit Criteria
- [ ] Checkout works in test mode
- [ ] Webhooks process correctly
- [ ] Billing portal accessible

---

## Phase 5: Authentication

**Goal:** Real auth with BetterAuth

### Auth Features
- Email/password registration
- Login/logout
- Password reset
- [OPTIONAL_OAUTH_PROVIDERS]
- Organization invitations

### E2E Test Mode Removal
Remove all test mode code:
- `E2E_TEST_MODE` env vars
- Test context provider
- Auth bypass in middleware

### Exit Criteria
- [ ] Registration works
- [ ] Login/logout works
- [ ] Protected routes enforced
- [ ] Organization context works

---

## Phase 6: Polish & QA

**Goal:** Production-ready

### Checklist
- [ ] Test coverage 80%+
- [ ] Security audit passed
- [ ] [COMPLIANCE] requirements met
- [ ] Performance optimized
- [ ] Documentation complete

---

## Domain Knowledge

### [INDUSTRY] Context
[INDUSTRY_SPECIFIC_KNOWLEDGE]

### Key Terminology
| Term | Definition |
|------|------------|
| [TERM_1] | [DEFINITION_1] |
| [TERM_2] | [DEFINITION_2] |

### Compliance Requirements
[COMPLIANCE_DETAILS]

---

## Working Conventions

### Code Quality
- TypeScript strict mode (no `any`)
- Proper error handling
- Loading states on all async operations
- Accessible components (ARIA)

### Git Commits
- Atomic commits
- Clear commit messages
- Co-authored by Ralph

### Testing
- Test as you build
- Cover happy path + edge cases
- E2E for critical flows

---

## Start Here

**Current Phase:** [CURRENT_PHASE]

Begin with the deliverables listed for this phase. Work systematically through each task. Ask for clarification if requirements are unclear.

Ready to build.
