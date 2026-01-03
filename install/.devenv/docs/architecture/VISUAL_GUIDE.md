# AI-Orchestrated Setup: Visual Guide

> Diagrams and flowcharts explaining the system architecture

---

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                          USER                                    │
│                                                                   │
│  "Setup new SaaS project with Apso and BetterAuth"              │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                   CLAUDE CODE                                    │
│                                                                   │
│  1. Understands intent                                           │
│  2. Activates appropriate skill                                  │
│  3. Orchestrates execution                                       │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│              MASTER ORCHESTRATOR SKILL                           │
│              (apso-betterauth-setup)                             │
│                                                                   │
│  Coordinates:                                                    │
│  • Phase sequencing                                              │
│  • Error handling                                                │
│  • Progress tracking (TodoWrite)                                 │
│  • Checkpoint management                                         │
└───────────────┬────────────┬────────────┬────────────┬──────────┘
                │            │            │            │
       ┌────────┘            │            │            └────────┐
       │                     │            │                     │
       ▼                     ▼            ▼                     ▼
┌─────────────┐   ┌──────────────┐   ┌──────────┐   ┌──────────────┐
│Prerequisites│   │setup-backend │   │configure │   │setup-frontend│
│   Skill     │   │    Skill     │   │-database │   │    Skill     │
└─────────────┘   └──────────────┘   │  Skill   │   └──────────────┘
                                     └──────────┘
       │                     │            │                     │
       │                     │            │                     │
       └────────┬────────────┴────────────┴────────────┬────────┘
                │                                       │
                ▼                                       ▼
       ┌──────────────┐                       ┌──────────────┐
       │verify-setup  │                       │fix-common-   │
       │   Skill      │                       │issues Skill  │
       └──────────────┘                       └──────────────┘
                │                                       │
                └───────────────┬───────────────────────┘
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    WORKING SAAS PROJECT                          │
│                                                                   │
│  • Backend: http://localhost:3001                                │
│  • Frontend: http://localhost:3003                               │
│  • Database: PostgreSQL (Docker)                                 │
│  • Auth: BetterAuth configured                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## Execution Flow

```
START
  │
  ▼
┌─────────────────────┐
│ User states intent  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐        ┌──────────────────┐
│ Load checkpoint?    │───YES──│ Resume from      │
│                     │        │ saved state      │
└──────────┬──────────┘        └────────┬─────────┘
           │                            │
           NO                           │
           │                            │
           ▼                            ▼
┌─────────────────────┐        ┌──────────────────┐
│ Initialize fresh    │        │ Skip completed   │
│ setup               │        │ phases           │
└──────────┬──────────┘        └────────┬─────────┘
           │                            │
           └──────────┬─────────────────┘
                      │
                      ▼
           ┌─────────────────────┐
           │ Execute Phase 1:    │
           │ Prerequisites       │
           └──────────┬──────────┘
                      │
                      ├─────────┐
                      │         │
                   SUCCESS   FAILURE
                      │         │
                      │         ▼
                      │    ┌─────────────────┐
                      │    │ Save checkpoint │
                      │    ├─────────────────┤
                      │    │ Try auto-fix    │
                      │    ├─────────────────┤
                      │    │ If fixed:       │
                      │    │   Continue      │
                      │    │ If not:         │
                      │    │   Ask user      │
                      │    └─────────────────┘
                      │
                      ▼
           ┌─────────────────────┐
           │ Save checkpoint     │
           │ Phase 1 complete    │
           └──────────┬──────────┘
                      │
                      ▼
           ┌─────────────────────┐
           │ Execute Phase 2:    │
           │ Backend Setup       │
           └──────────┬──────────┘
                      │
                    [repeat pattern]
                      │
                      ▼
           ┌─────────────────────┐
           │ All phases complete │
           ├─────────────────────┤
           │ Clear checkpoint    │
           ├─────────────────────┤
           │ Show summary        │
           └──────────┬──────────┘
                      │
                      ▼
                    SUCCESS
```

---

