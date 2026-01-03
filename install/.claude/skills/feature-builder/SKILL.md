---
name: feature-builder
description: Builds complete features full-stack (backend + frontend + tests). Triggers when user wants to implement a feature, add functionality, or build a specific capability.
---

# Feature Builder

I implement complete features from specification to working code, covering backend APIs, frontend UI, and tests.

## What I Build

For each feature, I deliver:

### 1. Backend Implementation
- REST API endpoints (or extend existing)
- Service layer with business logic
- Data access layer
- Input validation
- Error handling
- OpenAPI documentation

### 2. Frontend Implementation
- UI components with shadcn/ui
- Forms with react-hook-form + zod
- API integration with React Query
- State management
- Error handling & loading states
- Responsive design

### 3. Testing
- Backend unit tests
- Backend integration tests
- Frontend component tests
- E2E tests (if critical flow)

### 4. Documentation
- Feature specification
- API documentation
- Component documentation
- Usage examples

## The Build Process

### Step 1: Feature Specification

I start by creating a detailed spec:

**Feature:** [Name]
**User Story:**
```
As a [user type]
I want to [action]
So that [benefit]
```

**Acceptance Criteria:**
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

**API Endpoints Needed:**
- `POST /api/resource` - Create
- `GET /api/resource/:id` - Fetch
- `PUT /api/resource/:id` - Update

**UI Components:**
- ResourceList
- ResourceForm
- ResourceCard
- ResourceDetail

**Data Flow:**
```
User Input → Form Validation → API Request → Backend Validation → Database → API Response → UI Update
```

### Step 2: Backend Implementation

#### A. Define DTOs (Data Transfer Objects)

```typescript
// server/src/extensions/Resource/dto/create-resource.dto.ts
import { IsString, IsEnum, IsOptional, MinLength } from 'class-validator';

export class CreateResourceDto {
  @IsString()
  @MinLength(3)
  name: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsEnum(['active', 'draft'])
  status: 'active' | 'draft';
}
```

#### B. Add Business Logic to Service

```typescript
// server/src/extensions/Resource/Resource.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Resource } from 'src/autogen/entities/Resource';

@Injectable()
export class ResourceService {
  constructor(
    @InjectRepository(Resource)
    private resourceRepo: Repository<Resource>,
  ) {}

  async create(dto: CreateResourceDto, orgId: string, userId: string) {
    // Business logic
    const resource = this.resourceRepo.create({
      ...dto,
      organization_id: orgId,
      created_by: userId,
    });

    // Save to database
    const saved = await this.resourceRepo.save(resource);

    // Trigger side effects (emails, notifications, etc.)
    await this.notificationService.notifyResourceCreated(saved);

    return saved;
  }

  async findWithStats(id: string, orgId: string) {
    const resource = await this.resourceRepo.findOne({
      where: { id, organization_id: orgId },
      relations: ['created_by', 'items'],
    });

    if (!resource) {
      throw new NotFoundException('Resource not found');
    }

    // Add computed stats
    return {
      ...resource,
      stats: {
        total_items: resource.items.length,
        active_items: resource.items.filter(i => i.status === 'active').length,
      },
    };
  }

  async archive(id: string, orgId: string) {
    const resource = await this.findOne(id, orgId);

    // Business logic for archiving
    resource.status = 'archived';
    resource.archived_at = new Date();

    // Archive related items
    await this.itemService.archiveByResource(id);

    return this.resourceRepo.save(resource);
  }
}
```

#### C. Add Custom Controller Endpoints

```typescript
// server/src/extensions/Resource/Resource.controller.ts
import { Controller, Post, Get, Put, Param, Body, UseGuards, Req } from '@nestjs/common';
import { AuthGuard } from 'src/common/guards/auth.guard';
import { OrgGuard } from 'src/common/guards/org.guard';

@Controller('resources')
@UseGuards(AuthGuard, OrgGuard)
export class ResourceController {
  constructor(private resourceService: ResourceService) {}

  // Extend generated CRUD with custom endpoint
  @Get(':id/stats')
  async getWithStats(@Param('id') id: string, @Req() req) {
    return this.resourceService.findWithStats(id, req.organizationId);
  }

  @Post(':id/archive')
  async archive(@Param('id') id: string, @Req() req) {
    return this.resourceService.archive(id, req.organizationId);
  }

  @Post(':id/duplicate')
  async duplicate(@Param('id') id: string, @Req() req) {
    const original = await this.resourceService.findOne(id, req.organizationId);
    return this.resourceService.create(
      { ...original, name: `${original.name} (Copy)` },
      req.organizationId,
      req.userId,
    );
  }
}
```

### Step 3: Frontend Implementation

#### A. Type Definitions

