# Project Timeline & Sprint Planning
## ShareSaji - MVP Development Schedule

**Version:** 1.0  
**Date:** 2025-09-30  
**Total Duration:** 3-4 weeks  
**Team Size:** 2-3 developers (1 full-stack + 1 frontend/backend)

---

## 1. Project Milestones Overview

```
Week 1: Foundation & Setup
├─ Day 1-2: Project setup, database schema
├─ Day 3-4: Authentication system
└─ Day 5-7: Customer registration & referral system

Week 2: Core Transactions
├─ Day 8-9: Staff checkout interface
├─ Day 10-11: Discount calculation & virtual currency
└─ Day 12-14: Transaction recording & upline rewards

Week 3: Analytics & Polish
├─ Day 15-16: Owner analytics dashboard
├─ Day 17-18: Email notifications & expiry logic
└─ Day 19-21: UI polish, responsive design, testing

Week 4: Launch Preparation
├─ Day 22-23: User acceptance testing (UAT)
├─ Day 24-25: Staff training & documentation
├─ Day 26-27: Production deployment & monitoring
└─ Day 28: Soft launch at pilot restaurant
```

---

## 2. Detailed Sprint Breakdown

### Sprint 1: Foundation (Days 1-7)

#### Sprint Goal
Establish project infrastructure and implement customer registration with referral tracking.

#### Day 1-2: Project Setup & Database

**Tasks:**
- [ ] Create GitHub repository
- [ ] Setup Supabase project (database, auth, storage)
- [ ] Create React app with Vite
- [ ] Configure Tailwind CSS
- [ ] Setup ESLint + Prettier
- [ ] Create database schema (run migrations)
- [ ] Create seed data (test restaurant, owner, staff)
- [ ] Setup Vercel project for deployment
- [ ] Configure environment variables

**Deliverables:**
- Working dev environment
- Database with all tables, views, stored procedures
- Initial React app structure

**Estimated Hours:** 16 hours

---

#### Day 3-4: Authentication System

**Tasks:**
- [ ] Create Supabase client configuration
- [ ] Implement AuthContext (React Context API)
- [ ] Create login page (email/password)
- [ ] Create registration page (with role selection)
- [ ] Implement email verification flow
- [ ] Implement password recovery flow
- [ ] Create protected route wrapper
- [ ] Add form validation (email format, password strength)
- [ ] Create auth service layer (API calls)

**Deliverables:**
- Functional login/registration
- Email verification working
- Password recovery working
- Protected routes based on role

**Estimated Hours:** 16 hours

---

#### Day 5-7: Customer Registration & Referral System

**Tasks:**
- [ ] Create customer registration form (email, password, birthday, age)
- [ ] Generate unique referral code on registration (SAJI-XXXXX)
- [ ] Implement referral code URL parameter handling
- [ ] Call `create_referral_chain` RPC on registration
- [ ] Create customer dashboard page
- [ ] Display referral code/QR on dashboard
- [ ] Implement QR code generation (react-qr-code)
- [ ] Create shareable link with copy-to-clipboard
- [ ] Display upline chain (who referred you)
- [ ] Display downline list (who you referred)
- [ ] Create referral tree visualization (simple list for MVP)

**Deliverables:**
- Customer can register with referral code
- Referral chain created automatically (up to 3 uplines)
- Customer dashboard shows QR/code to share
- Customer can view their referrals

**Estimated Hours:** 24 hours

**Sprint 1 Total:** 56 hours (~7 working days for 2 developers)

---

### Sprint 2: Core Transactions (Days 8-14)

#### Sprint Goal
Implement staff checkout flow with discount calculation and virtual currency management.

#### Day 8-9: Staff Checkout Interface

