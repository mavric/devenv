# SaaS Feature Catalog

> A comprehensive reference guide for defining SaaS product features across domains

## Purpose

This catalog provides a structured taxonomy of SaaS features organized into:
- **Common Features**: Core capabilities that span all SaaS domains
- **Vertical-Specific Features**: Industry-specific functionality
- **Tiered Complexity**: Basic, Intermediate, and Advanced implementations

Use this catalog as context when defining product requirements, planning roadmaps, or scoping development efforts.

---

## Common SaaS Features (Tiered)

These features are foundational to most SaaS products, organized by complexity level.

### 1. Authentication & Authorization

#### Basic
**Description**: Essential user authentication
**Features**:
- Email/password authentication
- Basic session management
- Password reset functionality
- Role-based access control (RBAC) - simple roles

**Examples**: Custom auth with bcrypt, JWT tokens, Passport.js

#### Intermediate
**Description**: Enhanced authentication with third-party providers
**Features**:
- OAuth 2.0 implementation
- Social login (Google, GitHub, Facebook)
- Two-factor authentication (2FA)
- API key management
- Advanced RBAC with granular permissions

**Examples**: Auth0, Firebase Auth, Clerk, Magic, Stytch

#### Advanced
**Description**: Enterprise-grade identity management
**Features**:
- Single Sign-On (SSO)
- SAML 2.0 integration
- LDAP/Active Directory integration
- Multi-factor authentication (MFA) with various methods
- Identity provider integration
- Passwordless authentication
- Adaptive authentication

**Examples**: Okta, Auth0 Enterprise, WorkOS, Azure AD

---

### 2. User Profiles & Management

#### Basic
**Description**: Basic user data management
**Features**:
- User profile creation and viewing
- Basic profile editing
- User listing

**Examples**: Django user model, custom user tables

#### Intermediate
**Description**: Enhanced user management with customization
**Features**:
- Custom profile fields
- Avatar/image uploads
- User preferences and settings
- User groups/teams
- Activity logs

**Examples**: Userpilot, ProfilePress

#### Advanced
**Description**: Enterprise user management
**Features**:
- User onboarding flows
- Progressive profiling
- User segmentation
- Behavioral tracking
- User lifecycle management
- Bulk user operations

**Examples**: Auth0 User Management, Frontegg

---

### 3. Data Storage & Retrieval

#### Basic
**Description**: Essential data persistence
**Features**:
- Relational database (PostgreSQL, MySQL)
- Basic CRUD operations
- Simple queries
- File system storage

**Examples**: PostgreSQL, MySQL, SQLite

#### Intermediate
**Description**: Scalable storage solutions
**Features**:
- Cloud object storage
- NoSQL databases
- CDN integration for assets
- Database indexing and optimization
- Read replicas

**Examples**: AWS S3, MongoDB, Redis, CloudFront

#### Advanced
**Description**: Distributed and high-performance storage
**Features**:
- Multi-region storage
- Data sharding
- Caching layers (Redis, Memcached)
- Data lake architecture
- Hot/cold storage tiers
- Real-time data replication

**Examples**: AWS S3 + CloudFront, Azure Blob, Google Cloud Storage, DynamoDB

---

### 4. Search & Filtering

#### Basic
**Description**: Simple search capabilities
**Features**:
- Text-based search (SQL LIKE queries)
- Basic filtering (dropdowns, checkboxes)
- Sorting (ASC/DESC)
- Pagination

**Examples**: SQL queries, DataTables

#### Intermediate
**Description**: Enhanced search with full-text capabilities
**Features**:
- Full-text search
- Faceted search/filtering
- Search suggestions
- Multi-field search
- Search result highlighting

**Examples**: PostgreSQL full-text, Elasticsearch, Meilisearch

#### Advanced
**Description**: AI-powered and distributed search
**Features**:
- Semantic search
- Typo tolerance
- Search analytics
- Personalized results
- Vector search
- Multi-language search
- Distributed search clusters

**Examples**: Algolia, Elasticsearch Enterprise, Typesense

---

### 5. Notifications

#### Basic
**Description**: Essential notification delivery
**Features**:
- Email notifications (transactional)
- In-app notifications
- Basic notification preferences

**Examples**: Nodemailer, SendGrid, simple in-app alerts

