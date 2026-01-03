# Skills Integration Guide

> How to use the SaaS skills system for complete project development

## Quick Start

### Option 1: Full Project (Orchestrated)

Start with the meta-orchestrator for a complete guided experience:

```
"I want to build a SaaS application for project management"
```

The `saas-project-orchestrator` will:
1. Ask discovery questions
2. Call `product-brief-writer` → Create PRD
3. Call `schema-architect` → Design database
4. Call `backend-bootstrapper` → Set up API
5. Call `frontend-bootstrapper` → Create UI
6. Call `feature-builder` → Implement features
7. Call `deployment-orchestrator` → Deploy to production

**Timeline:** 12 weeks to production-ready MVP

### Option 2: Specific Task (Direct)

Use individual skills for specific tasks:

```
"Design a database schema for a CRM system"
→ schema-architect activates

"Set up the backend with Apso"
→ backend-bootstrapper activates

"Implement a comment system feature"
→ feature-builder activates
```

## Workflow Patterns

### Pattern A: Greenfield Project (Start from Scratch)

**Goal:** Build complete SaaS application from idea

**Steps:**

1. **Invoke Orchestrator**
   ```
   "Start a new SaaS project for [domain]"
   ```

2. **Phase 0: Discovery** (Week 1, Day 1)
   - Orchestrator asks questions
   - You provide project details
   - **Output:** Project context established

3. **Phase 1: Planning** (Week 1, Days 2-5)
   - Skills Called: `product-brief-writer`, `schema-architect`
   - **Output:**
     - `docs/product-requirements.md`
     - `server/.apsorc` (schema)
   - **Validation:** Review PRD and schema, iterate if needed

4. **Phase 2: Backend Setup** (Week 2)
   - Skill Called: `backend-bootstrapper`
   - **Output:**
     - `server/` directory
     - Working API at localhost:3001
     - Database with all tables
   - **Validation:** Test API endpoints via OpenAPI docs

5. **Phase 3: Frontend Setup** (Week 3)
   - Skill Called: `frontend-bootstrapper`
   - **Output:**
     - `client/` directory
     - Working app at localhost:3000
     - Type-safe API client
   - **Validation:** Navigate to homepage, see UI

6. **Phase 4: Authentication** (Week 4)
   - Skill Called: `auth-implementer`
   - **Output:**
     - Better Auth integrated
     - Login/signup pages
     - Multi-tenant isolation
   - **Validation:** Create account, login, create org

7. **Phase 5: Core Features** (Weeks 5-9)
   - For each feature:
     - You: "Implement [feature name]"
     - Skill Called: `feature-builder`
     - **Output:** Backend + Frontend + Tests
   - **Validation:** User testing after each feature

8. **Phase 6: Polish** (Week 10-11)
   - Skill Called: `test-generator`
   - **Output:** 80%+ test coverage
   - **Validation:** All tests pass

9. **Phase 7: Deployment** (Week 12)
   - Skill Called: `deployment-orchestrator`
   - **Output:** Production deployment
   - **Validation:** App running at your domain

**Result:** Production-ready SaaS in 12 weeks

### Pattern B: Adding Features to Existing Project

**Goal:** Extend existing application with new functionality

**Steps:**

1. **Describe Feature**
   ```
   "Add a commenting system where users can comment on projects and tasks"
   ```

2. **Skill Activation**
   - Claude loads: `feature-builder`
   - No orchestrator needed (context is clear)

3. **Feature Specification**
   - Skill creates spec document
   - You review and approve

4. **Implementation**
   - Skill implements:
     - Backend: Comment entity, CRUD endpoints
     - Frontend: CommentList, CommentForm components
     - Tests: Unit + integration tests

5. **Validation**
   - Test the feature
   - Provide feedback
   - Skill iterates if needed

**Timeline:** 1-3 days per feature

### Pattern C: Schema Design Only

**Goal:** Design database schema before development

**Steps:**

1. **Invoke Schema Architect**
   ```
   "Design a database schema for a SaaS CRM with contacts, deals, and activities"
   ```

2. **Entity Discovery**
   - Skill asks about entities and relationships
   - You describe your domain

3. **Schema Generation**
   - Skill creates `.apsorc` file
   - Includes multi-tenancy
   - Optimized indexes

4. **Review & Iterate**
   - You review schema
   - Request changes
   - Skill updates

5. **Output**
   - `server/.apsorc` ready for Apso
   - Entity relationship diagram
   - Documentation

**Timeline:** 1-2 hours

### Pattern D: Rapid Prototyping

**Goal:** Quick MVP to validate idea

**Steps:**

1. **Minimal Context**
   ```
   "Build a quick MVP for a to-do list SaaS. Just tasks and projects, nothing fancy."
   ```

