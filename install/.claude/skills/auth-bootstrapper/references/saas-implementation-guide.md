# SaaS Implementation Guide - Apso + Better Auth

> Step-by-step implementation guide for building SaaS with Apso backend and Better Auth

## Overview

This guide walks you through building a complete SaaS application using:
- **Apso** for backend (database + REST API + deployment)
- **Better Auth** for authentication (email/password + OAuth + sessions)
- **Next.js** for frontend (TypeScript + Tailwind + shadcn/ui)
- **Stripe** for payments
- **Postmark** for email

**Timeline:** 12 weeks to MVP, 24 weeks to market-ready, 48 weeks to enterprise-ready

---

## Phase 1: MVP Foundation (Weeks 1-12)

### Week 1-2: Apso Backend Setup

#### Step 1: Define Your Schema in Apso

**Navigate to:** https://app.staging.apso.cloud/

**Create new service** and define your schema:

```
Service Name: my-saas-api
Environment: development

Schema Definition:

organizations:
  - name: string (required)
  - slug: string (unique, required)
  - billing_email: string
  - stripe_customer_id: string (nullable)
  - created_at: timestamp (auto)
  - updated_at: timestamp (auto)

users:
  - email: string (unique, required)
  - name: string
  - avatar_url: string (nullable)
  - org_id: uuid (references organizations, required)
  - role: enum(admin, member, viewer) (default: member)
  - created_at: timestamp (auto)
  - updated_at: timestamp (auto)

projects:
  - name: string (required)
  - description: text (nullable)
  - org_id: uuid (references organizations, required)
  - created_by: uuid (references users, required)
  - status: enum(active, archived) (default: active)
  - created_at: timestamp (auto)
  - updated_at: timestamp (auto)

subscriptions:
  - org_id: uuid (references organizations, required, unique)
  - stripe_subscription_id: string (unique, required)
  - plan_id: string (required)
  - status: enum(active, canceled, past_due, trialing)
  - current_period_end: timestamp
  - created_at: timestamp (auto)
  - updated_at: timestamp (auto)
```

**Click "Generate & Deploy"**

Apso will:
1. Create PostgreSQL database with tables
2. Generate NestJS REST API with endpoints:
   - `GET/POST /organizations`
   - `GET/PUT/DELETE /organizations/:id`
   - `GET/POST /users`
   - `GET/PUT/DELETE /users/:id`
   - `GET/POST /projects`
   - `GET/PUT/DELETE /projects/:id`
   - (same pattern for subscriptions)
3. Deploy to AWS (Lambda + API Gateway + RDS)
4. Generate OpenAPI documentation

**Result:** You'll get:
- API Base URL: `https://api.staging.apso.cloud/my-saas-api/dev`
- OpenAPI Docs: `https://api.staging.apso.cloud/my-saas-api/dev/docs`
- Database connection string (for Better Auth setup)

#### Step 2: Test Your API

```bash
# Get all organizations
curl https://api.staging.apso.cloud/my-saas-api/dev/organizations

# Create an organization
curl -X POST https://api.staging.apso.cloud/my-saas-api/dev/organizations \
  -H "Content-Type: application/json" \
  -d '{"name": "Acme Corp", "slug": "acme"}'

# Get by ID
curl https://api.staging.apso.cloud/my-saas-api/dev/organizations/[id]
```

**Note:** At this point, the API is open. We'll add auth in the next step.

---

### Week 3-4: Frontend Setup

#### Step 1: Create Next.js Project

```bash
npx create-next-app@latest my-saas-app --typescript --tailwind --app --no-src-dir

cd my-saas-app
```

#### Step 2: Install Dependencies

```bash
# UI Components
npx shadcn-ui@latest init

# Better Auth
npm install better-auth

# Apso API Client (fetch wrapper)
npm install axios zod

# Forms
npm install react-hook-form @hookform/resolvers zod

# State Management (optional, for complex state)
npm install zustand
```

#### Step 3: Configure shadcn/ui

