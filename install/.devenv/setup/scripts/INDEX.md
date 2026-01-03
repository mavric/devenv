# Scripts Index

Quick reference to all automation scripts in this directory.

## Main Scripts

### setup-apso-betterauth.sh
**Purpose:** Complete automated setup for Apso + BetterAuth

**Features:**
- Creates backend (NestJS + Apso + BetterAuth)
- Creates frontend (Next.js + BetterAuth client)
- Configures environment variables
- Initializes PostgreSQL database
- Starts development servers
- Verifies everything works

**Usage:**
```bash
# Interactive mode
./scripts/setup-apso-betterauth.sh

# Automated mode
./scripts/setup-apso-betterauth.sh \
  --project-name my-saas \
  --backend-port 3001 \
  --frontend-port 3003

# Help
./scripts/setup-apso-betterauth.sh --help
```

**Time:** ~5 minutes

---

### verify-setup.sh
**Purpose:** Comprehensive health check and diagnostics

**Features:**
- Checks prerequisites (Node, PostgreSQL, etc.)
- Validates directory structure
- Tests environment variables
- Verifies database connection
- Tests running services
- Checks code structure
- Validates dependencies

**Usage:**
```bash
# Basic verification
./scripts/verify-setup.sh

# Verbose mode
./scripts/verify-setup.sh --verbose

# Custom ports
./scripts/verify-setup.sh --backend-port 4000 --frontend-port 4001
```

**Exit Codes:**
- 0 = All checks passed
- 1 = Critical failures

---

### stop-servers.sh
**Purpose:** Stop backend and frontend development servers

**Features:**
- Reads PIDs from dev-servers.pid
- Gracefully stops processes
- Cleans up PID file
- Fallback: kills processes on ports 3001/3003

**Usage:**
```bash
./scripts/stop-servers.sh
```

---

### restart-servers.sh
**Purpose:** Restart both development servers

**Features:**
- Stops existing servers
- Waits for clean shutdown
- Starts fresh processes
- Saves new PIDs

**Usage:**
```bash
./scripts/restart-servers.sh
```

---

### view-logs.sh
**Purpose:** View development server logs in real-time

**Features:**
- View backend logs only
- View frontend logs only
- View both with tail -f

**Usage:**
```bash
# View both (default)
./scripts/view-logs.sh
./scripts/view-logs.sh both

# View backend only
./scripts/view-logs.sh backend

# View frontend only
./scripts/view-logs.sh frontend
```

**Log Files:**
- Backend: /tmp/backend-dev.log
- Frontend: /tmp/frontend-dev.log

---

### fresh-start.sh
**Purpose:** Complete reset - removes everything and starts fresh

**WARNING:** This will DELETE:
- backend/ directory
- frontend/ directory
- Database (with confirmation)
- All generated files and logs

**Features:**
- Stops all servers
- Removes all generated files
- Drops database
- Cleans up logs
- Optionally runs setup immediately

**Usage:**
```bash
./scripts/fresh-start.sh
```

**Safety:**
- Requires typing "yes" to confirm
- Prompts for database name
- Asks before running setup

---

### test-auth.sh
**Purpose:** Test authentication endpoints

**Features:**
- Health checks backend
- Tests auth endpoint
- Demo signup request
- Shows example curl commands

**Usage:**
```bash
# Default port
./scripts/test-auth.sh

# Custom port
./scripts/test-auth.sh --backend-port 4000
```

---

## Documentation

### README.md
**Purpose:** Complete documentation for all scripts

**Contents:**
- Detailed script descriptions
- Usage examples
- Configuration options
- Troubleshooting guide
- Platform-specific instructions
- Security notes

### QUICK-REFERENCE.md
**Purpose:** One-page cheat sheet

**Contents:**
- Common commands
- Quick setup flow
- File locations
- Environment variables
- Quick fixes

### INDEX.md (this file)
**Purpose:** Quick navigation to all scripts

---

## Quick Start Recipes

### First Time Setup
```bash
./scripts/setup-apso-betterauth.sh
./scripts/verify-setup.sh
open http://localhost:3003
```

### Daily Development
```bash
./scripts/verify-setup.sh
./scripts/view-logs.sh both &
# develop...
./scripts/stop-servers.sh
```

### Troubleshooting
```bash
./scripts/verify-setup.sh --verbose
./scripts/view-logs.sh both
./scripts/restart-servers.sh
```

### Complete Reset
```bash
./scripts/fresh-start.sh
```

---

## File Structure

```
scripts/
├── setup-apso-betterauth.sh   # Main setup script (38KB)
├── verify-setup.sh            # Health check (18KB)
├── stop-servers.sh            # Stop servers (2KB)
├── restart-servers.sh         # Restart servers (1KB)
├── view-logs.sh               # View logs (2KB)
├── fresh-start.sh             # Complete reset (4.5KB)
├── test-auth.sh               # Test endpoints (3.4KB)
├── README.md                  # Full documentation (9.2KB)
├── QUICK-REFERENCE.md         # Cheat sheet (6.8KB)
└── INDEX.md                   # This file
```

---

## Script Dependencies

All scripts are standalone bash scripts with minimal dependencies:
- bash (any modern version)
- Standard Unix tools (grep, sed, awk, etc.)
- curl (for health checks)
- lsof (for port checking)

Platform support:
- macOS (primary)
- Linux (Ubuntu, Debian, CentOS)
- Windows (WSL2)

---

## Environment Requirements

Before running setup:
- Node.js >= 18.0.0
- npm >= 9.0.0
- PostgreSQL >= 13.0
- Git (optional)

Check with:
```bash
node --version
npm --version
psql --version
```

---

## Common Options

All scripts support:
- `--help` - Show help message
- Colored output (automatic)
- Safe error handling
- Progress reporting

Main setup script additional options:
- `--project-name NAME`
- `--backend-port PORT`
- `--frontend-port PORT`
- `--db-name NAME`
- `--db-user USER`
- `--db-password PASS`
- `--db-host HOST`
- `--db-port PORT`
- `--skip-install`
- `--skip-db`

---

## Related Documentation

In project root:
- `SETUP-AUTOMATION.md` - Comprehensive setup guide
- `QUICKSTART.md` - Project quickstart
- `apso/apso-schema-guide.md` - Apso CLI reference
- `saas/saas-tech-stack.md` - Tech stack details

---

## Support

For help:
1. Run `--help` on any script
2. Check `README.md` for detailed docs
3. Review `QUICK-REFERENCE.md` for common fixes
4. Run `verify-setup.sh --verbose` for diagnostics

---

**Last Updated:** 2025-01-18
**Version:** 1.0.0
