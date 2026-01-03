# Code Structure

File and directory organization standards.

---

## Backend Structure

```
backend/
├── src/
│   ├── autogen/              # ⚠️ NEVER MODIFY
│   │   ├── Entity/
│   │   │   ├── Entity.entity.ts
│   │   │   ├── Entity.service.ts
│   │   │   ├── Entity.controller.ts
│   │   │   ├── Entity.module.ts
│   │   │   └── dtos/
│   │   │       ├── Entity.dto.ts
│   │   │       └── index.ts
│   │   └── guards/
│   │       ├── auth.guard.ts
│   │       └── scope.guard.ts
│   │
│   ├── extensions/           # ✅ YOUR CODE
│   │   ├── Entity/
│   │   │   ├── Entity.controller.ts
│   │   │   └── Entity.service.ts
│   │   └── auth/
│   │       └── auth.service.ts
│   │
│   ├── common/
│   │   ├── decorators/
│   │   ├── filters/
│   │   ├── guards/
│   │   ├── interceptors/
│   │   └── pipes/
│   │
│   ├── app.module.ts
│   └── main.ts
│
├── test/
│   ├── unit/
│   └── e2e/
│
├── .apsorc
├── .env
└── package.json
```

### Key Rules

1. **Never modify `autogen/`** - Regenerated on scaffold
2. **Custom code in `extensions/`** - Extends/overrides autogen
3. **Shared utilities in `common/`** - Cross-cutting concerns
4. **Tests mirror `src/`** - Same structure

---

## Frontend Structure

```
frontend/
├── app/                      # Next.js App Router
│   ├── (auth)/               # Auth route group
│   │   ├── login/
│   │   │   └── page.tsx
│   │   └── register/
│   │       └── page.tsx
│   ├── (dashboard)/          # Dashboard route group
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   └── projects/
│   │       ├── page.tsx
│   │       └── [id]/
│   │           └── page.tsx
│   ├── api/                  # API routes
│   │   └── auth/
│   ├── layout.tsx
│   └── page.tsx
│
├── components/
│   ├── ui/                   # shadcn/ui components
│   │   ├── button.tsx
│   │   ├── card.tsx
│   │   └── input.tsx
│   ├── forms/                # Form components
│   │   └── project-form.tsx
│   ├── layouts/              # Layout components
│   │   ├── header.tsx
│   │   └── sidebar.tsx
│   └── features/             # Feature-specific
│       └── projects/
│           ├── project-card.tsx
│           └── project-list.tsx
│
├── lib/
│   ├── api.ts                # API client
│   ├── auth.ts               # Auth config
│   └── utils.ts              # Utilities
│
├── hooks/
│   ├── use-auth.ts
│   └── use-projects.ts
│
├── types/
│   └── index.ts
│
└── styles/
    └── globals.css
```

### Key Rules

1. **Route groups** - Use `(group)` for organization
2. **Colocate related files** - Components near their routes
3. **Shared components in `components/`** - Reusable UI
4. **Business logic in `lib/`** - API, auth, utils

---

## Test Structure

```
features/
├── api/                      # API tests
│   ├── auth/
│   │   ├── login.feature
│   │   └── register.feature
│   └── projects/
│       └── crud.feature
│
├── ui/                       # UI tests
│   ├── forms/
│   │   └── project-form.feature
│   └── components/
│       └── project-list.feature
│
├── e2e/                      # E2E tests
│   ├── auth-flow.feature
│   └── project-flow.feature
│
├── step-definitions/         # Step implementations
│   ├── api/
│   ├── ui/
│   └── common/
│
└── docs/                     # Project docs
    ├── discovery/
    ├── schema/
    └── product-requirements.md
```

---

## Naming Conventions

### Files

| Type | Convention | Example |
|------|------------|---------|
| Components | PascalCase | `ProjectCard.tsx` |
| Hooks | camelCase with `use` | `useProjects.ts` |
| Utilities | camelCase | `formatDate.ts` |
| Types | PascalCase | `Project.ts` |
| Tests | kebab-case | `project-crud.feature` |
| Configs | kebab-case | `next.config.js` |

### Directories

| Type | Convention | Example |
|------|------------|---------|
| Route segments | kebab-case | `user-settings/` |
| Feature modules | kebab-case | `project-management/` |
| Component groups | kebab-case | `ui/`, `forms/` |

### Code

| Type | Convention | Example |
|------|------------|---------|
| Classes | PascalCase | `UserService` |
| Functions | camelCase | `getUserById` |
| Constants | SCREAMING_SNAKE | `MAX_RETRY_COUNT` |
| Interfaces | PascalCase | `User`, `CreateUserDto` |
| Enums | PascalCase | `UserRole` |
| Type aliases | PascalCase | `UserId` |

---

## Import Organization

```typescript
// 1. External packages
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';

// 2. Internal modules (absolute)
import { UserService } from '@/services/user.service';
import { User } from '@/entities/user.entity';

// 3. Relative imports
import { CreateUserDto } from './dtos/create-user.dto';
import { UserMapper } from './user.mapper';

// 4. Types (if separate)
import type { UserWithPosts } from './types';
```

---

## Module Organization

### NestJS Module

```typescript
// project.module.ts
@Module({
  imports: [
    TypeOrmModule.forFeature([Project]),
    UserModule,
  ],
  controllers: [ProjectController],
  providers: [ProjectService],
  exports: [ProjectService],
})
export class ProjectModule {}
```

### Barrel Exports

```typescript
// components/ui/index.ts
export { Button } from './button';
export { Card, CardHeader, CardContent } from './card';
export { Input } from './input';

// Usage
import { Button, Card, Input } from '@/components/ui';
```

---

## Configuration Files

```
project/
├── .env                      # Local environment
├── .env.example              # Template (commit this)
├── .gitignore
├── package.json
├── tsconfig.json
├── next.config.js            # (frontend)
├── nest-cli.json             # (backend)
├── .apsorc                   # (backend) Schema
└── docker-compose.yml        # (backend) Local DB
```

### Environment Files

```bash
# .env.example (commit this)
NODE_ENV=development
PORT=3001
DATABASE_URL=postgresql://user:pass@localhost:5432/db
AUTH_SECRET=your-secret-here

# .env (never commit)
NODE_ENV=development
PORT=3001
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/mydb
AUTH_SECRET=actual-secret-value
```
