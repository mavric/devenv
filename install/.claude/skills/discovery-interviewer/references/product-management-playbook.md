# Product Management Playbook: Best Practices & Industry Standards

> Guidance for common SaaS product decisions and patterns

---

## Core SaaS Patterns

### Multi-Tenancy Architecture

**Standard Pattern:**
```
Organization (Tenant)
├── Users (belong to organization)
├── Projects (scoped to organization)
├── Tasks (scoped to organization)
└── Settings (per organization)
```

**Key principles:**
1. **Organization is the top-level container**
   - All data has `organization_id` foreign key
   - Queries automatically filter by organization
   - Users belong to one or more organizations

2. **User-Organization relationship**
   - Many-to-many (users can join multiple orgs)
   - Junction table: `organization_users` with role
   - Current organization stored in session/token

3. **Data isolation**
   - Database: Row-level security with organization_id
   - API: Middleware injects organization filter
   - UI: Context provider tracks current organization

**Common variations:**
- **Single-org users:** Simpler (many-to-one), less flexible
- **Workspace model:** Organization → Workspaces → Data (adds layer)
- **Account hierarchy:** Parent accounts own child accounts (enterprise)

**Choose based on:**
- Single-org if users never switch contexts
- Multi-org if users work across multiple companies
- Hierarchy if serving enterprises with complex structures

---

### User Roles & Permissions

**Standard RBAC (Role-Based Access Control):**

```
Owner
├── Full control
├── Billing management
├── User management
└── Can delete organization

Admin
├── User management
├── Settings management
├── Cannot access billing
└── Cannot delete organization

Manager
├── Create/edit/delete projects
├── Assign tasks
├── View reports
└── Cannot manage users

Member
├── Create/edit own tasks
├── Comment on projects
├── View assigned projects
└── Cannot delete or assign

Viewer (Read-only)
├── View projects
├── View tasks
└── No create/edit/delete
```

**Permission patterns:**

**Option A: Boolean flags** (simple, rigid)
```typescript
user.canCreateProjects
user.canEditTasks
user.canDeleteUsers
```

**Option B: Role-based** (flexible, scalable)
```typescript
enum Role { Owner, Admin, Manager, Member, Viewer }
const permissions = {
  [Role.Owner]: ['*'],
  [Role.Admin]: ['users.manage', 'projects.*', 'tasks.*'],
  [Role.Manager]: ['projects.*', 'tasks.*'],
  [Role.Member]: ['tasks.create', 'tasks.edit_own'],
  [Role.Viewer]: ['*.read']
}
```

**Option C: Custom permissions** (most flexible, complex)
```typescript
// User has specific permissions assigned
user.permissions = ['projects.create', 'tasks.edit', 'reports.view']
```

**Industry standard:** Start with Option B (role-based), add Option C if enterprise customers need custom roles.

---

### Data Lifecycle

**Standard CRUD patterns:**

#### Create
```
Validation → Authorization → Create → Notification → Response
```

**Best practices:**
- ✅ Validate client-side (instant feedback)
- ✅ Validate server-side (security)
- ✅ Return full created object with ID
- ✅ Set `created_at`, `created_by` automatically
- ✅ Emit event for audit log

#### Read
```
Authorization → Fetch → Filter → Paginate → Response
```

**Best practices:**
- ✅ Filter by organization automatically
- ✅ Paginate by default (limit: 20-50)
- ✅ Allow sorting (created_at desc default)
- ✅ Support search/filter query params
- ✅ Return total count for pagination

#### Update
```
Authorization → Fetch → Validate → Update → Notification → Response
```

**Best practices:**
- ✅ Verify user can edit this specific record
- ✅ Update `updated_at` automatically
- ✅ Track `updated_by` for audit
- ✅ Support partial updates (PATCH)
- ✅ Return updated object

#### Delete
```
Authorization → Fetch → Check Dependencies → Delete → Response
```

**Deletion strategies:**

**Hard delete** (permanent)
```sql
DELETE FROM projects WHERE id = $1
```
- ✅ Pros: Clean, no storage waste
- ❌ Cons: Irreversible, breaks audit trails

**Soft delete** (mark as deleted)
```sql
UPDATE projects SET deleted_at = NOW() WHERE id = $1
```
- ✅ Pros: Recoverable, maintains history
- ❌ Cons: Uses storage, complicates queries

**Archive** (move to archive table)
```sql
INSERT INTO projects_archive SELECT * FROM projects WHERE id = $1;
DELETE FROM projects WHERE id = $1;
```
- ✅ Pros: Clean active tables, maintains history
- ❌ Cons: Complex queries across tables

**Industry standard:** Soft delete for user data, hard delete for system data.

