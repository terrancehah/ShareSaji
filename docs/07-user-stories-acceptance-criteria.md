# User Stories & Acceptance Criteria
## MalaChilli - MVP Requirements

**Version:** 1.0  
**Date:** 2025-09-30  
**Format:** As a [role], I want to [action], so that [benefit]

---

## 1. Customer Portal Stories

### Epic 1: Registration & Onboarding

#### US-C01: Register with Referral Code
**As a new customer**, I want to register using a referral code, so that I can get discounts and my referrer earns rewards.

**Acceptance Criteria:**
- [ ] Registration form includes email, password, birthday, age fields
- [ ] Referral code auto-filled from URL parameter (e.g., ?ref=SAJI-ABC123)
- [ ] Email verification sent after registration
- [ ] Unique referral code generated for new user (format: SAJI-XXXXX)
- [ ] Referral chain created automatically (up to 3 uplines)
- [ ] Error shown if referral code is invalid
- [ ] Password must be at least 8 characters with 1 uppercase, 1 number

**Story Points:** 8

---

#### US-C02: View My Referral Code/QR
**As a customer**, I want to view my unique referral code and QR, so that I can share it with friends.

**Acceptance Criteria:**
- [ ] Referral code displayed prominently on dashboard (e.g., SAJI-XYZ789)
- [ ] QR code generated and displayed (scannable)
- [ ] Shareable link shown (e.g., sharesaji.com/r/XYZ789)
- [ ] Copy-to-clipboard button for link (with success feedback)
- [ ] QR code downloadable as image (optional for MVP)

**Story Points:** 3

---

#### US-C03: Login to My Account
**As a returning customer**, I want to login with my email and password, so that I can access my wallet and referrals.

**Acceptance Criteria:**
- [ ] Login form with email and password fields
- [ ] "Forgot password?" link redirects to recovery page
- [ ] Successful login redirects to dashboard
- [ ] Error message shown for invalid credentials
- [ ] "Remember me" checkbox (optional for MVP)

**Story Points:** 2

---

#### US-C04: Recover Forgotten Password
**As a customer**, I want to recover my password via email, so that I can regain access if I forget it.

**Acceptance Criteria:**
- [ ] Password recovery page with email input
- [ ] Recovery email sent with magic link
- [ ] Magic link expires after 1 hour
- [ ] Clicking link allows password reset
- [ ] New password must meet strength requirements
- [ ] Success message after password reset

**Story Points:** 3

---

### Epic 2: Virtual Currency & Wallet

#### US-C05: View My Wallet Balance
**As a customer**, I want to view my current virtual currency balance, so that I know how much I can redeem.

**Acceptance Criteria:**
- [ ] Balance displayed in RM with 2 decimals (e.g., RM 15.50)
- [ ] Balance updates in real-time when downline spends
- [ ] Last updated timestamp shown
- [ ] Loading state while fetching balance
- [ ] Error message if balance fails to load

**Story Points:** 3

---

#### US-C06: View Transaction History
**As a customer**, I want to view my wallet transaction history, so that I can track my earnings and redemptions.

**Acceptance Criteria:**
- [ ] Transaction list shows last 50 transactions
- [ ] Each transaction shows:
  - [ ] Type (earn, redeem, expire)
  - [ ] Amount (+ for earn, - for redeem/expire)
  - [ ] Date/time
  - [ ] Related user (for earn: downline name)
  - [ ] Expiry date (for earn)
- [ ] Transactions sorted by date (newest first)
- [ ] Color-coded by type (green=earn, red=redeem, gray=expire)
- [ ] Pagination or infinite scroll for >50 transactions

**Story Points:** 5

---

#### US-C07: Receive Expiry Notifications
**As a customer**, I want to be notified when my virtual currency is about to expire, so that I can use it before losing it.

**Acceptance Criteria:**
- [ ] Email sent 7 days before expiry
- [ ] Email shows amount expiring and expiry date
- [ ] Email includes link to wallet page
- [ ] In-app notification badge (optional for MVP)
- [ ] Expiry date highlighted in red in wallet

**Story Points:** 5

---

### Epic 3: Referral Tracking

#### US-C08: View My Referrals
**As a customer**, I want to view who I've referred, so that I can see my network growing.

**Acceptance Criteria:**
- [ ] Referral page shows total downline count
- [ ] List of direct referrals (Level 1) with names and join dates
- [ ] Breakdown by level (Level 1, 2, 3 counts)
- [ ] Visual indicator for active vs inactive downlines
- [ ] "Share your code" button prominent on page

