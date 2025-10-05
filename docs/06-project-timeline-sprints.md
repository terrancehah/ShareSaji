# Project Timeline & Sprint Planning
## ShareSaji - Phased Development Schedule

**Version:** 2.0  
**Date:** 2025-10-05  
**Total Duration:** 6-9 weeks (3 phases)  
**Team Size:** 1-2 developers  
**Work Schedule:** 8-10 hours per day

---

## 1. Project Phases Overview

```
PHASE 1: Customer Portal (2-3 weeks)
├─ Week 1: Foundation & Authentication
├─ Week 2: Dashboard & Virtual Currency Display
└─ Week 3: Settings & Skeletons

PHASE 2: Staff & Restaurant Portal (2-3 weeks)
├─ Week 4: QR Scanning & Customer Verification
├─ Week 5: Add/Deduct Currency & OCR Interface
└─ Week 6: Transaction Management

PHASE 3: Polish & Complete Features (2-3 weeks)
├─ Week 7: Restaurant Dashboard & Analytics
├─ Week 8: Complete All Skeletons & Integrations
└─ Week 9: Testing, Bug Fixes & Deployment
```

---

---

## 2. PHASE 1: Customer Portal (2-3 weeks)

### Phase Goal
Build complete customer-facing portal with onboarding, dashboard, virtual currency display, and settings. All advanced features as skeletons.

---

### Week 1: Foundation & Onboarding

#### Day 1-2: Project Setup & Database

**Tasks:**
- [ ] Create GitHub repository
- [ ] Setup Supabase project (database, auth, storage)
- [ ] Create React app with Vite + TypeScript
- [ ] Configure Tailwind CSS + shadcn/ui
- [ ] Setup ESLint + Prettier
- [ ] Create complete database schema (all tables from docs)
- [ ] Setup Vercel project for deployment
- [ ] Configure environment variables

**Deliverables:**
- Working dev environment
- Database with all tables ready
- Initial React app structure with routing

**Estimated Hours:** 16-20 hours

---

#### Day 3-5: Authentication & Onboarding Flow

**Tasks:**
- [ ] Setup Supabase Auth client
- [ ] Create AuthContext (React Context)
- [ ] Build registration page
  - [ ] Email, password, birthday, age fields
  - [ ] Generate unique referral code on signup (SAJI-XXXXXX)
  - [ ] Handle referral code from URL (`/join/:restaurantSlug/:code`)
  - [ ] Save referral code to `saved_referral_codes` table
- [ ] Build login page
- [ ] Implement email verification flow
- [ ] Implement password recovery flow
- [ ] Create protected route wrapper
- [ ] Form validation (email format, password strength, age 18+)
- [ ] Welcome screen after registration

**Deliverables:**
- Customer can register with email
- Referral code generated automatically
- Login/logout working
- Email verification sent
- Clean onboarding experience

**Estimated Hours:** 20-24 hours

---

### Week 2: Dashboard & Virtual Currency Display

#### Day 6-8: Customer Dashboard Core

**Tasks:**
- [ ] Create dashboard layout (navbar, sidebar, content area)
- [ ] Build virtual currency balance section
  - [ ] Display current balance (large, prominent)
  - [ ] Fetch balance from `customer_wallet_balance` view
  - [ ] Real-time updates using Supabase Realtime
  - [ ] Format currency properly (RM XX.XX)
- [ ] Build referral code display section
  - [ ] Show user's referral code (SAJI-XXXXXX)
  - [ ] Copy to clipboard button
  - [ ] "Share with friends" section
- [ ] Build referral link display
  - [ ] Show restaurant-specific link format
  - [ ] Copy link button
  - [ ] Pre-filled social share messages
- [ ] Create navigation menu
  - [ ] Dashboard (home)
  - [ ] Recent Orders (skeleton)
  - [ ] Settings

**Deliverables:**
- Clean, modern dashboard UI
- Virtual currency balance displayed
- Referral code easy to share
- Working navigation

**Estimated Hours:** 20-24 hours

---

#### Day 9-10: QR Code Generator (Skeleton) & Link Sharing

