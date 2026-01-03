# Common Backend + BetterAuth Issues & Solutions

## Database Issues

### Issue: "null value in column 'avatar_url' violates not-null constraint"

**Cause:** User entity fields not marked as nullable for OAuth compatibility

**Solution:**
```bash
# Run the fix script
bash references/fix-scripts/fix-nullable-fields.sh

# Reset database
psql -U postgres -d backend_dev << EOF
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
EOF

# Restart backend
npm run start:dev
```

**Manual Fix:**
```typescript
// backend/src/autogen/User/User.entity.ts
@Column({ nullable: true })  // Add nullable: true
avatar_url: string;

@Column({ nullable: true })  // Add nullable: true
password_hash: string;
```

---

### Issue: "null value in column 'id' of relation 'account'"

**Cause:** Create DTOs missing `id` field

**Solution:**
```bash
# Run the fix script
bash references/fix-scripts/fix-dto-id-fields.sh
```

**Manual Fix:**
```typescript
// backend/src/autogen/User/dtos/User.dto.ts
export class UserCreate {
  @ApiProperty()
  @IsUUID()
  id: string;  // Add this field

  @ApiProperty()
  @IsEmail()
  email: string;
  // ... rest
}
```

---

### Issue: "relation 'user' does not exist"

**Cause:** Database tables not created

**Solution:**
```bash
# Start backend to run TypeORM sync
npm run start:dev

# Verify tables
psql -U postgres -d backend_dev -c "\dt"
```

**Expected Output:**
```
 Schema |      Name      | Type  |  Owner
--------+----------------+-------+----------
 public | account        | table | postgres
 public | organization   | table | postgres
 public | session        | table | postgres
 public | user           | table | postgres
 public | verification   | table | postgres
```

---

### Issue: "table 'Account' already exists but has different schema"

**Cause:** Old schema conflicts with new Better Auth schema

**Solution:**
```bash
# Complete database reset
psql -U postgres -d backend_dev << EOF
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
EOF

# Regenerate code
cd backend
apso server

# Restart
npm run start:dev
```

---

## Code Generation Issues

### Issue: "Entity 'Account' conflicts with Better Auth 'account'"

**Cause:** Business entity name conflicts with auth entity

**Solution:**
1. Rename in `.apsorc`:
```json
{
  "entities": {
    "Organization": {  // Changed from "Account"
      "description": "Multi-tenant root entity",
      // ...
    }
  }
}
```

2. Update all references:
```bash
# Find all account_id references
grep -r "account_id" backend/src/

# Update to organization_id
sed -i 's/account_id/organization_id/g' backend/.apsorc
```

3. Regenerate:
```bash
apso server
```

---

### Issue: "Module 'UserModule' not found"

**Cause:** AppModule not importing generated modules

**Solution:**
```typescript
// backend/src/app.module.ts
import { Module } from '@nestjs/common';
import { UserModule } from './autogen/User/User.module';
import { AccountModule } from './autogen/account/account.module';
import { SessionModule } from './autogen/session/session.module';
import { VerificationModule } from './autogen/Verification/Verification.module';

@Module({
  imports: [
    UserModule,
    AccountModule,
    SessionModule,
    VerificationModule,
    // ... other modules
  ],
})
export class AppModule {}
```

---

## Network & CORS Issues

### Issue: "CORS error when calling backend from frontend"

**Cause:** CORS not configured

**Solution:**
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
  });

  await app.listen(3001);
}
```

---

### Issue: "connect ECONNREFUSED 127.0.0.1:5433"

**Cause:** PostgreSQL not running

**Solution:**
```bash
# Check if Docker is running
docker ps

# Start PostgreSQL
docker-compose up -d

# Or using Docker directly
docker run -d \
  --name postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=backend_dev \
  -p 5433:5432 \
  postgres:15-alpine

# Verify connection
psql -h localhost -p 5433 -U postgres -d backend_dev -c "SELECT version();"
```

---

## Environment Issues

### Issue: "BETTER_AUTH_SECRET is not defined"

**Cause:** Missing environment variable

**Solution:**
```bash
# Generate secure secret
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Add to .env.development
echo "BETTER_AUTH_SECRET=<generated-secret>" >> .env.development
```

---

### Issue: "Port 3001 already in use"

**Cause:** Another process using the port

**Solution:**
```bash
# Find process
lsof -ti:3001

# Kill process
lsof -ti:3001 | xargs kill

# Or use different port
PORT=3002 npm run start:dev
```

---

## Validation Issues

### Issue: "Validation failed (uuid is expected)"

**Cause:** Invalid UUID format in request

**Solution:**
```typescript
// Generate valid UUID
const uuid = crypto.randomUUID();

// Or using uuidv4
import { v4 as uuidv4 } from 'uuid';
const id = uuidv4();

// In curl requests
curl -X POST http://localhost:3001/Users \
  -H "Content-Type: application/json" \
  -d "{
    \"id\": \"$(uuidgen | tr '[:upper:]' '[:lower:]')\",
    \"email\": \"test@example.com\",
    \"name\": \"Test User\"
  }"
```

---

### Issue: "email must be an email"

**Cause:** Invalid email format

**Solution:**
Ensure email field contains valid email:
```json
{
  "email": "valid.email@example.com"  // ✓
  // NOT: "notanemail"                // ✗
}
```

---

## TypeORM Issues

### Issue: "Cannot use import statement outside a module"

**Cause:** TypeScript compilation issue

**Solution:**
```bash
# Clean build
rm -rf dist/
npm run build

# Or just restart dev server
npm run start:dev
```

---

### Issue: "Entity metadata for User was not found"

**Cause:** Entity not registered in TypeORM

**Solution:**
```typescript
// backend/src/app.module.ts
import { TypeOrmModule } from '@nestjs/typeorm';

