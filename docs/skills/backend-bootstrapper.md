# Backend Bootstrapper

Sets up production-ready Apso backends with NestJS REST APIs.

---

## Overview

| Attribute | Value |
|-----------|-------|
| **Name** | backend-bootstrapper |
| **Type** | Implementation skill |
| **Triggers** | "setup backend", "create API", "bootstrap server" |
| **Duration** | ~5 minutes (automated) |
| **Output** | Complete NestJS backend |
| **Location** | `.claude/skills/backend-bootstrapper/` |

---

## What It Creates

### 1. Apso Service Configuration

Complete `.apsorc` schema file with:
- All entities defined
- Relationships configured
- Validation rules
- Indexes optimized
- Multi-tenancy enabled

### 2. Generated NestJS Backend

Apso auto-generates:
- REST API with OpenAPI docs
- CRUD endpoints for all entities
- TypeORM models
- Database migrations
- Validation middleware
- Error handling
- Logging

### 3. Database Setup

- PostgreSQL database
- All tables created
- Relationships enforced
- Migrations ready

### 4. Development Environment

- Docker Compose for local database
- Environment variable configuration
- Development server with hot reload

### 5. API Documentation

- OpenAPI/Swagger at `/api/docs`
- Interactive testing UI
- Type definitions exported

---

## The Bootstrap Process

### Step 1: Validate Schema

Reviews the schema and:
- Checks for missing fields
- Validates relationships
- Ensures multi-tenancy
- Suggests optimizations

### Step 2: Create Apso Project

```bash
npx apso init
cd your-project-backend
```

### Step 3: Configure Schema

Creates `.apsorc` with your entities.

### Step 4: Generate Code

```bash
apso server scaffold
```

Creates:
```
src/
├── autogen/        # Generated code (DON'T EDIT)
├── extensions/     # Your custom code
├── common/         # Shared utilities
└── main.ts         # Entry point
```

### Step 5: Install Dependencies

```bash
npm install
```

### Step 6: Start Database

```bash
npm run compose
```

### Step 7: Provision Database

```bash
npm run provision
```

### Step 8: Start Server

```bash
npm run start:dev
```

Server runs at:
- API: `http://localhost:3001`
- Docs: `http://localhost:3001/api/docs`

---

## Generated API Structure

For each entity, you get:

### Standard REST Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/entities` | List all (paginated) |
| GET | `/entities/:id` | Get by ID |
| POST | `/entities` | Create new |
| PUT | `/entities/:id` | Full update |
| PATCH | `/entities/:id` | Partial update |
| DELETE | `/entities/:id` | Delete |

### Query Parameters

```
# Pagination
?page=1&limit=10

# Sorting
?sort=created_at&order=desc

# Filtering
?status=active

# Search
?search=keyword

# Relations
?include=organization,user
```

---

## File Structure

```
backend/
├── src/
│   ├── autogen/              # ⚠️ NEVER MODIFY
│   │   ├── Organization/
│   │   │   ├── Organization.entity.ts
│   │   │   ├── Organization.service.ts
│   │   │   ├── Organization.controller.ts
│   │   │   └── Organization.module.ts
│   │   ├── User/
│   │   └── guards/
│   │       ├── auth.guard.ts
│   │       └── scope.guard.ts
│   │
│   ├── extensions/           # ✅ YOUR CODE
│   │   ├── Organization/
│   │   │   └── Organization.controller.ts
│   │   └── auth/
│   │
│   └── common/
│       ├── interceptors/
│       └── filters/
│
├── .apsorc
├── docker-compose.yml
└── package.json
```

!!! danger "Never Edit autogen/"
    Files in `autogen/` are overwritten on every `apso server scaffold`.
    Put custom code in `extensions/`.

---

## Adding Custom Endpoints

```typescript
// src/extensions/Project/Project.controller.ts
import { Controller, Post, Param, Get } from '@nestjs/common';

@Controller('projects')
export class ProjectController {
  @Post(':id/archive')
  async archive(@Param('id') id: string) {
    return this.projectService.archive(id);
  }

  @Get(':id/statistics')
  async getStats(@Param('id') id: string) {
    return this.projectService.getStatistics(id);
  }
}
```

---

## Environment Configuration

```bash
# .env
NODE_ENV=development
PORT=3001

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=your_db
DB_USER=postgres
DB_PASSWORD=postgres

# Auth
AUTH_SECRET=your-secret-key
```

---

## Automatic Features

### Multi-Tenancy

All queries automatically filtered by organization:

```typescript
// Middleware adds organization context
@UseGuards(OrgGuard)
export class ProjectController {
  async findAll(@Req() req) {
    // Only returns projects for req.organizationId
  }
}
```

### Validation

Input validation with class-validator:

```typescript
class CreateProjectDto {
  @IsString()
  @MinLength(3)
  name: string;

  @IsEnum(['active', 'archived'])
  status: string;
}
```

### Error Handling

Consistent error responses:

```json
{
  "statusCode": 400,
  "message": "Validation failed",
  "errors": [
    { "field": "name", "message": "must be at least 3 characters" }
  ]
}
```

---

## Invocation

### Via Orchestrator

Automatically called as Phase 5 of `/start-project`.

### Via Script

```bash
./scripts/setup-apso-betterauth.sh
```

### Via Natural Language

```
"Setup the backend for my project"
"Bootstrap the API"
"Create the server"
```

---

## Common Issues

| Issue | Solution |
|-------|----------|
| Cannot connect to database | Ensure `npm run compose` is running |
| Module not found | Run `npm install` after generating |
| TypeORM entity not found | Run `npm run provision` |
| Port already in use | `lsof -ti:3001 \| xargs kill` |

---

## Related

- [Auth Bootstrapper](auth-bootstrapper.md) (adds authentication)
- [Schema Architect](schema-architect.md) (creates schema)
- [Feature Builder](feature-builder.md) (adds features)
