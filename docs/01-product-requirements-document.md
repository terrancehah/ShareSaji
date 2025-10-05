# Product Requirements Document (PRD)
## ShareSaji - Viral Restaurant Discount Platform

**Version:** 1.0  
**Date:** 2025-09-30  
**Status:** Draft  
**Author:** Product Team

---

## 1. Executive Summary

### 1.1 Product Vision
ShareSaji is a web-based viral marketing platform that helps Malaysian local restaurants boost foot traffic and sales through multi-level discount sharing. Customers earn rewards by referring others, creating a self-sustaining promotional ecosystem.

### 1.2 Business Objectives
- Increase restaurant foot traffic by 30-50% within 3 months of launch
- Create viral sharing mechanism with minimal marketing spend
- Provide measurable ROI for restaurant owners through analytics
- Build a cross-restaurant network for enhanced customer value

### 1.3 Success Metrics
- **Customer Acquisition:** Number of new registrations per restaurant per week
- **Virality Coefficient:** Average downlines per user (target: >2)
- **Redemption Rate:** Percentage of earned virtual currency redeemed
- **Restaurant ROI:** Revenue increase vs discount costs (target: 3:1 ratio)
- **Retention:** Repeat visits within 30 days (target: >40%)

---

## 2. Target Users

### 2.1 Primary Users

#### Customers (End Users)
- **Demographics:** Malaysian diners, age 18-45, smartphone users
- **Behavior:** Social media active, price-conscious, enjoy sharing deals
- **Pain Points:** 
  - Limited dining discounts beyond first-time offers
  - No rewards for referring friends to restaurants
  - Discount codes expire before use
- **Goals:**
  - Save money on dining
  - Earn rewards passively through referrals
  - Easy discount redemption process

#### Restaurant Staff/Waiters
- **Demographics:** Front-line service staff, basic tech literacy
- **Pain Points:**
  - Complex promotion systems slow down service
  - Manual discount calculations prone to errors
  - No visibility into promotion effectiveness
- **Goals:**
  - Quick and easy discount verification
  - Smooth checkout process
  - Help restaurant increase sales (tips)

#### Restaurant Owners/Managers
- **Demographics:** Small to medium restaurant operators
- **Pain Points:**
  - High customer acquisition costs
  - Difficulty tracking promotion ROI
  - One-time discounts don't drive repeat visits
- **Goals:**
  - Measurable marketing ROI
  - Increased repeat customer rate
  - Data-driven promotion optimization

---

## 3. Core Features

### 3.1 Customer Portal

#### 3.1.1 Registration & Authentication
- **Email-based registration** with password
- Required fields: Email, birthday, age
- Email verification for account activation
- Login with email/password
- Password recovery via email magic link
- **Rationale:** Simple, secure, enables personalized offers and code recovery

#### 3.1.2 Personal Discount Code & Sharing
- Unique shareable code (e.g., "SAJI-ABC123") - generated on registration
- **Restaurant-specific share links:** `sharesaji.com/join/:restaurantSlug/:code`
- Example: `sharesaji.com/join/nasi-lemak-corner/SAJI-ABC123`
- Copy-to-clipboard functionality
- Social media share buttons (WhatsApp, Facebook, Instagram) with pre-filled messages
- **QR code generator** (placeholder in MVP, full implementation Phase 2)
- **Rationale:** Restaurant-specific links ensure proper attribution and fair reward distribution

#### 3.1.3 Virtual Currency Wallet
- Real-time balance display (in RM)
- Transaction history (earnings from downlines)
- Expiry date notifications (email + in-app)
- Redemption history
- Downline activity summary (total downlines, active downlines)
- **Rationale:** Transparency builds trust and encourages sharing

#### 3.1.4 Referral Tracking
- Visual referral tree (up to 3 levels deep) **per restaurant**
- Downline count (unlimited) across all restaurants
- Earnings breakdown by restaurant and downline level
- **Saved Codes Collection:** Display referral codes saved for restaurants not yet visited
- **Rationale:** Gamification motivates continued sharing; per-restaurant tracking ensures fair attribution

