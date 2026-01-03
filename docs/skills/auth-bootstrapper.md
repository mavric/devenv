# Auth Bootstrapper

Adds BetterAuth authentication to Apso backends with zero manual steps.

---

## Overview

| Attribute | Value |
|-----------|-------|
| **Name** | auth-bootstrapper |
| **Type** | Implementation skill |
| **Triggers** | "add authentication", "setup auth", "integrate BetterAuth" |
| **Duration** | ~5 minutes (automated) |
| **Location** | `.claude/skills/auth-bootstrapper/` |

---

## Core Capabilities

### 1. setup-backend-with-auth

**Complete new backend with authentication.**

- Creates Apso backend structure
- Generates `.apsorc` with BetterAuth entities
- Runs code generation
- Fixes known integration issues
- Sets up environment variables
- Initializes database
- Verifies endpoints

**Usage:** "Setup backend with auth"

---

### 2. add-auth-to-existing

**Add BetterAuth to existing Apso backend.**

- Analyzes current schema
- Detects naming conflicts
- Adds BetterAuth entities
- Regenerates code
- Fixes DTO/entity issues
- Updates database

**Usage:** "Add auth to my backend"

---

### 3. fix-auth-issues

**Auto-fix common BetterAuth problems.**

Issues fixed:
- Missing `id` field in DTOs
- Nullable field constraints
- Entity naming conflicts
- AppModule wiring
- Database NOT NULL errors
- CORS configuration

**Usage:** "Fix auth issues"

---

### 4. verify-auth-setup

**Run comprehensive verification.**

Checks:
- Database tables exist
- CRUD endpoints respond
- Signup flow works
- Signin flow works
- Session creation works
- Multi-tenancy isolation

**Usage:** "Verify auth setup"

---

## BetterAuth Entities

The skill creates these required entities:

| Entity | Case | Purpose |
|--------|------|---------|
| `User` | PascalCase | Authentication user |
| `account` | lowercase | OAuth/credential providers |
| `session` | lowercase | Active user sessions |
| `verification` | lowercase | Email verification tokens |

!!! warning "Entity Naming"
    BetterAuth expects exact names. `User` is PascalCase, others are lowercase.

---

## Critical Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                    Better Auth Data Model                     │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  User table:              account table:                      │
│  ┌────────────────┐       ┌─────────────────────────┐        │
│  │ id             │       │ id                      │        │
│  │ email          │───────│ userId                  │        │
│  │ name           │   1:N │ providerId = "credential│ ← KEY! │
│  │ email_verified │       │ password (bcrypt hash)  │ ← HERE │
│  └────────────────┘       └─────────────────────────┘        │
│                                                               │
│  PASSWORDS ARE IN THE ACCOUNT TABLE, NOT USER TABLE!         │
└──────────────────────────────────────────────────────────────┘
```

!!! danger "Critical Understanding"
    Passwords are stored in `account.password`, not `user.password_hash`.

    The `account.providerId` must be `"credential"` for password login.

---

## Common Issue: Login Fails

**Symptom:** Signup works, but login always fails with "Invalid email or password".

**Root Cause:** `account.providerId` is not set to `"credential"` during account creation.

**Solution:**
1. Use `@apso/better-auth-adapter@2.0.2` or higher
2. Verify database: `SELECT "providerId" FROM account;`
3. Should show `"credential"`

---

## Automated Setup

### Interactive Mode

```bash
./scripts/setup-apso-betterauth.sh
```

Prompts for:
- Project name
- Backend port
- Database credentials

### Automated Mode

```bash
./scripts/setup-apso-betterauth.sh \
  --project-name my-saas \
  --backend-port 3001 \
  --frontend-port 3003
```

---

## Generated Structure

```
backend/
├── src/
│   ├── autogen/
│   │   ├── User/
│   │   ├── account/
│   │   ├── session/
│   │   ├── verification/
│   │   └── guards/
│   │       ├── auth.guard.ts
│   │       └── scope.guard.ts
│   │
│   └── extensions/
│       └── auth/
│           ├── auth.decorator.ts
│           └── auth.service.ts
│
└── .env
```

---

## Environment Variables

```bash
# .env
NODE_ENV=development
PORT=3001

# Database
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/db

# BetterAuth
BETTER_AUTH_SECRET=generated-32-char-secret
BETTER_AUTH_URL=http://localhost:3001

# CORS
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3003
```

---

## Verification Checklist

After setup, verify:

**Backend Services:**
- [ ] Server starts (port 3001)
- [ ] Database connected
- [ ] Tables created
- [ ] OpenAPI docs at `/api/docs`

**Endpoints:**
- [ ] GET `/Users` returns 200
- [ ] POST `/Users` creates user
- [ ] GET `/accounts` returns 200
- [ ] GET `/sessions` returns 200

**Auth Flows:**
- [ ] Signup creates user + account
- [ ] Signin validates credentials
- [ ] Session creation works
- [ ] Password hashing works

---

## Frontend Integration

After backend setup:

```bash
cd frontend
npm install better-auth @apso/better-auth-adapter@latest
```

```typescript
// frontend/lib/auth.ts
import { betterAuth } from 'better-auth';
import { createApsoAdapter } from '@apso/better-auth-adapter';

export const auth = betterAuth({
  database: createApsoAdapter({
    baseUrl: process.env.NEXT_PUBLIC_BACKEND_URL,
  }),
  emailAndPassword: { enabled: true },
});
```

---

## Invocation

### Via Orchestrator

Automatically called as Phase 7 of `/start-project`.

### Via Script

```bash
./scripts/setup-apso-betterauth.sh
```

### Via Natural Language

```
"Add authentication to my backend"
"Setup BetterAuth"
"Fix auth issues in my project"
```

---

## Related

- [Backend Bootstrapper](backend-bootstrapper.md) (creates backend)
- [Automated Setup](../setup/automated-setup.md) (full script docs)