#### Intermediate
**Description**: Multi-channel notifications
**Features**:
- SMS notifications
- Push notifications (web and mobile)
- Notification templates
- Delivery scheduling
- Notification grouping
- Read/unread status

**Examples**: OneSignal, Firebase Cloud Messaging, Twilio

#### Advanced
**Description**: Intelligent notification orchestration
**Features**:
- Multi-channel orchestration
- Notification preferences center
- A/B testing for notifications
- Delivery rate optimization
- Smart timing/batching
- Notification analytics
- Channel fallback strategies

**Examples**: Courier, Customer.io, Airship

---

### 6. Messaging & Communication

#### Basic
**Description**: Simple messaging functionality
**Features**:
- Basic chat functionality
- One-to-one messaging
- Message history
- Simple presence indicators

**Examples**: Socket.IO, custom WebSocket implementation

#### Intermediate
**Description**: Feature-rich messaging
**Features**:
- Group/channel messaging
- File attachments
- Message threading
- Typing indicators
- Read receipts
- Message reactions

**Examples**: Stream Chat, Sendbird, PubNub

#### Advanced
**Description**: Enterprise communication platform
**Features**:
- Video/audio calls
- Screen sharing
- Message encryption (E2E)
- Moderation tools
- Advanced search in messages
- Message translation
- Bots and automation

**Examples**: Twilio, Discord, Slack

---

### 7. Email Integration

#### Basic
**Description**: Basic email sending
**Features**:
- Transactional emails
- Simple templates
- Basic deliverability

**Examples**: Nodemailer, SMTP

#### Intermediate
**Description**: Professional email capabilities
**Features**:
- HTML email templates
- Email analytics (opens, clicks)
- Bounce handling
- Unsubscribe management
- Email scheduling
- Attachment handling

**Examples**: SendGrid, Mailgun, Postmark

#### Advanced
**Description**: Enterprise email infrastructure
**Features**:
- Advanced deliverability optimization
- IP warming
- Domain reputation management
- A/B testing
- Dynamic content
- Email API with webhooks
- Dedicated IP addresses

**Examples**: SendGrid Enterprise, Mailgun, Amazon SES

---

### 8. Dashboards & Reporting

#### Basic
**Description**: Basic data visualization
**Features**:
- Simple charts (line, bar, pie)
- Basic metrics display
- Static reports
- Data tables

**Examples**: Chart.js, custom tables

#### Intermediate
**Description**: Interactive dashboards
**Features**:
- Interactive charts
- Custom date ranges
- Export to PDF/Excel
- Dashboard sharing
- Scheduled reports
- Multiple dashboard views

**Examples**: Google Data Studio, Metabase, ReCharts

#### Advanced
**Description**: Enterprise analytics and BI
**Features**:
- Custom report builder
- Drag-and-drop dashboard creation
- Real-time data updates
- Advanced visualizations
- Embedded analytics
- Role-based dashboard access
- Data source connections

**Examples**: Tableau, Power BI, Looker, Sisense

---

### 9. API

#### Basic
**Description**: Basic API functionality
**Features**:
- RESTful API endpoints
- JSON responses
- Basic authentication (API keys)
- CRUD operations
- Basic error handling

**Examples**: Express.js, FastAPI, Django REST

#### Intermediate
**Description**: Professional API design
**Features**:
- API versioning
- Rate limiting
- Request validation
- API documentation (Swagger/OpenAPI)
- Webhooks
- Pagination
- Filtering and sorting

**Examples**: OpenAPI Spec, Postman, NestJS

#### Advanced
**Description**: Enterprise API infrastructure
**Features**:
- GraphQL API
- API gateway
- Multiple authentication methods
- API analytics
- SDK generation
- API marketplace
- Advanced rate limiting (per-user, tiered)
- API monetization

**Examples**: GraphQL, Kong, Apigee, AWS API Gateway

---

### 10. Third-Party Integrations

#### Basic
**Description**: Simple integrations
**Features**:
- Webhook receivers
- Basic OAuth clients
- CSV import/export
- Manual data sync

**Examples**: Simple webhooks, CSV libraries

#### Intermediate
**Description**: Automated integrations
**Features**:
- Pre-built integrations (5-10 services)
- Webhook management
- OAuth 2.0 flows
- Background job processing
- Integration marketplace
- Zapier integration

**Examples**: Zapier, IFTTT, custom integrations