**Tasks:**
- [ ] Create QR code section on dashboard
  - [ ] Placeholder box with "QR Code Coming Soon"
  - [ ] Info text explaining Phase 2 feature
  - [ ] Keep layout ready for actual QR
- [ ] Enhance link sharing section
  - [ ] Add WhatsApp share button (pre-filled message)
  - [ ] Add Facebook share button
  - [ ] Add Instagram copy button
  - [ ] Style social buttons nicely
- [ ] Build saved codes collection view
  - [ ] Fetch saved codes from `saved_referral_codes`
  - [ ] Display restaurant name, code, who shared it
  - [ ] "Ready to Use" badge for unused codes
  - [ ] Empty state when no codes saved

**Deliverables:**
- QR skeleton in place (Phase 2 ready)
- Social sharing buttons working
- Saved codes display functional
- Good UX for link sharing

**Estimated Hours:** 16-20 hours

---

### Week 3: Settings & Recent Orders Skeleton

#### Day 11-13: Settings Page

**Tasks:**
- [ ] Create settings page layout
- [ ] Profile settings section
  - [ ] Change nickname/full name
  - [ ] Change email (with re-verification)
  - [ ] Change birthday
  - [ ] Display age (calculated from birthday)
  - [ ] Form validation
- [ ] Notification preferences section
  - [ ] Toggle: Email notifications on/off
  - [ ] Toggle: Earning notifications
  - [ ] Toggle: Expiry warnings
  - [ ] Save preferences to database
- [ ] Security section
  - [ ] Change password button (link to password reset)
  - [ ] Delete account button (with confirmation modal)
- [ ] About section
  - [ ] App version
  - [ ] Terms of Service link
  - [ ] Privacy Policy link
  - [ ] FAQ link

**Deliverables:**
- Full settings page
- Profile editing working
- Notification toggles functional
- Good form validation and error handling

**Estimated Hours:** 20-24 hours

---

#### Day 14-15: Recent Orders Skeleton & Polish

**Tasks:**
- [ ] Create recent orders page
  - [ ] Skeleton/placeholder UI
  - [ ] Empty state: "No orders yet"
  - [ ] Placeholder cards showing what data will display
  - [ ] Info message: "Orders will appear here after your first purchase"
- [ ] Dashboard polish
  - [ ] Loading states for all data fetches
  - [ ] Error states with retry buttons
  - [ ] Empty states for all sections
  - [ ] Smooth transitions and animations
- [ ] Responsive design fixes
  - [ ] Test on mobile (375px, 414px)
  - [ ] Test on tablet (768px)
  - [ ] Test on desktop (1024px+)
  - [ ] Fix any layout issues
- [ ] Phase 1 testing
  - [ ] Test all customer flows end-to-end
  - [ ] Test on iOS Safari and Android Chrome
  - [ ] Fix bugs found

**Deliverables:**
- Recent orders skeleton complete
- Fully responsive customer portal
- All Phase 1 features tested and polished
- Ready for Phase 2 development

**Estimated Hours:** 16-20 hours

**Phase 1 Total:** 108-132 hours (~2-3 weeks for 1-2 developers)

## 3. PHASE 2: Staff & Restaurant Portal (2-3 weeks)

### Phase Goal
Build staff-facing features for QR scanning, customer verification, adding/deducting virtual currency, and OCR interface.

---

### Week 4: QR Scanning & Customer Verification

#### Day 1-3: Staff Authentication & Dashboard

**Tasks:**
- [ ] Create staff login page (separate from customer)
- [ ] Staff authentication flow
- [ ] Staff dashboard layout
  - [ ] Today's stats (transactions count, total sales)
  - [ ] Recent transactions list
  - [ ] Quick action: Start Checkout
- [ ] Navigation menu
  - [ ] Dashboard
  - [ ] Scan Customer
  - [ ] Manual Entry
  - [ ] Transaction History

**Deliverables:**
- Staff can log in
- Basic dashboard showing stats
- Navigation working

**Estimated Hours:** 20-24 hours

---

#### Day 4-7: QR Scanner & Customer Verification