**Story Points:** 5

---

#### US-C09: View My Uplines
**As a customer**, I want to see who referred me, so that I understand my referral chain.

**Acceptance Criteria:**
- [ ] Upline chain displayed (up to 3 levels)
- [ ] Each upline shows name and referral code
- [ ] Visual hierarchy (Level 1 → Level 2 → Level 3)
- [ ] "You" indicator at bottom of chain
- [ ] Message if no upline (root user)

**Story Points:** 3

---

#### US-C10: Receive Earning Notifications
**As a customer**, I want to be notified when I earn virtual currency, so that I'm motivated to share more.

**Acceptance Criteria:**
- [ ] Email sent immediately when downline spends
- [ ] Email shows amount earned (e.g., "You earned RM 2.50!")
- [ ] Email shows downline name (e.g., "from John's visit")
- [ ] Email includes current balance
- [ ] Email includes link to wallet

**Story Points:** 5

---

### Epic 4: Redemption at Checkout

#### US-C11: Redeem Virtual Currency at Checkout
**As a customer**, I want to show my code/QR at checkout, so that staff can apply my discounts.

**Acceptance Criteria:**
- [ ] Dashboard has prominent "Show at Checkout" button
- [ ] Button opens full-screen QR code (easy for staff to scan)
- [ ] Code displayed below QR (for manual entry)
- [ ] Current balance shown (so customer knows what to expect)
- [ ] Screen brightness increased for better scanning

**Story Points:** 3

---

---

## 2. Staff Portal Stories

### Epic 5: Checkout & Discount Application

#### US-S01: Scan Customer QR Code
**As a staff member**, I want to scan a customer's QR code, so that I can quickly verify their account.

**Acceptance Criteria:**
- [ ] Checkout page has QR scanner (camera-based)
- [ ] Scanner activates camera on page load
- [ ] QR code decoded within 2 seconds
- [ ] Customer details fetched and displayed
- [ ] Error message if QR invalid or camera unavailable
- [ ] Manual code entry option always visible

**Story Points:** 5

---

#### US-S02: Enter Customer Code Manually
**As a staff member**, I want to manually enter a customer code, so that I can verify customers without QR scanning.

**Acceptance Criteria:**
- [ ] Manual entry field accepts code (e.g., SAJI-ABC123)
- [ ] Auto-format code as user types (uppercase, hyphen)
- [ ] Customer details fetched on Enter key or button click
- [ ] Error message if code not found
- [ ] Recent codes dropdown for quick re-entry (optional)

**Story Points:** 3

---

#### US-S03: View Customer Details at Checkout
**As a staff member**, I want to see customer details after scanning, so that I can personalize service and verify identity.

**Acceptance Criteria:**
- [ ] Customer name displayed prominently
- [ ] Virtual currency balance shown (in RM)
- [ ] First-time user indicator (e.g., badge "First Visit - 5% Off!")
- [ ] Referral code shown (for verification)
- [ ] Last visit date (optional for MVP)

**Story Points:** 2

---

#### US-S04: Calculate Discounts
**As a staff member**, I want the system to calculate discounts automatically, so that I don't make errors.

**Acceptance Criteria:**
- [ ] Bill amount input field (RM)
- [ ] Guaranteed discount auto-calculated (5% if first visit)
- [ ] Virtual currency available displayed
- [ ] Maximum redeemable calculated (20% of bill)
- [ ] Staff can select redemption amount (slider or input)
- [ ] Total discount shown (guaranteed + virtual currency)
- [ ] Final amount calculated (bill - total discount)
- [ ] All amounts formatted with RM prefix and 2 decimals

**Story Points:** 5

---

#### US-S05: Apply Discount and Record Transaction
**As a staff member**, I want to apply the discount and record the transaction, so that the customer's wallet and uplines are updated.

**Acceptance Criteria:**
- [ ] "Apply Discount" button submits transaction
- [ ] Loading state during submission
- [ ] Success message after transaction recorded
- [ ] Transaction ID shown (for reference)
- [ ] Customer's balance updated immediately
- [ ] Upline rewards distributed automatically (1% each)
- [ ] Error message if transaction fails (with retry option)

**Story Points:** 5

---

#### US-S06: Upload Receipt Photo
**As a staff member**, I want to upload a receipt photo, so that the transaction is verified and logged.

