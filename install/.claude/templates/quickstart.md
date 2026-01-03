# Quickstart Validation: [PROJECT_NAME]

> Key scenarios to validate before proceeding to implementation.
> These represent the critical paths that must work for the product to be viable.

---

## Critical Path Scenarios

### 1. User Onboarding Flow

**Goal:** New user can sign up and access the product

```gherkin
Scenario: Complete user onboarding
  Given I am a new visitor
  When I click "Get Started"
  And I enter my email and password
  And I verify my email
  And I create an organization
  Then I should see the main dashboard
  And I should be ready to use the product
```

**Validation Steps:**
1. [ ] Navigate to signup page
2. [ ] Fill registration form
3. [ ] Check email for verification
4. [ ] Complete organization setup
5. [ ] Confirm dashboard access

**Success Criteria:**
- Complete flow in < 2 minutes
- No errors or confusing steps
- Clear next action visible

---

### 2. Core Value Demonstration

**Goal:** User experiences the primary value proposition

```gherkin
Scenario: [PRIMARY_WORKFLOW]
  Given I am logged in as a new user
  When I [PRIMARY_ACTION]
  Then I should [EXPERIENCE_VALUE]
  And I should understand why this product is useful
```

**Validation Steps:**
1. [ ] [STEP_1]
2. [ ] [STEP_2]
3. [ ] [STEP_3]

**Success Criteria:**
- Value is obvious within 30 seconds
- No tutorial needed for basic action
- Result matches expectation

---

### 3. Data Persistence

**Goal:** Data is saved correctly and retrievable

```gherkin
Scenario: Data persists across sessions
  Given I have created [ENTITY]
  When I log out
  And I log back in
  Then I should see my [ENTITY]
  And all data should be intact
```

**Validation Steps:**
1. [ ] Create test data
2. [ ] Log out completely
3. [ ] Log back in
4. [ ] Verify data presence

**Success Criteria:**
- All data visible after logout/login
- No data loss or corruption
- Organization isolation working

---

### 4. Error Recovery

**Goal:** System handles errors gracefully

```gherkin
Scenario: Recover from network error
  Given I am filling out a form
  When the network connection is lost
  Then I should see an error message
  And my data should not be lost
  And I should be able to retry
```

**Validation Steps:**
1. [ ] Start an action
2. [ ] Simulate network failure
3. [ ] Verify error message
4. [ ] Confirm data preserved
5. [ ] Retry successfully

**Success Criteria:**
- User-friendly error message
- No data loss
- Clear recovery path

---

### 5. Multi-Tenancy Isolation

**Goal:** Organizations cannot see each other's data

```gherkin
Scenario: Organization data isolation
  Given User A belongs to Organization A
  And User B belongs to Organization B
  When User A creates [ENTITY]
  Then User B should not see it
  And User A should see it
```

**Validation Steps:**
1. [ ] Create two organizations
2. [ ] Create data in Org A
3. [ ] Switch to Org B
4. [ ] Verify data not visible
5. [ ] Switch back to Org A
6. [ ] Verify data visible

**Success Criteria:**
- Complete data isolation
- No cross-tenant leakage
- Switching works correctly

---

## Validation Checklist

### Before Phase 1 Complete

- [ ] Signup flow works end-to-end
- [ ] Login/logout works
- [ ] Organization creation works
- [ ] Basic navigation works
- [ ] Error messages are user-friendly

### Before Phase 2 Complete

- [ ] Core CRUD operations work
- [ ] Data persists correctly
- [ ] Multi-tenancy isolation verified
- [ ] Basic search/filter works

### Before Phase 3 Complete

- [ ] All workflows are complete
- [ ] Integrations are functional
- [ ] Notifications are delivered
- [ ] Team features work

### Before Launch

- [ ] All critical paths validated
- [ ] Performance targets met
- [ ] Security audit passed
- [ ] All P1 bugs fixed

---

## Quick Smoke Test

Run these commands to quickly validate the system:

```bash
# 1. Check backend health
curl http://localhost:3001/health

# 2. Check frontend loads
curl http://localhost:3000

# 3. Test authentication
curl -X POST http://localhost:3001/api/auth/signin \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"Test123!"}'

# 4. Test protected endpoint (with token)
curl http://localhost:3001/api/[entity] \
  -H "Authorization: Bearer [TOKEN]"
```

---

## Known Issues

| Issue | Severity | Workaround | Status |
|-------|----------|------------|--------|
| [ISSUE_1] | [High/Med/Low] | [WORKAROUND] | [Open/Fixed] |

---

**Last Validated:** [DATE]
**Validated By:** [NAME]
