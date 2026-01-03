# Apso + BetterAuth Setup Automation

Complete automation scripts for setting up a full-stack Apso backend + Next.js frontend with BetterAuth authentication in 5 minutes.

## Quick Start

```bash
# Complete setup in one command
./scripts/setup-apso-betterauth.sh

# Verify everything works
./scripts/verify-setup.sh

# Open your browser
open http://localhost:3003
```

That's it! Your full-stack application is ready.

## What Gets Created

### Backend (NestJS + Apso + BetterAuth)

```
backend/
├── src/
│   ├── main.ts                  # Server entry point
│   ├── app.module.ts            # Main app module
│   ├── config/
│   │   └── typeorm.config.ts    # Database configuration
│   └── auth/
│       ├── auth.module.ts       # Auth module
│       ├── auth.service.ts      # Auth service
│       ├── auth.controller.ts   # Auth endpoints
│       └── auth.config.ts       # BetterAuth config
├── .env                         # Environment variables
├── package.json
├── tsconfig.json
└── nest-cli.json
```

### Frontend (Next.js + BetterAuth Client)

```
frontend/
├── app/
│   ├── page.tsx                 # Home page (protected)
│   ├── login/
│   │   └── page.tsx             # Login/signup page
│   └── api/
│       └── auth/
│           └── [...all]/
│               └── route.ts     # Auth API route handler
├── lib/
│   └── auth-client.ts           # BetterAuth client
├── .env.local                   # Frontend env vars
└── package.json
```

### Database

PostgreSQL database with:
- User authentication tables (BetterAuth schema)
- Session management
- Ready for TypeORM migrations

### Environment Variables

Automatically generated with secure random secrets:

**Backend (.env)**
```bash
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=your-password
DB_NAME=project_name_dev

PORT=3001
NODE_ENV=development
FRONTEND_URL=http://localhost:3003

JWT_SECRET=<cryptographically-secure-random>
AUTH_SECRET=<cryptographically-secure-random>
```

**Frontend (.env.local)**
```bash
NEXT_PUBLIC_API_URL=http://localhost:3001
BETTER_AUTH_SECRET=<matches-backend>
BETTER_AUTH_URL=http://localhost:3003
```

## Available Scripts

| Script | Purpose | Example |
|--------|---------|---------|
| `setup-apso-betterauth.sh` | Complete setup from scratch | `./scripts/setup-apso-betterauth.sh` |
| `verify-setup.sh` | Health check and diagnostics | `./scripts/verify-setup.sh` |
| `stop-servers.sh` | Stop development servers | `./scripts/stop-servers.sh` |
| `restart-servers.sh` | Restart both servers | `./scripts/restart-servers.sh` |
| `view-logs.sh` | View server logs | `./scripts/view-logs.sh both` |
| `fresh-start.sh` | Nuclear reset - start completely fresh | `./scripts/fresh-start.sh` |
| `test-auth.sh` | Test authentication endpoints | `./scripts/test-auth.sh` |

## Features

### Setup Script Features

1. **Prerequisites Check**
   - Node.js >= 18
   - npm >= 9
   - PostgreSQL >= 13
   - Git (optional)

2. **Interactive Configuration**
   - Project name
   - Custom ports (backend/frontend)
   - Database credentials
   - Confirmation before proceeding

3. **Automated Setup**
   - Creates backend with NestJS + Apso
   - Creates frontend with Next.js
   - Installs all dependencies
   - Generates secure environment variables
   - Initializes PostgreSQL database
   - Runs migrations
   - Starts development servers

4. **Progress Indicators**
   - Colored output (green/red/yellow/blue)
   - Spinner animations for long operations
   - Step-by-step progress reporting

5. **Error Handling**
   - Automatic rollback on failure
   - Detailed error messages
   - Cleanup of partial installations

6. **Health Checks**
   - Verifies backend is running
   - Verifies frontend is running
   - Tests database connection
   - Validates endpoints

### Verification Script Features

Comprehensive checks:
- Prerequisites installed
- Directories exist
- Environment variables configured
- Database connection
- Database tables created
- Backend server running
- Frontend server running
- Code structure correct
- Dependencies installed
- Endpoints responding

Outputs:
- Detailed pass/fail for each check
- Success rate percentage
- Recommendations for fixes

## Usage Examples

### Basic Setup

```bash
# Interactive mode (recommended for first time)
./scripts/setup-apso-betterauth.sh
```

You'll be prompted for:
- Project name
- Database name (auto-suggested)
- Database password
- Confirmation

### Automated Setup

```bash
# Non-interactive with all options
./scripts/setup-apso-betterauth.sh \
  --project-name my-saas \
  --backend-port 3001 \
  --frontend-port 3003 \
  --db-name my_saas_dev \
  --db-password mypassword
```

### Custom Configuration