**Acceptance Criteria:**
- [ ] Camera button opens device camera
- [ ] Photo preview shown before upload
- [ ] "Retake" and "Upload" buttons
- [ ] Photo uploaded to cloud storage
- [ ] Photo URL saved with transaction
- [ ] Compression applied (max 1MB)
- [ ] Upload progress indicator

**Story Points:** 5

---

#### US-S07: View Today's Transactions
**As a staff member**, I want to view transactions I processed today, so that I can verify my work.

**Acceptance Criteria:**
- [ ] Staff dashboard shows today's stats:
  - [ ] Total transactions count
  - [ ] Total revenue (RM)
  - [ ] Total discounts given (RM)
  - [ ] New registrations facilitated
- [ ] Transaction list (last 10 transactions)
- [ ] Each transaction shows customer name, amount, discount
- [ ] Refresh button to update stats

**Story Points:** 3

---

---

## 3. Owner Portal Stories

### Epic 6: Analytics & Reporting

#### US-O01: View Overall Analytics
**As a restaurant owner**, I want to view overall program analytics, so that I can measure ROI.

**Acceptance Criteria:**
- [ ] Dashboard shows key metrics:
  - [ ] Total registered customers
  - [ ] Total transactions
  - [ ] Total revenue (RM)
  - [ ] Total discounts given (RM)
  - [ ] Net revenue (revenue - discounts)
  - [ ] Average bill amount
  - [ ] New customers (first-time transactions)
- [ ] Metrics shown for: Today, This Week, All-Time
- [ ] ROI calculation displayed (revenue increase vs discount cost)
- [ ] Visual indicators (green=positive, red=negative)

**Story Points:** 8

---

#### US-O02: View Referral Statistics
**As a restaurant owner**, I want to see referral statistics, so that I can understand virality.

**Acceptance Criteria:**
- [ ] Total registered customers count
- [ ] Average downlines per customer
- [ ] Virality coefficient (if >1, self-sustaining growth)
- [ ] Top 5 referrers list (name, referral code, downline count)
- [ ] Referral tree visualization (optional for MVP)

**Story Points:** 5

---

#### US-O03: View Transaction List
**As a restaurant owner**, I want to view all transactions, so that I can audit and analyze.

**Acceptance Criteria:**
- [ ] Paginated transaction list (20 per page)
- [ ] Each transaction shows:
  - [ ] Date/time
  - [ ] Customer name
  - [ ] Staff name
  - [ ] Branch name
  - [ ] Bill amount
  - [ ] Total discount
  - [ ] Final amount
- [ ] Search by customer name or code
- [ ] Filter by date range
- [ ] Filter by branch
- [ ] Sort by date, amount, discount

**Story Points:** 8

---

#### US-O04: View Virtual Currency Liability
**As a restaurant owner**, I want to see outstanding virtual currency balances, so that I can forecast costs.

**Acceptance Criteria:**
- [ ] Total outstanding balance across all customers (RM)
- [ ] Breakdown by expiry date (next 7 days, 8-14 days, 15-30 days)
- [ ] Projected expiry amount (will expire soon)
- [ ] Average balance per customer
- [ ] Top 10 customers by balance

**Story Points:** 5

---

#### US-O05: Manage Staff Accounts
**As a restaurant owner**, I want to manage staff accounts, so that I can control access.

**Acceptance Criteria:**
- [ ] Staff list showing name, email, branch, status
- [ ] "Add Staff" button opens form (email, name, branch, password)
- [ ] "Edit" button allows updating staff details
- [ ] "Deactivate" button disables staff login (soft-delete)
- [ ] Confirmation dialog before deactivation

**Story Points:** 5

---

#### US-O06: Manage Restaurant Branches
**As a restaurant owner**, I want to manage branches, so that I can track performance by location.

**Acceptance Criteria:**
- [ ] Branch list showing name, address, phone, status
- [ ] "Add Branch" button opens form
- [ ] "Edit" button allows updating branch details
- [ ] "Deactivate" button disables branch (soft-delete)
- [ ] Transactions filtered by branch in analytics

**Story Points:** 5

---

---

## 4. System/Technical Stories

### Epic 7: Authentication & Security

#### US-T01: Secure Password Storage
**As a system**, I want to hash passwords using bcrypt, so that user credentials are protected.

**Acceptance Criteria:**
- [ ] Passwords hashed with bcrypt (cost factor 10)
- [ ] Plaintext passwords never stored
- [ ] Password comparison uses bcrypt.compare()
- [ ] Password reset invalidates old hash

