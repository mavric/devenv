# Next.js + Better Auth Frontend Integration Guide

> Complete implementation guide for authentication in Next.js App Router with Better Auth

## Table of Contents

1. [Project Setup](#project-setup)
2. [Library Configuration](#library-configuration)
3. [Authentication Components](#authentication-components)
4. [Protected Routes](#protected-routes)
5. [Session Management](#session-management)
6. [OAuth Integration](#oauth-integration)
7. [Multi-Tenancy Frontend](#multi-tenancy-frontend)
8. [Advanced Features](#advanced-features)
9. [Testing Authentication](#testing-authentication)
10. [Production Deployment](#production-deployment)

## Project Setup

### Required Dependencies

```bash
# Core dependencies
npm install better-auth
npm install @apso/better-auth-adapter

# Additional utilities
npm install zod                    # Form validation
npm install react-hook-form        # Form management
npm install @hookform/resolvers    # Zod integration
npm install sonner                 # Toast notifications
```

### Project Structure

```
frontend/
├── app/
│   ├── (auth)/
│   │   ├── signin/
│   │   │   └── page.tsx
│   │   ├── signup/
│   │   │   └── page.tsx
│   │   ├── forgot-password/
│   │   │   └── page.tsx
│   │   └── layout.tsx
│   ├── (protected)/
│   │   ├── dashboard/
│   │   │   └── page.tsx
│   │   ├── settings/
│   │   │   └── page.tsx
│   │   └── layout.tsx
│   ├── api/
│   │   └── auth/
│   │       └── [...all]/
│   │           └── route.ts
│   └── layout.tsx
├── components/
│   ├── auth/
│   │   ├── SignInForm.tsx
│   │   ├── SignUpForm.tsx
│   │   ├── OAuthButtons.tsx
│   │   ├── PasswordResetForm.tsx
│   │   └── EmailVerification.tsx
│   ├── layout/
│   │   ├── Header.tsx
│   │   └── UserMenu.tsx
│   └── providers/
│       └── AuthProvider.tsx
├── lib/
│   ├── auth.ts           # Server-side auth config
│   ├── auth-client.ts    # Client-side auth
│   └── auth-utils.ts     # Helper functions
├── hooks/
│   ├── useAuth.ts
│   └── useOrganization.ts
└── middleware.ts
```

## Library Configuration

### Server-Side Auth Configuration

**File:** `lib/auth.ts`

```typescript
import { betterAuth } from 'better-auth';
import { apsoAdapter } from '@apso/better-auth-adapter';
import { headers } from 'next/headers';

// UUID generation helper
export function generateUUID(): string {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
    const r = (Math.random() * 16) | 0;
    const v = c === 'x' ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

// Auth configuration
export const auth = betterAuth({
  // Database adapter
  database: apsoAdapter({
    baseUrl: process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:3001',
    apiKey: process.env.APSO_API_KEY,

    // Advanced options
    retryConfig: {
      maxRetries: 3,
      initialDelayMs: 1000,
    },

    // Custom headers
    headers: {
      'X-API-Version': '1.0',
    },
  }),

  // Email/Password authentication
  emailAndPassword: {
    enabled: true,
    requireEmailVerification: process.env.NODE_ENV === 'production',
    minPasswordLength: 8,
    maxPasswordLength: 128,
  },

  // OAuth providers
  socialProviders: {
    google: {
      clientId: process.env.GOOGLE_CLIENT_ID || '',
      clientSecret: process.env.GOOGLE_CLIENT_SECRET || '',
      enabled: !!process.env.GOOGLE_CLIENT_ID,
      scopes: ['email', 'profile'],
      callbackURL: '/api/auth/callback/google',
    },
    github: {
      clientId: process.env.GITHUB_CLIENT_ID || '',
      clientSecret: process.env.GITHUB_CLIENT_SECRET || '',
      enabled: !!process.env.GITHUB_CLIENT_ID,
      scopes: ['read:user', 'user:email'],
      callbackURL: '/api/auth/callback/github',
    },
  },

  // Session configuration
  session: {
    expiresIn: 60 * 60 * 24 * 7,  // 7 days
    updateAge: 60 * 60 * 24,      // Update if older than 1 day
    cookieName: 'auth-session',
  },

  // Security settings
  trustedOrigins: [
    process.env.NEXT_PUBLIC_APP_URL || 'http://localhost:3000',
    'http://localhost:3001',
  ],

  // Cookie configuration
  advanced: {
    cookiePrefix: 'auth',
    useSecureCookies: process.env.NODE_ENV === 'production',
    sameSite: 'lax',
  },

  // Custom hooks
  hooks: {
    after: [
      {
        matcher: (ctx) => ctx.path === '/sign-up/email' && ctx.method === 'POST',
        handler: async (ctx) => {
          const user = ctx.context?.user;
          if (!user) return;

          // Create organization for new user
          await createOrganizationForUser(user);

          // Send welcome email
          if (process.env.NODE_ENV === 'production') {
            await sendWelcomeEmail(user);
          }
        },
      },
    ],
  },
});

// Helper functions
async function createOrganizationForUser(user: any) {
  const orgId = generateUUID();
  const slug = `${user.email.split('@')[0]}-${Date.now()}`;

  try {
    const response = await fetch(
      `${process.env.NEXT_PUBLIC_BACKEND_URL}/Organizations`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          id: orgId,
          name: user.name || user.email.split('@')[0],
          slug,
          billing_email: user.email,
          subscription_tier: 'free',
          credits: 10,
        }),
      }
    );

    if (response.ok) {
      // Link user to organization
      await fetch(
        `${process.env.NEXT_PUBLIC_BACKEND_URL}/OrganizationUsers`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            id: generateUUID(),
            organization_id: orgId,
            user_id: user.id,
            role: 'owner',
          }),
        }
      );
    }
  } catch (error) {
    console.error('Failed to create organization:', error);
  }
}

async function sendWelcomeEmail(user: any) {
  // Implement email sending logic
}

// Server-side session helper
export async function getServerSession() {
  return auth.api.getSession({
    headers: headers(),
  });
}

// Type exports
export type Auth = typeof auth;
export type Session = Awaited<ReturnType<typeof getServerSession>>;
```

### Client-Side Auth Configuration

**File:** `lib/auth-client.ts`

```typescript
import { createAuthClient } from 'better-auth/react';
import type { Auth } from './auth';

// Create typed client
export const authClient = createAuthClient<Auth>({
  baseURL: process.env.NEXT_PUBLIC_APP_URL || 'http://localhost:3000',

  // Client-side configuration
  fetchOptions: {
    credentials: 'include',
  },
});

// Export typed methods
export const {
  signIn,
  signUp,
  signOut,
  useSession,
  user,
  organization,
} = authClient;

// Custom hooks
export function useAuth() {
  const session = useSession();

  return {
    user: session.data?.user,
    session: session.data,
    isLoading: session.isPending,
    isAuthenticated: !!session.data,
    error: session.error,
  };
}
```

### Environment Configuration

**File:** `.env.local`

```env
# Application URLs
NEXT_PUBLIC_APP_URL=http://localhost:3000
NEXT_PUBLIC_BACKEND_URL=http://localhost:3001

# Authentication
BETTER_AUTH_SECRET=your-super-secret-key-minimum-32-characters
BETTER_AUTH_URL=http://localhost:3000

# OAuth Providers
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-secret
GITHUB_CLIENT_ID=your-github-client-id
GITHUB_CLIENT_SECRET=your-github-secret

# Email Service (Postmark example)
POSTMARK_API_KEY=your-postmark-key
FROM_EMAIL=noreply@yourdomain.com

# Backend API
APSO_API_KEY=your-api-key-if-needed
```

## Authentication Components

### Sign Up Form

**File:** `components/auth/SignUpForm.tsx`

```typescript
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { signUp } from '@/lib/auth-client';
import { toast } from 'sonner';

// Validation schema
const signUpSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters'),
  email: z.string().email('Invalid email address'),
  password: z
    .string()
    .min(8, 'Password must be at least 8 characters')
    .regex(
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/,
      'Password must contain uppercase, lowercase, and number'
    ),
  confirmPassword: z.string(),
}).refine((data) => data.password === data.confirmPassword, {
  message: "Passwords don't match",
  path: ['confirmPassword'],
});

type SignUpFormData = z.infer<typeof signUpSchema>;

export function SignUpForm() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<SignUpFormData>({
    resolver: zodResolver(signUpSchema),
  });

  const onSubmit = async (data: SignUpFormData) => {
    setIsLoading(true);

    try {
      const result = await signUp.email({
        email: data.email,
        password: data.password,
        name: data.name,
      });

      if (result.error) {
        toast.error(result.error.message);
        return;
      }

      toast.success('Account created successfully!');
      router.push('/dashboard');
    } catch (error: any) {
      toast.error(error.message || 'Failed to create account');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      <div>
        <label htmlFor="name" className="block text-sm font-medium text-gray-700">
          Name
        </label>
        <input
          {...register('name')}
          type="text"
          id="name"
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
          placeholder="John Doe"
        />
        {errors.name && (
          <p className="mt-1 text-sm text-red-600">{errors.name.message}</p>
        )}
      </div>

      <div>
        <label htmlFor="email" className="block text-sm font-medium text-gray-700">
          Email
        </label>
        <input
          {...register('email')}
          type="email"
          id="email"
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
          placeholder="john@example.com"
        />
        {errors.email && (
          <p className="mt-1 text-sm text-red-600">{errors.email.message}</p>
        )}
      </div>

      <div>
        <label htmlFor="password" className="block text-sm font-medium text-gray-700">
          Password
        </label>
        <input
          {...register('password')}
          type="password"
          id="password"
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
        />
        {errors.password && (
          <p className="mt-1 text-sm text-red-600">{errors.password.message}</p>
        )}
      </div>

      <div>
        <label htmlFor="confirmPassword" className="block text-sm font-medium text-gray-700">
          Confirm Password
        </label>
        <input
          {...register('confirmPassword')}
          type="password"
          id="confirmPassword"
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
        />
        {errors.confirmPassword && (
          <p className="mt-1 text-sm text-red-600">{errors.confirmPassword.message}</p>
        )}
      </div>

      <button
        type="submit"
        disabled={isLoading}
        className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50"
      >
        {isLoading ? 'Creating account...' : 'Sign Up'}
      </button>
    </form>
  );
}
```

### Sign In Form

**File:** `components/auth/SignInForm.tsx`

```typescript
'use client';

import { useState } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { signIn } from '@/lib/auth-client';
import { toast } from 'sonner';

const signInSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(1, 'Password is required'),
  rememberMe: z.boolean().optional(),
});

type SignInFormData = z.infer<typeof signInSchema>;

export function SignInForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [isLoading, setIsLoading] = useState(false);

  const callbackUrl = searchParams.get('callbackUrl') || '/dashboard';

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<SignInFormData>({
    resolver: zodResolver(signInSchema),
  });

  const onSubmit = async (data: SignInFormData) => {
    setIsLoading(true);

    try {
      const result = await signIn.email({
        email: data.email,
        password: data.password,
        rememberMe: data.rememberMe,
      });

      if (result.error) {
        toast.error(result.error.message);
        return;
      }

      toast.success('Signed in successfully!');
      router.push(callbackUrl);
    } catch (error: any) {
      toast.error(error.message || 'Failed to sign in');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      <div>
        <label htmlFor="email" className="block text-sm font-medium text-gray-700">
          Email
        </label>
        <input
          {...register('email')}
          type="email"
          id="email"
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
          placeholder="john@example.com"
        />
        {errors.email && (
          <p className="mt-1 text-sm text-red-600">{errors.email.message}</p>
        )}
      </div>

      <div>
        <label htmlFor="password" className="block text-sm font-medium text-gray-700">
          Password
        </label>
        <input
          {...register('password')}
          type="password"
          id="password"
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
        />
        {errors.password && (
          <p className="mt-1 text-sm text-red-600">{errors.password.message}</p>
        )}
      </div>

      <div className="flex items-center justify-between">
        <div className="flex items-center">
          <input
            {...register('rememberMe')}
            type="checkbox"
            id="rememberMe"
            className="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
          />
          <label htmlFor="rememberMe" className="ml-2 block text-sm text-gray-900">
            Remember me
          </label>
        </div>

        <div className="text-sm">
          <a href="/forgot-password" className="font-medium text-indigo-600 hover:text-indigo-500">
            Forgot password?
          </a>
        </div>
      </div>

      <button
        type="submit"
        disabled={isLoading}
        className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 disabled:opacity-50"
      >
        {isLoading ? 'Signing in...' : 'Sign In'}
      </button>
    </form>
  );
}
```

### OAuth Buttons

**File:** `components/auth/OAuthButtons.tsx`

```typescript
'use client';

import { useState } from 'react';
import { signIn } from '@/lib/auth-client';
import { toast } from 'sonner';

export function OAuthButtons() {
  const [isLoading, setIsLoading] = useState<string | null>(null);

  const handleOAuth = async (provider: 'google' | 'github') => {
    setIsLoading(provider);

    try {
      await signIn.social({
        provider,
        callbackURL: '/dashboard',
      });
    } catch (error: any) {
      toast.error(`Failed to sign in with ${provider}`);
      setIsLoading(null);
    }
  };

  return (
    <div className="space-y-3">
      <button
        onClick={() => handleOAuth('google')}
        disabled={isLoading !== null}
        className="w-full flex items-center justify-center px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50"
      >
        {isLoading === 'google' ? (
          <span>Connecting...</span>
        ) : (
          <>
            <GoogleIcon className="w-5 h-5 mr-2" />
            Continue with Google
          </>
        )}
      </button>

      <button
        onClick={() => handleOAuth('github')}
        disabled={isLoading !== null}
        className="w-full flex items-center justify-center px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50"
      >
        {isLoading === 'github' ? (
          <span>Connecting...</span>
        ) : (
          <>
            <GitHubIcon className="w-5 h-5 mr-2" />
            Continue with GitHub
          </>
        )}
      </button>
    </div>
  );
}

function GoogleIcon({ className }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24">
      <path
        fill="currentColor"
        d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
      />
      <path
        fill="currentColor"
        d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
      />
      <path
        fill="currentColor"
        d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
      />
      <path
        fill="currentColor"
        d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
      />
    </svg>
  );
}

function GitHubIcon({ className }: { className?: string }) {
  return (
    <svg className={className} fill="currentColor" viewBox="0 0 24 24">
      <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z" />
    </svg>
  );
}
```

## Protected Routes

### Middleware Protection

**File:** `middleware.ts`

```typescript
import { NextRequest, NextResponse } from 'next/server';
import { auth } from '@/lib/auth';

// Define protected and public routes
const protectedRoutes = ['/dashboard', '/settings', '/profile'];
const authRoutes = ['/signin', '/signup', '/forgot-password'];

export async function middleware(request: NextRequest) {
  const path = request.nextUrl.pathname;
  const isProtectedRoute = protectedRoutes.some(route => path.startsWith(route));
  const isAuthRoute = authRoutes.some(route => path.startsWith(route));

  // Get session from cookies
  const session = await auth.api.getSession({
    headers: request.headers,
  });

  // Redirect logic
  if (isProtectedRoute && !session) {
    const redirectUrl = new URL('/signin', request.url);
    redirectUrl.searchParams.set('callbackUrl', path);
    return NextResponse.redirect(redirectUrl);
  }

  if (isAuthRoute && session) {
    return NextResponse.redirect(new URL('/dashboard', request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    /*
     * Match all request paths except:
     * - api/auth (auth endpoints)
     * - _next/static (static files)
     * - _next/image (image optimization)
     * - favicon.ico (favicon)
     */
    '/((?!api/auth|_next/static|_next/image|favicon.ico).*)',
  ],
};
```

### Protected Layout

**File:** `app/(protected)/layout.tsx`

```typescript
import { redirect } from 'next/navigation';
import { getServerSession } from '@/lib/auth';
import { Header } from '@/components/layout/Header';

export default async function ProtectedLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const session = await getServerSession();

  if (!session) {
    redirect('/signin');
  }

  return (
    <>
      <Header user={session.user} />
      <main className="min-h-screen bg-gray-50">
        {children}
      </main>
    </>
  );
}
```

### Protected Page Example

**File:** `app/(protected)/dashboard/page.tsx`

```typescript
import { getServerSession } from '@/lib/auth';
import { getOrganizationForUser } from '@/lib/organization';

export default async function DashboardPage() {
  const session = await getServerSession();
  const organization = await getOrganizationForUser(session!.user.id);

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <h1 className="text-3xl font-bold text-gray-900">
        Welcome back, {session!.user.name}!
      </h1>

      <div className="mt-8 grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
        <div className="bg-white overflow-hidden shadow rounded-lg">
          <div className="px-4 py-5 sm:p-6">
            <dt className="text-sm font-medium text-gray-500 truncate">
              Organization
            </dt>
            <dd className="mt-1 text-3xl font-semibold text-gray-900">
              {organization?.name}
            </dd>
          </div>
        </div>

        <div className="bg-white overflow-hidden shadow rounded-lg">
          <div className="px-4 py-5 sm:p-6">
            <dt className="text-sm font-medium text-gray-500 truncate">
              Credits Available
            </dt>
            <dd className="mt-1 text-3xl font-semibold text-gray-900">
              {organization?.credits || 0}
            </dd>
          </div>
        </div>

        <div className="bg-white overflow-hidden shadow rounded-lg">
          <div className="px-4 py-5 sm:p-6">
            <dt className="text-sm font-medium text-gray-500 truncate">
              Subscription
            </dt>
            <dd className="mt-1 text-3xl font-semibold text-gray-900 capitalize">
              {organization?.subscription_tier || 'Free'}
            </dd>
          </div>
        </div>
      </div>
    </div>
  );
}
```

## Session Management

### Auth Provider

**File:** `components/providers/AuthProvider.tsx`

```typescript
'use client';

import { createContext, useContext, useEffect, useState } from 'react';
import { useSession } from '@/lib/auth-client';
import type { Session } from '@/lib/auth';

interface AuthContextType {
  session: Session | null;
  isLoading: boolean;
  isAuthenticated: boolean;
  refreshSession: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const sessionQuery = useSession();
  const [session, setSession] = useState<Session | null>(null);

  useEffect(() => {
    if (sessionQuery.data) {
      setSession(sessionQuery.data);
    }
  }, [sessionQuery.data]);

  const refreshSession = async () => {
    await sessionQuery.refetch();
  };

  return (
    <AuthContext.Provider
      value={{
        session,
        isLoading: sessionQuery.isPending,
        isAuthenticated: !!session,
        refreshSession,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
}
```

### User Menu Component

**File:** `components/layout/UserMenu.tsx`

```typescript
'use client';

import { useState, useRef, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { signOut } from '@/lib/auth-client';
import { useAuth } from '@/components/providers/AuthProvider';
import { toast } from 'sonner';

export function UserMenu() {
  const router = useRouter();
  const { session } = useAuth();
  const [isOpen, setIsOpen] = useState(false);
  const menuRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    }

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleSignOut = async () => {
    try {
      await signOut();
      toast.success('Signed out successfully');
      router.push('/');
    } catch (error) {
      toast.error('Failed to sign out');
    }
  };

  if (!session) return null;

  return (
    <div className="relative" ref={menuRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-3 text-sm focus:outline-none"
      >
        <img
          className="h-8 w-8 rounded-full"
          src={session.user.avatar_url || `https://ui-avatars.com/api/?name=${session.user.name}`}
          alt={session.user.name}
        />
        <span className="hidden md:block font-medium text-gray-700">
          {session.user.name}
        </span>
      </button>

      {isOpen && (
        <div className="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-50">
          <a
            href="/dashboard"
            className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
          >
            Dashboard
          </a>
          <a
            href="/settings"
            className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
          >
            Settings
          </a>
          <hr className="my-1" />
          <button
            onClick={handleSignOut}
            className="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
          >
            Sign Out
          </button>
        </div>
      )}
    </div>
  );
}
```

## OAuth Integration

### OAuth Callback Handler

**File:** `app/api/auth/[...all]/route.ts`

```typescript
import { auth } from '@/lib/auth';
import { toNextJsHandler } from 'better-auth/next-js';

// Handle all auth routes
export const { GET, POST } = toNextJsHandler(auth);
```

### OAuth Configuration Steps

#### Google OAuth Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add authorized redirect URIs:
   - `http://localhost:3000/api/auth/callback/google` (development)
   - `https://yourdomain.com/api/auth/callback/google` (production)

#### GitHub OAuth Setup

1. Go to GitHub Settings > Developer settings > OAuth Apps
2. Create a new OAuth App
3. Set Authorization callback URL:
   - `http://localhost:3000/api/auth/callback/github` (development)
   - `https://yourdomain.com/api/auth/callback/github` (production)

## Multi-Tenancy Frontend

### Organization Context

**File:** `hooks/useOrganization.ts`

```typescript
import { useState, useEffect } from 'react';
import { useAuth } from '@/components/providers/AuthProvider';

export interface Organization {
  id: string;
  name: string;
  slug: string;
  subscription_tier: string;
  credits: number;
}

export function useOrganization() {
  const { session } = useAuth();
  const [organization, setOrganization] = useState<Organization | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    if (!session?.user?.id) {
      setIsLoading(false);
      return;
    }

    fetchOrganization();
  }, [session]);

  const fetchOrganization = async () => {
    try {
      const response = await fetch(
        `/api/organizations/current`,
        {
          credentials: 'include',
        }
      );

      if (response.ok) {
        const data = await response.json();
        setOrganization(data);
      }
    } catch (error) {
      console.error('Failed to fetch organization:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const switchOrganization = async (orgId: string) => {
    try {
      const response = await fetch('/api/organizations/switch', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ organizationId: orgId }),
        credentials: 'include',
      });

      if (response.ok) {
        await fetchOrganization();
        window.location.reload(); // Refresh to update context
      }
    } catch (error) {
      console.error('Failed to switch organization:', error);
    }
  };

  return {
    organization,
    isLoading,
    switchOrganization,
    refetch: fetchOrganization,
  };
}
```

### Organization Switcher

**File:** `components/layout/OrganizationSwitcher.tsx`

```typescript
'use client';

import { useState } from 'react';
import { useOrganization } from '@/hooks/useOrganization';

export function OrganizationSwitcher() {
  const { organization, switchOrganization } = useOrganization();
  const [isOpen, setIsOpen] = useState(false);
  const [organizations, setOrganizations] = useState<any[]>([]);

  const handleSwitch = async (orgId: string) => {
    await switchOrganization(orgId);
    setIsOpen(false);
  };

  if (!organization) return null;

  return (
    <div className="relative">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-2 px-3 py-2 border border-gray-300 rounded-md"
      >
        <span className="font-medium">{organization.name}</span>
        <ChevronDownIcon className="w-4 h-4" />
      </button>

      {isOpen && (
        <div className="absolute top-full mt-1 w-64 bg-white rounded-md shadow-lg z-50">
          <div className="py-1">
            {organizations.map((org) => (
              <button
                key={org.id}
                onClick={() => handleSwitch(org.id)}
                className="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
              >
                <div className="font-medium">{org.name}</div>
                <div className="text-xs text-gray-500">{org.role}</div>
              </button>
            ))}
          </div>
          <div className="border-t">
            <button
              className="block w-full text-left px-4 py-2 text-sm text-blue-600 hover:bg-gray-100"
              onClick={() => {/* Create organization logic */}}
            >
              Create new organization
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

function ChevronDownIcon({ className }: { className?: string }) {
  return (
    <svg className={className} fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
    </svg>
  );
}
```

## Advanced Features

### Two-Factor Authentication

**File:** `components/auth/TwoFactorSetup.tsx`

```typescript
'use client';

import { useState } from 'react';
import { useAuth } from '@/components/providers/AuthProvider';
import { toast } from 'sonner';
import QRCode from 'qrcode';

export function TwoFactorSetup() {
  const { session } = useAuth();
  const [qrCodeUrl, setQrCodeUrl] = useState<string>('');
  const [secret, setSecret] = useState<string>('');
  const [verificationCode, setVerificationCode] = useState('');
  const [isEnabled, setIsEnabled] = useState(false);

  const generateSecret = async () => {
    try {
      const response = await fetch('/api/auth/2fa/generate', {
        method: 'POST',
        credentials: 'include',
      });

      const data = await response.json();
      setSecret(data.secret);

      // Generate QR code
      const otpauthUrl = `otpauth://totp/${encodeURIComponent(
        'YourApp'
      )}:${session?.user.email}?secret=${data.secret}&issuer=YourApp`;

      const qrUrl = await QRCode.toDataURL(otpauthUrl);
      setQrCodeUrl(qrUrl);
    } catch (error) {
      toast.error('Failed to generate 2FA secret');
    }
  };

  const enable2FA = async () => {
    try {
      const response = await fetch('/api/auth/2fa/enable', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          secret,
          code: verificationCode,
        }),
        credentials: 'include',
      });

      if (response.ok) {
        setIsEnabled(true);
        toast.success('Two-factor authentication enabled');
      } else {
        toast.error('Invalid verification code');
      }
    } catch (error) {
      toast.error('Failed to enable 2FA');
    }
  };

  return (
    <div className="space-y-6">
      <div>
        <h3 className="text-lg font-medium">Two-Factor Authentication</h3>
        <p className="mt-1 text-sm text-gray-600">
          Add an extra layer of security to your account
        </p>
      </div>

      {!isEnabled && !qrCodeUrl && (
        <button
          onClick={generateSecret}
          className="px-4 py-2 bg-blue-600 text-white rounded-md"
        >
          Enable Two-Factor Authentication
        </button>
      )}

      {qrCodeUrl && !isEnabled && (
        <div className="space-y-4">
          <div>
            <p className="text-sm text-gray-600 mb-2">
              Scan this QR code with your authenticator app:
            </p>
            <img src={qrCodeUrl} alt="2FA QR Code" className="w-48 h-48" />
          </div>

          <div>
            <p className="text-sm text-gray-600 mb-2">
              Or enter this secret manually:
            </p>
            <code className="bg-gray-100 px-2 py-1 rounded text-sm">
              {secret}
            </code>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700">
              Verification Code
            </label>
            <input
              type="text"
              value={verificationCode}
              onChange={(e) => setVerificationCode(e.target.value)}
              className="mt-1 block w-full rounded-md border-gray-300"
              placeholder="Enter 6-digit code"
              maxLength={6}
            />
          </div>

          <button
            onClick={enable2FA}
            disabled={verificationCode.length !== 6}
            className="px-4 py-2 bg-green-600 text-white rounded-md disabled:opacity-50"
          >
            Verify and Enable
          </button>
        </div>
      )}

      {isEnabled && (
        <div className="bg-green-50 border border-green-200 rounded-md p-4">
          <p className="text-green-800">
            ✓ Two-factor authentication is enabled
          </p>
        </div>
      )}
    </div>
  );
}
```

### Password Reset Flow

**File:** `components/auth/PasswordResetForm.tsx`

```typescript
'use client';

import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { toast } from 'sonner';

const resetSchema = z.object({
  email: z.string().email('Invalid email address'),
});

type ResetFormData = z.infer<typeof resetSchema>;

export function PasswordResetForm() {
  const [isLoading, setIsLoading] = useState(false);
  const [emailSent, setEmailSent] = useState(false);

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<ResetFormData>({
    resolver: zodResolver(resetSchema),
  });

  const onSubmit = async (data: ResetFormData) => {
    setIsLoading(true);

    try {
      const response = await fetch('/api/auth/forgot-password', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
      });

      if (response.ok) {
        setEmailSent(true);
        toast.success('Password reset email sent');
      } else {
        toast.error('Failed to send reset email');
      }
    } catch (error) {
      toast.error('An error occurred');
    } finally {
      setIsLoading(false);
    }
  };

  if (emailSent) {
    return (
      <div className="text-center">
        <CheckCircleIcon className="mx-auto h-12 w-12 text-green-500" />
        <h3 className="mt-2 text-lg font-medium text-gray-900">
          Check your email
        </h3>
        <p className="mt-1 text-sm text-gray-600">
          We've sent you a password reset link.
        </p>
      </div>
    );
  }

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      <div>
        <label htmlFor="email" className="block text-sm font-medium text-gray-700">
          Email Address
        </label>
        <input
          {...register('email')}
          type="email"
          id="email"
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
          placeholder="Enter your email"
        />
        {errors.email && (
          <p className="mt-1 text-sm text-red-600">{errors.email.message}</p>
        )}
      </div>

      <button
        type="submit"
        disabled={isLoading}
        className="w-full py-2 px-4 bg-blue-600 text-white rounded-md disabled:opacity-50"
      >
        {isLoading ? 'Sending...' : 'Send Reset Email'}
      </button>
    </form>
  );
}

function CheckCircleIcon({ className }: { className?: string }) {
  return (
    <svg className={className} fill="currentColor" viewBox="0 0 20 20">
      <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
    </svg>
  );
}
```

## Testing Authentication

### Unit Tests

**File:** `__tests__/auth/SignInForm.test.tsx`

```typescript
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { SignInForm } from '@/components/auth/SignInForm';
import { signIn } from '@/lib/auth-client';

jest.mock('@/lib/auth-client', () => ({
  signIn: {
    email: jest.fn(),
  },
}));

jest.mock('next/navigation', () => ({
  useRouter: () => ({
    push: jest.fn(),
  }),
  useSearchParams: () => ({
    get: jest.fn(),
  }),
}));

describe('SignInForm', () => {
  it('renders form fields', () => {
    render(<SignInForm />);

    expect(screen.getByLabelText(/email/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/password/i)).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /sign in/i })).toBeInTheDocument();
  });

  it('validates email format', async () => {
    render(<SignInForm />);

    const emailInput = screen.getByLabelText(/email/i);
    const submitButton = screen.getByRole('button', { name: /sign in/i });

    fireEvent.change(emailInput, { target: { value: 'invalid-email' } });
    fireEvent.click(submitButton);

    await waitFor(() => {
      expect(screen.getByText(/invalid email address/i)).toBeInTheDocument();
    });
  });

  it('calls signIn on valid submission', async () => {
    const mockSignIn = signIn.email as jest.Mock;
    mockSignIn.mockResolvedValue({ error: null });

    render(<SignInForm />);

    const emailInput = screen.getByLabelText(/email/i);
    const passwordInput = screen.getByLabelText(/password/i);
    const submitButton = screen.getByRole('button', { name: /sign in/i });

    fireEvent.change(emailInput, { target: { value: 'test@example.com' } });
    fireEvent.change(passwordInput, { target: { value: 'password123' } });
    fireEvent.click(submitButton);

    await waitFor(() => {
      expect(mockSignIn).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123',
        rememberMe: false,
      });
    });
  });
});
```

### E2E Tests

**File:** `e2e/auth.spec.ts`

```typescript
import { test, expect } from '@playwright/test';

test.describe('Authentication', () => {
  test('user can sign up', async ({ page }) => {
    await page.goto('/signup');

    // Fill form
    await page.fill('[name="name"]', 'Test User');
    await page.fill('[name="email"]', 'test@example.com');
    await page.fill('[name="password"]', 'TestPassword123!');
    await page.fill('[name="confirmPassword"]', 'TestPassword123!');

    // Submit
    await page.click('button[type="submit"]');

    // Verify redirect to dashboard
    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('text=Welcome back, Test User!')).toBeVisible();
  });

  test('user can sign in', async ({ page }) => {
    await page.goto('/signin');

    // Fill form
    await page.fill('[name="email"]', 'existing@example.com');
    await page.fill('[name="password"]', 'Password123!');

    // Submit
    await page.click('button[type="submit"]');

    // Verify redirect
    await expect(page).toHaveURL('/dashboard');
  });

  test('protected route redirects to signin', async ({ page }) => {
    await page.goto('/dashboard');

    // Should redirect to signin with callback URL
    await expect(page).toHaveURL('/signin?callbackUrl=%2Fdashboard');
  });

  test('OAuth login works', async ({ page }) => {
    await page.goto('/signin');

    // Click Google button (mock OAuth flow in test environment)
    await page.click('button:has-text("Continue with Google")');

    // Verify OAuth redirect (in real test, mock the OAuth provider)
    await expect(page).toHaveURL(/google\.com/);
  });
});
```

## Production Deployment

### Environment Variables

```env
# Production .env
NODE_ENV=production
NEXT_PUBLIC_APP_URL=https://yourdomain.com
NEXT_PUBLIC_BACKEND_URL=https://api.yourdomain.com

# Security
BETTER_AUTH_SECRET=<generate-with-openssl-rand-base64-32>
BETTER_AUTH_URL=https://yourdomain.com

# Database (via Apso backend)
APSO_API_KEY=<production-api-key>

# OAuth
GOOGLE_CLIENT_ID=<production-google-client-id>
GOOGLE_CLIENT_SECRET=<production-google-secret>
GITHUB_CLIENT_ID=<production-github-client-id>
GITHUB_CLIENT_SECRET=<production-github-secret>

# Email
POSTMARK_API_KEY=<production-postmark-key>
FROM_EMAIL=noreply@yourdomain.com

# Analytics (optional)
NEXT_PUBLIC_POSTHOG_KEY=<posthog-key>
NEXT_PUBLIC_POSTHOG_HOST=https://app.posthog.com
```

### Vercel Deployment

```json
// vercel.json
{
  "env": {
    "BETTER_AUTH_SECRET": "@better-auth-secret",
    "GOOGLE_CLIENT_ID": "@google-client-id",
    "GOOGLE_CLIENT_SECRET": "@google-client-secret"
  },
  "functions": {
    "app/api/auth/[...all]/route.ts": {
      "maxDuration": 10
    }
  }
}
```

### Security Checklist

- [ ] Use secure session cookies in production
- [ ] Enable CSRF protection
- [ ] Implement rate limiting
- [ ] Enable email verification
- [ ] Set up proper CORS headers
- [ ] Use HTTPS everywhere
- [ ] Rotate secrets regularly
- [ ] Monitor failed login attempts
- [ ] Implement account lockout
- [ ] Add security headers

This complete guide provides everything needed to implement authentication in a Next.js application with Better Auth and Apso backend.