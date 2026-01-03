# Product Build Checklist

> Quick reference checklist for building SaaS products from scratch

Use this alongside [product-development-foundation.md](./product-development-foundation.md) for detailed guidance.

---

## Phase 0: Planning (3-5 days)

### Product Requirements
- [ ] Define problem statement
- [ ] Identify target users (personas)
- [ ] List must-have MVP features
- [ ] List nice-to-have post-MVP features
- [ ] Define success metrics
- [ ] Document revenue model
- [ ] Create `docs/product-requirements.md`

### Data Model Design
- [ ] List all core entities
- [ ] Define entity relationships
- [ ] Add fields to each entity
- [ ] Consider multi-tenancy requirements
- [ ] Start with base SaaS entities (Organization, User, etc.)
- [ ] Create draft `.apsorc` schema file
- [ ] Document schema in design doc

### Architecture Planning
- [ ] Choose tech stack (use Mavric standard)
- [ ] Plan system components
- [ ] Create architecture diagram
- [ ] Document key decisions

---

## Phase 1: Foundation (Week 1-2)

### Week 1: Backend Setup

**Day 1: Generate Backend**
- [ ] Install Apso CLI: `npm install -g @apso/apso-cli`
- [ ] Create backend: `apso server new --name <project>-backend`
- [ ] Copy/create `.apsorc` schema file
- [ ] Generate code: `apso server scaffold`
- [ ] Install dependencies: `npm install`
- [ ] Start database: `npm run compose`
- [ ] Provision schema: `npm run provision`
- [ ] Verify server starts: `npm run start:dev`
- [ ] Check OpenAPI docs: http://localhost:3001/api/docs
- [ ] Verify all entities have CRUD endpoints

**Day 2: Frontend Setup**
- [ ] Create Next.js app: `npx create-next-app@latest client --typescript --tailwind --app`
- [ ] Install dependencies:
  - [ ] `npm install axios zod react-hook-form @tanstack/react-query`
- [ ] Initialize shadcn/ui: `npx shadcn-ui@latest init`
- [ ] Add core components: button, input, form, card, dialog, dropdown-menu, toast
- [ ] Create `.env.local` with `NEXT_PUBLIC_API_URL`
- [ ] Create `src/lib/api-client.ts` with axios setup
- [ ] Create base page structure

**Day 3-4: Authentication**
- [ ] Backend: Install `better-auth`
- [ ] Backend: Create auth service in `extensions/auth/`
- [ ] Backend: Implement signup endpoint
- [ ] Backend: Implement signin endpoint
- [ ] Backend: Implement token verification
- [ ] Frontend: Create `src/lib/auth.ts`
- [ ] Frontend: Create `/login` page
- [ ] Frontend: Create `/signup` page
- [ ] Frontend: Add auth token interceptor to axios
- [ ] Frontend: Create protected route wrapper
- [ ] Test: User can sign up
- [ ] Test: User can log in
- [ ] Test: Token is stored and sent with requests
- [ ] Test: Protected routes redirect to login

**Day 5: Multi-Tenancy**
- [ ] Backend: Create organization middleware
- [ ] Backend: Extract org ID from user session
- [ ] Backend: Apply middleware to all routes
- [ ] Backend: Create org-scoped decorator
- [ ] Backend: Test queries are filtered by organization
- [ ] Frontend: Add organization context
- [ ] Frontend: Show current organization in UI

### Week 2: Core Infrastructure

**Day 1: Stripe Billing**
- [ ] Backend: Install `stripe`
- [ ] Backend: Create stripe service in `extensions/billing/`
- [ ] Backend: Implement `createCustomer`
- [ ] Backend: Implement `createCheckoutSession`
- [ ] Backend: Create webhook handler
- [ ] Backend: Add webhook endpoint
- [ ] Frontend: Install `@stripe/stripe-js` and `@stripe/react-stripe-js`
- [ ] Frontend: Create billing page
- [ ] Frontend: Add checkout flow
- [ ] Test: Can create checkout session
- [ ] Test: Webhooks update subscription status

**Day 2: File Uploads (S3)**
- [ ] Backend: Install `@aws-sdk/client-s3` and `@aws-sdk/s3-request-presigner`
- [ ] Backend: Create S3 service in `extensions/files/`
- [ ] Backend: Implement `uploadFile`
- [ ] Backend: Implement `getPresignedUrl`
- [ ] Backend: Add upload endpoint
- [ ] Frontend: Create file upload component
- [ ] Frontend: Add file preview
- [ ] Test: Can upload files
- [ ] Test: Files are stored in S3
- [ ] Test: Can retrieve file URLs

