# Release Notes & Summaries

This folder contains release notes and summaries documenting major updates to the Specification-Driven Development system.

## Contents

### DISCOVERY-INTERVIEWER-SUMMARY.md
**Date**: 2025-11-13
**Version**: v1.1
**Summary**: Introduction of the discovery-interviewer skill as Phase 0 of the methodology. Explains the 90-minute structured interview process, dual persona (interviewer + PM expert), and integration with other skills.

### TESTING-UPDATE-SUMMARY.md
**Date**: 2025-11-13
**Summary**: Addition of comprehensive BDD/Gherkin testing approach. Documents the test-generator skill and three-layer testing strategy (API 40%, UI 45%, E2E 15%).

### SKILLS-TRANSFORMATION-SUMMARY.md
**Date**: 2025-11-13
**Summary**: Transformation of the devenv system from standalone instructions to modular Claude skills. Documents the architecture, skill structure, and orchestration approach.

## Version History

- **v1.1** (Current) - Discovery-first approach
  - Added discovery-interviewer skill
  - Added test-generator skill
  - Updated orchestrator to call discovery as Phase 0
  - Flow: Discovery → Scenarios → Schema → Brief → Roadmap

- **v1.0** - Initial skills system
  - saas-project-orchestrator
  - product-brief-writer
  - schema-architect
  - backend-bootstrapper
  - feature-builder

## Purpose

These documents serve as:
- Historical record of system evolution
- Detailed explanations of major features
- Reference for understanding design decisions
- Onboarding material for new contributors

## Related Documentation

- `../../SPECIFICATION-DRIVEN-GUIDE.md` - Current getting started guide
- `../../METHODOLOGY.md` - Complete methodology documentation
- `../../.claude/skills/` - Actual skill implementations