```bash
# Custom database server
./scripts/setup-apso-betterauth.sh \
  --db-host 192.168.1.100 \
  --db-port 5433 \
  --db-user myuser \
  --db-password mypassword

# Custom ports
./scripts/setup-apso-betterauth.sh \
  --backend-port 4000 \
  --frontend-port 4001

# Skip time-consuming steps
./scripts/setup-apso-betterauth.sh \
  --skip-install \
  --skip-db
```

### Verification

```bash
# Basic verification
./scripts/verify-setup.sh

# Verbose mode (detailed output)
./scripts/verify-setup.sh --verbose

# Custom ports
./scripts/verify-setup.sh \
  --backend-port 4000 \
  --frontend-port 4001
```

### Server Management

```bash
# View logs
./scripts/view-logs.sh both       # Both servers
./scripts/view-logs.sh backend    # Backend only
./scripts/view-logs.sh frontend   # Frontend only

# Restart servers
./scripts/restart-servers.sh

# Stop servers
./scripts/stop-servers.sh
```

### Fresh Start

```bash
# Complete reset (will prompt for confirmation)
./scripts/fresh-start.sh

# Removes everything and can optionally run setup immediately
```

## Workflow Examples

### New Developer Onboarding

```bash
# Day 1 - Setup
git clone <repo>
cd lightbulb-v2
./scripts/setup-apso-betterauth.sh

# Verify
./scripts/verify-setup.sh

# Start coding
open http://localhost:3003
```

### Daily Development

```bash
# Morning - verify everything works
./scripts/verify-setup.sh

# View logs in separate terminal
./scripts/view-logs.sh both

# Develop (servers auto-reload on changes)
# ...

# End of day - stop servers
./scripts/stop-servers.sh
```

### After Pulling Updates

```bash
# Pull latest code
git pull

# Reinstall dependencies if needed
cd backend && npm install
cd ../frontend && npm install

# Restart servers
./scripts/restart-servers.sh

# Verify
./scripts/verify-setup.sh
```

### Debugging Issues

```bash
# Full diagnostic
./scripts/verify-setup.sh --verbose

# Check logs
./scripts/view-logs.sh both

# Restart servers
./scripts/restart-servers.sh

# If still broken - fresh start
./scripts/fresh-start.sh
```

### Testing Before Deployment

```bash
# Verify everything
./scripts/verify-setup.sh

# Test authentication
./scripts/test-auth.sh

# Manual testing
open http://localhost:3003
```

## Architecture

### Authentication Flow

1. **User Sign Up/Sign In**
   - Frontend form at `/login`
   - Submits to BetterAuth client
   - Client sends to `/api/auth/*` endpoint

2. **Backend Processing**
   - Next.js API route forwards to backend
   - Backend auth controller handles request
   - BetterAuth service validates and creates session
   - JWT token returned

3. **Session Management**
   - Token stored in HTTP-only cookie
   - Frontend checks session with `useSession()`
   - Protected routes redirect if no session

4. **Protected Routes**
   - Home page (`/`) requires authentication
   - Redirects to `/login` if not authenticated
   - Shows user info if authenticated

### Database Schema

BetterAuth creates tables:
- `user` - User accounts
- `session` - Active sessions
- `verification_token` - Email verification
- `account` - OAuth provider links

Ready to extend with your custom entities using Apso.

## Customization

### Adding OAuth Providers

1. Get credentials from provider (Google, GitHub, etc.)

2. Add to backend `.env`:
   ```bash
   GOOGLE_CLIENT_ID=your-client-id
   GOOGLE_CLIENT_SECRET=your-client-secret
   ```

3. Restart backend:
   ```bash
   ./scripts/restart-servers.sh
   ```

4. Use in frontend:
   ```tsx
   import { signIn } from '@/lib/auth-client';

   await signIn.social({ provider: 'google' });
   ```

### Custom Ports

All scripts support custom ports:

```bash
# Setup with custom ports
./scripts/setup-apso-betterauth.sh \
  --backend-port 4000 \
  --frontend-port 4001

# Verify with same ports
./scripts/verify-setup.sh \
  --backend-port 4000 \
  --frontend-port 4001
```

### Database Configuration

Support for:
- Local PostgreSQL
- Remote PostgreSQL server
- Cloud databases (RDS, etc.)
- Custom ports and credentials

```bash
./scripts/setup-apso-betterauth.sh \
  --db-host db.example.com \
  --db-port 5433 \
  --db-user myuser \
  --db-password mypassword \
  --db-name production_db
```

### Environment Variables

After setup, customize in:
- `backend/.env` - Backend configuration
- `frontend/.env.local` - Frontend configuration

## Troubleshooting

### Common Issues

**Issue:** Port already in use
```bash
# Find what's using the port
lsof -i :3001

# Kill the process
kill -9 <PID>

# Or use different ports
./scripts/setup-apso-betterauth.sh --backend-port 4000
```