### 3.2 Staff/Restaurant Portal

#### 3.2.1 Code Verification at Checkout
- QR scanner (camera-based)
- Manual code entry option
- Customer details display (name, balance)
- Discount calculation interface:
  - Bill amount input
  - Guaranteed discount (5% for first use) auto-applied
  - Virtual currency redemption (up to 20% of bill)
  - Total discount preview
- Apply discount button
- **Rationale:** Streamlined checkout maintains service speed

#### 3.2.2 Transaction Recording (MVP: Manual Entry)
- Manual entry form:
  - Transaction amount
  - Customer code (auto-filled from verification)
  - Date/time (auto-captured)
  - Restaurant branch (auto-filled from staff login)
- Receipt photo upload (for future OCR processing)
- Submit transaction button
- **Rationale:** Manual entry for MVP speed; photo upload prepares for Phase 2 automation

#### 3.2.3 Basic Analytics Dashboard
- Today's transactions count and total value
- Discounts given today (total RM)
- New registrations today
- **Rationale:** Immediate feedback motivates staff promotion

### 3.3 Restaurant Owner Portal

#### 3.3.1 Advanced Analytics
- **Referral Analytics:**
  - Total registered customers
  - Referral tree visualization (top performers)
  - Average downlines per customer
  - Virality coefficient trend
- **Financial Analytics:**
  - Total revenue from program participants
  - Total discounts given (guaranteed + virtual currency)
  - Net revenue impact (revenue - discounts)
  - ROI calculation (revenue increase vs discount cost)
  - Breakdown by time period (daily, weekly, monthly)
- **Customer Analytics:**
  - New vs returning customers
  - Average spend per customer
  - Redemption rate (virtual currency used vs earned)
  - Virtual currency liability (outstanding balances)
- **Export:** CSV download for external analysis
- **Rationale:** Data-driven decision making for program optimization

#### 3.3.2 Program Configuration
- **Discount Parameters:**
  - Guaranteed discount percentage (default: 5%)
  - Upline reward percentage (default: 1% per level)
  - Maximum redemption percentage (default: 20%)
  - Virtual currency expiry days (default: 30)
- **Restaurant Details:**
  - Branch management (add/edit locations)
  - Staff account management
- **Rationale:** Flexibility to experiment and optimize based on ROI data

---

## 4. Discount & Rewards Mechanism

### 4.1 Two-Tier Discount System

#### 4.1.1 Guaranteed Discount (5%)
- **Eligibility:** First transaction **at each restaurant** (not first transaction ever)
- **Application:** Automatic at checkout when code verified
- **Amount:** 5% of current bill
- **Cost to Restaurant:** 5% per new customer's first transaction at that specific restaurant
- **Example:** RM100 bill at Restaurant A → RM5 discount → Customer pays RM95
- **Note:** Same customer can get 5% again at Restaurant B (their first visit there)

#### 4.1.2 Unguaranteed Discount (Virtual Currency)
- **Earning:** 1% of each downline's spend, distributed to up to 3 uplines
- **Redemption:** Up to 20% of current bill
- **Expiry:** 30 days from earning date (configurable)
- **No Earning Cap:** Unlimited to encourage sharing
- **Example:** 
  - Downline spends RM100 → Upline earns RM1 virtual currency
  - Upline's next bill: RM50 → Can redeem up to RM10 (20%), but only has RM1 → Redeems RM1

### 4.2 Multi-Level Rewards Structure

#### 4.2.1 Upline Limitation (Cost Control)
- Each user has **maximum 3 uplines:**
  - Level 1: Direct referrer
  - Level 2: Referrer's referrer
  - Level 3: Top-level referrer
- When a user spends, 1% goes to each upline (total 3% max)

