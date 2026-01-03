# AI-Orchestrated Setup: Implementation Guide

> Practical guide for implementing the AI-first setup system

**Companion to:** [AI-Orchestrated Setup System Architecture](./ai-orchestrated-setup-system.md)

---

## Quick Start

### For Users

**Current (shell script):**
```bash
./setup.sh
# Breaks on line 47, no way to resume
```

**Future (AI skill):**
```
User: "Setup new SaaS project with Apso and BetterAuth"

Claude:
I'll set up a production-ready SaaS project. This will take about 7 minutes.

[Todo 1/5] Checking prerequisites...
✓ Node.js 20.10.0 found
✓ Docker running
✓ Ports available

[Todo 2/5] Setting up backend...
→ Creating Apso project
→ Generating auth schema
→ Running code generation
→ Auto-fixing DTO issues
✓ Backend ready at localhost:3001

[continues...]

✓ Setup complete! (6m 42s)

Your SaaS project is ready at:
- Backend: http://localhost:3001
- Frontend: http://localhost:3003
- Docs: http://localhost:3001/api/docs
```

### For Developers

**To implement a new setup skill:**

1. Create skill directory
2. Write SKILL.md with clear instructions
3. Implement core logic in references
4. Test standalone and orchestrated
5. Document integration points

---

## Implementation Roadmap

### Milestone 1: Proof of Concept (Week 1)

**Goal**: Demonstrate AI can replace one shell script section

**Implementation:**
```
.claude/skills/setup-backend-poc/
├── SKILL.md
└── references/
    └── setup-steps.md
```

**SKILL.md:**
```markdown
---
name: setup-backend-poc
description: Proof of concept - sets up basic Apso backend without auth
---

# Backend Setup POC

I create a minimal Apso backend to prove AI orchestration works.

## What I Do

1. Check Node.js version
2. Create backend directory
3. Run apso init
4. Install dependencies
5. Start server
6. Verify health endpoint

## Steps

### Step 1: Prerequisites

Check Node.js:
```bash
node --version
```

Expected: v18.0.0 or higher

If not installed:
- macOS: `brew install node@20`
- Linux: `curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs`
- Windows: Download from https://nodejs.org

### Step 2: Initialize

```bash
mkdir backend
cd backend
npx apso init
```

If this fails:
- Check network connection
- Try: `npx apso@latest init`
- If still fails, install globally: `npm install -g apso && apso init`

### Step 3: Install

```bash
npm install
```

If this fails:
- Try: `npm install --legacy-peer-deps`
- Clear cache: `npm cache clean --force && npm install`

### Step 4: Verify

Start server:
```bash
npm run start:dev
```

Test health:
```bash
curl http://localhost:3001/health
```

Expected: `{"status":"ok"}`

If server doesn't start:
- Check port 3001 is available: `lsof -i:3001`
- Check logs for errors
- Try different port: `PORT=3002 npm run start:dev`

## Success Criteria

- [ ] Server responds at localhost:3001
- [ ] Health endpoint returns 200
- [ ] No TypeScript errors
```

**Test:**
```
User: "Setup backend POC"

Claude:
I'll set up a minimal Apso backend to demonstrate the concept.

Step 1: Checking prerequisites...
→ Running: node --version
✓ Found Node.js v20.10.0

Step 2: Initializing project...
→ Creating directory: backend
→ Running: npx apso init
✓ Project initialized

Step 3: Installing dependencies...
→ Running: npm install
✓ Dependencies installed

Step 4: Starting server...
→ Running: npm run start:dev
→ Waiting for server to start...
✓ Server started

Step 5: Verifying...
→ Testing: curl http://localhost:3001/health
✓ Health check passed

Setup complete! Backend running at http://localhost:3001
```

**Success Metric**: POC completes in < 3 minutes without errors

---

### Milestone 2: Checkpoint System (Week 1-2)

**Goal**: Implement resumability

**Implementation:**

Create shared library:
```
.claude/skills/shared/
├── checkpoint.ts
├── todo-tracker.ts
└── types.ts
```