TypeOrmModule.forRoot({
  type: 'postgres',
  // ...
  entities: ['dist/**/*.entity{.ts,.js}'],
  synchronize: true,  // Only for development
})
```

---

## Testing Issues

### Issue: "Test timeout exceeded"

**Cause:** Database not ready or slow queries

**Solution:**
```typescript
// test/e2e/setup.ts
beforeAll(async () => {
  // Increase timeout
  jest.setTimeout(30000);

  // Wait for database
  await waitForDatabase();
});
```

---

### Issue: "Cannot read properties of undefined (reading 'user')"

**Cause:** Better Auth context not available

**Solution:**
Check BetterAuth configuration in frontend:
```typescript
// frontend/lib/auth.ts
export const auth = betterAuth({
  database: apsoAdapter({
    baseUrl: process.env.NEXT_PUBLIC_BACKEND_URL,
  }),
  // Ensure all required config is present
  emailAndPassword: {
    enabled: true,
  },
});
```

---

## Verification Commands

### Check All Tables
```bash
psql -U postgres -d backend_dev -c "\dt"
```

### Check User Table Structure
```bash
psql -U postgres -d backend_dev -c "\d user"
```

### Count Records
```bash
psql -U postgres -d backend_dev -c "
SELECT
  'users' as table_name, COUNT(*) as count FROM \"user\"
UNION ALL
SELECT 'accounts', COUNT(*) FROM account
UNION ALL
SELECT 'sessions', COUNT(*) FROM session
UNION ALL
SELECT 'organizations', COUNT(*) FROM organization;
"
```

### Test Health Endpoint
```bash
curl http://localhost:3001/health
```

### Test User CRUD
```bash
# Create
curl -X POST http://localhost:3001/Users \
  -H "Content-Type: application/json" \
  -d '{"id":"'$(uuidgen)'","email":"test@example.com","name":"Test"}'

# List
curl http://localhost:3001/Users

# Get by ID
curl http://localhost:3001/Users/{id}

# Delete
curl -X DELETE http://localhost:3001/Users/{id}
```

---

## Better Auth Adapter Issues

### Issue: "Login fails with 'Invalid email or password' after successful signup"

**This is the most common issue!** Users can sign up successfully, but login always fails with `INVALID_EMAIL_OR_PASSWORD`.

**Root Cause:** The `@apso/better-auth-adapter` is not correctly returning account data with the `providerId` field set. Better Auth's runtime code uses:

```typescript
// Better Auth internal code for credential validation:
user.accounts.find((a) => a.providerId === "credential")
```

If `providerId` is `undefined` or missing, login fails even with correct credentials.

**Solution:**

1. **Ensure using latest adapter version:**
   ```bash
   npm install @apso/better-auth-adapter@latest
   ```

2. **Verify account entity has `providerId` field in .apsorc:**
   ```json
   {
     "name": "account",
     "fields": [
       {
         "name": "providerId",
         "type": "text",
         "length": 50,
         "nullable": true
       }
     ]
   }
   ```

3. **Critical Architecture Points:**
   - Better Auth stores **passwords in the `account` table**, NOT the `User` table
   - The `account.password` field holds the bcrypt-hashed password
   - The `account.providerId` field must be `"credential"` for email/password auth
   - When signing in, Better Auth calls `findUserByEmail(email, { includeAccounts: true })`
   - The adapter must return user WITH populated accounts array

**Debug Checklist:**
```bash
# 1. Check account has providerId set correctly
psql -U postgres -d your_db -c "SELECT id, \"userId\", \"providerId\", password IS NOT NULL as has_password FROM account;"

# Expected: providerId = 'credential' and has_password = true

# 2. Check adapter version
npm list @apso/better-auth-adapter

# 3. Test API returns accounts with user
curl http://localhost:YOUR_PORT/accounts
```

**If providerId is NULL in database:**
- This means the adapter isn't setting it during account creation
- Update to @apso/better-auth-adapter@2.0.2 or higher
- Re-run signup to create accounts with correct providerId

---

### Issue: "Credential account not found" during signin

**Cause:** Same as above - Better Auth can't find the credential account because `providerId` is missing or incorrect.

**Solution:** See "Login fails with 'Invalid email or password'" above.

---

### Issue: "accounts.filter is not a function" or "Cannot read property 'find' of undefined"

**Cause:** The adapter's `findUserByEmail` isn't returning accounts with the user. Better Auth expects:

```typescript
{
  user: {
    id: "...",
    email: "...",
    accounts: [  // ← This array must be present!
      {
        id: "...",
        userId: "...",
        providerId: "credential",  // ← This must be set!
        password: "hashed..."
      }
    ]
  }
}
```

**Solution:**

1. Ensure backend API supports `?join=account` or similar query parameter
2. Ensure adapter handles `{ includeAccounts: true }` option in `findUserByEmail`
3. Update adapter: `npm install @apso/better-auth-adapter@latest`

---

## Getting More Help

1. **Check logs:**
   ```bash
   npm run start:dev 2>&1 | tee backend.log
   ```

2. **Enable debug mode:**
   ```bash
   LOG_LEVEL=debug npm run start:dev
   ```

3. **Run automated tests:**
   ```bash
   bash references/verification-commands/test-auth-flow.sh
   ```

4. **Consult reference docs:**
   - `/Users/matthewcullerton/projects/mavric/lightbulb-v2/docs/apso-better-auth-quickstart.md`
   - `/Users/matthewcullerton/projects/mavric/lightbulb-v2/docs/auth/COMPLETE_AUTH_INTEGRATION_GUIDE.md`