**Tasks:**
- [ ] Create QR scanner page
  - [ ] Implement `html5-qrcode` library
  - [ ] Camera permission handling
  - [ ] Scan customer QR code (containing referral code)
  - [ ] Parse scanned code
- [ ] Manual code entry fallback
  - [ ] Input field for referral code
  - [ ] Validation
- [ ] Customer details verification
  - [ ] Fetch customer by referral code
  - [ ] Display customer name
  - [ ] Display current virtual currency balance
  - [ ] Check if first visit at restaurant (`customer_restaurant_history`)
  - [ ] Display "First Visit - 5% Discount Applies" badge
  - [ ] Show saved codes if any
- [ ] Customer selection flow
  - [ ] If multiple saved codes, show list
  - [ ] Staff/customer picks which code to use
  - [ ] Option to skip code

**Deliverables:**
- QR scanner working on mobile
- Manual entry fallback functional
- Customer details displayed correctly
- First-visit detection working

**Estimated Hours:** 24-28 hours

---

### Week 5: Add/Deduct Currency & OCR Interface

#### Day 8-10: Currency Management Interface

**Tasks:**
- [ ] Create transaction input page
  - [ ] Bill amount input field
  - [ ] Calculate guaranteed discount (5% if first visit)
  - [ ] Display virtual currency available
  - [ ] Calculate max redeemable (20% of bill)
  - [ ] Slider/input to select redemption amount
  - [ ] Show total discount breakdown
  - [ ] Show final amount customer pays
- [ ] Add currency function
  - [ ] Admin/owner can manually add currency
  - [ ] Reason field (e.g., "compensation", "promotion")
  - [ ] Confirmation modal
- [ ] Deduct currency function
  - [ ] Redemption during checkout
  - [ ] Update `virtual_currency_ledger`
  - [ ] FIFO logic (oldest first)
- [ ] Transaction preview
  - [ ] Summary before confirming
  - [ ] Review all discounts
  - [ ] Confirm button

**Deliverables:**
- Staff can calculate discounts accurately
- Manual add/deduct currency working
- Transaction preview clear and accurate

**Estimated Hours:** 20-24 hours

#### Day 11-12: OCR Interface (Skeleton)

**Tasks:**
- [ ] Create receipt upload page
  - [ ] Camera/file picker for receipt photo
  - [ ] Upload to Supabase Storage
  - [ ] Display uploaded image preview
- [ ] OCR processing skeleton
  - [ ] Placeholder: "OCR processing..."
  - [ ] Manual entry fields shown immediately
  - [ ] Message: "OCR feature coming in Phase 3"
  - [ ] Save photo reference in transaction record
- [ ] Manual data entry as fallback
  - [ ] Bill amount
  - [ ] Transaction date/time
  - [ ] Notes field
- [ ] Receipt gallery view
  - [ ] View past receipt photos
  - [ ] Zoom and pan functionality

**Deliverables:**
- Receipt photo upload working
- OCR skeleton UI in place
- Manual entry as primary method
- Photos stored for future OCR

**Estimated Hours:** 16-20 hours

### Week 6: Transaction Management & Backend Logic

#### Day 13-15: Transaction Processing & Rewards

**Tasks:**
- [ ] Implement transaction creation flow
  - [ ] Create transaction record in database
  - [ ] Link to customer, restaurant, branch
  - [ ] Store bill amount, discounts applied
  - [ ] Attach receipt photo reference
- [ ] Implement `redeem_virtual_currency` RPC
  - [ ] FIFO redemption logic (oldest first)
  - [ ] Update ledger with redemption
  - [ ] Mark redeemed entries
- [ ] Implement `distribute_upline_rewards` RPC
  - [ ] Find uplines for customer at this restaurant
  - [ ] Calculate 1% reward per upline (up to 3)
  - [ ] Create ledger entries for earnings
  - [ ] Set expiry dates (30 days default)
- [ ] Implement `create_referral_chain` RPC
  - [ ] Called on first transaction at restaurant
  - [ ] Use saved code from `saved_referral_codes`
  - [ ] Build 3-level upline chain
  - [ ] Create entries in `referrals` table
  - [ ] Update `customer_restaurant_history`