**Day 3: Email Integration**
- [ ] Backend: Install `resend`
- [ ] Backend: Create email service in `extensions/email/`
- [ ] Backend: Implement welcome email
- [ ] Backend: Implement password reset email
- [ ] Backend: Implement invitation email
- [ ] Test: Emails are sent successfully
- [ ] Test: Email templates render correctly

**Day 4-5: Audit Logging**
- [ ] Backend: Create audit interceptor
- [ ] Backend: Log all write operations
- [ ] Backend: Capture user, IP, user agent
- [ ] Backend: Store old and new values
- [ ] Backend: Apply to all controllers
- [ ] Frontend: Create audit log viewer (admin only)
- [ ] Test: Changes are logged
- [ ] Test: Logs are queryable

---

## Phase 2: Core Features (Week 3-6)

For each core entity, complete these tasks:

### Entity CRUD Implementation

**Day 1: Design UI**
- [ ] Create entity card component
- [ ] Create entity list component
- [ ] Create entity form component
- [ ] Design entity detail view
- [ ] Add loading states
- [ ] Add empty states

**Day 2: List View**
- [ ] Create list page
- [ ] Fetch entities with React Query
- [ ] Add loading skeleton
- [ ] Add empty state
- [ ] Add pagination (if needed)
- [ ] Add search/filtering (if needed)

**Day 3: Create Form**
- [ ] Create new entity page
- [ ] Define Zod schema
- [ ] Create form with react-hook-form
- [ ] Add validation
- [ ] Handle submission
- [ ] Show success/error messages
- [ ] Redirect after creation

**Day 4: Edit/Delete**
- [ ] Create edit page
- [ ] Pre-populate form with existing data
- [ ] Handle update submission
- [ ] Add delete button with confirmation
- [ ] Handle delete
- [ ] Update cache after mutations

**Day 5: Custom Endpoints**
- [ ] Backend: Add custom business logic endpoints
- [ ] Backend: Implement in `extensions/[Entity]/`
- [ ] Frontend: Create API client functions
- [ ] Frontend: Add UI for custom actions
- [ ] Test: Custom endpoints work correctly

**Repeat for Each Core Entity (Week 4-6)**

---

## Phase 3: User Features (Week 7-9)

### Week 7: Team Collaboration

**Invitation System**
- [ ] Backend: Create invitation service
- [ ] Backend: Generate unique tokens
- [ ] Backend: Send invitation emails
- [ ] Backend: Create accept endpoint
- [ ] Frontend: Create team page
- [ ] Frontend: Add invite form
- [ ] Frontend: Create invitation acceptance page
- [ ] Test: Can invite users
- [ ] Test: Users can accept invites
- [ ] Test: Invitations expire after 7 days

**Role-Based Access Control**
- [ ] Backend: Create RBAC guard
- [ ] Backend: Define role permissions
- [ ] Backend: Apply to endpoints
- [ ] Frontend: Hide UI based on roles
- [ ] Test: Permissions are enforced

### Week 8: Notifications

**In-App Notifications**
- [ ] Backend: Create notification service
- [ ] Backend: Trigger notifications on events
- [ ] Frontend: Create notification dropdown
- [ ] Frontend: Add notification badge
- [ ] Frontend: Mark as read functionality
- [ ] Test: Notifications are created
- [ ] Test: Users see their notifications

**Real-Time (Optional)**
- [ ] Backend: Install `socket.io`
- [ ] Backend: Create WebSocket gateway
- [ ] Frontend: Install `socket.io-client`
- [ ] Frontend: Connect to WebSocket
- [ ] Frontend: Listen for notifications
- [ ] Test: Real-time updates work

### Week 9: Settings & Preferences

**User Profile**
- [ ] Frontend: Create profile page
- [ ] Frontend: Edit name, email, avatar
- [ ] Frontend: Change password
- [ ] Frontend: Delete account
- [ ] Test: Profile updates work

**Organization Settings**
- [ ] Frontend: Create organization settings page
- [ ] Frontend: Edit organization details
- [ ] Frontend: Manage team members
- [ ] Frontend: View billing
- [ ] Test: Settings save correctly

