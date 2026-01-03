# Backend + BetterAuth Setup Checklist

Use this checklist when setting up a new backend with authentication.

## Phase 1: Pre-Setup (2 minutes)

### Environment Check
- [ ] Node.js 18+ installed (`node --version`)
- [ ] Docker installed and running (`docker --version`)
- [ ] PostgreSQL client installed (`psql --version`)
- [ ] Git initialized in project (`git status`)

### Project Structure
- [ ] `backend/` directory created (or will be created)
- [ ] `.gitignore` configured for Node.js
- [ ] Project name decided
- [ ] Database name decided

## Phase 2: Schema Design (5 minutes)

### Entity Planning
- [ ] List of business entities identified
- [ ] No naming conflicts with BetterAuth entities:
  - [ ] Not using "Account" (use "Organization" instead)
  - [ ] Not using "Session" (use "DiscoverySession" or similar)
  - [ ] "User" is OK (universal concept)
  - [ ] Not using "Verification"

### Required Auth Entities
- [ ] `User` (PascalCase) planned
- [ ] `account` (lowercase) planned
- [ ] `session` (lowercase) planned
- [ ] `verification` (lowercase) planned

### Multi-Tenancy
- [ ] Tenant root entity named (Organization/Company/Workspace)
- [ ] Junction table for User-Organization planned
- [ ] Multi-tenancy key decided (organization_id)

## Phase 3: Code Generation (5 minutes)

### Apso Setup
- [ ] `.apsorc` created with correct schema
- [ ] Nullable fields marked for User entity:
  - [ ] `avatar_url: { nullable: true }`
  - [ ] `password_hash: { nullable: true }`
  - [ ] `oauth_provider: { nullable: true }`
  - [ ] `oauth_id: { nullable: true }`
- [ ] All relationships defined
- [ ] `apso server` command executed successfully
- [ ] No generation errors

### Dependencies
- [ ] `npm install` completed
- [ ] All packages installed without errors
- [ ] `node_modules/` populated

## Phase 4: Auto-Fixes (3 minutes)

### DTO Fixes
- [ ] `id` field added to `UserCreate` DTO
- [ ] `id` field added to `accountCreate` DTO
- [ ] `id` field added to `sessionCreate` DTO
- [ ] `@IsUUID()` validators added

### Entity Fixes
- [ ] Nullable fields verified in `User.entity.ts`
- [ ] Foreign keys properly configured
- [ ] Enum types match .apsorc

### Module Wiring
- [ ] All entity modules imported in `app.module.ts`
- [ ] TypeORM configuration correct
- [ ] CORS enabled in `main.ts`

## Phase 5: Environment Configuration (2 minutes)

### Environment Files
- [ ] `.env.development` created
- [ ] `.env.test` created
- [ ] `.env.production.example` created
- [ ] `.env` files added to `.gitignore`

### Required Variables
- [ ] `NODE_ENV` set
- [ ] `PORT` set (default: 3001)
- [ ] `DATABASE_URL` configured
- [ ] `BETTER_AUTH_SECRET` generated (32+ chars)
- [ ] `BETTER_AUTH_URL` set
- [ ] `ALLOWED_ORIGINS` configured

### Security
- [ ] Secrets generated securely
- [ ] No hardcoded credentials in code
- [ ] Environment variables not committed to git

## Phase 6: Database Setup (3 minutes)

### PostgreSQL
- [ ] Docker Compose file created
- [ ] PostgreSQL container started (`docker-compose up -d`)
- [ ] Database accessible on port 5433
- [ ] Connection test successful

### Schema Creation
- [ ] Backend started (`npm run start:dev`)
- [ ] TypeORM synchronize ran
- [ ] All tables created
- [ ] Foreign keys established

### Verification
- [ ] `\dt` shows all tables
- [ ] `user` table exists
- [ ] `account` table exists
- [ ] `session` table exists
- [ ] `verification` table exists
- [ ] Organization table exists

## Phase 7: Testing (5 minutes)

### Server Health
- [ ] Server starts without errors
- [ ] Listening on port 3001
- [ ] `/health` endpoint returns 200
- [ ] No startup errors in logs

### API Endpoints
- [ ] `GET /Users` returns 200
- [ ] `POST /Users` creates user
- [ ] `GET /Users/{id}` retrieves user
- [ ] `PATCH /Users/{id}` updates user
- [ ] `DELETE /Users/{id}` deletes user

### OpenAPI Docs
- [ ] `/api/docs` accessible
- [ ] All entities documented
- [ ] Swagger UI loads
- [ ] Try-it-out works

