# Template Selection Wizard

Answer these questions to find the right template for your project.

---

## Quick Questions

### 1. Are you charging customers money?

**Yes, we have pricing plans**
→ Go to Question 2

**No, free product or pre-revenue**
→ **Use Minimal Template**

---

### 2. Do you need subscription billing?

**Yes, monthly/annual subscriptions**
→ Go to Question 3

**No, one-time payments or custom billing**
→ **Use Minimal Template** (add custom billing entities)

---

### 3. Do customers work in teams?

**Yes, multiple users per account**
→ Go to Question 4

**No, single-user accounts only**
→ **Use Minimal Template** (remove AccountUser if truly single-user)

---

### 4. Do you need audit logging?

**Yes, for compliance (SOC2, GDPR, HIPAA)**
→ **Use Complete Template**

**No, not required**
→ Go to Question 5

---

### 5. Will you offer API access?

**Yes, customers need programmatic access**
→ **Use Complete Template**

**No, web/mobile app only**
→ Go to Question 6

---

### 6. Are you launching soon?

**Yes, launching in <3 months**
→ **Use Complete Template** (faster to market)

**No, building MVP or exploring**
→ **Use Minimal Template** (iterate faster)

---

## Decision Tree

```
Start
  │
  ├─ Charging customers?
  │   ├─ NO  → Minimal
  │   └─ YES
  │       │
  │       ├─ Subscription billing?
  │       │   ├─ NO  → Minimal
  │       │   └─ YES
  │       │       │
  │       │       ├─ Team accounts?
  │       │       │   ├─ NO  → Minimal
  │       │       │   └─ YES
  │       │       │       │
  │       │       │       ├─ Need compliance?
  │       │       │       │   ├─ YES → Complete
  │       │       │       │   └─ NO
  │       │       │       │       │
  │       │       │       │       ├─ API access?
  │       │       │       │       │   ├─ YES → Complete
  │       │       │       │       │   └─ NO
  │       │       │       │       │       │
  │       │       │       │       │       ├─ Launch <3mo?
  │       │       │       │       │       │   ├─ YES → Complete
  │       │       │       │       │       │   └─ NO  → Minimal
```

---

## Use Case Examples

### Minimal Template Projects

**1. Domain-Specific SaaS**
- Construction management software
- Legal practice management
- Restaurant reservation system
- Custom CRM for niche industry

**Why Minimal?** Unique data models don't fit standard SaaS patterns. Start simple and add custom entities.

---

**2. Pre-Revenue MVPs**
- Validating product-market fit
- Beta testing with early users
- Building initial traction
- Exploring different features

**Why Minimal?** You'll iterate quickly. Don't over-engineer before validating the idea.

---

**3. Internal Tools**
- Company-internal dashboards
- Team management tools
- Data analysis platforms
- Admin panels

**Why Minimal?** No billing, no API, no compliance requirements. Keep it simple.

---

**4. Educational Projects**
- Learning full-stack development
- Teaching SaaS architecture
- Building portfolio projects
- Code tutorials

**Why Minimal?** Easier to understand, less complexity, focus on core concepts.

---

### Complete Template Projects

**1. B2B SaaS Platforms**
- Project management (Asana, Monday)
- CRM systems (Salesforce, HubSpot)
- Analytics platforms (Mixpanel, Amplitude)
- Team collaboration (Slack, Notion)

**Why Complete?** Standard SaaS features (billing, teams, API) are table stakes.

---

**2. API-First Products**
- Developer tools
- Integration platforms
- Data APIs
- Automation services (Zapier, n8n)

**Why Complete?** API key management is critical, audit logging tracks usage.

---

**3. Compliance-Required Apps**
- Healthcare (HIPAA)
- Finance (SOC2, PCI)
- Legal (data retention)
- Enterprise (security audits)

**Why Complete?** Audit logging and security features are mandatory.

---

**4. Enterprise SaaS**
- Selling to large companies
- Multiple teams per account
- SSO requirements
- Custom contracts

**Why Complete?** Enterprise customers expect advanced features out of the box.

---

## Feature Checklist

Check boxes for features you need:

### Authentication
- [ ] Email/password login (Both templates)
- [ ] OAuth (Google, GitHub, etc) (Both templates)
- [ ] Email verification (Both templates)
- [ ] Password reset (Both templates)

### Multi-Tenancy
- [ ] Organizations/workspaces (Both templates)
- [ ] User invitations (Complete only)
- [ ] Role-based access (Basic: Minimal, Advanced: Complete)
- [ ] Multiple orgs per user (Both templates)