**Cascade rules:**
- **Prevent:** Delete fails if dependencies exist
  - Use for: High-value data (projects with tasks)
- **Cascade:** Delete children automatically
  - Use for: Owned data (organization → all data)
- **Nullify:** Set foreign key to null
  - Use for: Optional relationships (task → assigned user)

---

### Forms & Validation

**Standard form UX:**

1. **Client-side validation** (immediate)
   - Required fields: Show error on blur
   - Format validation: Show error on blur
   - Complex validation: Show on submit

2. **Server-side validation** (always)
   - Never trust client
   - Validate all constraints
   - Return structured errors

3. **Error display**
   - Inline errors below fields
   - Summary at top for multiple errors
   - Focus first error field
   - Preserve user input

4. **Submit states**
   - Loading: Disable form, show spinner
   - Success: Show message, redirect or clear
   - Error: Enable form, show errors

**Validation patterns:**

```typescript
// Field-level validation
{
  email: {
    required: true,
    pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
    message: "Enter a valid email address"
  },
  password: {
    required: true,
    minLength: 8,
    pattern: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/,
    message: "Password must be 8+ chars with uppercase, lowercase, and number"
  },
  projectName: {
    required: true,
    maxLength: 100,
    unique: true, // Check against database
    message: "Project name must be unique and under 100 characters"
  }
}
```

**Error response format:**
```json
{
  "error": "Validation failed",
  "details": [
    {
      "field": "email",
      "message": "Email is required",
      "code": "REQUIRED_FIELD"
    },
    {
      "field": "projectName",
      "message": "Project with this name already exists",
      "code": "DUPLICATE_VALUE"
    }
  ]
}
```

---

### Pagination & Filtering

**Standard pagination:**

**Option A: Offset-based** (simple, familiar)
```
GET /api/projects?page=2&limit=20
```
- ✅ Pros: Easy to implement, user can jump to page
- ❌ Cons: Slow for large datasets, inconsistent with concurrent changes

**Option B: Cursor-based** (scalable, consistent)
```
GET /api/projects?cursor=abc123&limit=20
```
- ✅ Pros: Fast, consistent results
- ❌ Cons: Can't jump to arbitrary page

**Industry standard:** Offset for <10k records, cursor for >10k or real-time data.

**Response format:**
```json
{
  "data": [ /* items */ ],
  "pagination": {
    "total": 1543,
    "page": 2,
    "limit": 20,
    "totalPages": 78,
    "hasMore": true,
    "nextCursor": "xyz789"
  }
}
```

**Filtering best practices:**
```
# Single filter
GET /api/projects?status=active

# Multiple filters (AND)
GET /api/projects?status=active&priority=high

# Range filters
GET /api/projects?created_after=2024-01-01&created_before=2024-12-31

# Search
GET /api/projects?search=analytics

# Sorting
GET /api/projects?sort=-created_at (desc)
GET /api/projects?sort=name (asc)
```

---

### Error Handling

**HTTP Status Code Standards:**

```
200 OK - Success with response body
201 Created - Resource created successfully
204 No Content - Success with no response body (delete)

400 Bad Request - Validation error, malformed request
401 Unauthorized - Missing or invalid authentication
403 Forbidden - Authenticated but not authorized
404 Not Found - Resource doesn't exist
409 Conflict - Duplicate or constraint violation
422 Unprocessable Entity - Business logic error

500 Internal Server Error - Unexpected server error
503 Service Unavailable - Temporary outage (maintenance)
```

**Error response format:**
```json
{
  "error": "Human-readable error message",
  "code": "MACHINE_READABLE_CODE",
  "details": { /* additional context */ },
  "timestamp": "2024-01-15T10:30:00Z",
  "requestId": "req_abc123"
}
```

**User-facing messages:**

❌ **Don't expose technical details:**
```
"Foreign key constraint violation on table projects"
```

✅ **Translate to user language:**
```
"Cannot delete project because it has active tasks"
```

**Retry guidance:**
```json
{
  "error": "Service temporarily unavailable",
  "code": "SERVICE_UNAVAILABLE",
  "retryable": true,
  "retryAfter": 30
}
```

---

### Performance Standards

**Response time targets:**

```
Perceived instant: <100ms
Fast: <500ms
Acceptable: <2s
Slow (needs spinner): >2s
```

**By layer:**
- **API endpoint:** <500ms (p95)
- **Database query:** <100ms (p95)
- **Page load (SSR):** <2s (p95)
- **Page load (CSR):** <3s (p95)

**Optimization patterns:**

**Database:**
- Index foreign keys
- Index commonly filtered columns
- Use connection pooling
- Limit query depth (N+1 problem)

**API:**
- Use pagination (never return unbounded lists)
- Cache static data (Redis, 5-60 min TTL)
- Compress responses (gzip)
- Rate limit (protect against abuse)

