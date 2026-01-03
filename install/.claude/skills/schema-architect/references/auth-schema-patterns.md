# Authentication Schema Patterns for Apso

> Reference patterns for designing schemas with Better Auth integration using Apso v2 format

## Standard Auth Schema Pattern

### Complete Multi-Tenant SaaS Schema (Apso v2)

```json
{
  "version": 2,
  "rootFolder": "src",
  "relationships": [
    // Auth relationships
    {
      "from": "account",
      "to": "User",
      "type": "ManyToOne",
      "to_name": "user"
    },
    {
      "from": "session",
      "to": "User",
      "type": "ManyToOne",
      "to_name": "user"
    },
    // Business relationships
    {
      "from": "OrganizationUser",
      "to": "Organization",
      "type": "ManyToOne",
      "to_name": "organization"
    },
    {
      "from": "OrganizationUser",
      "to": "User",
      "type": "ManyToOne",
      "to_name": "user"
    }
  ],
  "entities": [
    // ============ AUTH ENTITIES (Better Auth) ============
    {
      "name": "User",
      "created_at": true,
      "updated_at": true,
      "fields": [
        { "name": "email", "type": "text", "length": 255, "unique": true },
        { "name": "email_verified", "type": "boolean", "default": false },
        { "name": "name", "type": "text", "length": 255 },
        { "name": "avatar_url", "type": "text", "nullable": true },
        { "name": "password_hash", "type": "text", "nullable": true },
        {
          "name": "oauth_provider",
          "type": "enum",
          "values": ["google", "github", "microsoft"],
          "nullable": true
        },
        { "name": "oauth_id", "type": "text", "nullable": true }
      ]
    },
    {
      "name": "account",
      "created_at": true,
      "fields": [
        { "name": "accountId", "type": "text", "length": 255 },
        { "name": "providerId", "type": "text", "length": 255 },
        { "name": "accessToken", "type": "text", "nullable": true },
        { "name": "refreshToken", "type": "text", "nullable": true },
        { "name": "password", "type": "text", "nullable": true }
      ]
    },
    {
      "name": "session",
      "created_at": true,
      "fields": [
        { "name": "sessionToken", "type": "text", "length": 255, "unique": true },
        { "name": "expiresAt", "type": "timestamp" }
      ]
    },
    {
      "name": "verification",
      "created_at": true,
      "fields": [
        { "name": "identifier", "type": "text", "length": 255 },
        { "name": "value", "type": "text", "length": 255 },
        { "name": "expiresAt", "type": "timestamp" }
      ]
    },

    // ============ BUSINESS ENTITIES ============
    {
      "name": "Organization",
      "created_at": true,
      "updated_at": true,
      "fields": [
        { "name": "name", "type": "text", "length": 255 },
        { "name": "slug", "type": "text", "length": 100, "unique": true },
        { "name": "billing_email", "type": "text", "length": 255 },
        {
          "name": "subscription_tier",
          "type": "enum",
          "values": ["free", "starter", "professional", "enterprise"],
          "default": "free"
        }
      ]
    },
    {
      "name": "OrganizationUser",
      "created_at": true,
      "fields": [
        {
          "name": "role",
          "type": "enum",
          "values": ["owner", "admin", "member", "viewer"],
          "default": "member"
        }
      ]
    }
  ]
}
```

## Common Auth Schema Patterns (Add to entities array)

### 1. Single Sign-On (SSO) Pattern

```json
{
  "name": "SSOProvider",
  "created_at": true,
  "updated_at": true,
  "fields": [
    {
      "name": "provider",
      "type": "enum",
      "values": ["okta", "auth0", "azure_ad"]
    },
    { "name": "client_id", "type": "text", "length": 255 },
    { "name": "client_secret", "type": "text" },
    { "name": "domain", "type": "text", "length": 255 },
    { "name": "enabled", "type": "boolean", "default": true }
  ]
}
```

With relationship:
```json
{
  "from": "SSOProvider",
  "to": "Organization",
  "type": "ManyToOne",
  "to_name": "organization"
}
```

### 2. Two-Factor Authentication Pattern

```json
{
  "name": "TwoFactorAuth",
  "created_at": true,
  "updated_at": true,
  "fields": [
    { "name": "secret", "type": "text" },
    { "name": "backup_codes", "type": "json" },
    { "name": "enabled", "type": "boolean", "default": false },
    { "name": "verified_at", "type": "timestamp", "nullable": true }
  ]
}
```

With relationship:
```json
{
  "from": "TwoFactorAuth",
  "to": "User",
  "type": "OneToOne",
  "to_name": "user"
}
```

### 3. API Key Pattern

```json
{
  "name": "ApiKey",
  "created_at": true,
  "updated_at": true,
  "fields": [
    { "name": "name", "type": "text", "length": 255 },
    { "name": "key_hash", "type": "text", "unique": true },
    { "name": "last_used_at", "type": "timestamp", "nullable": true },
    { "name": "expires_at", "type": "timestamp", "nullable": true },
    { "name": "scopes", "type": "json" }
  ]
}
```

