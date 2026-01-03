# Project Constitution

> Immutable principles that govern all development in this project.
> These rules are enforced by the Mavric toolchain and should not be violated.

---

## Article I: Discovery-First Principle

**Every feature begins with validated requirements.**

- No implementation code is written before discovery is complete
- All workflows must be documented step-by-step
- Edge cases must be identified before coding begins
- Confidence level must be 8/10 or higher before proceeding

## Article II: Test-First Imperative

**Tests are written before implementation code.**

- Gherkin scenarios define acceptance criteria
- Scenarios must cover happy paths, error cases, and edge cases
- Implementation is considered complete when all scenarios pass
- Test coverage target: 80% minimum

## Article III: Multi-Tenancy by Default

**All data is organization-scoped.**

- Organization entity is the tenant root
- All entities include `organizationId` foreign key
- Row-level security enforced at database and API layers
- Cross-tenant data access is prohibited

## Article IV: Type Safety Mandate

**TypeScript everywhere, no exceptions.**

- Strict mode enabled (`strict: true`)
- No `any` types without explicit justification
- API contracts defined with proper types
- Database entities fully typed

## Article V: Security by Default

**All endpoints are protected unless explicitly public.**

- Authentication required by default
- Authorization checked at every endpoint
- Input validation on all user data
- Secrets never committed to repository

## Article VI: Simplicity Principle

**Prefer simple solutions over clever ones.**

- Maximum 3 abstractions for any feature
- Use frameworks directly, avoid unnecessary wrappers
- No premature optimization
- Code should be readable without comments

## Article VII: Documentation as Code

**Documentation is maintained alongside code.**

- Discovery documents are living artifacts
- Gherkin scenarios serve as documentation
- API contracts are auto-generated
- Architecture decisions are recorded

## Article VIII: Progressive Delivery

**Ship working software incrementally.**

- Each phase produces deployable software
- Features are validated with real users
- Feedback loops are short (weekly)
- MVP scope is protected from creep

## Article IX: Integration-First Testing

**Test against real systems when possible.**

- Prefer real databases over mocks in tests
- Use actual service instances when available
- Contract tests before implementation
- E2E tests validate complete workflows

---

## Enforcement

These principles are enforced through:

1. **Skill prompts** - Each skill checks constitutional compliance
2. **Verification command** - `/verify` checks artifact consistency
3. **Quality gates** - Orchestrator requires approval at each phase
4. **Code review** - AI validates against constitution during review

## Amendments

This constitution may be amended with explicit user approval:

1. Document the proposed change
2. Explain the rationale
3. Assess impact on existing code
4. Update all affected skills and templates

---

**Project:** [PROJECT_NAME]
**Created:** [DATE]
**Last Updated:** [DATE]
