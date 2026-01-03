# Contribution Standards

Core coding standards for full-stack development.

---

## SOLID Principles

### Single Responsibility

Each module, class, or function has one purpose.

```typescript
// ❌ Bad
class UserManager {
  createUser(data) { }
  sendEmail(to, body) { }
  logActivity(action) { }
}

// ✅ Good
class UserService {
  createUser(data: CreateUserDto): Promise<User> { }
}

class EmailService {
  sendEmail(to: string, body: string): Promise<void> { }
}

class AuditLogger {
  logActivity(action: string): Promise<void> { }
}
```

### Open/Closed

Open for extension, closed for modification.

```typescript
// ✅ Good: Use interfaces
interface PaymentProcessor {
  processPayment(amount: number): Promise<PaymentResult>;
}

class StripeProcessor implements PaymentProcessor {
  async processPayment(amount: number) { /* Stripe */ }
}

class PayPalProcessor implements PaymentProcessor {
  async processPayment(amount: number) { /* PayPal */ }
}

// Adding new processor doesn't modify existing code
class SquareProcessor implements PaymentProcessor {
  async processPayment(amount: number) { /* Square */ }
}
```

### Dependency Inversion

Depend on abstractions, not concretions.

```typescript
// ✅ Good: Inject dependencies
class CheckoutService {
  constructor(private paymentProcessor: PaymentProcessor) {}

  async checkout(order: Order) {
    await this.paymentProcessor.processPayment(order.total);
  }
}
```

---

## TypeScript Best Practices

### Strict Configuration

```json
{
  "compilerOptions": {
    "strict": true,
    "strictNullChecks": true,
    "noImplicitAny": true,
    "strictFunctionTypes": true
  }
}
```

### Explicit Types

```typescript
// ✅ Good
interface User {
  id: string;
  email: string;
  name: string | null;
}

async function getUser(id: string): Promise<User | null> {
  return db.user.findUnique({ where: { id } });
}

// ❌ Bad
async function getUser(id) {
  return db.user.findUnique({ where: { id } });
}
```

### Null Handling

```typescript
// ✅ Good: Handle null explicitly
function getUserName(user: User | null): string {
  if (!user) return 'Guest';
  return user.name ?? 'Unknown';
}

// ✅ Good: Optional chaining
const email = user?.profile?.email?.toLowerCase() ?? 'no-email';

// ❌ Bad: Unsafe access
const email = user.profile.email.toLowerCase();
```

### Type Guards

```typescript
// ✅ Good: Custom type guards
function isAdmin(user: User): user is AdminUser {
  return user.role === 'admin';
}

if (isAdmin(user)) {
  user.adminPrivileges; // TypeScript knows type
}
```

### Utility Types

```typescript
interface User {
  id: string;
  email: string;
  password: string;
}

// Omit sensitive fields
type PublicUser = Omit<User, 'password'>;

// Make optional
type PartialUser = Partial<User>;

// Pick specific fields
type Credentials = Pick<User, 'email' | 'password'>;
```

---

## API Design

### RESTful Conventions

```typescript
// Resources: plural nouns, kebab-case
GET /users
GET /users/:id
POST /users
PUT /users/:id
PATCH /users/:id
DELETE /users/:id

// Nested resources
GET /users/:id/posts
GET /workspaces/:id/members
```

### Response Format

```typescript
// Success
{
  "success": true,
  "data": { ... },
  "meta": { "page": 1, "limit": 20, "total": 150 }
}

// Error
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": { "email": "Invalid format" }
  }
}
```

### Status Codes

| Code | Usage |
|------|-------|
| 200 | Successful GET, PUT, PATCH, DELETE |
| 201 | Successful POST (created) |
| 400 | Invalid input |
| 401 | Not authenticated |
| 403 | Not authorized |
| 404 | Not found |
| 422 | Validation errors |
| 500 | Server error |

---

## Error Handling

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

export class ValidationError extends AppError {
  constructor(message: string, details?: Record<string, unknown>) {
    super(message, 422, 'VALIDATION_ERROR', details);
  }
}

export class NotFoundError extends AppError {
  constructor(resource: string, id: string) {
    super(`${resource} with id ${id} not found`, 404, 'NOT_FOUND');
  }
}
```

### Usage

```typescript
async function getUserById(id: string): Promise<User> {
  const user = await db.user.findUnique({ where: { id } });
  if (!user) {
    throw new NotFoundError('User', id);
  }
  return user;
}
```

---

## Database Guidelines

### Query Optimization

```typescript
// ✅ Good: Select only needed fields
const user = await db.user.findUnique({
  where: { id },
  select: { id: true, email: true, name: true }
});

// ✅ Good: Batch operations
await db.post.createMany({
  data: users.map(user => ({ userId: user.id }))
});

// ❌ Bad: N+1 queries
for (const user of users) {
  await db.post.create({ data: { userId: user.id } });
}
```

### Multi-Tenancy

```typescript
// ✅ CRITICAL: Always filter by organization
async function getProjects(orgId: string) {
  return db.project.findMany({
    where: { organizationId: orgId }
  });
}

// ❌ DANGEROUS: Missing tenant filter
async function getAllProjects() {
  return db.project.findMany(); // Exposes all tenants!
}
```

---

## Code Quality

### Commits

Use conventional commits:
```
feat: add user profile page
fix: resolve null pointer in auth
refactor: simplify payment logic
test: add integration tests
docs: update API documentation
```

### Documentation

```typescript
// ✅ Good: Explain "why"
// Cache permissions for 5 minutes to reduce DB load
// during high-traffic. Eventual consistency is acceptable.
const permissions = await cache.get(`user:${id}:perms`);

// ❌ Bad: States the obvious
// Get user permissions
const permissions = await getUserPermissions(id);
```

### JSDoc for Public APIs

```typescript
/**
 * Creates a new user account.
 *
 * @param dto - User creation data
 * @param workspaceId - Target workspace
 * @returns Created user (without password)
 * @throws {ValidationError} If input invalid
 * @throws {ConflictError} If email exists
 */
export async function createUser(
  dto: CreateUserDto,
  workspaceId: string
): Promise<PublicUser> {
  // ...
}
```