**Preferences**
- [ ] Frontend: Add notification preferences
- [ ] Frontend: Add theme preference (dark mode)
- [ ] Frontend: Add email preferences
- [ ] Test: Preferences are saved and applied

---

## Phase 4: Polish & Launch (Week 10-12)

### Week 10: Testing & Bug Fixes

**Backend Tests**
- [ ] Write unit tests for services
- [ ] Write integration tests for endpoints
- [ ] Achieve >70% code coverage
- [ ] Fix all failing tests
- [ ] Test error handling

**Frontend Tests**
- [ ] Write component tests
- [ ] Write integration tests
- [ ] Test user workflows
- [ ] Fix all failing tests
- [ ] Test on multiple browsers

**Manual Testing**
- [ ] Test all user flows
- [ ] Test on mobile
- [ ] Test edge cases
- [ ] Test error scenarios
- [ ] Create bug list
- [ ] Fix critical bugs

### Week 11: Performance Optimization

**Backend**
- [ ] Add database indexes
- [ ] Optimize N+1 queries
- [ ] Add pagination to lists
- [ ] Implement caching (Redis)
- [ ] Profile slow endpoints
- [ ] Optimize slow queries

**Frontend**
- [ ] Optimize images (Next.js Image)
- [ ] Add code splitting
- [ ] Implement lazy loading
- [ ] Optimize bundle size
- [ ] Add React Query caching
- [ ] Test performance metrics

**Database**
- [ ] Review query performance
- [ ] Add missing indexes
- [ ] Optimize slow queries
- [ ] Set up connection pooling

### Week 12: Deployment & Launch

**Pre-Deployment**
- [ ] Set up Sentry for error tracking
- [ ] Configure environment variables
- [ ] Set up database backups
- [ ] Configure CloudWatch alerts
- [ ] Set up status page
- [ ] Create support email
- [ ] Set up PostHog analytics

**Backend Deployment**
- [ ] Deploy backend to staging
- [ ] Test staging environment
- [ ] Deploy backend to production
- [ ] Verify production deployment
- [ ] Test production endpoints

**Frontend Deployment**
- [ ] Deploy frontend to staging
- [ ] Test staging environment
- [ ] Configure custom domain
- [ ] Deploy frontend to production
- [ ] Verify production deployment
- [ ] Test production site

**Post-Launch**
- [ ] Enable HTTPS
- [ ] Configure DNS
- [ ] Test all production flows
- [ ] Monitor error rates
- [ ] Monitor performance
- [ ] Create launch announcement
- [ ] Share with initial users

---

## Ongoing Maintenance

### Daily
- [ ] Check error reports (Sentry)
- [ ] Review server logs
- [ ] Monitor performance metrics
- [ ] Respond to user issues

### Weekly
- [ ] Review analytics
- [ ] Check database performance
- [ ] Update dependencies
- [ ] Deploy bug fixes

### Monthly
- [ ] Review backup strategy
- [ ] Optimize database queries
- [ ] Review security logs
- [ ] Plan new features

### Quarterly
- [ ] Review architecture
- [ ] Plan scaling improvements
- [ ] Update documentation
- [ ] Security audit

---

## Quick Health Check

Run this checklist periodically to ensure system health:

**Backend**
- [ ] All endpoints responding < 500ms
- [ ] Error rate < 1%
- [ ] Database queries optimized
- [ ] Logs are clean
- [ ] Backups are running

**Frontend**
- [ ] All pages load < 2s
- [ ] No console errors
- [ ] Mobile responsive
- [ ] Accessibility compliant
- [ ] Analytics tracking

**Infrastructure**
- [ ] SSL certificate valid
- [ ] DNS configured correctly
- [ ] Monitoring active
- [ ] Backups successful
- [ ] Alerts configured

**Security**
- [ ] Dependencies updated
- [ ] Secrets rotated
- [ ] CORS configured
- [ ] Rate limiting active
- [ ] Auth working

---

## Resources

- **[Product Development Foundation](./product-development-foundation.md)** - Complete implementation guide
- **[Lightbulb Schema Design](../../docs/development/schema-design.md)** - Example data model
- **[SaaS Base Template](../saas/saas-base-template.md)** - Standard SaaS entities
- **[Tech Stack Guide](../saas/saas-tech-stack.md)** - Technology decisions
- **[Apso CLI README](../../apso/packages/apso-cli/README.md)** - Apso documentation

---

**Version:** 1.0
**Last Updated:** 2025-01-11
**Status:** Production-ready checklist

