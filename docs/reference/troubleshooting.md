# Troubleshooting

Common issues and their solutions when working with Mavric DevEnv.

---

## Setup Issues

### PostgreSQL Connection Failed

**Symptom**: Backend fails to start with database connection error.

```
Error: connect ECONNREFUSED 127.0.0.1:5432
```

**Solutions**:

1. **Check if PostgreSQL is running**:
   ```bash
   docker ps | grep postgres
   ```

2. **Start PostgreSQL container**:
   ```bash
   docker compose up -d postgres
   ```

3. **Verify connection string**:
   ```bash
   # Check .env file
   cat backend/.env | grep DATABASE_URL

   # Should be:
   DATABASE_URL=postgresql://postgres:postgres@localhost:5432/myapp
   ```

4. **Check port availability**:
   ```bash
   lsof -i :5432
   ```

---

### Port Already in Use

**Symptom**: Server fails to start because port is occupied.

```
Error: listen EADDRINUSE: address already in use :::3001
```

**Solutions**:

1. **Find process using the port**:
   ```bash
   lsof -i :3001
   ```

2. **Kill the process**:
   ```bash
   kill -9 <PID>
   ```

3. **Or use a different port**:
   ```bash
   # In backend/.env
   PORT=3002
   ```

---

### Missing Dependencies

**Symptom**: Module not found errors.

```
Error: Cannot find module '@nestjs/common'
```

**Solutions**:

1. **Install dependencies**:
   ```bash
   cd backend && npm install
   cd frontend && npm install
   ```

2. **Clear node_modules and reinstall**:
   ```bash
   rm -rf node_modules package-lock.json
   npm install
   ```

---

## Authentication Issues

### AUTH_SECRET Not Configured

**Symptom**: Auth fails with secret error.

```
Error: AUTH_SECRET environment variable is required
```

**Solution**:

Generate a secure secret and add to `.env`:

```bash
# Generate secret
openssl rand -base64 32

# Add to backend/.env
AUTH_SECRET=your-generated-secret-here
```

---

### Session Not Persisting

**Symptom**: User gets logged out unexpectedly.

**Solutions**:

1. **Check cookie settings**:
   ```typescript
   // Ensure secure settings match environment
   {
     httpOnly: true,
     secure: process.env.NODE_ENV === 'production',
     sameSite: 'lax',
   }
   ```

2. **Verify CORS credentials**:
   ```typescript
   app.use(cors({
     origin: 'http://localhost:3000',
     credentials: true,  // Required for cookies
   }));
   ```

3. **Check frontend fetch calls**:
   ```typescript
   fetch('/api/auth/session', {
     credentials: 'include',  // Required
   });
   ```

---

### CORS Errors

**Symptom**: Browser blocks API requests.

```
Access to fetch at 'http://localhost:3001' from origin 'http://localhost:3000' has been blocked by CORS policy
```

**Solution**:

Configure CORS in backend:

```typescript
// main.ts
app.enableCors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  credentials: true,
});
```

---

## Apso Issues

### Scaffold Command Fails

**Symptom**: `apso scaffold` exits with error.

**Solutions**:

1. **Validate .apsorc syntax**:
   ```bash
   cat .apsorc | jq .
   ```

2. **Check entity names**:
   - Must be PascalCase
   - No reserved words
   - No special characters

3. **Verify field types**:
   ```json
   {
     "fields": {
       "name": "string",      // Valid
       "count": "number",     // Valid
       "active": "boolean",   // Valid
       "data": "object"       // Invalid - use json
     }
   }
   ```

---

### DTO Import Errors

**Symptom**: TypeScript errors about missing DTO exports.

```
Module '"./dtos"' has no exported member 'CreateProjectDto'
```

**Solution**:

Run the DTO fix script:

```bash
node scripts/fix-dto-imports.js
```

Or manually check `autogen/Entity/dtos/index.ts` exports.

---

### Entity Relationship Errors

**Symptom**: Foreign key constraint failures.

**Solutions**:

1. **Check relationship definitions in .apsorc**:
   ```json
   {
     "relationships": {
       "organization": {
         "type": "many-to-one",
         "target": "Organization",
         "required": true
       }
     }
   }
   ```

2. **Ensure referenced entities exist**:
   ```bash
   # Check if Organization entity is defined
   grep -l "Organization" .apsorc
   ```