```bash
npx shadcn-ui@latest add button
npx shadcn-ui@latest add card
npx shadcn-ui@latest add input
npx shadcn-ui@latest add label
npx shadcn-ui@latest add form
npx shadcn-ui@latest add toast
npx shadcn-ui@latest add dialog
npx shadcn-ui@latest add table
npx shadcn-ui@latest add select
npx shadcn-ui@latest add badge
```

#### Step 4: Set Up Environment Variables

```bash
# .env.local
NEXT_PUBLIC_API_URL=https://api.staging.apso.cloud/my-saas-api/dev
APSO_DB_HOST=your-db-host.rds.amazonaws.com
APSO_DB_NAME=my_saas_db
APSO_DB_USER=apso_user
APSO_DB_PASSWORD=your-password
APSO_DB_PORT=5432
```

**Note:** Get database credentials from Apso dashboard

#### Step 5: Create API Client

```typescript
// lib/api-client.ts
import axios from 'axios'

const apiClient = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Add auth token to requests
apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('auth_token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

export default apiClient

// Type-safe API methods
export const api = {
  organizations: {
    list: () => apiClient.get('/organizations'),
    get: (id: string) => apiClient.get(`/organizations/${id}`),
    create: (data: any) => apiClient.post('/organizations', data),
    update: (id: string, data: any) => apiClient.put(`/organizations/${id}`, data),
    delete: (id: string) => apiClient.delete(`/organizations/${id}`),
  },
  projects: {
    list: (org_id: string) => apiClient.get('/projects', { params: { org_id } }),
    get: (id: string) => apiClient.get(`/projects/${id}`),
    create: (data: any) => apiClient.post('/projects', data),
    update: (id: string, data: any) => apiClient.put(`/projects/${id}`, data),
    delete: (id: string) => apiClient.delete(`/projects/${id}`),
  },
  // Add more as needed
}
```

---

### Week 5-6: Authentication with Better Auth

#### Step 1: Install Better Auth CLI

```bash
npm install -D @better-auth/cli
```

#### Step 2: Configure Better Auth

```typescript
// lib/auth.ts
import { betterAuth } from "better-auth"
import { pgAdapter } from "better-auth/adapters/postgres"

export const auth = betterAuth({
  database: pgAdapter({
    host: process.env.APSO_DB_HOST!,
    database: process.env.APSO_DB_NAME!,
    user: process.env.APSO_DB_USER!,
    password: process.env.APSO_DB_PASSWORD!,
    port: parseInt(process.env.APSO_DB_PORT!),
    ssl: {
      rejectUnauthorized: false, // For AWS RDS
    },
  }),

  emailAndPassword: {
    enabled: true,
    requireEmailVerification: true,
  },

  socialProviders: {
    google: {
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    },
    github: {
      clientId: process.env.GITHUB_CLIENT_ID!,
      clientSecret: process.env.GITHUB_CLIENT_SECRET!,
    },
  },

  session: {
    expiresIn: 60 * 60 * 24 * 7, // 7 days
    updateAge: 60 * 60 * 24, // 1 day
  },

  user: {
    additionalFields: {
      org_id: {
        type: "string",
        required: false,
      },
      role: {
        type: "string",
        required: false,
      },
    },
  },
})
```

#### Step 3: Generate Auth Tables

```bash
npx better-auth generate
```

This creates tables in Apso's PostgreSQL:
- `users` (id, email, emailVerified, name, image, createdAt, updatedAt)
- `sessions` (id, userId, expiresAt, token, ipAddress, userAgent, createdAt, updatedAt)
- `accounts` (id, userId, provider, providerAccountId, access_token, refresh_token, expires_at, token_type, scope, id_token, session_state)
- `verificationTokens` (identifier, token, expires)

#### Step 4: Create Auth API Route

```typescript
// app/api/auth/[...all]/route.ts
import { auth } from "@/lib/auth"
import { toNextJsHandler } from "better-auth/next-js"

export const { GET, POST } = toNextJsHandler(auth)
```

