# E2E Test Mode Pattern

**Source:** GoLotus Project Build (January 2026)
**Purpose:** Allow development and testing without authentication during early phases

---

## When to Use

Use E2E test mode during **Phases 1-4** of screens-first development:
- Phase 1: Foundation & Layout
- Phase 2: All Screens (mock data)
- Phase 3: Backend Schema & API
- Phase 4: Billing & Payments

**Remove all test mode code in Phase 5 (Authentication).**

---

## Implementation

### 1. Environment Variables

```bash
# .env.local (Next.js frontend)
NEXT_PUBLIC_E2E_TEST_MODE=true
E2E_TEST_MODE=true
```

### 2. Middleware Bypass

```typescript
// src/middleware.ts
import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

export function middleware(request: NextRequest) {
  // Check for test mode
  const isTestMode = process.env.NEXT_PUBLIC_E2E_TEST_MODE === "true"
    || process.env.E2E_TEST_MODE === "true";

  if (isTestMode) {
    // Skip auth in test mode
    return NextResponse.next();
  }

  // Normal auth flow here...
  // Redirect to login if not authenticated
}

export const config = {
  matcher: [
    "/((?!api|_next/static|_next/image|favicon.ico|login|register).*)",
  ],
};
```

### 3. Test Context Provider

Create a context provider for test user/organization switching:

```typescript
// src/contexts/test-context.tsx
"use client";

import * as React from "react";

interface TestUser {
  id: string;
  email: string;
  first_name: string;
  last_name: string;
  role: string;
}

interface TestOrganization {
  id: string;
  name: string;
}

interface TestContextType {
  isTestMode: boolean;
  currentUser: TestUser | null;
  currentOrganization: TestOrganization | null;
  testUsers: TestUser[];
  setCurrentUser: (user: TestUser) => void;
}

const TestContext = React.createContext<TestContextType | null>(null);

export function TestContextProvider({ children }: { children: React.ReactNode }) {
  const isTestMode = process.env.NEXT_PUBLIC_E2E_TEST_MODE === "true";

  const [testUsers, setTestUsers] = React.useState<TestUser[]>([]);
  const [currentOrganization, setCurrentOrganization] = React.useState<TestOrganization | null>(null);
  const [currentUser, setCurrentUser] = React.useState<TestUser | null>(null);

  // Fetch test organization and users on mount
  React.useEffect(() => {
    if (!isTestMode) return;

    async function fetchTestData() {
      try {
        // Fetch organization
        const orgRes = await fetch("/api/organizations");
        const orgs = await orgRes.json();
        if (orgs.data?.[0]) {
          setCurrentOrganization(orgs.data[0]);
        }

        // Fetch users
        const usersRes = await fetch("/api/users");
        const users = await usersRes.json();
        setTestUsers(users.data || []);

        // Set default user (admin)
        const admin = users.data?.find((u: TestUser) => u.role === "admin");
        if (admin) {
          setCurrentUser(admin);
        } else if (users.data?.[0]) {
          setCurrentUser(users.data[0]);
        }
      } catch (error) {
        console.error("Failed to fetch test data:", error);
      }
    }

    fetchTestData();
  }, [isTestMode]);

  if (!isTestMode) {
    return <>{children}</>;
  }

  return (
    <TestContext.Provider
      value={{
        isTestMode,
        currentUser,
        currentOrganization,
        testUsers,
        setCurrentUser,
      }}
    >
      {children}
    </TestContext.Provider>
  );
}

export function useTestContext() {
  const context = React.useContext(TestContext);
  if (!context) {
    throw new Error("useTestContext must be used within TestContextProvider");
  }
  return context;
}
```

### 4. API Client with Test Headers

Configure API client to send test user/org headers:

```typescript
// src/lib/api/client.ts
import { useTestContext } from "@/contexts/test-context";

export function useApiClient() {
  const { currentUser, currentOrganization, isTestMode } = useTestContext();

  const headers: Record<string, string> = {
    "Content-Type": "application/json",
  };

  if (isTestMode && currentOrganization) {
    headers["X-Organization-Id"] = currentOrganization.id;
  }

  if (isTestMode && currentUser) {
    headers["X-User-Id"] = currentUser.id;
  }

  return {
    get: (url: string) => fetch(url, { headers }),
    post: (url: string, body: unknown) =>
      fetch(url, { method: "POST", headers, body: JSON.stringify(body) }),
    put: (url: string, body: unknown) =>
      fetch(url, { method: "PUT", headers, body: JSON.stringify(body) }),
    delete: (url: string) =>
      fetch(url, { method: "DELETE", headers }),
  };
}
```

### 5. Test User Switcher Component

Add UI to switch between test users:

```typescript
// src/components/test-user-switcher.tsx
"use client";

import { useTestContext } from "@/contexts/test-context";

export function TestUserSwitcher() {
  const { isTestMode, currentUser, testUsers, setCurrentUser, currentOrganization } = useTestContext();

  if (!isTestMode) return null;

  return (
    <div className="fixed bottom-4 right-4 z-50 rounded-lg border bg-yellow-50 p-4 shadow-lg">
      <div className="mb-2 text-xs font-semibold text-yellow-800">
        E2E TEST MODE
      </div>

      <div className="text-xs text-yellow-700 mb-2">
        Org: {currentOrganization?.name || "None"}
      </div>

      <select
        value={currentUser?.id || ""}
        onChange={(e) => {
          const user = testUsers.find((u) => u.id === e.target.value);
          if (user) setCurrentUser(user);
        }}
        className="w-full text-sm border rounded px-2 py-1"
      >
        {testUsers.map((user) => (
          <option key={user.id} value={user.id}>
            {user.first_name} {user.last_name} ({user.role})
          </option>
        ))}
      </select>
    </div>
  );
}
```

### 6. Add to Layout

```typescript
// src/app/layout.tsx
import { TestContextProvider } from "@/contexts/test-context";
import { TestUserSwitcher } from "@/components/test-user-switcher";

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <TestContextProvider>
          {children}
          <TestUserSwitcher />
        </TestContextProvider>
      </body>
    </html>
  );
}
```

---

## Removal Checklist (Phase 5)

When implementing real authentication, remove:

- [ ] `NEXT_PUBLIC_E2E_TEST_MODE` from `.env.local`
- [ ] `E2E_TEST_MODE` from `.env.local`
- [ ] Test mode bypass in `middleware.ts`
- [ ] `src/contexts/test-context.tsx`
- [ ] `src/components/test-user-switcher.tsx`
- [ ] Test header logic in API client
- [ ] TestContextProvider from layout

---

## Benefits

1. **Faster iteration** - No login flow during development
2. **Easy testing** - Switch users with one click
3. **Real data** - Uses seeded database, not mock data
4. **Role testing** - Test different permission levels
5. **Clean removal** - All test code is isolated

---

**Last Updated:** 2026-01-15