#### Advanced
**Description**: Integration platform
**Features**:
- Extensive integration library (50+ services)
- Embedded integration builder
- Custom integration SDK
- Real-time sync
- Transformation engine
- Integration monitoring
- White-label integrations

**Examples**: Tray.io, Workato, Merge.dev, Nango

---

### 11. Security & Compliance

#### Basic
**Description**: Essential security measures
**Features**:
- HTTPS/SSL
- Password hashing
- Basic input validation
- CORS configuration
- Environment variables for secrets

**Examples**: Let's Encrypt, bcrypt, dotenv

#### Intermediate
**Description**: Enhanced security
**Features**:
- Data encryption at rest
- Data encryption in transit
- Security headers
- GDPR compliance tools
- Privacy policy management
- Cookie consent
- Audit logs
- IP whitelisting

**Examples**: AWS KMS, Azure Key Vault, Cookiebot

#### Advanced
**Description**: Enterprise security and compliance
**Features**:
- SOC 2 compliance
- HIPAA compliance
- ISO 27001 certification
- Penetration testing
- Bug bounty program
- DDoS protection
- WAF (Web Application Firewall)
- Security incident response plan
- Data residency controls

**Examples**: CloudFlare, Vanta, Drata, AWS Shield

---

### 12. Backup & Recovery

#### Basic
**Description**: Basic data protection
**Features**:
- Daily database backups
- Manual backup triggers
- 7-day retention
- Single-region backups

**Examples**: pg_dump, mysqldump, cloud provider snapshots

#### Intermediate
**Description**: Automated backup system
**Features**:
- Automated scheduled backups
- 30-day retention
- Point-in-time recovery
- Multi-region backups
- Backup testing
- Incremental backups

**Examples**: AWS Backup, Azure Backup, Bacula

#### Advanced
**Description**: Enterprise disaster recovery
**Features**:
- Continuous data protection
- Cross-region replication
- Disaster recovery plan
- RTO/RPO guarantees
- Backup encryption
- Long-term archival
- Compliance-ready retention policies

**Examples**: AWS Disaster Recovery, Veeam, Rubrik

---

### 13. Billing & Payments

#### Basic
**Description**: Simple payment processing
**Features**:
- One-time payments
- Credit card processing
- Basic receipt generation
- Payment confirmation emails

**Examples**: Stripe Checkout, PayPal, Square

#### Intermediate
**Description**: Subscription management
**Features**:
- Recurring subscriptions
- Multiple pricing plans
- Payment method management
- Failed payment handling
- Prorated billing
- Basic invoicing
- Dunning management

**Examples**: Stripe Billing, Chargebee, Paddle

#### Advanced
**Description**: Enterprise billing infrastructure
**Features**:
- Usage-based billing
- Complex pricing models
- Multi-currency support
- Tax calculation (global)
- Invoice customization
- Revenue recognition
- Payment orchestration
- Multiple payment gateways
- ACH/wire transfers
- Purchase orders

**Examples**: Stripe, Zuora, Recurly, Chargebee Enterprise

---

### 14. Customer Support

#### Basic
**Description**: Basic support functionality
**Features**:
- Contact form
- Email support
- FAQ page
- Simple ticket system

**Examples**: Email, Google Forms, custom forms

#### Intermediate
**Description**: Help desk system
**Features**:
- Ticketing system
- Knowledge base
- Live chat widget
- Canned responses
- Ticket assignment
- Basic SLA tracking
- Customer portal

**Examples**: Intercom, Help Scout, Freshdesk

#### Advanced
**Description**: Enterprise support platform
**Features**:
- Omnichannel support (email, chat, phone, social)
- AI-powered chatbots
- Advanced SLA management
- Ticket automation and routing
- Customer satisfaction surveys
- Support analytics
- Integration with CRM
- Multi-language support
- Video support

**Examples**: Zendesk, Salesforce Service Cloud, Gorgias

---

## Vertical-Specific Features

These features are specialized for specific industries. Many can be adapted across verticals.

### E-commerce (10 features)
1. **3PL/Fulfillment** (Integration: Logistics) - ShipBob, Deliverr, Shippo
2. **Shopping Cart/Storefront** - Shopify, BigCommerce, WooCommerce
3. **Marketing Automation** - Klaviyo, Omnisend, Mailchimp
4. **Order Management** - Order Desk, Skubana
5. **Returns Management** - Returnly, Loop Returns
6. **Customer Service** - Gorgias, Re:amaze
7. **Live Chat** - Olark, Drift
8. **Reviews Management** - Yotpo, Judge.me
9. **Subscription Management** - Recharge, Bold Subscriptions
10. **Analytics** - Google Analytics, Glew.io