#### Step 5: Create Auth Client (Frontend)

```typescript
// lib/auth-client.ts
import { createAuthClient } from "better-auth/react"

export const authClient = createAuthClient({
  baseURL: process.env.NEXT_PUBLIC_APP_URL!,
})

export const {
  signIn,
  signUp,
  signOut,
  useSession,
  resetPassword,
  sendVerificationEmail,
} = authClient
```

#### Step 6: Build Login Page

```typescript
// app/login/page.tsx
"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { signIn } from "@/lib/auth-client"
import { toast } from "@/components/ui/use-toast"

export default function LoginPage() {
  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const [loading, setLoading] = useState(false)
  const router = useRouter()

  async function handleEmailLogin(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)

    try {
      const result = await signIn.email({
        email,
        password,
      })

      if (result.error) {
        toast({
          title: "Error",
          description: result.error.message,
          variant: "destructive",
        })
      } else {
        toast({
          title: "Success",
          description: "Logged in successfully",
        })
        router.push("/dashboard")
      }
    } catch (error) {
      toast({
        title: "Error",
        description: "Something went wrong",
        variant: "destructive",
      })
    } finally {
      setLoading(false)
    }
  }

  async function handleGoogleLogin() {
    await signIn.social({
      provider: "google",
      callbackURL: "/dashboard",
    })
  }

  return (
    <div className="flex min-h-screen items-center justify-center">
      <Card className="w-full max-w-md">
        <CardHeader>
          <CardTitle>Log in</CardTitle>
          <CardDescription>Enter your credentials to continue</CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleEmailLogin} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="email">Email</Label>
              <Input
                id="email"
                type="email"
                placeholder="you@example.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="password">Password</Label>
              <Input
                id="password"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
              />
            </div>
            <Button type="submit" className="w-full" disabled={loading}>
              {loading ? "Loading..." : "Log in"}
            </Button>
          </form>

          <div className="relative my-4">
            <div className="absolute inset-0 flex items-center">
              <span className="w-full border-t" />
            </div>
            <div className="relative flex justify-center text-xs uppercase">
              <span className="bg-background px-2 text-muted-foreground">Or continue with</span>
            </div>
          </div>

          <Button
            variant="outline"
            className="w-full"
            onClick={handleGoogleLogin}
          >
            <svg className="mr-2 h-4 w-4" viewBox="0 0 24 24">
              {/* Google icon SVG */}
            </svg>
            Google
          </Button>
        </CardContent>
        <CardFooter className="flex flex-col space-y-2">
          <a href="/forgot-password" className="text-sm text-muted-foreground hover:underline">
            Forgot password?
          </a>
          <p className="text-sm text-muted-foreground">
            Don't have an account?{" "}
            <a href="/signup" className="underline">
              Sign up
            </a>
          </p>
        </CardFooter>
      </Card>
    </div>
  )
}
```

#### Step 7: Build Signup Page