## Error Handling Flow

```
                    ERROR OCCURS
                         │
                         ▼
              ┌──────────────────────┐
              │ Classify error type  │
              └──────────┬───────────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Known issue? │  │ Has retry    │  │ User input   │
│              │  │ strategy?    │  │ needed?      │
└──────┬───────┘  └──────┬───────┘  └──────┬───────┘
       │                 │                 │
      YES               YES               YES
       │                 │                 │
       ▼                 ▼                 ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ LEVEL 1      │  │ LEVEL 2      │  │ LEVEL 3      │
│ Auto-Fix     │  │ Retry with   │  │ User         │
│              │  │ Alternative  │  │ Guidance     │
└──────┬───────┘  └──────┬───────┘  └──────┬───────┘
       │                 │                 │
       │                 │                 │
       ├─────────────────┼─────────────────┤
       │                                   │
       ▼                                   ▼
┌──────────────┐                    ┌──────────────┐
│ Apply fix    │                    │ Ask user     │
├──────────────┤                    ├──────────────┤
│ Retry        │                    │ Wait for     │
└──────┬───────┘                    │ decision     │
       │                            └──────┬───────┘
       │                                   │
       ├───────────────────────────────────┤
       │                                   │
      SUCCESS?                          CONTINUE?
       │                                   │
   ┌───┴───┐                           ┌───┴───┐
   │       │                           │       │
  YES     NO                          YES     NO
   │       │                           │       │
   │       ▼                           │       ▼
   │  ┌──────────────┐                │  ┌──────────────┐
   │  │ LEVEL 4      │                │  │ Save         │
   │  │ Graceful     │                │  │ checkpoint   │
   │  │ Degradation  │                │  ├──────────────┤
   │  └──────┬───────┘                │  │ Stop setup   │
   │         │                        │  └──────────────┘
   │         ▼                        │
   │  ┌──────────────┐                │
   │  │ Skip feature │                │
   │  ├──────────────┤                │
   │  │ Log issue    │                │
   │  ├──────────────┤                │
   │  │ Continue     │                │
   │  └──────┬───────┘                │
   │         │                        │
   └─────────┴────────────────────────┘
             │
             ▼
       CONTINUE SETUP
```

---

## Checkpoint System

```
┌─────────────────────────────────────────────────────────────┐
│                    PHASE EXECUTION                           │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
                 ┌─────────────┐
                 │ Start Phase │
                 └──────┬──────┘
                        │
                        ▼
              ┌─────────────────┐
              │ Execute Step 1  │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ Save Checkpoint │
              │                 │
              │ {               │
              │   phase: "...", │
              │   completed: [] │
              │ }               │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ Execute Step 2  │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ Save Checkpoint │
              │                 │
              │ {               │
              │   phase: "...", │
              │   completed:    │
              │     ["step1"]   │
              │ }               │
              └────────┬────────┘
                       │
                     ERROR?
                       │
                   ┌───┴───┐
                   │       │
                  YES     NO
                   │       │
                   ▼       │
          ┌────────────┐   │
          │ Checkpoint │   │
          │ Saved      │   │
          │            │   │
          │ User can   │   │
          │ resume     │   │
          └────────────┘   │
                           │
                           ▼
                  ┌────────────────┐
                  │ Phase Complete │
                  │                │
                  │ Clear partial  │
                  │ checkpoints    │
                  └────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    RESUME FLOW                               │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
              ┌─────────────────┐
              │ Load Checkpoint │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ Restore State:  │
              │ • Phase         │
              │ • Completed     │
              │ • Config        │
              │ • Artifacts     │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ Skip completed  │
              │ steps           │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ Continue from   │
              │ next step       │
              └─────────────────┘
```

---

## TodoWrite Integration