### Healthcare (7 features)
1. **Electronic Health Records (EHR)** - Epic, Cerner, DrChrono
2. **Telemedicine** - Teladoc, Doxy.me
3. **Medical Billing** - Kareo, AdvancedMD
4. **Patient Engagement** - PatientPop, Solutionreach
5. **Medical Imaging** - Ambra Health
6. **Healthcare CRM** - Salesforce Health Cloud
7. **Revenue Cycle Management** - Availity

### Education (6 features)
1. **Learning Management System (LMS)** - Canvas, Moodle, Blackboard
2. **Student Information System (SIS)** - PowerSchool, Infinite Campus
3. **Classroom Management** - Google Classroom, ClassDojo
4. **Online Proctoring** - ProctorU, Examity
5. **Admissions & Enrollment** - Slate, Ellucian CRM
6. **School Communication** - ParentSquare, Remind

### Finance (6 features)
1. **Accounting** - Xero, QuickBooks, FreshBooks
2. **Payment Processing** - Stripe, PayPal, Square
3. **Investment Management** - Betterment, Wealthfront
4. **Loan Management** - Blend, Finastra
5. **Financial Planning** - eMoney Advisor, MoneyGuidePro
6. **Regulatory Compliance** - Fenergo

### Real Estate (5 features)
1. **CRM** - Follow Up Boss, Propertybase
2. **Property Management** - Buildium, AppFolio
3. **Real Estate Marketing** - BoomTown, kvCORE
4. **Transaction Management** - Dotloop, SkySlope
5. **Virtual Tours** - Matterport, Zillow 3D Home

### Marketing & Sales (5 features)
1. **Marketing Automation** - Marketo, Pardot, HubSpot
2. **Social Media Management** - Hootsuite, Buffer, Sprout Social
3. **Sales Intelligence** - ZoomInfo, LinkedIn Sales Navigator
4. **Content Marketing** - Contently, Semrush
5. **Email Marketing** - Mailchimp, Constant Contact

### Human Resources (HR) (5 features)
1. **Applicant Tracking System (ATS)** - Greenhouse, Lever, BambooHR
2. **Payroll** - Gusto, ADP, Paychex
3. **Performance Management** - Lattice, 15Five
4. **Benefits Administration** - Zenefits, Gusto
5. **Employee Engagement** - Culture Amp, Officevibe

### Project Management (4 features)
1. **Project Management Software** - Asana, Monday.com, Jira
2. **Time Tracking** - Toggl, Harvest, Clockify
3. **Resource Management** - Float, Resource Guru
4. **Collaboration Tools** - Slack, Microsoft Teams, Notion

### Customer Service (4 features)
1. **Help Desk** - Zendesk, Freshdesk, Intercom
2. **Live Chat** - Olark, Drift, LiveChat
3. **Knowledge Base** - Helpjuice, Document360
4. **Customer Feedback** - SurveyMonkey, Typeform

### Legal (5 features)
1. **Practice Management** - Clio, MyCase, PracticePanther
2. **Document Management** - NetDocuments, iManage
3. **E-Discovery** - Relativity, Everlaw
4. **Contract Management** - Ironclad, PandaDoc
5. **Legal Research** - Westlaw, LexisNexis

### Non-Profit (3 features)
1. **Donor Management** - Salesforce.org, Bloomerang
2. **Fundraising** - Classy, DonorPerfect
3. **Volunteer Management** - VolunteerMatch, SignUpGenius

### Travel & Hospitality (3 features)
1. **Property Management Systems** - Cloudbeds, Guesty
2. **Booking Engines** - TravelClick, SiteMinder
3. **Revenue Management** - IDeaS, Duetto

### Manufacturing (3 features)
1. **Enterprise Resource Planning (ERP)** - SAP, Oracle NetSuite
2. **Manufacturing Execution Systems (MES)** - GE Proficy
3. **Supply Chain Management (SCM)** - Blue Yonder, Infor

### Agriculture (3 features)
1. **Farm Management** - FarmersEdge, Granular
2. **Precision Agriculture** - John Deere Operations Center
3. **Livestock Management** - CattleMax, Farmplan

---