**Story Points:** 2

---

#### US-T02: Email Verification Required
**As a system**, I want to require email verification, so that only valid emails are registered.

**Acceptance Criteria:**
- [ ] Verification email sent on registration
- [ ] Email contains verification link (expires in 24 hours)
- [ ] User cannot login until email verified
- [ ] "Resend verification" option available
- [ ] Verified status stored in database

**Story Points:** 3

---

#### US-T03: Role-Based Access Control
**As a system**, I want to enforce role-based access, so that users only access authorized features.

**Acceptance Criteria:**
- [ ] Customer role: Access customer portal only
- [ ] Staff role: Access staff portal only
- [ ] Owner role: Access owner portal only
- [ ] Protected routes redirect to login if unauthorized
- [ ] API endpoints enforce RLS policies (Supabase)

**Story Points:** 3

---

### Epic 8: Referral Logic

#### US-T04: Create Referral Chain on Registration
**As a system**, I want to create referral relationships automatically, so that uplines are linked correctly.

**Acceptance Criteria:**
- [ ] On registration with referral code, call `create_referral_chain` RPC
- [ ] Level 1 upline: Direct referrer
- [ ] Level 2 upline: Referrer's upline (if exists)
- [ ] Level 3 upline: Referrer's level 2 upline (if exists)
- [ ] Maximum 3 uplines per user
- [ ] Error if referral code invalid

**Story Points:** 5

---

#### US-T05: Distribute Upline Rewards on Transaction
**As a system**, I want to distribute 1% rewards to uplines automatically, so that referrers earn passively.

**Acceptance Criteria:**
- [ ] On transaction creation, call `distribute_upline_rewards` RPC
- [ ] Each upline (up to 3) earns 1% of bill amount
- [ ] Earnings recorded in virtual_currency_ledger
- [ ] Expiry date set to 30 days from earning
- [ ] Balance updated immediately
- [ ] Earning notification email sent to each upline

**Story Points:** 5

---

#### US-T06: Redeem Virtual Currency at Checkout
**As a system**, I want to deduct virtual currency on redemption, so that balances are accurate.

**Acceptance Criteria:**
- [ ] On transaction with redemption, call `redeem_virtual_currency` RPC
- [ ] Redemption amount deducted from balance
- [ ] Redemption recorded in virtual_currency_ledger (negative amount)
- [ ] Balance cannot go negative (validation)
- [ ] Redemption capped at 20% of bill (validation)
- [ ] Error if insufficient balance

**Story Points:** 3

---

### Epic 9: Virtual Currency Expiry

#### US-T07: Expire Virtual Currency Daily
**As a system**, I want to expire virtual currency past expiry date, so that liability is controlled.

**Acceptance Criteria:**
- [ ] Cron job runs daily at 2 AM MYT
- [ ] Call `expire_virtual_currency` RPC
- [ ] All earnings past expiry date are expired
- [ ] Expiry recorded in virtual_currency_ledger (negative amount)
- [ ] Balance updated for affected users
- [ ] Expiry notification email sent to affected users

**Story Points:** 5

---

#### US-T08: Send Expiry Warning Emails
**As a system**, I want to warn users 7 days before expiry, so that they can redeem before losing balance.

**Acceptance Criteria:**
- [ ] Cron job runs daily at 9 AM MYT
- [ ] Query virtual_currency_ledger for earnings expiring in 7 days
- [ ] Send warning email to each affected user
- [ ] Email shows amount expiring and expiry date
- [ ] Email includes link to wallet page

**Story Points:** 3

---

### Epic 10: Email Notifications

#### US-T09: Send Registration Verification Email
**As a system**, I want to send verification emails on registration, so that emails are validated.

**Acceptance Criteria:**
- [ ] Email sent immediately after registration
- [ ] Email contains verification link
- [ ] Link expires after 24 hours
- [ ] Email template branded (logo, colors)
- [ ] Sender: noreply@sharesaji.com

**Story Points:** 3

---

#### US-T10: Send Earning Notification Email
**As a system**, I want to notify users when they earn, so that they're engaged.

**Acceptance Criteria:**
- [ ] Email sent when virtual_currency_ledger insert (type=earn)
- [ ] Email shows amount earned and downline name
- [ ] Email shows current balance
- [ ] Email includes link to wallet
- [ ] Email template branded