3. **Run migrations**:
   ```bash
   npm run typeorm migration:run
   ```

---

## Database Issues

### Migration Failures

**Symptom**: Database schema doesn't match entities.

**Solutions**:

1. **Generate new migration**:
   ```bash
   npm run typeorm migration:generate -- -n UpdateSchema
   ```

2. **Run pending migrations**:
   ```bash
   npm run typeorm migration:run
   ```

3. **Reset database (development only)**:
   ```bash
   npm run typeorm schema:drop
   npm run typeorm migration:run
   ```

---

### Duplicate Key Errors

**Symptom**: Insert fails with unique constraint violation.

```
Error: duplicate key value violates unique constraint
```

**Solutions**:

1. **Check for existing data**:
   ```sql
   SELECT * FROM users WHERE email = 'test@example.com';
   ```

2. **Handle in code**:
   ```typescript
   try {
     await this.userRepo.save(user);
   } catch (error) {
     if (error.code === '23505') {
       throw new ConflictError('Email already exists');
     }
     throw error;
   }
   ```

---

## Frontend Issues

### Hydration Mismatch

**Symptom**: React hydration error in Next.js.

```
Error: Hydration failed because the initial UI does not match
```

**Solutions**:

1. **Use client components for dynamic content**:
   ```typescript
   'use client';

   export function DynamicComponent() {
     const [mounted, setMounted] = useState(false);

     useEffect(() => {
       setMounted(true);
     }, []);

     if (!mounted) return null;

     return <div>{/* dynamic content */}</div>;
   }
   ```

2. **Suppress hydration warning (last resort)**:
   ```typescript
   <div suppressHydrationWarning>
     {typeof window !== 'undefined' && <DynamicContent />}
   </div>
   ```

---

### API Fetch Failures

**Symptom**: API calls fail in production but work locally.

**Solutions**:

1. **Check environment variables**:
   ```bash
   # Verify NEXT_PUBLIC_ prefix for client-side vars
   NEXT_PUBLIC_API_URL=https://api.example.com
   ```

2. **Use absolute URLs in server components**:
   ```typescript
   const res = await fetch(`${process.env.API_URL}/users`);
   ```

---

## Testing Issues

### Step Definition Not Found

**Symptom**: Cucumber can't find step implementation.

```
Step "I am logged in" is not defined
```

**Solution**:

Ensure step definition exists and matches:

```typescript
// step-definitions/common/auth.steps.ts
import { Given } from '@cucumber/cucumber';

Given('I am logged in', async function() {
  // Implementation
});
```

---

### Test Database Conflicts

**Symptom**: Tests fail due to data from other tests.

**Solutions**:

1. **Use test database**:
   ```bash
   # .env.test
   DATABASE_URL=postgresql://postgres:postgres@localhost:5432/myapp_test
   ```

2. **Clean database between tests**:
   ```typescript
   beforeEach(async () => {
     await db.query('TRUNCATE users, projects CASCADE');
   });
   ```

---

## Performance Issues

### Slow API Responses

**Solutions**:

1. **Add database indexes**:
   ```typescript
   @Entity()
   @Index(['organizationId', 'status'])
   export class Project {
     // ...
   }
   ```

2. **Select only needed fields**:
   ```typescript
   const users = await this.userRepo.find({
     select: ['id', 'name', 'email'],
   });
   ```

3. **Use pagination**:
   ```typescript
   const users = await this.userRepo.find({
     skip: (page - 1) * limit,
     take: limit,
   });
   ```

---

### N+1 Query Problem

**Symptom**: Many database queries for related data.

**Solution**:

Use eager loading:

```typescript
// Instead of loading relations separately
const projects = await this.projectRepo.find({
  relations: ['members', 'tasks'],
});
```

---

## Getting Help

If you can't resolve an issue:

1. **Check logs**:
   ```bash
   # Backend logs
   npm run start:dev 2>&1 | tee backend.log

   # Docker logs
   docker compose logs -f postgres
   ```

2. **Enable debug mode**:
   ```bash
   DEBUG=* npm run start:dev
   ```

3. **Search existing issues**:
   - Check project issue tracker
   - Search error message online

4. **Provide details when asking for help**:
   - Exact error message
   - Steps to reproduce
   - Environment (OS, Node version)
   - Relevant log output
