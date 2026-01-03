# 5-Minute Apso + BetterAuth Setup

> **Goal**: Get a working backend + frontend with authentication in 5 minutes flat.
> **No decisions needed**: Just copy, paste, and run each command in order.

## Prerequisites Check (30 seconds)

Run these commands to verify prerequisites:

```bash
# Check Node.js (must be 18+)
node -v

# Check PostgreSQL is running
pg_isready

# Check Git
git --version

# Create project directory
mkdir -p ~/quickstart-apso && cd ~/quickstart-apso
```

✅ **Verification**: All commands should return version numbers or "accepting connections"

---

## Step 1: Backend Setup (2 minutes)

### 1.1 Initialize Backend (30 seconds)

```bash
# Create backend directory
mkdir backend && cd backend

# Initialize package.json
npm init -y

# Install core dependencies
npm install @nestjs/common@10.0.0 @nestjs/core@10.0.0 @nestjs/platform-express@10.0.0 @nestjs/config@3.1.1 @nestjs/typeorm@10.0.0 typeorm@0.3.20 pg@8.16.3 reflect-metadata@0.2.1 rxjs@7.8.1 class-transformer@0.5.1 class-validator@0.14.1 @apso/better-auth-adapter@2.0.0 better-auth@1.3.34

# Install dev dependencies
npm install -D @nestjs/cli@10.0.0 @types/node@18.13.0 typescript@5.0.0 ts-node@10.9.1
```

### 1.2 Create Configuration Files (30 seconds)

```bash
# Create TypeScript config
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "module": "commonjs",
    "declaration": true,
    "removeComments": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "allowSyntheticDefaultImports": true,
    "target": "ES2021",
    "sourceMap": true,
    "outDir": "./dist",
    "baseUrl": "./",
    "incremental": true,
    "skipLibCheck": true,
    "strictNullChecks": false,
    "noImplicitAny": false,
    "strictBindCallApply": false,
    "forceConsistentCasingInFileNames": false,
    "noFallthroughCasesInSwitch": false
  }
}
EOF

# Create .env file
cat > .env << 'EOF'
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
DATABASE_NAME=apso_quickstart
JWT_SECRET=quickstart_secret_change_in_production_123456789
BETTER_AUTH_URL=http://localhost:3000
BETTER_AUTH_SECRET=quickstart_auth_secret_change_in_production_987654321
PORT=3001
EOF

# Create .apsorc file
cat > .apsorc << 'EOF'
{
  "service": "quickstart-app",
  "database": {
    "provider": "postgresql",
    "multiTenant": false
  },
  "entities": {
    "User": {
      "description": "User entity for BetterAuth",
      "fields": {
        "id": {
          "type": "uuid",
          "primary": true,
          "default": "uuid_generate_v4()"
        },
        "email": {
          "type": "string",
          "unique": true,
          "required": true
        },
        "name": {
          "type": "string"
        },
        "emailVerified": {
          "type": "boolean",
          "default": false
        },
        "image": {
          "type": "string"
        },
        "createdAt": {
          "type": "timestamp",
          "default": "now()"
        },
        "updatedAt": {
          "type": "timestamp",
          "default": "now()"
        }
      }
    },
    "Session": {
      "description": "Session entity for BetterAuth",
      "fields": {
        "id": {
          "type": "uuid",
          "primary": true,
          "default": "uuid_generate_v4()"
        },
        "expiresAt": {
          "type": "timestamp",
          "required": true
        },
        "ipAddress": {
          "type": "string"
        },
        "userAgent": {
          "type": "string"
        },
        "userId": {
          "type": "uuid",
          "required": true,
          "references": {
            "entity": "User",
            "field": "id"
          }
        },
        "createdAt": {
          "type": "timestamp",
          "default": "now()"
        },
        "updatedAt": {
          "type": "timestamp",
          "default": "now()"
        }
      }
    },
    "Account": {
      "description": "Account entity for OAuth providers",
      "fields": {
        "id": {
          "type": "uuid",
          "primary": true,
          "default": "uuid_generate_v4()"
        },
        "accountId": {
          "type": "string",
          "required": true
        },
        "providerId": {
          "type": "string",
          "required": true
        },
        "userId": {
          "type": "uuid",
          "required": true,
          "references": {
            "entity": "User",
            "field": "id"
          }
        },
        "accessToken": {
          "type": "string"
        },
        "refreshToken": {
          "type": "string"
        },
        "expiresAt": {
          "type": "timestamp"
        },
        "createdAt": {
          "type": "timestamp",
          "default": "now()"
        },
        "updatedAt": {
          "type": "timestamp",
          "default": "now()"
        }
      }
    }
  }
}
EOF
```

### 1.3 Create Backend Source Files (30 seconds)