- [ ] Transaction confirmation page
  - [ ] Success message
  - [ ] Transaction summary
  - [ ] Receipt for printing/email

**Deliverables:**
- Complete transaction flow working
- Referral chain created on first visit
- Upline rewards distributed correctly
- Virtual currency redemption functional

**Estimated Hours:** 24-28 hours

---

#### Day 16-18: Customer Transaction History & Testing

**Tasks:**
- [ ] Update customer "Recent Orders" page (remove skeleton)
  - [ ] Fetch transactions from database
  - [ ] Display transaction cards
    - [ ] Restaurant name
    - [ ] Date and time
    - [ ] Bill amount
    - [ ] Discounts received
    - [ ] Final amount paid
    - [ ] Receipt photo thumbnail
  - [ ] Pagination for long history
  - [ ] Pull-to-refresh
- [ ] Add transaction detail view
  - [ ] Click transaction to see full details
  - [ ] Show discount breakdown
  - [ ] Show upline earnings from this transaction
  - [ ] View receipt photo full-size
- [ ] Phase 2 comprehensive testing
  - [ ] Test QR scanning on multiple devices
  - [ ] Test transaction flow end-to-end
  - [ ] Test referral chain creation
  - [ ] Test upline reward distribution
  - [ ] Test redemption limits (20% cap)
  - [ ] Test first-visit discount
  - [ ] Fix bugs found

**Deliverables:**
- Customer can view transaction history
- Transaction details complete
- All Phase 2 features tested
- Staff portal fully functional

**Estimated Hours:** 20-24 hours

**Phase 2 Total:** 100-120 hours (~2-3 weeks for 1-2 developers)

---

## 4. PHASE 3: Polish & Complete Features (2-3 weeks)

### Phase Goal
Complete restaurant dashboard, implement all skeleton features, add email notifications, and polish entire application for launch.

---

### Week 7: Restaurant Dashboard & Analytics

#### Day 1-3: Owner Portal & Basic Analytics

**Tasks:**
- [ ] Create owner login page (separate from staff/customer)
- [ ] Owner dashboard layout
  - [ ] Key metrics cards (revenue, transactions, customers)
  - [ ] Charts section (simple bar/line charts)
  - [ ] Recent activity feed
- [ ] Implement `restaurant_analytics_summary` view
  - [ ] Today's stats
  - [ ] This week's stats
  - [ ] All-time stats
- [ ] Revenue analytics
  - [ ] Total revenue
  - [ ] Total discounts given (guaranteed + VC)
  - [ ] Net revenue (revenue - discounts)
  - [ ] ROI calculation
- [ ] Customer analytics
  - [ ] Total registered customers
  - [ ] New customers this week
  - [ ] Active customers (made purchases)
  - [ ] Average spend per customer

**Deliverables:**
- Owner portal with login
- Basic dashboard with key metrics
- Revenue and customer analytics

**Estimated Hours:** 20-24 hours

#### Day 4-6: Referral Analytics & Transaction List

**Tasks:**
- [ ] Referral analytics section
  - [ ] Average downlines per customer
  - [ ] Top 10 referrers (by downline count)
  - [ ] Referral tree visualization (top customer chains)
  - [ ] Virality coefficient calculation
- [ ] Transaction list page
  - [ ] Paginated transaction table
  - [ ] Columns: Date, Customer, Bill, Discount, Final Amount
  - [ ] Search by customer name or code
  - [ ] Filter by date range
  - [ ] Export to CSV button
- [ ] Charts implementation
  - [ ] Use Chart.js or Recharts
  - [ ] Revenue trend (daily/weekly)
  - [ ] Customer acquisition trend
  - [ ] Discount distribution chart

**Deliverables:**
- Complete referral analytics
- Transaction list with search/filter
- Visual charts for trends
- CSV export working

**Estimated Hours:** 20-24 hours

---

### Week 8: Complete Skeletons & Email Notifications

#### Day 7-9: Implement QR Code Generator & Recent Orders

**Tasks:**
- [ ] Complete QR code generator (remove skeleton)
  - [ ] Use `react-qr-code` library
  - [ ] Generate QR encoding referral link
  - [ ] Download QR as PNG/SVG
  - [ ] Customize QR styling (colors, logo)
  - [ ] Share QR image on social media