#### 4.2.2 Downline Unlimited (Virality)
- No limit on downlines per user
- Encourages aggressive sharing

#### 4.2.3 Cost Structure Per Transaction
- **Spender's First Use:** 5% guaranteed + 3% upline rewards = **8% total cost**
- **Spender's Subsequent Uses:** 0% guaranteed + 3% upline rewards + up to 20% redeemed = **variable cost**
- **Example Scenario (all first-time users, RM100 each):**
  - Root spends: 5% cost = RM5
  - Level 1 (via Root) spends: 5% + 1% (to Root) = 6% cost = RM6
  - Level 2 (via L1) spends: 5% + 1% (to L1) + 1% (to Root) = 7% cost = RM7
  - Level 3 (via L2) spends: 5% + 1% (to L2) + 1% (to L1) + 1% (to Root) = 8% cost = RM8
  - Level 4 (via L3) spends: 5% + 1% (to L3) + 1% (to L2) + 1% (to L1) = 8% cost = RM8 (Root gets nothing)

### 4.3 Mathematical Viability
- **To accumulate RM100 virtual currency:** Downlines must spend ~RM10,000 total (at 1% rate)
- **To redeem RM100 (at 20% cap):** User must have RM500 bill
- **Expiry pressure:** Encourages redemption before large balances accumulate
- **Conclusion:** System naturally limits liability while encouraging sharing

---

## 5. Restaurant-Specific Referral Model

### 5.1 Core Principle: Fair Attribution
- **Restaurant-Specific Referral Chains:** Each restaurant builds its own referral network
- **Referral Code:** User has ONE code (`SAJI-ABC123`) but different upline chains per restaurant
- **Share Link Format:** `sharesaji.com/join/:restaurantSlug/:referralCode`
- **Cost Attribution:** Restaurant only pays for customers they acquired through their network

### 5.2 Multi-Restaurant Participation (Phase 2+)
- **Customer Journey:**
  1. Customer clicks Friend A's link for Restaurant X → Code saved
  2. Customer visits Restaurant X → Uses Friend A's code → Restaurant X acquires customer
  3. Customer clicks Friend B's link for Restaurant Y → Different code saved
  4. Customer visits Restaurant Y → Uses Friend B's code → Restaurant Y acquires customer
  5. Customer now has 2 separate upline chains (one per restaurant)

- **Virtual Currency:**
  - Earned when downlines spend at the SPECIFIC restaurant where the chain exists
  - **Global balance** (can be redeemed at any restaurant in Phase 2)
  - Restaurant pays upline rewards for transactions at their location

### 5.3 Benefits
- **For Customers:** Participate in multiple restaurant networks, earn from all
- **For Restaurants:** 
  - Only pay for their own customer acquisitions
  - Fair cost attribution per restaurant
  - Build independent referral networks
- **MVP Scope:** Launch with single restaurant; multi-restaurant support in Phase 2

---

## 6. Fraud Prevention & Risk Mitigation

### 6.1 Fraud Considerations

#### 6.1.1 Self-Referral Risk
- **Scenario:** User creates multiple accounts to refer themselves
- **Mitigation:** 
  - All earnings require real spends verified by staff at checkout
  - Self-referrals still generate actual revenue, offsetting discount costs
  - **Conclusion:** Not harmful; potentially beneficial for sales
  
#### 6.1.2 Code Reuse/Sharing
- **Scenario:** Unlimited code sharing could be abused
- **Mitigation:**
  - All transactions gated by staff verification
  - Receipt photos (future OCR) provide audit trail
  - No unique usage limits needed
  - **Conclusion:** Low risk; prioritize virality over restrictions

#### 6.1.3 Staff Collusion
- **Scenario:** Staff creates fake transactions to help friends
- **Mitigation:**
  - Receipt photo upload required (even if not OCR-processed in MVP)
  - Analytics flag unusual patterns (e.g., high discount rate per staff member)
  - Owner review of high-value transactions
  - **Conclusion:** Monitor in beta; address if patterns emerge