With relationships:
```json
{
  "from": "ApiKey",
  "to": "Organization",
  "type": "ManyToOne",
  "to_name": "organization"
},
{
  "from": "ApiKey",
  "to": "User",
  "type": "ManyToOne",
  "to_name": "created_by"
}
```

### 4. Audit Log Pattern

```json
{
  "name": "AuditLog",
  "created_at": true,
  "fields": [
    { "name": "action", "type": "text", "length": 100 },
    { "name": "resource_type", "type": "text", "length": 100 },
    { "name": "resource_id", "type": "text", "length": 100, "nullable": true },
    { "name": "ip_address", "type": "text", "length": 45, "nullable": true },
    { "name": "user_agent", "type": "text", "nullable": true },
    { "name": "metadata", "type": "json", "nullable": true }
  ]
}
```

With relationships:
```json
{
  "from": "AuditLog",
  "to": "Organization",
  "type": "ManyToOne",
  "to_name": "organization"
},
{
  "from": "AuditLog",
  "to": "User",
  "type": "ManyToOne",
  "to_name": "user",
  "nullable": true
}
```

### 5. Permission System Pattern

```json
{
  "name": "Role",
  "created_at": true,
  "updated_at": true,
  "fields": [
    { "name": "name", "type": "text", "length": 100 },
    { "name": "description", "type": "text", "nullable": true },
    { "name": "permissions", "type": "json" },
    { "name": "is_system", "type": "boolean", "default": false }
  ]
},
{
  "name": "UserRole",
  "created_at": true,
  "fields": [
    { "name": "granted_at", "type": "timestamp" }
  ]
}
```

With relationships:
```json
{
  "from": "Role",
  "to": "Organization",
  "type": "ManyToOne",
  "to_name": "organization"
},
{
  "from": "UserRole",
  "to": "User",
  "type": "ManyToOne",
  "to_name": "user"
},
{
  "from": "UserRole",
  "to": "Role",
  "type": "ManyToOne",
  "to_name": "role"
},
{
  "from": "UserRole",
  "to": "Organization",
  "type": "ManyToOne",
  "to_name": "organization"
}
```

## Entity Naming Rules

### Reserved Names (Better Auth)

| Entity | Must Be | Table Name |
|--------|---------|------------|
| User | `User` (PascalCase) | `user` |
| Account | `account` (lowercase) | `account` |
| Session | `session` (lowercase) | `session` |
| Verification | `verification` (lowercase) | `verification` |

### Business Entity Alternatives

| Avoid | Use Instead |
|-------|-------------|
| Account | Organization, Company, Workspace, Tenant |
| Session | UserSession, DiscoverySession, ChatSession |
| Verification | EmailConfirmation, TokenVerification |

## Field Requirements (Apso v2)

### Always Nullable (OAuth Support)

In Apso v2, add `"nullable": true` to field definitions:

```json
{ "name": "avatar_url", "type": "text", "nullable": true },
{ "name": "password_hash", "type": "text", "nullable": true },
{ "name": "oauth_provider", "type": "enum", "values": [...], "nullable": true },
{ "name": "oauth_id", "type": "text", "nullable": true },
{ "name": "accessToken", "type": "text", "nullable": true },
{ "name": "refreshToken", "type": "text", "nullable": true }
```

### Never Nullable (Required)

These fields should NOT have `"nullable": true`:

```json
{ "name": "email", "type": "text", "length": 255, "unique": true },
{ "name": "sessionToken", "type": "text", "length": 255, "unique": true },
{ "name": "expiresAt", "type": "timestamp" }
```

## Unique Constraints (Apso v2)

Add unique constraint directly to field or use indexes:

```json
// Single field unique
{ "name": "email", "type": "text", "unique": true }

// Or using unique property on field
{ "name": "sessionToken", "type": "text", "unique": true }
```

For composite unique constraints, add to entity definition (note: Apso v2 may require custom implementation)

## Migration Checklist

When adding auth to existing schema:

1. [ ] Rename conflicting entities (Account → Organization)
2. [ ] Add User entity with nullable OAuth fields
3. [ ] Add account, session, verification entities (lowercase)
4. [ ] Create junction table (OrganizationUser)
5. [ ] Update foreign key references
6. [ ] Add appropriate indexes
7. [ ] Test with Better Auth adapter

## Common Mistakes to Avoid

1. ❌ Using `Account` for business entity
2. ❌ Not making OAuth fields nullable
3. ❌ Using wrong case for auth entities
4. ❌ Missing id field in DTOs
5. ❌ Not adding unique constraints
6. ❌ Forgetting CASCADE on delete
7. ❌ Missing organization_id in multi-tenant entities

## Reference Links

- [Complete Integration Guide](../../../.devenv/docs/auth/COMPLETE_AUTH_INTEGRATION_GUIDE.md)
- [Entity Configuration](../../../.devenv/docs/auth/APSORC_AUTH_ENTITIES.md)
- [Troubleshooting](../../../.devenv/docs/auth/TROUBLESHOOTING_AUTH.md)
- [Apso Schema Guide](../../../.devenv/standards/apso/apso-schema-guide.md)