```bash
# Create source directory structure
mkdir -p src/auth src/config

# Create main.ts
cat > src/main.ts << 'EOF'
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors();
  const port = process.env.PORT || 3001;
  await app.listen(port);
  console.log(`Backend running on http://localhost:${port}`);
}
bootstrap();
EOF

# Create app.module.ts
cat > src/app.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DATABASE_HOST,
      port: parseInt(process.env.DATABASE_PORT, 10),
      username: process.env.DATABASE_USERNAME,
      password: process.env.DATABASE_PASSWORD,
      database: process.env.DATABASE_NAME,
      entities: [__dirname + '/**/*.entity{.ts,.js}'],
      synchronize: true, // Only for development
      logging: false,
    }),
    AuthModule,
  ],
})
export class AppModule {}
EOF

# Create auth module
cat > src/auth/auth.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';

@Module({
  controllers: [AuthController],
})
export class AuthModule {}
EOF

# Create auth controller
cat > src/auth/auth.controller.ts << 'EOF'
import { Controller, Get, Req, Res } from '@nestjs/common';
import { Request, Response } from 'express';

@Controller('auth')
export class AuthController {
  @Get('health')
  health() {
    return { status: 'ok', timestamp: new Date().toISOString() };
  }

  @Get('session')
  async getSession(@Req() req: Request) {
    return {
      user: req['user'] || null,
      authenticated: !!req['user'],
    };
  }
}
EOF

# Update package.json with scripts
cat > package.json << 'EOF'
{
  "name": "backend",
  "version": "1.0.0",
  "scripts": {
    "build": "nest build",
    "start": "nest start",
    "start:dev": "nest start --watch",
    "start:prod": "node dist/main"
  },
  "dependencies": {
    "@nestjs/common": "10.0.0",
    "@nestjs/core": "10.0.0",
    "@nestjs/platform-express": "10.0.0",
    "@nestjs/config": "3.1.1",
    "@nestjs/typeorm": "10.0.0",
    "typeorm": "0.3.20",
    "pg": "8.16.3",
    "reflect-metadata": "0.2.1",
    "rxjs": "7.8.1",
    "class-transformer": "0.5.1",
    "class-validator": "0.14.1",
    "@apso/better-auth-adapter": "2.0.0",
    "better-auth": "1.3.34"
  },
  "devDependencies": {
    "@nestjs/cli": "10.0.0",
    "@types/node": "18.13.0",
    "typescript": "5.0.0",
    "ts-node": "10.9.1"
  }
}
EOF
```

### 1.4 Initialize Database (30 seconds)

```bash
# Create database
PGPASSWORD=postgres psql -U postgres -h localhost -c "CREATE DATABASE apso_quickstart;"

# Verify database creation
PGPASSWORD=postgres psql -U postgres -h localhost -c "\l" | grep apso_quickstart
```

✅ **Backend Verification**:
```bash
# Test backend startup
npm run start:dev &
sleep 5
curl http://localhost:3001/auth/health
# Should return: {"status":"ok","timestamp":"..."}
```

---

## Step 2: Frontend Setup (1.5 minutes)

### 2.1 Initialize Frontend (30 seconds)

```bash
# Go back to project root
cd ~/quickstart-apso

# Create Next.js app
npx create-next-app@latest frontend --typescript --tailwind --app --no-src-dir --import-alias "@/*"

# Navigate to frontend
cd frontend

# Install BetterAuth
npm install better-auth@1.3.34 @better-auth/react@0.0.12
```

### 2.2 Configure BetterAuth (30 seconds)

```bash
# Create auth configuration
cat > lib/auth-client.ts << 'EOF'
import { createAuthClient } from "better-auth/react";

export const authClient = createAuthClient({
  baseURL: "http://localhost:3000",
});

export const {
  signIn,
  signUp,
  signOut,
  useSession
} = authClient;
EOF

# Create API auth route
mkdir -p app/api/auth/[...all]
cat > app/api/auth/[...all]/route.ts << 'EOF'
import { betterAuth } from "better-auth";
import { toNextJsHandler } from "better-auth/next-js";

const auth = betterAuth({
  database: {
    provider: "pg",
    url: "postgresql://postgres:postgres@localhost:5432/apso_quickstart",
  },
  emailAndPassword: {
    enabled: true,
  },
});

export const { GET, POST } = toNextJsHandler(auth);
EOF

# Create .env.local
cat > .env.local << 'EOF'
BETTER_AUTH_SECRET=quickstart_auth_secret_change_in_production_987654321
BETTER_AUTH_URL=http://localhost:3000
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/apso_quickstart
EOF
```

### 2.3 Create Login Page (30 seconds)

```bash
# Create auth pages
mkdir -p app/auth/signin
cat > app/auth/signin/page.tsx << 'EOF'
"use client";
import { useState } from "react";
import { signIn } from "@/lib/auth-client";
import { useRouter } from "next/navigation";

