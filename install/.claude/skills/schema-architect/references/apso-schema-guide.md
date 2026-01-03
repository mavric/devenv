# Apso Schema Configuration - SaaS Base Template

> Use this `.apsorc` configuration with the Apso CLI to generate your NestJS backend

---

## Installation

```bash
# Install Apso CLI globally
npm install -g @apso/apso-cli

# Verify installation
apso --version
```

---

## Quick Start

```bash
# 1. Create new backend project
apso server new --name lightbulb-backend

# 2. Navigate to project
cd lightbulb-backend

# 3. Copy the .apsorc example configuration
# See apsorc-example.json in this directory for full configuration

# 4. Generate code from schema
apso server scaffold

# 5. Install dependencies
npm install

# 6. Start local PostgreSQL (Docker)
npm run compose

# 7. Provision database schema
npm run provision

# 8. Start development server
npm run start:dev
```

---

## `.apsorc` Configuration

The `.apsorc` file defines your database schema, entities, and relationships. See `apsorc-example.json` for a complete example.

### File Structure

```json
{
  "version": 2,
  "rootFolder": "src",
  "relationships": [
    // Define entity relationships here
  ],
  "entities": [
    // Define entities and fields here
  ]
}
```

### Full Example

See [`apsorc-example.json`](./apsorc-example.json) for a complete SaaS template with:

- **Organizations** - Multi-tenant organization management
- **Users** - User accounts with roles and status
- **Invitations** - Team invitation system
- **Subscriptions** - Stripe subscription tracking
- **ApiKeys** - API key management
- **Webhooks** - Webhook configuration
- **AuditLogs** - Audit trail logging
- **Files** - File storage metadata
- **Notifications** - User notifications

---

## Customizing Your Schema

### Adding New Entities

```json
{
  "name": "Project",
  "created_at": true,
  "updated_at": true,
  "fields": [
    { "name": "name", "type": "text", "length": 255 },
    { "name": "description", "type": "text", "nullable": true },
    { "name": "status", "type": "enum", "values": ["active", "archived"], "default": "active" }
  ]
}
```

### Adding Relationships

```json
{
  "from": "Project",
  "to": "Organization",
  "type": "ManyToOne",
  "to_name": "organization"
}
```

### Field Types

| Type | Description | Example |
|------|-------------|---------|
| `text` | String/varchar | `{ "name": "email", "type": "text", "length": 255 }` |
| `integer` | Integer number | `{ "name": "count", "type": "integer", "default": 0 }` |
| `decimal` | Decimal number | `{ "name": "price", "type": "decimal", "precision": 10, "scale": 2 }` |
| `boolean` | True/false | `{ "name": "active", "type": "boolean", "default": true }` |
| `enum` | Enumerated values | `{ "name": "status", "type": "enum", "values": ["active", "inactive"] }` |
| `json` | JSON object | `{ "name": "metadata", "type": "json" }` |
| `timestamp` | Date/time | `{ "name": "expires_at", "type": "timestamp", "nullable": true }` |

### Relationship Types

| Type | Description | Example |
|------|-------------|---------|
| `OneToMany` | One-to-many | User has many Projects |
| `ManyToOne` | Many-to-one | Project belongs to User |
| `ManyToMany` | Many-to-many | User has many Roles, Role has many Users |

### Multi-Tenancy with `scopeBy`

The `scopeBy` property enables automatic multi-tenant data isolation on entities. When configured, Apso CLI generates scope guards that automatically:

- **Filter GET (list)** requests by the scope field
- **Verify access** on GET/PUT/PATCH/DELETE by ID
- **Auto-inject** scope values on POST (create)

#### Basic Usage

```json
{
  "name": "Project",
  "scopeBy": "organizationId",
  "fields": [
    { "name": "name", "type": "text", "length": 255 },
    { "name": "organizationId", "type": "text", "length": 50 }
  ]
}
```

#### Advanced Options

```json
{
  "name": "Project",
  "scopeBy": "organizationId",
  "scopeOptions": {
    "injectOnCreate": true,
    "enforceOn": ["find", "get", "create", "update", "delete"],
    "bypassRoles": ["admin", "superadmin"]
  }
}
```

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `injectOnCreate` | boolean | `true` | Auto-inject scope value on POST requests |
| `enforceOn` | string[] | `["find", "get", "create", "update", "delete"]` | Which operations to enforce scoping |
| `bypassRoles` | string[] | `[]` | Roles that skip scope enforcement |

#### Multiple Scopes

```json
{
  "name": "Task",
  "scopeBy": ["organizationId", "projectId"],
  "fields": [...]
}
```

#### Nested Scopes

For entities that inherit scope from a parent relationship:

```json
{
  "name": "Comment",
  "scopeBy": "task.organizationId",
  "fields": [...]
}
```

#### Generated Files

When entities have `scopeBy` configured, `apso server scaffold` generates:

```
src/autogen/guards/
├── auth.guard.ts      # AuthGuard for session validation (when auth.provider configured)
├── scope.guard.ts     # ScopeGuard with ENTITY_SCOPES configuration
├── guards.module.ts   # NestJS module providing the guards
└── index.ts           # Barrel exports
```

**Important:** Guards are now generated inside `src/autogen/guards/` to clearly indicate they are auto-generated and should not be manually edited.

The generated guards are **not enabled globally by default**. To enable:

1. **Globally:** Uncomment the `APP_GUARD` provider in `guards.module.ts`
2. **Per-controller:** Use `@UseGuards(AuthGuard, ScopeGuard)` decorator

---

## Code Generation

### Running Scaffold

```bash
# Generate all code from .apsorc
apso server scaffold
```

This generates:
- **Entities** - TypeORM entities in `src/autogen/[Entity]/`
- **Services** - CRUD services
- **Controllers** - REST API controllers
- **DTOs** - Data transfer objects
- **Modules** - NestJS modules

### Generated Code Structure

```
src/
├── autogen/              # ⚠️ NEVER MODIFY - Auto-generated
│   ├── Organization/
│   │   ├── Organization.entity.ts
│   │   ├── Organization.service.ts
│   │   ├── Organization.controller.ts
│   │   └── Organization.module.ts
│   ├── User/
│   ├── guards/           # ⚠️ AUTO-GENERATED - Auth & scope guards
│   │   ├── auth.guard.ts     # Auth guard (when auth.provider configured)
│   │   ├── scope.guard.ts    # Scope guard (when scopeBy configured)
│   │   ├── guards.module.ts  # NestJS module for guards
│   │   └── index.ts          # Barrel exports
│   └── ...
├── extensions/           # ✅ Add custom logic here
│   ├── Organization/
│   │   ├── Organization.service.ts
│   │   └── Organization.controller.ts
│   └── ...
```

**Important:**
- Guards are now generated inside `src/autogen/guards/` to clearly indicate they are auto-generated
- Never modify files in `autogen/`. They are overwritten on every scaffold
- Use `extensions/` for custom code

---

## Extending Generated Code

### Custom Service Logic

```typescript
// src/extensions/Organization/Organization.service.ts
import { Injectable } from '@nestjs/common';
import { OrganizationService as AutogenService } from '../../autogen/Organization/Organization.service';

@Injectable()
export class OrganizationService extends AutogenService {
  // Add custom methods
  async findBySlug(slug: string) {
    return this.organizationRepository.findOne({ where: { slug } });
  }
}
```

### Custom Controller Endpoints

```typescript
// src/extensions/Organization/Organization.controller.ts
import { Controller, Get, Param } from '@nestjs/common';
import { OrganizationService } from './Organization.service';

@Controller('organizations')
export class OrganizationController {
  constructor(private readonly organizationService: OrganizationService) {}

  @Get('slug/:slug')
  async findBySlug(@Param('slug') slug: string) {
    return this.organizationService.findBySlug(slug);
  }
}
```

---

## Local Development

### Start PostgreSQL

```bash
# Start Docker container with PostgreSQL
npm run compose
```

### Provision Database

```bash
# Create database schema and tables
npm run provision
```

### Auto-Sync Mode (Development)

For rapid prototyping, enable auto-sync in `.env`:

```env
DATABASE_SYNC=true
```

**Warning:** This automatically syncs schema changes. Don't use in production.

---

## Environment Variables

Create a `.env` file in your project root:

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=lightbulb_dev

# Auto-sync (development only)
DATABASE_SYNC=true

# Application
PORT=3001
NODE_ENV=development

# Stripe (if using subscriptions)
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# AWS S3 (if using file uploads)
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_S3_BUCKET=lightbulb-files
AWS_S3_REGION=us-east-1
```

---

## Apso CLI Commands

```bash
# Create new project
apso server new --name <project-name>

# Generate code from .apsorc
apso server scaffold

# View help
apso help

# View server commands
apso server --help
```

---

## Testing the API

Once your server is running (`npm run start:dev`), test the generated API:

### OpenAPI Documentation

Visit: `http://localhost:3001/api/docs`

### Example Requests

**Create Organization:**
```bash
curl -X POST http://localhost:3001/organizations \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Acme Corp",
    "slug": "acme",
    "billing_email": "billing@acme.com"
  }'
```

**Get All Organizations:**
```bash
curl http://localhost:3001/organizations
```

**Get Organization by ID:**
```bash
curl http://localhost:3001/organizations/1
```

---

## Migration Workflow

### Schema Changes

1. Update `.apsorc` file
2. Run `apso server scaffold`
3. Review generated code
4. Test locally
5. Commit changes

### Database Migrations

For production, disable `DATABASE_SYNC` and use migrations:

```bash
# Generate migration
npm run migration:generate -- -n AddProjectsTable

# Run migrations
npm run migration:run

# Revert migration
npm run migration:revert
```

---

## Deployment

### Build for Production

```bash
npm run build
```

### Start Production Server

```bash
npm run start:prod
```

### Environment-Specific Configuration

- **Development:** Use `.env` with `DATABASE_SYNC=true`
- **Staging:** Use proper migrations, separate database
- **Production:** Use migrations, environment variables from secrets manager

---

## Resources

- **Apso CLI Package:** https://www.npmjs.com/package/@apso/apso-cli
- **Apso Platform:** https://app.staging.apso.cloud/docs
- **NestJS Docs:** https://docs.nestjs.com/
- **TypeORM Docs:** https://typeorm.io/

---

## Support

For questions or issues:
- Check the [Apso CLI README](../../../apso/packages/apso-cli/README.md)
- Visit https://app.staging.apso.cloud/docs
- Contact Mavric dev team

---

**Template Version:** 2.0
**CLI Version:** @apso/apso-cli
**Code Generation Time:** ~30 seconds
**Production Ready:** Day 1