```typescript
// client/src/types/resource.ts
export interface Resource {
  id: string;
  organization_id: string;
  name: string;
  description: string | null;
  status: 'active' | 'draft' | 'archived';
  created_by: string;
  created_at: string;
  updated_at: string;
}

export interface ResourceWithStats extends Resource {
  stats: {
    total_items: number;
    active_items: number;
  };
}

export interface CreateResourceInput {
  name: string;
  description?: string;
  status: 'active' | 'draft';
}
```

#### B. API Client Methods

```typescript
// client/src/lib/api/resources.ts
import { apiClient } from '../api-client';
import { Resource, ResourceWithStats, CreateResourceInput } from '@/types/resource';

export const resourcesApi = {
  list: async (): Promise<Resource[]> => {
    const res = await apiClient.get('/resources');
    return res.data.data;
  },

  get: async (id: string): Promise<Resource> => {
    const res = await apiClient.get(`/resources/${id}`);
    return res.data;
  },

  getWithStats: async (id: string): Promise<ResourceWithStats> => {
    const res = await apiClient.get(`/resources/${id}/stats`);
    return res.data;
  },

  create: async (data: CreateResourceInput): Promise<Resource> => {
    const res = await apiClient.post('/resources', data);
    return res.data;
  },

  update: async (id: string, data: Partial<CreateResourceInput>): Promise<Resource> => {
    const res = await apiClient.put(`/resources/${id}`, data);
    return res.data;
  },

  archive: async (id: string): Promise<Resource> => {
    const res = await apiClient.post(`/resources/${id}/archive`);
    return res.data;
  },

  delete: async (id: string): Promise<void> => {
    await apiClient.delete(`/resources/${id}`);
  },
};
```

#### C. React Query Hooks

```typescript
// client/src/hooks/use-resources.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { resourcesApi } from '@/lib/api/resources';
import { CreateResourceInput } from '@/types/resource';
import { useToast } from '@/components/ui/use-toast';

export function useResources() {
  return useQuery({
    queryKey: ['resources'],
    queryFn: resourcesApi.list,
  });
}

export function useResource(id: string) {
  return useQuery({
    queryKey: ['resources', id],
    queryFn: () => resourcesApi.getWithStats(id),
    enabled: !!id,
  });
}

export function useCreateResource() {
  const queryClient = useQueryClient();
  const { toast } = useToast();

  return useMutation({
    mutationFn: resourcesApi.create,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['resources'] });
      toast({
        title: 'Success',
        description: 'Resource created successfully',
      });
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to create resource',
        variant: 'destructive',
      });
    },
  });
}

export function useUpdateResource() {
  const queryClient = useQueryClient();
  const { toast } = useToast();

  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<CreateResourceInput> }) =>
      resourcesApi.update(id, data),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['resources'] });
      queryClient.invalidateQueries({ queryKey: ['resources', variables.id] });
      toast({
        title: 'Success',
        description: 'Resource updated successfully',
      });
    },
    onError: (error: any) => {
      toast({
        title: 'Error',
        description: error.response?.data?.message || 'Failed to update resource',
        variant: 'destructive',
      });
    },
  });
}

export function useArchiveResource() {
  const queryClient = useQueryClient();
  const { toast } = useToast();

  return useMutation({
    mutationFn: resourcesApi.archive,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['resources'] });
      toast({
        title: 'Success',
        description: 'Resource archived successfully',
      });
    },
  });
}
```

#### D. UI Components

**Resource Form Component:**
```typescript
// client/src/components/features/resources/resource-form.tsx
'use client';

import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { Button } from '@/components/ui/button';
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { CreateResourceInput, Resource } from '@/types/resource';

const resourceSchema = z.object({
  name: z.string().min(3, 'Name must be at least 3 characters'),
  description: z.string().optional(),
  status: z.enum(['active', 'draft']),
});

interface ResourceFormProps {
  resource?: Resource;
  onSubmit: (data: CreateResourceInput) => void;
  isLoading?: boolean;
}

export function ResourceForm({ resource, onSubmit, isLoading }: ResourceFormProps) {
  const form = useForm<CreateResourceInput>({
    resolver: zodResolver(resourceSchema),
    defaultValues: {
      name: resource?.name || '',
      description: resource?.description || '',
      status: resource?.status || 'draft',
    },
  });

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <FormField
          control={form.control}
          name="name"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Name</FormLabel>
              <FormControl>
                <Input placeholder="Resource name" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <FormField
          control={form.control}
          name="description"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Description</FormLabel>
              <FormControl>
                <Textarea placeholder="Resource description" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

        <FormField
          control={form.control}
          name="status"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Status</FormLabel>
              <Select onValueChange={field.onChange} defaultValue={field.value}>
                <FormControl>
                  <SelectTrigger>
                    <SelectValue placeholder="Select status" />
                  </SelectTrigger>
                </FormControl>
                <SelectContent>
                  <SelectItem value="draft">Draft</SelectItem>
                  <SelectItem value="active">Active</SelectItem>
                </SelectContent>
              </Select>
              <FormMessage />
            </FormItem>
          )}
        />

        <div className="flex justify-end gap-2">
          <Button type="submit" disabled={isLoading}>
            {isLoading ? 'Saving...' : resource ? 'Update' : 'Create'}
          </Button>
        </div>
      </form>
    </Form>
  );
}
```

