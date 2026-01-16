# Apso Setup Learnings

**Source:** GoLotus Project Build (January 2026)
**Status:** Verified fixes that should be applied to all new projects

---

## Critical Configuration Rules

### 1. `.apsorc` rootFolder Must Be `./src`

**Problem:** Code generation fails or generates in wrong location if rootFolder is incorrect.

**Correct:**
```json
{
  "service": "your-api",
  "rootFolder": "./src",
  "database": { ... }
}
```

**Wrong:**
```json
{
  "rootFolder": "src/generated",  // Wrong - will create nested folders
  "rootFolder": "src",            // Wrong - missing ./
  "rootFolder": "./src/generated" // Wrong - should be just ./src
}
```

**Why:** Apso expects `./src` as the standard root. The CLI creates `src/autogen/` and `src/extensions/` inside this path.

---

### 2. Docker Compose Port Handling

**Problem:** The `apso-compose.sh` script was appending `:5432` to the port variable, causing "Invalid IP address" errors.

**Fixed Script Pattern:**
```bash
# apso-compose.sh - CORRECT
info "DATABASE_PORT=${DATABASE_PORT}"
run COMPOSE_FILE="${currentDir}/compose/docker-compose.yml" DATABASE_PORT="${DATABASE_PORT}" \
    docker-compose up --detach --remove-orphans --build
```

**Wrong:**
```bash
# WRONG - Don't append :5432
run COMPOSE_FILE="${currentDir}/compose/docker-compose.yml" DATABASE_PORT="${DATABASE_PORT}:5432" \
    docker-compose up --detach --remove-orphans --build
```

**Why:** docker-compose.yml already handles the port mapping with `${DATABASE_PORT}:5432`. The shell script should pass the external port only.

---

### 3. Provision Scripts Must Use Environment Variables

**Problem:** Hardcoded `root/root` credentials fail when database uses different credentials.

**Fixed Pattern:**
```bash
# provision/default-schema.sh - CORRECT
ROOT_USERNAME="${DATABASE_USERNAME}"
ROOT_PASSWORD="${DATABASE_PASSWORD}"
ROOT_DATABASE="postgres"  # Always use postgres for admin operations
TARGET_DATABASE="${DATABASE_NAME}"
```

**Wrong:**
```bash
# WRONG - Hardcoded credentials
ROOT_USERNAME="root"
ROOT_PASSWORD="root"
ROOT_DATABASE="postgres"
```

**Why:** Apso scaffolding creates databases with `apso/password` or custom credentials. Scripts must read from environment.

---

### 4. Environment Files Need Quoted Values

**Problem:** Values with spaces in `.env` files cause bash parsing errors.

**Correct:**
```bash
# .env - CORRECT (quoted values with spaces)
APP_NAME="GoLotus API"
SESSION_SECRET="wine is fine, whiskey is swell, but beer is better"
DATABASE_PORT=59329
DATABASE_USERNAME=apso
DATABASE_PASSWORD=password
```

**Wrong:**
```bash
# WRONG - Unquoted values with spaces
APP_NAME=GoLotus API
SESSION_SECRET=wine is fine, whiskey is swell
```

**Error Message:** `API: command not found` (bash interprets "API" as a command)

---

### 5. docker-compose.yml Version Attribute

**Problem:** `version` attribute is obsolete and generates warnings.

**Correct:**
```yaml
# docker-compose.yml - No version attribute
services:
  postgres:
    hostname: postgres
    image: postgres:14.6
    ...
```

**Deprecated:**
```yaml
# DEPRECATED - Remove version attribute
version: '3.8'
services:
  ...
```

**Why:** Docker Compose v2 ignores the version attribute. Including it triggers deprecation warnings.

---

## Verification Checklist

When setting up a new Apso backend, verify:

- [ ] `.apsorc` has `"rootFolder": "./src"`
- [ ] `apso-compose.sh` doesn't append `:5432` to DATABASE_PORT
- [ ] Provision scripts use `${DATABASE_USERNAME}` and `${DATABASE_PASSWORD}`
- [ ] `.env` values with spaces are quoted
- [ ] `docker-compose.yml` has no `version` attribute
- [ ] `npm run compose` starts without errors
- [ ] `npm run provision` creates tables without auth failures
- [ ] `npm run start:dev` runs on expected port

---

## Quick Test Commands

```bash
# After setup, these should all work:
cd server/your-api

# Start database
npm run compose
# Expected: PostgreSQL container starts

# Provision schema
npm run provision
# Expected: Tables created successfully

# Start server
npm run start:dev
# Expected: Server on port 3100 (or configured port)

# Health check
curl http://localhost:3100/health
# Expected: "I am up!" or similar
```

---

**Last Updated:** 2026-01-15
