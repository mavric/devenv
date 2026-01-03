# Architecture Documentation

> Design documents for the Mavric SaaS development platform

---

## Overview

This directory contains architectural design documents for replacing traditional development workflows with AI-orchestrated intelligent systems.

## Documents

### 1. [AI-Orchestrated Setup System](./ai-orchestrated-setup-system.md)

**Complete architectural design for replacing shell scripts with Claude Code skills**

**What it covers:**
- System architecture (master orchestrator + phase skills + utilities)
- Skill design patterns and communication protocols
- Error handling (4-level progressive escalation)
- Progress tracking with TodoWrite
- Checkpoint/resume system
- Self-healing intelligence
- Cross-platform compatibility

**Key innovations:**
- Declarative intent vs. imperative commands
- Context-aware adaptation to environment
- Automatic issue detection and fixing
- Perfect resumability from any failure point

**For:**
- Technical architects
- Senior developers
- Anyone designing AI-first systems

**Read time:** 25 minutes

---

### 2. [AI Setup Implementation Guide](./ai-setup-implementation-guide.md)

**Practical step-by-step guide for implementing the AI orchestration system**

**What it covers:**
- 5-milestone roadmap (POC → Production)
- Code examples and templates
- Testing strategies
- Migration path from shell scripts
- Troubleshooting common issues
- Complete skill template

**Key sections:**
- Quick Start (for users and developers)
- Milestone breakdown with success metrics
- Best practices (do's and don'ts)
- Side-by-side comparison (script vs skill)

**For:**
- Developers implementing the system
- Teams migrating from scripts
- Contributors adding new skills

**Read time:** 20 minutes

---

## The Vision

### Current State: Brittle Scripts

```bash
#!/bin/bash
set -e

mkdir backend && cd backend
npx apso init
npm install
docker-compose up -d
apso server
npm run start:dev
```

**Problems:**
- Fails on first error
- Platform-specific
- Not resumable
- No intelligence
- Poor error messages

### Future State: AI Orchestration

```
User: "Setup new SaaS project with Apso and BetterAuth"

Claude:
I'll set up a production-ready SaaS project. This takes about 7 minutes.

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

[continues autonomously...]

✓ Setup complete! (6m 42s)

Your SaaS is ready at http://localhost:3001
```

**Advantages:**
- Self-healing
- Cross-platform
- Resumable
- Intelligent
- Actionable guidance

---

## Key Concepts

### 1. Skills as Intelligence Bricks

Each skill is a specialized module of knowledge:

```
apso-betterauth-setup (orchestrator)
├─→ setup-backend (phase skill)
│   ├─→ fix-common-issues (utility)
│   └─→ verify-setup (utility)
├─→ setup-frontend (phase skill)
└─→ configure-database (utility)
```

Skills:
- Know how to accomplish specific goals
- Adapt to environment variations
- Handle errors intelligently
- Communicate via checkpoints

### 2. Progressive Error Handling

Four levels of escalation:

```
Level 1: Auto-Fix
├─ Known issue detected
├─ Apply automatic fix
└─ Continue

Level 2: Retry with Alternative
├─ First approach failed
├─ Try different method
└─ Continue

Level 3: User Guidance
├─ Need user input
├─ Present options with context
└─ Wait for decision

Level 4: Graceful Degradation
├─ Cannot proceed
├─ Skip optional feature
└─ Continue with limitations
```

### 3. Checkpoint System

Resume from any point:

```json
{
  "phase": "backend-setup",
  "completedSteps": ["prerequisites", "apso-init"],
  "failedSteps": [],
  "config": {
    "projectName": "my-saas",
    "backendPort": 3001
  },
  "artifacts": {
    "backendPath": "/path/to/backend",
    "databaseUrl": "postgresql://..."
  }
}
```

If setup fails:
1. Checkpoint is saved
2. User fixes issue
3. "Resume setup" continues from exact point

### 4. TodoWrite Integration

Live progress tracking:

```json
{
  "todos": [
    {
      "content": "Check prerequisites",
      "activeForm": "Checking prerequisites",
      "status": "completed"
    },
    {
      "content": "Setup backend",
      "activeForm": "Setting up backend",
      "status": "in_progress"
    },
    {
      "content": "Configure database",
      "activeForm": "Configuring database",
      "status": "pending"
    }
  ]
}
```

User sees real-time progress in their IDE.

---

## Architecture Principles

### 1. Declarative Over Imperative

**Imperative (scripts):**
```bash
cd backend
npm install --legacy-peer-deps
```

**Declarative (skills):**
```markdown
Install backend dependencies.

Handle common errors:
- Peer dependency conflicts: Use --legacy-peer-deps
- Network timeouts: Retry with exponential backoff
- Disk full: Clean npm cache and retry
```

Claude figures out the HOW based on environment.

### 2. Intelligence Over Logic

**Logic (scripts):**
```bash
if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install postgresql
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  apt-get install postgresql
fi
```

**Intelligence (skills):**
```markdown
Ensure PostgreSQL is available.

Detection:
- Check if already installed
- Check if Docker available
- Suggest best option for user's OS

Let me handle the platform-specific details.
```

Claude adapts without conditional logic.

### 3. Self-Healing Over Failing

**Failing (scripts):**
```bash
apso server
# Error: Missing id field in DTO
# Script exits
```

**Self-Healing (skills):**
```markdown
Generate backend code.

Known issues I auto-fix:
- Missing id fields → Add to DTOs
- Nullable constraints → Update entities
- Module imports → Fix AppModule

If I detect these, I'll fix them automatically and continue.
```

Claude detects and fixes issues autonomously.

### 4. Resumable Over Restartable

