# Apso + Better Auth Quickstart Guide

> Get Better Auth working with Apso in < 30 minutes

This guide provides a streamlined path to integrating Better Auth with an Apso-generated backend, avoiding common pitfalls.

## Prerequisites

- Apso backend generated and running
- Next.js frontend set up
- PostgreSQL database
- Basic familiarity with TypeScript and REST APIs

## Critical: Entity Naming

**Better Auth reserves these entity names for authentication:**
- `User` (for authenticated users)
- `account` (lowercase - for OAuth/credential accounts)
- `session` (lowercase - for user sessions)
- `verification` (lowercase - for email verification)

**If your business domain needs "Account" or "Session" entities, rename them to avoid conflicts:**
- `Account` → `Organization` or `Company` or `Workspace`
- `Session` → `DiscoverySession` or `UserSession` or `ChatSession`

## Step 1: Define Your Apso Schema (15 min)

Create/update `.apsorc` in your backend:

```json
{
  "version": "2",
  "projectName": "your-project",
  "database": {
    "type": "postgres",
    "host": "localhost",
    "port": 5433,
    "username": "postgres",
    "password": "postgres",
    "database": "your_db_dev"
  },
  "schemas": {
    "public": {
      "entities": {
        // Your business entities (renamed to avoid conflicts)
        "Organization": {
          "name": "string!",
          "slug": "string!"
        },

        // Better Auth entities - DO NOT RENAME THESE
        "User": {
          "email": "string!",
          "email_verified": "boolean",
          "name": "string!",
          "avatar_url": "string?",      // ✅ nullable (OAuth users may not have)
          "password_hash": "string?",   // ✅ nullable (OAuth users don't have password)
          "oauth_provider": "string?",  // ✅ nullable (email/password users don't have)
          "oauth_id": "string?"         // ✅ nullable (email/password users don't have)
        },
        "account": {
          "userId": "User!",
          "accountId": "string",
          "providerId": "string",
          "accessToken": "string?",
          "refreshToken": "string?",
          "accessTokenExpiresAt": "datetime?",
          "refreshTokenExpiresAt": "datetime?",
          "scope": "string?",
          "idToken": "string?",
          "password": "string?"
        },
        "session": {
          "sessionToken": "string!",
          "userId": "User!",
          "expiresAt": "datetime!"
        },
        "verification": {
          "identifier": "string!",
          "value": "string!",
          "expiresAt": "datetime!"
        }
      }
    }
  }
}
```

**Key Points:**
- Mark optional User fields as nullable with `?` (avatar_url, password_hash, oauth_*)
- Use lowercase for `account`, `session`, `verification` (Better Auth convention)
- Use PascalCase `User` (Better Auth requirement)

## Step 2: Generate Apso Backend (5 min)

```bash
cd backend
npx apso generate
npm install
```

**Manual Fixes Required After Generation:**

### Fix 1: Add `id` to DTOs

Apso may not include `id` in Create DTOs. Add it manually:

**File:** `backend/src/autogen/User/dtos/User.dto.ts`
```typescript
export class UserCreate {
  @ApiProperty()
  id: string;  // ← Add this

  @ApiProperty()
  email: string;
  // ... rest
}
```

**File:** `backend/src/autogen/account/dtos/account.dto.ts`
```typescript
export class accountCreate {
  @ApiProperty()
  id: string;  // ← Add this

  @ApiProperty()
  userId: string;
  // ... rest
}
```

### Fix 2: Verify Nullable Fields in Entities

**File:** `backend/src/autogen/User/User.entity.ts`

Ensure these fields are `nullable: true`:

```typescript
@Column({ type: 'text', nullable: true })  // ✅ Must be nullable
avatar_url: string;

@Column({ type: 'text', nullable: true })  // ✅ Must be nullable
password_hash: string;

@Column({
  type: 'enum',
  enum: enums.UserOauthProviderEnum,
  nullable: true,  // ✅ Must be nullable
})
oauth_provider: enums.UserOauthProviderEnum;

@Column({ type: 'text', nullable: true })  // ✅ Must be nullable
oauth_id: string;
```

## Step 3: Reset Database (2 min)

TypeORM synchronize won't update existing NOT NULL constraints. Drop and recreate:

```bash
# Connect to database
PGPASSWORD=postgres psql -h localhost -p 5433 -U postgres -d your_db_dev

# Drop and recreate schema
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
\q

# Start backend (will recreate tables via TypeORM)
cd backend
npm run start:dev
```

**Verify tables were created:**
```bash
PGPASSWORD=postgres psql -h localhost -p 5433 -U postgres -d your_db_dev \
  -c "\dt public.*"
```

