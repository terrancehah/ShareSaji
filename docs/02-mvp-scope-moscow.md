# MVP Scope Definition (MoSCoW Prioritization)
## ShareSaji - Phase 1 MVP

**Version:** 1.0  
**Date:** 2025-09-30  
**Target Timeline:** 2-3 weeks  
**Target Launch:** Single restaurant pilot

---

## MoSCoW Method Overview

Features are categorized into:
- **Must Have:** Critical for MVP launch, non-negotiable
- **Should Have:** Important but not critical, can be delayed if needed
- **Could Have:** Nice to have, adds value but not essential
- **Won't Have:** Explicitly excluded from MVP, planned for future phases

---

## MUST HAVE (Critical for MVP)

### 1. Customer Features

#### 1.1 Registration & Authentication ✅
- Email/password registration
- Email verification (verification link sent)
- Login with email/password
- Password recovery via email
- Required fields: email, password, birthday, age
- **Why Must Have:** Core identity system; enables all other features

#### 1.2 Unique Referral Code/QR ✅
- Auto-generate unique code on registration (format: SAJI-XXXXX)
- Display QR code for scanning
- Display shareable link (e.g., sharesaji.com/r/XXXXX)
- Copy-to-clipboard button for link
- **Why Must Have:** Core viral mechanism; without this, no referrals possible

#### 1.3 Virtual Currency Wallet ✅
- Display current balance (in RM)
- Show transaction history:
  - Earnings from downlines (date, amount, downline name)
  - Redemptions at checkout (date, amount, restaurant)
  - Expiry events (date, amount expired)
- Display expiry dates for each earning
- **Why Must Have:** Transparency builds trust; motivates sharing

#### 1.4 Referral Tracking ✅
- Display total downline count
- Show direct downlines (Level 1) with names
- Show upline chain (who referred you, up to 3 levels)
- **Why Must Have:** Social proof; users need to see their network growing

### 2. Staff Features

#### 2.1 Code Verification at Checkout ✅
- QR code scanner (camera-based)
- Manual code entry field (fallback)
- Display customer details:
  - Name (from email prefix or profile)
  - Virtual currency balance
  - First-time user indicator (for 5% guaranteed discount)
- **Why Must Have:** Core transaction flow; without this, discounts can't be applied

#### 2.2 Discount Calculation & Application ✅
- Input field for bill amount
- Auto-calculate guaranteed discount (5% if first use)
- Display virtual currency available
- Calculate maximum redeemable (20% of bill)
- Allow staff to select redemption amount (up to max)
- Show total discount preview
- "Apply Discount" button
- **Why Must Have:** Ensures correct discount application; prevents errors

#### 2.3 Transaction Recording (Manual Entry) ✅
- Form fields:
  - Bill amount (pre-filled from discount calculation)
  - Customer code (pre-filled from verification)
  - Date/time (auto-captured)
  - Restaurant branch (auto-filled from staff login)
- Receipt photo upload (stored for future OCR)
- Submit button
- Confirmation message
- **Why Must Have:** Data for analytics and upline rewards distribution

#### 2.4 Staff Authentication ✅
- Login with staff email/password
- Branch assignment (auto-fills in transactions)
- **Why Must Have:** Security; tracks which staff processed transactions

### 3. Restaurant Owner Features

#### 3.1 Basic Analytics Dashboard ✅
- **Today's Summary:**
  - Total transactions count
  - Total revenue (RM)
  - Total discounts given (RM)
  - New registrations count
- **This Week Summary:** (same metrics)
- **All-Time Summary:** (same metrics)
- **Referral Stats:**
  - Total registered customers
  - Average downlines per customer
  - Top 5 referrers (by downline count)
- **Why Must Have:** Owner needs to see ROI to continue program

#### 3.2 Owner Authentication ✅
- Login with owner email/password
- **Why Must Have:** Security; access to sensitive business data

### 4. Backend & Infrastructure

