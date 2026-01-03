# Security Standards

Security best practices for SaaS applications.

---

## Authentication

### Password Requirements

```typescript
// Minimum requirements
const passwordSchema = z.string()
  .min(8, 'At least 8 characters')
  .regex(/[A-Z]/, 'At least one uppercase')
  .regex(/[0-9]/, 'At least one number');
```

### Password Storage

```typescript
// ✅ Always hash passwords
import bcrypt from 'bcrypt';

const hash = await bcrypt.hash(password, 12);
const valid = await bcrypt.compare(password, hash);

// ❌ Never store plaintext
user.password = password;
```

### Session Management

```typescript
// Secure session cookies
{
  httpOnly: true,      // No JavaScript access
  secure: true,        // HTTPS only
  sameSite: 'strict',  // CSRF protection
  maxAge: 7 * 24 * 60 * 60 * 1000  // 7 days
}
```

---

## Authorization

### Multi-Tenancy Isolation

```typescript
// ✅ CRITICAL: Always scope by organization
async function getProjects(orgId: string) {
  return db.project.findMany({
    where: { organizationId: orgId }
  });
}

// ❌ DANGEROUS: Exposes all data
async function getAllProjects() {
  return db.project.findMany();
}
```

### Role-Based Access

```typescript
// Define roles
enum Role {
  ADMIN = 'admin',
  MEMBER = 'member',
  VIEWER = 'viewer'
}

// Check permissions
@UseGuards(RolesGuard)
@Roles(Role.ADMIN)
@Delete(':id')
async deleteProject(@Param('id') id: string) {
  // Only admins can delete
}
```

### Resource Ownership

```typescript
// Verify ownership before actions
async function updateProject(userId: string, projectId: string, data: any) {
  const project = await db.project.findUnique({
    where: { id: projectId }
  });

  // Check user can access this project
  const membership = await db.projectMember.findFirst({
    where: {
      projectId,
      userId,
      role: { in: ['owner', 'editor'] }
    }
  });

  if (!membership) {
    throw new ForbiddenError('Not authorized');
  }

  return db.project.update({ where: { id: projectId }, data });
}
```

---

## Input Validation

### All Inputs Must Be Validated

```typescript
import { z } from 'zod';

const createUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2).max(100),
  password: z.string().min(8),
});

// Validate before processing
const data = createUserSchema.parse(req.body);
```

### SQL Injection Prevention

```typescript
// ✅ Good: Parameterized queries
const user = await db.user.findUnique({
  where: { id: userId }  // Parameterized
});

// ✅ Good: ORM methods
await db.$queryRaw`
  SELECT * FROM users WHERE id = ${userId}
`;

// ❌ Bad: String concatenation
await db.$queryRawUnsafe(
  `SELECT * FROM users WHERE id = '${userId}'`
);
```

### XSS Prevention

```typescript
// ✅ Good: React auto-escapes
<div>{userInput}</div>

// ⚠️ Careful: dangerouslySetInnerHTML
<div dangerouslySetInnerHTML={{ __html: sanitize(content) }} />

// ✅ Good: Sanitize if needed
import DOMPurify from 'dompurify';
const clean = DOMPurify.sanitize(dirty);
```

---

## Secrets Management

### Never Commit Secrets

```gitignore
# .gitignore
.env
.env.local
*.pem
*.key
credentials.json
```

### Environment Variables

```typescript
// ✅ Good: Use environment variables
const secret = process.env.AUTH_SECRET;

if (!secret) {
  throw new Error('AUTH_SECRET not configured');
}

// ❌ Bad: Hardcoded secrets
const secret = 'my-secret-key-12345';
```

### Secure Generation

```bash
# Generate secure secrets
openssl rand -base64 32
```

---

## HTTPS & Transport

### Force HTTPS

```typescript
// Production: redirect HTTP to HTTPS
if (process.env.NODE_ENV === 'production') {
  app.use((req, res, next) => {
    if (req.headers['x-forwarded-proto'] !== 'https') {
      return res.redirect(`https://${req.headers.host}${req.url}`);
    }
    next();
  });
}
```

### Secure Headers

```typescript
import helmet from 'helmet';

app.use(helmet({
  contentSecurityPolicy: true,
  crossOriginEmbedderPolicy: true,
  crossOriginOpenerPolicy: true,
  crossOriginResourcePolicy: true,
  dnsPrefetchControl: true,
  frameguard: true,
  hidePoweredBy: true,
  hsts: true,
  ieNoOpen: true,
  noSniff: true,
  referrerPolicy: true,
  xssFilter: true,
}));
```

---

## Rate Limiting

```typescript
import rateLimit from 'express-rate-limit';

// General rate limit
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // 100 requests per window
});

// Stricter for auth endpoints
const authLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1 hour
  max: 10, // 10 attempts per hour
  message: 'Too many attempts, try again later',
});

app.use('/api/', limiter);
app.use('/api/auth/', authLimiter);
```

---

## CORS Configuration

```typescript
// ✅ Good: Specific origins
app.use(cors({
  origin: [
    'https://app.example.com',
    'https://admin.example.com',
  ],
  credentials: true,
}));

// ❌ Bad: Allow all origins
app.use(cors({ origin: '*' }));
```

---

## Audit Logging

### Log Security Events

```typescript
// Events to log
await auditLog.create({
  organizationId,
  userId,
  action: 'USER_ROLE_CHANGED',
  resourceType: 'User',
  resourceId: targetUserId,
  details: { oldRole, newRole },
  ipAddress: req.ip,
  userAgent: req.headers['user-agent'],
});
```

### What to Log

| Event | Priority |
|-------|----------|
| Login attempts (success/fail) | Critical |
| Role changes | Critical |
| Data exports | Critical |
| API key creation | High |
| Password changes | High |
| Settings changes | Medium |
| CRUD operations | Low |

---

## Security Checklist

Before deploying:

- [ ] All inputs validated
- [ ] Authentication required for protected routes
- [ ] Authorization checks on all operations
- [ ] SQL injection prevented (parameterized queries)
- [ ] XSS prevented (sanitized outputs)
- [ ] CSRF protection enabled
- [ ] Rate limiting configured
- [ ] Secrets not in code
- [ ] HTTPS enforced
- [ ] Secure headers set
- [ ] Multi-tenancy isolation enforced
- [ ] Audit logging for sensitive operations
- [ ] Dependencies updated (no known vulnerabilities)