**Resource List Page:**
```typescript
// client/src/app/resources/page.tsx
'use client';

import { useState } from 'react';
import { useResources, useArchiveResource } from '@/hooks/use-resources';
import { Button } from '@/components/ui/button';
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import Link from 'next/link';
import { Plus, Archive } from 'lucide-react';

export default function ResourcesPage() {
  const { data: resources, isLoading } = useResources();
  const archiveMutation = useArchiveResource();

  if (isLoading) {
    return <div>Loading...</div>;
  }

  return (
    <div className="container mx-auto py-8">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">Resources</h1>
        <Button asChild>
          <Link href="/resources/new">
            <Plus className="mr-2 h-4 w-4" />
            New Resource
          </Link>
        </Button>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        {resources?.map((resource) => (
          <Card key={resource.id}>
            <CardHeader>
              <div className="flex justify-between items-start">
                <CardTitle>{resource.name}</CardTitle>
                <Badge variant={resource.status === 'active' ? 'default' : 'secondary'}>
                  {resource.status}
                </Badge>
              </div>
              <CardDescription>{resource.description}</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="flex gap-2">
                <Button variant="outline" size="sm" asChild>
                  <Link href={`/resources/${resource.id}`}>View</Link>
                </Button>
                <Button variant="outline" size="sm" asChild>
                  <Link href={`/resources/${resource.id}/edit`}>Edit</Link>
                </Button>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => archiveMutation.mutate(resource.id)}
                >
                  <Archive className="h-4 w-4" />
                </Button>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  );
}
```

### Step 4: Testing

I write comprehensive tests:

```typescript
// server/test/resource.e2e-spec.ts
describe('Resource API (e2e)', () => {
  it('should create a resource', async () => {
    const res = await request(app)
      .post('/resources')
      .send({ name: 'Test Resource', status: 'draft' })
      .expect(201);

    expect(res.body.name).toBe('Test Resource');
    expect(res.body.id).toBeDefined();
  });

  it('should get resource with stats', async () => {
    const res = await request(app)
      .get(`/resources/${resourceId}/stats`)
      .expect(200);

    expect(res.body.stats).toBeDefined();
    expect(res.body.stats.total_items).toBeGreaterThanOrEqual(0);
  });
});
```

```typescript
// client/src/components/features/resources/__tests__/resource-form.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { ResourceForm } from '../resource-form';

describe('ResourceForm', () => {
  it('renders form fields', () => {
    render(<ResourceForm onSubmit={jest.fn()} />);

    expect(screen.getByLabelText('Name')).toBeInTheDocument();
    expect(screen.getByLabelText('Description')).toBeInTheDocument();
    expect(screen.getByLabelText('Status')).toBeInTheDocument();
  });

  it('validates required fields', async () => {
    const onSubmit = jest.fn();
    render(<ResourceForm onSubmit={onSubmit} />);

    fireEvent.click(screen.getByText('Create'));

    expect(await screen.findByText('Name must be at least 3 characters')).toBeInTheDocument();
    expect(onSubmit).not.toHaveBeenCalled();
  });

  it('submits valid data', async () => {
    const onSubmit = jest.fn();
    render(<ResourceForm onSubmit={onSubmit} />);

    fireEvent.change(screen.getByLabelText('Name'), { target: { value: 'Test' } });
    fireEvent.click(screen.getByText('Create'));

    expect(onSubmit).toHaveBeenCalledWith({
      name: 'Test',
      status: 'draft',
    });
  });
});
```

## Feature Patterns I Use

### Pattern 1: List-Detail-Edit
Standard CRUD pattern with three views

### Pattern 2: Wizard/Multi-Step
Break complex features into steps

### Pattern 3: Modal Forms
Quick actions without page navigation

### Pattern 4: Inline Editing
Edit directly in lists/tables

### Pattern 5: Bulk Actions
Select multiple items and perform actions

## Quality Checklist

Before marking a feature complete:

- ✅ Backend endpoints work and return proper responses
- ✅ Input validation prevents invalid data
- ✅ Error handling provides helpful messages
- ✅ Multi-tenancy enforced (org-scoped queries)
- ✅ Frontend UI matches design system
- ✅ Forms have validation with helpful error messages
- ✅ Loading states while fetching data
- ✅ Success/error toasts for user feedback
- ✅ Responsive design works on mobile
- ✅ Tests cover happy path and error cases
- ✅ OpenAPI documentation updated
- ✅ Code follows SOLID principles

## Ready?

Tell me what feature you want to build, and I'll implement it full-stack with tests and documentation.

**What feature should we build?**