#### 4.1 Database Schema ✅
- Users table (customers, staff, owners)
- Referrals table (upline-downline relationships)
- Transactions table (all checkouts)
- Virtual currency ledger (earnings, redemptions, expiry)
- Restaurants & branches table
- **Why Must Have:** Foundation for all data storage

#### 4.2 Referral Logic ✅
- On registration, link to upline (from referral code in URL)
- Limit to 3 uplines per user
- On transaction, distribute 1% to each upline (up to 3)
- Update virtual currency balances in real-time
- **Why Must Have:** Core business logic; defines how rewards work

#### 4.3 Expiry Logic ✅
- Set expiry date on virtual currency earning (30 days from earning)
- Daily cron job to expire balances
- Deduct expired amounts from wallet
- Log expiry events
- **Why Must Have:** Cost control; prevents unlimited liability

#### 4.4 Email Notifications ✅
- Registration verification email
- Password recovery email
- Earning notification (when downline spends)
- Expiry warning (7 days before expiry)
- **Why Must Have:** User engagement; reminds users to share and redeem

---

## SHOULD HAVE (Important but can be delayed)

### 1. Customer Features

#### 1.1 Detailed Referral Tree Visualization 🔶
- Visual tree diagram showing downlines (up to 3 levels deep)
- Click to expand/collapse branches
- **Why Should Have:** Enhances gamification, but text list is sufficient for MVP
- **Fallback:** Simple list of downlines with level indicators

#### 1.2 Earnings Breakdown by Level 🔶
- Show how much earned from Level 1, Level 2, Level 3 downlines separately
- **Why Should Have:** Interesting insight, but total balance is sufficient for MVP
- **Fallback:** Show total earnings only

### 2. Staff Features

#### 2.1 Today's Performance Summary 🔶
- Staff-specific dashboard showing:
  - Transactions processed today
  - New registrations facilitated today
- **Why Should Have:** Motivates staff, but not critical for checkout flow
- **Fallback:** Owner sees all staff performance

### 3. Owner Features

#### 3.1 Date Range Filtering 🔶
- Custom date range selector for analytics
- **Why Should Have:** Useful for analysis, but predefined periods (today/week/all-time) sufficient for MVP
- **Fallback:** Use predefined periods only

#### 3.2 Transaction List View 🔶
- Paginated list of all transactions with details
- Search/filter by customer, staff, date
- **Why Should Have:** Useful for auditing, but summary analytics sufficient for MVP
- **Fallback:** Owner can request data export if needed

#### 3.3 CSV Export 🔶
- Export transactions, customers, referrals to CSV
- **Why Should Have:** Enables external analysis, but not critical for initial validation
- **Fallback:** Manual data extraction if urgently needed

---

## COULD HAVE (Nice to have, low priority)

### 1. Customer Features

#### 1.1 Social Media Share Buttons 🟡
- Direct share to WhatsApp, Facebook, Instagram with pre-filled message
- **Why Could Have:** Copy link is sufficient; users know how to share
- **Fallback:** Copy link and paste manually

#### 1.2 Profile Editing 🟡
- Edit birthday, age, password
- **Why Could Have:** Low change frequency; can be handled via support
- **Fallback:** Contact support for changes

#### 1.3 Notification Preferences 🟡
- Toggle email notifications on/off
- **Why Could Have:** Most users want notifications; can add later if complaints
- **Fallback:** All users receive all notifications

### 2. Staff Features

#### 2.1 Transaction History View 🟡
- Staff can view their past transactions
- **Why Could Have:** Not needed for daily workflow; owner has this data
- **Fallback:** Owner provides reports if staff requests

### 3. Owner Features

#### 3.1 Staff Performance Leaderboard 🟡
- Rank staff by registrations facilitated, transactions processed
- **Why Could Have:** Gamification for staff, but manual recognition works for MVP
- **Fallback:** Owner manually reviews staff stats

#### 3.2 Parameter Configuration UI 🟡
- Web interface to adjust:
  - Guaranteed discount percentage
  - Upline reward percentage
  - Redemption cap percentage
  - Expiry days
