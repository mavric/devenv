# .apsorc Auth Entity Configuration Guide

> Complete reference for configuring Better Auth entities in Apso schema files

## CRITICAL: Understanding Better Auth Architecture

**Before you begin, understand this key insight:**

```
┌──────────────────────────────────────────────────────────────────────────┐
│               Better Auth Password Storage Architecture                   │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  ⚠️  PASSWORDS ARE STORED IN THE ACCOUNT TABLE, NOT THE USER TABLE!      │
│                                                                           │
│  User table:              account table:                                  │
│  ┌────────────────┐       ┌─────────────────────────────┐                │
│  │ id             │       │ id                          │                │
│  │ email          │───────│ userId                      │                │
│  │ name           │   1:N │ providerId = "credential"   │ ← CRITICAL!    │
│  │ email_verified │       │ password (bcrypt hash)      │ ← Passwords!   │
│  │ avatar_url     │       │ accountId                   │                │
│  └────────────────┘       └─────────────────────────────┘                │
│                                                                           │
│  Sign-in flow:                                                            │
│  1. Better Auth calls: findUserByEmail(email, { includeAccounts: true }) │
│  2. Adapter returns user WITH accounts array                              │
│  3. Better Auth: user.accounts.find(a => a.providerId === "credential")  │
│  4. Password verified against account.password                            │
│                                                                           │
│  If providerId is undefined/null → Login ALWAYS fails!                   │
│                                                                           │
└──────────────────────────────────────────────────────────────────────────┘
```

**Required adapter version:** `@apso/better-auth-adapter@2.0.2+`

## Table of Contents