### Database Integrity
- [ ] User creation inserts to database
- [ ] Foreign keys enforced
- [ ] Unique constraints work
- [ ] Nullable fields accept null
- [ ] Cascade deletes work

## Phase 8: Auth Integration (Frontend - CRITICAL)

### Frontend Setup
- [ ] `better-auth` installed
- [ ] `@apso/better-auth-adapter@2.0.2+` installed (**CRITICAL: must be v2.0.2 or higher!**)
- [ ] `lib/auth.ts` configured with `createApsoAdapter()`
- [ ] API route handler created at `/api/auth/[...all]`

### Auth Configuration
- [ ] Adapter points to backend URL
- [ ] Email/password enabled
- [ ] OAuth providers configured (if needed)
- [ ] Session settings configured

### Testing (CRITICAL: Test BOTH signup AND login!)
- [ ] Signup flow works (creates user)
- [ ] **Signin flow works** ← Most common failure point!
- [ ] Session creation works
- [ ] Protected routes work

### Database Verification
- [ ] After signup, verify account table has `providerId = 'credential'`:
  ```bash
  psql -U postgres -d your_db -c "SELECT id, \"userId\", \"providerId\", password IS NOT NULL FROM account;"
  ```
- [ ] If `providerId` is NULL → update adapter and re-test signup

## Phase 9: Production Readiness (10 minutes)

### Code Quality
- [ ] ESLint configured
- [ ] Prettier configured
- [ ] No TypeScript errors
- [ ] Build succeeds (`npm run build`)

### Testing
- [ ] Unit tests written
- [ ] E2E tests written
- [ ] All tests pass
- [ ] Coverage > 80%

### Documentation
- [ ] README.md updated
- [ ] API endpoints documented
- [ ] Environment variables documented
- [ ] Setup instructions clear

### Security
- [ ] Secrets rotated for production
- [ ] HTTPS enforced in production
- [ ] Rate limiting configured
- [ ] Input validation comprehensive

### Deployment
- [ ] Database migration strategy
- [ ] CI/CD pipeline configured
- [ ] Health checks configured
- [ ] Monitoring set up

## Common Gotchas

### MOST COMMON: Login Fails After Successful Signup
- ❌ Signup works but login returns "Invalid email or password"
- ✓ **Root cause:** `account.providerId` is NULL or undefined
- ✓ **Fix:** Update to `@apso/better-auth-adapter@2.0.2+`
- ✓ **Verify:** `SELECT "providerId" FROM account;` should show `"credential"`

### Understanding Better Auth Architecture
- ❌ Assuming password is stored in User table
- ✓ **Password is stored in the `account` table!**
- ✓ Better Auth uses `user.accounts.find(a => a.providerId === "credential")`
- ✓ If `providerId` is missing, login always fails

### Schema Issues
- ❌ Using "Account" as business entity name
- ✓ Use "Organization" instead

- ❌ Forgetting nullable: true on optional fields
- ✓ Mark avatar_url, password_hash, oauth_* as nullable

### Code Generation
- ❌ Manually editing autogen/ files
- ✓ Use extensions/ for custom code

- ❌ Missing id in Create DTOs
- ✓ Add id field to all Create DTOs

### Database
- ❌ Using synchronize: true in production
- ✓ Use migrations in production

- ❌ Forgetting to reset database after entity changes
- ✓ DROP SCHEMA → CREATE SCHEMA → restart

### Environment
- ❌ Committing .env files
- ✓ Use .env.example templates

- ❌ Weak BETTER_AUTH_SECRET
- ✓ Generate cryptographically secure secret

## Troubleshooting

If something goes wrong, check:

1. **Logs:** `npm run start:dev` output
2. **Database:** `psql` connection and tables
3. **Network:** Port not in use, CORS configured
4. **Code:** No TypeScript errors
5. **Environment:** All variables set

## Quick Reference Commands

```bash
# Start backend
npm run start:dev

# Reset database
psql -U postgres -d backend_dev -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

# Run tests
npm run test:e2e

# Fix DTOs
bash references/fix-scripts/fix-dto-id-fields.sh

# Fix nullable fields
bash references/fix-scripts/fix-nullable-fields.sh

# Test auth flow
bash references/verification-commands/test-auth-flow.sh
```

## Success Criteria

Setup is complete when:

- ✓ Server starts without errors
- ✓ All CRUD endpoints work
- ✓ Database tables created correctly
- ✓ User signup/signin flows work
- ✓ OpenAPI docs accessible
- ✓ Tests pass
- ✓ No TypeScript errors
- ✓ Frontend can authenticate

**Target Time:** 20-30 minutes for complete setup
**Manual Steps:** 0 (fully automated with backend-bootstrapper skill)
