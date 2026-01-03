# Setup Overview

How to set up projects using Mavric AI Toolchain through Claude Code.

---

## Quick Start

In Claude Code, simply describe what you need:

```
Set up an Apso backend with BetterAuth for my SaaS project
```

Claude Code will use the appropriate skills to:

1. Create project structure
2. Configure the database
3. Set up authentication
4. Generate API endpoints
5. Start development servers

**Result:** Running backend and frontend in ~5 minutes.

---

## Available Skills for Setup

| Skill | What It Does | How to Invoke |
|-------|--------------|---------------|
| **backend-bootstrapper** | Complete Apso + BetterAuth setup | "Set up a backend for my project" |
| **auth-bootstrapper** | Add auth to existing backend | "Add authentication to my backend" |
| **schema-architect** | Design data models | "Design the database schema" |

---

## Setup Approaches

### Approach 1: Full Project Orchestration

For new SaaS projects, use the complete workflow:

```
/start-project
```

This runs through all phases:

1. Discovery interview (90 min)
2. Test scenario generation
3. Schema design
4. Product brief
5. Backend implementation
6. Authentication setup

---

### Approach 2: Backend Only

If you already have requirements:

```
Set up an Apso backend with BetterAuth authentication.
Project name: my-saas
Database: my_saas_db
Backend port: 3001
```

Claude Code will:

- Initialize the Apso project
- Configure PostgreSQL connection
- Set up BetterAuth
- Create initial entities
- Start the development server

---

### Approach 3: Add Auth to Existing Project

If you have an Apso backend without auth:

```
Add BetterAuth authentication to my existing backend
```

Claude Code will:

- Add auth entities to `.apsorc`
- Generate auth configuration
- Set up session handling
- Create login/register endpoints

---

## Templates

The toolchain includes pre-configured `.apsorc` templates. Ask Claude Code:

```
Show me the available .apsorc templates
```

| Template | Use Case |
|----------|----------|
| **Minimal SaaS** | MVPs, prototypes (6 entities) |
| **Complete SaaS** | Full B2B with billing (11 entities) |

To use a template:

```
Create a backend using the minimal SaaS template
```

---

## Common Tasks

### Start Development Servers

```
Start the backend and frontend development servers
```

### Stop Servers

```
Stop all running development servers
```

### Check Server Status

```
Are my development servers running? Check the health endpoints.
```

### View Logs

```
Show me the recent backend logs
```

### Restart After Changes

```
Restart the backend server to pick up my schema changes
```

---

## Verification

After setup, ask Claude Code to verify:

```
Verify my backend setup is working correctly
```

Claude Code will check:

- Database connection
- API health endpoint
- Auth endpoints
- Frontend connectivity

---

## Prerequisites

Before running setup, ensure you have:

- **Claude Code** installed and authenticated
- **Node.js** >= 18.0.0
- **PostgreSQL** running

```bash
# Verify prerequisites
claude --version
node --version
psql --version
pg_isready
```

---

## Troubleshooting

### Database Connection Issues

```
I'm getting a database connection error. Can you help diagnose it?
```

### Port Conflicts

```
Port 3001 is already in use. Find what's using it and help me resolve it.
```

### Auth Not Working

```
Authentication isn't working. Can you check the BetterAuth configuration?
```

### Entity Generation Failed

```
The entity generation failed. Can you check my .apsorc schema for errors?
```

---

## Next Steps

- [Templates Reference](templates.md) - Available schema templates
- [Backend Bootstrapper Skill](../skills/backend-bootstrapper.md) - Detailed skill documentation
- [Auth Bootstrapper Skill](../skills/auth-bootstrapper.md) - Authentication setup details