- [ ] Complete OCR processing (basic implementation)
  - [ ] Integrate EasyOCR or Tesseract.js
  - [ ] Extract bill amount from receipt
  - [ ] Pre-fill transaction form with extracted data
  - [ ] Manual correction still available
  - [ ] Track OCR accuracy for improvements
- [ ] Polish recent orders page
  - [ ] Add filters (date range, restaurant)
  - [ ] Add sorting (newest first, highest amount)
  - [ ] Add statistics (total spent, total saved)

**Deliverables:**
- Working QR code generator
- Basic OCR functionality
- Complete recent orders page
- All skeletons removed

**Estimated Hours:** 24-28 hours

---

#### Day 10-12: Email Notifications & Expiry Logic

**Tasks:**
- [ ] Setup SendGrid account and API key
- [ ] Create email templates (HTML)
  - [ ] Registration verification
  - [ ] Password recovery
  - [ ] Earning notification ("You earned RM X!")
  - [ ] Expiry warning (7 days before expiry)
- [ ] Create Supabase Edge Function for email sending
- [ ] Implement earning notification trigger
  - [ ] Trigger on virtual_currency_ledger insert
  - [ ] Only for 'earn' transactions
  - [ ] Respect user's notification preferences
- [ ] Implement expiry system
  - [ ] Create Edge Function for `expire_virtual_currency` RPC
  - [ ] Schedule cron job (daily at 2 AM MYT)
  - [ ] Send expiry notifications
- [ ] Create expiry warning cron
  - [ ] Find earnings expiring in 7 days
  - [ ] Send warning emails
  - [ ] Schedule daily at 9 AM MYT
- [ ] Test all email flows
  - [ ] Verify email deliverability
  - [ ] Check spam scores
  - [ ] Test unsubscribe links

**Deliverables:**
- Email system fully functional
- Users receive notifications (if enabled)
- Automatic expiry working
- All emails tested

**Estimated Hours:** 20-24 hours

---

### Week 9: Testing, Bug Fixes & Deployment

#### Day 13-15: Comprehensive Testing & UI Polish

**Tasks:**
- [ ] UI polish across all portals
  - [ ] Consistent styling and branding
  - [ ] Loading states for all async operations
  - [ ] Error states with retry buttons
  - [ ] Success messages for all actions
  - [ ] Smooth transitions and animations
- [ ] Responsive design verification
  - [ ] Test on iPhone (Safari, Chrome)
  - [ ] Test on Android (Chrome, Samsung Browser)
  - [ ] Test on iPad
  - [ ] Test on desktop (various screen sizes)
  - [ ] Fix any layout issues
- [ ] Create static pages
  - [ ] FAQ page (common questions)
  - [ ] Terms of Service
  - [ ] Privacy Policy (PDPA compliant)
  - [ ] About Us
  - [ ] Contact/Support
- [ ] End-to-end testing
  - [ ] Customer flow: Register → Share → Earn → Redeem
  - [ ] Staff flow: Scan → Verify → Process Transaction
  - [ ] Owner flow: View Analytics → Export Data
- [ ] Edge case testing
  - [ ] Insufficient balance redemption
  - [ ] Expired virtual currency
  - [ ] Invalid referral codes
  - [ ] Network failures
  - [ ] Concurrent transactions

**Deliverables:**
- Polished, consistent UI
- Fully responsive on all devices
- Static pages complete
- All user flows tested
- Edge cases handled

**Estimated Hours:** 24-28 hours

---

#### Day 16-18: Bug Fixes, Performance & Launch Prep

**Tasks:**
- [ ] Fix all bugs found in testing
  - [ ] Prioritize: Critical > High > Medium > Low
  - [ ] Document known issues (non-critical)
- [ ] Performance optimization
  - [ ] Optimize database queries (add indexes if needed)
  - [ ] Lazy load components
  - [ ] Optimize images (WebP, proper sizing)
  - [ ] Code splitting for faster initial load
  - [ ] Enable caching where appropriate
