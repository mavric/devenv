# BetterAuth + Apso Integration Reference Guide

> Complete reference for integrating Better Auth authentication with Apso-generated NestJS backends

---

## Table of Contents

1. [Entity Naming and Conflicts](#entity-naming-and-conflicts)
2. [Apso .apsorc Configuration](#apso-apsorc-configuration)
3. [Field Definitions](#field-definitions)
4. [Entity Relationships](#entity-relationships)
5. [Complete Configuration Examples](#complete-configuration-examples)
6. [Common Patterns](#common-patterns)
7. [Anti-Patterns to Avoid](#anti-patterns-to-avoid)
8. [Troubleshooting](#troubleshooting)

---

## Entity Naming and Conflicts

### Reserved Entity Names

Better Auth reserves the following entity names for its authentication system:

| Entity | Type | Managed By | Customizable |
|--------|------|------------|--------------|
| `User` | Core Auth | Better Auth | No (use PascalCase exactly) |
| `account` | OAuth/Credentials | Better Auth | No (use lowercase exactly) |
| `session` | Sessions | Better Auth | No (use lowercase exactly) |
| `verification` | Email Verification | Better Auth | No (use lowercase exactly) |

**Important:** These names are case-sensitive and must match exactly.

### Naming Your Business Entities

If your business domain needs entities similar to reserved names, **rename them**:

```
❌ WRONG: "Account" entity (conflicts with better auth's account)
✅ RIGHT: "Organization", "Company", "Workspace", "Team"

❌ WRONG: "Session" entity (conflicts with better auth's session)
✅ RIGHT: "DiscoverySession", "UserSession", "ChatSession", "GameSession"

✅ OK: "User" entity (you must use this for Better Auth)
✅ OK: "Profile", "Settings", "Preferences" (no conflicts)
```

### Example Naming Strategy

**If your product has sessions/accounts:**

```json
{
  "entities": [
    {
      "name": "User",
      "description": "Better Auth authentication user"
    },
    {
      "name": "Organization",
      "description": "Business entity (renamed from Account)"
    },
    {
      "name": "DiscoverySession",
      "description": "Application session (renamed from Session)"
    }
  ]
}
```

---

## Apso .apsorc Configuration

### Minimal Configuration with Better Auth

```json
{
  "version": 2,
  "rootFolder": "src",
  "entities": [
    {
      "name": "User",
      "description": "Better Auth user. Managed by Better Auth library.",
      "primaryKeyType": "uuid",
      "created_at": true,
      "updated_at": true,
      "fields": [
        {
          "name": "email",
          "type": "text",
          "length": 255,
          "unique": true,
          "required": true
        },
        {
          "name": "email_verified",
          "type": "boolean",
          "default": false
        },
        {
          "name": "name",
          "type": "text",
          "length": 255,
          "required": true
        },
        {
          "name": "avatar_url",
          "type": "text",
          "length": 500,
          "nullable": true
        }
      ]
    },
    {
      "name": "account",
      "description": "Better Auth OAuth and credential accounts. Managed by Better Auth.",
      "primaryKeyType": "uuid",
      "created_at": true,
      "updated_at": true,
      "fields": [
        {
          "name": "userId",
          "type": "text",
          "length": 36,
          "required": true
        },
        {
          "name": "accountId",
          "type": "text",
          "length": 255,
          "nullable": true,
          "comment": "OAuth provider's user ID"
        },
        {
          "name": "providerId",
          "type": "text",
          "length": 50,
          "nullable": true,
          "comment": "OAuth provider name (google, github, etc.)"
        },
        {
          "name": "accessToken",
          "type": "text",
          "nullable": true
        },
        {
          "name": "refreshToken",
          "type": "text",
          "nullable": true
        },
        {
          "name": "accessTokenExpiresAt",
          "type": "timestamp",
          "nullable": true
        },
        {
          "name": "refreshTokenExpiresAt",
          "type": "timestamp",
          "nullable": true
        },
        {
          "name": "scope",
          "type": "text",
          "length": 500,
          "nullable": true
        },
        {
          "name": "idToken",
          "type": "text",
          "nullable": true
        },
        {
          "name": "password",
          "type": "text",
          "length": 255,
          "nullable": true,
          "comment": "Hashed password for email/password auth"
        }
      ]
    },
    {
      "name": "session",
      "description": "Better Auth session management. Managed by Better Auth.",
      "primaryKeyType": "uuid",
      "created_at": true,
      "updated_at": true,
      "fields": [
        {
          "name": "userId",
          "type": "text",
          "length": 36,
          "required": true
        },
        {
          "name": "token",
          "type": "text",
          "length": 255,
          "unique": true,
          "required": true
        },
        {
          "name": "expiresAt",
          "type": "timestamp",
          "required": true
        },
        {
          "name": "ipAddress",
          "type": "text",
          "length": 45,
          "nullable": true
        },
        {
          "name": "userAgent",
          "type": "text",
          "length": 500,
          "nullable": true
        }
      ]
    },
    {
      "name": "Verification",
      "description": "Better Auth email verification and password reset tokens.",
      "primaryKeyType": "uuid",
      "created_at": true,
      "updated_at": true,
      "fields": [
        {
          "name": "identifier",
          "type": "text",
          "length": 255,
          "required": true
        },
        {
          "name": "value",
          "type": "text",
          "length": 255,
          "required": true
        },
        {
          "name": "expiresAt",
          "type": "timestamp",
          "required": true
        }
      ]
    },
    {
      "name": "Organization",
      "description": "Business entity. Multi-tenant root.",
      "primaryKeyType": "uuid",
      "created_at": true,
      "updated_at": true,
      "fields": [
        {
          "name": "name",
          "type": "text",
          "length": 255,
          "required": true
        },
        {
          "name": "slug",
          "type": "text",
          "length": 100,
          "unique": true,
          "required": true,
          "pattern": "^[a-z0-9-]+$"
        }
      ]
    }
  ],
  "relationships": [
    {
      "from": "User",
      "to": "Organization",
      "type": "ManyToOne",
      "fromField": "org_id",
      "toField": "id",
      "onDelete": "CASCADE"
    }
  ]
}
```

### Configuration for Existing Projects

If you have an existing Apso project, add Better Auth entities to your current `.apsorc`:

1. **Keep your existing entities**
2. **Add the 4 Better Auth entities** (User, account, session, Verification)
3. **Update relationships** to link your entities to User
4. **Run generation**: `npx apso generate`

---

## Field Definitions

### User Entity Fields

#### Core Identity Fields (Required)

```json
{
  "name": "email",
  "type": "text",
  "length": 255,
  "unique": true,
  "required": true,
  "comment": "User email address. Unique per user."
}
```

```json
{
  "name": "email_verified",
  "type": "boolean",
  "default": false,
  "comment": "Whether user has verified email address"
}
```

#### Profile Fields (Required)

```json
{
  "name": "name",
  "type": "text",
  "length": 255,
  "required": true,
  "comment": "User's display name"
}
```

#### Optional Profile Fields (Nullable)

```json
{
  "name": "avatar_url",
  "type": "text",
  "length": 500,
  "nullable": true,
  "comment": "URL to user's avatar. Null for users without avatar."
}
```

### Account Entity Fields

#### OAuth Fields

```json
{
  "name": "providerId",
  "type": "text",
  "length": 50,
  "nullable": true,
  "comment": "OAuth provider (google, github, discord, etc). Null for email/password auth."
}
```

```json
{
  "name": "accountId",
  "type": "text",
  "length": 255,
  "nullable": true,
  "comment": "OAuth provider's user ID. Null for email/password auth."
}
```

#### Token Fields (OAuth Only)

```json
{
  "name": "accessToken",
  "type": "text",
  "nullable": true,
  "comment": "OAuth access token. Null for email/password auth."
}
```

```json
{
  "name": "refreshToken",
  "type": "text",
  "nullable": true,
  "comment": "OAuth refresh token. Null for email/password auth."
}
```

```json
{
  "name": "accessTokenExpiresAt",
  "type": "timestamp",
  "nullable": true,
  "comment": "When access token expires. Null for email/password auth."
}
```

#### Password Field (Email/Password Only)

```json
{
  "name": "password",
  "type": "text",
  "length": 255,
  "nullable": true,
  "comment": "Hashed password. Null for OAuth-only accounts."
}
```

### Session Entity Fields

```json
{
  "name": "userId",
  "type": "text",
  "length": 36,
  "required": true,
  "comment": "ID of authenticated user"
}
```

```json
{
  "name": "token",
  "type": "text",
  "length": 255,
  "unique": true,
  "required": true,
  "comment": "Session token (JWT or opaque). Must be unique."
}
```

```json
{
  "name": "expiresAt",
  "type": "timestamp",
  "required": true,
  "comment": "Session expiration time"
}
```

```json
{
  "name": "ipAddress",
  "type": "text",
  "length": 45,
  "nullable": true,
  "comment": "IP address of session origin. Optional for logging."
}
```

```json
{
  "name": "userAgent",
  "type": "text",
  "length": 500,
  "nullable": true,
  "comment": "User agent of session device. Optional for logging."
}
```

### Verification Entity Fields

```json
{
  "name": "identifier",
  "type": "text",
  "length": 255,
  "required": true,
  "comment": "Email or identifier being verified"
}
```

```json
{
  "name": "value",
  "type": "text",
  "length": 255,
  "required": true,
  "comment": "Verification token (OTP or random code)"
}
```

```json
{
  "name": "expiresAt",
  "type": "timestamp",
  "required": true,
  "comment": "When verification token expires"
}
```

---

## Entity Relationships

### Linking Business Entities to User

#### ManyToOne (Multiple business entities per User)

```json
{
  "relationships": [
    {
      "from": "Organization",
      "to": "User",
      "type": "ManyToOne",
      "fromField": "owner_id",
      "toField": "id",
      "onDelete": "CASCADE",
      "required": true
    }
  ]
}
```

**Usage Pattern:**
```typescript
// Every organization has one owner (User)
organization.owner_id = session.user.id;

// Delete organization if owner is deleted
// (because onDelete: CASCADE)
```

#### OneToOne (One business entity per User)

```json
{
  "relationships": [
    {
      "from": "Profile",
      "to": "User",
      "type": "OneToOne",
      "fromField": "user_id",
      "toField": "id",
      "onDelete": "CASCADE"
    }
  ]
}
```

**Usage Pattern:**
```typescript
// Each user has exactly one profile
profile.user_id = session.user.id;

// Delete profile if user is deleted
```

#### Multi-Tenant User-Organization Relationship

For team/workspace scenarios:

```json
{
  "entities": [
    {
      "name": "User",
      "fields": [
        {
          "name": "email",
          "type": "text",
          "unique": true,
          "required": true
        }
      ]
    },
    {
      "name": "Organization",
      "fields": [
        {
          "name": "name",
          "type": "text",
          "required": true
        }
      ]
    },
    {
      "name": "OrganizationMember",
      "description": "Junction table for User-Organization many-to-many",
      "fields": [
        {
          "name": "role",
          "type": "enum",
          "values": ["owner", "admin", "member"]
        }
      ]
    }
  ],
  "relationships": [
    {
      "from": "OrganizationMember",
      "to": "User",
      "type": "ManyToOne",
      "fromField": "user_id",
      "toField": "id",
      "onDelete": "CASCADE"
    },
    {
      "from": "OrganizationMember",
      "to": "Organization",
      "type": "ManyToOne",
      "fromField": "org_id",
      "toField": "id",
      "onDelete": "CASCADE"
    }
  ]
}
```

**Usage Pattern:**
```typescript
// User can belong to multiple organizations
// Find all orgs for a user:
const orgs = await organizationMemberService.find({
  user_id: session.user.id
});

// Find all users in an org:
const members = await organizationMemberService.find({
  org_id: organization.id
});
```

---

## Complete Configuration Examples

### Example 1: Simple SaaS (Single Org per User)

```json
{
  "version": 2,
  "rootFolder": "src",
  "entities": [
    {
      "name": "User",
      "description": "Better Auth user",
      "primaryKeyType": "uuid",
      "created_at": true,
      "updated_at": true,
      "fields": [
        {
          "name": "email",
          "type": "text",
          "length": 255,
          "unique": true,
          "required": true
        },
        {
          "name": "email_verified",
          "type": "boolean",
          "default": false
        },
        {
          "name": "name",
          "type": "text",
          "length": 255,
          "required": true
        },
        {
          "name": "avatar_url",
          "type": "text",
          "length": 500,
          "nullable": true
        }
      ]
    },
    {
      "name": "account",
      "description": "Better Auth OAuth/credentials",
      "primaryKeyType": "uuid",
      "created_at": true,
      "updated_at": true,
      "fields": [
        {
          "name": "userId",
          "type": "text",
          "length": 36,
          "required": true
        },
        {
          "name": "accountId",
          "type": "text",
          "length": 255,
          "nullable": true
        },
        {
          "name": "providerId",
          "type": "text",
          "length": 50,
          "nullable": true
        },
        {
          "name": "accessToken",
          "type": "text",
          "nullable": true
        },
        {
          "name": "refreshToken",
          "type": "text",
          "nullable": true
        },
        {
          "name": "accessTokenExpiresAt",
          "type": "timestamp",
          "nullable": true
        },
        {
          "name": "refreshTokenExpiresAt",
          "type": "timestamp",
          "nullable": true
        },
        {
          "name": "scope",
          "type": "text",
          "length": 500,
          "nullable": true
        },
        {
          "name": "idToken",
          "type": "text",
          "nullable": true
        },
        {
          "name": "password",
          "type": "text",
          "length": 255,
          "nullable": true
        }
      ]
    },
    {
      "name": "session",
      "description": "Better Auth sessions",
      "primaryKeyType": "uuid",
      "created_at": true,
      "updated_at": true,
      "fields": [
        {
          "name": "userId",
          "type": "text",
          "length": 36,
          "required": true
        },
        {
          "name": "token",
          "type": "text",
          "length": 255,
          "unique": true,
          "required": true
        },
        {
          "name": "expiresAt",
          "type": "timestamp",
          "required": true
        },
        {
          "name": "ipAddress",
          "type": "text",
          "length": 45,
          "nullable": true
        },
        {
          "name": "userAgent",
          "type": "text",
          "length": 500,
          "nullable": true
        }
      ]
    },
    {
      "name": "Verification",
      "description": "Better Auth verification tokens",
      "primaryKeyType": "uuid",
      "created_at": true,
      "updated_at": true,
      "fields": [
        {
          "name": "identifier",
          "type": "text",
          "length": 255,
          "required": true
        },
        {
          "name": "value",
          "type": "text",
          "length": 255,
          "required": true
        },
        {
          "name": "expiresAt",
          "type": "timestamp",
          "required": true
        }
      ]
    },
    {
      "name": "Organization",
      "description": "User's workspace/org. 1:1 with User.",
      "primaryKeyType": "uuid",
      "created_at": true,
      "updated_at": true,
      "fields": [
        {
          "name": "user_id",
          "type": "text",
          "length": 36,
          "required": true
        },
        {
          "name": "name",
          "type": "text",
          "length": 255,
          "required": true
        },
        {
          "name": "slug",
          "type": "text",
          "length": 100,
          "unique": true,
          "required": true,
          "pattern": "^[a-z0-9-]+$"
        },
        {
          "name": "billing_email",
          "type": "text",
          "length": 255,
          "required": true
        },
        {
          "name": "stripe_customer_id",
          "type": "text",
          "length": 255,
          "nullable": true
        }
      ]
    }
  ],
  "relationships": [
    {
      "from": "Organization",
      "to": "User",
      "type": "ManyToOne",
      "fromField": "user_id",
      "toField": "id",
      "onDelete": "CASCADE"
    }
  ]
}
```

### Example 2: Team Collaboration SaaS

```json
{
  "version": 2,
  "rootFolder": "src",
  "entities": [
    {
      "name": "User",
      "fields": [
        {
          "name": "email",
          "type": "text",
          "unique": true,
          "required": true
        },
        {
          "name": "email_verified",
          "type": "boolean",
          "default": false
        },
        {
          "name": "name",
          "type": "text",
          "required": true
        },
        {
          "name": "avatar_url",
          "type": "text",
          "nullable": true
        }
      ]
    },
    {
      "name": "account",
      "fields": [
        {
          "name": "userId",
          "type": "text",
          "required": true
        },
        {
          "name": "accountId",
          "type": "text",
          "nullable": true
        },
        {
          "name": "providerId",
          "type": "text",
          "nullable": true
        },
        {
          "name": "password",
          "type": "text",
          "nullable": true
        }
      ]
    },
    {
      "name": "session",
      "fields": [
        {
          "name": "userId",
          "type": "text",
          "required": true
        },
        {
          "name": "token",
          "type": "text",
          "unique": true,
          "required": true
        },
        {
          "name": "expiresAt",
          "type": "timestamp",
          "required": true
        }
      ]
    },
    {
      "name": "Verification",
      "fields": [
        {
          "name": "identifier",
          "type": "text",
          "required": true
        },
        {
          "name": "value",
          "type": "text",
          "required": true
        },
        {
          "name": "expiresAt",
          "type": "timestamp",
          "required": true
        }
      ]
    },
    {
      "name": "Organization",
      "description": "Team workspace",
      "fields": [
        {
          "name": "name",
          "type": "text",
          "required": true
        },
        {
          "name": "slug",
          "type": "text",
          "unique": true,
          "required": true
        }
      ]
    },
    {
      "name": "OrganizationMember",
      "description": "Users in organization with roles",
      "fields": [
        {
          "name": "user_id",
          "type": "text",
          "required": true
        },
        {
          "name": "org_id",
          "type": "text",
          "required": true
        },
        {
          "name": "role",
          "type": "enum",
          "values": ["owner", "admin", "member"],
          "default": "member"
        }
      ]
    },
    {
      "name": "Project",
      "description": "Project within organization",
      "fields": [
        {
          "name": "org_id",
          "type": "text",
          "required": true
        },
        {
          "name": "name",
          "type": "text",
          "required": true
        },
        {
          "name": "description",
          "type": "text",
          "nullable": true
        }
      ]
    }
  ],
  "relationships": [
    {
      "from": "OrganizationMember",
      "to": "User",
      "type": "ManyToOne",
      "fromField": "user_id",
      "toField": "id",
      "onDelete": "CASCADE"
    },
    {
      "from": "OrganizationMember",
      "to": "Organization",
      "type": "ManyToOne",
      "fromField": "org_id",
      "toField": "id",
      "onDelete": "CASCADE"
    },
    {
      "from": "Project",
      "to": "Organization",
      "type": "ManyToOne",
      "fromField": "org_id",
      "toField": "id",
      "onDelete": "CASCADE"
    }
  ]
}
```

---

## Common Patterns

### Pattern 1: Protecting API Endpoints

**Backend - NestJS Guard:**

```typescript
// auth.guard.ts
import { Injectable, CanActivate, ExecutionContext, UnauthorizedException } from '@nestjs/common';

@Injectable()
export class AuthGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const authHeader = request.headers.authorization;

    if (!authHeader) {
      throw new UnauthorizedException('Missing authorization header');
    }

    // Verify token with Better Auth
    const token = authHeader.replace('Bearer ', '');
    const session = verifyToken(token);

    if (!session) {
      throw new UnauthorizedException('Invalid token');
    }

    // Attach user to request
    request.user = session.user;
    return true;
  }
}

// usage.controller.ts
import { UseGuards } from '@nestjs/common';

@Controller('projects')
@UseGuards(AuthGuard)
export class ProjectsController {
  @Get()
  async listProjects(@Req() request) {
    // request.user is set by AuthGuard
    const userId = request.user.id;
    return this.projectService.findByUserId(userId);
  }
}
```

### Pattern 2: Multi-Tenant Data Filtering

**Always filter by organization:**

```typescript
// projects.service.ts
@Injectable()
export class ProjectsService {
  async findByOrgId(orgId: string, userId: string) {
    // 1. Verify user belongs to org
    const member = await this.orgMemberService.findOne({
      org_id: orgId,
      user_id: userId
    });

    if (!member) {
      throw new ForbiddenException('Not a member of this org');
    }

    // 2. Return org's projects only
    return this.projectRepository.find({
      where: { org_id: orgId }
    });
  }
}
```

### Pattern 3: Sign-Up Flow

**Frontend:**

```typescript
// signup.ts
async function signUp(email: string, password: string, name: string) {
  // 1. Create user via Better Auth
  const result = await signUpEmail({
    email,
    password,
    name
  });

  if (!result.success) {
    throw new Error(result.error);
  }

  // 2. Create organization for user
  const org = await fetch('/api/organizations', {
    method: 'POST',
    body: JSON.stringify({
      name: name,
      slug: generateSlug(name),
      user_id: result.user.id
    })
  });

  return { user: result.user, organization: org };
}
```

**Backend:**

```typescript
// organizations.controller.ts
@Post()
async create(@Body() createOrgDto: CreateOrganizationDto) {
  // Verify user exists
  const user = await this.userService.findById(createOrgDto.user_id);
  if (!user) {
    throw new BadRequestException('User not found');
  }

  // Create org
  const org = await this.organizationService.create({
    name: createOrgDto.name,
    slug: createOrgDto.slug,
    user_id: createOrgDto.user_id
  });

  return org;
}
```

### Pattern 4: OAuth Integration

**Backend - Better Auth config:**

```typescript
// auth.ts
export const auth = betterAuth({
  database: apsoAdapter({
    baseUrl: process.env.BACKEND_URL
  }),
  emailAndPassword: { enabled: true },
  socialProviders: {
    google: {
      clientId: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET
    },
    github: {
      clientId: process.env.GITHUB_CLIENT_ID,
      clientSecret: process.env.GITHUB_CLIENT_SECRET
    }
  }
});
```

**Frontend - Sign-in with OAuth:**

```typescript
// login.tsx
async function handleGoogleLogin() {
  const result = await signIn.social({
    provider: 'google',
    callbackURL: '/dashboard'
  });

  if (result.error) {
    console.error(result.error);
  }
}
```

---

## Anti-Patterns to Avoid

### Anti-Pattern 1: Using Better Auth Reserved Names

❌ **Wrong:**
```json
{
  "entities": [
    {
      "name": "Account",
      "fields": [{ "name": "name", "type": "text" }]
    },
    {
      "name": "Session",
      "fields": [{ "name": "title", "type": "text" }]
    }
  ]
}
```

**Error you'll see:**
```
table 'account' already exists
table 'session' already exists
```

✅ **Right:**
```json
{
  "entities": [
    {
      "name": "Organization",
      "fields": [{ "name": "name", "type": "text" }]
    },
    {
      "name": "DiscoverySession",
      "fields": [{ "name": "title", "type": "text" }]
    }
  ]
}
```

### Anti-Pattern 2: Not Marking Optional User Fields as Nullable

❌ **Wrong:**
```json
{
  "name": "User",
  "fields": [
    {
      "name": "avatar_url",
      "type": "text",
      "required": true  // OAuth users won't have this!
    }
  ]
}
```

**Error you'll see:**
```
null value in column 'avatar_url' violates not-null constraint
```

✅ **Right:**
```json
{
  "name": "User",
  "fields": [
    {
      "name": "avatar_url",
      "type": "text",
      "nullable": true  // OAuth users can have null avatar
    }
  ]
}
```

### Anti-Pattern 3: Not Filtering by Organization

❌ **Wrong:**
```typescript
// This returns projects for ALL users
async findProjects() {
  return this.projectRepository.find();  // SECURITY BUG!
}
```

✅ **Right:**
```typescript
// This filters by user's organization
async findProjectsByUserId(userId: string) {
  // 1. Get user's org
  const member = await this.orgMemberService.findOne({ user_id: userId });

  // 2. Return only org's projects
  return this.projectRepository.find({
    where: { org_id: member.org_id }
  });
}
```

### Anti-Pattern 4: Storing Password Hash in User Entity

❌ **Wrong:**
```json
{
  "name": "User",
  "fields": [
    {
      "name": "password",
      "type": "text",
      "required": true
    }
  ]
}
```

**Problem:** Better Auth manages passwords in the `account.password` field, not in `user.password`.

✅ **Right:**
```json
{
  "name": "User",
  "fields": []  // Don't include password
}

{
  "name": "account",
  "fields": [
    {
      "name": "password",
      "type": "text",
      "nullable": true  // Managed by Better Auth
    }
  ]
}
```

### Anti-Pattern 5: Creating User Manually Instead of via Better Auth

❌ **Wrong:**
```typescript
// Never create users this way
const user = await this.userService.create({
  email: 'test@example.com',
  name: 'Test User'
});
```

**Problem:** No password/OAuth account created. User can't login.

✅ **Right:**
```typescript
// Always use Better Auth for signup
const result = await signUp.email({
  email: 'test@example.com',
  password: 'password123',
  name: 'Test User'
});

// Better Auth creates:
// - User record
// - account record with password
// - session record
```

---

## Troubleshooting

### Issue: "null value in column 'avatar_url' violates not-null constraint"

**Cause:** User entity has `nullable: false` on optional fields

**Fix:**
```json
{
  "name": "User",
  "fields": [
    {
      "name": "avatar_url",
      "type": "text",
      "nullable": true
    }
  ]
}
```

Then reset database:
```bash
# Drop and recreate database
PGPASSWORD=postgres psql -h localhost -U postgres -c "DROP DATABASE your_db;"
PGPASSWORD=postgres psql -h localhost -U postgres -c "CREATE DATABASE your_db;"

# Run migrations
npm run typeorm migration:run
```

### Issue: "table 'user' already exists"

**Cause:** Entity name conflicts with Better Auth table

**Fix:** Rename your entity
```json
❌ "Account" → ✅ "Organization"
❌ "Session" → ✅ "DiscoverySession"
```

### Issue: "User can't login after signup"

**Cause:** Created user manually or OAuth account not created

**Fix:** Always use Better Auth for authentication
```typescript
// ✅ Correct
const result = await signUp.email({ email, password, name });

// ❌ Wrong
await userService.create({ email, name });
```

### Issue: "Data leaking across organizations"

**Cause:** API endpoints not filtering by org_id

**Fix:** Always filter queries by organization
```typescript
async findProjects(userId: string) {
  const member = await this.orgMemberService.findOne({ user_id: userId });
  return this.projectRepository.find({
    where: { org_id: member.org_id }  // ← Always filter!
  });
}
```

### Issue: "Case sensitivity errors in table names"

**Cause:** Using wrong case for Better Auth entities

**Fix:**
```
✅ User (PascalCase)
✅ account (lowercase)
✅ session (lowercase)
✅ Verification (PascalCase)

❌ user (lowercase)
❌ Account (PascalCase)
❌ Session (PascalCase)
```

---

## Checklist Before Deployment

- [ ] All entity names checked against Better Auth reserved names
- [ ] User optional fields are nullable (avatar_url, password)
- [ ] account, session, Verification entities match exact case
- [ ] Relationships properly defined between User and business entities
- [ ] All API endpoints filter by organization
- [ ] User never created manually (only via Better Auth)
- [ ] OAuth accounts have nullable fields for providerId, accountId, etc.
- [ ] Database reset after schema changes
- [ ] Email/password signup tested
- [ ] OAuth signup tested (at least one provider)
- [ ] Session management working (can access authenticated routes)
- [ ] Data isolation verified (users can't see other org data)

---

**Last Updated:** 2025-01-18
**Version:** 1.0
**Status:** Complete Reference