- **Why Could Have:** Hardcoded defaults (5%, 1%, 20%, 30 days) work for MVP; can change via database if needed
- **Fallback:** Developer adjusts in database for experiments

---

## WON'T HAVE (Explicitly excluded from MVP)

### 1. AI OCR for Receipts ❌
- **Reason:** Adds complexity; manual entry is faster to build and sufficient for validation
- **Phase 2:** Implement EasyOCR or Google Cloud Vision API after MVP validation
- **MVP Alternative:** Manual transaction entry + receipt photo upload (for future processing)

### 2. Restaurant Item Database ❌
- **Reason:** Not needed for discount mechanism; adds data management overhead
- **Phase 2:** CSV upload for menu items (price, calories, nutritional info)
- **MVP Alternative:** Transaction amount only (no item-level detail)

### 3. Cross-Restaurant Functionality ❌
- **Reason:** Single restaurant pilot is sufficient to validate model
- **Phase 2:** Enable code sharing across multiple restaurants
- **MVP Alternative:** One restaurant only; codes work at that restaurant's branches

### 4. Birthday Offers & Personalization ❌
- **Reason:** Not core to viral mechanism; requires additional logic
- **Phase 2:** Automated birthday discounts, personalized offers based on spending
- **MVP Alternative:** Collect birthday data, but no automated offers yet

### 5. Advanced Gamification ❌
- **Reason:** Referral tracking is sufficient motivation for MVP
- **Phase 2:** Badges, leaderboards, achievement system
- **MVP Alternative:** Simple downline count and earnings display

### 6. Push Notifications (PWA) ❌
- **Reason:** Email notifications sufficient for MVP; PWA adds complexity
- **Phase 2:** Implement Progressive Web App with push notifications
- **MVP Alternative:** Email notifications only

### 7. Multi-Language Support ❌
- **Reason:** English is widely understood in Malaysia; adds translation overhead
- **Phase 2:** Add Bahasa Malaysia support
- **MVP Alternative:** English only

### 8. Mobile Native Apps ❌
- **Reason:** Responsive web app is sufficient; native apps require separate development
- **Phase 2:** Consider native apps if web performance is insufficient
- **MVP Alternative:** Mobile-responsive web app (works on all devices)

### 9. Payment Integration ❌
- **Reason:** Discounts applied manually at POS; no online payment needed
- **Phase 2:** Consider if adding online ordering feature
- **MVP Alternative:** Manual discount application by staff

### 10. Customer Support Chat ❌
- **Reason:** Email support is sufficient for MVP scale
- **Phase 2:** Add live chat or chatbot if support volume high
- **MVP Alternative:** Email support, FAQ page

---

## MVP Feature Summary Table

| Feature Category | Must Have | Should Have | Could Have | Won't Have |
|------------------|-----------|-------------|------------|------------|
| Customer Portal | 4 features | 2 features | 3 features | 5 features |
| Staff Portal | 4 features | 1 feature | 1 feature | 0 features |
| Owner Portal | 2 features | 3 features | 2 features | 0 features |
| Backend/Infrastructure | 4 systems | 0 systems | 0 systems | 5 systems |
| **Total** | **14 critical** | **6 important** | **6 nice-to-have** | **10 excluded** |

---

## Development Priority Order

### Sprint 1 (Week 1): Foundation
1. Database schema setup (Supabase)
2. User authentication (customers, staff, owners)
3. Referral code generation & QR display
4. Basic customer portal UI

### Sprint 2 (Week 2): Core Transactions
1. Staff code verification interface
2. Discount calculation logic
3. Manual transaction entry
4. Virtual currency distribution to uplines
5. Wallet display with transaction history

### Sprint 3 (Week 3): Analytics & Polish
1. Owner analytics dashboard
2. Email notifications (registration, earnings, expiry)
3. Expiry logic (cron job)
4. UI polish and responsive design
5. Testing and bug fixes

### Sprint 4 (Week 4): Pilot Launch
1. Deploy to production
2. Train restaurant staff
3. Create marketing materials (table QR codes, posters)
4. Monitor analytics and gather feedback