**checkpoint.ts:**
```typescript
import { writeFile, readFile, fileExists } from './fs-utils';

export interface Checkpoint {
  version: string;
  timestamp: string;
  phase: string;
  completedSteps: string[];
  config: Record<string, any>;
  artifacts: Record<string, any>;
}

export class CheckpointManager {
  private checkpointPath = '.setup-state.json';

  async save(checkpoint: Checkpoint): Promise<void> {
    const data = {
      ...checkpoint,
      timestamp: new Date().toISOString()
    };

    await writeFile(
      this.checkpointPath,
      JSON.stringify(data, null, 2)
    );

    console.log(`Checkpoint saved: ${checkpoint.phase}`);
  }

  async load(): Promise<Checkpoint | null> {
    if (!(await fileExists(this.checkpointPath))) {
      return null;
    }

    const content = await readFile(this.checkpointPath);
    return JSON.parse(content);
  }

  async clear(): Promise<void> {
    if (await fileExists(this.checkpointPath)) {
      await unlinkFile(this.checkpointPath);
    }
  }

  async canResume(): Promise<boolean> {
    return await fileExists(this.checkpointPath);
  }
}
```

**Usage in skill:**
```markdown
## Checkpoint Integration

I save progress after each major step.

### When Setup Fails

If setup fails, I save a checkpoint:

```json
{
  "version": "1.0",
  "timestamp": "2025-01-18T10:30:00Z",
  "phase": "backend-setup",
  "completedSteps": [
    "prerequisites",
    "apso-init"
  ],
  "config": {
    "projectName": "my-saas",
    "backendPort": 3001
  },
  "artifacts": {
    "backendPath": "/Users/user/my-saas/backend"
  }
}
```

### Resume Command

User says: "Resume setup"

I do:
1. Load checkpoint from .setup-state.json
2. Show what's been completed
3. Continue from last successful step

Example:
```
User: "Resume setup"

Claude:
Found checkpoint from 2 minutes ago.

Completed:
✓ Prerequisites check
✓ Apso initialization

Resuming from: Installing dependencies...
→ Running: npm install
[continues...]
```
```

**Test:**
1. Start setup
2. Kill process during npm install
3. Resume
4. Verify it continues from npm install

**Success Metric**: Can resume from any step without data loss

---

### Milestone 3: Error Handling (Week 2)

**Goal**: Auto-fix common issues

**Implementation:**

```
.claude/skills/fix-common-issues/
├── SKILL.md
└── lib/
    ├── detectors.ts
    └── fixers.ts
```

**Example: Auto-fix port conflict**

**SKILL.md:**
```markdown
## Port Conflict Detection

I detect when a port is already in use and find an alternative.

### Detection Pattern

```bash
# Try to start server
npm run start:dev

# If this error occurs:
Error: listen EADDRINUSE: address already in use :::3001
```

### Auto-Fix

1. Detect the error pattern
2. Find available port (try 3002, 3003, etc.)
3. Update configuration
4. Retry

### Implementation

```typescript
async function handlePortConflict(error: Error): Promise<FixResult> {
  const portMatch = error.message.match(/:::(\d+)/);
  if (!portMatch) {
    return { fixed: false };
  }

  const occupiedPort = parseInt(portMatch[1]);
  console.log(`Port ${occupiedPort} is in use, finding alternative...`);

  // Try nearby ports
  for (let port = occupiedPort + 1; port < occupiedPort + 10; port++) {
    if (await isPortAvailable(port)) {
      console.log(`Found available port: ${port}`);

      // Update .env
      await updateEnvFile({ PORT: port.toString() });

      // Retry
      return {
        fixed: true,
        newPort: port,
        message: `Using port ${port} instead of ${occupiedPort}`
      };
    }
  }

  return {
    fixed: false,
    message: 'No available ports found'
  };
}
```

### User Experience

```
[Setting up backend...]
→ Starting server on port 3001...
✗ Port 3001 already in use

Auto-fixing...
→ Checking port 3002... in use
→ Checking port 3003... available!
→ Updating configuration to use port 3003
→ Retrying server start...
✓ Server started on port 3003

Backend ready at: http://localhost:3003
```
```

**Test Cases:**
1. Port 3001 taken → Auto-uses 3002
2. Ports 3001-3005 taken → Auto-uses 3006
3. All ports taken → Shows error with guidance

**Success Metric**: > 90% of port conflicts auto-resolved

---

### Milestone 4: Full Orchestrator (Week 3)

**Goal**: Complete multi-phase setup

**Implementation:**

