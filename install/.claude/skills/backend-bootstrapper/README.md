# Backend Bootstrapper Skill

Fully automated Apso + BetterAuth backend setup in under 5 minutes with zero manual steps.

## What This Skill Does

Automates the complete setup of a production-ready NestJS backend with:

- Apso-generated REST API
- BetterAuth integration
- PostgreSQL database
- Multi-tenancy support
- OpenAPI documentation
- Automated testing
- Complete error handling

## Quick Start

### Option 1: New Backend with Auth
```
"Setup backend with auth"
```

I will:
1. Create Apso project structure
2. Generate .apsorc with BetterAuth entities
3. Run code generation
4. Auto-fix all known issues
5. Set up database
6. Verify everything works

**Time:** 5 minutes | **Manual steps:** 0

### Option 2: Add Auth to Existing Backend
```
"Add auth to my backend"
```

I will:
1. Analyze existing schema
2. Detect naming conflicts
3. Add BetterAuth entities
4. Regenerate code
5. Fix integration issues
6. Test endpoints

**Time:** 3 minutes | **Manual steps:** 0

### Option 3: Fix Auth Issues
```
"Fix auth issues"
```

I will automatically fix:
- Missing id fields in DTOs
- Nullable field constraints
- Entity naming conflicts
- AppModule wiring
- Database schema issues

**Time:** 1 minute | **Manual steps:** 0

### Option 4: Verify Setup
```
"Verify auth setup"
```

I will test:
- All CRUD endpoints
- Database integrity
- Auth flows
- Multi-tenancy
- Session management

**Time:** 2 minutes | **Manual steps:** 0

## File Structure

```
backend-bootstrapper/
├── SKILL.md                          # Main skill documentation
├── README.md                         # This file
└── references/
    ├── apsorc-templates/             # Ready-to-use .apsorc files
    │   ├── minimal-auth.json         # Basic auth setup
    │   ├── saas-platform.json        # Full SaaS (coming soon)
    │   ├── marketplace.json          # Multi-vendor (coming soon)
    │   └── collaboration-tool.json   # Team tools (coming soon)
    │
    ├── fix-scripts/                  # Automated fix scripts
    │   ├── fix-dto-id-fields.sh      # Add id to DTOs
    │   ├── fix-nullable-fields.sh    # Fix User entity nullables
    │   ├── fix-entity-conflicts.sh   # Rename conflicting entities
    │   └── fix-app-module.sh         # Wire modules correctly
    │
    ├── verification-commands/        # Testing scripts
    │   ├── test-auth-flow.sh         # Complete auth test suite
    │   ├── test-crud.sh              # CRUD endpoint tests
    │   └── test-database.sh          # Database integrity tests
    │
    ├── troubleshooting/              # Issue resolution
    │   ├── common-issues.md          # Problems & solutions
    │   └── debugging-guide.md        # Advanced debugging
    │
    ├── setup-checklist.md            # Step-by-step checklist
    ├── better-auth-integration.md    # BetterAuth deep dive
    ├── saas-implementation-guide.md  # SaaS patterns
    └── saas-tech-stack.md            # Tech stack details
```

## What Gets Created

### Backend Structure
```
backend/
├── src/
│   ├── autogen/           # Apso-generated (don't edit)
│   │   ├── User/
│   │   ├── account/
│   │   ├── session/
│   │   ├── verification/
│   │   └── Organization/
│   ├── extensions/        # Your custom code
│   ├── common/            # Shared utilities
│   └── main.ts
├── .apsorc                # Schema definition
├── .env.development       # Dev environment
├── docker-compose.yml     # Local PostgreSQL
└── package.json
```

### Database Tables
- `user` - Authentication users (Better Auth)
- `account` - OAuth/credential providers (Better Auth)
- `session` - Active sessions (Better Auth)
- `verification` - Email verification (Better Auth)
- `organization` - Multi-tenant root (Your business)
- `account_user` - User-Organization junction (Your business)

### API Endpoints

