# API Patterns

Common API patterns and conventions used in Mavric DevEnv projects.

---

## RESTful Conventions

### Resource Naming

| Pattern | Example | Description |
|---------|---------|-------------|
| Plural nouns | `/users`, `/projects` | Resource collections |
| Kebab-case | `/user-settings` | Multi-word resources |
| Nested resources | `/users/:id/posts` | Related resources |

### HTTP Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `GET` | Read resource(s) | `GET /users` |
| `POST` | Create resource | `POST /users` |
| `PUT` | Replace resource | `PUT /users/:id` |
| `PATCH` | Update resource | `PATCH /users/:id` |
| `DELETE` | Delete resource | `DELETE /users/:id` |

---

## Request/Response Format

### Success Response

```json
{
  "success": true,
  "data": {
    "id": "123",
    "name": "Project Alpha",
    "createdAt": "2024-01-15T10:30:00Z"
  }
}
```

### List Response (with pagination)

```json
{
  "success": true,
  "data": [
    { "id": "1", "name": "Project A" },
    { "id": "2", "name": "Project B" }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "totalPages": 8
  }
}
```

### Error Response

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": {
      "email": "Invalid email format",
      "name": "Name is required"
    }
  }
}
```

---

## Status Codes

### Success Codes

| Code | Meaning | Use Case |
|------|---------|----------|
| `200` | OK | Successful GET, PUT, PATCH, DELETE |
| `201` | Created | Successful POST |
| `204` | No Content | Successful DELETE (no body) |

### Client Error Codes

| Code | Meaning | Use Case |
|------|---------|----------|
| `400` | Bad Request | Invalid request format |
| `401` | Unauthorized | Missing/invalid auth |
| `403` | Forbidden | Insufficient permissions |
| `404` | Not Found | Resource doesn't exist |
| `409` | Conflict | Duplicate resource |
| `422` | Unprocessable | Validation errors |

### Server Error Codes

| Code | Meaning | Use Case |
|------|---------|----------|
| `500` | Internal Error | Unexpected server error |
| `503` | Service Unavailable | Maintenance/overload |

---

## Authentication Patterns

### Session-Based Auth

BetterAuth uses session-based authentication:

```typescript
// Check authentication
const session = await auth.getSession(request);
if (!session) {
  throw new UnauthorizedException();
}
```

### Auth Headers

```http
GET /api/projects HTTP/1.1
Cookie: session=abc123...
```

### Protected Routes

```typescript
@UseGuards(AuthGuard)
@Get('projects')
async getProjects(@CurrentUser() user: User) {
  return this.projectService.findByUser(user.id);
}
```

---

## Multi-Tenancy Patterns

### Organization Scoping

**Critical**: Every query must be scoped by organization.

```typescript
// ✅ Correct: Scoped by organization
async getProjects(orgId: string) {
  return this.projectRepo.find({
    where: { organizationId: orgId }
  });
}

// ❌ Wrong: Exposes all data
async getProjects() {
  return this.projectRepo.find();
}
```

### Request Context

```typescript
@Injectable()
export class OrganizationMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction) {
    const orgId = req.headers['x-organization-id'];
    req.organizationId = orgId;
    next();
  }
}
```

---

## Validation Patterns

### DTO Validation

```typescript
import { IsString, IsEmail, MinLength, IsOptional } from 'class-validator';

export class CreateUserDto {
  @IsEmail()
  email: string;

  @IsString()
  @MinLength(2)
  name: string;

  @IsString()
  @MinLength(8)
  password: string;

  @IsOptional()
  @IsString()
  avatar?: string;
}
```

### Controller Validation

```typescript
@Post()
async create(@Body() dto: CreateUserDto) {
  // Validation happens automatically via ValidationPipe
  return this.userService.create(dto);
}
```

### Zod Validation (Frontend)

```typescript
import { z } from 'zod';

const createUserSchema = z.object({
  email: z.string().email('Invalid email'),
  name: z.string().min(2, 'Name too short'),
  password: z.string().min(8, 'Password too short'),
});

