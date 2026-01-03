# Verification Report: [PROJECT_NAME]

**Generated:** [DATE]
**Status:** [Pass / Partial / Fail]
**Confidence Score:** [X]/100

---

## Executive Summary

[One paragraph summarizing the verification results, key gaps, and recommended actions]

---

## Artifact Inventory

| Artifact | Location | Status | Last Updated |
|----------|----------|--------|--------------|
| Discovery Document | `docs/discovery/discovery-notes.md` | [Found/Missing] | [DATE] |
| Discovery Summary | `docs/discovery/discovery-summary.md` | [Found/Missing] | [DATE] |
| Gherkin Scenarios | `docs/scenarios/` | [X files] | [DATE] |
| Schema Definition | `backend/.apsorc` | [Found/Missing] | [DATE] |
| Technical Plan | `docs/plans/technical-plan.md` | [Found/Missing] | [DATE] |
| Roadmap | `docs/plans/roadmap.md` | [Found/Missing] | [DATE] |
| Constitution | `.claude/constitution.md` | [Found/Missing] | [DATE] |

---

## Coverage Analysis

### 1. Discovery → Scenarios

**Workflows Documented:** [X]
**Scenarios Generated:** [Y]
**Coverage:** [Y/X × expected_per_workflow]%

| Workflow | Expected Scenarios | Actual | Gap |
|----------|-------------------|--------|-----|
| [WORKFLOW_1] | [X] | [Y] | [DIFF] |
| [WORKFLOW_2] | [X] | [Y] | [DIFF] |
| [WORKFLOW_3] | [X] | [Y] | [DIFF] |

**Status:** [Complete / Partial / Missing]

**Gaps Identified:**
- [ ] [WORKFLOW] missing [TYPE] scenarios
- [ ] [WORKFLOW] missing edge cases for [CONDITION]

---

### 2. Scenarios → Schema

**Entities in Scenarios:** [X]
**Entities in Schema:** [Y]
**Coverage:** [Y/X]%

| Entity | In Scenarios | In Schema | Match |
|--------|--------------|-----------|-------|
| [ENTITY_1] | Yes | Yes | ✅ |
| [ENTITY_2] | Yes | No | ❌ |
| [ENTITY_3] | No | Yes | ⚠️ |

**Field Coverage:**

| Entity | Fields in Scenarios | Fields in Schema | Missing |
|--------|---------------------|------------------|---------|
| [ENTITY_1] | [X] | [Y] | [LIST] |

**Status:** [Complete / Partial / Missing]

**Gaps Identified:**
- [ ] [ENTITY] not defined in schema
- [ ] [ENTITY].[FIELD] missing from schema
- [ ] Relationship [REL] not defined

---

### 3. Schema → API

**Entities in Schema:** [X]
**Entities with Endpoints:** [Y]
**Coverage:** [Y/X]%

| Entity | CRUD Endpoints | Validation | Authorization |
|--------|---------------|------------|---------------|
| [ENTITY_1] | C✅ R✅ U✅ D✅ | ✅ | ✅ |
| [ENTITY_2] | C✅ R✅ U❌ D❌ | ⚠️ | ✅ |

**Status:** [Complete / Partial / Missing]

**Gaps Identified:**
- [ ] [ENTITY] missing [OPERATION] endpoint
- [ ] [ENTITY] missing validation for [FIELD]

---

### 4. Test Execution Status

**Total Scenarios:** [X]
**Passing:** [Y]
**Failing:** [Z]
**Skipped:** [W]

| Layer | Total | Pass | Fail | Skip | Coverage |
|-------|-------|------|------|------|----------|
| API | [X] | [Y] | [Z] | [W] | [%] |
| UI | [X] | [Y] | [Z] | [W] | [%] |
| E2E | [X] | [Y] | [Z] | [W] | [%] |

**Failing Scenarios:**
1. `[FEATURE_FILE]:[LINE]` - [SCENARIO_NAME]
   - Error: [ERROR_MESSAGE]
2. `[FEATURE_FILE]:[LINE]` - [SCENARIO_NAME]
   - Error: [ERROR_MESSAGE]

---

### 5. Constitutional Compliance

| Article | Compliance | Notes |
|---------|------------|-------|
| I. Discovery-First | [Yes/No/Partial] | [NOTES] |
| II. Test-First | [Yes/No/Partial] | [NOTES] |
| III. Multi-Tenancy | [Yes/No/Partial] | [NOTES] |
| IV. Type Safety | [Yes/No/Partial] | [NOTES] |
| V. Security by Default | [Yes/No/Partial] | [NOTES] |
| VI. Simplicity | [Yes/No/Partial] | [NOTES] |
| VII. Documentation | [Yes/No/Partial] | [NOTES] |
| VIII. Progressive Delivery | [Yes/No/Partial] | [NOTES] |
| IX. Integration Testing | [Yes/No/Partial] | [NOTES] |

---

## Quality Metrics

### Code Quality

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| TypeScript Strict | Enabled | [Yes/No] | [✅/❌] |
| ESLint Errors | 0 | [X] | [✅/❌] |
| No `any` Types | Yes | [X found] | [✅/❌] |

### Test Quality

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Overall Coverage | 80% | [X]% | [✅/❌] |
| API Coverage | 40% | [X]% | [✅/❌] |
| UI Coverage | 45% | [X]% | [✅/❌] |
| E2E Coverage | 15% | [X]% | [✅/❌] |

### Documentation Quality

| Document | Complete | Accurate | Current |
|----------|----------|----------|---------|
| Discovery | [Yes/No] | [Yes/No] | [Yes/No] |
| Scenarios | [Yes/No] | [Yes/No] | [Yes/No] |
| Technical Plan | [Yes/No] | [Yes/No] | [Yes/No] |
| API Docs | [Yes/No] | [Yes/No] | [Yes/No] |

---

## Recommended Actions

### Critical (Must Fix)

1. **[ACTION_1]**
   - Issue: [DESCRIPTION]
   - Impact: [IMPACT]
   - Effort: [Low/Medium/High]

2. **[ACTION_2]**
   - Issue: [DESCRIPTION]
   - Impact: [IMPACT]
   - Effort: [Low/Medium/High]

### Important (Should Fix)

3. **[ACTION_3]**
   - Issue: [DESCRIPTION]
   - Impact: [IMPACT]
   - Effort: [Low/Medium/High]

### Nice to Have

4. **[ACTION_4]**
   - Issue: [DESCRIPTION]
   - Impact: [IMPACT]
   - Effort: [Low/Medium/High]

---

## Confidence Score Breakdown

| Category | Weight | Score | Weighted |
|----------|--------|-------|----------|
| Discovery Coverage | 20% | [X]/100 | [Y] |
| Scenario Coverage | 25% | [X]/100 | [Y] |
| Schema Alignment | 15% | [X]/100 | [Y] |
| Test Passing | 25% | [X]/100 | [Y] |
| Constitutional Compliance | 15% | [X]/100 | [Y] |
| **Total** | **100%** | - | **[Z]/100** |

---

## Next Steps

Based on this verification:

1. [ ] [IMMEDIATE_ACTION]
2. [ ] [SHORT_TERM_ACTION]
3. [ ] [MEDIUM_TERM_ACTION]

---

## Verification History

| Date | Score | Major Changes |
|------|-------|---------------|
| [DATE] | [X]/100 | Initial verification |
| [DATE] | [X]/100 | [CHANGES] |

---

**Verified By:** Claude (Verification System)
**Review Required By:** [USER]