For each entity, you get:
- `GET /{entity}` - List with pagination, filtering, sorting
- `GET /{entity}/{id}` - Get by ID
- `POST /{entity}` - Create
- `PUT /{entity}/{id}` - Full update
- `PATCH /{entity}/{id}` - Partial update
- `DELETE /{entity}/{id}` - Delete

Plus:
- `/health` - Health check
- `/api/docs` - OpenAPI/Swagger UI

## Key Features

### Auto-Fixes

I automatically fix these common issues:

1. **Missing id in DTOs** - Add `id` field to Create DTOs
2. **Nullable constraints** - Mark User optional fields as nullable
3. **Entity conflicts** - Rename Account/Session to avoid conflicts
4. **Module wiring** - Import all modules in AppModule
5. **CORS configuration** - Enable cross-origin requests
6. **Database schema** - Reset when needed

### Verification Tests

I automatically verify:

- Server health
- Database connection
- Table creation
- CRUD operations
- Foreign keys
- Unique constraints
- Nullable fields
- Enum validation

### Environment Management

I create and configure:
- `.env.development` - Local development
- `.env.test` - Test environment
- `.env.production.example` - Production template

With secure defaults for:
- Database connection
- BetterAuth secrets
- CORS origins
- Logging levels

## Common Use Cases

### New SaaS Project
```
User: "I need a backend for my SaaS product"
Skill: Creates complete authenticated backend with Organization multi-tenancy
```

### Add Auth to Existing
```
User: "Add authentication to my existing backend"
Skill: Analyzes schema, adds auth entities, fixes conflicts automatically
```

### Fix Integration Issues
```
User: "My auth isn't working"
Skill: Runs diagnostics, applies fixes, verifies everything works
```

### Verify Setup
```
User: "Is my backend set up correctly?"
Skill: Runs comprehensive tests, reports status, suggests fixes
```

## Integration Points

### With Schema Architect
The skill can use schemas from schema-architect or create minimal schemas for quick starts.

### With Frontend
After backend setup, guides frontend integration:
1. Install BetterAuth adapter
2. Configure auth client
3. Test end-to-end flow

### With Feature Builder
Provides working backend for feature-builder to add business logic.

### With Test Generator
Generates E2E tests for all auth flows and endpoints.

## Success Metrics

- **Setup time:** < 5 minutes
- **Manual steps:** 0
- **Auto-fix rate:** > 95%
- **Test coverage:** 100% of endpoints

## Troubleshooting

If issues occur:

1. **Check logs:** `npm run start:dev`
2. **Run auto-fix:** "Fix auth issues"
3. **Verify database:** `psql -c "\dt"`
4. **Test endpoints:** `bash references/verification-commands/test-auth-flow.sh`
5. **Check references:** `references/troubleshooting/common-issues.md`

## Reference Documentation

- **SKILL.md** - Complete skill documentation
- **setup-checklist.md** - Step-by-step setup guide
- **better-auth-integration.md** - BetterAuth deep dive
- **common-issues.md** - Troubleshooting guide
- **apsorc-templates/** - Ready-to-use schemas

## Quick Reference Commands

```bash
# Start backend
npm run start:dev

# Reset database
psql -U postgres -d backend_dev -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

# Fix DTOs
bash references/fix-scripts/fix-dto-id-fields.sh

# Test auth flow
bash references/verification-commands/test-auth-flow.sh

# View all tables
psql -U postgres -d backend_dev -c "\dt"
```

## Next Steps After Setup

1. **Frontend Integration**
   - Install BetterAuth adapter
   - Configure auth client
   - Add signup/signin forms

2. **Custom Endpoints**
   - Add business logic to extensions/
   - Create custom controllers
   - Implement service methods

3. **Testing**
   - Write unit tests
   - Add E2E tests
   - Verify coverage

4. **Deployment**
   - Set up CI/CD
   - Configure production database
   - Deploy to AWS/Vercel

## License

Part of Mavric SaaS Development Framework