```typescript
// app/signup/page.tsx
"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { signUp } from "@/lib/auth-client"
import { toast } from "@/components/ui/use-toast"
import { api } from "@/lib/api-client"

export default function SignupPage() {
  const [name, setName] = useState("")
  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const [orgName, setOrgName] = useState("")
  const [loading, setLoading] = useState(false)
  const router = useRouter()

  async function handleSignup(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)

    try {
      // 1. Create organization in Apso
      const orgResponse = await api.organizations.create({
        name: orgName,
        slug: orgName.toLowerCase().replace(/\s+/g, '-'),
      })

      const org = orgResponse.data

      // 2. Create user with Better Auth
      const result = await signUp.email({
        email,
        password,
        name,
        callbackURL: "/dashboard",
      })

      if (result.error) {
        toast({
          title: "Error",
          description: result.error.message,
          variant: "destructive",
        })
        return
      }

      // 3. Link user to organization in Apso
      const userId = result.data?.user?.id
      if (userId) {
        await api.users.create({
          id: userId, // Use Better Auth user ID
          email,
          name,
          org_id: org.id,
          role: "admin", // First user is admin
        })
      }

      toast({
        title: "Success",
        description: "Account created! Please check your email to verify.",
      })

      router.push("/verify-email")
    } catch (error: any) {
      toast({
        title: "Error",
        description: error.message || "Something went wrong",
        variant: "destructive",
      })
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="flex min-h-screen items-center justify-center">
      <Card className="w-full max-w-md">
        <CardHeader>
          <CardTitle>Create an account</CardTitle>
          <CardDescription>Get started with your free trial</CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSignup} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="org-name">Organization Name</Label>
              <Input
                id="org-name"
                type="text"
                placeholder="Acme Corp"
                value={orgName}
                onChange={(e) => setOrgName(e.target.value)}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="name">Your Name</Label>
              <Input
                id="name"
                type="text"
                placeholder="John Doe"
                value={name}
                onChange={(e) => setName(e.target.value)}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="email">Email</Label>
              <Input
                id="email"
                type="email"
                placeholder="you@example.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="password">Password</Label>
              <Input
                id="password"
                type="password"
                placeholder="••••••••"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                minLength={8}
              />
              <p className="text-xs text-muted-foreground">
                At least 8 characters
              </p>
            </div>
            <Button type="submit" className="w-full" disabled={loading}>
              {loading ? "Creating account..." : "Create account"}
            </Button>
          </form>
        </CardContent>
        <CardFooter>
          <p className="text-sm text-muted-foreground">
            Already have an account?{" "}
            <a href="/login" className="underline">
              Log in
            </a>
          </p>
        </CardFooter>
      </Card>
    </div>
  )
}
```

#### Step 8: Create Protected Route Middleware

```typescript
// middleware.ts
import { NextResponse } from "next/server"
import type { NextRequest } from "next/server"
import { auth } from "@/lib/auth"

export async function middleware(request: NextRequest) {
  const pathname = request.nextUrl.pathname

  // Public routes
  const publicRoutes = ["/login", "/signup", "/forgot-password", "/verify-email"]
  if (publicRoutes.includes(pathname)) {
    return NextResponse.next()
  }

  // Check session
  const session = await auth.api.getSession({
    headers: request.headers,
  })

  if (!session) {
    const loginUrl = new URL("/login", request.url)
    loginUrl.searchParams.set("from", pathname)
    return NextResponse.redirect(loginUrl)
  }

  // Add user info to headers for API routes
  const requestHeaders = new Headers(request.headers)
  requestHeaders.set("x-user-id", session.user.id)
  requestHeaders.set("x-user-email", session.user.email)

  return NextResponse.next({
    request: {
      headers: requestHeaders,
    },
  })
}

export const config = {
  matcher: [
    "/((?!api|_next/static|_next/image|favicon.ico).*)",
  ],
}
```

#### Step 9: Create Session Hook

```typescript
// hooks/use-session.ts
"use client"

import { useSession as useBetterAuthSession } from "@/lib/auth-client"
import { useEffect, useState } from "react"
import { api } from "@/lib/api-client"

interface UserWithOrg {
  id: string
  email: string
  name: string | null
  org_id: string
  role: string
  organization: {
    id: string
    name: string
    slug: string
  }
}

export function useSession() {
  const session = useBetterAuthSession()
  const [user, setUser] = useState<UserWithOrg | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function loadUser() {
      if (session.data?.user) {
        try {
          // Get full user data from Apso (includes org_id, role)
          const response = await api.users.get(session.data.user.id)
          setUser(response.data)
        } catch (error) {
          console.error("Failed to load user data:", error)
        }
      }
      setLoading(false)
    }

    loadUser()
  }, [session.data?.user])

  return {
    user,
    session: session.data,
    loading: loading || session.isPending,
  }
}
```

---

### Week 7-8: Core Product Features

#### Build Dashboard