You should see: `user`, `account`, `session`, `verification` tables.

## Step 4: Install Better Auth Adapter in Frontend (2 min)

```bash
cd frontend
npm install better-auth @apso/better-auth-adapter
```

## Step 5: Configure Better Auth (5 min)

**File:** `frontend/lib/auth.ts`

```typescript
import { betterAuth } from 'better-auth';
import { apsoAdapter } from '@apso/better-auth-adapter';

export const auth = betterAuth({
  database: apsoAdapter({
    baseUrl: process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:3001',
    // apiKey: process.env.APSO_API_KEY,  // Optional if using public endpoints
  }),
  emailAndPassword: {
    enabled: true,
  },
  session: {
    expiresIn: 60 * 60 * 24 * 7, // 7 days
    updateAge: 60 * 60 * 24, // 1 day
  },
  // Optional: Add OAuth providers
  // socialProviders: {
  //   google: {
  //     clientId: process.env.GOOGLE_CLIENT_ID!,
  //     clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
  //   },
  // },
});

export type Session = typeof auth.$Infer.Session;
```

**File:** `frontend/.env.local`

```env
NEXT_PUBLIC_BACKEND_URL=http://localhost:3001
BETTER_AUTH_SECRET=your-super-secret-key-here-minimum-32-chars
# GOOGLE_CLIENT_ID=your-google-client-id
# GOOGLE_CLIENT_SECRET=your-google-client-secret
```

## Step 6: Create Auth Route Handler (2 min)

**File:** `frontend/app/api/auth/[...all]/route.ts`

```typescript
import { auth } from '@/lib/auth';

export const { GET, POST } = auth.handler;
```

## Step 7: Test the Integration (3 min)

**Test 1: Sign up a user**

```bash
curl -X POST 'http://localhost:3003/api/auth/sign-up/email' \
  -H 'Content-Type: application/json' \
  -d '{
    "email": "test@example.com",
    "password": "TestPassword123!",
    "name": "Test User"
  }'
```

**Expected Response:** User object with `id`, `email`, `name`

**Test 2: Verify in database**

```bash
PGPASSWORD=postgres psql -h localhost -p 5433 -U postgres -d your_db_dev \
  -c "SELECT id, email, name, email_verified FROM \"user\";"
```

**Expected:** One user with `email_verified = false`

**Test 3: Verify account was created**

```bash
PGPASSWORD=postgres psql -h localhost -p 5433 -U postgres -d your_db_dev \
  -c "SELECT id, \"userId\", provider FROM account;"
```

**Expected:** One account with `provider = 'credential'`

## Common Issues & Fixes

### Issue 1: "null value in column 'avatar_url' violates not-null constraint"

**Fix:** Make the field nullable in `User.entity.ts` and drop/recreate database (Step 3)

### Issue 2: "null value in column 'id' of relation 'account' violates not-null constraint"

**Fix:** Update to latest `@apso/better-auth-adapter`:
```bash
cd frontend
npm update @apso/better-auth-adapter
```

### Issue 3: "DTO validation failed - unexpected field 'id'"

**Fix:** Add `id` field to DTOs (see Step 2, Fix 1)

### Issue 4: "table 'account' already exists" or entity conflicts

**Fix:** Rename your business entities (Step 1) - don't use Better Auth reserved names

## Next Steps

1. **Add Frontend UI:**
   - Sign up form
   - Sign in form
   - Password reset
   - OAuth buttons

2. **Add Session Management:**
   - Protect routes
   - Check authentication status
   - Handle sign out

3. **Add OAuth Providers (Optional):**
   - Google
   - GitHub
   - Microsoft

4. **Add Email Verification:**
   - Set up email service (Postmark, SendGrid)
   - Configure verification flow

## Additional Resources

- [Better Auth Documentation](https://better-auth.com)
- [Apso Documentation](https://apso.cloud/docs)
- [Better Auth Adapter Troubleshooting](/apso/packages/better-auth/docs/troubleshooting.md#apso-integration-issues)

## Checklist

Before deploying to production:

- [ ] Entity names don't conflict with Better Auth (`User`, `account`, `session`, `verification`)
- [ ] User optional fields are nullable (`avatar_url`, `password_hash`, `oauth_*`)
- [ ] DTOs include `id` field
- [ ] Database tables created successfully
- [ ] Email/password signup works
- [ ] Session management works
- [ ] Environment variables are set securely
- [ ] Database connection is secure (not using default passwords)
- [ ] BETTER_AUTH_SECRET is properly generated and secure