**Frontend:**
- Code split by route
- Lazy load images
- Prefetch critical data
- Optimistic UI updates

---

### Security Best Practices

**Authentication:**

**Standard flow:**
1. User submits credentials
2. Server validates against database
3. Server generates JWT token (24h expiry)
4. Client stores token (httpOnly cookie or localStorage)
5. Client includes token in Authorization header
6. Server validates token on each request

**Token payload:**
```json
{
  "userId": "usr_123",
  "organizationId": "org_456",
  "role": "admin",
  "iat": 1704000000,
  "exp": 1704086400
}
```

**Session management:**
- ✅ Expire tokens (24h access, 7d refresh)
- ✅ Revoke on logout (token blacklist)
- ✅ Single sign-on (SSO) for enterprise
- ✅ Multi-factor auth (MFA) for sensitive accounts

**Authorization:**

**Check at every layer:**
```typescript
// Middleware: Verify user authenticated
if (!req.user) throw UnauthorizedException

// Handler: Verify user authorized for THIS resource
const project = await getProject(projectId)
if (project.organizationId !== req.user.organizationId) {
  throw ForbiddenException
}
```

**Common vulnerabilities:**

❌ **Insecure Direct Object Reference (IDOR)**
```typescript
// User can access any project by changing ID
GET /api/projects/123
```
✅ **Fix: Check ownership**
```typescript
if (project.organizationId !== req.user.organizationId) {
  throw ForbiddenException
}
```

❌ **Mass Assignment**
```typescript
// User can set any field, including role
await user.update(req.body)
```
✅ **Fix: Whitelist fields**
```typescript
const allowed = pick(req.body, ['name', 'email'])
await user.update(allowed)
```

**Data protection:**
- ✅ Encrypt passwords (bcrypt, 10+ rounds)
- ✅ Encrypt sensitive data at rest (PII, payment info)
- ✅ Use HTTPS everywhere (no mixed content)
- ✅ Sanitize inputs (prevent XSS, SQL injection)
- ✅ Rate limit auth endpoints (prevent brute force)

---

### Testing Strategy

**Three-layer testing:**

**API Tests (40% of scenarios)**
- Test: Endpoints, validation, business logic
- Tools: Cucumber + Axios
- Focus: CRUD operations, edge cases, auth

**UI Tests (45% of scenarios)**
- Test: Components, forms, interactions
- Tools: Cucumber + Playwright
- Focus: User workflows, visual validation

**E2E Tests (15% of scenarios)**
- Test: Complete user journeys
- Tools: Cucumber + Playwright
- Focus: Critical paths, integration

**Coverage targets:**
```
MVP (Week 2): 60% overall (70% API, 55% UI, 40% E2E)
Features (Week 6): 75% overall (80% API, 70% UI, 60% E2E)
Launch (Week 12): 90% overall (95% API, 85% UI, 80% E2E)
```

**Test prioritization:**

**@smoke (critical paths):**
- User registration/login
- Create primary entity (project, task, etc.)
- Payment/subscription flow
- Data export

**@critical (high value):**
- All CRUD operations
- Permission boundaries
- Integration points

**@regression (everything else):**
- Edge cases
- Error scenarios
- UI variations

---

### Deployment Strategy

**Environment progression:**

```
Local → Staging → Production
```

**Staging environment:**
- Mirrors production (same stack, scaled down)
- Test data (not production data)
- Automated tests run on every PR
- Manual QA before production deploy

**Production deployment:**

**Option A: Blue-Green** (zero downtime)
```
Blue (live) ← Users
Green (new) ← Deploy here, test, then switch
```

**Option B: Canary** (gradual rollout)
```
10% users → New version (monitor)
50% users → New version (monitor)
100% users → New version (complete)
```

**Option C: Rolling** (gradual replacement)
```
Server 1 → Update (Server 2, 3 handle traffic)
Server 2 → Update (Server 1, 3 handle traffic)
Server 3 → Update (Server 1, 2 handle traffic)
```

**Industry standard:** Blue-green for SaaS (simple, safe, fast rollback).

**CI/CD pipeline:**
```
1. Push code → GitHub
2. Run tests → GitHub Actions
3. Build Docker image → Registry
4. Deploy to staging → Auto
5. Run smoke tests → Auto
6. Deploy to production → Manual approval
7. Monitor errors → Auto alerts
```

---

### Pricing Models

**Common SaaS pricing strategies:**

**1. Flat-rate subscription**
```
$29/month - Unlimited everything
```
- ✅ Simple, predictable
- ❌ Leaves money on table (power users underpay)