```typescript
// app/dashboard/page.tsx
"use client"

import { useEffect, useState } from "react"
import { useSession } from "@/hooks/use-session"
import { api } from "@/lib/api-client"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Plus } from "lucide-react"

export default function DashboardPage() {
  const { user, loading } = useSession()
  const [projects, setProjects] = useState([])

  useEffect(() => {
    if (user?.org_id) {
      loadProjects()
    }
  }, [user])

  async function loadProjects() {
    try {
      const response = await api.projects.list(user!.org_id)
      setProjects(response.data)
    } catch (error) {
      console.error("Failed to load projects:", error)
    }
  }

  if (loading) {
    return <div>Loading...</div>
  }

  return (
    <div className="container mx-auto py-8">
      <div className="flex justify-between items-center mb-8">
        <div>
          <h1 className="text-3xl font-bold">Projects</h1>
          <p className="text-muted-foreground">
            {user?.organization.name}
          </p>
        </div>
        <Button>
          <Plus className="mr-2 h-4 w-4" />
          New Project
        </Button>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        {projects.map((project: any) => (
          <Card key={project.id}>
            <CardHeader>
              <CardTitle>{project.name}</CardTitle>
              <CardDescription>{project.description}</CardDescription>
            </CardHeader>
            <CardContent>
              <p className="text-sm text-muted-foreground">
                Created {new Date(project.created_at).toLocaleDateString()}
              </p>
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  )
}
```

**Continue building CRUD interfaces for all your core resources using the same pattern.**

---

### Week 9-10: Stripe Integration

#### Step 1: Set Up Stripe

```bash
npm install stripe @stripe/stripe-js
```

#### Step 2: Create Stripe Checkout Session

```typescript
// app/api/checkout/route.ts
import { NextRequest, NextResponse } from "next/server"
import Stripe from "stripe"
import { auth } from "@/lib/auth"
import { api } from "@/lib/api-client"

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: "2023-10-16",
})

export async function POST(request: NextRequest) {
  // Get session
  const session = await auth.api.getSession({
    headers: request.headers,
  })

  if (!session) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 })
  }

  const { priceId } = await request.json()

  // Get user's org
  const userResponse = await api.users.get(session.user.id)
  const user = userResponse.data

  // Create or get Stripe customer
  let customerId = user.organization.stripe_customer_id

  if (!customerId) {
    const customer = await stripe.customers.create({
      email: user.email,
      name: user.organization.name,
      metadata: {
        org_id: user.org_id,
      },
    })
    customerId = customer.id

    // Save customer ID in Apso
    await api.organizations.update(user.org_id, {
      stripe_customer_id: customerId,
    })
  }

  // Create checkout session
  const checkoutSession = await stripe.checkout.sessions.create({
    customer: customerId,
    line_items: [
      {
        price: priceId,
        quantity: 1,
      },
    ],
    mode: "subscription",
    success_url: `${process.env.NEXT_PUBLIC_APP_URL}/dashboard?success=true`,
    cancel_url: `${process.env.NEXT_PUBLIC_APP_URL}/pricing`,
    metadata: {
      org_id: user.org_id,
    },
  })

  return NextResponse.json({ url: checkoutSession.url })
}
```

#### Step 3: Handle Stripe Webhooks