1. [Overview](#overview)
2. [Required Auth Entities](#required-auth-entities)
3. [Entity Naming Rules](#entity-naming-rules)
4. [Field Configuration Details](#field-configuration-details)
5. [Relationships & Foreign Keys](#relationships--foreign-keys)
6. [Common Patterns](#common-patterns)
7. [Migration from Existing Schema](#migration-from-existing-schema)
8. [Validation & Testing](#validation--testing)

## Overview

Better Auth requires specific entity names and field structures to function correctly. This guide provides the exact configuration needed in your `.apsorc` file.

### Quick Reference

| Entity | Case | Table Name | Purpose |
|--------|------|------------|---------|
| `User` | PascalCase | `user` | User accounts |
| `account` | lowercase | `account` | OAuth/credential providers **+ PASSWORDS!** |
| `session` | lowercase | `session` | Active user sessions |
| `verification` | lowercase | `verification` | Email verification tokens |

## Required Auth Entities

### 1. User Entity

The `User` entity stores authenticated user information.

```json
"User": {
  "description": "Better Auth user entity - stores authenticated users",
  "fields": {
    "id": {
      "type": "uuid",
      "primary": true,
      "default": "uuid_generate_v4()",
      "description": "Unique user identifier"
    },
    "email": {
      "type": "string",
      "unique": true,
      "required": true,
      "maxLength": 255,
      "validation": {
        "email": true,
        "lowercase": true
      },
      "description": "User's email address (used for login)"
    },
    "email_verified": {
      "type": "boolean",
      "default": false,
      "required": true,
      "description": "Whether email has been verified"
    },
    "name": {
      "type": "string",
      "required": true,
      "maxLength": 255,
      "description": "User's display name"
    },
    "avatar_url": {
      "type": "string",
      "nullable": true,  // CRITICAL: Must be nullable
      "maxLength": 500,
      "description": "Profile picture URL (from OAuth or uploaded)"
    },
    "password_hash": {
      "type": "string",
      "nullable": true,  // CRITICAL: OAuth users won't have this
      "description": "Hashed password for email/password auth only"
    },
    "oauth_provider": {
      "type": "enum",
      "values": ["google", "github", "microsoft", "facebook", "apple"],
      "nullable": true,  // CRITICAL: Email users won't have this
      "description": "OAuth provider used for signup"
    },
    "oauth_id": {
      "type": "string",
      "nullable": true,  // CRITICAL: Email users won't have this
      "maxLength": 255,
      "description": "User ID from OAuth provider"
    },
    "two_factor_enabled": {
      "type": "boolean",
      "default": false,
      "description": "Whether 2FA is enabled (optional)"
    },
    "two_factor_secret": {
      "type": "string",
      "nullable": true,
      "description": "TOTP secret for 2FA (optional)"
    },
    "banned": {
      "type": "boolean",
      "default": false,
      "description": "Whether user is banned (optional)"
    },
    "banned_reason": {
      "type": "string",
      "nullable": true,
      "description": "Reason for ban (optional)"
    },
    "created_at": {
      "type": "timestamp",
      "default": "now()",
      "required": true
    },
    "updated_at": {
      "type": "timestamp",
      "default": "now()",
      "required": true
    }
  },
  "indexes": [
    ["email"],
    ["oauth_provider", "oauth_id"],
    ["created_at"]
  ]
}
```

### 2. Account Entity (lowercase!) - STORES PASSWORDS!

**CRITICAL:** The `account` entity stores passwords for credential authentication! This is Better Auth's design - passwords are NOT stored in the User table.

```json
"account": {
  "description": "Better Auth account entity - STORES PASSWORDS and links users to auth providers",
  "fields": {
    "id": {
      "type": "uuid",
      "primary": true,
      "default": "uuid_generate_v4()"
    },
    "userId": {
      "type": "uuid",
      "required": true,
      "references": "User.id",
      "onDelete": "CASCADE",
      "description": "User this account belongs to"
    },
    "accountId": {
      "type": "string",
      "required": true,
      "description": "Account ID from provider (email or OAuth ID)"
    },
    "providerId": {
      "type": "string",
      "required": true,
      "description": "CRITICAL: Must be 'credential' for email/password. Better Auth uses: accounts.find(a => a.providerId === 'credential')"
    },
    "accessToken": {
      "type": "text",
      "nullable": true,
      "description": "OAuth access token"
    },
    "refreshToken": {
      "type": "text",
      "nullable": true,
      "description": "OAuth refresh token"
    },
    "accessTokenExpiresAt": {
      "type": "timestamp",
      "nullable": true,
      "description": "When access token expires"
    },
    "refreshTokenExpiresAt": {
      "type": "timestamp",
      "nullable": true,
      "description": "When refresh token expires"
    },
    "scope": {
      "type": "string",
      "nullable": true,
      "maxLength": 500,
      "description": "OAuth scopes granted"
    },
    "idToken": {
      "type": "text",
      "nullable": true,
      "description": "OpenID Connect ID token"
    },
    "password": {
      "type": "string",
      "nullable": true,
      "description": "Bcrypt-hashed password - STORED HERE, not in User table! Only for credential (email/password) accounts."
    },
    "created_at": {
      "type": "timestamp",
      "default": "now()"
    },
    "updated_at": {
      "type": "timestamp",
      "default": "now()"
    }
  },
  "unique": [
    ["providerId", "accountId"]  // One account per provider
  ],
  "indexes": [
    ["userId"],
    ["providerId", "accountId"]
  ]
}
```

### 3. Session Entity (lowercase!)

The `session` entity tracks active user sessions.

```json
"session": {
  "description": "Better Auth session entity - tracks active sessions",
  "fields": {
    "id": {
      "type": "uuid",
      "primary": true,
      "default": "uuid_generate_v4()"
    },
    "sessionToken": {
      "type": "string",
      "unique": true,
      "required": true,
      "description": "Unique session token"
    },
    "userId": {
      "type": "uuid",
      "required": true,
      "references": "User.id",
      "onDelete": "CASCADE",
      "description": "User this session belongs to"
    },
    "expiresAt": {
      "type": "timestamp",
      "required": true,
      "description": "When session expires"
    },
    "ipAddress": {
      "type": "string",
      "nullable": true,
      "maxLength": 45,  // Supports IPv6
      "description": "IP address of session creation"
    },
    "userAgent": {
      "type": "string",
      "nullable": true,
      "maxLength": 500,
      "description": "User agent string"
    },
    "created_at": {
      "type": "timestamp",
      "default": "now()"
    },
    "updated_at": {
      "type": "timestamp",
      "default": "now()"
    }
  },
  "indexes": [
    ["sessionToken"],
    ["userId"],
    ["expiresAt"]  // For cleanup queries
  ]
}
```

### 4. Verification Entity (lowercase!)

The `verification` entity stores email verification and password reset tokens.

```json
"verification": {
  "description": "Better Auth verification entity - email verification & password reset",
  "fields": {
    "id": {
      "type": "uuid",
      "primary": true,
      "default": "uuid_generate_v4()"
    },
    "identifier": {
      "type": "string",
      "required": true,
      "description": "Email address being verified"
    },
    "value": {
      "type": "string",
      "required": true,
      "description": "Verification token"
    },
    "expiresAt": {
      "type": "timestamp",
      "required": true,
      "description": "When token expires"
    },
    "type": {
      "type": "enum",
      "values": ["email", "password_reset"],
      "default": "email",
      "description": "Type of verification"
    },
    "used": {
      "type": "boolean",
      "default": false,
      "description": "Whether token has been used"
    },
    "created_at": {
      "type": "timestamp",
      "default": "now()"
    },
    "updated_at": {
      "type": "timestamp",
      "default": "now()"
    }
  },
  "unique": [
    ["identifier", "value"]  // Ensure unique token per email
  ],
  "indexes": [
    ["identifier"],
    ["value"],
    ["expiresAt"]  // For cleanup queries
  ]
}
```

## Entity Naming Rules

### Critical Rules

1. **User MUST be PascalCase** - `User` not `user` in .apsorc
2. **Other auth entities MUST be lowercase** - `account`, `session`, `verification`
3. **Table names will be lowercase** - TypeORM converts `User` → `user` table
4. **Field names use camelCase** - `userId` not `user_id` in .apsorc
5. **Database columns use snake_case** - TypeORM converts `userId` → `user_id`

### Naming Conflicts

If your business domain conflicts with auth entity names:

```json
{
  // WRONG - Conflicts with Better Auth
  "Account": { ... },  // ❌ Conflicts with auth 'account'
  "Session": { ... },  // ❌ Conflicts with auth 'session'

  // CORRECT - Renamed to avoid conflicts
  "Organization": { ... },     // ✅ Business "Account" renamed
  "DiscoverySession": { ... }, // ✅ Business "Session" renamed
  "User": { ... }              // ✅ User is fine (universal concept)
}
```

## Field Configuration Details

### Nullable Fields Strategy

Fields that MUST be nullable:

```json
{
  // User entity nullable fields
  "avatar_url": { "nullable": true },      // Not all users have avatars
  "password_hash": { "nullable": true },   // OAuth users don't have passwords
  "oauth_provider": { "nullable": true },  // Email users don't have OAuth
  "oauth_id": { "nullable": true },        // Email users don't have OAuth ID

  // Account entity nullable fields
  "accessToken": { "nullable": true },     // Credential accounts don't have tokens
  "refreshToken": { "nullable": true },    // Not all OAuth provides refresh tokens
  "password": { "nullable": true },        // OAuth accounts don't have passwords

  // Session entity nullable fields
  "ipAddress": { "nullable": true },       // May not always be available
  "userAgent": { "nullable": true }        // May not always be available
}
```

### Required Fields Strategy

Fields that MUST NOT be nullable:

```json
{
  // User entity required fields
  "id": { "required": true },
  "email": { "required": true },
  "name": { "required": true },
  "email_verified": { "required": true, "default": false },

  // Account entity required fields
  "userId": { "required": true },
  "accountId": { "required": true },
  "providerId": { "required": true },

  // Session entity required fields
  "sessionToken": { "required": true },
  "userId": { "required": true },
  "expiresAt": { "required": true }
}
```

## Relationships & Foreign Keys

### User Relationships

```json
{
  "User": {
    "relationships": {
      "accounts": {
        "type": "hasMany",
        "entity": "account",
        "foreignKey": "userId"
      },
      "sessions": {
        "type": "hasMany",
        "entity": "session",
        "foreignKey": "userId"
      },
      "organizationUsers": {
        "type": "hasMany",
        "entity": "OrganizationUser",
        "foreignKey": "user_id"
      }
    }
  }
}
```

### Account Relationships

```json
{
  "account": {
    "relationships": {
      "user": {
        "type": "belongsTo",
        "entity": "User",
        "foreignKey": "userId",
        "onDelete": "CASCADE"  // Delete accounts when user deleted
      }
    }
  }
}
```

### Session Relationships

```json
{
  "session": {
    "relationships": {
      "user": {
        "type": "belongsTo",
        "entity": "User",
        "foreignKey": "userId",
        "onDelete": "CASCADE"  // Delete sessions when user deleted
      }
    }
  }
}
```

## Common Patterns

### Multi-Tenant Setup with Auth

```json
{
  "entities": {
    // Auth entities (as above)
    "User": { ... },
    "account": { ... },
    "session": { ... },
    "verification": { ... },

    // Multi-tenant organization
    "Organization": {
      "fields": {
        "id": { "type": "uuid", "primary": true },
        "name": { "type": "string", "required": true },
        "slug": { "type": "string", "unique": true }
      }
    },

    // Junction table
    "OrganizationUser": {
      "fields": {
        "id": { "type": "uuid", "primary": true },
        "organization_id": {
          "type": "uuid",
          "references": "Organization.id"
        },
        "user_id": {
          "type": "uuid",
          "references": "User.id"
        },
        "role": {
          "type": "enum",
          "values": ["owner", "admin", "member"]
        }
      },
      "unique": [["organization_id", "user_id"]]
    }
  }
}
```

### Social Login Extended Fields

```json
{
  "User": {
    "fields": {
      // Standard fields...

      // Social profile fields
      "google_profile": {
        "type": "json",
        "nullable": true,
        "description": "Google profile data"
      },
      "github_username": {
        "type": "string",
        "nullable": true,
        "unique": true,
        "description": "GitHub username"
      },
      "linkedin_url": {
        "type": "string",
        "nullable": true,
        "description": "LinkedIn profile URL"
      },
      "social_metadata": {
        "type": "json",
        "nullable": true,
        "description": "Additional social profile data"
      }
    }
  }
}
```

## Migration from Existing Schema

### Step 1: Identify Conflicts

```bash
# Check for conflicting entity names
grep -E '"(Account|Session|Verification)"' .apsorc
```

### Step 2: Rename Conflicting Entities

```json
// Before
{
  "Account": {  // ❌ Conflicts
    "fields": { ... }
  }
}

// After
{
  "Organization": {  // ✅ Renamed
    "fields": { ... }
  }
}
```

### Step 3: Update References

```json
// Update foreign keys
{
  "Project": {
    "fields": {
      "organization_id": {  // Changed from account_id
        "references": "Organization.id"  // Changed from Account.id
      }
    }
  }
}
```

### Step 4: Database Migration

```sql
-- Rename existing tables
ALTER TABLE account RENAME TO organization;
ALTER TABLE session RENAME TO discovery_session;

-- Update foreign key constraints
ALTER TABLE project
  DROP CONSTRAINT project_account_id_fkey,
  ADD CONSTRAINT project_organization_id_fkey
    FOREIGN KEY (organization_id) REFERENCES organization(id);
```

## Validation & Testing

### Schema Validation Checklist

- [ ] User entity is PascalCase
- [ ] account, session, verification are lowercase
- [ ] Nullable fields marked correctly
- [ ] Required fields have defaults where appropriate
- [ ] Unique constraints in place
- [ ] Indexes on frequently queried fields
- [ ] Foreign keys with proper CASCADE rules

### Testing Commands

```bash
# Generate and validate
npx apso generate

# Check generated entities
ls -la backend/src/autogen/User/
ls -la backend/src/autogen/account/
ls -la backend/src/autogen/session/
ls -la backend/src/autogen/verification/

# Verify database tables
psql -U postgres -d your_db -c "\dt public.*"

# Test CRUD operations
curl -X POST http://localhost:3001/Users -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","name":"Test User"}'

curl http://localhost:3001/Users
curl http://localhost:3001/accounts
curl http://localhost:3001/sessions
```

### Common Validation Errors

| Error | Cause | Solution |
|-------|-------|----------|
| "Entity 'user' not found" | Wrong case | Use `User` (PascalCase) |
| "Column 'avatar_url' cannot be null" | Missing nullable | Add `nullable: true` |
| "Duplicate key value violates unique constraint" | Missing unique constraint | Add unique constraint |
| "Foreign key constraint fails" | Wrong reference | Check entity name and field |

## Best Practices

1. **Always use UUIDs for IDs** - Better for distributed systems
2. **Add indexes on foreign keys** - Improves JOIN performance
3. **Use CASCADE for auth entities** - Clean up on user deletion
4. **Keep sensitive fields nullable** - Not all auth methods use all fields
5. **Add audit fields** - created_at, updated_at on all entities
6. **Use enums for fixed values** - OAuth providers, roles, etc.
7. **Plan for expansion** - Add metadata/profile fields as JSON

## Complete Example

```json
{
  "service": "saas-platform",
  "database": {
    "provider": "postgresql",
    "multiTenant": true,
    "tenantKey": "organization_id"
  },
  "entities": {
    // Auth entities (exactly as required)
    "User": {
      "fields": {
        "id": { "type": "uuid", "primary": true, "default": "uuid_generate_v4()" },
        "email": { "type": "string", "unique": true, "required": true },
        "email_verified": { "type": "boolean", "default": false },
        "name": { "type": "string", "required": true },
        "avatar_url": { "type": "string", "nullable": true },
        "password_hash": { "type": "string", "nullable": true },
        "oauth_provider": {
          "type": "enum",
          "values": ["google", "github"],
          "nullable": true
        },
        "oauth_id": { "type": "string", "nullable": true },
        "created_at": { "type": "timestamp", "default": "now()" },
        "updated_at": { "type": "timestamp", "default": "now()" }
      }
    },
    "account": {
      "fields": {
        "id": { "type": "uuid", "primary": true, "default": "uuid_generate_v4()" },
        "userId": { "type": "uuid", "required": true, "references": "User.id" },
        "accountId": { "type": "string", "required": true },
        "providerId": { "type": "string", "required": true },
        "accessToken": { "type": "text", "nullable": true },
        "refreshToken": { "type": "text", "nullable": true },
        "password": { "type": "string", "nullable": true },
        "created_at": { "type": "timestamp", "default": "now()" }
      }
    },
    "session": {
      "fields": {
        "id": { "type": "uuid", "primary": true, "default": "uuid_generate_v4()" },
        "sessionToken": { "type": "string", "unique": true, "required": true },
        "userId": { "type": "uuid", "required": true, "references": "User.id" },
        "expiresAt": { "type": "timestamp", "required": true },
        "created_at": { "type": "timestamp", "default": "now()" }
      }
    },
    "verification": {
      "fields": {
        "id": { "type": "uuid", "primary": true, "default": "uuid_generate_v4()" },
        "identifier": { "type": "string", "required": true },
        "value": { "type": "string", "required": true },
        "expiresAt": { "type": "timestamp", "required": true },
        "created_at": { "type": "timestamp", "default": "now()" }
      }
    },

    // Business entities
    "Organization": {
      "fields": {
        "id": { "type": "uuid", "primary": true, "default": "uuid_generate_v4()" },
        "name": { "type": "string", "required": true },
        "created_at": { "type": "timestamp", "default": "now()" }
      }
    }
  }
}
```

This configuration provides a complete, working authentication setup with Better Auth and Apso.