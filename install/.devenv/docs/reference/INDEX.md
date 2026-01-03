# Repeatable SaaS Setup - Complete Reference Index

> Master index for all reference materials for building SaaS products using Apso, Better Auth, Next.js, and NestJS

---

## Quick Links

### For New Projects
- **[Setup Checklist](CONFIGURATION-TEMPLATES.md#quick-setup-checklist)** - Get a new project running in 30 minutes
- **[Configuration Templates](CONFIGURATION-TEMPLATES.md)** - Copy-paste templates for all config files
- **[Tech Stack Overview](TECH-STACK-COMPLETE.md#stack-overview)** - Understand the complete stack

### For Implementation
- **[API Patterns Reference](API-PATTERNS-REFERENCE.md)** - REST endpoint structure, error handling, auth
- **[Better Auth + Apso Reference](BETTERAUTH-APSO-REFERENCE.md)** - Authentication configuration and patterns
- **[Tech Stack Complete](TECH-STACK-COMPLETE.md)** - Detailed reference for every tool

### For Troubleshooting
- **[Better Auth Anti-Patterns](BETTERAUTH-APSO-REFERENCE.md#anti-patterns-to-avoid)** - What NOT to do
- **[API Troubleshooting](API-PATTERNS-REFERENCE.md#error-handling)** - Error codes and fixes
- **[Configuration Troubleshooting](BETTERAUTH-APSO-REFERENCE.md#troubleshooting)** - Common issues and solutions

---

## Reference Documents

### 1. BetterAuth + Apso Integration Reference
**File:** `BETTERAUTH-APSO-REFERENCE.md`

**Contains:**
- Entity naming rules and conflicts
- Complete .apsorc configuration examples
- Field definitions for all Better Auth entities
- Entity relationships and patterns
- Complete configuration examples (minimal SaaS, team collaboration)
- Common patterns (protected endpoints, multi-tenancy, OAuth, signup flow)
- Anti-patterns to avoid
- Troubleshooting guide

**Use when:**
- Setting up authentication
- Defining your database schema
- Adding Better Auth to existing project
- Fixing authentication issues
- Designing multi-tenant architecture

---

### 2. API Patterns Reference
**File:** `API-PATTERNS-REFERENCE.md`

**Contains:**
- REST endpoint structure (CRUD patterns)
- URL structure rules
- Bearer token authentication
- Error handling and status codes
- Request/response patterns
- Pagination and filtering
- Common operations (list, create, get, update, delete)
- Best practices (validation, ownership checks, timestamps)
- Complete examples with code

**Use when:**
- Building backend API endpoints
- Implementing authentication guards
- Handling errors
- Designing request/response formats
- Setting up pagination

---

### 3. Tech Stack Complete Reference
**File:** `TECH-STACK-COMPLETE.md`

**Contains:**
- Backend stack (NestJS, TypeORM, PostgreSQL, Better Auth)
- Frontend stack (Next.js, TypeScript, Tailwind, shadcn/ui, React Hook Form, Zod)
- Infrastructure (AWS, Vercel, PostgreSQL)
- Development tools (Git, npm, ESLint, Prettier, TypeScript)
- Testing frameworks (Jest, React Testing Library)
- CI/CD (GitHub Actions)
- Version requirements
- Project structure
- Environment configuration
- Scripts and automation

**Use when:**
- Setting up a new project
- Understanding tool versions
- Looking up how to use a specific tool
- Setting up development environment
- Configuring build/test scripts

---

### 4. Configuration Templates
**File:** `CONFIGURATION-TEMPLATES.md`

**Contains:**
- Backend .apsorc templates (minimal, team collaboration)
- Backend environment variables (.env.local, .env.production)
- Frontend environment variables (.env.local, .env.production)
- Frontend auth configuration
- Docker Compose setup
- NestJS configuration files
- Next.js configuration files
- Quick setup checklist

**Use when:**
- Creating a new project
- Copying configuration files
- Setting up environment variables
- Docker setup
- Deploying to production

---

## Architecture Decision Records (ADRs)

### Why Apso for Backend?
- Eliminates boilerplate backend code
- Auto-generates NestJS + TypeORM code from schema
- Handles AWS deployment automation
- Integrates seamlessly with Better Auth
- Single source of truth for data model

### Why Better Auth?
- Lightweight and modern (not Firebase overhead)
- Integrates with Apso's PostgreSQL
- Supports email/password + OAuth
- TypeScript first
- Excellent developer experience

### Why Next.js + Tailwind + shadcn/ui?
- Modern React with SSR/ISR
- Tailwind for rapid UI development
- shadcn/ui for accessible, pre-built components
- Vercel deployment integration
- Outstanding developer experience

---

## File Structure

```
project-root/
├── docs/
│   └── reference/
│       ├── INDEX.md                       ← You are here
│       ├── BETTERAUTH-APSO-REFERENCE.md  ← Auth configuration
│       ├── API-PATTERNS-REFERENCE.md     ← API design
│       ├── TECH-STACK-COMPLETE.md        ← Tools and technologies
│       └── CONFIGURATION-TEMPLATES.md    ← Copy-paste configs
│
├── backend/                               ← NestJS backend
│   ├── .apsorc                           ← Schema definition
│   ├── .env.local                        ← Environment variables
│   ├── src/
│   │   ├── autogen/                      ← Apso-generated code
│   │   ├── guards/                       ← Auth guards
│   │   └── ...
│   └── package.json
│
└── frontend/                             ← Next.js frontend
    ├── .env.local                        ← Environment variables
    ├── app/
    │   ├── api/auth/[...all]/route.ts   ← Auth handler
    │   └── ...
    ├── lib/
    │   ├── auth.ts                       ← Better Auth setup
    │   ├── auth-client.ts               ← Client auth
    │   └── api-client.ts                ← API wrapper
    └── package.json
```

---

## Common Tasks and Where to Find Them

| Task | Reference Document | Section |
|------|-------------------|---------|
| Set up a new SaaS project | CONFIGURATION-TEMPLATES.md | Quick Setup Checklist |
| Define database schema | BETTERAUTH-APSO-REFERENCE.md | Apso .apsorc Configuration |
| Configure Better Auth | BETTERAUTH-APSO-REFERENCE.md | Complete Configuration Examples |
| Build API endpoints | API-PATTERNS-REFERENCE.md | REST Endpoint Structure |
| Protect endpoints with auth | API-PATTERNS-REFERENCE.md | Authentication Middleware |
| Handle API errors | API-PATTERNS-REFERENCE.md | Error Handling |
| Set up pagination | API-PATTERNS-REFERENCE.md | Standard Response Format |
| Design multi-tenant system | BETTERAUTH-APSO-REFERENCE.md | Entity Relationships |
| Configure OAuth | BETTERAUTH-APSO-REFERENCE.md | Common Patterns (Pattern 4) |
| Understand tech stack | TECH-STACK-COMPLETE.md | Stack Overview |
| Set environment variables | CONFIGURATION-TEMPLATES.md | Environment Templates |
| Deploy to production | TECH-STACK-COMPLETE.md | Infrastructure & Deployment |
| Fix authentication issue | BETTERAUTH-APSO-REFERENCE.md | Troubleshooting |
| Fix API error | API-PATTERNS-REFERENCE.md | Error Handling |

---

## Reading Paths

### Path 1: Complete New Project (4-5 hours)
1. Read: [Tech Stack Overview](TECH-STACK-COMPLETE.md#stack-overview)
2. Copy: [Configuration Templates](CONFIGURATION-TEMPLATES.md) - all files
3. Read: [Quick Setup Checklist](CONFIGURATION-TEMPLATES.md#quick-setup-checklist)
4. Follow: Setup steps in checklist
5. Read: [Better Auth Configuration](BETTERAUTH-APSO-REFERENCE.md#complete-configuration-examples)
6. Read: [API Patterns](API-PATTERNS-REFERENCE.md#common-api-operations)
7. Start building!

### Path 2: Add Better Auth to Existing Project (2 hours)
1. Read: [Entity Naming](BETTERAUTH-APSO-REFERENCE.md#entity-naming-and-conflicts)
2. Review: [Minimal Configuration](BETTERAUTH-APSO-REFERENCE.md#complete-configuration-examples)
3. Read: [Common Patterns](BETTERAUTH-APSO-REFERENCE.md#common-patterns)
4. Implement: Follow patterns in your project

### Path 3: Build New API Feature (1 hour)
1. Read: [REST Endpoint Structure](API-PATTERNS-REFERENCE.md#rest-endpoint-structure)
2. Read: [Authentication Middleware](API-PATTERNS-REFERENCE.md#authentication-middleware)
3. Read: [Common Operations](API-PATTERNS-REFERENCE.md#common-api-operations)
4. Review: [Best Practices](API-PATTERNS-REFERENCE.md#best-practices)
5. Implement: Start coding

### Path 4: Troubleshoot Issue (30 mins)
1. Check: [Anti-Patterns](BETTERAUTH-APSO-REFERENCE.md#anti-patterns-to-avoid) (auth issues)
2. Check: [Error Handling](API-PATTERNS-REFERENCE.md#error-handling) (API errors)
3. Check: [Troubleshooting](BETTERAUTH-APSO-REFERENCE.md#troubleshooting) (auth setup issues)

---

## Key Concepts

### Multi-Tenancy
- **Pattern:** Each user has one Organization (can be extended to many)
- **Implementation:** All queries filtered by org_id or user's organization
- **Reference:** [Entity Relationships](BETTERAUTH-APSO-REFERENCE.md#entity-relationships)

### Authentication Flow
- **Pattern:** Better Auth handles signup/signin → Session created → Token in Authorization header → Guard validates → Access granted
- **Reference:** [Authentication Middleware](API-PATTERNS-REFERENCE.md#authentication-middleware)

### Error Handling
- **Pattern:** Consistent JSON error response format with status code + message + details
- **Reference:** [Error Handling](API-PATTERNS-REFERENCE.md#error-handling)

### Entity Design
- **Pattern:** User (Better Auth) + Account (OAuth) + Organization (Business) + relationships
- **Reference:** [Complete Configuration Examples](BETTERAUTH-APSO-REFERENCE.md#complete-configuration-examples)

---

## Validation Checklist

Before deploying any SaaS to production, verify:

### Database Schema
- [ ] All entities named correctly (no conflicts with Better Auth)
- [ ] User entity includes required fields (email, name)
- [ ] Optional fields marked as nullable (avatar_url)
- [ ] Relationships properly defined
- [ ] No circular dependencies

### Authentication
- [ ] Better Auth configured correctly
- [ ] Auth guard protects sensitive endpoints
- [ ] Session expiration set appropriately
- [ ] OAuth providers configured (if using)
- [ ] Password validation enforced

### API Design
- [ ] All endpoints follow REST conventions
- [ ] Request/response formats consistent
- [ ] Pagination implemented for list endpoints
- [ ] Errors return proper status codes
- [ ] Timestamps in ISO 8601 format

### Data Security
- [ ] Multi-tenant data isolation enforced
- [ ] User ownership verified in every query
- [ ] Secrets not committed to version control
- [ ] Environment variables properly configured
- [ ] HTTPS enforced in production

### Testing
- [ ] Auth flow tested (signup, login, logout)
- [ ] Protected endpoints tested
- [ ] Error cases tested
- [ ] Multi-tenant isolation tested

---

## Glossary

| Term | Definition |
|------|-----------|
| **Apso** | Schema-driven backend generator. Define your data model → Apso generates NestJS + TypeORM backend |
| **Better Auth** | Authentication library. Manages users, sessions, OAuth, email verification |
| **Multi-Tenancy** | One application serves multiple customers. Each customer's data isolated. |
| **DTO** | Data Transfer Object. Validates and shapes request/response data |
| **Entity** | Database table. Defined in .apsorc, generated as TypeORM entity |
| **Guard** | NestJS middleware that checks authorization before route handler executes |
| **Middleware** | Function that runs before request reaches handler. Used for auth, logging, etc. |
| **Repository** | Class providing database query methods. Auto-generated by TypeORM |
| **Service** | NestJS service containing business logic. Uses repository for data access |
| **Controller** | NestJS class handling HTTP requests. Calls service for business logic |

---

## Quick Reference Cards

### Bearer Token Pattern
```
GET /api/resource
Authorization: Bearer <session_token>
```

### Entity Naming Rules
```
✅ User (PascalCase - Better Auth required)
✅ account (lowercase - Better Auth required)
✅ Organization (PascalCase - your entity)
❌ Account (conflicts with Better Auth)
❌ Session (conflicts with Better Auth)
```

### Required .apsorc Entities
```json
{
  "entities": [
    { "name": "User" },
    { "name": "account" },
    { "name": "session" },
    { "name": "Verification" }
  ]
}
```

### API Response Format
```json
{
  "data": {...},
  "pagination": { "page": 1, "total": 42 },
  "error": null
}
```

### Error Response Format
```json
{
  "statusCode": 400,
  "message": "Description",
  "error": "BadRequestException",
  "timestamp": "2025-01-18T10:30:00Z"
}
```

---

## Updates and Maintenance

**Last Updated:** 2025-01-18
**Version:** 1.0
**Status:** Complete Reference - Production Ready

### Version History
- v1.0 (2025-01-18) - Initial complete reference set

### How to Keep Updated
1. Check this index regularly for latest versions
2. Review reference documents for deprecation notices
3. Follow links for detailed changes
4. Test configurations before using in production

---

## Getting Help

### Quick Questions
- Check the Glossary section
- Use Ctrl+F to search for keywords
- Check the "Common Tasks" table

### Configuration Issues
- See [Configuration Templates](CONFIGURATION-TEMPLATES.md)
- Check [Troubleshooting](BETTERAUTH-APSO-REFERENCE.md#troubleshooting)

### API Implementation
- See [API Patterns Reference](API-PATTERNS-REFERENCE.md)
- Review [Common API Operations](API-PATTERNS-REFERENCE.md#common-api-operations)

### Authentication Issues
- See [Better Auth Reference](BETTERAUTH-APSO-REFERENCE.md)
- Check [Anti-Patterns](BETTERAUTH-APSO-REFERENCE.md#anti-patterns-to-avoid)

---

## Summary

These four reference documents provide everything needed to:
1. Build a new SaaS product from scratch
2. Integrate Better Auth with Apso
3. Design and implement REST APIs
4. Configure and deploy to production

They follow the **Mavric Standard Stack**: Apso (backend) + Better Auth (auth) + Next.js (frontend) + NestJS (framework) + PostgreSQL (database).

All configurations are tested, production-ready, and follow industry best practices.

---

**Happy building!** 🚀

For questions, refer to the specific reference document or the Troubleshooting sections.
