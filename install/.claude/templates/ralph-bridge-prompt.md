# DevEnv to Ralph Quick Reference

For full export functionality, use the `/ralph-export` command.

---

## Artifact Mapping

| DevEnv Output | Ralph Input | Key Content |
|---------------|-------------|-------------|
| Discovery output | `PROMPT.md` | Project overview, phases, tech stack |
| Gherkin scenarios | `@fix_plan.md` | Tasks with VERIFY items, phase gates |
| Schema design | `specs/` | Entity definitions, relationships |
| Tech stack | `@AGENT.md` | Build commands, file locations |

---

## Critical Ralph Requirements

### PROMPT.md Must Have:
- RALPH_STATUS block format
- EXIT_SIGNAL rules
- @fix_plan.md update instructions
- Error recovery rules
- BDD verification approach

### @fix_plan.md Must Have:
- Instructions header (error handling, stuck detection)
- VERIFY items under each task
- Phase gates between phases
- `[x] ✓` format for completed tasks
- `[~] BLOCKED:` format for stuck tasks

### @AGENT.md Must Have:
- Project init commands
- Dev/build/test commands
- File location map
- Git workflow requirements
- Feature completion checklist

---

## Run the Export

```
/ralph-export
```

This will generate all Ralph artifacts from your DevEnv discovery and scenarios.