**Restartable (scripts):**
```bash
# Setup fails at step 5
# Must run entire script again
# Steps 1-4 run unnecessarily
```

**Resumable (skills):**
```markdown
Checkpoint after each major step.

If failure occurs:
- Save exact state
- User can fix issue
- Resume from exact failure point
- Skip completed steps
```

Claude never repeats completed work.

---

## Comparison

| Aspect | Shell Scripts | AI Skills |
|--------|---------------|-----------|
| **Platform Support** | OS-specific conditionals | Universal, adaptive |
| **Error Handling** | Exit on first error | Progressive escalation |
| **Resumability** | None (start from scratch) | Full checkpoint system |
| **Intelligence** | None (blind execution) | Context-aware decisions |
| **Self-Healing** | None | Auto-fixes known issues |
| **User Guidance** | Generic error dumps | Specific, actionable advice |
| **Adaptability** | Fixed logic | Handles edge cases |
| **Maintenance** | Breaks with updates | Self-updating patterns |
| **Testing** | Manual, fragile | Comprehensive, automated |
| **Documentation** | Separate files | Self-documenting |

---

## Implementation Roadmap

### Week 1: Proof of Concept
- Create one skill that replaces one script section
- Implement basic checkpoint system
- Prove the concept works

**Success Metric:** One working skill with resume capability

### Week 2: Core Infrastructure
- Build checkpoint manager
- Implement TodoWrite integration
- Create error handler framework
- Develop skill invocation system

**Success Metric:** Reusable infrastructure for all skills

### Week 3: Full Orchestrator
- Master orchestrator skill
- All phase skills (backend, frontend, database)
- Inter-skill communication
- End-to-end flow

**Success Metric:** Complete setup in < 8 minutes

### Week 4: Utility Skills
- Verification skill with comprehensive tests
- Fix-common-issues skill with auto-fixes
- Diagnostic intelligence
- Self-healing patterns

**Success Metric:** > 90% auto-fix rate for common issues

### Week 5: Production Ready
- Cross-platform testing (macOS, Linux, Windows)
- Comprehensive documentation
- Migration guide from scripts
- Deprecation strategy

**Success Metric:** Works reliably on all major platforms

---

## Success Metrics

### Technical
- **Setup Time:** < 7 minutes for complete setup
- **Auto-Fix Rate:** > 80% of common issues fixed automatically
- **Resume Success:** > 95% resume from any checkpoint
- **Test Coverage:** > 80% of code paths
- **Cross-Platform:** Works on macOS, Linux, Windows

### User Experience
- **First-Time Success:** > 90% complete without errors
- **User Confidence:** > 8/10 in post-setup survey
- **Support Tickets:** < 10% require human assistance
- **Repeat Usage:** > 70% use for multiple projects

---

## Getting Started

### For Users

Want to try the AI-orchestrated setup?

```
# In your Claude Code chat:
"Setup new SaaS project with Apso and BetterAuth"

# Claude will handle everything:
# - Check prerequisites
# - Setup backend
# - Configure database
# - Setup frontend (optional)
# - Verify everything works
```

### For Developers

Want to implement or extend the system?

1. Read the [Architecture Document](./ai-orchestrated-setup-system.md)
2. Follow the [Implementation Guide](./ai-setup-implementation-guide.md)
3. Start with Milestone 1 (POC)
4. Test thoroughly
5. Contribute back

### For Contributors

Want to add new skills?

See the skill template in the [Implementation Guide](./ai-setup-implementation-guide.md#complete-skill-template).

---

## Future Vision

### Version 2.0 (3-6 months)

**Multi-Cloud Deployment**
- AWS, GCP, Azure deployment skills
- Auto-configure infrastructure
- CI/CD pipeline generation

**Advanced Monitoring**
- Sentry, PostHog, LogRocket auto-setup
- Performance monitoring
- Error tracking
- Analytics integration

**Security Hardening**
- Auto-apply security best practices
- Dependency vulnerability scanning
- Secret rotation
- Compliance checks

### Version 3.0 (6-12 months)

**AI Code Review**
- Automatic code quality checks
- SOLID principle enforcement
- Performance optimization suggestions
- Security vulnerability detection

**Intelligent Updates**
- Auto-update dependencies safely
- Test compatibility before updating
- Rollback if issues detected
- Zero-downtime updates

**Self-Optimization**
- Learn from failures
- Improve auto-fix patterns
- Adapt to new technologies
- Contribute fixes upstream

---

## Philosophy

> "The best setup is one you never think about."

Traditional scripts make you think about:
- OS differences
- Error handling
- Retry logic
- State management
- Resume capability

AI skills handle all of this transparently:
- You state your intent
- AI figures out execution
- Issues are auto-fixed
- Progress is tracked
- Failures are recoverable

**Result:** You focus on building your product, not fighting setup scripts.

---

## Questions?

**Technical questions:**
- See the [Architecture Document](./ai-orchestrated-setup-system.md)
- Check the [Implementation Guide](./ai-setup-implementation-guide.md)

**Implementation help:**
- Review existing skills in `/.claude/skills/`
- Check the skill template
- Test with small POC first

**General questions:**
- File an issue in the project repo
- Join the discussion

---

## The Bottom Line

**Instead of this:**
```bash
./setup.sh
# Error on line 47
# Figure out what went wrong
# Fix it manually
# Run script again from start
# Different error on line 63
# ...
```

**You get this:**
```
"Setup my project"

✓ Done (7 minutes)

Your app is ready at http://localhost:3001
```

The future of development tooling is AI-orchestrated, not script-based.

---

**Document Version:** 1.0
**Last Updated:** 2025-01-18
**Status:** Living Document (updated as system evolves)