```
┌─────────────────────────────────────────────────────────────┐
│                  ORCHESTRATOR START                          │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
              ┌─────────────────┐
              │ TodoWrite({     │
              │   todos: [      │
              │     { phase1,   │
              │       pending },│
              │     { phase2,   │
              │       pending } │
              │   ]             │
              │ })              │
              └────────┬────────┘
                       │
                       │
          ┌────────────┴────────────┐
          │                         │
    USER SEES IN IDE          ORCHESTRATOR USES
          │                         │
          ▼                         ▼
   ┌─────────────┐         ┌────────────────┐
   │ □ Phase 1   │         │ Track current  │
   │ □ Phase 2   │         │ phase          │
   │ □ Phase 3   │         └────────┬───────┘
   └─────────────┘                  │
          │                         │
          │    ┌────────────────────┘
          │    │
          │    ▼
          │  ┌────────────────┐
          │  │ Update Todo:   │
          │  │ phase1 →       │
          │  │ in_progress    │
          │  └────────┬───────┘
          │           │
          ▼           ▼
   ┌─────────────┐  ┌────────────────┐
   │ ⟳ Phase 1   │  │ Execute        │
   │ □ Phase 2   │  │ Phase 1        │
   │ □ Phase 3   │  └────────┬───────┘
   └─────────────┘           │
          │                  │
          │    ┌─────────────┘
          │    │
          │    ▼
          │  ┌────────────────┐
          │  │ Update Todo:   │
          │  │ phase1 →       │
          │  │ completed      │
          │  │ phase2 →       │
          │  │ in_progress    │
          │  └────────┬───────┘
          │           │
          ▼           ▼
   ┌─────────────┐  ┌────────────────┐
   │ ✓ Phase 1   │  │ Execute        │
   │ ⟳ Phase 2   │  │ Phase 2        │
   │ □ Phase 3   │  └────────────────┘
   └─────────────┘
```

---

## Skill Communication

```
┌─────────────────────────────────────────────────────────────┐
│                   MASTER ORCHESTRATOR                        │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        │ Call skill with params
                        │
                        ▼
              ┌─────────────────┐
              │  PHASE SKILL    │
              │                 │
              │  Input:         │
              │  • Config       │
              │  • Context      │
              └────────┬────────┘
                       │
                       │ Execute
                       │
                       ▼
              ┌─────────────────┐
              │  PHASE SKILL    │
              │                 │
              │  Calls utility  │
              │  skills as      │
              │  needed         │
              └────────┬────────┘
                       │
          ┌────────────┼────────────┐
          │            │            │
          ▼            ▼            ▼
    ┌─────────┐  ┌─────────┐  ┌─────────┐
    │Utility 1│  │Utility 2│  │Utility 3│
    └────┬────┘  └────┬────┘  └────┬────┘
         │            │            │
         └────────────┼────────────┘
                      │
                      │ Return results
                      │
                      ▼
              ┌─────────────────┐
              │  PHASE SKILL    │
              │                 │
              │  Output:        │
              │  • Success      │
              │  • Artifacts    │
              │  • Checkpoint   │
              └────────┬────────┘
                       │
                       │ Return to orchestrator
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                   MASTER ORCHESTRATOR                        │
│                                                               │
│  • Save checkpoint                                           │
│  • Update TodoWrite                                          │
│  • Call next skill                                           │
└─────────────────────────────────────────────────────────────┘
```

---

## Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│                         START                                │
│                                                               │
│  User Intent: "Setup new SaaS project"                       │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
              ┌─────────────────────┐
              │ Collect Config      │
              │                     │
              │ • projectName       │
              │ • includeFrontend   │
              │ • authProviders     │
              └──────────┬──────────┘
                         │
                         │ Pass to Phase 1
                         │
                         ▼
┌────────────────────────────────────────────────────────────┐
│                      PHASE 1                                │
│                   Prerequisites                             │
│                                                              │
│  Input: config                                              │
│  Output: environment { node, docker, ports }                │
└──────────────────────┬─────────────────────────────────────┘
                       │
                       │ Checkpoint 1
                       │
                       ▼
              ┌─────────────────┐
              │ .setup-state    │
              │ {               │
              │   config,       │
              │   environment   │
              │ }               │
              └────────┬────────┘
                       │
                       │ Pass to Phase 2
                       │
                       ▼
