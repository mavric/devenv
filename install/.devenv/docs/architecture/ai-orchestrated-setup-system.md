# AI-Orchestrated Setup System Architecture

> Replacing brittle shell scripts with intelligent, adaptive, self-healing AI skills

**Version:** 1.0
**Date:** 2025-01-18
**Status:** Design Document - Ready for Implementation

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [The Problem with Shell Scripts](#the-problem-with-shell-scripts)
3. [AI-First Solution](#ai-first-solution)
4. [System Architecture](#system-architecture)
5. [Skill Design](#skill-design)
6. [Orchestration Strategy](#orchestration-strategy)
7. [Error Handling & Recovery](#error-handling--recovery)
8. [Progress Tracking & Resumability](#progress-tracking--resumability)
9. [Implementation Plan](#implementation-plan)
10. [Success Metrics](#success-metrics)

---

## Executive Summary

Traditional setup scripts are brittle, platform-specific, and fail ungracefully. This design replaces them with **AI-orchestrated skills** that are:

- **Intelligent**: Understand context, adapt to edge cases
- **Self-healing**: Detect and fix common issues automatically
- **Cross-platform**: Work on any OS without conditional logic
- **Resumable**: Continue from failures without starting over
- **Self-documenting**: Explain what they're doing and why

**Key Innovation:** Instead of scripting commands, we orchestrate AI skills that understand *what* needs to be accomplished and figure out *how* based on the environment.

---

## The Problem with Shell Scripts

### Current Approach: `setup.sh`

```bash
#!/bin/bash
set -e

# What happens on Windows? What about when Docker isn't installed?
# What if port 5433 is taken? What if Node version is wrong?

echo "Creating backend..."
mkdir backend && cd backend

# Fails if directory exists
# No way to resume

npx apso init
# What if npx fails? What if network is slow?
# Script just dies

npm install
# What if npm install fails halfway?
# Start from scratch again

docker-compose up -d
# What if Docker isn't running?
# What if port is taken?
# Script can't fix this

apso server
# What if this generates broken code?
# Script can't detect or fix

npm run start:dev
# What if database isn't ready?
# What if there are TypeScript errors?
# Script exits, user is stuck
```

### Problems

1. **Zero Intelligence**: Can't adapt to environment variations
2. **Brittle**: One failure = entire script fails
3. **Platform-Specific**: Doesn't work on Windows/Linux/macOS equally
4. **Not Resumable**: Must start from scratch after failures
5. **Poor Error Messages**: "Command failed" doesn't help users
6. **No Self-Healing**: Can't detect or fix common issues
7. **Outdated Quickly**: Dependencies change, script breaks

---

## AI-First Solution

### Key Insight

Instead of:
```bash
# Tell the computer EXACTLY how to do it
mkdir backend
cd backend
npx apso init
npm install
```

We do:
```markdown
# Tell AI WHAT to accomplish
You are setting up an Apso backend with BetterAuth integration.

Environment: macOS, Node 20, Docker available
Goal: Working API at localhost:3001 with auth tables in database

Steps to accomplish:
1. Initialize Apso project
2. Configure .apsorc with auth entities
3. Generate code
4. Fix common integration issues
5. Start database
6. Run backend
7. Verify all endpoints work

Use your judgment to handle edge cases.
```

The AI skill:
- Detects the OS and uses appropriate commands
- Checks prerequisites before starting
- Handles errors intelligently
- Fixes known issues automatically
- Verifies success at each step
- Explains what it's doing

---

## System Architecture

### Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    Master Orchestrator Skill                     │
│              (saas-project-setup or apso-betterauth-setup)       │
│                                                                   │
│  Responsibilities:                                               │
│  • Coordinate all sub-skills                                     │
│  • Maintain global state (TodoWrite)                             │
│  • Handle cross-phase dependencies                               │
│  • Provide progress updates                                      │
│  • Implement checkpoint/resume logic                             │
└───────────────────────────┬─────────────────────────────────────┘
                            │
            ┌───────────────┼───────────────┐
            │               │               │
            ▼               ▼               ▼
┌───────────────────┐  ┌───────────────┐  ┌──────────────────┐
│  setup-backend    │  │setup-frontend │  │verify-setup      │
│                   │  │               │  │                  │
│  Phase 1          │  │  Phase 2      │  │  Phase 3         │
│  • Check prereqs  │  │  • Next.js    │  │  • Health checks │
│  • Create Apso    │  │  • Auth client│  │  • Test flows    │
│  • Generate code  │  │  • Components │  │  • Diagnostics   │
│  • Fix issues     │  │  • Config     │  │  • Fix detected  │
│  • Start services │  │  • Verify     │  │    issues        │
└───────────────────┘  └───────────────┘  └──────────────────┘
            │               │               │
            └───────────────┼───────────────┘
                            ▼
                ┌───────────────────────┐
                │ configure-database    │
                │                       │
                │ Shared Utility        │
                │ • PostgreSQL setup    │
                │ • Migrations          │
                │ • Seeding             │
                │ • Connection tests    │
                └───────────────────────┘
                            │
                            ▼
                ┌───────────────────────┐
                │ fix-common-issues     │
                │                       │
                │ Self-Healing Module   │
                │ • Detect problems     │
                │ • Apply known fixes   │
                │ • Verify fix worked   │
                │ • Report to user      │
                └───────────────────────┘
```

### Skill Hierarchy

**Level 1: Master Orchestrator**
- Single entry point for users
- Manages TodoWrite for entire setup
- Calls Level 2 skills in sequence
- Handles failures and retries

**Level 2: Phase Skills**
- Self-contained phase implementations
- Own TodoWrite for sub-tasks
- Call Level 3 utilities as needed
- Return success/failure to orchestrator

**Level 3: Utility Skills**
- Reusable across phases
- No state management
- Pure functions
- Example: database setup, issue fixing

---

## Skill Design

### 1. Master Orchestrator: `apso-betterauth-setup`

**Location:** `.claude/skills/apso-betterauth-setup/SKILL.md`

#### Skill Definition

```markdown
---
name: apso-betterauth-setup
description: Complete setup orchestrator for Apso + BetterAuth SaaS projects. Triggers when user wants to "setup project", "create SaaS backend", or "initialize Apso with auth". Coordinates all setup phases.
---

# Apso + BetterAuth Setup Orchestrator

I orchestrate the complete setup of a production-ready SaaS backend with Apso and BetterAuth.

## Operating Modes

### Interactive Mode (Default)
- Ask clarifying questions
- Present options for decisions
- Wait for approval at checkpoints
- Explain what I'm doing

### Automated Mode
- Use sensible defaults
- No approval gates (except critical decisions)
- Maximum speed
- Still explain actions

**Usage:**
- Interactive: "Setup a new SaaS project"
- Automated: "Setup a new SaaS project with defaults"

## What I Do

I coordinate these phases:

1. **Prerequisites Check** (30 seconds)
   - Node.js version
   - Docker availability
   - Port availability (3001, 5433)
   - Disk space
   - Network connectivity

2. **Backend Setup** (2-3 minutes)
   - Call `setup-backend` skill
   - Apso initialization
   - BetterAuth integration
   - Code generation
   - Auto-fix common issues

3. **Database Configuration** (1 minute)
   - Call `configure-database` skill
   - PostgreSQL via Docker
   - Schema creation
   - Initial migrations

4. **Frontend Setup** (2-3 minutes) [Optional]
   - Call `setup-frontend` skill
   - Next.js initialization
   - BetterAuth client
   - UI components

5. **Verification** (1 minute)
   - Call `verify-setup` skill
   - Health checks
   - Test auth flows
   - Generate test data

6. **Completion** (30 seconds)
   - Summary report
   - Next steps guidance
   - Troubleshooting tips

## Progress Tracking

I use TodoWrite to track progress:

```json
{
  "todos": [
    {
      "content": "Check prerequisites (Node, Docker, ports)",
      "activeForm": "Checking prerequisites",
      "status": "in_progress"
    },
    {
      "content": "Setup Apso backend with BetterAuth",
      "activeForm": "Setting up backend",
      "status": "pending"
    },
    {
      "content": "Configure PostgreSQL database",
      "activeForm": "Configuring database",
      "status": "pending"
    },
    {
      "content": "Setup Next.js frontend (optional)",
      "activeForm": "Setting up frontend",
      "status": "pending"
    },
    {
      "content": "Verify complete setup",
      "activeForm": "Verifying setup",
      "status": "pending"
    }
  ]
}
```

## Checkpoint & Resume

I create checkpoints after each phase:

**Checkpoint File:** `.setup-state.json`

```json
{
  "version": "1.0",
  "timestamp": "2025-01-18T10:30:00Z",
  "currentPhase": "backend-setup",
  "completedPhases": ["prerequisites"],
  "failedPhases": [],
  "environment": {
    "os": "darwin",
    "node": "20.10.0",
    "docker": "24.0.7"
  },
  "config": {
    "projectName": "my-saas",
    "backendPort": 3001,
    "databasePort": 5433,
    "includeFrontend": true
  },
  "artifacts": {
    "backendPath": "/Users/user/my-saas/backend",
    "apsorc": "/Users/user/my-saas/backend/.apsorc",
    "databaseUrl": "postgresql://postgres:postgres@localhost:5433/my_saas_dev"
  }
}
```

**Resume Logic:**

```typescript
if (checkpointExists()) {
  const state = loadCheckpoint();

  if (state.currentPhase === "backend-setup" && state.failedPhases.length === 0) {
    // Continue from backend setup
    await resumeFromPhase("backend-setup");
  } else if (state.failedPhases.includes("backend-setup")) {
    // Retry failed phase
    await retryPhase("backend-setup");
  }
}
```

## Error Handling

### Strategy: Progressive Escalation

1. **Auto-Fix (Level 1)**: Try known fixes automatically
2. **Retry (Level 2)**: Retry with different approach
3. **User Guidance (Level 3)**: Ask user for input
4. **Graceful Degradation (Level 4)**: Skip optional features

### Example: Database Connection Failure

```markdown
ERROR: Cannot connect to PostgreSQL at localhost:5433

Level 1 - Auto-Fix Attempt:
→ Checking if Docker is running...
→ Docker not running. Starting Docker...
→ Waiting for Docker daemon...
→ Retrying connection...
✓ Connected successfully

If Level 1 fails:

Level 2 - Retry with Alternative:
→ Trying alternative port 5434...
→ Success on port 5434
→ Updating configuration to use 5434

If Level 2 fails:

Level 3 - User Guidance:
⚠ Cannot start PostgreSQL automatically.

Options:
1. Install Docker Desktop and retry
2. Use existing PostgreSQL instance (provide connection string)
3. Skip database setup (manual setup later)

What would you like to do?

If user unavailable (automated mode):

Level 4 - Graceful Degradation:
⚠ Skipping database setup (can configure later)
→ Continuing with backend code generation...
→ You'll need to run database setup manually later
```

## Self-Healing Intelligence

I detect and fix these issues automatically:

### Backend Issues
- Missing `id` field in DTOs → Add automatically
- Nullable field constraints → Update entity definitions
- Entity naming conflicts → Rename and regenerate
- AppModule import errors → Add missing imports
- TypeScript compilation errors → Fix common patterns

### Database Issues
- Port conflicts → Try alternative ports
- Schema conflicts → Reset and recreate
- Migration errors → Detect and fix SQL
- Connection timeouts → Increase timeout and retry

### Environment Issues
- Missing .env files → Generate from templates
- Invalid secrets → Generate secure defaults
- Port collisions → Find available ports
- Permission errors → Suggest fixes with commands

## Decision Points

I'll ask for input on:

1. **Project Name**
   - Used for directory names, database name
   - Default: Current directory name

2. **Include Frontend?**
   - Yes: Full-stack setup
   - No: Backend only
   - Default: Yes

3. **Auth Providers**
   - Email/Password (always included)
   - Google OAuth
   - GitHub OAuth
   - Default: Email/Password only

4. **Sample Data**
   - Generate test users and organizations
   - Empty database
   - Default: Generate sample data

## Output

### Success Output

```markdown
✓ Setup Complete!

Your SaaS project is ready:

**Backend:**
- API: http://localhost:3001
- Docs: http://localhost:3001/api/docs
- Database: PostgreSQL (port 5433)

**Frontend:**
- App: http://localhost:3003
- Auth: BetterAuth configured

**Test Account:**
- Email: admin@example.com
- Password: admin123

**Next Steps:**

1. Start backend:
   cd backend && npm run start:dev

2. Start frontend:
   cd frontend && npm run dev

3. Open http://localhost:3003 and login

4. Read the documentation:
   - API: http://localhost:3001/api/docs
   - Setup guide: /Users/user/my-saas/README.md

**Verification:**
- ✓ Backend health check passed
- ✓ Database tables created (5 tables)
- ✓ Auth endpoints responding
- ✓ Frontend builds successfully
- ✓ End-to-end auth flow tested

Time taken: 6 minutes 42 seconds
```

### Failure Output

```markdown
⚠ Setup Incomplete

**Completed:**
- ✓ Prerequisites check
- ✓ Backend initialization
- ✓ Code generation

**Failed:**
- ✗ Database setup (port 5433 already in use)

**What happened:**
Port 5433 is being used by another PostgreSQL instance.

**How to fix:**

Option 1 - Use different port:
```bash
# Stop this setup
# Edit docker-compose.yml port to 5434
# Resume setup: "Continue setup from checkpoint"
```

Option 2 - Stop existing PostgreSQL:
```bash
docker stop $(docker ps -q --filter "publish=5433")
# Resume setup: "Continue setup from checkpoint"
```

Option 3 - Use existing database:
Provide connection string and I'll configure to use it.

**Resume command:**
"Resume setup from last checkpoint"

**Checkpoint saved:**
.setup-state.json (can manually inspect/edit)
```

## References

I consult these reference files:

- `references/setup-checklist.md` - Complete setup steps
- `references/troubleshooting/common-issues.md` - Known issues & fixes
- `references/better-auth-integration.md` - BetterAuth patterns
- `references/apsorc-templates/` - Schema templates

## Usage Examples

**Example 1: Basic Setup**
```
User: "Setup a new SaaS project"

Orchestrator:
I'll help you set up a production-ready SaaS project with Apso and BetterAuth.

First, I need to know:
1. Project name? (default: current directory)
2. Include frontend setup? (default: yes)

User: "ProjectHub" and yes

Orchestrator:
Great! Setting up ProjectHub...

[Todo 1/5] Checking prerequisites...
✓ Node.js 20.10.0 found
✓ Docker 24.0.7 running
✓ Ports 3001, 5433 available
✓ Network connection OK

[Todo 2/5] Setting up Apso backend...
→ Creating backend directory
→ Running apso init
→ Generating BetterAuth schema
→ Running apso server
→ Auto-fixing DTO id fields
→ Verifying code generation
✓ Backend code generated

[Todo 3/5] Configuring database...
→ Starting PostgreSQL container
→ Creating database: projecthub_dev
→ Running migrations
→ Verifying tables created
✓ Database ready (5 tables)

[Todo 4/5] Setting up Next.js frontend...
→ Creating frontend directory
→ Installing dependencies
→ Configuring BetterAuth client
→ Creating base components
✓ Frontend ready

[Todo 5/5] Verifying setup...
→ Testing backend health
→ Testing auth endpoints
→ Testing frontend build
→ Creating test user
✓ All checks passed

Setup complete! (6m 42s)
```

**Example 2: Resume from Failure**
```
User: "Setup a new SaaS project"

[Setup starts, fails at database step due to port conflict]

Orchestrator:
⚠ Setup failed at database configuration.

Issue: Port 5433 already in use
Checkpoint saved to: .setup-state.json

You can:
1. Fix the issue and resume
2. Start fresh with different config

User: [stops existing PostgreSQL]

User: "Resume setup from checkpoint"

Orchestrator:
Resuming setup from checkpoint...

Completed phases: prerequisites, backend-setup
Resuming from: database-configuration

[Todo 3/5] Configuring database...
→ Port 5433 now available
→ Starting PostgreSQL container
→ Creating database: my_saas_dev
✓ Database ready

[Continues with remaining phases]
```

**Example 3: Automated Mode**
```
User: "Setup new SaaS project with all defaults"

Orchestrator:
Running automated setup with defaults...

Project: my-saas
Frontend: included
Auth: email/password
Sample data: yes

[Runs all phases without approval gates]

✓ Complete (5m 12s)
```

## Integration with Existing Skills

I call these existing skills:

- `backend-bootstrapper` → For Phase 2
- `schema-architect` → If user needs schema design first
- `fix-common-issues` → Throughout (auto-healing)

## Success Criteria

Setup is successful when:

- [ ] Backend server responds at localhost:3001
- [ ] Database has all expected tables
- [ ] GET /Users returns 200
- [ ] POST /Users creates user
- [ ] Frontend builds without errors (if included)
- [ ] Auth flow works end-to-end
- [ ] No TypeScript errors
- [ ] No console errors

## Failure Recovery

If setup fails:
1. Save checkpoint with detailed state
2. Provide clear error message
3. Suggest specific fixes
4. Offer resume capability
5. Allow manual intervention
```

---

### 2. Phase Skill: `setup-backend`

**Location:** `.claude/skills/setup-backend/SKILL.md`

#### Skill Definition

```markdown
---
name: setup-backend
description: Sets up Apso backend with BetterAuth integration. Called by orchestrator or standalone. Handles initialization, code generation, and auto-fixing.
---

# Backend Setup Skill

I create a production-ready Apso backend with BetterAuth integration.

## What I Do

1. **Initialize Apso Project**
   - Create backend directory
   - Run `npx apso init`
   - Install dependencies

2. **Configure Schema**
   - Create `.apsorc` with BetterAuth entities
   - Add business entities (if provided)
   - Configure multi-tenancy

3. **Generate Code**
   - Run `apso server`
   - Generate REST API
   - Generate TypeORM entities
   - Generate DTOs

4. **Auto-Fix Issues**
   - Add `id` fields to create DTOs
   - Set nullable fields correctly
   - Fix AppModule imports
   - Verify compilation

5. **Configure Environment**
   - Create `.env.development`
   - Generate secrets
   - Set CORS origins

6. **Start Server**
   - Start development server
   - Verify server responds
   - Test health endpoint

## Intelligence Features

### Prerequisite Detection

Before starting, I check:

```typescript
const prerequisites = {
  node: await checkNodeVersion(), // >= 18
  npm: await checkNpmVersion(),   // >= 9
  apso: await checkApsoInstalled(), // Can install if missing
  disk: await checkDiskSpace(),   // >= 500MB
  ports: await checkPortsAvailable([3001, 5433])
};

if (!prerequisites.node.satisfied) {
  return {
    error: "Node.js 18+ required",
    current: prerequisites.node.version,
    fix: "Install Node.js from https://nodejs.org or use nvm"
  };
}
```

### Schema Intelligence

I detect entity conflicts:

```typescript
// BAD: Conflicts with BetterAuth
{
  "entities": {
    "Account": {...},  // ← Conflict!
    "Session": {...}   // ← Conflict!
  }
}

// GOOD: I auto-rename
{
  "entities": {
    "Organization": {...},  // Renamed from Account
    "DiscoverySession": {...}  // Renamed from Session
  }
}
```

### Auto-Fix Patterns

**Pattern 1: Missing DTO ID**

```typescript
// Generated (broken)
export class UserCreate {
  @ApiProperty()
  @IsEmail()
  email: string;
  // ... missing id
}

// I fix it automatically
export class UserCreate {
  @ApiProperty()
  @IsUUID()
  id: string;  // ← Added

  @ApiProperty()
  @IsEmail()
  email: string;
}
```

**Pattern 2: Nullable Fields**

```typescript
// User.entity.ts (needs nullable for OAuth)
@Column()  // ← Wrong: will fail on OAuth signup
avatar_url: string;

// I fix it
@Column({ nullable: true })  // ← Correct
avatar_url: string;
```

### Port Intelligence

If port is taken:

```typescript
async function findAvailablePort(preferred: number): Promise<number> {
  if (await isPortAvailable(preferred)) {
    return preferred;
  }

  // Try nearby ports
  for (let offset = 1; offset <= 10; offset++) {
    const port = preferred + offset;
    if (await isPortAvailable(port)) {
      console.log(`Port ${preferred} taken, using ${port} instead`);
      return port;
    }
  }

  throw new Error(`No available ports found near ${preferred}`);
}
```

## TodoWrite Integration

```json
{
  "todos": [
    {
      "content": "Initialize Apso project structure",
      "activeForm": "Initializing Apso project",
      "status": "completed"
    },
    {
      "content": "Configure .apsorc with BetterAuth entities",
      "activeForm": "Configuring schema",
      "status": "completed"
    },
    {
      "content": "Generate backend code (apso server)",
      "activeForm": "Generating code",
      "status": "in_progress"
    },
    {
      "content": "Auto-fix DTO and entity issues",
      "activeForm": "Fixing generated code",
      "status": "pending"
    },
    {
      "content": "Configure environment variables",
      "activeForm": "Setting up environment",
      "status": "pending"
    },
    {
      "content": "Start development server",
      "activeForm": "Starting server",
      "status": "pending"
    }
  ]
}
```

## Error Handling

### Level 1: Auto-Fix

```typescript
try {
  await exec('apso server');
} catch (error) {
  if (error.message.includes('nullable constraint')) {
    console.log('Detected nullable constraint issue, fixing...');
    await fixNullableFields();
    await exec('apso server'); // Retry
  }
}
```

### Level 2: Retry with Alternative

```typescript
try {
  await exec('npm install');
} catch (error) {
  console.log('npm install failed, trying with --legacy-peer-deps...');
  await exec('npm install --legacy-peer-deps');
}
```

### Level 3: User Guidance

```typescript
if (error.code === 'EACCES') {
  return {
    error: "Permission denied",
    suggestion: "Run: sudo chown -R $(whoami) ~/.npm",
    canContinue: false
  };
}
```

## Verification

I verify success by testing:

```typescript
async function verifyBackend(baseUrl: string): Promise<VerificationResult> {
  const tests = [
    {
      name: "Health endpoint",
      test: () => fetch(`${baseUrl}/health`).then(r => r.ok)
    },
    {
      name: "Users endpoint",
      test: () => fetch(`${baseUrl}/Users`).then(r => r.ok)
    },
    {
      name: "OpenAPI docs",
      test: () => fetch(`${baseUrl}/api/docs`).then(r => r.ok)
    }
  ];

  const results = await Promise.all(
    tests.map(async (t) => ({
      name: t.name,
      passed: await t.test().catch(() => false)
    }))
  );

  return {
    success: results.every(r => r.passed),
    results
  };
}
```

## References

- `references/apsorc-templates/` - Schema templates
- `references/fix-scripts/` - Auto-fix implementations
- `references/better-auth-integration.md` - BetterAuth patterns
```

---

### 3. Phase Skill: `setup-frontend`

**Location:** `.claude/skills/setup-frontend/SKILL.md`

```markdown
---
name: setup-frontend
description: Sets up Next.js frontend with BetterAuth client integration. Called by orchestrator or standalone. Handles initialization, auth configuration, and component setup.
---

# Frontend Setup Skill

I create a production-ready Next.js frontend with BetterAuth client.

## What I Do

1. **Initialize Next.js**
   - Run `npx create-next-app@latest`
   - Configure TypeScript, Tailwind, App Router
   - Install dependencies

2. **Install BetterAuth Client**
   - Install `better-auth` package
   - Configure auth client
   - Set up API routes

3. **Setup shadcn/ui**
   - Initialize shadcn
   - Install base components
   - Configure theme

4. **Create Auth Components**
   - Login form
   - Signup form
   - Protected route wrapper
   - Session provider

5. **Configure Environment**
   - Create `.env.local`
   - Set backend URL
   - Configure public variables

6. **Verify Build**
   - Run `npm run build`
   - Test development server
   - Verify auth integration

## Intelligence Features

### Framework Detection

```typescript
// Check for existing Next.js installation
if (await directoryExists('frontend')) {
  const hasNextConfig = await fileExists('frontend/next.config.js');

  if (hasNextConfig) {
    // Integrate into existing app
    await integrateAuth('frontend');
  } else {
    // Directory exists but not Next.js
    const answer = await askUser(
      "Directory 'frontend' exists but isn't a Next.js app. What should I do?",
      [
        "Delete and create new Next.js app",
        "Use different directory name",
        "Skip frontend setup"
      ]
    );
  }
}
```

### Version Compatibility

```typescript
const compatibilityMatrix = {
  "better-auth": "^1.0.0",
  "next": "^14.0.0 || ^15.0.0",
  "react": "^18.0.0 || ^19.0.0"
};

async function checkCompatibility() {
  const packageJson = await readJSON('frontend/package.json');

  for (const [pkg, required] of Object.entries(compatibilityMatrix)) {
    if (!satisfies(packageJson.dependencies[pkg], required)) {
      console.warn(`⚠ ${pkg} version mismatch. Installing compatible version...`);
      await exec(`npm install ${pkg}@${required}`);
    }
  }
}
```

### Auto-Configuration

```typescript
// Auto-detect backend URL
async function detectBackendUrl(): Promise<string> {
  // Check if backend is running
  const localUrls = [
    'http://localhost:3001',
    'http://localhost:3000',
    'http://localhost:4000'
  ];

  for (const url of localUrls) {
    try {
      const response = await fetch(`${url}/health`, { timeout: 1000 });
      if (response.ok) {
        console.log(`✓ Detected backend at ${url}`);
        return url;
      }
    } catch {}
  }

  // Default to standard port
  return 'http://localhost:3001';
}
```

## TodoWrite Integration

```json
{
  "todos": [
    {
      "content": "Initialize Next.js with TypeScript and Tailwind",
      "activeForm": "Initializing Next.js",
      "status": "completed"
    },
    {
      "content": "Install and configure BetterAuth client",
      "activeForm": "Setting up BetterAuth",
      "status": "in_progress"
    },
    {
      "content": "Setup shadcn/ui component library",
      "activeForm": "Installing components",
      "status": "pending"
    },
    {
      "content": "Create authentication components",
      "activeForm": "Building auth UI",
      "status": "pending"
    },
    {
      "content": "Configure environment variables",
      "activeForm": "Setting up environment",
      "status": "pending"
    },
    {
      "content": "Verify build and auth integration",
      "activeForm": "Testing setup",
      "status": "pending"
    }
  ]
}
```

## Generated Files

```
frontend/
├── app/
│   ├── (auth)/
│   │   ├── login/
│   │   │   └── page.tsx          # ← I create this
│   │   └── signup/
│   │       └── page.tsx          # ← I create this
│   ├── (protected)/
│   │   ├── dashboard/
│   │   │   └── page.tsx          # ← I create this
│   │   └── layout.tsx            # ← Protected layout
│   ├── api/
│   │   └── auth/
│   │       └── [...all]/route.ts # ← BetterAuth API route
│   ├── layout.tsx
│   └── page.tsx
├── components/
│   ├── auth/
│   │   ├── LoginForm.tsx         # ← I create this
│   │   ├── SignupForm.tsx        # ← I create this
│   │   └── ProtectedRoute.tsx    # ← I create this
│   └── ui/                       # ← shadcn components
├── lib/
│   ├── auth.ts                   # ← BetterAuth client config
│   └── utils.ts
├── .env.local                    # ← I create this
├── next.config.js
└── package.json
```

## Verification

```typescript
async function verifyFrontend(): Promise<VerificationResult> {
  const tests = [
    {
      name: "Next.js builds successfully",
      test: async () => {
        const result = await exec('npm run build');
        return result.exitCode === 0;
      }
    },
    {
      name: "BetterAuth client configured",
      test: async () => {
        const authFile = await readFile('lib/auth.ts');
        return authFile.includes('betterAuth') &&
               authFile.includes(process.env.NEXT_PUBLIC_BACKEND_URL);
      }
    },
    {
      name: "Auth components exist",
      test: async () => {
        return await fileExists('components/auth/LoginForm.tsx') &&
               await fileExists('components/auth/SignupForm.tsx');
      }
    },
    {
      name: "Development server starts",
      test: async () => {
        const server = await startDevServer('npm run dev');
        await sleep(5000);
        const response = await fetch('http://localhost:3003');
        await server.kill();
        return response.ok;
      }
    }
  ];

  const results = await Promise.all(tests.map(runTest));

  return {
    success: results.every(r => r.passed),
    results
  };
}
```
```

---

### 4. Utility Skill: `configure-database`

**Location:** `.claude/skills/configure-database/SKILL.md`

```markdown
---
name: configure-database
description: Configures PostgreSQL database for Apso projects. Handles Docker setup, schema creation, and migrations. Reusable across all setup phases.
---

# Database Configuration Skill

I setup and configure PostgreSQL databases for your application.

## What I Do

1. **Docker PostgreSQL**
   - Detect Docker installation
   - Create docker-compose.yml
   - Start PostgreSQL container
   - Wait for database ready

2. **Database Creation**
   - Create development database
   - Create test database
   - Set up proper permissions

3. **Schema Migration**
   - Run TypeORM synchronization
   - Verify tables created
   - Create indexes

4. **Connection Testing**
   - Test connection
   - Verify read/write access
   - Check table existence

## Intelligence Features

### Docker Detection

```typescript
async function setupPostgreSQL(): Promise<DatabaseConfig> {
  // Check Docker availability
  if (await isDockerAvailable()) {
    return await setupDockerPostgreSQL();
  }

  // Check existing PostgreSQL
  if (await isPostgreSQLInstalled()) {
    const useExisting = await askUser(
      "Found existing PostgreSQL. Use it?",
      ["Yes", "No, use Docker"]
    );

    if (useExisting === "Yes") {
      return await useExistingPostgreSQL();
    }
  }

  // Suggest installation
  return await suggestPostgreSQLInstallation();
}
```

### Port Intelligence

```typescript
async function findDatabasePort(): Promise<number> {
  const preferredPort = 5433;

  if (await isPortAvailable(preferredPort)) {
    return preferredPort;
  }

  // Check if it's our own container
  const existingContainer = await exec(
    `docker ps --filter "publish=${preferredPort}" --format "{{.Names}}"`
  );

  if (existingContainer.includes('postgres')) {
    console.log('Reusing existing PostgreSQL container');
    return preferredPort;
  }

  // Find alternative port
  for (let port = 5434; port < 5450; port++) {
    if (await isPortAvailable(port)) {
      console.log(`Port ${preferredPort} taken, using ${port}`);
      return port;
    }
  }

  throw new Error('No available ports for PostgreSQL');
}
```

### Connection Retry Logic

```typescript
async function waitForDatabase(
  connectionString: string,
  maxAttempts: number = 30
): Promise<void> {
  console.log('Waiting for database to be ready...');

  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      const client = new Client(connectionString);
      await client.connect();
      await client.query('SELECT 1');
      await client.end();

      console.log(`✓ Database ready (attempt ${attempt})`);
      return;
    } catch (error) {
      if (attempt === maxAttempts) {
        throw new Error(`Database not ready after ${maxAttempts} attempts`);
      }

      console.log(`Attempt ${attempt}/${maxAttempts} - waiting 2s...`);
      await sleep(2000);
    }
  }
}
```

## Generated Configuration

### docker-compose.yml

```yaml
# I generate this automatically
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: {project}-postgres
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: {project}_dev
    ports:
      - "{port}:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5

volumes:
  postgres-data:
```

### Database Initialization SQL

```sql
-- I run this automatically
CREATE DATABASE {project}_dev;
CREATE DATABASE {project}_test;

GRANT ALL PRIVILEGES ON DATABASE {project}_dev TO postgres;
GRANT ALL PRIVILEGES ON DATABASE {project}_test TO postgres;
```

## Verification

```typescript
async function verifyDatabase(config: DatabaseConfig): Promise<VerificationResult> {
  const tests = [
    {
      name: "Container running",
      test: async () => {
        const result = await exec(`docker ps --filter "name=${config.containerName}"`);
        return result.stdout.includes(config.containerName);
      }
    },
    {
      name: "Database accepts connections",
      test: async () => {
        const client = new Client(config.connectionString);
        await client.connect();
        await client.end();
        return true;
      }
    },
    {
      name: "Database exists",
      test: async () => {
        const client = new Client(config.connectionString);
        await client.connect();
        const result = await client.query(
          "SELECT 1 FROM pg_database WHERE datname = $1",
          [config.database]
        );
        await client.end();
        return result.rows.length > 0;
      }
    },
    {
      name: "Tables created",
      test: async () => {
        const client = new Client(config.connectionString);
        await client.connect();
        const result = await client.query(
          "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public'"
        );
        await client.end();
        return parseInt(result.rows[0].count) > 0;
      }
    }
  ];

  const results = await Promise.all(tests.map(runTest));

  return {
    success: results.every(r => r.passed),
    results
  };
}
```
```

---

### 5. Utility Skill: `verify-setup`

**Location:** `.claude/skills/verify-setup/SKILL.md`

```markdown
---
name: verify-setup
description: Comprehensive verification of complete setup. Tests all endpoints, auth flows, and integrations. Provides detailed diagnostics.
---

# Setup Verification Skill

I comprehensively test your setup to ensure everything works correctly.

## What I Test

### Backend Health
- Server responds at correct port
- Health endpoint returns OK
- OpenAPI docs accessible
- Database connection active

### CRUD Endpoints
- GET /Users returns 200
- POST /Users creates user
- GET /Users/{id} retrieves user
- PATCH /Users/{id} updates user
- DELETE /Users/{id} deletes user

### Auth Flow
- User signup creates user + account + organization
- User login validates credentials
- Session creation works
- Token validation works
- Password hashing secure

### Database Integrity
- All expected tables exist
- Foreign keys enforced
- Unique constraints work
- Nullable fields correct

### Frontend (if included)
- Application builds successfully
- Development server starts
- Login page renders
- Signup page renders
- Protected routes work

## Intelligence Features

### Diagnostic Intelligence

```typescript
async function diagnoseIssue(error: Error): Promise<Diagnosis> {
  const patterns = [
    {
      pattern: /ECONNREFUSED.*:(\d+)/,
      diagnose: (match) => ({
        issue: `Service not running on port ${match[1]}`,
        fix: `Start the service: npm run start:dev`,
        severity: 'high'
      })
    },
    {
      pattern: /relation "(\w+)" does not exist/,
      diagnose: (match) => ({
        issue: `Database table '${match[1]}' not created`,
        fix: `Run migrations or restart backend to sync schema`,
        severity: 'high'
      })
    },
    {
      pattern: /null value.*violates not-null constraint/,
      diagnose: () => ({
        issue: 'Nullable field configuration incorrect',
        fix: 'Run fix-nullable-fields auto-fix',
        severity: 'medium'
      })
    }
  ];

  for (const {pattern, diagnose} of patterns) {
    const match = error.message.match(pattern);
    if (match) {
      return diagnose(match);
    }
  }

  return {
    issue: error.message,
    fix: 'Check logs for details',
    severity: 'unknown'
  };
}
```

### Self-Healing Verification

```typescript
async function verifyWithHealing(): Promise<VerificationResult> {
  const result = await runAllTests();

  if (!result.success) {
    console.log('Some tests failed. Attempting auto-fixes...');

    for (const failed of result.failures) {
      const diagnosis = await diagnoseIssue(failed.error);

      if (diagnosis.severity !== 'high' && diagnosis.autoFix) {
        console.log(`→ Applying fix: ${diagnosis.fix}`);
        await diagnosis.autoFix();

        // Retest
        const retryResult = await runTest(failed.test);
        if (retryResult.passed) {
          console.log(`✓ Fixed: ${failed.name}`);
        }
      }
    }

    // Run tests again after fixes
    return await runAllTests();
  }

  return result;
}
```

## Test Suites

### Backend Test Suite

```typescript
const backendTests = [
  {
    name: "Server Health",
    test: async () => {
      const response = await fetch(`${backendUrl}/health`);
      return response.status === 200;
    }
  },
  {
    name: "OpenAPI Docs",
    test: async () => {
      const response = await fetch(`${backendUrl}/api/docs`);
      return response.status === 200 &&
             response.headers.get('content-type')?.includes('text/html');
    }
  },
  {
    name: "Database Connection",
    test: async () => {
      const response = await fetch(`${backendUrl}/health/db`);
      const data = await response.json();
      return data.status === 'connected';
    }
  },
  {
    name: "Users Endpoint (GET)",
    test: async () => {
      const response = await fetch(`${backendUrl}/Users`);
      return response.status === 200;
    }
  },
  {
    name: "Users Endpoint (POST)",
    test: async () => {
      const user = {
        id: randomUUID(),
        email: `test-${Date.now()}@example.com`,
        name: "Test User"
      };

      const response = await fetch(`${backendUrl}/Users`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(user)
      });

      return response.status === 201;
    }
  }
];
```

### Auth Flow Test Suite

```typescript
const authFlowTests = [
  {
    name: "User Signup Flow",
    test: async () => {
      // 1. Create user
      const userId = randomUUID();
      const email = `signup-${Date.now()}@example.com`;

      const userResponse = await fetch(`${backendUrl}/Users`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          id: userId,
          email,
          name: "Signup Test",
          email_verified: false
        })
      });

      if (userResponse.status !== 201) return false;

      // 2. Verify account created
      const accountResponse = await fetch(
        `${backendUrl}/accounts?userId=${userId}`
      );
      const accounts = await accountResponse.json();

      if (accounts.length === 0) return false;

      // 3. Verify organization created
      const user = await userResponse.json();
      const orgResponse = await fetch(
        `${backendUrl}/Organizations?userId=${userId}`
      );
      const orgs = await orgResponse.json();

      return orgs.length > 0;
    }
  },
  {
    name: "Session Creation",
    test: async () => {
      // Create session
      const sessionResponse = await fetch(`${backendUrl}/sessions`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          id: randomUUID(),
          userId: testUserId,
          token: 'test-token-' + Date.now(),
          expiresAt: new Date(Date.now() + 86400000).toISOString()
        })
      });

      return sessionResponse.status === 201;
    }
  }
];
```

### Database Integrity Suite

```typescript
const databaseTests = [
  {
    name: "All Tables Exist",
    test: async () => {
      const client = new Client(databaseUrl);
      await client.connect();

      const expectedTables = ['user', 'account', 'session', 'verification', 'organization'];

      const result = await client.query(`
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
      `);

      await client.end();

      const actualTables = result.rows.map(r => r.table_name);
      return expectedTables.every(t => actualTables.includes(t));
    }
  },
  {
    name: "Foreign Keys Enforced",
    test: async () => {
      // Try to create account with invalid userId
      try {
        await fetch(`${backendUrl}/accounts`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            id: randomUUID(),
            userId: randomUUID(), // Non-existent
            providerId: 'email',
            providerAccountId: 'test'
          })
        });

        // Should have failed
        return false;
      } catch (error) {
        // Foreign key violation expected
        return true;
      }
    }
  },
  {
    name: "Unique Constraints Work",
    test: async () => {
      const email = `unique-${Date.now()}@example.com`;

      // Create first user
      await fetch(`${backendUrl}/Users`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          id: randomUUID(),
          email,
          name: "First"
        })
      });

      // Try to create duplicate
      const duplicateResponse = await fetch(`${backendUrl}/Users`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          id: randomUUID(),
          email, // Same email
          name: "Duplicate"
        })
      });

      // Should fail with 409 or 400
      return duplicateResponse.status >= 400;
    }
  }
];
```

## Output Format

### Success Output

```markdown
✓ Verification Complete - All Checks Passed

**Backend Services** (6/6)
- ✓ Server health check
- ✓ OpenAPI documentation
- ✓ Database connection
- ✓ Users CRUD operations
- ✓ Auth endpoints
- ✓ Multi-tenant isolation

**Database Integrity** (4/4)
- ✓ All 5 tables created
- ✓ Foreign keys enforced
- ✓ Unique constraints work
- ✓ Nullable fields correct

**Auth Flow** (3/3)
- ✓ User signup creates user + account + org
- ✓ Session creation works
- ✓ Token validation works

**Frontend** (4/4)
- ✓ Application builds successfully
- ✓ Development server starts
- ✓ Login page renders
- ✓ Auth integration works

**Summary:**
- Total tests: 17
- Passed: 17
- Failed: 0
- Duration: 23 seconds

Your setup is production-ready!
```

### Failure Output with Diagnostics

```markdown
⚠ Verification Incomplete - 3 Issues Found

**Backend Services** (4/6)
- ✓ Server health check
- ✓ OpenAPI documentation
- ✗ Database connection
- ✗ Users CRUD operations
- ✓ Auth endpoints
- ✗ Multi-tenant isolation

**Issues Detected:**

1. Database Connection Failed
   **Error:** ECONNREFUSED 127.0.0.1:5433
   **Diagnosis:** PostgreSQL not running on port 5433
   **Fix:** Start PostgreSQL container
   ```bash
   docker-compose up -d
   ```
   **Severity:** HIGH

2. Users CRUD Failed
   **Error:** relation "user" does not exist
   **Diagnosis:** Database tables not created
   **Fix:** Restart backend to run TypeORM sync
   ```bash
   npm run start:dev
   ```
   **Severity:** HIGH

3. Multi-tenant Isolation Failed
   **Error:** Organization not auto-created on user signup
   **Diagnosis:** organization.hooks.ts not triggering
   **Fix:** Check AppModule imports organization hooks
   **Severity:** MEDIUM
   **Auto-fixable:** Yes

**Recommended Actions:**

1. Start PostgreSQL: `docker-compose up -d`
2. Restart backend: `npm run start:dev`
3. Run auto-fix: "Fix common issues"
4. Re-run verification: "Verify setup again"

**Checkpoint saved:** .verification-state.json
```

## Integration with Fix Skill

When issues detected:

```typescript
if (!verificationResult.success) {
  console.log('Attempting automatic fixes...');

  const fixable = verificationResult.failures.filter(f => f.autoFixable);

  if (fixable.length > 0) {
    // Call fix-common-issues skill
    await callSkill('fix-common-issues', {
      issues: fixable
    });

    // Re-run verification
    return await verifySetup();
  }
}
```
```

---

### 6. Utility Skill: `fix-common-issues`

**Location:** `.claude/skills/fix-common-issues/SKILL.md`

```markdown
---
name: fix-common-issues
description: Auto-fixes known setup and integration issues. Called automatically when problems detected or manually by user.
---

# Common Issues Fix Skill

I automatically detect and fix known problems with backend, database, and auth setup.

## What I Fix

### Category 1: DTO Issues
- Missing `id` field in create DTOs
- Incorrect field validators
- Missing API property decorators

### Category 2: Entity Issues
- Nullable field configurations
- Column type mismatches
- Missing indexes

### Category 3: Module Issues
- Missing imports in AppModule
- Incorrect provider registration
- Circular dependency errors

### Category 4: Database Issues
- NOT NULL constraint violations
- Foreign key conflicts
- Unique constraint violations

### Category 5: Environment Issues
- Missing environment variables
- Invalid secrets
- CORS configuration

## Fix Patterns

### Pattern 1: Missing DTO ID Field

```typescript
async function fixDtoIdFields(): Promise<FixResult> {
  const dtoFiles = await glob('backend/src/autogen/**/dtos/*.dto.ts');
  let fixed = 0;

  for (const file of dtoFiles) {
    const content = await readFile(file);

    if (content.includes('export class') &&
        content.includes('Create') &&
        !content.includes('id: string')) {

      // Find insertion point (after class declaration)
      const classMatch = content.match(/export class (\w+Create) {/);
      if (classMatch) {
        const insertPoint = content.indexOf('{', classMatch.index) + 1;

        const idField = `
  @ApiProperty()
  @IsUUID()
  id: string;
`;

        const newContent =
          content.slice(0, insertPoint) +
          idField +
          content.slice(insertPoint);

        // Ensure imports
        const finalContent = ensureImports(newContent, [
          "import { IsUUID } from 'class-validator';",
          "import { ApiProperty } from '@nestjs/swagger';"
        ]);

        await writeFile(file, finalContent);
        fixed++;
        console.log(`✓ Fixed ${file}`);
      }
    }
  }

  return {
    success: fixed > 0,
    message: `Fixed ${fixed} DTO files`,
    filesModified: fixed
  };
}
```

### Pattern 2: Nullable Field Configuration

```typescript
async function fixNullableFields(): Promise<FixResult> {
  const entityFiles = await glob('backend/src/autogen/**/**.entity.ts');
  let fixed = 0;

  const fieldsNeedingNullable = [
    'avatar_url',
    'password_hash',
    'oauth_provider',
    'oauth_id',
    'phone_number'
  ];

  for (const file of entityFiles) {
    let content = await readFile(file);
    let modified = false;

    for (const field of fieldsNeedingNullable) {
      // Find @Column() for this field without nullable
      const regex = new RegExp(
        `@Column\\(([^)]*)\\)\\s*${field}`,
        'g'
      );

      const matches = [...content.matchAll(regex)];

      for (const match of matches) {
        const currentOptions = match[1];

        if (!currentOptions.includes('nullable')) {
          // Add nullable: true
          const newOptions = currentOptions
            ? `{ nullable: true, ${currentOptions} }`
            : '{ nullable: true }';

          content = content.replace(
            match[0],
            `@Column(${newOptions})\n  ${field}`
          );

          modified = true;
        }
      }
    }

    if (modified) {
      await writeFile(file, content);
      fixed++;
      console.log(`✓ Fixed ${file}`);
    }
  }

  return {
    success: fixed > 0,
    message: `Fixed nullable fields in ${fixed} entities`,
    filesModified: fixed
  };
}
```

### Pattern 3: AppModule Imports

```typescript
async function fixAppModuleImports(): Promise<FixResult> {
  const appModulePath = 'backend/src/app.module.ts';
  const content = await readFile(appModulePath);

  // Find all generated modules
  const generatedModules = await glob('backend/src/autogen/**/*.module.ts');

  const requiredModules = generatedModules.map(path => {
    const match = path.match(/autogen\/(.+?)\/(.+?)\.module\.ts/);
    if (match) {
      const [, folder, name] = match;
      return {
        name: `${name}Module`,
        path: `./autogen/${folder}/${name}.module`
      };
    }
  }).filter(Boolean);

  let newContent = content;
  let addedImports = 0;

  for (const module of requiredModules) {
    // Check if already imported
    if (!newContent.includes(`import { ${module.name} }`)) {
      // Add import
      const lastImport = newContent.lastIndexOf('import {');
      const insertPoint = newContent.indexOf('\n', lastImport) + 1;

      newContent =
        newContent.slice(0, insertPoint) +
        `import { ${module.name} } from '${module.path}';\n` +
        newContent.slice(insertPoint);

      addedImports++;
    }

    // Check if in imports array
    if (!newContent.includes(module.name)) {
      // Add to imports array
      const importsMatch = newContent.match(/imports:\s*\[([\s\S]*?)\]/);
      if (importsMatch) {
        const currentImports = importsMatch[1].trim();
        const newImports = currentImports
          ? `${currentImports},\n    ${module.name}`
          : module.name;

        newContent = newContent.replace(
          importsMatch[0],
          `imports: [\n    ${newImports}\n  ]`
        );
      }
    }
  }

  if (addedImports > 0) {
    await writeFile(appModulePath, newContent);
    console.log(`✓ Added ${addedImports} module imports to AppModule`);
  }

  return {
    success: addedImports > 0,
    message: `Added ${addedImports} missing imports`,
    filesModified: addedImports > 0 ? 1 : 0
  };
}
```

### Pattern 4: Database Constraint Violations

```typescript
async function fixDatabaseConstraints(): Promise<FixResult> {
  const issues = await detectConstraintViolations();

  for (const issue of issues) {
    switch (issue.type) {
      case 'NOT_NULL_VIOLATION':
        // Fix nullable fields and recreate schema
        await fixNullableFields();
        await recreateDatabase();
        break;

      case 'UNIQUE_VIOLATION':
        // Add unique index if missing
        await addUniqueIndex(issue.table, issue.column);
        break;

      case 'FOREIGN_KEY_VIOLATION':
        // Ensure cascade deletes configured
        await configureCascadeDeletes(issue.table);
        break;
    }
  }

  return {
    success: issues.length > 0,
    message: `Fixed ${issues.length} constraint issues`,
    issuesFixed: issues.length
  };
}

async function recreateDatabase(): Promise<void> {
  console.log('Recreating database schema...');

  const client = new Client(process.env.DATABASE_URL);
  await client.connect();

  await client.query('DROP SCHEMA public CASCADE');
  await client.query('CREATE SCHEMA public');
  await client.query('GRANT ALL ON SCHEMA public TO postgres');
  await client.query('GRANT ALL ON SCHEMA public TO public');

  await client.end();

  // Restart backend to run TypeORM sync
  console.log('Restarting backend to sync schema...');
  await restartBackend();

  console.log('✓ Database schema recreated');
}
```

## Issue Detection

```typescript
async function detectAllIssues(): Promise<Issue[]> {
  const detectors = [
    detectDtoIssues,
    detectEntityIssues,
    detectModuleIssues,
    detectDatabaseIssues,
    detectEnvironmentIssues
  ];

  const results = await Promise.all(
    detectors.map(detect => detect())
  );

  return results.flat();
}

async function detectDtoIssues(): Promise<Issue[]> {
  const issues: Issue[] = [];
  const dtoFiles = await glob('backend/src/autogen/**/dtos/*.dto.ts');

  for (const file of dtoFiles) {
    const content = await readFile(file);

    // Check for missing id field in Create DTOs
    if (content.includes('Create') && !content.includes('id: string')) {
      issues.push({
        type: 'MISSING_DTO_ID',
        file,
        severity: 'HIGH',
        autoFixable: true,
        fix: 'fixDtoIdFields'
      });
    }
  }

  return issues;
}

async function detectDatabaseIssues(): Promise<Issue[]> {
  const issues: Issue[] = [];

  try {
    // Try to create a test user
    const response = await fetch(`${backendUrl}/Users`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        id: randomUUID(),
        email: 'test@example.com',
        name: 'Test'
        // Intentionally missing avatar_url
      })
    });

    if (!response.ok) {
      const error = await response.text();

      if (error.includes('null value') && error.includes('not-null constraint')) {
        issues.push({
          type: 'NOT_NULL_VIOLATION',
          severity: 'HIGH',
          autoFixable: true,
          fix: 'fixNullableFields'
        });
      }
    }
  } catch (error) {
    // Connection issue
    if (error.message.includes('ECONNREFUSED')) {
      issues.push({
        type: 'DATABASE_NOT_RUNNING',
        severity: 'CRITICAL',
        autoFixable: true,
        fix: 'startDatabase'
      });
    }
  }

  return issues;
}
```

## Execution

```typescript
async function runAutoFix(issueTypes?: string[]): Promise<FixReport> {
  console.log('Detecting issues...');
  const allIssues = await detectAllIssues();

  const issuesToFix = issueTypes
    ? allIssues.filter(i => issueTypes.includes(i.type))
    : allIssues.filter(i => i.autoFixable);

  console.log(`Found ${issuesToFix.length} auto-fixable issues`);

  const results = [];

  for (const issue of issuesToFix) {
    console.log(`\nFixing: ${issue.type}`);

    const fixFunction = getFix Function(issue.fix);
    const result = await fixFunction();

    results.push({
      issue,
      result
    });
  }

  const successCount = results.filter(r => r.result.success).length;

  return {
    totalIssues: allIssues.length,
    fixedIssues: successCount,
    results
  };
}
```

## Output

```markdown
## Auto-Fix Report

**Issues Detected:** 5
**Auto-Fixable:** 4
**Fixed:** 4

**Fixes Applied:**

1. ✓ Missing DTO ID Fields
   - Fixed 3 DTO files
   - Added id field to UserCreate, AccountCreate, SessionCreate

2. ✓ Nullable Field Configuration
   - Fixed 1 entity file
   - Made avatar_url, password_hash nullable in User entity

3. ✓ AppModule Imports
   - Added 2 missing imports
   - Added UserModule, SessionModule to AppModule

4. ✓ Database Constraints
   - Recreated database schema
   - All tables created successfully

**Remaining Issues:** 1

5. ⚠ CORS Configuration
   - Manual fix required
   - Add ALLOWED_ORIGINS to .env.development
   - See: docs/troubleshooting/cors-setup.md

**Verification:**
Re-running verification tests...

✓ All tests now pass!
```
```

---

## Orchestration Strategy

### Communication Protocol

Skills communicate via:

1. **Return Values** - Structured results
2. **Checkpoint Files** - Persistent state
3. **TodoWrite** - Progress tracking
4. **Shared Context** - Environment config

### Skill Invocation

```typescript
// Master orchestrator calls sub-skills
interface SkillResult {
  success: boolean;
  message: string;
  data?: any;
  error?: Error;
  checkpoint?: Checkpoint;
}

async function callSkill(
  skillName: string,
  params: any
): Promise<SkillResult> {
  console.log(`Invoking ${skillName} skill...`);

  try {
    const result = await executeSkill(skillName, params);

    if (result.checkpoint) {
      await saveCheckpoint(result.checkpoint);
    }

    return result;
  } catch (error) {
    return {
      success: false,
      message: `${skillName} failed`,
      error
    };
  }
}
```

### Dependency Management

```typescript
// Skills declare dependencies
interface SkillMetadata {
  name: string;
  dependencies: string[];
  optional: string[];
}

// Orchestrator checks dependencies before calling
async function canCallSkill(skillName: string): Promise<boolean> {
  const skill = getSkill(skillName);

  for (const dep of skill.dependencies) {
    const depResult = await getSkillStatus(dep);
    if (depResult.status !== 'completed') {
      console.log(`Cannot call ${skillName}: ${dep} not complete`);
      return false;
    }
  }

  return true;
}
```

### State Management

```typescript
interface GlobalState {
  phase: string;
  completedSkills: string[];
  failedSkills: string[];
  config: ProjectConfig;
  artifacts: Artifacts;
}

class StateManager {
  private state: GlobalState;

  async saveCheckpoint(): Promise<void> {
    await writeJSON('.setup-state.json', this.state);
  }

  async loadCheckpoint(): Promise<GlobalState> {
    return await readJSON('.setup-state.json');
  }

  markSkillComplete(skillName: string, result: SkillResult): void {
    this.state.completedSkills.push(skillName);

    if (result.data?.artifacts) {
      this.state.artifacts = {
        ...this.state.artifacts,
        ...result.data.artifacts
      };
    }

    this.saveCheckpoint();
  }
}
```

---

## Error Handling & Recovery

### 4-Level Strategy

```typescript
class ErrorHandler {
  async handle(error: Error, context: Context): Promise<Resolution> {
    // Level 1: Auto-fix
    const autoFix = await this.tryAutoFix(error);
    if (autoFix.success) {
      return { strategy: 'AUTO_FIX', ...autoFix };
    }

    // Level 2: Retry with alternative
    const retry = await this.tryAlternative(error, context);
    if (retry.success) {
      return { strategy: 'RETRY', ...retry };
    }

    // Level 3: User guidance
    if (context.interactive) {
      const guidance = await this.requestUserInput(error);
      return { strategy: 'USER_INPUT', ...guidance };
    }

    // Level 4: Graceful degradation
    const degradation = await this.degradeGracefully(error, context);
    return { strategy: 'DEGRADE', ...degradation };
  }

  private async tryAutoFix(error: Error): Promise<FixResult> {
    const knownIssues = [
      { pattern: /nullable.*constraint/, fix: () => fixNullableFields() },
      { pattern: /ECONNREFUSED.*5433/, fix: () => startDatabase() },
      { pattern: /port.*in use/, fix: () => findAlternativePort() }
    ];

    for (const { pattern, fix } of knownIssues) {
      if (pattern.test(error.message)) {
        console.log(`Detected known issue, applying auto-fix...`);
        return await fix();
      }
    }

    return { success: false };
  }
}
```

### Retry Logic

```typescript
async function retryWithBackoff<T>(
  fn: () => Promise<T>,
  maxAttempts: number = 3,
  backoff: number = 1000
): Promise<T> {
  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await fn();
    } catch (error) {
      if (attempt === maxAttempts) {
        throw error;
      }

      const delay = backoff * Math.pow(2, attempt - 1);
      console.log(`Attempt ${attempt} failed, retrying in ${delay}ms...`);
      await sleep(delay);
    }
  }

  throw new Error('Retry logic failed unexpectedly');
}
```

---

## Progress Tracking & Resumability

### TodoWrite Integration

```typescript
class ProgressTracker {
  private todos: Todo[];

  async updateProgress(update: TodoUpdate): Promise<void> {
    // Update todo status
    this.todos = this.todos.map(todo =>
      todo.content === update.content
        ? { ...todo, status: update.status }
        : todo
    );

    // Call TodoWrite tool
    await TodoWrite({ todos: this.todos });
  }

  async addTodo(todo: Todo): Promise<void> {
    this.todos.push(todo);
    await TodoWrite({ todos: this.todos });
  }

  getCurrentTodo(): Todo | undefined {
    return this.todos.find(t => t.status === 'in_progress');
  }
}
```

### Checkpoint System

```typescript
interface Checkpoint {
  version: string;
  timestamp: string;
  phase: string;
  completedPhases: string[];
  failedPhases: string[];
  currentTodo: number;
  config: ProjectConfig;
  artifacts: Artifacts;
  environment: Environment;
}

class CheckpointManager {
  async save(checkpoint: Checkpoint): Promise<void> {
    await writeJSON('.setup-state.json', checkpoint);

    // Also save backup
    const backupPath = `.setup-state-${Date.now()}.json`;
    await writeJSON(backupPath, checkpoint);
  }

  async load(): Promise<Checkpoint | null> {
    if (await fileExists('.setup-state.json')) {
      return await readJSON('.setup-state.json');
    }
    return null;
  }

  async resume(): Promise<ResumeContext> {
    const checkpoint = await this.load();

    if (!checkpoint) {
      throw new Error('No checkpoint found');
    }

    console.log(`Resuming from phase: ${checkpoint.phase}`);
    console.log(`Completed: ${checkpoint.completedPhases.join(', ')}`);

    return {
      startPhase: checkpoint.phase,
      skipPhases: checkpoint.completedPhases,
      config: checkpoint.config,
      artifacts: checkpoint.artifacts
    };
  }
}
```

### Resume Logic

```typescript
async function executeOrchestrator(mode: 'fresh' | 'resume' = 'fresh'): Promise<void> {
  let context: ExecutionContext;

  if (mode === 'resume') {
    const checkpoint = await checkpointManager.load();
    if (!checkpoint) {
      console.log('No checkpoint found, starting fresh');
      context = createFreshContext();
    } else {
      context = await resumeFromCheckpoint(checkpoint);
    }
  } else {
    context = createFreshContext();
  }

  const phases = [
    'prerequisites',
    'backend-setup',
    'database-config',
    'frontend-setup',
    'verification'
  ];

  for (const phase of phases) {
    // Skip already completed phases
    if (context.completedPhases.includes(phase)) {
      console.log(`✓ Skipping ${phase} (already complete)`);
      continue;
    }

    // Skip failed phases if user requests
    if (context.skipFailedPhases && context.failedPhases.includes(phase)) {
      console.log(`⊘ Skipping ${phase} (previously failed)`);
      continue;
    }

    try {
      console.log(`\nExecuting phase: ${phase}`);
      const result = await executePhase(phase, context);

      if (result.success) {
        context.completedPhases.push(phase);
        await checkpointManager.save(createCheckpoint(context));
      } else {
        context.failedPhases.push(phase);
        await checkpointManager.save(createCheckpoint(context));

        if (result.critical) {
          console.log(`Critical failure in ${phase}, stopping`);
          break;
        }
      }
    } catch (error) {
      console.error(`Error in ${phase}:`, error);
      context.failedPhases.push(phase);
      await checkpointManager.save(createCheckpoint(context));

      // Ask user what to do
      const action = await askUser(
        `Phase ${phase} failed. What should I do?`,
        ['Retry', 'Skip', 'Abort']
      );

      if (action === 'Retry') {
        // Retry same phase
        phases.splice(phases.indexOf(phase), 0, phase);
      } else if (action === 'Abort') {
        break;
      }
    }
  }
}
```

---

## Implementation Plan

### Phase 1: Core Infrastructure (Week 1)

**Deliverables:**
- [ ] Checkpoint system implementation
- [ ] TodoWrite integration
- [ ] Error handler class
- [ ] State manager class
- [ ] Basic skill invocation framework

**Files to Create:**
```
.claude/skills/shared/
├── lib/
│   ├── checkpoint-manager.ts
│   ├── todo-tracker.ts
│   ├── error-handler.ts
│   ├── state-manager.ts
│   └── skill-invoker.ts
└── types/
    ├── skill-result.ts
    ├── checkpoint.ts
    └── context.ts
```

### Phase 2: Master Orchestrator (Week 1-2)

**Deliverables:**
- [ ] `apso-betterauth-setup` skill
- [ ] Interactive mode implementation
- [ ] Automated mode implementation
- [ ] Resume logic
- [ ] Progress reporting

**Files to Create:**
```
.claude/skills/apso-betterauth-setup/
├── SKILL.md
├── lib/
│   ├── orchestrator.ts
│   ├── interactive-mode.ts
│   └── automated-mode.ts
└── templates/
    ├── checkpoint.template.json
    └── config.template.json
```

### Phase 3: Phase Skills (Week 2-3)

**Deliverables:**
- [ ] `setup-backend` skill
- [ ] `setup-frontend` skill
- [ ] `configure-database` skill
- [ ] Integration tests for each skill

**Files to Create:**
```
.claude/skills/
├── setup-backend/
│   ├── SKILL.md
│   ├── lib/
│   │   ├── apso-initializer.ts
│   │   ├── schema-configurator.ts
│   │   └── code-generator.ts
│   └── references/
│       └── apsorc-templates/
├── setup-frontend/
│   ├── SKILL.md
│   ├── lib/
│   │   ├── nextjs-initializer.ts
│   │   ├── auth-configurator.ts
│   │   └── component-generator.ts
│   └── references/
│       └── component-templates/
└── configure-database/
    ├── SKILL.md
    ├── lib/
    │   ├── docker-manager.ts
    │   ├── postgres-initializer.ts
    │   └── migration-runner.ts
    └── templates/
        └── docker-compose.yml
```

### Phase 4: Utility Skills (Week 3-4)

**Deliverables:**
- [ ] `verify-setup` skill
- [ ] `fix-common-issues` skill
- [ ] Comprehensive test suites
- [ ] Auto-fix patterns

**Files to Create:**
```
.claude/skills/
├── verify-setup/
│   ├── SKILL.md
│   ├── lib/
│   │   ├── test-suites/
│   │   │   ├── backend-tests.ts
│   │   │   ├── auth-tests.ts
│   │   │   ├── database-tests.ts
│   │   │   └── frontend-tests.ts
│   │   ├── diagnostics.ts
│   │   └── reporter.ts
│   └── references/
│       └── test-patterns.md
└── fix-common-issues/
    ├── SKILL.md
    ├── lib/
    │   ├── detectors/
    │   │   ├── dto-issues.ts
    │   │   ├── entity-issues.ts
    │   │   ├── module-issues.ts
    │   │   └── database-issues.ts
    │   ├── fixers/
    │   │   ├── fix-dtos.ts
    │   │   ├── fix-entities.ts
    │   │   ├── fix-modules.ts
    │   │   └── fix-database.ts
    │   └── auto-fix.ts
    └── references/
        └── fix-patterns.md
```

### Phase 5: Integration & Testing (Week 4)

**Deliverables:**
- [ ] End-to-end tests
- [ ] Resume/checkpoint tests
- [ ] Error handling tests
- [ ] Documentation

**Test Scenarios:**
- Fresh setup (happy path)
- Resume from each phase
- Error in each phase with auto-fix
- Manual intervention scenarios
- Graceful degradation scenarios

### Phase 6: Polish & Documentation (Week 4-5)

**Deliverables:**
- [ ] User guide
- [ ] Troubleshooting guide
- [ ] Video walkthrough
- [ ] Migration guide from shell scripts

---

## Success Metrics

### Performance Metrics

- **Setup Time**: < 7 minutes for complete setup
- **Error Rate**: < 5% requiring manual intervention
- **Resume Success**: > 95% resume from any checkpoint
- **Auto-Fix Rate**: > 80% of common issues fixed automatically

### User Experience Metrics

- **Setup Success Rate**: > 90% first-time success
- **User Confidence**: > 8/10 in post-setup survey
- **Support Tickets**: < 10% require human assistance
- **Repeat Usage**: > 70% use for multiple projects

### Technical Metrics

- **Cross-Platform**: Works on macOS, Linux, Windows
- **Version Tolerance**: Works with Node 18-22, Docker 20-26
- **Test Coverage**: > 80% of code paths
- **Documentation**: 100% of features documented

---

## Advantages Over Shell Scripts

| Aspect | Shell Scripts | AI Skills |
|--------|--------------|-----------|
| **Platform Support** | OS-specific, require ports | Universal, adaptive |
| **Error Handling** | Exit on error | Progressive escalation |
| **Resumability** | None | Full checkpoint system |
| **Intelligence** | Zero | Context-aware |
| **Self-Healing** | None | Auto-fixes common issues |
| **User Guidance** | Generic errors | Specific, actionable advice |
| **Adaptability** | Fixed logic | Handles edge cases |
| **Maintenance** | Breaks with updates | Self-updating patterns |
| **Documentation** | Separate | Self-documenting |
| **Testing** | Manual | Comprehensive automated |

---

## Future Enhancements

### Version 2.0 (3-6 months)

- **Multi-Cloud Support**: AWS, GCP, Azure deployment skills
- **CI/CD Integration**: Auto-setup GitHub Actions, GitLab CI
- **Monitoring Setup**: Sentry, PostHog, LogRocket auto-config
- **Performance Optimization**: Database indexing, caching setup
- **Security Hardening**: Auto-apply security best practices

### Version 3.0 (6-12 months)

- **AI Code Review**: Automatic code quality checks
- **Dependency Management**: Auto-update and test dependencies
- **Load Testing**: Auto-generate and run load tests
- **Documentation Generation**: Auto-generate API docs, user guides
- **A/B Testing Setup**: Feature flag and experiment infrastructure

---

## Conclusion

This AI-orchestrated setup system represents a paradigm shift from brittle imperative scripts to intelligent declarative orchestration. By leveraging Claude's intelligence, we create a system that:

1. **Understands Intent**: Not just executing commands, but understanding goals
2. **Adapts to Context**: Handles environmental variations intelligently
3. **Self-Heals**: Detects and fixes issues automatically
4. **Guides Users**: Provides clear, actionable guidance when needed
5. **Never Forgets**: Checkpoint system enables perfect resumability
6. **Continuously Improves**: Learns new patterns and fixes over time

The result is a setup experience that feels like having an expert DevOps engineer guiding you through the process, rather than fighting with a fragile script.

**Next Step**: Begin implementation with Phase 1 (Core Infrastructure).

---

**Document Version:** 1.0
**Last Updated:** 2025-01-18
**Author:** Claude (Sonnet 4.5)
**Status:** Ready for Implementation