```
.claude/skills/apso-betterauth-setup/
├── SKILL.md
├── lib/
│   ├── orchestrator.ts
│   ├── phases/
│   │   ├── prerequisites.ts
│   │   ├── backend.ts
│   │   ├── database.ts
│   │   ├── frontend.ts
│   │   └── verification.ts
│   └── config.ts
└── references/
    ├── setup-flow.md
    └── decision-tree.md
```

**SKILL.md:**
```markdown
---
name: apso-betterauth-setup
description: Complete orchestrator for Apso + BetterAuth SaaS setup. Runs multi-phase setup with checkpoints, auto-fixes, and verification.
---

# Apso + BetterAuth Setup Orchestrator

I orchestrate complete SaaS project setup in 5 phases.

## Phase Flow

```
Prerequisites (30s)
    ↓
Backend Setup (3m)
    ↓
Database Config (1m)
    ↓
Frontend Setup (2m) [optional]
    ↓
Verification (1m)
    ↓
Complete
```

## TodoWrite Integration

I track progress with TodoWrite:

```json
{
  "todos": [
    {
      "content": "Check prerequisites (Node, Docker, ports)",
      "activeForm": "Checking prerequisites",
      "status": "completed"
    },
    {
      "content": "Setup Apso backend with BetterAuth",
      "activeForm": "Setting up backend",
      "status": "in_progress"
    },
    {
      "content": "Configure PostgreSQL database",
      "activeForm": "Configuring database",
      "status": "pending"
    },
    {
      "content": "Setup Next.js frontend (optional)",
      "activeForm": "Setting up frontend",
      "status": "pending"
    },
    {
      "content": "Verify complete setup",
      "activeForm": "Verifying setup",
      "status": "pending"
    }
  ]
}
```

## Execution Logic

### Fresh Start

```typescript
async function runFullSetup(config: SetupConfig): Promise<void> {
  const tracker = new ProgressTracker();
  const checkpoint = new CheckpointManager();

  // Initialize todos
  await tracker.init([
    'Check prerequisites',
    'Setup backend',
    'Configure database',
    config.includeFrontend ? 'Setup frontend' : null,
    'Verify setup'
  ].filter(Boolean));

  try {
    // Phase 1
    await tracker.start('Check prerequisites');
    await runPrerequisites();
    await tracker.complete('Check prerequisites');
    await checkpoint.save({ phase: 'prerequisites-complete', config });

    // Phase 2
    await tracker.start('Setup backend');
    await runBackendSetup(config);
    await tracker.complete('Setup backend');
    await checkpoint.save({ phase: 'backend-complete', config });

    // Phase 3
    await tracker.start('Configure database');
    await runDatabaseSetup(config);
    await tracker.complete('Configure database');
    await checkpoint.save({ phase: 'database-complete', config });

    // Phase 4 (optional)
    if (config.includeFrontend) {
      await tracker.start('Setup frontend');
      await runFrontendSetup(config);
      await tracker.complete('Setup frontend');
      await checkpoint.save({ phase: 'frontend-complete', config });
    }

    // Phase 5
    await tracker.start('Verify setup');
    const verification = await runVerification(config);
    await tracker.complete('Verify setup');

    // Done
    await checkpoint.clear();
    await showSuccessSummary(verification);

  } catch (error) {
    await checkpoint.save({
      phase: 'failed',
      error: error.message,
      config
    });

    throw error;
  }
}
```

### Resume from Checkpoint

```typescript
async function resumeSetup(): Promise<void> {
  const checkpoint = new CheckpointManager();
  const state = await checkpoint.load();

  if (!state) {
    console.log('No checkpoint found, starting fresh');
    return await runFullSetup(getDefaultConfig());
  }

  console.log(`Resuming from: ${state.phase}`);
  console.log(`Completed phases: ${state.completedSteps.join(', ')}`);

  const tracker = new ProgressTracker();

  // Restore progress
  await tracker.restore(state);

  // Continue from next phase
  switch (state.phase) {
    case 'prerequisites-complete':
      await tracker.start('Setup backend');
      await runBackendSetup(state.config);
      // ... continue flow
      break;

    case 'backend-complete':
      await tracker.start('Configure database');
      await runDatabaseSetup(state.config);
      // ... continue flow
      break;

    // ... other phases
  }
}
```

## Error Recovery

When errors occur:

1. Save checkpoint with error details
2. Attempt auto-fix (if known issue)
3. If auto-fix succeeds, continue
4. If auto-fix fails, show guidance
5. User can resume after fixing manually

Example:
```
[Phase 2: Backend Setup]
→ Running: apso server
✗ Error: nullable constraint violation