**Story Points:** 3

---

#### US-T11: Send Password Recovery Email
**As a system**, I want to send recovery emails on request, so that users can reset passwords.

**Acceptance Criteria:**
- [ ] Email sent when user requests password recovery
- [ ] Email contains magic link (expires in 1 hour)
- [ ] Link redirects to password reset page
- [ ] Email template branded

**Story Points:** 2

---

---

## 5. Non-Functional Stories

### Epic 11: Performance & Reliability

#### US-N01: Fast Page Load Times
**As a user**, I want pages to load quickly, so that I have a smooth experience.

**Acceptance Criteria:**
- [ ] Page load time <3 seconds on 4G connection
- [ ] Code splitting for routes (lazy loading)
- [ ] Images optimized (compressed, WebP format)
- [ ] API responses cached (wallet balance: 30 seconds)

**Story Points:** 3

---

#### US-N02: Responsive Design
**As a user**, I want the app to work on my phone, so that I can use it anywhere.

**Acceptance Criteria:**
- [ ] All pages responsive (mobile, tablet, desktop)
- [ ] Touch-friendly buttons (min 44px tap target)
- [ ] Readable text (min 16px font size)
- [ ] Tested on iOS Safari and Android Chrome
- [ ] No horizontal scrolling

**Story Points:** 5

---

#### US-N03: Reliable QR Scanning
**As a staff member**, I want QR scanning to work consistently, so that checkout is fast.

**Acceptance Criteria:**
- [ ] QR scanner works on iOS Safari and Android Chrome
- [ ] Scan time <2 seconds
- [ ] Manual entry fallback if camera unavailable
- [ ] Error message if QR invalid
- [ ] Camera permission requested on first use

**Story Points:** 5

---

### Epic 12: Security & Compliance

#### US-N04: PDPA Compliance
**As a user**, I want my data protected, so that my privacy is respected.

**Acceptance Criteria:**
- [ ] Privacy Policy page published
- [ ] Consent checkbox on registration
- [ ] User can request data export (via support)
- [ ] User can request account deletion (via support)
- [ ] Data encrypted in transit (HTTPS) and at rest

**Story Points:** 3

---

#### US-N05: Prevent SQL Injection
**As a system**, I want to prevent SQL injection, so that the database is secure.

**Acceptance Criteria:**
- [ ] All queries use parameterized statements (Supabase handles this)
- [ ] No raw SQL with user input
- [ ] Input validation on all forms
- [ ] XSS prevention (React auto-escapes JSX)

**Story Points:** 2

---

---

## 6. Story Point Reference

### Fibonacci Scale
- **1 point:** Trivial (e.g., change button text)
- **2 points:** Simple (e.g., add form field)
- **3 points:** Moderate (e.g., create login page)
- **5 points:** Complex (e.g., implement QR scanner)
- **8 points:** Very complex (e.g., analytics dashboard)
- **13 points:** Epic (break down into smaller stories)

### Velocity Estimate
- **2 developers × 8 hours/day = 16 hours/day**
- **Average story: 4 points = 2 hours**
- **Daily velocity: 8 stories (32 points)**
- **Sprint velocity (7 days): 56 stories (224 points)**

---

## 7. Acceptance Testing Checklist

### Manual Testing (Before UAT)
- [ ] All user stories have passing acceptance criteria
- [ ] All user flows tested end-to-end
- [ ] No critical bugs (P0/P1)
- [ ] Responsive design verified on 3+ devices
- [ ] Email notifications tested (sent and received)
- [ ] QR scanning tested on iOS and Android
- [ ] Performance tested (page load <3s)

### Automated Testing (CI/CD)
- [ ] Unit tests for utility functions (80% coverage)
- [ ] Integration tests for API calls
- [ ] Linting passes (ESLint)
- [ ] Build succeeds (no errors)

---

## 8. Definition of Done

A user story is "Done" when:
1. ✅ Code implemented and committed
2. ✅ All acceptance criteria met
3. ✅ Unit tests written and passing
4. ✅ Code reviewed and approved
5. ✅ Deployed to staging environment
6. ✅ Manually tested by developer
7. ✅ Documented (if needed)
8. ✅ Accepted by product owner

---

**Document Approval:**
- [ ] Product Owner
- [ ] Technical Lead
- [ ] QA Lead

**Next Steps:**
1. Review and approve user stories
2. Prioritize stories for Sprint 1
3. Assign stories to developers
4. Begin implementation