┌────────────────────────────────────────────────────────────┐
│                      PHASE 2                                │
│                   Backend Setup                             │
│                                                              │
│  Input: config, environment                                 │
│  Output: artifacts { backendPath, backendUrl }             │
└──────────────────────┬─────────────────────────────────────┘
                       │
                       │ Checkpoint 2
                       │
                       ▼
              ┌─────────────────┐
              │ .setup-state    │
              │ {               │
              │   config,       │
              │   environment,  │
              │   artifacts     │
              │ }               │
              └────────┬────────┘
                       │
                       │ Pass to Phase 3
                       │
                       ▼
┌────────────────────────────────────────────────────────────┐
│                      PHASE 3                                │
│                 Database Config                             │
│                                                              │
│  Input: config, artifacts.backendPath                       │
│  Output: artifacts { databaseUrl, tables }                 │
└──────────────────────┬─────────────────────────────────────┘
                       │
                       │ Checkpoint 3
                       │
                       ▼
              ┌─────────────────┐
              │ .setup-state    │
              │ {               │
              │   config,       │
              │   environment,  │
              │   artifacts {   │
              │     backend..., │
              │     database... │
              │   }             │
              │ }               │
              └────────┬────────┘
                       │
                     [etc.]
                       │
                       ▼
┌────────────────────────────────────────────────────────────┐
│                      COMPLETE                               │
│                                                              │
│  Final state:                                               │
│  • config (user choices)                                    │
│  • environment (detected)                                   │
│  • artifacts (all outputs)                                  │
│                                                              │
│  Return to user:                                            │
│  • Backend URL                                              │
│  • Frontend URL                                             │
│  • Test credentials                                         │
│  • Next steps                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## Comparison: Script vs AI

### Shell Script Flow

```
START
  │
  ▼
mkdir backend
  │
  ├─── Error? → EXIT ❌
  │
  ▼
cd backend
  │
  ├─── Error? → EXIT ❌
  │
  ▼
npx apso init
  │
  ├─── Error? → EXIT ❌
  │
  ▼
npm install
  │
  ├─── Error? → EXIT ❌
  │
  ▼
docker-compose up
  │
  ├─── Error? → EXIT ❌
  │
  ▼
apso server
  │
  ├─── Error? → EXIT ❌
  │
  ▼
npm start
  │
  ├─── Error? → EXIT ❌
  │
  ▼
DONE (maybe)
```

### AI Skill Flow

```
START
  │
  ▼
Initialize backend
  │
  ├─── Error?
  │      │
  │      ├─ Known issue? → Auto-fix → Continue
  │      ├─ Retry option? → Try alt → Continue
  │      ├─ Need input? → Ask user → Continue
  │      └─ Can't fix? → Degrade → Continue
  │
  ▼
Save checkpoint
  │
  ▼
Install dependencies
  │
  ├─── Error?
  │      │
  │      └─ [same handling]
  │
  ▼
Save checkpoint
  │
  ▼
Setup database
  │
  ├─── Error?
  │      │
  │      └─ [same handling]
  │
  ▼
Save checkpoint
  │
  ▼
DONE ✓
(or resume from any checkpoint)
```

---

## Progressive Error Escalation