**2. Tiered pricing** (most common)
```
Free: 3 projects, 10 tasks
Starter: $9/mo - 10 projects, 100 tasks
Pro: $29/mo - 50 projects, 1000 tasks
Business: $99/mo - Unlimited, priority support
```
- ✅ Serves multiple customer segments
- ✅ Clear upgrade path
- ❌ Requires balancing limits

**3. Per-user pricing**
```
$10/user/month
```
- ✅ Scales with customer growth
- ❌ Disincentivizes adding users

**4. Usage-based pricing**
```
$0.10 per API call
$0.01 per task created
```
- ✅ Fair (pay for what you use)
- ❌ Unpredictable costs

**5. Hybrid** (best for SaaS)
```
Base: $29/mo (includes 5 users)
Additional user: $5/user/month
Overage: $0.10 per task over 1000
```

**Industry standard:** Tiered pricing with clear limits, 3-4 tiers, ~3-4x price jumps.

**Free tier strategy:**
- Include to drive adoption
- Limit to prevent abuse
- Make upgrade path obvious
- Typical limit: 10-20% of paid tier

---

### Analytics & Metrics

**Core SaaS metrics:**

**Acquisition:**
- Signups per week/month
- Signup source (organic, paid, referral)
- Cost per acquisition (CPA)

**Activation:**
- % of signups who complete onboarding
- Time to first value (e.g., create first project)
- Feature adoption rates

**Retention:**
- % of users active after 7, 30, 90 days
- Churn rate (monthly, annual)
- User cohort analysis

**Revenue:**
- Monthly recurring revenue (MRR)
- Average revenue per user (ARPU)
- Lifetime value (LTV)
- LTV:CAC ratio (should be >3)

**Referral:**
- Net Promoter Score (NPS)
- Referrals per user
- Viral coefficient

**Key events to track:**
```
User Events:
- Signup (with source)
- Login
- Create [primary entity]
- Invite team member
- Upgrade to paid
- Churn (cancel subscription)

Feature Events:
- [Feature name] used
- [Workflow name] completed
- [Error name] encountered
```

**Dashboard priorities:**
```
Primary: Signups, Active users, MRR
Secondary: Feature usage, Churn, NPS
Tertiary: Performance metrics, Error rates
```

---

## Decision Frameworks

### When to Build vs Buy

**Build if:**
- Core differentiator for your product
- Unique requirements not met by existing solutions
- Integration cost > build cost
- Need full control

**Buy/integrate if:**
- Commodity feature (auth, payments, email)
- Well-established vendors exist
- Time to market critical
- Not core to product value

**Examples:**
- ✅ Build: Your domain-specific workflow engine
- ✅ Buy: Authentication (Better Auth, Auth0)
- ✅ Buy: Payments (Stripe)
- ✅ Buy: Email (SendGrid)

### Monolith vs Microservices

**Start with monolith:**
- Faster to build
- Easier to deploy
- Simpler to debug
- Sufficient for <100k users

**Split to microservices when:**
- Team > 20 people
- Different scaling needs per feature
- Need independent deployment
- Organizational boundaries clear

**For SaaS MVP:** Always monolith. Premature microservices = premature optimization.

### SQL vs NoSQL

**Use SQL (PostgreSQL) for:**
- Relational data (most SaaS data is relational)
- Complex queries and joins
- Transactions and consistency
- Multi-tenancy

**Use NoSQL for:**
- Document storage (MongoDB)
- Time-series data (InfluxDB)
- Cache layer (Redis)
- Real-time features (Firebase)

**For SaaS MVP:** PostgreSQL for primary database, Redis for cache.

---

## Common Pitfalls

### ❌ Pitfall: Premature Optimization
**Symptom:** Building for scale before product-market fit
**Fix:** Start simple, optimize when you have the problem

### ❌ Pitfall: Feature Bloat
**Symptom:** Every customer request becomes a feature
**Fix:** Focus on core workflows, say no to edge cases

### ❌ Pitfall: Over-engineering
**Symptom:** Microservices, event sourcing, CQRS from day 1
**Fix:** Build for today's needs, refactor when necessary

### ❌ Pitfall: Skipping Multi-tenancy
**Symptom:** Single-tenant database, hard to scale
**Fix:** Build multi-tenancy from day 1 (easier than retrofitting)

### ❌ Pitfall: Inadequate Testing
**Symptom:** Manual testing, no CI/CD, frequent regressions
**Fix:** Invest in automated tests early (90% coverage target)

### ❌ Pitfall: Poor Error Handling
**Symptom:** Generic errors, no logging, hard to debug
**Fix:** Structured errors, comprehensive logging, error tracking (Sentry)

---

**Remember:** These are guidelines, not rules. Adapt to your specific product, users, and constraints. When in doubt, start simple and iterate.