```typescript
// app/api/webhooks/stripe/route.ts
import { NextRequest, NextResponse } from "next/server"
import Stripe from "stripe"
import { api } from "@/lib/api-client"

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: "2023-10-16",
})

const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET!

export async function POST(request: NextRequest) {
  const body = await request.text()
  const signature = request.headers.get("stripe-signature")!

  let event: Stripe.Event

  try {
    event = stripe.webhooks.constructEvent(body, signature, webhookSecret)
  } catch (err: any) {
    return NextResponse.json({ error: err.message }, { status: 400 })
  }

  // Handle events
  switch (event.type) {
    case "checkout.session.completed":
      const session = event.data.object as Stripe.Checkout.Session
      await handleCheckoutCompleted(session)
      break

    case "customer.subscription.updated":
    case "customer.subscription.deleted":
      const subscription = event.data.object as Stripe.Subscription
      await handleSubscriptionChange(subscription)
      break

    default:
      console.log(`Unhandled event type ${event.type}`)
  }

  return NextResponse.json({ received: true })
}

async function handleCheckoutCompleted(session: Stripe.Checkout.Session) {
  const subscriptionId = session.subscription as string
  const orgId = session.metadata?.org_id

  if (!orgId) return

  // Get subscription details
  const subscription = await stripe.subscriptions.retrieve(subscriptionId)

  // Save subscription in Apso
  await api.subscriptions.create({
    org_id: orgId,
    stripe_subscription_id: subscriptionId,
    plan_id: subscription.items.data[0].price.id,
    status: subscription.status,
    current_period_end: new Date(subscription.current_period_end * 1000),
  })
}

async function handleSubscriptionChange(subscription: Stripe.Subscription) {
  // Update subscription in Apso
  await api.subscriptions.update(subscription.id, {
    status: subscription.status,
    current_period_end: new Date(subscription.current_period_end * 1000),
  })
}
```

---

### Week 11-12: Polish & Deploy

#### Add Error Tracking (Sentry)

```bash
npm install @sentry/nextjs
npx @sentry/wizard@latest -i nextjs
```

#### Add Analytics (PostHog)

```bash
npm install posthog-js
```

```typescript
// lib/posthog.ts
import posthog from 'posthog-js'

if (typeof window !== 'undefined') {
  posthog.init(process.env.NEXT_PUBLIC_POSTHOG_KEY!, {
    api_host: 'https://app.posthog.com',
  })
}

export default posthog
```

#### Deploy to Production

1. **Deploy Frontend to Vercel:**
   ```bash
   vercel --prod
   ```

2. **Deploy Backend via Apso:**
   - Go to Apso dashboard
   - Select your service
   - Click "Deploy to Production"
   - Apso will deploy to AWS production environment

3. **Set Production Environment Variables:**
   - Vercel: Add env vars in dashboard
   - Apso: Add env vars in Apso dashboard

---

## Phase 2: Market Ready (Weeks 13-24)

### Week 13-15: Enhanced Authentication

#### Add MFA/2FA (Better Auth)

```typescript
// Update lib/auth.ts
export const auth = betterAuth({
  // ... existing config
  twoFactor: {
    enabled: true,
    issuer: "My SaaS App",
  },
})
```

#### Add Passwordless Login (Magic Links)

```typescript
// Update lib/auth.ts
export const auth = betterAuth({
  // ... existing config
  magicLink: {
    enabled: true,
    sendMagicLink: async ({ email, token, url }) => {
      // Send email via Postmark
      await sendEmail({
        to: email,
        subject: "Your magic login link",
        html: `<a href="${url}">Click here to log in</a>`,
      })
    },
  },
})
```

---

### Week 16-18: Real-Time Notifications

#### Set Up Redis

```bash
# Sign up for Redis Cloud (free tier)
# Get connection string
```

#### Create Socket.io Server

```typescript
// server.ts (separate service or Next.js custom server)
import { Server } from "socket.io"
import { createServer } from "http"
import { Redis } from "ioredis"
import { auth } from "./lib/auth"

const httpServer = createServer()
const io = new Server(httpServer, {
  cors: {
    origin: process.env.FRONTEND_URL,
    credentials: true,
  },
})

const redis = new Redis(process.env.REDIS_URL!)
const redisSub = new Redis(process.env.REDIS_URL!)

// Subscribe to Redis channels
redisSub.subscribe("notifications")

// Forward Redis messages to Socket.io
redisSub.on("message", (channel, message) => {
  const notification = JSON.parse(message)
  io.to(`user:${notification.userId}`).emit("notification", notification)
})

// Authenticate connections
io.use(async (socket, next) => {
  const token = socket.handshake.auth.token

  try {
    const session = await auth.api.getSession({
      headers: new Headers({
        cookie: `session=${token}`,
      }),
    })

    if (!session) {
      return next(new Error("Authentication failed"))
    }

    socket.userId = session.user.id
    socket.orgId = session.user.org_id
    next()
  } catch (err) {
    next(new Error("Authentication failed"))
  }
})

// Connection handling
io.on("connection", (socket) => {
  console.log(`User ${socket.userId} connected`)

  // Join rooms
  socket.join(`user:${socket.userId}`)
  socket.join(`org:${socket.orgId}`)

  socket.on("disconnect", () => {
    console.log(`User ${socket.userId} disconnected`)
  })
})

httpServer.listen(3001, () => {
  console.log("Socket.io server listening on port 3001")
})
```

