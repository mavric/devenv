# Better Auth + Apso Troubleshooting Guide

> Complete troubleshooting reference for common authentication issues

## Table of Contents

1. [Quick Diagnosis Checklist](#quick-diagnosis-checklist)
2. [Database Issues](#database-issues)
3. [Backend API Issues](#backend-api-issues)
4. [Frontend Issues](#frontend-issues)
5. [Session & Cookie Issues](#session--cookie-issues)
6. [OAuth Issues](#oauth-issues)
7. [Multi-Tenancy Issues](#multi-tenancy-issues)
8. [Performance Issues](#performance-issues)
9. [Security Issues](#security-issues)
10. [Debugging Tools](#debugging-tools)

## Quick Diagnosis Checklist

Run through this checklist first to identify common problems:

```bash
# 1. Check backend is running
curl http://localhost:3001/health

# 2. Check database tables exist
psql -U postgres -d your_db -c "\dt public.*" | grep -E "(user|account|session|verification)"

# 3. Check auth endpoint
curl http://localhost:3003/api/auth/session

# 4. Check environment variables
node -e "console.log({
  BACKEND: process.env.NEXT_PUBLIC_BACKEND_URL,
  APP: process.env.NEXT_PUBLIC_APP_URL,
  SECRET: process.env.BETTER_AUTH_SECRET ? 'SET' : 'MISSING'
})"

# 5. Check nullable fields in database
psql -U postgres -d your_db -c "
SELECT column_name, is_nullable
FROM information_schema.columns
WHERE table_name = 'user'
AND column_name IN ('avatar_url', 'password_hash', 'oauth_provider', 'oauth_id');"
```

## Database Issues

### Issue: "null value in column violates not-null constraint"

**Error Message:**
```
error: null value in column 'avatar_url' of relation 'user' violates not-null constraint
```

**Cause:** Field not marked as nullable in entity definition

**Solution:**

1. Update entity file:
```typescript
// backend/src/autogen/User/User.entity.ts
@Column({ nullable: true })  // ← Add nullable: true
avatar_url: string;

@Column({ nullable: true })
password_hash: string;

@Column({ nullable: true })
oauth_provider: string;

@Column({ nullable: true })
oauth_id: string;
```

2. Drop and recreate database:
```bash
# Connect to PostgreSQL
psql -U postgres -d your_db

# Drop and recreate schema
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
\q

# Restart backend to recreate tables
cd backend && npm run start:dev
```

3. Verify fix:
```sql
SELECT column_name, is_nullable
FROM information_schema.columns
WHERE table_name = 'user'
AND column_name IN ('avatar_url', 'password_hash');
-- Should show 'YES' for is_nullable
```

### Issue: "relation 'Account' does not exist"

**Error Message:**
```
error: relation "Account" does not exist
```

**Cause:** Better Auth expects lowercase table names

**Solution:**

1. Check .apsorc file - entities should be:
   - `User` (PascalCase)
   - `account` (lowercase)
   - `session` (lowercase)
   - `verification` (lowercase)

2. Rename business entities that conflict:
```json
// .apsorc
{
  "entities": {
    "Organization": {  // Renamed from "Account"
      // ...
    },
    "DiscoverySession": {  // Renamed from "Session"
      // ...
    }
  }
}
```

3. Regenerate backend:
```bash
cd backend
npx apso generate
npm run start:dev
```

### Issue: "duplicate key value violates unique constraint"

**Error Message:**
```
error: duplicate key value violates unique constraint "UQ_email"
```

**Cause:** Trying to create user with existing email

**Solution:**

1. Check for existing user:
```sql
SELECT id, email FROM "user" WHERE email = 'test@example.com';
```

2. Handle in application:
```typescript
try {
  await signUp.email({ email, password, name });
} catch (error) {
  if (error.message.includes('duplicate')) {
    toast.error('An account with this email already exists');
  }
}
```

3. Add proper validation:
```typescript
// Check if user exists before signup
const existing = await fetch(`/api/users/check?email=${email}`);
if (existing.ok) {
  setError('Email already registered');
  return;
}
```

## Backend API Issues

### Issue: "Cannot POST /Users - DTO validation failed"

**Error Message:**
```
{
  "statusCode": 400,
  "message": "Validation failed",
  "error": "Bad Request"
}
```

**Cause:** Missing `id` field in Create DTO

**Solution:**

1. Add `id` to DTO:
```typescript
// backend/src/autogen/User/dtos/User.dto.ts
export class UserCreate {
  @ApiProperty()
  @IsUUID()
  id: string;  // ← Add this

  @ApiProperty()
  @IsEmail()
  email: string;

  // ... rest of fields
}
```

2. Do the same for account DTO:
```typescript
// backend/src/autogen/account/dtos/account.dto.ts
export class accountCreate {
  @ApiProperty()
  @IsUUID()
  id: string;  // ← Add this

  // ... rest
}
```

3. Restart backend:
```bash
cd backend && npm run start:dev
```

### Issue: "CORS blocked"

**Error Message:**
```
Access to fetch at 'http://localhost:3001' from origin 'http://localhost:3003' has been blocked by CORS policy
```

**Solution:**

1. Enable CORS in backend:
```typescript
// backend/src/main.ts
async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.enableCors({
    origin: [
      'http://localhost:3000',
      'http://localhost:3003',
      process.env.FRONTEND_URL,
    ],
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  });

  await app.listen(3001);
}
```

2. Check Better Auth trusted origins:
```typescript
// frontend/lib/auth.ts
export const auth = betterAuth({
  trustedOrigins: [
    'http://localhost:3000',
    'http://localhost:3001',
    'http://localhost:3003',
    process.env.NEXT_PUBLIC_APP_URL,
  ],
});
```

### Issue: "404 Not Found on auth endpoints"

**Cause:** API route not configured correctly

**Solution:**

1. Verify file structure:
```
frontend/app/api/auth/[...all]/route.ts
```

2. Check route handler:
```typescript
// app/api/auth/[...all]/route.ts
import { auth } from '@/lib/auth';
import { toNextJsHandler } from 'better-auth/next-js';

export const { GET, POST } = toNextJsHandler(auth);
```

3. Test directly:
```bash
curl -X POST http://localhost:3003/api/auth/sign-up/email \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"Test123!","name":"Test"}'
```

## Frontend Issues

### Issue: "useSession is not a function"

**Error Message:**
```
TypeError: useSession is not a function
```

**Cause:** Incorrect import or client not created properly

**Solution:**

1. Check auth-client creation:
```typescript
// lib/auth-client.ts
import { createAuthClient } from 'better-auth/react';

export const authClient = createAuthClient({
  baseURL: process.env.NEXT_PUBLIC_APP_URL || 'http://localhost:3003',
});

export const { useSession } = authClient;
```

2. Use correct import:
```typescript
// In component
import { useSession } from '@/lib/auth-client';
```

### Issue: "Hydration mismatch"

**Error Message:**
```
Error: Hydration failed because the initial UI does not match what was rendered on the server
```

**Cause:** Session state different on server and client

**Solution:**

1. Use proper session loading:
```typescript
'use client';

export function UserProfile() {
  const { data: session, isPending } = useSession();

  if (isPending) {
    return <div>Loading...</div>;
  }

  if (!session) {
    return <div>Not logged in</div>;
  }

  return <div>Welcome, {session.user.name}</div>;
}
```

2. For server components:
```typescript
// Server component
import { getServerSession } from '@/lib/auth';
import { headers } from 'next/headers';

export default async function Page() {
  const session = await getServerSession();

  if (!session) {
    return <div>Not logged in</div>;
  }

  return <div>Welcome, {session.user.name}</div>;
}
```

### Issue: "Cannot read properties of undefined"

**Error Message:**
```
TypeError: Cannot read properties of undefined (reading 'user')
```

**Cause:** Accessing session before it's loaded

**Solution:**

1. Add null checks:
```typescript
const session = useSession();
const userName = session?.data?.user?.name || 'Guest';
```

2. Use loading states:
```typescript
const { data: session, isPending, error } = useSession();

if (isPending) return <Skeleton />;
if (error) return <ErrorMessage />;
if (!session) return <SignInPrompt />;

return <UserDashboard user={session.user} />;
```

## Session & Cookie Issues

### Issue: "Session not persisting after login"

**Symptoms:**
- User logs in successfully
- Redirect to dashboard shows not authenticated
- Cookie not being set

**Solution:**

1. Check cookie configuration:
```typescript
// frontend/lib/auth.ts
export const auth = betterAuth({
  advanced: {
    cookiePrefix: 'auth',
    useSecureCookies: false,  // false for localhost
    sameSite: 'lax',
  },
});
```

2. Verify cookie in browser:
```javascript
// Browser console
document.cookie
// Should show: auth-session=...
```

3. Check middleware:
```typescript
// middleware.ts
export async function middleware(request: NextRequest) {
  const session = await auth.api.getSession({
    headers: request.headers,
  });

  console.log('Session in middleware:', session);
  // Debug session issues
}
```

### Issue: "Invalid session token"

**Error Message:**
```
error: Invalid session token
```

**Cause:** Session expired or token mismatch

**Solution:**

1. Clear cookies and retry:
```javascript
// Browser console
document.cookie.split(";").forEach(c => {
  document.cookie = c.replace(/^ +/, "").replace(/=.*/,
    "=;expires=" + new Date().toUTCString() + ";path=/");
});
```

2. Check session expiry:
```typescript
// lib/auth.ts
session: {
  expiresIn: 60 * 60 * 24 * 7,  // 7 days
  updateAge: 60 * 60 * 24,       // Update if older than 1 day
}
```

3. Implement session refresh:
```typescript
// In your app
useEffect(() => {
  const interval = setInterval(async () => {
    await authClient.session.refresh();
  }, 60 * 60 * 1000); // Refresh every hour

  return () => clearInterval(interval);
}, []);
```

## OAuth Issues

### Issue: "OAuth callback URL mismatch"

**Error Message:**
```
Error 400: redirect_uri_mismatch
```

**Cause:** Callback URL not registered with OAuth provider

**Solution:**

1. For Google:
   - Go to Google Cloud Console
   - Add authorized redirect URI:
     ```
     http://localhost:3003/api/auth/callback/google
     https://yourdomain.com/api/auth/callback/google
     ```

2. For GitHub:
   - Go to GitHub OAuth App settings
   - Set Authorization callback URL:
     ```
     http://localhost:3003/api/auth/callback/github
     ```

3. Update auth config:
```typescript
socialProviders: {
  google: {
    clientId: process.env.GOOGLE_CLIENT_ID,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    callbackURL: '/api/auth/callback/google',  // Relative URL
  },
}
```

### Issue: "OAuth user creation fails"

**Error Message:**
```
Failed to create user from OAuth profile
```

**Cause:** Missing or null OAuth fields

**Solution:**

1. Handle missing OAuth data:
```typescript
// In auth hooks
const name = oauthProfile.name || oauthProfile.email.split('@')[0];
const avatar = oauthProfile.picture || null;
```

2. Ensure nullable fields:
```typescript
// User entity
@Column({ nullable: true })
avatar_url: string;

@Column({ nullable: true })
oauth_provider: string;

@Column({ nullable: true })
oauth_id: string;
```

## Multi-Tenancy Issues

### Issue: "Organization not created on signup"

**Symptoms:**
- User created successfully
- No organization exists
- Dashboard shows no organization

**Solution:**

1. Check hook execution:
```typescript
// lib/auth.ts
hooks: {
  after: [
    {
      matcher: (ctx) => {
        console.log('Hook matcher:', ctx.path, ctx.method);
        return ctx.path === '/sign-up/email' && ctx.method === 'POST';
      },
      handler: async (ctx) => {
        console.log('Hook handler executing');
        // Create organization logic
      },
    },
  ],
}
```

2. Alternative: Use server action:
```typescript
// app/actions/auth.ts
'use server';

export async function createOrganizationForUser(userId: string) {
  // Create organization after signup
  const org = await createOrganization({
    name: user.name,
    billing_email: user.email,
  });

  await linkUserToOrganization(userId, org.id);
}
```

3. Call after signup:
```typescript
// In SignUpForm
const result = await signUp.email({ email, password, name });
if (result.data?.user) {
  await createOrganizationForUser(result.data.user.id);
}
```

### Issue: "Cannot switch organizations"

**Cause:** Session not updating with new organization context

**Solution:**

1. Implement organization switching:
```typescript
// api/organizations/switch/route.ts
export async function POST(request: Request) {
  const { organizationId } = await request.json();
  const session = await getServerSession();

  // Verify user has access
  const access = await checkOrganizationAccess(session.user.id, organizationId);
  if (!access) {
    return new Response('Forbidden', { status: 403 });
  }

  // Update session context
  cookies().set('current-org', organizationId);

  return new Response('OK');
}
```

2. Read organization in middleware:
```typescript
// middleware.ts
const currentOrg = request.cookies.get('current-org')?.value;
// Add to request context
```

## Performance Issues

### Issue: "Slow authentication requests"

**Symptoms:**
- Login takes > 2 seconds
- Signup times out
- Session checks are slow

**Solution:**

1. Add database indexes:
```sql
-- Add indexes for common queries
CREATE INDEX idx_user_email ON "user"(email);
CREATE INDEX idx_session_token ON session(sessionToken);
CREATE INDEX idx_session_user ON session(userId);
CREATE INDEX idx_account_user ON account(userId);
```

2. Enable connection pooling:
```typescript
// Backend database config
{
  type: 'postgres',
  // ... other config
  extra: {
    max: 20,  // Connection pool size
    connectionTimeoutMillis: 2000,
  },
}
```

3. Add caching:
```typescript
// Cache session checks
const sessionCache = new Map();

export async function getCachedSession(token: string) {
  if (sessionCache.has(token)) {
    const cached = sessionCache.get(token);
    if (cached.expires > Date.now()) {
      return cached.session;
    }
  }

  const session = await fetchSession(token);
  sessionCache.set(token, {
    session,
    expires: Date.now() + 60000, // 1 minute cache
  });

  return session;
}
```

### Issue: "Database connection exhausted"

**Error Message:**
```
error: remaining connection slots are reserved for non-replication superuser connections
```

**Solution:**

1. Reduce connection pool size:
```typescript
// TypeORM config
{
  extra: {
    max: 10,  // Reduce from 20
  },
}
```

2. Close connections properly:
```typescript
// In API routes
finally {
  await connection.close();
}
```

3. Use connection pooling service:
   - PgBouncer
   - AWS RDS Proxy
   - Supabase connection pooling

## Security Issues

### Issue: "CSRF token mismatch"

**Error Message:**
```
error: CSRF token validation failed
```

**Solution:**

1. Enable CSRF protection:
```typescript
// lib/auth.ts
export const auth = betterAuth({
  security: {
    csrf: {
      enabled: true,
      cookieName: 'csrf-token',
    },
  },
});
```

2. Include token in requests:
```typescript
// In frontend
const csrfToken = cookies().get('csrf-token');

fetch('/api/auth/sign-in', {
  headers: {
    'X-CSRF-Token': csrfToken,
  },
});
```

### Issue: "Brute force attacks"

**Symptoms:**
- Many failed login attempts
- Same IP trying different passwords

**Solution:**

1. Add rate limiting:
```typescript
// middleware.ts
import { rateLimit } from '@/lib/rate-limit';

const limiter = rateLimit({
  interval: 60 * 1000, // 1 minute
  uniqueTokenPerInterval: 500,
});

export async function middleware(request: NextRequest) {
  if (request.nextUrl.pathname.startsWith('/api/auth')) {
    try {
      await limiter.check(request, 10, 'CACHE_TOKEN');
    } catch {
      return new Response('Too Many Requests', { status: 429 });
    }
  }
}
```

2. Implement account lockout:
```typescript
// Track failed attempts
const failedAttempts = new Map();

export async function trackFailedLogin(email: string) {
  const attempts = failedAttempts.get(email) || 0;
  failedAttempts.set(email, attempts + 1);

  if (attempts >= 5) {
    await lockAccount(email);
    return true;
  }
  return false;
}
```

## Debugging Tools

### Browser DevTools

1. **Check cookies:**
```javascript
// Console
console.table(document.cookie.split(';').map(c => {
  const [key, value] = c.trim().split('=');
  return { key, value: value?.substring(0, 20) + '...' };
}));
```

2. **Monitor network requests:**
```javascript
// Intercept auth requests
const originalFetch = window.fetch;
window.fetch = function(...args) {
  if (args[0].includes('/auth')) {
    console.log('Auth request:', args);
  }
  return originalFetch.apply(this, args);
};
```

### Database Queries

```sql
-- Check user creation
SELECT id, email, created_at
FROM "user"
ORDER BY created_at DESC
LIMIT 5;

-- Check active sessions
SELECT s.id, s."userId", u.email, s."expiresAt"
FROM session s
JOIN "user" u ON s."userId" = u.id
WHERE s."expiresAt" > NOW();

-- Check OAuth accounts
SELECT a.id, a."providerId", u.email
FROM account a
JOIN "user" u ON a."userId" = u.id;

-- Check failed constraints
SELECT conname, contype, conrelid::regclass
FROM pg_constraint
WHERE contype = 'c'
AND conrelid = 'public.user'::regclass;
```

### Logging

```typescript
// Add debug logging
export const auth = betterAuth({
  // ... config
  logger: {
    level: 'debug',
    handler: (level, message, data) => {
      console.log(`[${level}] ${message}`, data);
    },
  },
});
```

### Testing Authentication

```bash
# Test signup
curl -X POST http://localhost:3003/api/auth/sign-up/email \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "TestPassword123!",
    "name": "Test User"
  }' \
  -c cookies.txt \
  -v

# Test signin with cookies
curl -X POST http://localhost:3003/api/auth/sign-in/email \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "TestPassword123!"
  }' \
  -c cookies.txt \
  -v

# Test session
curl http://localhost:3003/api/auth/session \
  -b cookies.txt \
  -v

# Test protected route
curl http://localhost:3003/api/protected \
  -b cookies.txt \
  -v
```

## Common Error Patterns

| Error | Likely Cause | Quick Fix |
|-------|--------------|-----------|
| "null value violates not-null" | Entity field not nullable | Add `nullable: true` to column |
| "relation does not exist" | Wrong entity name case | Use lowercase for auth entities |
| "DTO validation failed" | Missing id in Create DTO | Add id field to DTO |
| "CORS blocked" | CORS not configured | Enable CORS in backend |
| "Session not persisting" | Cookie configuration | Check cookie settings |
| "OAuth callback mismatch" | Wrong callback URL | Update OAuth provider settings |
| "Invalid session token" | Expired or wrong token | Clear cookies and re-login |
| "Organization not created" | Hook not executing | Use server action instead |
| "Too Many Requests" | Rate limit hit | Wait or increase limits |
| "Connection slots exhausted" | Too many DB connections | Reduce pool size |

## Getting Help

If issues persist after trying these solutions:

1. Check Better Auth documentation: https://better-auth.com
2. Check Apso documentation: https://apso.dev
3. Enable debug logging and collect logs
4. Create minimal reproduction
5. Check GitHub issues for similar problems

Remember to always:
- Test in incognito/private browsing to avoid cookie conflicts
- Clear browser cache when debugging frontend issues
- Check all environment variables are set correctly
- Verify database schema matches entity definitions
- Keep Better Auth and dependencies updated