```
                    ERROR
                      │
                      ▼
            ┌──────────────────┐
            │ Can I fix this   │
            │ automatically?   │
            └─────────┬────────┘
                      │
                  ┌───┴───┐
                  │       │
                 YES     NO
                  │       │
                  ▼       │
         ┌────────────┐   │
         │ LEVEL 1    │   │
         │            │   │
         │ Auto-Fix   │   │
         │            │   │
         │ • Detect   │   │
         │ • Apply    │   │
         │ • Retry    │   │
         └─────┬──────┘   │
               │          │
            SUCCESS?      │
               │          │
           ┌───┴───┐      │
           │       │      │
          YES     NO      │
           │       │      │
           ▼       └──────┤
         CONTINUE         │
                          ▼
                ┌──────────────────┐
                │ Do I have an     │
                │ alternative?     │
                └─────────┬────────┘
                          │
                      ┌───┴───┐
                      │       │
                     YES     NO
                      │       │
                      ▼       │
             ┌────────────┐   │
             │ LEVEL 2    │   │
             │            │   │
             │ Retry Alt  │   │
             │            │   │
             │ • Diff     │   │
             │   approach │   │
             │ • Retry    │   │
             └─────┬──────┘   │
                   │          │
                SUCCESS?      │
                   │          │
               ┌───┴───┐      │
               │       │      │
              YES     NO      │
               │       │      │
               ▼       └──────┤
             CONTINUE         │
                              ▼
                    ┌──────────────────┐
                    │ Can user help?   │
                    └─────────┬────────┘
                              │
                          ┌───┴───┐
                          │       │
                         YES     NO
                          │       │
                          ▼       │
                 ┌────────────┐   │
                 │ LEVEL 3    │   │
                 │            │   │
                 │ User Input │   │
                 │            │   │
                 │ • Explain  │   │
                 │ • Options  │   │
                 │ • Wait     │   │
                 └─────┬──────┘   │
                       │          │
                     USER         │
                    PROVIDES      │
                    SOLUTION      │
                       │          │
                       ▼          │
                    CONTINUE      │
                                  │
                                  ▼
                        ┌──────────────────┐
                        │ Can we skip?     │
                        └─────────┬────────┘
                                  │
                              ┌───┴───┐
                              │       │
                             YES     NO
                              │       │
                              ▼       │
                     ┌────────────┐   │
                     │ LEVEL 4    │   │
                     │            │   │
                     │ Degrade    │   │
                     │            │   │
                     │ • Skip     │   │
                     │ • Log      │   │
                     │ • Continue │   │
                     └─────┬──────┘   │
                           │          │
                           ▼          │
                        CONTINUE      │
                      (degraded)      │
                                      │
                                      ▼
                                   FAIL
                                (save checkpoint)
```

---

## State Transitions

```
┌──────────┐
│  FRESH   │ Initial state, no checkpoint
└─────┬────┘
      │
      │ Start setup
      │
      ▼
┌──────────┐
│ RUNNING  │ Actively executing phases
└─────┬────┘
      │
      ├──────────┐
      │          │
    ERROR     SUCCESS
      │          │
      ▼          ▼
┌──────────┐  ┌──────────┐
│ PAUSED   │  │CHECKPOINT│ Phase completed
└─────┬────┘  └─────┬────┘
      │             │
      │ Resume      │ Next phase
      │             │
      └──────┬──────┘
             │
             ▼
       ┌──────────┐
       │ RUNNING  │ Continue
       └─────┬────┘
             │
           [repeat]
             │
             ▼
       ┌──────────┐
       │ COMPLETE │ All phases done
       └──────────┘
```

---

## Skill Hierarchy

```
                 apso-betterauth-setup
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
   setup-backend  setup-frontend  configure-database
        │                │                │
        │                │                │
    ┌───┴───┐        ┌───┴───┐        ┌───┴───┐
    │       │        │       │        │       │
    ▼       ▼        ▼       ▼        ▼       ▼
  verify  fix    verify  fix      verify  fix
  -setup  -issues -setup -issues   -setup -issues


Legend:
  ┌─────────────┐
  │ Orchestrator│ Coordinates other skills
  └─────────────┘

  ┌─────────────┐
  │ Phase Skill │ Implements one setup phase
  └─────────────┘

  ┌─────────────┐
  │Utility Skill│ Reusable helper
  └─────────────┘
```

---

These diagrams show the complete architecture. For implementation details, see:

- [Architecture Document](./ai-orchestrated-setup-system.md)
- [Implementation Guide](./ai-setup-implementation-guide.md)
- [Quick Reference](./QUICK_REFERENCE.md)

---

**Last Updated:** 2025-01-18
**Version:** 1.0