#### Publish Notifications from Apso

When something happens in your Apso backend (e.g., a project is created), publish to Redis:

```typescript
// In your Apso custom endpoint or webhook
import { Redis } from "ioredis"

const redis = new Redis(process.env.REDIS_URL!)

async function notifyUser(userId: string, notification: any) {
  await redis.publish("notifications", JSON.stringify({
    userId,
    ...notification,
  }))
}

// Example: When a project is created
await notifyUser(project.created_by, {
  type: "project_created",
  title: "Project created",
  message: `${project.name} was created successfully`,
})
```

---

### Week 19-21: Audit Logging

Add to Apso schema:

```
audit_logs:
  - user_id: uuid (references users, required)
  - org_id: uuid (references organizations, required)
  - action: enum(create, update, delete) (required)
  - resource_type: string (required)
  - resource_id: uuid (required)
  - old_values: jsonb (nullable)
  - new_values: jsonb (nullable)
  - ip_address: string (nullable)
  - user_agent: string (nullable)
  - created_at: timestamp (auto, immutable)
```

**Note:** Mark `created_at` as immutable in Apso to prevent edits.

---

## Key Implementation Patterns

### 1. Multi-Tenancy Enforcement

**Always filter by org_id:**

```typescript
// Good ✅
const projects = await api.projects.list(user.org_id)

// Bad ❌ - could leak data across orgs
const projects = await api.projects.list()
```

### 2. RBAC Checks

```typescript
// middleware to check permissions
function requireRole(role: string) {
  return async (request: NextRequest) => {
    const user = await getCurrentUser(request)

    if (user.role !== role && user.role !== "admin") {
      return new Response("Forbidden", { status: 403 })
    }

    return NextResponse.next()
  }
}

// Use in API routes
export const DELETE = requireRole("admin")(async (request) => {
  // Only admins can access
})
```

### 3. Error Handling

```typescript
// Centralized error handling
export async function apiCall<T>(fn: () => Promise<T>): Promise<T> {
  try {
    return await fn()
  } catch (error: any) {
    // Log to Sentry
    Sentry.captureException(error)

    // Show user-friendly message
    toast({
      title: "Error",
      description: error.message || "Something went wrong",
      variant: "destructive",
    })

    throw error
  }
}

// Usage
const projects = await apiCall(() => api.projects.list(orgId))
```

---

## Summary: What Apso Provides vs. What You Build

### Apso Provides (Automatic)
✅ PostgreSQL database with schema
✅ REST API (CRUD for all resources)
✅ OpenAPI documentation
✅ AWS deployment (Lambda, RDS, API Gateway)
✅ Environment management (dev, staging, prod)
✅ CloudWatch logging
✅ Auto-scaling infrastructure

### You Build (Custom)
✅ Frontend UI/UX (Next.js + Tailwind + shadcn)
✅ Authentication flows (using Better Auth)
✅ Payment flows (using Stripe)
✅ Real-time features (Socket.io if needed)
✅ Business logic (specific to your product)
✅ Workflow automation (if needed)
✅ AI features (using OpenAI/Claude)

### Result
- **10x faster** than building from scratch
- **Production-ready** from day one
- **Focus on product**, not infrastructure
- **MVP in 12 weeks** instead of 6-12 months

---

**Last Updated:** 2025-01-10
**Next:** See SAAS_TECH_STACK.md for complete tech stack details