Auto-fixing...
→ Detecting issue: nullable fields not configured
→ Applying fix: Update User entity nullable fields
→ Retrying: apso server
✓ Success

[continues with Phase 3...]
```

## References

I consult these during setup:

- `references/setup-flow.md` - Complete phase descriptions
- `references/decision-tree.md` - Decision points and options
- `../backend-bootstrapper/references/` - Backend-specific guidance
- `../fix-common-issues/lib/` - Auto-fix implementations
```

**Test:**
```
User: "Setup new SaaS project"

Claude:
I'll set up a complete SaaS project with Apso and BetterAuth.

Quick questions:
1. Project name? (default: current directory name)
2. Include frontend? (default: yes)

User: "TaskFlow" and yes

Claude:
Setting up TaskFlow...

[Todo 1/5] Checking prerequisites...
→ Node.js version: 20.10.0 ✓
→ Docker status: running ✓
→ Port 3001: available ✓
→ Port 5433: available ✓
✓ Prerequisites complete

[Todo 2/5] Setting up Apso backend...
→ Creating backend directory
→ Running apso init
→ Installing dependencies (this may take 2-3 minutes)
→ Configuring .apsorc with BetterAuth entities
→ Running apso server
→ Auto-fixing DTO id fields
→ Verifying code generation
✓ Backend complete (http://localhost:3001)

[Todo 3/5] Configuring database...
→ Starting PostgreSQL container
→ Waiting for database ready...
→ Creating database: taskflow_dev
→ Running schema sync
→ Verifying tables (user, account, session, verification, organization)
✓ Database complete

[Todo 4/5] Setting up Next.js frontend...
→ Creating frontend directory
→ Running create-next-app
→ Installing dependencies
→ Configuring BetterAuth client
→ Setting up shadcn/ui
→ Creating auth components
✓ Frontend complete (http://localhost:3003)

[Todo 5/5] Verifying setup...
→ Testing backend health... ✓
→ Testing auth endpoints... ✓
→ Testing database integrity... ✓
→ Testing frontend build... ✓
→ Creating test user... ✓
✓ Verification complete

Setup complete! (6m 42s)

Your SaaS project "TaskFlow" is ready:

Backend: http://localhost:3001
Frontend: http://localhost:3003
Docs: http://localhost:3001/api/docs

Test account:
Email: admin@taskflow.local
Password: admin123

Next steps:
1. cd backend && npm run start:dev
2. cd frontend && npm run dev
3. Open http://localhost:3003
```

**Success Metric**: Complete setup in < 8 minutes with zero manual steps

---

### Milestone 5: Production Ready (Week 4-5)

**Goal**: Battle-tested, documented, deployable

**Checklist:**

- [ ] Comprehensive test suite
- [ ] Works on macOS, Linux, Windows
- [ ] Handles all common errors
- [ ] Clear documentation
- [ ] Video walkthrough
- [ ] Migration guide from scripts

**Test Matrix:**

| Scenario | macOS | Linux | Windows |
|----------|-------|-------|---------|
| Fresh setup | ✓ | ✓ | ✓ |
| Resume from checkpoint | ✓ | ✓ | ✓ |
| Port conflict | ✓ | ✓ | ✓ |
| Docker not running | ✓ | ✓ | ✓ |
| Node version mismatch | ✓ | ✓ | ✓ |
| Network timeout | ✓ | ✓ | ✓ |
| Disk full | ✓ | ✓ | ✓ |

**Documentation:**

1. **User Guide**: How to run setup
2. **Developer Guide**: How to add new skills
3. **Troubleshooting**: Common issues
4. **Architecture**: System design (this document)
5. **API Reference**: Skill interfaces

---

## Best Practices

### Writing Skills

**DO:**
- Write clear, conversational instructions
- Explain what you're doing and why
- Provide specific error messages
- Include verification steps
- Save checkpoints frequently

**DON'T:**
- Assume environment details
- Use complex conditional logic
- Hide errors from users
- Skip verification
- Create brittle dependencies

### Example: Good vs Bad

**BAD:**
```markdown
Run npm install. If it fails, try --legacy-peer-deps.
```