**Issue:** PostgreSQL not running
```bash
# macOS
brew services start postgresql

# Linux
sudo systemctl start postgresql

# Verify
pg_isready
```

**Issue:** Database already exists
```bash
# Drop manually
psql -U postgres -c "DROP DATABASE my_saas_dev;"

# Or let script prompt you
./scripts/setup-apso-betterauth.sh
```

**Issue:** Node version too old
```bash
# Check version
node --version

# Update
# macOS
brew upgrade node

# Linux (nvm)
nvm install 18
nvm use 18
```

**Issue:** Servers won't start
```bash
# Check logs
./scripts/view-logs.sh both

# Rebuild
cd backend && npm run build
cd frontend && npm run build

# Restart
./scripts/restart-servers.sh
```

**Issue:** Complete failure - nuclear option
```bash
# Fresh start - removes everything
./scripts/fresh-start.sh

# Then setup again
./scripts/setup-apso-betterauth.sh
```

## Log Files

All logs stored in `/tmp/`:

| File | Contents |
|------|----------|
| `backend-dev.log` | Backend runtime logs |
| `frontend-dev.log` | Frontend runtime logs |
| `backend-install.log` | Backend npm install output |
| `frontend-create.log` | Next.js creation output |
| `backend-build.log` | Backend build output |
| `db-create.log` | Database creation output |
| `migration-run.log` | Migration output |

View with:
```bash
# Tail logs
tail -f /tmp/backend-dev.log

# Or use helper script
./scripts/view-logs.sh backend
```

## Platform Support

Tested on:
- macOS (primary platform)
- Linux (Ubuntu, Debian, CentOS)
- Windows (via WSL2)

### macOS Setup

```bash
# Install prerequisites
brew install node postgresql

# Start PostgreSQL
brew services start postgresql

# Run setup
./scripts/setup-apso-betterauth.sh
```

### Linux Setup

```bash
# Install prerequisites
sudo apt-get update
sudo apt-get install nodejs npm postgresql

# Start PostgreSQL
sudo systemctl start postgresql

# Run setup
./scripts/setup-apso-betterauth.sh
```

### Windows (WSL2) Setup

```bash
# In WSL2 terminal
sudo apt-get update
sudo apt-get install nodejs npm postgresql

# Start PostgreSQL
sudo service postgresql start

# Run setup
./scripts/setup-apso-betterauth.sh
```

## Security

### Generated Secrets

Scripts generate cryptographically secure secrets:
- Uses `openssl rand -base64 32` when available
- Falls back to `/dev/urandom` if needed
- Applied to JWT_SECRET and AUTH_SECRET

### Best Practices

1. **Never commit secrets to git**
   ```bash
   # Already in .gitignore
   .env
   .env.local
   ```

2. **Use strong database passwords**
   ```bash
   # Generate strong password
   ./scripts/setup-apso-betterauth.sh \
     --db-password "$(openssl rand -base64 32)"
   ```

3. **Rotate secrets regularly**
   - Regenerate AUTH_SECRET and JWT_SECRET
   - Update both backend and frontend .env files
   - Restart servers

4. **Production considerations**
   - Use environment-specific secrets
   - Store secrets in secure vault
   - Enable HTTPS
   - Configure CORS properly

## Integration with Existing Project

If you already have backend/frontend:

```bash
# Backup existing
mv backend backend.backup
mv frontend frontend.backup

# Run setup
./scripts/setup-apso-betterauth.sh

# Migrate your code
cp -r backend.backup/src/custom-modules backend/src/
cp -r frontend.backup/app/custom-pages frontend/app/

# Restart
./scripts/restart-servers.sh
```

## Next Steps After Setup

1. **Test Authentication**
   - Go to http://localhost:3003/login
   - Create an account
   - Sign in
   - Verify session on home page

2. **Start Building**
   - Add Apso entities to backend
   - Create frontend pages
   - Implement business logic

3. **Use Apso CLI**
   ```bash
   cd backend
   apso generate crud --entity YourEntity
   ```

4. **Deploy**
   - Backend: AWS via Apso
   - Frontend: Vercel
   - Database: AWS RDS

## Documentation

- **Quick Reference:** `scripts/QUICK-REFERENCE.md`
- **Full README:** `scripts/README.md`
- **Main Quickstart:** `QUICKSTART.md`
- **Apso Guide:** `apso/apso-schema-guide.md`
- **Tech Stack:** `saas/saas-tech-stack.md`

## Support

Run help for any script:

```bash
./scripts/setup-apso-betterauth.sh --help
./scripts/verify-setup.sh --help
```

## Contributing

When adding new scripts:
1. Follow naming convention
2. Add colored output
3. Include help message
4. Document in README
5. Make executable: `chmod +x script.sh`

## License

MIT

---

**Created:** 2025-01-18
**Last Updated:** 2025-01-18
**Version:** 1.0.0
