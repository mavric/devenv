# Standards Overview

Development standards enforced by Mavric DevEnv.

---

## What Are Standards?

Standards are rules and guidelines that ensure code quality, consistency, and security. They are automatically enforced by Claude Code through `.mdc` rule files.

---

## Available Standards

| Standard | Purpose | File |
|----------|---------|------|
| [Contribution](contribution-standards.md) | SOLID, TypeScript, API design | `contribution-standards.mdc` |
| [Code Structure](code-structure.md) | File organization | `code-structure.mdc` |
| [Security](security-standards.md) | Security best practices | `security-standards.mdc` |
| [Testing](testing-standards.md) | Testing requirements | `testing-standards.mdc` |

---

## How Standards Are Enforced

Standards are defined as `.mdc` (Markdown with Config) files in:
```
.devENV/standards/rules/
```

Claude Code automatically loads and applies these rules to all code it generates or reviews.

### Rule Structure

```markdown
---
description: What this rule enforces
globs:
  - "**/*.ts"
  - "**/*.tsx"
alwaysApply: true
priority: normal
---

# Rule: Rule Name

[Rule content and examples...]
```

### Key Fields

| Field | Purpose |
|-------|---------|
| `description` | Brief summary |
| `globs` | File patterns to apply to |
| `alwaysApply` | Whether to always enforce |
| `priority` | `normal` or `critical` |

---

## Core Principles

All standards share these principles:

### 1. SOLID Principles

- **S**ingle Responsibility
- **O**pen/Closed
- **L**iskov Substitution
- **I**nterface Segregation
- **D**ependency Inversion

### 2. Type Safety

Strict TypeScript with:
- `strictNullChecks: true`
- `noImplicitAny: true`
- Explicit return types

### 3. Multi-Tenancy

Every query scoped by `organization_id`:
```typescript
// ✅ Always filter by organization
const items = await db.item.findMany({
  where: { organizationId: req.organizationId }
});
```

### 4. Security First

- Input validation on all endpoints
- No secrets in code
- Proper authentication/authorization
- SQL injection prevention

---

## Quick Reference

### Code Quality

```typescript
// ✅ Good: Single responsibility
class UserService { /* only user logic */ }
class EmailService { /* only email logic */ }

// ❌ Bad: Multiple responsibilities
class UserManager {
  createUser() { }
  sendEmail() { }
  logActivity() { }
  generateReport() { }
}
```

### Type Safety

```typescript
// ✅ Good: Explicit types
async function getUser(id: string): Promise<User | null> {
  return db.user.findUnique({ where: { id } });
}

// ❌ Bad: Implicit any
async function getUser(id) {
  return db.user.findUnique({ where: { id } });
}
```

### Error Handling

```typescript
// ✅ Good: Custom error classes
throw new NotFoundError('User', id);
throw new ValidationError('Invalid input', { email: 'Invalid format' });

// ❌ Bad: Generic errors
throw new Error('Something went wrong');
```

---

## Customizing Standards

You can modify standards for your project:

1. Edit files in `.devENV/standards/rules/`
2. Add new `.mdc` files for custom rules
3. Adjust `globs` to change scope
4. Set `alwaysApply: false` to make optional

!!! warning "Be Careful"
    Disabling security standards may introduce vulnerabilities.