type CreateUserInput = z.infer<typeof createUserSchema>;
```

---

## Error Handling Patterns

### Custom Error Classes

```typescript
export class AppError extends Error {
  constructor(
    public message: string,
    public statusCode: number,
    public code: string,
    public details?: Record<string, unknown>
  ) {
    super(message);
  }
}

export class NotFoundError extends AppError {
  constructor(resource: string, id: string) {
    super(
      `${resource} with id ${id} not found`,
      404,
      'NOT_FOUND'
    );
  }
}

export class ValidationError extends AppError {
  constructor(details: Record<string, string>) {
    super(
      'Validation failed',
      422,
      'VALIDATION_ERROR',
      details
    );
  }
}
```

### Global Exception Filter

```typescript
@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();

    if (exception instanceof AppError) {
      return response.status(exception.statusCode).json({
        success: false,
        error: {
          code: exception.code,
          message: exception.message,
          details: exception.details,
        },
      });
    }

    // Unexpected error
    return response.status(500).json({
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: 'An unexpected error occurred',
      },
    });
  }
}
```

---

## Pagination Patterns

### Query Parameters

```http
GET /api/projects?page=2&limit=20&sort=createdAt&order=desc
```

### Implementation

```typescript
interface PaginationParams {
  page?: number;
  limit?: number;
  sort?: string;
  order?: 'asc' | 'desc';
}

async findAll(params: PaginationParams) {
  const { page = 1, limit = 20, sort = 'createdAt', order = 'desc' } = params;

  const [data, total] = await this.repo.findAndCount({
    skip: (page - 1) * limit,
    take: limit,
    order: { [sort]: order },
  });

  return {
    data,
    meta: {
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit),
    },
  };
}
```

---

## Filtering Patterns

### Query String Filters

```http
GET /api/projects?status=active&createdAfter=2024-01-01
```

### Implementation

```typescript
interface ProjectFilters {
  status?: string;
  createdAfter?: string;
  search?: string;
}

async findAll(filters: ProjectFilters, orgId: string) {
  const query = this.repo.createQueryBuilder('project')
    .where('project.organizationId = :orgId', { orgId });

  if (filters.status) {
    query.andWhere('project.status = :status', { status: filters.status });
  }

  if (filters.createdAfter) {
    query.andWhere('project.createdAt >= :date', { date: filters.createdAfter });
  }

  if (filters.search) {
    query.andWhere('project.name ILIKE :search', { search: `%${filters.search}%` });
  }

  return query.getMany();
}
```

---

## Relationship Patterns

### Eager Loading

```typescript
// Load project with members
const project = await this.projectRepo.findOne({
  where: { id },
  relations: ['members', 'owner'],
});
```

### Nested Resources

```typescript
// GET /projects/:projectId/tasks
@Get(':projectId/tasks')
async getProjectTasks(@Param('projectId') projectId: string) {
  return this.taskService.findByProject(projectId);
}

// POST /projects/:projectId/tasks
@Post(':projectId/tasks')
async createTask(
  @Param('projectId') projectId: string,
  @Body() dto: CreateTaskDto
) {
  return this.taskService.create({ ...dto, projectId });
}
```

---

## Rate Limiting

### Configuration

```typescript
import rateLimit from 'express-rate-limit';

// General API limit
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100,
  message: { error: { code: 'RATE_LIMITED', message: 'Too many requests' } },
});

// Stricter auth limit
const authLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1 hour
  max: 10,
  message: { error: { code: 'RATE_LIMITED', message: 'Too many login attempts' } },
});

app.use('/api/', apiLimiter);
app.use('/api/auth/', authLimiter);
```

---

## CORS Configuration

```typescript
// Specific origins (production)
app.use(cors({
  origin: [
    'https://app.example.com',
    'https://admin.example.com',
  ],
  credentials: true,
}));

// Development
app.use(cors({
  origin: 'http://localhost:3000',
  credentials: true,
}));
```
