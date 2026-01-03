# Configuration Templates and Reference

> Ready-to-use configuration templates for new SaaS projects. Copy these to bootstrap a new project quickly.

---

## Table of Contents

1. [Backend .apsorc Template](#backend-apsorc-template)
2. [Backend Environment Template](#backend-environment-template)
3. [Frontend Environment Template](#frontend-environment-template)
4. [Frontend Auth Config Template](#frontend-auth-config-template)
5. [Docker Compose Setup](#docker-compose-setup)
6. [NestJS Configuration Files](#nestjs-configuration-files)
7. [Next.js Configuration Files](#nextjs-configuration-files)
8. [Quick Setup Checklist](#quick-setup-checklist)

---

## Backend .apsorc Template

### Minimal SaaS (Single Org per User)

**File:** `backend/.apsorc`

```json
{
  "version": 2,
  "rootFolder": "src",
  "entities": [
    {
      "name": "User",
      "description": "Better Auth authentication user",
      "primaryKeyType": "uuid",
      "created_at": true,
      "updated_at": true,
      "fields": [
        {
          "name": "email",
          "type": "text",
          "length": 255,
          "unique": true,
          "required": true,
          "comment": "User email address"
        },
        {
          "name": "email_verified",
          "type": "boolean",
          "default": false,
          "comment": "Whether email is verified"
        },
        {
          "name": "name",
          "type": "text",
          "length": 255,
          "required": true,
          "comment": "User display name"
        },
        {
          "name": "avatar_url",
          "type": "text",
          "length": 500,
          "nullable": true,
          "comment": "User avatar URL"
        }
      ]
    },
    {
      "name": "account",
      "description": "Better Auth OAuth and credential accounts",
      "primaryKeyType": "uuid",
      "created_at": true,
      "updated_at": true,
      "fields": [
        {
          "name": "userId",
          "type": "text",
          "length": 36,
          "required": true,
          "comment": "Reference to User"
        },
        {
          "name": "accountId",
          "type": "text",
          "length": 255,
          "nullable": true,
          "comment": "OAuth provider user ID"
        },
        {
          "name": "providerId",
          "type": "text",
          "length": 50,
          "nullable": true,
          "comment": "OAuth provider name"
        },
        {
          "name": "accessToken",
          "type": "text",
          "nullable": true
        },
        {
          "name": "refreshToken",
          "type": "text",
          "nullable": true
        },
        {
          "name": "accessTokenExpiresAt",
          "type": "timestamp",
          "nullable": true
        },
        {
          "name": "refreshTokenExpiresAt",
          "type": "timestamp",
          "nullable": true
        },
        {
          "name": "scope",
          "type": "text",
          "length": 500,
          "nullable": true
        },
        {
          "name": "idToken",
          "type": "text",
          "nullable": true
        },
        {
          "name": "password",
          "type": "text",
          "length": 255,
          "nullable": true,
          "comment": "Hashed password for email/password auth"
        }
      ]
    },
    {
      "name": "session",
      "description": "Better Auth session management",
      "primaryKeyType": "uuid",
      "created_at": true,
      "updated_at": true,
      "fields": [
        {
          "name": "userId",
          "type": "text",
          "length": 36,
          "required": true
        },
        {
          "name": "token",
          "type": "text",
          "length": 255,
          "unique": true,
          "required": true
        },
        {
          "name": "expiresAt",
          "type": "timestamp",
          "required": true
        },
        {
          "name": "ipAddress",
          "type": "text",
          "length": 45,
          "nullable": true
        },
        {
          "name": "userAgent",
          "type": "text",
          "length": 500,
          "nullable": true
        }
      ]
    },
    {
      "name": "Verification",
      "description": "Better Auth email verification and password reset tokens",
      "primaryKeyType": "uuid",
      "created_at": true,
      "updated_at": true,
      "fields": [
        {
          "name": "identifier",
          "type": "text",
          "length": 255,
          "required": true,
          "comment": "Email or identifier"
        },
        {
          "name": "value",
          "type": "text",
          "length": 255,
          "required": true,
          "comment": "Verification token"
        },
        {
          "name": "expiresAt",
          "type": "timestamp",
          "required": true
        }
      ]
    },
    {
      "name": "Organization",
      "description": "User's workspace or organization",
      "primaryKeyType": "uuid",
      "created_at": true,
      "updated_at": true,
      "fields": [
        {
          "name": "user_id",
          "type": "text",
          "length": 36,
          "required": true,
          "comment": "Owner of organization"
        },
        {
          "name": "name",
          "type": "text",
          "length": 255,
          "required": true,
          "comment": "Organization name"
        },
        {
          "name": "slug",
          "type": "text",
          "length": 100,
          "unique": true,
          "required": true,
          "pattern": "^[a-z0-9-]+$",
          "comment": "URL-friendly slug"
        },
        {
          "name": "billing_email",
          "type": "text",
          "length": 255,
          "required": true,
          "comment": "Email for billing"
        },
        {
          "name": "stripe_customer_id",
          "type": "text",
          "length": 255,
          "nullable": true,
          "unique": true,
          "comment": "Stripe customer ID"
        },
        {
          "name": "stripe_subscription_id",
          "type": "text",
          "length": 255,
          "nullable": true,
          "unique": true,
          "comment": "Stripe subscription ID"
        },
        {
          "name": "subscription_tier",
          "type": "enum",
          "values": ["free", "starter", "professional"],
          "default": "free",
          "comment": "Current plan tier"
        },
        {
          "name": "subscription_status",
          "type": "enum",
          "values": ["active", "canceled", "past_due", "trialing"],
          "default": "active",
          "comment": "Subscription status"
        }
      ]
    }
  ],
  "relationships": [
    {
      "from": "Organization",
      "to": "User",
      "type": "ManyToOne",
      "fromField": "user_id",
      "toField": "id",
      "onDelete": "CASCADE",
      "required": true,
      "comment": "Organization belongs to User"
    }
  ]
}
```

### Team Collaboration SaaS

**File:** `backend/.apsorc` (add to minimal template above)

```json
{
  "entities": [
    // ... (User, account, session, Verification, Organization from above)
    {
      "name": "OrganizationMember",
      "description": "User membership in organization with role",
      "primaryKeyType": "uuid",
      "created_at": true,
      "fields": [
        {
          "name": "user_id",
          "type": "text",
          "length": 36,
          "required": true
        },
        {
          "name": "org_id",
          "type": "text",
          "length": 36,
          "required": true
        },
        {
          "name": "role",
          "type": "enum",
          "values": ["owner", "admin", "member"],
          "default": "member",
          "comment": "User role in organization"
        }
      ]
    },
    {
      "name": "Project",
      "description": "Project within organization",
      "primaryKeyType": "uuid",
      "created_at": true,
      "updated_at": true,
      "fields": [
        {
          "name": "org_id",
          "type": "text",
          "length": 36,
          "required": true
        },
        {
          "name": "name",
          "type": "text",
          "length": 255,
          "required": true
        },
        {
          "name": "slug",
          "type": "text",
          "length": 100,
          "required": true,
          "pattern": "^[a-z0-9-]+$"
        },
        {
          "name": "description",
          "type": "text",
          "nullable": true
        }
      ]
    }
  ],
  "relationships": [
    // ... (existing relationships)
    {
      "from": "OrganizationMember",
      "to": "User",
      "type": "ManyToOne",
      "fromField": "user_id",
      "toField": "id",
      "onDelete": "CASCADE"
    },
    {
      "from": "OrganizationMember",
      "to": "Organization",
      "type": "ManyToOne",
      "fromField": "org_id",
      "toField": "id",
      "onDelete": "CASCADE"
    },
    {
      "from": "Project",
      "to": "Organization",
      "type": "ManyToOne",
      "fromField": "org_id",
      "toField": "id",
      "onDelete": "CASCADE"
    }
  ]
}
```

---

## Backend Environment Template

**File:** `backend/.env.local` (development)

```env
# ============================================
# DATABASE CONFIGURATION
# ============================================
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/my_app_dev
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=my_app_dev

# ============================================
# APPLICATION
# ============================================
NODE_ENV=development
PORT=3001
LOG_LEVEL=debug

# ============================================
# AUTHENTICATION
# ============================================
JWT_SECRET=your-secret-key-min-32-characters-change-in-prod
BETTER_AUTH_SECRET=your-secret-key-min-32-characters-change-in-prod
BETTER_AUTH_URL=http://localhost:3001
BETTER_AUTH_TRUST_HOST=true

# ============================================
# EMAIL (Postmark)
# ============================================
POSTMARK_TOKEN=00000000-0000-0000-0000-000000000000
POSTMARK_FROM_EMAIL=noreply@example.com

# ============================================
# PAYMENTS (Stripe)
# ============================================
STRIPE_SECRET_KEY=sk_test_51234567890abcdefghijk
STRIPE_PUBLISHABLE_KEY=pk_test_51234567890abcdefghijk
STRIPE_WEBHOOK_SECRET=whsec_1234567890abcdefghijk

# ============================================
# FILE STORAGE (AWS S3)
# ============================================
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=AKIA1234567890EXAMPLE
AWS_SECRET_ACCESS_KEY=abcdefghijklmnopqrstuvwxyz1234567890
S3_BUCKET=my-app-dev

# ============================================
# OAUTH PROVIDERS
# ============================================
GOOGLE_CLIENT_ID=123456789-abcdefghij.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=GOCSPX-abcdefghijklmnopqr

GITHUB_CLIENT_ID=Iv1.1234567890abcd
GITHUB_CLIENT_SECRET=abcdefghijklmnopqrstuvwxyz1234567890

# ============================================
# MONITORING & LOGGING
# ============================================
SENTRY_DSN=https://abcdef1234567890@sentry.io/1234567
SENTRY_ENVIRONMENT=development

# ============================================
# AI INTEGRATIONS
# ============================================
OPENAI_API_KEY=sk-proj-1234567890abcdefghijklmnopqr
ANTHROPIC_API_KEY=sk-ant-1234567890abcdefghijklmnopqr
```

**File:** `backend/.env.production` (production)

```env
# ============================================
# DATABASE CONFIGURATION
# ============================================
DATABASE_URL=postgresql://prod_user:secure_password@db.rds.amazonaws.com:5432/my_app_prod
DB_HOST=db.rds.amazonaws.com
DB_PORT=5432
DB_USER=prod_user
DB_PASSWORD=secure_password
DB_NAME=my_app_prod

# ============================================
# APPLICATION
# ============================================
NODE_ENV=production
PORT=3001
LOG_LEVEL=error

# ============================================
# AUTHENTICATION
# ============================================
JWT_SECRET=use_strong_random_secret_at_least_32_chars
BETTER_AUTH_SECRET=use_strong_random_secret_at_least_32_chars
BETTER_AUTH_URL=https://api.example.com
BETTER_AUTH_TRUST_HOST=true

# ============================================
# EMAIL (Postmark)
# ============================================
POSTMARK_TOKEN=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
POSTMARK_FROM_EMAIL=noreply@example.com

# ============================================
# PAYMENTS (Stripe)
# ============================================
STRIPE_SECRET_KEY=sk_live_1234567890abcdefghijk
STRIPE_PUBLISHABLE_KEY=pk_live_1234567890abcdefghijk
STRIPE_WEBHOOK_SECRET=whsec_1234567890abcdefghijk

# ============================================
# FILE STORAGE (AWS S3)
# ============================================
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=AKIA1234567890EXAMPLE
AWS_SECRET_ACCESS_KEY=abcdefghijklmnopqrstuvwxyz1234567890
S3_BUCKET=my-app-prod

# ============================================
# OAUTH PROVIDERS
# ============================================
GOOGLE_CLIENT_ID=123456789-abcdefghij.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=GOCSPX-abcdefghijklmnopqr

GITHUB_CLIENT_ID=Iv1.1234567890abcd
GITHUB_CLIENT_SECRET=abcdefghijklmnopqrstuvwxyz1234567890

# ============================================
# MONITORING & LOGGING
# ============================================
SENTRY_DSN=https://abcdef1234567890@sentry.io/1234567
SENTRY_ENVIRONMENT=production

# ============================================
# AI INTEGRATIONS
# ============================================
OPENAI_API_KEY=sk-proj-1234567890abcdefghijklmnopqr
ANTHROPIC_API_KEY=sk-ant-1234567890abcdefghijklmnopqr
```

---

## Frontend Environment Template

**File:** `frontend/.env.local` (development)

```env
# ============================================
# API CONFIGURATION
# ============================================
NEXT_PUBLIC_BACKEND_URL=http://localhost:3001
NEXT_PUBLIC_BETTER_AUTH_URL=http://localhost:3001

# ============================================
# STRIPE (Public Key)
# ============================================
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_51234567890abcdefghijk

# ============================================
# ANALYTICS & MONITORING
# ============================================
NEXT_PUBLIC_SENTRY_DSN=https://abcdef1234567890@sentry.io/1234567

NEXT_PUBLIC_POSTHOG_KEY=phc_1234567890abcdefghijklmnopqr
NEXT_PUBLIC_POSTHOG_URL=https://app.posthog.com

# ============================================
# AI SERVICES
# ============================================
NEXT_PUBLIC_OPENAI_API_KEY=sk-proj-1234567890abcdefghijklmnopqr

# ============================================
# ENVIRONMENT
# ============================================
NEXT_PUBLIC_ENVIRONMENT=development
```

**File:** `frontend/.env.production` (production)

```env
# ============================================
# API CONFIGURATION
# ============================================
NEXT_PUBLIC_BACKEND_URL=https://api.example.com
NEXT_PUBLIC_BETTER_AUTH_URL=https://api.example.com

# ============================================
# STRIPE (Public Key)
# ============================================
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_1234567890abcdefghijk

# ============================================
# ANALYTICS & MONITORING
# ============================================
NEXT_PUBLIC_SENTRY_DSN=https://abcdef1234567890@sentry.io/1234567

NEXT_PUBLIC_POSTHOG_KEY=phc_1234567890abcdefghijklmnopqr
NEXT_PUBLIC_POSTHOG_URL=https://app.posthog.com

# ============================================
# AI SERVICES
# ============================================
NEXT_PUBLIC_OPENAI_API_KEY=sk-proj-1234567890abcdefghijklmnopqr

# ============================================
# ENVIRONMENT
# ============================================
NEXT_PUBLIC_ENVIRONMENT=production
```

---

## Frontend Auth Config Template

**File:** `frontend/lib/auth.ts`

```typescript
import { betterAuth } from 'better-auth';
import { apsoAdapter } from '@apso/better-auth-adapter';

export const auth = betterAuth({
  baseURL: process.env.BETTER_AUTH_URL || 'http://localhost:3001',
  basePath: '/api/auth',
  secret: process.env.BETTER_AUTH_SECRET!,
  database: apsoAdapter({
    baseUrl: process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:3001',
  }),
  emailAndPassword: {
    enabled: true,
    minPasswordLength: 8,
    maxPasswordLength: 128,
  },
  session: {
    expiresIn: 60 * 60 * 24 * 7, // 7 days
    updateAge: 60 * 60 * 24,     // 1 day
    cookieCache: {
      enabled: true,
      maxAge: 5 * 60, // 5 minutes
    },
  },
  socialProviders: {
    google: {
      clientId: process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    },
    github: {
      clientId: process.env.NEXT_PUBLIC_GITHUB_CLIENT_ID!,
      clientSecret: process.env.GITHUB_CLIENT_SECRET!,
    },
  },
  plugins: [
    // Add plugins here if needed
  ],
});

export type Session = typeof auth.$Infer.Session;
```

**File:** `frontend/lib/auth-client.ts`

```typescript
'use client';
import { createAuthClient } from 'better-auth/react';
import { useRouter } from 'next/navigation';

const baseURL = process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:3001';

export const {
  signUp,
  signIn,
  signOut,
  useSession,
  useAuth,
  getSession,
} = createAuthClient({
  baseURL: baseURL,
  basePath: '/api/auth',
});

// Hook for use in protected pages
export function useRequireAuth() {
  const router = useRouter();
  const { data: session, isPending } = useSession();

  if (!isPending && !session) {
    router.push('/login');
  }

  return { session, isPending };
}
```

---

## Docker Compose Setup

**File:** `docker-compose.yml`

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: my_app_postgres
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: my_app_dev
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: my_app_redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: my_app_backend
    ports:
      - "3001:3001"
    environment:
      NODE_ENV: development
      DATABASE_URL: postgresql://postgres:postgres@postgres:5432/my_app_dev
      REDIS_URL: redis://redis:6379
      PORT: 3001
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    volumes:
      - ./backend/src:/app/src
    command: npm run start:dev

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: my_app_frontend
    ports:
      - "3000:3000"
    environment:
      NEXT_PUBLIC_BACKEND_URL: http://localhost:3001
    depends_on:
      - backend
    volumes:
      - ./frontend:/app
      - /app/node_modules
      - /app/.next
    command: npm run dev

volumes:
  postgres_data:
  redis_data:
```

**Backend Dockerfile:**

```dockerfile
# backend/Dockerfile
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

EXPOSE 3001

CMD ["npm", "run", "start:dev"]
```

**Frontend Dockerfile:**

```dockerfile
# frontend/Dockerfile
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

EXPOSE 3000

CMD ["npm", "run", "dev"]
```

**Start services:**

```bash
docker-compose up
```

---

## NestJS Configuration Files

**File:** `backend/tsconfig.json`

```json
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "ES2020",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "baseUrl": ".",
    "paths": {
      "@/*": ["src/*"]
    },
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "test", "**/*spec.ts"]
}
```

**File:** `backend/nest-cli.json`

```json
{
  "$schema": "https://json.schemastore.org/nest-cli",
  "collection": "@nestjs/schematics",
  "sourceRoot": "src",
  "compilerOptions": {
    "webpack": true,
    "webpackConfigFilename": "webpack.config.js",
    "deleteOutDir": true
  }
}
```

**File:** `backend/.eslintrc.js`

```javascript
module.exports = {
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: 'tsconfig.json',
    sourceType: 'module',
  },
  plugins: ['@typescript-eslint/eslint-plugin'],
  extends: [
    'plugin:@typescript-eslint/recommended',
    'plugin:prettier/recommended',
  ],
  root: true,
  env: {
    node: true,
    jest: true,
  },
  ignorePatterns: ['.eslintrc.js'],
  rules: {
    '@typescript-eslint/interface-name-prefix': 'off',
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off',
    '@typescript-eslint/no-explicit-any': 'off',
  },
};
```

---

## Next.js Configuration Files

**File:** `frontend/next.config.mjs`

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '*.amazonaws.com',
      },
      {
        protocol: 'https',
        hostname: 'lh3.googleusercontent.com',
      },
      {
        protocol: 'https',
        hostname: 'avatars.githubusercontent.com',
      },
    ],
  },
  env: {
    NEXT_PUBLIC_BACKEND_URL: process.env.NEXT_PUBLIC_BACKEND_URL,
  },
  redirects: async () => [
    {
      source: '/',
      destination: '/dashboard',
      permanent: false,
    },
  ],
  rewrites: async () => ({
    beforeFiles: [
      {
        source: '/api/:path*',
        destination: `${process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:3001'}/api/:path*`,
      },
    ],
  }),
};

export default nextConfig;
```

**File:** `frontend/tsconfig.json`

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "strict": true,
    "esModuleInterop": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```

**File:** `frontend/.eslintrc.json`

```json
{
  "extends": "next/core-web-vitals",
  "rules": {
    "react-hooks/exhaustive-deps": "warn",
    "@next/next/no-img-element": "warn"
  }
}
```

---

## Quick Setup Checklist

### Step 1: Clone and Install

```bash
# Clone repository
git clone https://github.com/yourusername/project.git
cd project

# Install all dependencies
npm install
cd backend && npm install && cd ..
cd frontend && npm install && cd ..
```

### Step 2: Set Up Environment Variables

```bash
# Backend
cp backend/.env.example backend/.env.local
# Edit backend/.env.local with your values

# Frontend
cp frontend/.env.example frontend/.env.local
# Edit frontend/.env.local with your values
```

### Step 3: Database Setup

```bash
# Start PostgreSQL
docker-compose up postgres

# Run migrations
cd backend
npm run migration:run
cd ..
```

### Step 4: Run Services

```bash
# Terminal 1: Backend
cd backend
npm run start:dev

# Terminal 2: Frontend
cd frontend
npm run dev
```

### Step 5: Access Applications

- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:3001
- **API Docs:** http://localhost:3001/api/docs

### Pre-Launch Checklist

- [ ] All environment variables set
- [ ] Database migrations run successfully
- [ ] Backend starts without errors
- [ ] Frontend starts without errors
- [ ] Can create account via signup
- [ ] Can login with email/password
- [ ] Can access protected routes
- [ ] OAuth (Google/GitHub) configured (if using)
- [ ] Stripe keys configured (if using payments)
- [ ] Email service configured (if using transactional emails)

---

**Last Updated:** 2025-01-18
**Version:** 1.0
**Status:** Ready to Use
