# Common Tasks Reference

Reference for common development tasks you can perform through Claude Code.

---

## Server Management

### Start Servers

```
Start the backend and frontend development servers
```

Claude Code will:

1. Start backend with `npm run start:dev`
2. Start frontend with `npm run dev`
3. Confirm both are running

### Stop Servers

```
Stop all running development servers
```

Claude Code will:

1. Find running Node processes
2. Gracefully stop them
3. Confirm they're stopped

### Restart Servers

```
Restart the backend and frontend servers
```

Use this after:

- Configuration changes
- Installing new dependencies
- Schema updates

### Check Server Status

```
Are my servers running? Check their health endpoints.
```

Claude Code checks:

| Service | Check |
|---------|-------|
| Backend | `http://localhost:3001/health` |
| Frontend | `http://localhost:3003` |
| Database | PostgreSQL connection |

---

## Verification

### Full Verification

```
Verify my entire setup is working correctly
```

Claude Code checks:

1. **Prerequisites** - Node, npm, PostgreSQL versions
2. **Directories** - backend/, frontend/ exist
3. **Environment** - .env files present and valid
4. **Database** - Connection works, tables exist
5. **Services** - Backend and frontend responding
6. **Auth** - Login/register endpoints work

### Quick Health Check

```
Quick health check on the backend
```

### Database Verification

```
Check if the database connection is working and show me the tables
```

---

## Logging and Debugging

### View Backend Logs

```
Show me the backend server logs
```

### View Frontend Logs

```
Show me the frontend server logs
```

### View Both Logs

```
Show me logs from both servers
```

### Search Logs for Errors

```
Search the logs for any errors
```

### Tail Logs

```
Watch the backend logs in real-time
```

---

## Database Tasks

### Check Database Status

```
Is PostgreSQL running? Check the database connection.
```

### List Tables

```
Show me all tables in the database
```

### Run Migrations

```
Run database migrations
```

### Reset Database

```
Reset the database (drop and recreate)
```

!!! warning "Destructive Action"
    Claude Code will ask for confirmation before dropping the database.

---

## Dependency Management

### Install Dependencies

```
Install all npm dependencies for backend and frontend
```

### Update Dependencies

```
Update npm dependencies to latest versions
```

### Check for Outdated Packages

```
Check for outdated npm packages
```

### Install Specific Package

```
Install axios in the backend
```

Or:

```
Install @tanstack/react-query in the frontend
```

---

## Code Generation

### Regenerate Apso Entities

```
Regenerate the Apso entities from my .apsorc schema
```

### Fix DTO Imports

```
Fix the DTO import issues in the autogen folder
```

### Generate New Entity

```
Add a new entity called "Comment" to my schema and regenerate
```

---

## Environment Configuration

### Check Environment Variables

```
Show me the current environment configuration
```

### Update Environment Variable

```
Update the DATABASE_URL in my .env file
```

### Generate New Auth Secret

```
Generate a new AUTH_SECRET for production
```

---

## Troubleshooting

### Diagnose Connection Issues

```
I'm getting a database connection error. Can you diagnose it?
```

### Fix Port Conflicts

```
Port 3001 is in use. Help me resolve this.
```

### Debug Auth Issues

```
Authentication isn't working. Can you check the configuration?
```

### Check for Common Issues

```
Run a diagnostic check for common issues
```

---

## Project Cleanup

### Clean Build Artifacts

```
Clean all build artifacts and node_modules
```

### Fresh Reinstall

```
Do a fresh npm install for both backend and frontend
```

### Reset to Clean State

```
Reset everything to a clean state and set up again
```

!!! warning "Destructive Action"
    Claude Code will ask for confirmation before deleting directories.

---

## Quick Reference

| Task | What to Say |
|------|-------------|
| Start servers | "Start the dev servers" |
| Stop servers | "Stop all servers" |
| Restart servers | "Restart the servers" |
| Check health | "Are my servers running?" |
| View logs | "Show me the logs" |
| Verify setup | "Verify my setup" |
| Check database | "Check database connection" |
| Install deps | "Install dependencies" |
| Regenerate code | "Regenerate Apso entities" |
| Fix issues | "Help me fix [describe issue]" |

---

## Tips

### Be Specific

The more context you provide, the better Claude Code can help:

```
# Good
The backend server won't start. I'm seeing a database connection error in the logs.

# Less helpful
Server won't start
```

### Ask for Explanations

```
Restart the servers and explain what you're doing
```

### Chain Tasks

```
Stop the servers, update the schema, regenerate entities, and restart
```

### Get Help with Errors

Copy-paste error messages directly:

```
I'm getting this error: [paste error]
Can you help me fix it?
```