**Tasks:**
- [ ] Create staff login page
- [ ] Create staff dashboard (today's stats)
- [ ] Create checkout page with QR scanner
- [ ] Implement QR scanner (html5-qrcode library)
- [ ] Add manual code entry fallback
- [ ] Fetch customer details by code
- [ ] Display customer name, balance, first-time indicator
- [ ] Create discount calculation form
- [ ] Input field for bill amount
- [ ] Calculate guaranteed discount (5% if first use)
- [ ] Display virtual currency available
- [ ] Calculate max redeemable (20% of bill)
- [ ] Allow staff to select redemption amount
- [ ] Show total discount preview

**Deliverables:**
- Staff can scan customer QR or enter code
- Staff can see customer details
- Staff can calculate discounts accurately

**Estimated Hours:** 16 hours

---

#### Day 10-11: Virtual Currency & Wallet

**Tasks:**
- [ ] Create WalletContext (React Context API)
- [ ] Create wallet service layer (API calls)
- [ ] Implement `customer_wallet_balance` view query
- [ ] Create wallet page (customer portal)
- [ ] Display current balance (in RM)
- [ ] Display transaction history (earnings, redemptions, expiry)
- [ ] Show expiry dates for each earning
- [ ] Format currency (RM prefix, 2 decimals)
- [ ] Add loading states and error handling
- [ ] Implement real-time balance updates (Supabase Realtime)

**Deliverables:**
- Customer can view wallet balance
- Customer can see transaction history
- Real-time updates when downline spends

**Estimated Hours:** 16 hours

---

#### Day 12-14: Transaction Recording & Upline Rewards

**Tasks:**
- [ ] Create transaction service layer (API calls)
- [ ] Implement transaction creation endpoint
- [ ] Add receipt photo upload (Supabase Storage)
- [ ] Implement `redeem_virtual_currency` RPC call
- [ ] Implement `distribute_upline_rewards` RPC call
- [ ] Create transaction confirmation page (staff)
- [ ] Add transaction history view (customer)
- [ ] Test referral chain rewards (3 levels)
- [ ] Test redemption cap (20% of bill)
- [ ] Test first-time discount (5% guaranteed)
- [ ] Add error handling for insufficient balance
- [ ] Add validation for redemption amount

**Deliverables:**
- Staff can record transactions with photo
- Virtual currency redeemed correctly
- Upline rewards distributed automatically (1% each, up to 3 levels)
- Customer can view transaction history

**Estimated Hours:** 24 hours

**Sprint 2 Total:** 56 hours (~7 working days for 2 developers)

---

### Sprint 3: Analytics & Polish (Days 15-21)

#### Sprint Goal
Implement owner analytics dashboard, email notifications, and polish UI for launch.

#### Day 15-16: Owner Analytics Dashboard

**Tasks:**
- [ ] Create owner login page
- [ ] Create owner dashboard layout
- [ ] Implement `restaurant_analytics_summary` view query
- [ ] Display today's summary (transactions, revenue, discounts)
- [ ] Display this week's summary
- [ ] Display all-time summary
- [ ] Create referral stats section
  - [ ] Total registered customers
  - [ ] Average downlines per customer
  - [ ] Top 5 referrers (by downline count)
- [ ] Add date range filter (today, this week, all-time)
- [ ] Create transaction list view (paginated)
- [ ] Add search/filter by customer, date
- [ ] Create charts (optional: simple bar/line charts with Chart.js)

**Deliverables:**
- Owner can view comprehensive analytics
- Owner can see ROI (revenue vs discounts)
- Owner can identify top referrers

**Estimated Hours:** 16 hours

---

#### Day 17-18: Email Notifications & Expiry Logic

**Tasks:**
- [ ] Setup SendGrid account and API key
- [ ] Create email templates (HTML)
  - [ ] Registration verification
  - [ ] Password recovery
  - [ ] Earning notification
  - [ ] Expiry warning (7 days before)
- [ ] Create Supabase Edge Function for email sending
- [ ] Implement earning notification trigger (on ledger insert)
- [ ] Create cron Edge Function for expiry
  - [ ] Call `expire_virtual_currency` RPC
  - [ ] Send expiry notification emails
- [ ] Schedule cron job (daily at 2 AM MYT)
- [ ] Create expiry warning cron (daily at 9 AM MYT)
- [ ] Test email delivery
- [ ] Add email preferences (future: allow opt-out)

**Deliverables:**
- Users receive verification emails
- Users receive earning notifications
- Users receive expiry warnings
- Daily cron expires balances automatically

**Estimated Hours:** 16 hours

---

#### Day 19-21: UI Polish, Responsive Design, Testing

**Tasks:**
- [ ] Review all pages for responsive design (mobile, tablet, desktop)
- [ ] Add loading spinners for async operations
- [ ] Add error messages for failed operations
- [ ] Add success messages for completed actions
- [ ] Improve form validation feedback
- [ ] Add tooltips for complex features
- [ ] Create FAQ page (common questions)
- [ ] Create Terms of Service page
- [ ] Create Privacy Policy page (PDPA compliance)
- [ ] Add footer with links
- [ ] Optimize images and assets
- [ ] Test on multiple devices (iOS Safari, Android Chrome)
- [ ] Test all user flows end-to-end
  - [ ] Customer registration → sharing → earning → redemption
  - [ ] Staff checkout flow
  - [ ] Owner analytics viewing
- [ ] Fix bugs found during testing
- [ ] Write unit tests for critical functions
- [ ] Write integration tests for API calls

**Deliverables:**
- Polished, responsive UI
- All user flows tested and working
- FAQ, Terms, Privacy Policy pages
- Bug-free MVP ready for UAT

**Estimated Hours:** 24 hours

**Sprint 3 Total:** 56 hours (~7 working days for 2 developers)

---

### Sprint 4: Launch Preparation (Days 22-28)

#### Sprint Goal
Conduct user acceptance testing, train staff, deploy to production, and soft launch.

#### Day 22-23: User Acceptance Testing (UAT)

**Tasks:**
- [ ] Create UAT test plan (scenarios to test)
- [ ] Recruit 5-10 beta testers (friends, family)
- [ ] Provide test accounts (customer, staff, owner)
- [ ] Conduct UAT sessions (guided testing)
- [ ] Collect feedback (usability, bugs, confusion)
- [ ] Prioritize feedback (critical vs nice-to-have)
- [ ] Fix critical bugs
- [ ] Document known issues (non-critical)
- [ ] Retest fixed bugs

**Deliverables:**
- UAT feedback report
- Critical bugs fixed
- Known issues documented

**Estimated Hours:** 16 hours

---

#### Day 24-25: Staff Training & Documentation

**Tasks:**
- [ ] Create staff training manual (PDF)
  - [ ] How to promote program to customers
  - [ ] How to scan QR codes
  - [ ] How to calculate discounts
  - [ ] How to upload receipt photos
  - [ ] Troubleshooting common issues
- [ ] Create customer-facing materials
  - [ ] Table tent cards with QR code
  - [ ] Posters explaining program
  - [ ] Social media graphics for sharing
- [ ] Conduct in-person staff training (2 hours)
  - [ ] Demo all features
  - [ ] Practice checkout flow
  - [ ] Q&A session
- [ ] Create owner training guide
  - [ ] How to view analytics
  - [ ] How to interpret ROI data
  - [ ] How to adjust parameters (future)
- [ ] Create customer FAQ (in-app)

**Deliverables:**
- Staff trained and confident
- Training materials created
- Marketing materials printed
- Owner understands analytics

**Estimated Hours:** 16 hours

---

#### Day 26-27: Production Deployment & Monitoring

**Tasks:**
- [ ] Final code review
- [ ] Merge all branches to main
- [ ] Run production build locally (test)
- [ ] Deploy frontend to Vercel (production)
- [ ] Verify Supabase production database
- [ ] Run database migrations on production
- [ ] Insert production seed data (restaurant, owner, staff)
- [ ] Configure production environment variables
- [ ] Test production deployment (all flows)
- [ ] Setup monitoring
  - [ ] Vercel Analytics (page views, performance)
  - [ ] Supabase Dashboard (database metrics)
  - [ ] Error tracking (Sentry or Vercel)
- [ ] Setup alerts (email on critical errors)
- [ ] Create rollback plan (document steps)
- [ ] Backup production database (manual)

**Deliverables:**
- Production deployment live
- Monitoring and alerts configured
- Rollback plan documented

**Estimated Hours:** 16 hours

---

#### Day 28: Soft Launch

**Tasks:**
- [ ] Announce soft launch to restaurant staff
- [ ] Place QR codes on tables
- [ ] Hang posters in restaurant
- [ ] Train staff on-site (refresher)
- [ ] Monitor first transactions in real-time
- [ ] Be on-call for support (first day)
- [ ] Collect initial feedback from customers
- [ ] Track key metrics (registrations, transactions)
- [ ] Celebrate launch! 🎉

**Deliverables:**
- MVP live at pilot restaurant
- First customers registered
- First transactions processed
- Initial feedback collected

**Estimated Hours:** 8 hours

**Sprint 4 Total:** 56 hours (~7 working days for 2 developers)

---

## 3. Resource Allocation

### Team Structure

**Option 1: 2 Developers (Recommended for MVP)**
- **Developer 1 (Full-Stack):** 
  - Backend setup (Supabase, database, Edge Functions)
  - API integration
  - Authentication system
  - Transaction logic
- **Developer 2 (Frontend-focused):**
  - React components
  - UI/UX design
  - Responsive design
  - Testing

**Option 2: 3 Developers (Faster Timeline)**
- **Developer 1 (Backend):** Database, API, Edge Functions
- **Developer 2 (Frontend):** Customer & Staff portals
- **Developer 3 (Frontend):** Owner portal, analytics, polish

### Time Commitment

- **2 Developers:** 8 hours/day × 2 people × 21 working days = **336 hours total**
- **3 Developers:** 8 hours/day × 3 people × 14 working days = **336 hours total** (faster delivery)

---

## 4. Risk Management

### Potential Delays & Mitigation

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Supabase learning curve | 2-3 days | Medium | Study docs in advance, use tutorials |
| QR scanning issues on iOS | 1-2 days | Medium | Test early, have manual entry fallback |
| Email deliverability problems | 1 day | Low | Use SendGrid (reputable), setup SPF/DKIM |
| Referral chain logic bugs | 2-3 days | Medium | Write unit tests, test with seed data |
| Staff training takes longer | 1 day | Low | Create detailed manual, practice sessions |
| UAT reveals critical bugs | 2-3 days | Medium | Buffer time in Sprint 4, prioritize ruthlessly |

### Contingency Plan

If timeline slips beyond 4 weeks:
1. **Cut "Should Have" features** (see MoSCoW doc)
2. **Simplify analytics** (show only basic metrics)
3. **Delay email notifications** (add in Phase 2)
4. **Launch with manual expiry** (owner manually adjusts balances)

---

## 5. Daily Standup Format

**Time:** 9:00 AM daily (15 minutes)

**Questions:**
1. What did you complete yesterday?
2. What will you work on today?
3. Any blockers or help needed?

**Example:**
- **Dev 1:** "Yesterday: Completed database schema. Today: Implementing auth. Blocker: None."
- **Dev 2:** "Yesterday: Setup React app. Today: Creating login page. Blocker: Need Supabase credentials."

---

## 6. Weekly Review & Retrospective

**Time:** Friday 4:00 PM (1 hour)

**Agenda:**
1. **Review (30 min):**
   - Demo completed features
   - Review sprint goals (achieved?)
   - Discuss metrics (velocity, bugs)
2. **Retrospective (30 min):**
   - What went well?
   - What could improve?
   - Action items for next sprint

---

## 7. Success Metrics (Track Weekly)

### Development Metrics
- **Velocity:** Story points completed per sprint
- **Bug Count:** New bugs vs fixed bugs
- **Code Coverage:** Unit test coverage (target: 80%)
- **Deployment Frequency:** How often we deploy to staging

### Business Metrics (Post-Launch)
- **Registrations:** New customers per day
- **Virality:** Average downlines per customer
- **Transactions:** Checkouts per day
- **Redemption Rate:** % of virtual currency redeemed
- **ROI:** Revenue increase vs discount costs

---

## 8. Post-MVP Roadmap (Phase 2)

### Weeks 5-8: Automation & Scale
- **AI OCR for receipts** (EasyOCR integration)
- **Cross-restaurant functionality** (code works at multiple restaurants)
- **Advanced analytics** (date range, CSV export, transaction list)
- **Social media share buttons** (WhatsApp, Facebook)

### Weeks 9-12: Optimization
- **Birthday offers automation**
- **Personalized recommendations** (based on spending)
- **Gamification** (badges, leaderboards)
- **Parameter configuration UI** (owner can adjust rates)
- **Push notifications** (PWA)

### Months 4-6: Growth
- **Multi-language support** (Bahasa Malaysia)
- **Restaurant discovery map** (find participating restaurants)
- **Nutritional tracking** (using item database)
- **Loyalty tiers** (VIP program)
- **Referral contests** (monthly prizes)

---

## 9. Budget Estimate

### Development Costs (MVP)

**Freelance Rates (Malaysia):**
- Junior Developer: RM50-80/hour
- Mid-level Developer: RM100-150/hour
- Senior Developer: RM150-250/hour

**Estimated Cost (2 Mid-level Developers):**
- 336 hours × RM125/hour = **RM42,000** (~USD 9,000)

**In-house Development:**
- 2 developers × 4 weeks = **RM16,000-24,000** (monthly salaries)

### Infrastructure Costs (Monthly)

**MVP (Free Tier):**
- Supabase: RM0 (free tier sufficient for 100-500 users)
- Vercel: RM0 (free tier sufficient)
- SendGrid: RM0 (free tier: 100 emails/day)
- **Total: RM0/month**

**Phase 2 (500-5,000 users):**
- Supabase Pro: RM100/month (~USD 25)
- Vercel Pro: RM80/month (~USD 20)
- SendGrid Essentials: RM60/month (~USD 15, 50K emails/month)
- **Total: RM240/month (~USD 60)**

### Marketing Costs (Pilot Launch)

- Table QR codes (50 pcs): RM200
- Posters (20 pcs): RM300
- Social media graphics: RM500 (designer)
- **Total: RM1,000**

### Total MVP Budget

- Development: RM42,000 (freelance) or RM16,000-24,000 (in-house)
- Infrastructure: RM0 (free tier)
- Marketing: RM1,000
- **Grand Total: RM17,000-43,000** (~USD 3,600-9,200)

---

## 10. Gantt Chart (Visual Timeline)

```
Week 1: Foundation
[████████████████████] Sprint 1: Setup, Auth, Referrals

Week 2: Core Transactions
[████████████████████] Sprint 2: Checkout, Wallet, Rewards

Week 3: Analytics & Polish
[████████████████████] Sprint 3: Analytics, Emails, UI

Week 4: Launch
[████████████████████] Sprint 4: UAT, Training, Deploy

Legend:
█ = Work in progress
```

---

## 11. Checklist: Ready for Launch

### Technical Readiness
- [ ] All "Must Have" features implemented
- [ ] All user flows tested end-to-end
- [ ] No critical bugs
- [ ] Responsive design works on mobile/tablet/desktop
- [ ] Production deployment successful
- [ ] Monitoring and alerts configured
- [ ] Backup and rollback plan documented

### Business Readiness
- [ ] Staff trained and confident
- [ ] Marketing materials printed and placed
- [ ] Owner understands analytics
- [ ] Customer FAQ created
- [ ] Terms of Service and Privacy Policy published
- [ ] Support email setup (support@sharesaji.com)

### Legal & Compliance
- [ ] PDPA compliance verified (consent, privacy policy)
- [ ] Terms of Service reviewed (not a pyramid scheme)
- [ ] Email verification working (anti-spam)

---

## 12. Communication Plan

### Stakeholder Updates

**Weekly Email (Every Friday):**
- Progress update (features completed)
- Blockers or risks
- Next week's plan
- Screenshots or demo video

**Recipients:**
- Restaurant owner (pilot partner)
- Project sponsor
- Team members

### Launch Announcement

**Channels:**
- Restaurant social media (Facebook, Instagram)
- Email to existing customers (if available)
- In-restaurant signage
- Staff word-of-mouth

**Message:**
"Earn rewards by sharing! Register for 5% off today, then share your code to earn more discounts on future visits. No limits!"

---

## 13. Appendix: Sprint Backlog Template

### User Story Format

**As a [role], I want to [action], so that [benefit].**

**Example:**
- **As a customer**, I want to view my wallet balance, so that I know how much I can redeem.

**Acceptance Criteria:**
- [ ] Balance displayed in RM with 2 decimals
- [ ] Transaction history shown (last 20 transactions)
- [ ] Expiry dates visible for each earning
- [ ] Real-time updates when downline spends

**Story Points:** 5 (Fibonacci scale: 1, 2, 3, 5, 8, 13)

---

**Document Approval:**
- [ ] Project Manager
- [ ] Technical Lead
- [ ] Restaurant Owner (Pilot Partner)

**Next Steps:**
1. Review and approve timeline
2. Assemble development team
3. Kick off Sprint 1 (Day 1)
4. Setup daily standups and weekly reviews