### Billing
- [ ] Subscription plans (Complete only)
- [ ] Invoice history (Complete only)
- [ ] Stripe integration (Complete only)
- [ ] Custom billing (Add to Minimal)

### API Access
- [ ] API keys (Complete only)
- [ ] Webhooks (Add to either)
- [ ] Rate limiting (Add to either)
- [ ] API documentation (Add to either)

### Security & Compliance
- [ ] Audit logging (Complete only)
- [ ] IP tracking (Session: Both, Full: Complete)
- [ ] Soft deletes (Complete only)
- [ ] Data export (Add to either)

**If you checked 3+ "Complete only" items → Use Complete Template**
**Otherwise → Use Minimal Template**

---

## By Team Size

### Solo Developer
**Minimal Template**
- Faster to learn and customize
- Less code to maintain
- Focus on core features

### Small Team (2-5 people)
**Minimal or Complete**
- Minimal: If pre-revenue or custom domain
- Complete: If launching with billing

### Growing Startup (5-20 people)
**Complete Template**
- Need all features eventually
- Team can maintain complexity
- Faster time to market

### Enterprise Team (20+ people)
**Complete Template**
- Compliance is critical
- Need audit trails
- Multiple team members need context

---

## By Timeline

### Launching in 1-3 months
**Complete Template**
- Get standard features faster
- Less custom code to write
- Focus on business logic

### Launching in 3-6 months
**Either template**
- Time to customize either option
- Minimal: If heavily customizing
- Complete: If standard SaaS

### Launching in 6+ months
**Minimal Template**
- More time to iterate
- Build exactly what you need
- Learn as you grow

---

## By Budget

### Bootstrap (<$10k budget)
**Minimal Template**
- Lower hosting costs
- Less complexity = faster dev
- Add features as revenue grows

### Seed Stage ($10k-100k budget)
**Complete Template**
- Move faster with team
- Standard features expected
- Focus on differentiation

### Series A+ (>$100k budget)
**Complete Template**
- Enterprise features required
- Compliance is mandatory
- Team can handle complexity

---

## Migration Complexity

### Minimal → Complete
**Effort:** Medium (1-2 weeks)
**Steps:**
1. Copy missing entities to .apsorc
2. Generate migrations
3. Update API logic
4. Add Stripe webhooks
5. Test thoroughly

**When to migrate:**
- You start charging customers
- Investors require compliance
- Customers request API access

---

### Complete → Minimal
**Effort:** High (2-4 weeks)
**Not recommended**

You'd need to:
1. Drop entities (lose data)
2. Rewrite billing logic
3. Remove dependencies
4. Migrate existing data

**Better approach:** Just ignore unused entities in Complete template.

---

## Final Recommendations

### Start with Minimal if:
- Unsure what you need
- Pre-revenue
- Unique data model
- Learning/experimenting
- Solo developer
- <6 month timeline

### Start with Complete if:
- Launching with billing
- B2B SaaS product
- Team of 3+ developers
- Need compliance
- API-first product
- <3 month timeline

### Still unsure?
**Default to Minimal.**

It's easier to add entities later than remove them. You can always upgrade when you need specific features.

---

## Quick Copy-Paste Commands

### Minimal Template
```bash
cp apsorc-templates/minimal-saas-betterauth.json .apsorc
npx apso generate
npm run dev
```

### Complete Template
```bash
cp apsorc-templates/complete-saas-betterauth.json .apsorc
npx apso generate
npm run dev
```

### Both Templates (compare locally)
```bash
# Preview minimal
cat apsorc-templates/minimal-saas-betterauth.json | jq '.entities[].name'

# Preview complete
cat apsorc-templates/complete-saas-betterauth.json | jq '.entities[].name'

# Compare sizes
ls -lh apsorc-templates/*.json
```

---

## Get Help

Still not sure which template to use?

1. **Check examples:** See `README.md` for detailed use cases
2. **Compare visually:** See `ENTITY-DIAGRAMS.md` for ERDs
3. **Ask the community:**
   - Discord: https://discord.gg/apso
   - GitHub Discussions: https://github.com/apsolib/apso/discussions

4. **When in doubt:** Start with Minimal, upgrade later if needed.

---

## Template Maintenance

Both templates are:
- Production-tested
- Actively maintained
- Compatible with latest Apso
- BetterAuth schema compliant

**Last updated:** November 2025
**Apso version:** 1.0.0+
**BetterAuth version:** 1.0.0+