## Cross-Vertical Feature Patterns

Certain features appear across multiple verticals, indicating opportunities for shared components:

### CRM
**Appears in**: E-commerce, Healthcare, Real Estate
**Consideration**: Core customer relationship management can be adapted with vertical-specific data models

### Analytics
**Appears in**: E-commerce, Marketing & Sales
**Consideration**: Data tracking and reporting infrastructure is highly reusable

### Marketing Automation
**Appears in**: E-commerce, Marketing & Sales, Real Estate
**Consideration**: Campaign management, email automation, and lead nurturing logic

### Live Chat
**Appears in**: E-commerce, Customer Service
**Consideration**: Real-time messaging infrastructure

### Payment Processing
**Appears in**: E-commerce, Finance
**Consideration**: Payment gateway integration with compliance requirements

### Communication Tools
**Appears in**: Education, Project Management, Customer Service
**Consideration**: Messaging, notifications, and collaboration features

### Compliance & Regulatory
**Appears in**: Healthcare, Finance, Legal
**Consideration**: Audit trails, data governance, regulatory reporting

---

## How to Use This Catalog

### When Defining a New Product

1. **Start with Common Features**: Review the 14 common feature categories
2. **Determine Tier Level**: Identify whether you need Basic, Intermediate, or Advanced implementation for each
3. **Add Vertical Features**: If building for a specific industry, review vertical-specific features
4. **Identify Overlaps**: Check cross-vertical patterns for potential shared components

### Example: Building an E-commerce Platform

**Common Features - Basic Tier**:
- Authentication (email/password)
- User Profiles (basic)
- Data Storage (PostgreSQL)
- Search (SQL-based)
- Notifications (email only)
- API (REST)
- Security (HTTPS, basic GDPR)
- Payments (one-time via Stripe)

**Common Features - Intermediate Tier** (for growth):
- Authentication (OAuth, 2FA)
- Email Integration (SendGrid with analytics)
- Dashboards (interactive charts)
- Integrations (Zapier, 5-10 pre-built)

**E-commerce Specific**:
- Shopping Cart/Storefront
- Order Management
- 3PL/Fulfillment Integration
- Reviews Management
- Marketing Automation

### Example: Building a Healthcare SaaS

**Common Features - Advanced Tier** (required for compliance):
- Authentication (SSO, SAML for provider networks)
- Security (HIPAA compliance, SOC 2)
- Backup (enterprise disaster recovery)
- API (with strict rate limiting and audit logs)

**Healthcare Specific**:
- Electronic Health Records (EHR)
- Patient Engagement
- Medical Billing
- Telemedicine (if applicable)

---

## Integration Categories Reference

Based on Nango's integration taxonomy, common integration needs include:

- **Authentication**: Clerk, Magic, Stytch, WorkOS
- **Communication**: Discord, Gmail, Mailchimp, Slack, Twilio
- **Payments**: Stripe, Paddle, Checkout.com
- **Storage**: Amazon S3, Box, Dropbox, Google Drive
- **CRM**: Salesforce, HubSpot, Pipedrive, Zoho
- **Analytics**: Amplitude, Mixpanel, Segment, Heap
- **Support**: Zendesk, Intercom, Freshdesk
- **Marketing**: Mailchimp, HubSpot, ActiveCampaign
- **HR**: BambooHR, Greenhouse, Workday
- **Accounting**: QuickBooks, Xero, FreshBooks

---

## Quick Reference: Tier Selection Guide

**Choose BASIC when**:
- Building MVP or proof of concept
- Limited budget and timeline
- Small user base (< 1,000 users)
- Single team or region

**Choose INTERMEDIATE when**:
- Growing user base (1,000-10,000 users)
- Need for automation and efficiency
- Multiple teams or light multi-tenancy
- Professional product requirements

**Choose ADVANCED when**:
- Enterprise customers
- Large scale (10,000+ users)
- Strict compliance requirements
- Multi-region deployment
- Complex workflows and customization

---

## Maintenance Notes

- **Source**: SaasVerticalCategories.xlsx
- **Last Updated**: 2025-11-10
- **Taxonomy Version**: 1.0
- **Total Common Features**: 14 categories × 3 tiers = 42 feature sets
- **Total Verticals**: 14 industry domains
- **Total Vertical Features**: 69 specialized features

This catalog is a living document and should be updated as new patterns emerge and technologies evolve.
