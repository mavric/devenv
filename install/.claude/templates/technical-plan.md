# Technical Plan: [PROJECT_NAME]

**Created:** [DATE]
**Author:** Claude (Technical Planner)
**Status:** Draft | Approved | In Progress

---

## Executive Summary

[One paragraph summarizing the technical approach, key decisions, and timeline]

---

## 1. Technical Context

### 1.1 Project Overview

| Attribute | Value |
|-----------|-------|
| Project Name | [NAME] |
| Project Type | SaaS Application |
| Target Users | [PERSONAS] |
| Estimated Timeline | [WEEKS] weeks |

### 1.2 Requirements Summary

**From Discovery:**
- [KEY_REQUIREMENT_1]
- [KEY_REQUIREMENT_2]
- [KEY_REQUIREMENT_3]

**Core Workflows:**
1. [WORKFLOW_1]
2. [WORKFLOW_2]
3. [WORKFLOW_3]

### 1.3 Technical Constraints

| Constraint | Details |
|------------|---------|
| Performance | API < 500ms, Page load < 2s |
| Scale | [CONCURRENT_USERS] concurrent users |
| Compliance | [GDPR/HIPAA/SOC2/None] |
| Integrations | [EXTERNAL_SYSTEMS] |

---

## 2. Architecture Decisions

### 2.1 Technology Stack

| Layer | Technology | Rationale |
|-------|------------|-----------|
| Backend Framework | NestJS (via Apso) | Type-safe, modular, enterprise-ready |
| Database | PostgreSQL | ACID compliance, JSON support, proven scale |
| Frontend Framework | Next.js 14 | App Router, SSR, React ecosystem |
| Authentication | BetterAuth | Self-hosted, flexible, multi-tenant |
| Testing | Cucumber/Gherkin | BDD approach, executable specifications |
| Deployment | Vercel + Railway | Serverless frontend, managed backend |

### 2.2 Architecture Pattern

```
┌─────────────────────────────────────────────────────────────┐
│                        Frontend                              │
│                    (Next.js 14 + shadcn/ui)                 │
└─────────────────────────┬───────────────────────────────────┘
                          │ REST API
┌─────────────────────────┴───────────────────────────────────┐
│                        Backend                               │
│                    (NestJS via Apso)                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Auth      │  │   Entities  │  │   Services  │         │
│  │ (BetterAuth)│  │   (CRUD)    │  │  (Business) │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────┬───────────────────────────────────┘
                          │
┌─────────────────────────┴───────────────────────────────────┐
│                      PostgreSQL                              │
│              (Multi-tenant, Row-level security)             │
└─────────────────────────────────────────────────────────────┘
```

### 2.3 Key Architectural Decisions

#### Decision 1: [DECISION_TITLE]

**Context:** [Why this decision was needed]

**Options Considered:**
1. Option A - [Description]
2. Option B - [Description]
3. Option C - [Description]

**Decision:** Option [X]

**Rationale:** [Why this option was chosen]

**Consequences:**
- Positive: [Benefits]
- Negative: [Trade-offs]

---

## 3. Project Structure

### 3.1 Directory Layout

```
[project-name]/
├── .claude/
│   ├── constitution.md          # Project principles
│   ├── commands/                 # Custom commands
│   └── templates/                # Document templates
├── docs/
│   ├── discovery/
│   │   ├── discovery-notes.md   # Interview transcript
│   │   └── discovery-summary.md # Structured requirements
│   ├── scenarios/
│   │   ├── api/                 # API test scenarios
│   │   ├── ui/                  # UI test scenarios
│   │   └── e2e/                 # E2E test scenarios
│   └── plans/
│       ├── technical-plan.md    # This document
│       ├── roadmap.md           # Phased delivery plan
│       └── architecture.md      # Detailed architecture
├── backend/
│   ├── .apsorc                  # Schema definition
│   ├── src/
│   │   ├── autogen/             # Generated code (don't edit)
│   │   └── extensions/          # Custom logic
│   ├── test/                    # Backend tests
│   └── .env                     # Environment config
├── frontend/
│   ├── src/
│   │   ├── app/                 # Next.js pages
│   │   ├── components/          # React components
│   │   └── lib/                 # Utilities
│   └── .env.local               # Frontend config
└── tests/
    ├── step-definitions/        # Cucumber step definitions
    └── fixtures/                # Test data
```

### 3.2 Code Organization Principles

1. **Separation of Concerns** - Each layer has clear responsibilities
2. **Feature-based Organization** - Group by feature, not by type
3. **Generated vs Custom** - Clear separation of auto-generated code
4. **Test Proximity** - Tests near the code they test

