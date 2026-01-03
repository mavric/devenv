# Automated Setup

Complete Apso + BetterAuth project setup in 5 minutes using Claude Code.

---

## Quick Start

In Claude Code, simply ask:

```
Set up an Apso backend with BetterAuth authentication for my project
```

**What you'll have:**

- Apso NestJS backend with REST API
- BetterAuth authentication
- PostgreSQL database configured
- Next.js frontend
- Both servers running

---

## Setup Options

### Basic Setup

```
Set up a new Apso backend with BetterAuth
```

Claude Code will prompt you for:

- Project name
- Database name
- Port preferences

### Detailed Setup

Provide all details upfront:

```
Set up an Apso backend with BetterAuth.
Project name: my-saas
Database name: my_saas_dev
Backend port: 3001
Frontend port: 3003
```

### Using a Template

```
Set up an Apso backend using the minimal SaaS template
```

Or for a full-featured B2B setup:

```
Set up an Apso backend using the complete SaaS template
```

---

## What Claude Code Does

### Phase 1: Prerequisites Check

Claude Code verifies:

- Node.js version (>= 18)
- npm version (>= 9)
- PostgreSQL is running
- Ports are available

If anything is missing, Claude Code will help you resolve it.

### Phase 2: Backend Setup

1. Creates `backend/` directory
2. Initializes Apso project
3. Configures `.apsorc` with entities
4. Runs `apso server scaffold`
5. Installs dependencies
6. Creates `.env` with secure secrets

### Phase 3: Database Setup

1. Creates PostgreSQL database
2. Configures connection
3. Runs migrations
4. Verifies tables created

### Phase 4: Authentication Setup

1. Adds BetterAuth entities to schema
2. Configures auth endpoints
3. Sets up session handling
4. Generates secure secrets

### Phase 5: Frontend Setup

1. Creates Next.js project
2. Installs BetterAuth client
3. Configures environment
4. Sets up auth integration

### Phase 6: Verification

1. Starts development servers
2. Tests health endpoints
3. Verifies database connection
4. Confirms auth is working

---

## Generated Structure

```
my-project/
├── backend/
│   ├── src/
│   │   ├── autogen/          # Generated code (don't edit)
│   │   └── extensions/       # Your custom code
│   ├── .apsorc               # Schema definition
│   ├── .env                  # Configuration
│   └── docker-compose.yml
│
└── frontend/
    ├── app/                  # Next.js pages
    ├── lib/                  # Auth client
    └── .env.local            # Configuration
```

---

## Environment Variables

### Backend (.env)

```bash
NODE_ENV=development
PORT=3001

# Database
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=your-password
DB_NAME=project_name_dev

# Auth (auto-generated)
JWT_SECRET=<secure-random>
AUTH_SECRET=<secure-random>

# CORS
FRONTEND_URL=http://localhost:3003
```

### Frontend (.env.local)

```bash
NEXT_PUBLIC_API_URL=http://localhost:3001
BETTER_AUTH_SECRET=<secure-random>
BETTER_AUTH_URL=http://localhost:3003
```

---

## Custom Configuration

### Different Ports

```
Set up backend on port 4000 and frontend on port 4001
```

### External Database

```
Set up backend using external PostgreSQL at 192.168.1.100:5433
Database: custom_db
User: myuser
Password: mypassword
```

### Skip Steps

```
Set up backend but skip the frontend for now
```

Or:

```
Set up backend, I'll handle the database separately
```

---

## Common Tasks After Setup

### Check Status

```
Are my servers running? Check the health endpoints.
```

### Restart Servers

```
Restart the backend and frontend servers
```

### View Logs

```
Show me the backend server logs
```

### Stop Servers

```
Stop all development servers
```

---

## Troubleshooting

### PostgreSQL Connection Issues

```
I'm getting a database connection error. Can you help?
```

Claude Code will:

1. Check if PostgreSQL is running
2. Verify connection settings
3. Test the connection
4. Suggest fixes

### Port Conflicts

```
Port 3001 is in use. Help me fix this.
```

Claude Code will:

1. Find what's using the port
2. Offer to kill the process or use a different port
3. Update configuration if needed

### Database Already Exists

```
The database already exists. Should I recreate it?
```

Claude Code will ask for confirmation before dropping/recreating.

### Auth Not Working

```
Authentication isn't working. Can you diagnose it?
```

Claude Code will check:

- Auth secret configuration
- Session handling
- Endpoint availability
- Cookie settings

---

## Verify Setup

After setup completes:

```
Verify my backend setup is working correctly
```

Claude Code checks:

| Check | What It Verifies |
|-------|------------------|
| Database | Connection successful |
| Backend | Health endpoint responds |
| Auth | Login/register endpoints work |
| Frontend | Dev server running |

---

## Access Your Services

| Service | URL |
|---------|-----|
| Backend API | http://localhost:3001 |
| OpenAPI Docs | http://localhost:3001/api/docs |
| Frontend | http://localhost:3003 |

---

## Next Steps

After setup is complete:

- [Add features](../skills/feature-builder.md) - Build your application
- [Run discovery](../commands/start-project.md) - Gather requirements properly
- [Generate tests](../skills/test-generator.md) - Create test scenarios