- [ ] Production deployment prep
  - [ ] Final code review
  - [ ] Merge all feature branches
  - [ ] Run production build locally
  - [ ] Verify environment variables
  - [ ] Test production build
- [ ] Deploy to production
  - [ ] Deploy frontend to Vercel
  - [ ] Run database migrations on production
  - [ ] Verify Supabase production config
  - [ ] Test production deployment
- [ ] Setup monitoring
  - [ ] Vercel Analytics
  - [ ] Supabase Dashboard monitoring
  - [ ] Error tracking (Sentry)
  - [ ] Uptime monitoring
- [ ] Create rollback plan
  - [ ] Document rollback steps
  - [ ] Test rollback procedure
  - [ ] Backup production database

**Deliverables:**
- All critical bugs fixed
- Performance optimized
- Production deployment successful
- Monitoring configured
- Rollback plan ready

**Estimated Hours:** 20-24 hours

**Phase 3 Total:** 108-132 hours (~2-3 weeks for 1-2 developers)

## 5. Summary: Phase Totals

**Phase 1:** 108-132 hours (~2-3 weeks)
**Phase 2:** 100-120 hours (~2-3 weeks)
**Phase 3:** 108-132 hours (~2-3 weeks)

**Total Project:** 316-384 hours (~6-9 weeks for 1-2 developers)

---

## 6. Resource Allocation

### Team Options

**Option 1: Solo Developer (6-9 weeks)**
- Full-stack developer working 8-10 hours/day
- More affordable but longer timeline
- Suitable for bootstrap/self-funded projects

**Option 2: 2 Developers (4-6 weeks)**
- 1 Full-stack + 1 Frontend developer
- Faster delivery, better code quality
- Recommended for Phase 1 & 2
- Can work in parallel on different features

### Time Commitment Examples

**Solo Developer:**
- 8 hours/day × 45 working days = 360 hours total
- ~9 weeks calendar time

**2 Developers:**
- 8 hours/day × 2 people × 24 working days = 384 hours total
- ~5 weeks calendar time

---

## 7. Post-Launch Activities

### Week 10+: User Acceptance Testing (UAT)

**Tasks:**
- [ ] Recruit 5-10 beta testers
- [ ] Create UAT test plan
- [ ] Conduct guided testing sessions
- [ ] Collect feedback and bug reports
- [ ] Fix critical bugs
- [ ] Document known issues

**Estimated Hours:** 16-20 hours

### Staff Training & Marketing Materials

**Tasks:**
- [ ] Create staff training manual (PDF)
- [ ] How to scan QR codes and process transactions
- [ ] Troubleshooting guide
- [ ] Create customer-facing materials
  - [ ] Table tent cards with QR code
  - [ ] Posters explaining program
  - [ ] Social media graphics
- [ ] Conduct in-person staff training session
- [ ] Create owner training guide for analytics

**Estimated Hours:** 16-20 hours

### Soft Launch

**Tasks:**
- [ ] Announce launch to restaurant
- [ ] Place QR codes and posters
- [ ] On-site staff refresher training
- [ ] Monitor first transactions
- [ ] Collect initial feedback
- [ ] Track key metrics

**Estimated Hours:** 8-12 hours

---

## 8. Risk Management

### Potential Delays & Mitigation

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Supabase learning curve | 2-3 days | Medium | Study docs in advance, use tutorials |
| QR scanning issues on iOS | 1-2 days | Medium | Test early, have manual entry fallback |
| Email deliverability problems | 1 day | Low | Use SendGrid (reputable), setup SPF/DKIM |
| Referral chain logic bugs | 2-3 days | Medium | Write unit tests, test with seed data |
| Staff training takes longer | 1 day | Low | Create detailed manual, practice sessions |
| UAT reveals critical bugs | 2-3 days | Medium | Buffer time, prioritize ruthlessly |
| OCR accuracy issues | 2-3 days | Medium | Manual entry fallback, iterate later |

### Contingency Plan

If timeline slips:
1. **Cut "Should Have" features** (see MoSCoW doc)
2. **Simplify analytics** (show only basic metrics in Phase 3)
3. **Keep OCR as skeleton** (implement in future update)
4. **Reduce polish time** (ship with known minor issues)