export default function SignIn() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      await signIn.emailAndPassword({
        email,
        password,
      });
      router.push("/dashboard");
    } catch (error) {
      console.error("Sign in failed:", error);
      alert("Sign in failed");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="max-w-md w-full space-y-8">
        <h2 className="text-3xl font-bold text-center">Sign In</h2>
        <form className="mt-8 space-y-6" onSubmit={handleSubmit}>
          <div>
            <input
              type="email"
              required
              className="w-full px-3 py-2 border rounded-md"
              placeholder="Email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
          </div>
          <div>
            <input
              type="password"
              required
              className="w-full px-3 py-2 border rounded-md"
              placeholder="Password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
          </div>
          <button
            type="submit"
            disabled={loading}
            className="w-full py-2 px-4 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50"
          >
            {loading ? "Signing in..." : "Sign In"}
          </button>
        </form>
        <p className="text-center">
          Don't have an account?{" "}
          <a href="/auth/signup" className="text-blue-600">
            Sign Up
          </a>
        </p>
      </div>
    </div>
  );
}
EOF

# Create signup page
mkdir -p app/auth/signup
cat > app/auth/signup/page.tsx << 'EOF'
"use client";
import { useState } from "react";
import { signUp } from "@/lib/auth-client";
import { useRouter } from "next/navigation";

export default function SignUp() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [name, setName] = useState("");
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      await signUp.emailAndPassword({
        email,
        password,
        name,
      });
      router.push("/dashboard");
    } catch (error) {
      console.error("Sign up failed:", error);
      alert("Sign up failed");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="max-w-md w-full space-y-8">
        <h2 className="text-3xl font-bold text-center">Sign Up</h2>
        <form className="mt-8 space-y-6" onSubmit={handleSubmit}>
          <div>
            <input
              type="text"
              required
              className="w-full px-3 py-2 border rounded-md"
              placeholder="Name"
              value={name}
              onChange={(e) => setName(e.target.value)}
            />
          </div>
          <div>
            <input
              type="email"
              required
              className="w-full px-3 py-2 border rounded-md"
              placeholder="Email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
          </div>
          <div>
            <input
              type="password"
              required
              className="w-full px-3 py-2 border rounded-md"
              placeholder="Password (min 8 characters)"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
          </div>
          <button
            type="submit"
            disabled={loading}
            className="w-full py-2 px-4 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50"
          >
            {loading ? "Creating account..." : "Sign Up"}
          </button>
        </form>
        <p className="text-center">
          Already have an account?{" "}
          <a href="/auth/signin" className="text-blue-600">
            Sign In
          </a>
        </p>
      </div>
    </div>
  );
}
EOF

# Create dashboard page
mkdir -p app/dashboard
cat > app/dashboard/page.tsx << 'EOF'
"use client";
import { useSession, signOut } from "@/lib/auth-client";
import { useRouter } from "next/navigation";
import { useEffect } from "react";

export default function Dashboard() {
  const { data: session, isPending } = useSession();
  const router = useRouter();

  useEffect(() => {
    if (!isPending && !session) {
      router.push("/auth/signin");
    }
  }, [session, isPending, router]);

  if (isPending) {
    return <div>Loading...</div>;
  }

  if (!session) {
    return null;
  }

  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <div className="max-w-4xl mx-auto">
        <div className="bg-white rounded-lg shadow p-6">
          <h1 className="text-2xl font-bold mb-4">Dashboard</h1>
          <p className="mb-4">Welcome, {session.user?.email}!</p>
          <div className="space-y-2">
            <p>User ID: {session.user?.id}</p>
            <p>Session ID: {session.session?.id}</p>
          </div>
          <button
            onClick={async () => {
              await signOut();
              router.push("/");
            }}
            className="mt-6 px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700"
          >
            Sign Out
          </button>
        </div>
      </div>
    </div>
  );
}
EOF

# Update home page
cat > app/page.tsx << 'EOF'
export default function Home() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gray-50">
      <h1 className="text-4xl font-bold mb-8">Apso + BetterAuth Quickstart</h1>
      <div className="space-x-4">
        <a
          href="/auth/signin"
          className="px-6 py-3 bg-blue-600 text-white rounded-md hover:bg-blue-700"
        >
          Sign In
        </a>
        <a
          href="/auth/signup"
          className="px-6 py-3 bg-green-600 text-white rounded-md hover:bg-green-700"
        >
          Sign Up
        </a>
        <a
          href="/dashboard"
          className="px-6 py-3 bg-gray-600 text-white rounded-md hover:bg-gray-700"
        >
          Dashboard
        </a>
      </div>
    </div>
  );
}
EOF
```

✅ **Frontend Verification**:
```bash
# Build to verify no errors
npm run build
# Should complete without errors
```

---

## Step 3: Start & Verify (1 minute)

### 3.1 Start Both Services (30 seconds)

```bash
# Terminal 1: Start Backend
cd ~/quickstart-apso/backend
npm run start:dev