### 6.2 Cost Control Mechanisms
- 3-upline limit (max 3% rewards per spend)
- 20% redemption cap per transaction
- 30-day expiry on virtual currency
- Configurable parameters for owner experimentation

### 6.3 Legal & Ethical Compliance
- **Not a Pyramid Scheme:** Rewards from actual spends, not recruitment fees
- **PDPA Compliance:** Email verification, consent for data use, privacy policy
- **Terms of Service:** Clear rules on fraud, account termination rights

---

## 7. User Flows

### 7.1 Customer Journey

#### First-Time User Flow
1. **Discovery:** Staff promotes at table: "Scan QR for 5% off your bill today!"
2. **Registration:**
   - Scan table QR code → Lands on registration page
   - Enter email, password, birthday, age
   - Receive verification email → Click to verify
3. **First Discount:**
   - At checkout, show QR/code to staff
   - Staff verifies → Applies 5% discount
   - Customer pays discounted bill
4. **Sharing:**
   - Post-checkout, app prompts: "Share your code to earn rewards!"
   - Copy link or share to WhatsApp/Facebook
5. **Earning:**
   - When downline spends, receive notification: "You earned RM1 from [Name]'s visit!"
6. **Redemption:**
   - Next visit, wallet shows balance (e.g., RM5)
   - At checkout, staff applies virtual currency (up to 20% of bill)

#### Returning User Flow
1. Login with email/password
2. View wallet balance and expiry dates
3. At restaurant, show code for redemption
4. Continue sharing for more earnings

### 7.2 Staff Journey

#### Promotion Phase (Before Order)
1. Greet customers, mention promotion
2. Guide QR scan or registration if needed

#### Checkout Phase
1. Open staff portal on tablet/phone
2. Scan customer QR or enter code manually
3. Enter bill amount
4. System calculates:
   - Guaranteed discount (if first use)
   - Virtual currency available
   - Maximum redeemable (20% of bill)
5. Confirm discount application
6. Take receipt photo, upload to app
7. Manually enter transaction amount (MVP)
8. Submit transaction

### 7.3 Restaurant Owner Journey

#### Setup Phase
1. Create restaurant account
2. Add branch locations
3. Create staff accounts
4. Configure discount parameters (or use defaults)

#### Monitoring Phase
1. Login to owner portal
2. Review daily/weekly analytics:
   - New customers
   - Total revenue
   - Discount costs
   - ROI calculation
3. Adjust parameters if needed (e.g., reduce guaranteed discount to 4% if ROI low)

#### Optimization Phase
1. Export data for deeper analysis
2. Experiment with parameters
3. Train staff on best promotion practices

---

## 8. Data Requirements

### 8.1 Customer Data
- **Personal Details:**
  - Email (unique identifier, login, notifications)
  - Password (hashed)
  - Birthday (for birthday offers, future feature)
  - Age (demographics, future personalization)
  - Registration date
- **Referral Data:**
  - Unique code/QR
  - Upline references (up to 3)
  - Downline list (unlimited)
- **Wallet Data:**
  - Virtual currency balance
  - Transaction history (earnings, redemptions, expiry)
- **Privacy:** PDPA-compliant storage, consent for marketing use

### 8.2 Transaction Data (MVP: Manual Entry)
- **Core Fields:**
  - Transaction ID
  - Customer code
  - Restaurant branch ID
  - Staff ID (who processed)
  - Transaction amount (RM)
  - Guaranteed discount applied (RM)
  - Virtual currency redeemed (RM)
  - Total discount (RM)
  - Date/time
- **Receipt Photo (for future OCR):**
  - Image URL (stored in cloud storage)
  - OCR status (pending/processed/failed) - Phase 2
- **Purpose:** Analytics, fraud detection, audit trail

