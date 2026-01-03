# Feature Builder

Implements complete features full-stack (backend + frontend + tests).

---

## Overview

| Attribute | Value |
|-----------|-------|
| **Name** | feature-builder |
| **Type** | Implementation skill |
| **Triggers** | "implement feature", "build functionality", "add feature" |
| **Output** | Working feature code |
| **Location** | `.claude/skills/feature-builder/` |

---

## What It Does

The Feature Builder implements features end-to-end:

1. **Reads Gherkin scenarios** - Understands acceptance criteria
2. **Creates backend endpoints** - API routes, validation, logic
3. **Builds frontend UI** - Components, forms, state
4. **Writes tests** - Unit, integration tests
5. **Verifies against scenarios** - Ensures criteria are met

---

## Implementation Process

### Step 1: Understand Requirements

Reads from:
- Gherkin scenarios (`features/*.feature`)
- Discovery document
- Existing code structure

### Step 2: Backend Implementation

Creates/modifies:
- Controller endpoints
- Service business logic
- DTOs for validation
- Database queries

```typescript
// src/extensions/Project/Project.controller.ts
@Controller('projects')
export class ProjectController {
  @Post(':id/archive')
  async archive(@Param('id') id: string) {
    return this.projectService.archive(id);
  }
}

// src/extensions/Project/Project.service.ts
@Injectable()
export class ProjectService {
  async archive(id: string) {
    const project = await this.findOne(id);
    await this.taskService.archiveByProject(id);
    return this.update(id, { status: 'archived' });
  }
}
```

### Step 3: Frontend Implementation

Creates/modifies:
- Page components
- Form handling
- API integration
- State management

```typescript
// app/projects/[id]/page.tsx
export default async function ProjectPage({ params }) {
  const project = await getProject(params.id);

  return (
    <div>
      <ProjectHeader project={project} />
      <TaskList projectId={params.id} />
      <ArchiveButton projectId={params.id} />
    </div>
  );
}
```

### Step 4: Test Implementation

Creates:
- Step definitions
- Unit tests
- Integration tests

```typescript
// tests/unit/project.service.spec.ts
describe('ProjectService', () => {
  describe('archive', () => {
    it('should archive project and all tasks', async () => {
      const result = await service.archive('project-1');
      expect(result.status).toBe('archived');
      expect(taskService.archiveByProject).toHaveBeenCalled();
    });
  });
});
```

### Step 5: Verification

Runs scenarios to verify:
```bash
npm test -- --tags "@projects"
```

---

## Feature Types

### CRUD Feature

For basic entity management:
- List view with pagination
- Detail view
- Create form
- Edit form
- Delete confirmation

### Workflow Feature

For multi-step processes:
- State machine logic
- Step-by-step UI
- Progress tracking
- Validation at each step

### Integration Feature

For external systems:
- API client setup
- Webhook handlers
- Error handling
- Retry logic

---

## File Locations

| Type | Backend Location | Frontend Location |
|------|------------------|-------------------|
| Controller | `src/extensions/Entity/` | - |
| Service | `src/extensions/Entity/` | - |
| Page | - | `app/entity/page.tsx` |
| Component | - | `components/entity/` |
| Test | `test/` | `__tests__/` |

---

## Code Patterns

### Backend Service Pattern

```typescript
@Injectable()
export class FeatureService {
  constructor(
    private entityRepo: EntityRepository,
    private relatedService: RelatedService,
  ) {}

  async create(dto: CreateDto): Promise<Entity> {
    // Validate business rules
    await this.validateRules(dto);

    // Create entity
    const entity = await this.entityRepo.create(dto);

    // Side effects
    await this.relatedService.onEntityCreated(entity);

    return entity;
  }
}
```

### Frontend Form Pattern

```typescript
'use client';

import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';

export function CreateForm() {
  const form = useForm({
    resolver: zodResolver(schema),
    defaultValues: { name: '', status: 'active' },
  });

  const onSubmit = async (data) => {
    await createEntity(data);
    router.push('/entities');
  };

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)}>
        {/* Form fields */}
      </form>
    </Form>
  );
}
```

---

## Validation Against Scenarios

The feature builder ensures code matches Gherkin:

```gherkin
Scenario: Create project with valid data
  Given I am authenticated
  When I create a project with name "My Project"
  Then the project is created
  And I see "Project created successfully"
```

↓ Becomes ↓

```typescript
// Backend validates and creates
async create(dto) {
  if (!dto.name) throw new ValidationError('Name required');
  return this.repo.create(dto);
}

// Frontend shows success
const onSubmit = async (data) => {
  await api.createProject(data);
  toast.success('Project created successfully');
};
```

---

## Invocation

### Via Orchestrator

Called during Phase 8+ of `/start-project` for each feature.

### Via Natural Language

```
"Implement the project archive feature"
"Build the user settings page"
"Add comments functionality to tasks"
```

---

## Tips

### Do

- Read scenarios before implementing
- Follow existing patterns
- Put code in `extensions/` (not `autogen/`)
- Write tests alongside code
- Verify with Gherkin after

### Don't

- Modify `autogen/` files
- Skip validation
- Ignore error cases
- Forget multi-tenancy (`organization_id`)

---

## Related

- [Test Generator](test-generator.md) (creates scenarios)
- [Backend Bootstrapper](backend-bootstrapper.md) (base structure)
- [Schema Architect](schema-architect.md) (data model)