---

## 9. Daily Standup Format

**Time:** 9:00 AM daily (15 minutes)

**Questions:**
1. What did you complete yesterday?
2. What will you work on today?
3. Any blockers or help needed?

**Example:**
- **Dev 1:** "Yesterday: Completed database schema. Today: Implementing auth. Blocker: None."
- **Dev 2:** "Yesterday: Setup React app. Today: Creating login page. Blocker: Need Supabase credentials."

---

## 10. Weekly Review & Retrospective

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

## 11. Success Metrics (Track by Phase)

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

## 12. Future Enhancements (Phase 4+)

### After Launch: Optimization (Weeks 10-14)
- **Improve OCR accuracy** (train model, better parsing)
- **Cross-restaurant functionality** (code works at multiple restaurants)
- **Advanced analytics** (more charts, custom date ranges)
- **Parameter configuration UI** (owner can adjust percentages)
- **Birthday offers automation**

### Growth Features (Months 3-6)
- **Personalized recommendations** (based on spending patterns)
- **Gamification** (badges, leaderboards, challenges)
- **Push notifications** (PWA integration)
- **Multi-language support** (Bahasa Malaysia, Chinese)
- **Restaurant discovery map** (find participating restaurants)
- **Loyalty tiers** (VIP program for top spenders)
- **Referral contests** (monthly prizes for top referrers)

---

## 13. Budget Estimate

### Development Costs (All 3 Phases)

**Freelance Rates (Malaysia):**
- Junior Developer: RM50-80/hour
- Mid-level Developer: RM100-150/hour
- Senior Developer: RM150-250/hour

**Estimated Cost (Solo Mid-level Developer):**
- 360 hours × RM125/hour = **RM45,000** (~USD 9,600)

**Estimated Cost (2 Mid-level Developers):**
- 384 hours ÷ 2 × RM125/hour = **RM24,000** (~USD 5,100 per developer)

**In-house Development:**
- Solo: RM6,000-8,000/month × 2 months = **RM12,000-16,000**
- Team of 2: RM6,000-8,000 × 2 people × 1.5 months = **RM18,000-24,000**

### Infrastructure Costs (Monthly)

**MVP (Free Tier):**
- Supabase: RM0 (free tier sufficient for 100-500 users)
- Vercel: RM0 (free tier sufficient)
- SendGrid: RM0 (free tier: 100 emails/day)
- **Total: RM0/month**

**Production (500-5,000 users):**
- Supabase Pro: RM100/month (~USD 25)
- Vercel Pro: RM80/month (~USD 20)
- SendGrid Essentials: RM60/month (~USD 15, 50K emails/month)
- **Total: RM240/month (~USD 60)**

### Marketing Costs (Pilot Launch)

- Table QR codes (50 pcs): RM200
- Posters (20 pcs): RM300
- Social media graphics: RM500 (designer)
- **Total: RM1,000**

### Total Project Budget (All 3 Phases)

- Development: RM12,000-45,000 (depending on team size)
- Infrastructure: RM0 during development (free tier)
- Marketing: RM1,000
- **Grand Total: RM13,000-46,000** (~USD 2,800-9,800)

---

## 14. Visual Timeline

```
PHASE 1: Customer Portal (Weeks 1-3)
[████████████████████] Onboarding, Dashboard, Settings, Skeletons

PHASE 2: Staff Portal (Weeks 4-6)
[████████████████████] QR Scan, Currency Mgmt, OCR, Transactions

PHASE 3: Polish & Complete (Weeks 7-9)
[████████████████████] Restaurant Dashboard, Complete Skeletons, Deploy

Post-Launch (Week 10+)
[████████████████████] UAT, Training, Launch, Monitoring

Legend:
█ = Development phase
```

---

## 15. Checklist: Ready for Launch

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

## 16. Communication Plan

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

## 17. Appendix: Task Management

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
1. Review and approve 3-phase timeline
2. Assemble development team (1-2 developers)
3. Kick off Phase 1 (Week 1, Day 1)
4. Setup daily standups and bi-weekly reviews

---

*Document updated: October 5, 2025 - Restructured to 3-phase approach per user requirements*
