# AI-Orchestrated Setup: Quick Reference

> One-page cheat sheet for the AI orchestration system

---

## For Users

### Starting Fresh Setup

```
User: "Setup new SaaS project with Apso and BetterAuth"
```

Claude handles:
1. Prerequisites check
2. Backend setup (Apso + BetterAuth)
3. Database configuration
4. Frontend setup (optional)
5. Verification

Time: ~7 minutes

### Resuming After Failure

```
User: "Resume setup from checkpoint"
```

Claude:
- Loads saved state
- Shows completed steps
- Continues from failure point

### Getting Help

```
User: "What went wrong with the setup?"
```

Claude:
- Analyzes checkpoint
- Diagnoses issue
- Suggests specific fixes

---

## For Developers

### Skill Structure

```
.claude/skills/skill-name/
├── SKILL.md              # Main skill definition
├── lib/                  # Implementation logic
│   └── logic.ts
└── references/           # Supporting docs
    └── guide.md
```

### SKILL.md Template

```markdown
---
name: skill-name
description: What it does + trigger phrases
---

# Skill Name

I [what this skill does].

## What I Do

1. Step 1
2. Step 2
3. Step 3

## How I Work

[Detailed instructions for Claude]

## TodoWrite Integration

```json
{
  "todos": [
    {
      "content": "Description",
      "activeForm": "Doing description",
      "status": "in_progress"
    }
  ]
}
```

## Error Handling

[Common errors and fixes]

## Verification

[How to verify success]
```

### Creating a New Skill

1. Create directory: `.claude/skills/my-skill/`
2. Write `SKILL.md` with frontmatter
3. Add implementation in `lib/` (optional)
4. Test standalone
5. Test in orchestrated flow
6. Document integration points

### Checkpoint System

**Save checkpoint:**
```typescript
const checkpoint = {
  phase: 'backend-setup',
  completedSteps: ['prerequisites'],
  config: { projectName: 'my-app' },
  artifacts: { backendPath: '/path' }
};

await writeJSON('.setup-state.json', checkpoint);
```

**Load checkpoint:**
```typescript
const checkpoint = await readJSON('.setup-state.json');

if (checkpoint) {
  // Resume from checkpoint.phase
}
```

### TodoWrite Integration

**Initialize:**
```typescript
await TodoWrite({
  todos: [
    {
      content: "Check prerequisites",
      activeForm: "Checking prerequisites",
      status: "pending"
    }
  ]
});
```

**Update:**
```typescript
await TodoWrite({
  todos: [
    {
      content: "Check prerequisites",
      activeForm: "Checking prerequisites",
      status: "completed"
    },
    {
      content: "Setup backend",
      activeForm: "Setting up backend",
      status: "in_progress"
    }
  ]
});
```

### Error Handling Pattern

```typescript
try {
  await runCommand();
} catch (error) {
  // Level 1: Auto-fix
  if (isKnownIssue(error)) {
    await applyFix(error);
    return await runCommand(); // Retry
  }

  // Level 2: Alternative approach
  if (hasAlternative(error)) {
    return await tryAlternative();
  }

  // Level 3: User guidance
  if (isInteractive) {
    const choice = await askUser(error);
    return await handleChoice(choice);
  }

  // Level 4: Graceful degradation
  await skipOptionalStep();
}
```

---

## Key Patterns

### Detection Pattern

```markdown
I detect when [specific condition].

Signs of the issue:
- Error message contains "X"
- File Y is missing
- Port Z is occupied

Auto-fix steps:
1. [Do this]
2. [Then this]
3. Verify with [check]
```

### Verification Pattern

```markdown
I verify success by:

1. Check [condition 1]
   ```bash
   command to verify
   ```
   Expected: [result]

2. Check [condition 2]
   ```bash
   command to verify
   ```
   Expected: [result]
```

### Progressive Guidance Pattern

```markdown
If [error] occurs:

Quick fix (try this first):
```bash
command
```

If that doesn't work:
```bash
alternative command
```

Still not working? Check:
- [Prerequisite 1]
- [Prerequisite 2]
- [Prerequisite 3]

Need help? [Link to detailed guide]
```

---

## Common Scenarios

### Scenario 1: Port Conflict

**Detection:**
```
Error: EADDRINUSE :::3001
```

**Auto-fix:**
1. Detect port from error
2. Try ports 3002-3010
3. Update config with available port
4. Retry