### 8.3 Restaurant Data
- **Restaurant Details:**
  - Restaurant name
  - Owner contact
  - Branches (name, address, contact)
- **Staff Accounts:**
  - Staff name, email, branch assignment
- **Configuration:**
  - Discount parameters (guaranteed %, upline %, redemption cap, expiry days)
- **Item Database (Phase 2):**
  - Item name, price, calories, nutritional info, dietary flags
  - For future menu display and personalization

---

## 9. Technical Requirements

### 9.1 Platform
- **Type:** Responsive web application (mobile-first design)
- **Compatibility:** iOS Safari, Android Chrome, desktop browsers
- **No Native App Required:** Web app accessible via browser, can be added to home screen (PWA)

### 9.2 Performance
- **Page Load:** <3 seconds on 4G connection
- **QR Scan:** <2 seconds to verify code
- **Uptime:** 99% availability during restaurant hours (11am-11pm MYT)

### 9.3 Security
- **Authentication:** Email/password with bcrypt hashing
- **HTTPS:** All traffic encrypted
- **Data Privacy:** PDPA-compliant, privacy policy, user consent
- **SQL Injection Prevention:** Parameterized queries (Supabase handles this)

### 9.4 Scalability (Future)
- Support 100+ restaurants
- Handle 10,000+ concurrent users
- Database optimization for referral tree queries

---

## 10. MVP Scope & Phasing

### 10.1 Phase 1: MVP (2-3 weeks) - **PRIORITY**
**Goal:** Validate core business model with single restaurant

**Must-Have Features:**
- Customer registration & login (email/password)
- Unique code/QR generation
- Virtual currency wallet (balance, history)
- Staff code verification & discount application
- **Manual transaction entry** (no OCR)
- Receipt photo upload (stored for future processing)
- Basic analytics (transaction count, revenue, discounts)
- Multi-level referral tracking (3 uplines, unlimited downlines)
- Email notifications (registration, earnings, expiry)

**Excluded from MVP:**
- AI OCR (manual entry instead)
- Detailed item database (transaction amount only)
- Cross-restaurant functionality (single restaurant)
- Advanced analytics (export, detailed breakdowns)
- Birthday offers and personalization
- Social media share buttons (copy link only)

**Success Criteria:**
- 50+ customer registrations in first 2 weeks
- Average 2+ downlines per customer
- Positive ROI (revenue increase > discount costs)

### 10.2 Phase 2: Automation & Expansion (4-6 weeks)
**Goal:** Scale to multiple restaurants with automation

**Features:**
- AI OCR for receipt processing (EasyOCR or Google Cloud Vision)
- Cross-restaurant code sharing
- Restaurant item database (CSV upload)
- Advanced analytics (export, detailed breakdowns)
- Social media share buttons
- Email marketing campaigns (birthday offers)

### 10.3 Phase 3: Optimization & Growth (Ongoing)
**Goal:** Optimize for retention and profitability

**Features:**
- Personalized offers based on spending patterns
- Gamification (badges, leaderboards)
- Restaurant discovery (find participating restaurants)
- Nutritional tracking (using item database)
- Push notifications (PWA)
- Loyalty tiers (VIP customers)

---

## 11. Open Questions & Decisions Needed

### 11.1 Business Decisions
1. **Guaranteed Discount Timing:** Should 5% apply immediately at registration, or only at first checkout? (Recommendation: First checkout to ensure real spend)
2. **Expiry Policy:** 30 days from earning, or from last activity? (Recommendation: From earning, to encourage quick redemption)
3. **Minimum Redemption:** Should there be a minimum balance to redeem (e.g., RM1)? (Recommendation: No minimum for MVP, to maximize perceived value)
4. **Staff Incentives:** Should staff earn bonuses for registrations? (Recommendation: Yes, small bonus per registration to motivate promotion)