---

## 4. Data Model Summary

### 4.1 Core Entities

| Entity | Description | Key Fields |
|--------|-------------|------------|
| Organization | Tenant root | id, name, slug |
| User | System users | id, email, organizationId |
| [ENTITY_1] | [Description] | [Fields] |
| [ENTITY_2] | [Description] | [Fields] |

### 4.2 Entity Relationship Diagram

```mermaid
erDiagram
    Organization ||--o{ User : has
    Organization ||--o{ [ENTITY_1] : has
    [ENTITY_1] ||--o{ [ENTITY_2] : has
    User ||--o{ [ENTITY_2] : creates
```

*Full schema: See `backend/.apsorc`*

---

## 5. Phase Breakdown

### Phase 1: Foundation (Weeks 1-2)

**Objective:** Core infrastructure and authentication

**Deliverables:**
- [ ] Project initialization
- [ ] Backend bootstrap with Apso
- [ ] Frontend bootstrap with Next.js
- [ ] Authentication (login, signup, logout)
- [ ] Organization management
- [ ] User profile

**Scenarios:** 25-30 (Auth + Org + User)

**Exit Criteria:**
- Users can sign up, log in, create organization
- All Phase 1 Gherkin scenarios pass

### Phase 2: Core Features (Weeks 3-5)

**Objective:** Primary business functionality

**Deliverables:**
- [ ] [FEATURE_1] CRUD
- [ ] [FEATURE_2] CRUD
- [ ] [FEATURE_3] workflows

**Scenarios:** 40-50

**Exit Criteria:**
- Core workflows functional
- All Phase 2 Gherkin scenarios pass

### Phase 3: Advanced Features (Weeks 6-8)

**Objective:** Secondary features and integrations

**Deliverables:**
- [ ] [FEATURE_4]
- [ ] [FEATURE_5]
- [ ] Notifications
- [ ] Search/filtering

**Scenarios:** 30-40

**Exit Criteria:**
- All planned features complete
- All Phase 3 Gherkin scenarios pass

### Phase 4: Polish & Launch (Weeks 9-10)

**Objective:** Production readiness

**Deliverables:**
- [ ] Performance optimization
- [ ] Security audit
- [ ] E2E test suite complete
- [ ] Deployment pipeline
- [ ] Monitoring setup

**Exit Criteria:**
- 80%+ test coverage
- Security audit passed
- Production deployment successful

---

## 6. Risk Assessment

### 6.1 Technical Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| [RISK_1] | Medium | High | [MITIGATION] |
| [RISK_2] | Low | Medium | [MITIGATION] |

### 6.2 Dependencies

| Dependency | Type | Risk Level | Contingency |
|------------|------|------------|-------------|
| Apso | Framework | Low | Well-documented, stable |
| BetterAuth | Library | Low | Fallback to NextAuth |
| [EXTERNAL_API] | Integration | Medium | [CONTINGENCY] |

---

## 7. Quality Standards

### 7.1 Code Quality

- TypeScript strict mode
- ESLint + Prettier
- No `any` types
- Conventional commits

### 7.2 Testing Standards

| Layer | Coverage Target | Type |
|-------|-----------------|------|
| API | 40% of scenarios | Unit + Integration |
| UI | 45% of scenarios | Component + Integration |
| E2E | 15% of scenarios | Full workflow |

### 7.3 Performance Targets

| Metric | Target |
|--------|--------|
| API Response | < 500ms (p95) |
| Page Load | < 2s (p95) |
| Time to Interactive | < 3s |
| Lighthouse Score | > 90 |

---

## 8. Next Steps

1. **Immediate:** Review and approve this technical plan
2. **Day 1:** Run `/init` to scaffold project structure
3. **Day 1-2:** Bootstrap backend with Apso
4. **Day 2-3:** Bootstrap frontend with Next.js
5. **Week 1:** Implement Phase 1 (Authentication)

---

## Appendix

### A. Reference Documents

- Discovery: `docs/discovery/discovery-notes.md`
- Scenarios: `docs/scenarios/`
- Schema: `backend/.apsorc`
- Constitution: `.claude/constitution.md`

### B. Technology Resources

- [Apso Documentation](https://apso.dev)
- [BetterAuth Docs](https://betterauth.dev)
- [Next.js 14 Docs](https://nextjs.org/docs)
- [shadcn/ui](https://ui.shadcn.com)

---

**Approval:**

- [ ] Technical plan approved by: _____________ Date: _______