2. **Accelerated Flow**
   - Orchestrator uses defaults
   - Skips optional features
   - Focuses on core loop

3. **Phases Compressed**
   - Week 1: Planning + Backend + Frontend
   - Week 2: Auth + Core features
   - Week 3: Polish + Deploy

**Timeline:** 3 weeks to basic MVP

## Skill Coordination Examples

### Example 1: Blog Platform

**User Request:**
```
"Build a blog platform SaaS where users can create blogs, write posts, and manage subscribers"
```

**Skills Orchestration:**

1. **`product-brief-writer`**
   - Creates PRD with:
     - Personas: Blogger, Subscriber, Admin
     - Features: Blog creation, post authoring, subscriber management
     - Success metrics: 100 active blogs, 10 posts/blog

2. **`schema-architect`**
   - Designs entities:
     - Organization (tenant)
     - User (blogger)
     - Blog (belongs to org)
     - Post (belongs to blog)
     - Subscriber (belongs to blog)
     - Subscription (billing)

3. **`backend-bootstrapper`**
   - Generates API with endpoints:
     - `/organizations`, `/users`, `/blogs`, `/posts`, `/subscribers`
   - Sets up PostgreSQL

4. **`frontend-bootstrapper`**
   - Creates Next.js app with pages:
     - `/dashboard`, `/blogs`, `/blogs/[id]/posts`, `/blogs/[id]/subscribers`

5. **`auth-implementer`**
   - Better Auth with email/password
   - Organization creation flow
   - Multi-tenant isolation

6. **`feature-builder`** (Multiple Invocations)
   - Feature 1: Blog creation & management
   - Feature 2: Rich text post editor
   - Feature 3: Subscriber signup forms
   - Feature 4: Email notifications

7. **`deployment-orchestrator`**
   - Deploy to Vercel (frontend)
   - Deploy to AWS (backend)
   - Configure domain

**Result:** Complete blog platform in 12 weeks

### Example 2: Analytics Dashboard

**User Request:**
```
"Add analytics to my existing SaaS - I want to track user activity and show charts"
```

**Skills Orchestration:**

1. **Context Recognition**
   - Claude recognizes: Existing project, new feature
   - Skips orchestrator, goes straight to `feature-builder`

2. **`feature-builder`**
   - Backend:
     - Creates `AnalyticsEvent` entity
     - Adds tracking middleware
     - Creates aggregation endpoints
   - Frontend:
     - Installs Chart.js
     - Creates `AnalyticsChart` component
     - Creates `/analytics` page
   - Tests:
     - Unit tests for aggregation logic
     - Component tests for charts

**Timeline:** 3-5 days

### Example 3: Schema Redesign

**User Request:**
```
"My current schema isn't scaling. Help me redesign it."
```

**Skills Orchestration:**

1. **`schema-architect`** (with context of existing schema)
   - Analyzes current schema
   - Identifies bottlenecks
   - Proposes optimizations:
     - Add indexes
     - Denormalize for read performance
     - Add caching layer
   - Creates migration plan

2. **User Reviews & Approves**

3. **`feature-builder`** (for each migration step)
   - Implements migrations
   - Updates API endpoints
   - Adds backward compatibility

**Timeline:** 1-2 weeks

## Advanced Usage

### Chaining Skills Manually

While Claude usually orchestrates automatically, you can suggest a flow:

```
"First design the schema for a CRM, then set up the backend with Apso"

Claude:
1. Activates schema-architect
2. Waits for your approval
3. Activates backend-bootstrapper using the schema
```

### Parallel Skill Execution

For independent tasks:

```
"Set up the backend AND write the product brief"

Claude:
1. Activates product-brief-writer
2. Also activates backend-bootstrapper (if schema exists)
3. Both work in parallel
```

### Conditional Skill Activation

Based on project state:

```
"Continue with the next phase"

Claude checks:
- If backend exists → Skip backend-bootstrapper
- If frontend exists → Skip frontend-bootstrapper
- Activates next needed skill
```

## Troubleshooting

### Issue: Skill Not Activating

**Problem:** You expect a skill to activate, but Claude uses general knowledge instead

**Solution:**
- Be more explicit: "Use the schema-architect skill to design this"
- Check skill description - does your request match trigger phrases?
- Ensure skill is installed in `.claude/skills/`

### Issue: Skills Conflicting

**Problem:** Multiple skills try to handle the same task

**Solution:**
- Be specific about what you want
- Claude will choose most relevant skill
- If wrong skill activates, say "Actually, use [skill name] instead"

### Issue: Skill Generates Wrong Output

**Problem:** Skill output doesn't match expectations

**Solution:**
- Provide more context in initial request
- Review skill's output and give feedback: "This isn't quite right because..."
- Skill will iterate based on feedback