**GOOD:**
```markdown
Install dependencies:

```bash
npm install
```

If this fails with a peer dependency error:

```
npm ERR! ERESOLVE unable to resolve dependency tree
```

This is common with Next.js 14+. Solution:

```bash
npm install --legacy-peer-deps
```

Why this works:
Next.js 14 has stricter peer dependencies. The --legacy-peer-deps flag
uses the legacy npm resolution algorithm which is more permissive.

If this also fails:
1. Clear npm cache: `npm cache clean --force`
2. Delete node_modules: `rm -rf node_modules`
3. Try again: `npm install --legacy-peer-deps`

Still having issues? Check:
- Node version: `node --version` (should be 18+)
- npm version: `npm --version` (should be 9+)
- Disk space: `df -h` (need at least 500MB)
```

### Testing Skills

**Test Cases:**

1. **Happy Path**: Everything works first time
2. **Common Errors**: Port conflicts, missing deps, etc.
3. **Edge Cases**: Weird environments, old versions
4. **Resume**: Can resume from any checkpoint
5. **Cancellation**: Can stop and resume later

**Example Test:**

```typescript
describe('setup-backend skill', () => {
  it('completes successfully on fresh system', async () => {
    const result = await runSkill('setup-backend', {
      projectName: 'test-project'
    });

    expect(result.success).toBe(true);
    expect(result.artifacts).toHaveProperty('backendUrl');
    expect(await fetch(result.artifacts.backendUrl)).toBeOk();
  });

  it('handles port conflict gracefully', async () => {
    // Occupy port 3001
    const blocker = await startServer(3001);

    const result = await runSkill('setup-backend', {
      projectName: 'test-project'
    });

    expect(result.success).toBe(true);
    expect(result.artifacts.backendUrl).not.toContain('3001');
    expect(result.artifacts.backendUrl).toContain('300'); // 3002, 3003, etc.

    await blocker.close();
  });

  it('can resume after failure', async () => {
    // Cause a failure mid-setup
    const mockFs = vi.spyOn(fs, 'writeFile').mockRejectedValueOnce(
      new Error('Disk full')
    );

    const firstRun = await runSkill('setup-backend', {
      projectName: 'test-project'
    });

    expect(firstRun.success).toBe(false);
    expect(await checkpointExists()).toBe(true);

    mockFs.mockRestore();

    // Resume
    const secondRun = await resumeSkill('setup-backend');

    expect(secondRun.success).toBe(true);
    expect(await checkpointExists()).toBe(false); // Cleaned up
  });
});
```

---

## Migration from Shell Scripts

### Step 1: Identify Script Sections

Map your current script to skill phases:

```bash
# setup.sh
set -e

echo "Creating backend..."      # → Phase: backend-setup
mkdir backend
cd backend
npx apso init

echo "Installing deps..."       # → Phase: backend-setup
npm install

echo "Starting database..."     # → Phase: database-config
docker-compose up -d

echo "Running migrations..."    # → Phase: database-config
npm run db:migrate

echo "Starting backend..."      # → Phase: verification
npm run start:dev

echo "Testing..."               # → Phase: verification
curl http://localhost:3001/health
```

### Step 2: Create Skills

For each section, create a skill:

```
.claude/skills/
├── setup-backend/
│   └── SKILL.md (maps to "Creating backend" + "Installing deps")
├── configure-database/
│   └── SKILL.md (maps to "Starting database" + "Running migrations")
└── verify-setup/
    └── SKILL.md (maps to "Starting backend" + "Testing")
```

### Step 3: Add Intelligence

Enhance with error handling:

**Script:**
```bash
docker-compose up -d
# If this fails, script dies
```

**Skill:**
```markdown
Start PostgreSQL container:

```bash
docker-compose up -d
```

If this fails:

Error: "Cannot connect to Docker daemon"
→ Docker not running
→ Start Docker Desktop
→ Retry

Error: "port is already allocated"
→ Port 5433 in use
→ Find available port (5434, 5435, etc.)
→ Update docker-compose.yml
→ Retry

Error: "network timeout"
→ Network issue
→ Check internet connection
→ Try: docker-compose up -d --timeout 120
→ Retry
```

### Step 4: Test Side-by-Side

Run both in parallel environments:

| Test | Shell Script | AI Skill |
|------|--------------|----------|
| Fresh install | ✓ 3m 12s | ✓ 3m 24s |
| Port conflict | ✗ Failed | ✓ Auto-fixed |
| Resume | ✗ N/A | ✓ Resumed |
| Wrong Node version | ✗ Cryptic error | ✓ Clear guidance |
| Docker not running | ✗ Failed | ✓ Auto-started |

### Step 5: Deprecate Script

Once AI skills proven:

1. Add deprecation notice to script
2. Update documentation to use skills
3. Keep script for 1-2 months
4. Remove script

**Deprecation notice:**
```bash
#!/bin/bash

cat << EOF
⚠️  WARNING: This shell script is deprecated

Please use the AI-orchestrated setup instead:

  User: "Setup new SaaS project with Apso and BetterAuth"

Advantages:
- Cross-platform (works on any OS)
- Self-healing (auto-fixes common issues)
- Resumable (continue from failures)
- Better error messages

This script will be removed on 2025-03-01.

Press Ctrl+C to cancel, or Enter to continue with old script...
EOF

read
```

---

## Troubleshooting

### Common Issues

**Issue: Skill doesn't activate**

Check:
- Skill name in frontmatter matches directory
- Description includes relevant trigger phrases
- SKILL.md is valid markdown with frontmatter

**Issue: Checkpoint not saving**

Check:
- Write permissions in directory
- Disk space available
- Checkpoint code is called after each phase

**Issue: Auto-fix not working**

Check:
- Error pattern matches detection regex
- Fix logic is correct
- Fix is being called from error handler

**Issue: TodoWrite not updating**

Check:
- TodoWrite tool is available
- Todo status is being updated
- Todo content matches exactly (case-sensitive)

---

## Examples

### Complete Skill Template

```markdown
---
name: skill-name
description: Brief description including trigger phrases like "setup X" or "configure Y"
---

# Skill Name

I [what this skill does].

## What I Do

1. [Step 1]
2. [Step 2]
3. [Step 3]

## How I Work

### Step 1: [Name]

[Instructions for Claude to execute]

Commands:
```bash
command here
```

If this fails:
- [Common error 1]: [How to fix]
- [Common error 2]: [How to fix]

### Step 2: [Name]

[Instructions]

## TodoWrite Integration

```json
{
  "todos": [
    {
      "content": "Step 1 description",
      "activeForm": "Step 1 -ing form",
      "status": "completed"
    },
    {
      "content": "Step 2 description",
      "activeForm": "Step 2 -ing form",
      "status": "in_progress"
    }
  ]
}
```

## Checkpoint

I save progress after each major step.

Checkpoint structure:
```json
{
  "phase": "step-name",
  "completedSteps": ["step1", "step2"],
  "config": {...},
  "artifacts": {...}
}
```

## Verification

I verify success by:
- [Check 1]
- [Check 2]

## Error Handling

Common issues I auto-fix:
- [Issue 1]: [Fix description]
- [Issue 2]: [Fix description]

Issues requiring manual intervention:
- [Issue 3]: [Guidance]

## References

- `references/doc1.md` - [Description]
- `references/doc2.md` - [Description]
```

---

## Next Steps

1. **Implement POC** (Week 1)
   - Create one skill that replaces one script section
   - Prove the concept works

2. **Add Checkpoints** (Week 1-2)
   - Implement checkpoint system
   - Test resume functionality

3. **Build Orchestrator** (Week 2-3)
   - Create master skill
   - Coordinate multiple phases

4. **Production Harden** (Week 3-4)
   - Comprehensive testing
   - Documentation
   - Migration guide

5. **Deprecate Scripts** (Week 4-5)
   - Add deprecation notices
   - Update docs
   - Remove after grace period

---

## Resources

- **Architecture Doc**: [AI-Orchestrated Setup System](./ai-orchestrated-setup-system.md)
- **Skills Guide**: `/.claude/skills/README.md`
- **Backend Bootstrapper**: `/.claude/skills/backend-bootstrapper/SKILL.md`
- **Troubleshooting**: `/.claude/skills/backend-bootstrapper/references/troubleshooting/`

---

**Ready to build?**

Start with the POC:
1. Copy the template above
2. Fill in your specific steps
3. Test with Claude
4. Iterate based on results

The future is AI-orchestrated, not script-based.

---

**Document Version:** 1.0
**Last Updated:** 2025-01-18
**Status:** Implementation Guide