---

## Success Criteria for MVP

### Functional Completeness
- ✅ All "Must Have" features implemented and tested
- ✅ All user flows work end-to-end (registration → sharing → earning → redemption)
- ✅ No critical bugs blocking core functionality

### Performance
- ✅ Page load time <3 seconds on 4G
- ✅ QR scan/code verification <2 seconds
- ✅ Transaction submission <1 second

### Usability
- ✅ Staff can process checkout in <2 minutes (including registration)
- ✅ Customers can register in <1 minute
- ✅ Owner can view analytics without training

### Business Validation
- ✅ 50+ customer registrations in first 2 weeks
- ✅ 30%+ of customers share their code
- ✅ Average 1.5+ downlines per customer (virality starting)
- ✅ Positive ROI for restaurant (revenue increase > discount costs)

---

## Risk Mitigation for Scope Creep

### Rules for Adding Features During MVP
1. **No new features** unless critical bug or missing core functionality
2. **Document all "nice-to-have" requests** for Phase 2 backlog
3. **Owner approval required** for any scope changes
4. **Focus on launch date:** Better to launch with 80% polish than delay for 100%

### Red Flags (Stop and Reassess)
- Development extends beyond 3 weeks
- "Must Have" features being cut
- Team spending >1 day on "Could Have" features
- Scope expanding beyond single restaurant pilot

---

## Post-MVP Roadmap Preview

### Phase 2: Automation & Scale (Weeks 5-10)
- AI OCR for receipt processing
- Cross-restaurant code sharing
- Restaurant item database (CSV upload)
- Advanced analytics (date range, export, transaction list)
- Social media share buttons

### Phase 3: Optimization (Weeks 11-16)
- Birthday offers automation
- Personalized recommendations
- Gamification (badges, leaderboards)
- Parameter configuration UI for owners
- Push notifications (PWA)

### Phase 4: Growth (Months 5-6)
- Multi-language support (Bahasa Malaysia)
- Restaurant discovery map
- Nutritional tracking
- Loyalty tiers (VIP program)
- Referral contests and campaigns

---

## Appendix: Decision Log

### Why Manual Entry Instead of OCR for MVP?
**Decision:** Manual transaction entry in MVP, OCR in Phase 2  
**Rationale:**
- OCR adds 1-2 weeks development time (integration, testing, error handling)
- OCR accuracy not 100%; requires fallback to manual entry anyway
- Manual entry validates business model without technical complexity
- Receipt photos still uploaded for future processing
- Faster MVP launch = faster validation

**Trade-off:** Staff spend ~30 seconds per transaction on manual entry  
**Mitigation:** Simple form with auto-filled fields; acceptable for pilot scale

### Why Single Restaurant for MVP?
**Decision:** Launch with one restaurant, add cross-restaurant in Phase 2  
**Rationale:**
- Simpler data model (no restaurant switching logic)
- Easier to train staff and gather feedback
- Validates core referral mechanism without network complexity
- Faster iteration based on single restaurant's data

**Trade-off:** Less attractive value proposition (can't earn/redeem everywhere)  
**Mitigation:** Emphasize "coming soon" to more restaurants; focus on single restaurant's community

### Why No Parameter Configuration UI?
**Decision:** Hardcode defaults (5%, 1%, 20%, 30 days), adjust via database if needed  
**Rationale:**
- Saves 2-3 days development time
- Owner unlikely to change parameters frequently in MVP
- Can add UI in Phase 2 after understanding which parameters need adjustment

**Trade-off:** Owner can't self-serve parameter changes  
**Mitigation:** Developer can adjust in database within 1 hour if owner requests

---

**Document Approval:**
- [ ] Product Owner
- [ ] Technical Lead
- [ ] Restaurant Owner (Pilot Partner)

**Next Steps:**
1. Review and approve scope with stakeholders
2. Create detailed technical specification
3. Design database schema
4. Begin Sprint 1 development