# Terminal 2: Start Frontend
cd ~/quickstart-apso/frontend
npm run dev
```

### 3.2 Quick Verification (30 seconds)

```bash
# Verify backend is running
curl http://localhost:3001/auth/health
# Expected: {"status":"ok","timestamp":"..."}

# Verify frontend is running
curl http://localhost:3000 2>/dev/null | grep -q "Apso" && echo "Frontend OK" || echo "Frontend Error"

# Verify auth endpoint
curl -X POST http://localhost:3000/api/auth/sign-up \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123","name":"Test User"}' \
  2>/dev/null | grep -q "user" && echo "Auth OK" || echo "Auth Error"
```

✅ **Complete System Test**:
1. Open browser: http://localhost:3000
2. Click "Sign Up"
3. Create account with:
   - Name: Test User
   - Email: test@example.com
   - Password: password123
4. You should be redirected to dashboard
5. Click "Sign Out"
6. Click "Sign In" and use same credentials
7. You should see dashboard with your user info

---

## Troubleshooting (If Something Fails)

### Database Connection Error
```bash
# Check PostgreSQL is running
sudo systemctl status postgresql || brew services list | grep postgresql

# Start PostgreSQL
sudo systemctl start postgresql || brew services start postgresql

# Reset database
PGPASSWORD=postgres psql -U postgres -h localhost -c "DROP DATABASE IF EXISTS apso_quickstart;"
PGPASSWORD=postgres psql -U postgres -h localhost -c "CREATE DATABASE apso_quickstart;"
```

### Port Already in Use
```bash
# Kill process on port 3000 (frontend)
lsof -ti:3000 | xargs kill -9

# Kill process on port 3001 (backend)
lsof -ti:3001 | xargs kill -9
```

### Module Not Found Errors
```bash
# Clear node_modules and reinstall
cd ~/quickstart-apso/backend
rm -rf node_modules package-lock.json
npm install

cd ~/quickstart-apso/frontend
rm -rf node_modules package-lock.json
npm install
```

### Authentication Not Working
```bash
# Verify environment variables
cd ~/quickstart-apso/backend
cat .env | grep -E "DATABASE_|JWT_|BETTER_AUTH_"

cd ~/quickstart-apso/frontend
cat .env.local | grep -E "BETTER_AUTH_|DATABASE_"

# Both should have matching BETTER_AUTH_SECRET values
```

### TypeScript Errors
```bash
# Backend: Ensure tsconfig.json exists
cd ~/quickstart-apso/backend
test -f tsconfig.json && echo "OK" || echo "Missing tsconfig.json"

# Frontend: Reset TypeScript
cd ~/quickstart-apso/frontend
rm -rf .next
npm run build
```

---

## 🎉 Success Checklist

- [ ] Backend running on http://localhost:3001
- [ ] Frontend running on http://localhost:3000
- [ ] Database `apso_quickstart` created
- [ ] Can create new user account
- [ ] Can sign in with created account
- [ ] Dashboard shows user information
- [ ] Sign out works correctly

## Next Steps

1. **Add Apso Entities**: Run `npx apso generate` in backend to generate entities from .apsorc
2. **Add API Endpoints**: Create REST/GraphQL endpoints for your entities
3. **Add Frontend Components**: Build UI components for your features
4. **Configure Production**: Update secrets and database for production deployment

## Complete File Structure

```
~/quickstart-apso/
├── backend/
│   ├── src/
│   │   ├── auth/
│   │   │   ├── auth.module.ts
│   │   │   └── auth.controller.ts
│   │   ├── app.module.ts
│   │   └── main.ts
│   ├── .apsorc
│   ├── .env
│   ├── package.json
│   └── tsconfig.json
└── frontend/
    ├── app/
    │   ├── api/
    │   │   └── auth/
    │   │       └── [...all]/
    │   │           └── route.ts
    │   ├── auth/
    │   │   ├── signin/
    │   │   │   └── page.tsx
    │   │   └── signup/
    │   │       └── page.tsx
    │   ├── dashboard/
    │   │   └── page.tsx
    │   └── page.tsx
    ├── lib/
    │   └── auth-client.ts
    ├── .env.local
    └── package.json
```

---

**Total Time**: 5 minutes ⏱️

This quickstart gives you a fully functional authentication system with Apso backend structure and BetterAuth integration. Everything uses sensible defaults that can be customized later for production use.