# Better Auth Integration Reference for Backend Bootstrap

> Essential reference for integrating Better Auth with Apso backends

## CRITICAL: Understanding Better Auth's Architecture

**IMPORTANT:** Better Auth stores passwords in the `account` table, NOT the `User` table!

```
┌──────────────────────────────────────────────────────────────────────┐
│                    Better Auth Data Model                             │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  User table:              account table:                              │
│  ┌────────────────┐       ┌─────────────────────────┐                │
│  │ id             │       │ id                      │                │
│  │ email          │───────│ userId                  │                │
│  │ name           │   1:N │ providerId = "credential"│ ← CRITICAL!   │
│  │ email_verified │       │ password (bcrypt hash)  │ ← Password!    │
│  │ avatar_url     │       │ accountId               │                │
│  └────────────────┘       └─────────────────────────┘                │
│                                                                       │
│  Sign-in flow:                                                        │
│  1. Find user by email                                                │
│  2. Include user's accounts (join)                                    │
│  3. Find account where providerId === "credential"                    │
│  4. Verify password against account.password                          │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

## Quick Start Checklist

When bootstrapping a backend with authentication:

1. [ ] Use correct entity names (User, account, session, verification)
2. [ ] Mark OAuth fields as nullable
3. [ ] Add id field to Create DTOs
4. [ ] **Ensure account.providerId field exists** ← CRITICAL
5. [ ] Configure CORS for frontend URLs
6. [ ] Set up environment variables
7. [ ] Install `@apso/better-auth-adapter@2.0.2+`
8. [ ] Test signup AND login flows (not just signup!)

## Entity Requirements

### Critical Entity Names

```json
{
  "entities": {
    "User": {           // ← PascalCase
      // user table
    },
    "account": {        // ← lowercase
      // OAuth/credentials - STORES PASSWORDS!
    },
    "session": {        // ← lowercase
      // Active sessions
    },
    "verification": {   // ← lowercase
      // Email verification
    }
  }
}
```

### Critical Account Entity Fields

**The `account` entity MUST have these fields for credential auth to work:**

```json
"account": {
  "fields": [
    {
      "name": "providerId",
      "type": "text",
      "length": 50,
      "nullable": true,
      "description": "CRITICAL: Must be 'credential' for email/password auth"
    },
    {
      "name": "password",
      "type": "text",
      "nullable": true,
      "description": "Bcrypt-hashed password (credential accounts only)"
    },
    {
      "name": "accountId",
      "type": "text",
      "nullable": true,
      "description": "Provider-specific account ID"
    }
  ]
}
```

### Required Nullable Fields

```json
"User": {
  "fields": {
    "avatar_url": { "nullable": true },
    "password_hash": { "nullable": true },
    "oauth_provider": { "nullable": true },
    "oauth_id": { "nullable": true }
  }
}
```

## DTO Modifications

After Apso generation, add `id` to Create DTOs:

```typescript
// src/autogen/User/dtos/User.dto.ts
export class UserCreate {
  @ApiProperty()
  @IsUUID()
  id: string;  // ← Add this
  // ... rest
}

// src/autogen/account/dtos/account.dto.ts
export class accountCreate {
  @ApiProperty()
  @IsUUID()
  id: string;  // ← Add this
  // ... rest
}
```

## CORS Configuration

```typescript
// main.ts
app.enableCors({
  origin: [
    'http://localhost:3000',
    'http://localhost:3003',
    process.env.FRONTEND_URL,
  ],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
});
```

## Testing Authentication

```bash
# Test user creation
curl -X POST http://localhost:3001/Users \
  -H "Content-Type: application/json" \
  -d '{
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "test@example.com",
    "name": "Test User",
    "email_verified": false
  }'

# Verify in database
psql -U postgres -d your_db -c "SELECT * FROM \"user\";"
```

## Common Issues

1. **Null constraint violations**: Make fields nullable
2. **DTO validation errors**: Add id field to DTOs
3. **Table not found**: Use correct entity naming
4. **CORS blocked**: Configure CORS in main.ts
5. **Login fails after successful signup**: Missing `providerId` field or using old adapter version

## Frontend Integration

### Install the adapter (CRITICAL: use v2.0.2+)

```bash
cd frontend
npm install better-auth @apso/better-auth-adapter@latest
```

### Configure auth.ts

```typescript
// lib/auth.ts
import { betterAuth } from 'better-auth';
import { createApsoAdapter } from '@apso/better-auth-adapter';

export const auth = betterAuth({
  database: createApsoAdapter({
    baseUrl: process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:4441',
  }),
  emailAndPassword: {
    enabled: true,
  },
  // ... other config
});
```

### Test BOTH Signup and Login

**IMPORTANT:** Always test login after signup. Signup can succeed while login fails!

```bash
# 1. Signup
curl -X POST http://localhost:3001/api/auth/sign-up/email \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"TestPass123","name":"Test"}'

# Expected: {"user":{...},"token":"..."}

# 2. Login (MUST test this!)
curl -X POST http://localhost:3001/api/auth/sign-in/email \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"TestPass123"}'

# Expected: {"user":{...},"token":"..."}
# If you get INVALID_EMAIL_OR_PASSWORD, check providerId field!
```

### Debug Login Failures

```bash
# Check account has providerId = 'credential'
psql -U postgres -d your_db -c "SELECT id, \"userId\", \"providerId\", password IS NOT NULL FROM account;"

# If providerId is NULL:
# 1. Update adapter: npm install @apso/better-auth-adapter@latest
# 2. Delete test user and try again
```

## Reference Documentation

- [Complete Auth Integration Guide](../../../docs/auth/COMPLETE_AUTH_INTEGRATION_GUIDE.md)
- [Apsorc Auth Entities](../../../docs/auth/APSORC_AUTH_ENTITIES.md)
- [Troubleshooting Guide](../../../docs/auth/TROUBLESHOOTING_AUTH.md)
- [Better Auth Adapter Package](https://www.npmjs.com/package/@apso/better-auth-adapter)