### 11.2 Technical Decisions
1. **Backend:** Supabase vs Firebase? (Recommendation: Supabase for PostgreSQL, better for relational data like referral trees)
2. **QR Library:** Which library for QR generation? (Recommendation: `qrcode.react` for React)
3. **Email Service:** SendGrid vs AWS SES? (Recommendation: SendGrid for easier setup in MVP)
4. **Hosting:** Vercel vs Netlify? (Recommendation: Vercel for better Next.js integration if using React)

### 11.3 Design Decisions
1. **Color Scheme:** Brand colors for ShareSaji? (Recommendation: Warm, food-friendly colors like orange/red)
2. **Language:** English only, or Bahasa Malaysia support? (Recommendation: English for MVP, add BM in Phase 2)
3. **Currency Display:** Always show "RM" prefix? (Recommendation: Yes, for clarity)

---

## 12. Success Criteria & KPIs

### 12.1 MVP Success Metrics (First 4 Weeks)
- **Customer Acquisition:** 100+ registrations
- **Virality:** 50%+ of users share their code
- **Downline Ratio:** Average 2+ downlines per user
- **Redemption Rate:** 30%+ of earned virtual currency redeemed before expiry
- **Restaurant ROI:** Revenue increase of 20%+ vs discount costs
- **Retention:** 30%+ of customers return within 30 days

### 12.2 Long-Term KPIs (6 Months)
- **Network Growth:** 1,000+ registered customers across 5+ restaurants
- **Virality Coefficient:** >1.5 (self-sustaining growth)
- **Customer Lifetime Value:** 3x increase vs non-program customers
- **Restaurant Satisfaction:** 80%+ of owners rate program as "valuable"

---

## 13. Risks & Mitigation Strategies

### 13.1 Business Risks

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Low customer adoption | High | Medium | Staff training, in-restaurant marketing materials, attractive guaranteed discount |
| Poor virality (low sharing) | High | Medium | Gamification, social proof (show top referrers), email reminders |
| Negative ROI for restaurants | High | Low | Conservative default parameters (5% guaranteed, 1% upline), owner configurability |
| Customer confusion | Medium | Medium | Simple UI, staff training, FAQ section |
| High virtual currency liability | Medium | Low | 30-day expiry, 20% redemption cap, monitor analytics |

### 13.2 Technical Risks

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Slow QR scanning | Medium | Low | Optimize camera access, fallback to manual entry |
| Database performance (referral trees) | Medium | Low | Indexed queries, caching, Supabase optimization |
| Email deliverability | Medium | Medium | Use reputable service (SendGrid), SPF/DKIM setup |
| Security breach | High | Low | HTTPS, secure auth, regular security audits |

### 13.3 Operational Risks

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Staff resistance | High | Medium | Training, incentives, simple workflow |
| Manual entry errors (MVP) | Medium | High | Validation checks, receipt photo backup, owner review |
| Customer support load | Medium | Medium | Comprehensive FAQ, email support, staff as first line |

---

## 14. Appendix

### 14.1 Glossary
- **Guaranteed Discount:** 5% discount on first transaction after registration
- **Unguaranteed Discount:** Discount from virtual currency earned via referrals
- **Virtual Currency:** Redeemable balance earned from downline spends (1% per spend, up to 3 uplines)
- **Upline:** User who referred you (up to 3 levels above)
- **Downline:** User you referred (unlimited)
- **Redemption Cap:** Maximum 20% of current bill can be paid with virtual currency
- **Expiry:** Virtual currency expires 30 days after earning

### 14.2 References
- Malaysian PDPA: https://www.pdp.gov.my/
- Referral Marketing Best Practices: [Industry research]
- Restaurant Promotion ROI Studies: [Industry benchmarks]

### 14.3 Document History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-09-30 | Product Team | Initial draft based on project plan |

---

**Next Steps:**
1. Review and approve PRD with stakeholders
2. Create Technical Specification document
3. Design database schema
4. Create wireframes and user flows
5. Begin MVP development (Sprint 1)