### Scenario 2: Missing Dependency

**Detection:**
```
Error: Cannot find module 'X'
```

**Auto-fix:**
1. Identify missing package
2. Install: `npm install X`
3. Retry

### Scenario 3: Permission Error

**Detection:**
```
Error: EACCES permission denied
```

**Guidance:**
```
Permission issue detected.

Fix:
sudo chown -R $(whoami) ~/.npm

Why this works:
npm cache has wrong permissions. This command
fixes ownership of npm's cache directory.
```

### Scenario 4: Database Not Ready

**Detection:**
```
Error: connect ECONNREFUSED
```

**Auto-fix:**
1. Check if Docker running
2. If not, wait 30s and retry
3. If still failing, check port availability
4. If port taken, use alternative port

---

## Testing Checklist

### Unit Tests

- [ ] Skill completes on fresh system
- [ ] Skill handles port conflicts
- [ ] Skill handles missing dependencies
- [ ] Skill handles permission errors
- [ ] Skill can resume from checkpoint

### Integration Tests

- [ ] Skill integrates with orchestrator
- [ ] Skill passes data to next skill
- [ ] Skill updates TodoWrite correctly
- [ ] Skill saves checkpoint properly

### Platform Tests

- [ ] Works on macOS
- [ ] Works on Linux
- [ ] Works on Windows

### Edge Cases

- [ ] Old Node version (18.0.0)
- [ ] New Node version (22.0.0)
- [ ] Slow network
- [ ] Limited disk space
- [ ] Existing files in directory

---

## Debugging

### View Checkpoint

```bash
cat .setup-state.json | jq
```

### Check Todos

Look for TodoWrite output in Claude's response.

### Test Skill Standalone

```
User: "Run [skill-name] skill"
```

### Check Logs

Skills should log actions:
```
→ Running: npm install
✓ Complete (23s)
✗ Failed: Port 3001 in use
```

---

## Performance Targets

| Metric | Target |
|--------|--------|
| Setup time | < 7 min |
| Auto-fix rate | > 80% |
| Resume success | > 95% |
| First-time success | > 90% |

---

## Best Practices

### DO

- Write conversational instructions
- Explain what you're doing
- Provide specific error messages
- Include verification steps
- Save checkpoints frequently
- Handle errors gracefully
- Test on multiple platforms

### DON'T

- Assume environment details
- Use complex conditional logic
- Hide errors from users
- Skip verification
- Create brittle dependencies
- Use platform-specific commands without alternatives

---

## Resources

- **Architecture:** [ai-orchestrated-setup-system.md](./ai-orchestrated-setup-system.md)
- **Implementation:** [ai-setup-implementation-guide.md](./ai-setup-implementation-guide.md)
- **Overview:** [README.md](./README.md)
- **Existing Skills:** `/.claude/skills/`

---

## Quick Examples

### Minimal Skill

```markdown
---
name: hello-setup
description: Test skill that says hello
---

# Hello Setup

I demonstrate a minimal skill.

## What I Do

Print a greeting.

## How I Work

```bash
echo "Hello from AI skill!"
```

That's it!
```

### Skill with Error Handling

```markdown
---
name: port-checker
description: Checks if port is available
---

# Port Checker

I verify a port is available for use.

## What I Do

Check if port 3001 is available.

If not, find an alternative.

## How I Work

```bash
lsof -ti:3001
```

If output is empty:
→ Port available ✓

If output shows PID:
→ Port in use
→ Try port 3002
→ Try port 3003
→ Use first available
```

### Skill with Checkpoint

```markdown
---
name: backend-init
description: Initialize backend with checkpoint
---

# Backend Init

I initialize a backend and save progress.

## What I Do

1. Create directory
2. Run apso init
3. Save checkpoint

## How I Work

Step 1:
```bash
mkdir backend && cd backend
```

Checkpoint:
```json
{
  "phase": "directory-created",
  "artifacts": { "path": "backend" }
}
```

Step 2:
```bash
npx apso init
```

Checkpoint:
```json
{
  "phase": "apso-initialized",
  "completedSteps": ["directory-created"],
  "artifacts": { "path": "backend" }
}
```
```

---

**Keep this handy when building skills!**

For full details, see the main architecture documents.

---

**Last Updated:** 2025-01-18
**Version:** 1.0