### Issue: Can't Find Skill References

**Problem:** Skill references files that don't exist

**Solution:**
- Check `skill-name/references/` directory
- Copy necessary markdown files from main docs
- Update SKILL.md to reference correct files

## Performance Tips

### Tip 1: Provide Rich Context Upfront

**Bad:**
```
"Build a SaaS"
```

**Good:**
```
"Build a SaaS for freelancers to manage clients and projects.
Target: solo freelancers and small agencies.
Key features: client management, project tracking, time tracking, invoicing.
Timeline: 12 weeks. Tech: Apso + Next.js."
```

More context = Better skill selection = Faster development

### Tip 2: Review Early, Iterate Often

Don't wait until the end to review. Check outputs after each skill:
- Review PRD before schema design
- Review schema before backend setup
- Review backend before frontend work

### Tip 3: Use Validation Checkpoints

After each phase:
1. Test the deliverable
2. Get user feedback
3. Iterate if needed
4. Move to next phase

### Tip 4: Leverage Reference Files

Add your own reference files to skills:
```bash
# Add company-specific patterns
cp internal/our-api-patterns.md .claude/skills/backend-bootstrapper/references/

# Add design system
cp design-system.md .claude/skills/frontend-bootstrapper/references/
```

Skills will use this knowledge automatically.

## Customization

### Adding Custom Skills

1. **Create Skill Directory**
   ```bash
   mkdir .claude/skills/my-custom-skill
   ```

2. **Write SKILL.md**
   ```markdown
   ---
   name: my-custom-skill
   description: Does [specific thing]. Triggers on [phrases].
   ---

   # My Custom Skill

   [Instructions for Claude...]
   ```

3. **Add References** (optional)
   ```bash
   mkdir .claude/skills/my-custom-skill/references
   cp my-doc.md .claude/skills/my-custom-skill/references/
   ```

4. **Test**
   ```
   "Use my-custom-skill to [do thing]"
   ```

### Modifying Existing Skills

1. **Edit SKILL.md**
   ```bash
   vim .claude/skills/schema-architect/SKILL.md
   ```

2. **Update Instructions**
   - Add new patterns
   - Change output format
   - Update examples

3. **Test Changes**
   - Invoke skill with test case
   - Verify new behavior

### Sharing Skills

Skills are just directories. Share by:

1. **Export Skill**
   ```bash
   cd .claude/skills
   tar -czf schema-architect.tar.gz schema-architect/
   ```

2. **Share File**
   - Send to teammate
   - Post to GitHub
   - Submit to marketplace (future)

3. **Import Skill**
   ```bash
   cd ~/.claude/skills
   tar -xzf schema-architect.tar.gz
   ```

## Best Practices Checklist

### For Users

- ✅ Provide context upfront
- ✅ Review skill outputs promptly
- ✅ Give specific feedback
- ✅ Test after each phase
- ✅ Let Claude orchestrate (don't micromanage)

### For Skill Developers

- ✅ Single responsibility per skill
- ✅ Clear trigger descriptions
- ✅ Include examples in SKILL.md
- ✅ Add reference files for knowledge
- ✅ Test standalone and orchestrated
- ✅ Version control skills
- ✅ Document dependencies

## Migration Guide

### From Current .devenv to Skills

Your current setup → Skills architecture:

| Current | Skill Equivalent |
|---------|-----------------|
| Copy .devenv template | Use `saas-project-orchestrator` |
| Read product-development-foundation.md | Skill references this automatically |
| Read saas-implementation-guide.md | Skill uses as reference |
| Manually follow week-by-week guide | Skills orchestrate this flow |
| Manually enforce rules/*.mdc standards | `code-standards-enforcer` skill (future) |

**Migration Steps:**

1. **Keep Existing .devenv**
   - Still valuable as documentation
   - Skills reference these files

2. **Add Skills Alongside**
   ```bash
   cd ~/projects/mavric/devenv
   # Skills are already in .claude/skills/
   ```

3. **Use Skills for New Projects**
   ```
   "Build a new SaaS project using the skills system"
   ```

4. **Gradually Phase Out Manual Copying**
   - Let orchestrator handle setup
   - Use skills for feature work

## Summary

**Skills = Modular Intelligence Bricks**

- **Orchestrator** = Your guide through SDLC
- **Worker Skills** = Specialized tasks
- **Reference Files** = Domain knowledge
- **Claude** = The intelligent glue

**Start Here:**
```
"I want to build a SaaS application for [your idea]"
```

Claude will handle the rest, calling the right skills at the right time.

---

**Questions?**

- See main README: `.claude/skills/README.md`
- Check skill documentation: `.claude/skills/[skill-name]/SKILL.md`
- File issues: [Your issue tracker]
