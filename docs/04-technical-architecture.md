# Technical Architecture Document
## ShareSaji - MVP System Design

**Version:** 1.0  
**Date:** 2025-09-30  
**Status:** Draft

---

## 1. Architecture Overview

### 1.1 High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Customer   │  │    Staff     │  │    Owner     │      │
│  │   Web App    │  │   Web App    │  │   Web App    │      │
│  │  (React)     │  │  (React)     │  │  (React)     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│         │                 │                  │               │
│         └─────────────────┴──────────────────┘               │
│                           │                                  │
│                    HTTPS (TLS 1.2+)                         │
└───────────────────────────┼──────────────────────────────────┘
                            │
┌───────────────────────────┼──────────────────────────────────┐
│                    API GATEWAY LAYER                         │
│                  ┌─────────────────┐                         │
│                  │  Supabase API   │                         │
│                  │  (REST + Auth)  │                         │
│                  └─────────────────┘                         │
│                           │                                  │
└───────────────────────────┼──────────────────────────────────┘
                            │
┌───────────────────────────┼──────────────────────────────────┐
│                    BACKEND SERVICES LAYER                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Auth        │  │  Database    │  │  Storage     │      │
│  │  Service     │  │  (PostgreSQL)│  │  (S3-compat) │      │
│  │  (Supabase)  │  │  (Supabase)  │  │  (Supabase)  │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐                        │
│  │  Email       │  │  Cron Jobs   │                        │
│  │  Service     │  │  (Edge Func) │                        │
│  │  (SendGrid)  │  │  (Supabase)  │                        │
│  └──────────────┘  └──────────────┘                        │
└──────────────────────────────────────────────────────────────┘
```

### 1.2 Technology Stack

#### Frontend
- **Framework:** React 18+ (with Hooks)
- **Routing:** React Router v6
- **State Management:** React Context API + useState/useReducer
- **UI Library:** Tailwind CSS (utility-first, responsive)
- **QR Code:** `react-qr-code` (generation), `html5-qrcode` (scanning)
- **HTTP Client:** Supabase JS Client (built-in fetch)
- **Build Tool:** Vite (fast dev server, optimized builds)

#### Backend
- **BaaS Platform:** Supabase (Backend-as-a-Service)
  - **Database:** PostgreSQL 15
  - **Authentication:** Supabase Auth (email/password, magic links)
  - **Storage:** Supabase Storage (receipt photos)
  - **Edge Functions:** Deno runtime (for cron jobs, future OCR)
  - **Realtime:** Supabase Realtime (for live wallet updates)

#### Infrastructure
- **Hosting:** Vercel (frontend), Supabase (backend)
- **CDN:** Vercel Edge Network (global distribution)
- **Email:** SendGrid (transactional emails)
- **Monitoring:** Vercel Analytics + Supabase Dashboard

#### Development Tools
- **Version Control:** Git + GitHub
- **Package Manager:** npm
- **Code Quality:** ESLint + Prettier
- **Testing:** Vitest (unit tests), React Testing Library

---

## 2. Frontend Architecture

### 2.1 Application Structure

```
/src
├── /components          # Reusable UI components
│   ├── /common          # Buttons, inputs, modals, etc.
│   ├── /customer        # Customer-specific components
│   ├── /staff           # Staff-specific components
│   └── /owner           # Owner-specific components
├── /pages               # Page-level components (routes)
│   ├── /customer        # Customer portal pages
│   ├── /staff           # Staff portal pages
│   └── /owner           # Owner portal pages
├── /contexts            # React Context providers
│   ├── AuthContext.jsx  # User authentication state
│   └── WalletContext.jsx # Virtual currency state
├── /hooks               # Custom React hooks
│   ├── useAuth.js       # Authentication logic
│   ├── useWallet.js     # Wallet balance logic
│   └── useQRScanner.js  # QR scanning logic
├── /services            # API service layer
│   ├── authService.js   # Auth API calls
│   ├── walletService.js # Wallet API calls
│   └── transactionService.js # Transaction API calls
├── /utils               # Utility functions
│   ├── formatCurrency.js # RM formatting
│   ├── generateReferralCode.js # Code generation
│   └── validators.js    # Form validation
├── /config              # Configuration files
│   └── supabase.js      # Supabase client setup
├── App.jsx              # Root component
└── main.jsx             # Entry point
```

### 2.2 Routing Structure

```javascript
// Customer Portal Routes
/                        → Landing page (login/register)
/register                → Registration form
/login                   → Login form
/dashboard               → Customer dashboard (wallet, referrals)
/wallet                  → Wallet details (balance, history)
/referrals               → Referral tree visualization
/share                   → Share code/QR page

// Staff Portal Routes
/staff/login             → Staff login
/staff/dashboard         → Staff dashboard (today's stats)
/staff/checkout          → Checkout flow (scan, verify, apply discount)
/staff/transactions      → Transaction history (today)

// Owner Portal Routes
/owner/login             → Owner login
/owner/dashboard         → Owner analytics dashboard
/owner/customers         → Customer list
/owner/transactions      → Transaction list
/owner/staff             → Staff management
/owner/settings          → Restaurant settings
```

### 2.3 State Management Strategy

#### Global State (Context API)
- **AuthContext:** Current user, role, login/logout functions
- **WalletContext:** Current balance, transaction history (for customers)

#### Local State (useState)
- Form inputs, UI toggles, loading states

#### Server State (Supabase Realtime)
- Wallet balance updates (when downline spends)
- Transaction notifications

### 2.4 Component Design Patterns

#### Atomic Design Approach
- **Atoms:** Button, Input, Label, Badge
- **Molecules:** FormField (Label + Input + Error), QRDisplay (QR + Copy button)
- **Organisms:** RegistrationForm, CheckoutForm, AnalyticsDashboard
- **Templates:** CustomerLayout, StaffLayout, OwnerLayout
- **Pages:** CustomerDashboard, StaffCheckout, OwnerAnalytics

---

## 3. Backend Architecture

### 3.1 Supabase Configuration

#### Database
- **PostgreSQL 15** with Row-Level Security (RLS) enabled
- **Schema:** See `03-database-schema-design.md`
- **Indexes:** Optimized for common queries (user lookup, wallet balance, referral tree)

#### Authentication
- **Email/Password:** Primary auth method
- **Email Verification:** Required before full access
- **Password Recovery:** Magic link sent via email
- **JWT Tokens:** Supabase issues JWT for API authentication

#### Storage
- **Bucket:** `receipt-photos` (public read, authenticated write)
- **File Naming:** `{transaction_id}_{timestamp}.jpg`
- **Max File Size:** 5MB per photo
- **Allowed Types:** image/jpeg, image/png

#### Edge Functions (Serverless)
1. **expire-virtual-currency** (Cron: daily at 2 AM MYT)
   - Calls `expire_virtual_currency()` stored procedure
   - Sends expiry notification emails
2. **send-earning-notification** (Triggered by database insert)
   - Sends email when user earns virtual currency
3. **send-expiry-warning** (Cron: daily at 9 AM MYT)
   - Sends email 7 days before expiry

### 3.2 API Endpoints (Supabase Auto-Generated REST API)

#### Authentication Endpoints
```
POST   /auth/v1/signup              # Register new user
POST   /auth/v1/token?grant_type=password # Login
POST   /auth/v1/recover             # Password recovery
POST   /auth/v1/verify              # Email verification
GET    /auth/v1/user                # Get current user
```

#### Database Endpoints (via Supabase REST API)
```
# Users
GET    /rest/v1/users?id=eq.{id}                    # Get user by ID
GET    /rest/v1/users?referral_code=eq.{code}      # Get user by referral code
POST   /rest/v1/users                               # Create user (after signup)
PATCH  /rest/v1/users?id=eq.{id}                    # Update user

# Referrals
GET    /rest/v1/referrals?downline_id=eq.{id}      # Get user's uplines
GET    /rest/v1/referrals?upline_id=eq.{id}        # Get user's downlines
POST   /rest/v1/referrals                           # Create referral (via stored procedure)

# Transactions
GET    /rest/v1/transactions?customer_id=eq.{id}   # Get customer's transactions
POST   /rest/v1/transactions                        # Create transaction

# Virtual Currency Ledger
GET    /rest/v1/virtual_currency_ledger?user_id=eq.{id} # Get wallet history
POST   /rest/v1/virtual_currency_ledger             # Create ledger entry (via stored procedure)

# Views
GET    /rest/v1/customer_wallet_balance?user_id=eq.{id} # Get wallet balance
GET    /rest/v1/customer_downlines?user_id=eq.{id}      # Get downline count
GET    /rest/v1/restaurant_analytics_summary?restaurant_id=eq.{id} # Get analytics
```

#### Storage Endpoints
```
POST   /storage/v1/object/receipt-photos/{filename} # Upload receipt photo
GET    /storage/v1/object/public/receipt-photos/{filename} # Get receipt photo
```

### 3.3 Database Stored Procedures (Called via RPC)

```
POST   /rest/v1/rpc/create_referral_chain          # Create referral relationships
       Body: { p_downline_id: UUID, p_referral_code: string }

POST   /rest/v1/rpc/distribute_upline_rewards      # Distribute rewards to uplines
       Body: { p_transaction_id: UUID, p_customer_id: UUID, p_bill_amount: number }

POST   /rest/v1/rpc/redeem_virtual_currency        # Redeem virtual currency
       Body: { p_user_id: UUID, p_transaction_id: UUID, p_redeem_amount: number }

POST   /rest/v1/rpc/expire_virtual_currency        # Expire balances (cron only)
       Body: {}
```

---

## 4. Data Flow Diagrams

### 4.1 Customer Registration Flow

```
┌─────────┐                ┌─────────┐                ┌──────────┐
│ Customer│                │ Frontend│                │ Supabase │
└────┬────┘                └────┬────┘                └────┬─────┘
     │                          │                          │
     │ 1. Scan QR (with         │                          │
     │    referral code)        │                          │
     ├─────────────────────────>│                          │
     │                          │                          │
     │ 2. Fill registration     │                          │
     │    form (email, pwd,     │                          │
     │    birthday, age)        │                          │
     ├─────────────────────────>│                          │
     │                          │                          │
     │                          │ 3. POST /auth/v1/signup  │
     │                          ├─────────────────────────>│
     │                          │                          │
     │                          │ 4. User created,         │
     │                          │    verification email    │
     │                          │<─────────────────────────┤
     │                          │                          │
     │ 5. Check email for       │                          │
     │    verification link     │                          │
     │<─────────────────────────┤                          │
     │                          │                          │
     │ 6. Click verification    │                          │
     │    link                  │                          │
     ├─────────────────────────>│                          │
     │                          │                          │
     │                          │ 7. POST /auth/v1/verify  │
     │                          ├─────────────────────────>│
     │                          │                          │
     │                          │ 8. Email verified        │
     │                          │<─────────────────────────┤
     │                          │                          │
     │                          │ 9. Generate referral code│
     │                          │    (SAJI-XXXXX)          │
     │                          ├─────────────────────────>│
     │                          │                          │
     │                          │ 10. Call RPC             │
     │                          │     create_referral_chain│
     │                          ├─────────────────────────>│
     │                          │                          │
     │                          │ 11. Referral chain created│
     │                          │<─────────────────────────┤
     │                          │                          │
     │ 12. Show dashboard with  │                          │
     │     QR/code to share     │                          │
     │<─────────────────────────┤                          │
```

### 4.2 Checkout & Discount Application Flow

```
┌─────────┐  ┌─────────┐  ┌─────────┐  ┌──────────┐
│Customer │  │  Staff  │  │ Frontend│  │ Supabase │
└────┬────┘  └────┬────┘  └────┬────┘  └────┬─────┘
     │            │             │             │
     │ 1. Show QR/code         │             │
     ├───────────>│             │             │
     │            │             │             │
     │            │ 2. Scan QR  │             │
     │            ├────────────>│             │
     │            │             │             │
     │            │             │ 3. GET user │
     │            │             │    by code  │
     │            │             ├────────────>│
     │            │             │             │
     │            │             │ 4. User data│
     │            │             │<────────────┤
     │            │             │             │
     │            │ 5. Display  │             │
     │            │    customer │             │
     │            │    name,    │             │
     │            │    balance, │             │
     │            │    first-use│             │
     │            │<────────────┤             │
     │            │             │             │
     │            │ 6. Enter    │             │
     │            │    bill amt │             │
     │            │    (RM100)  │             │
     │            ├────────────>│             │
     │            │             │             │
     │            │ 7. Calculate│             │
     │            │    discounts│             │
     │            │    - Guar: 5%=RM5        │
     │            │    - Max VC: 20%=RM20    │
     │            │    - Avail VC: RM3       │
     │            │<────────────┤             │
     │            │             │             │
     │            │ 8. Select   │             │
     │            │    redeem   │             │
     │            │    RM3      │             │
     │            ├────────────>│             │
     │            │             │             │
     │            │ 9. Total    │             │
     │            │    discount:│             │
     │            │    RM8      │             │
     │            │<────────────┤             │
     │            │             │             │
     │            │ 10. Apply   │             │
     │            │     discount│             │
     │            ├────────────>│             │
     │            │             │             │
     │            │             │ 11. POST    │
     │            │             │     transaction│
     │            │             ├────────────>│
     │            │             │             │
     │            │             │ 12. Call RPC│
     │            │             │     redeem_vc│
     │            │             ├────────────>│
     │            │             │             │
     │            │             │ 13. Call RPC│
     │            │             │     distribute│
     │            │             │     _rewards │
     │            │             ├────────────>│
     │            │             │             │
     │            │             │ 14. Transaction│
     │            │             │     created  │
     │            │             │<────────────┤
     │            │             │             │
     │            │ 15. Upload  │             │
     │            │     receipt │             │
     │            │     photo   │             │
     │            ├────────────>│             │
     │            │             │             │
     │            │             │ 16. POST    │
     │            │             │     storage │
     │            │             ├────────────>│
     │            │             │             │
     │            │             │ 17. Photo   │
     │            │             │     uploaded│
     │            │             │<────────────┤
     │            │             │             │
     │            │ 18. Success │             │
     │            │     message │             │
     │            │<────────────┤             │
     │            │             │             │
     │ 19. Pay    │             │             │
     │     RM92   │             │             │
     │<───────────┤             │             │
```

### 4.3 Upline Reward Distribution Flow

```
Customer C spends RM100
         │
         ├─> Upline B (Level 1) earns RM1
         │   └─> Insert into virtual_currency_ledger
         │       - user_id: B
         │       - amount: +1.00
         │       - expires_at: NOW() + 30 days
         │
         ├─> Upline A (Level 2) earns RM1
         │   └─> Insert into virtual_currency_ledger
         │       - user_id: A
         │       - amount: +1.00
         │       - expires_at: NOW() + 30 days
         │
         └─> Upline Root (Level 3) earns RM1
             └─> Insert into virtual_currency_ledger
                 - user_id: Root
                 - amount: +1.00
                 - expires_at: NOW() + 30 days
```

---

## 5. Security Architecture

### 5.1 Authentication & Authorization

#### JWT-Based Authentication
- Supabase issues JWT tokens on login
- Tokens include user ID, role, email
- Frontend stores token in localStorage (with httpOnly option if possible)
- Token expires after 1 hour (refresh token valid for 7 days)

#### Role-Based Access Control (RBAC)
```javascript
// Example: Protect owner routes
function OwnerRoute({ children }) {
  const { user } = useAuth();
  
  if (user.role !== 'owner') {
    return <Navigate to="/login" />;
  }
  
  return children;
}
```

#### Row-Level Security (RLS) Policies
- Customers can only view/edit their own data
- Staff can view customers at their branch
- Owners can view all data for their restaurant
- See `03-database-schema-design.md` for detailed policies

### 5.2 Data Protection

#### Encryption
- **In Transit:** HTTPS (TLS 1.2+) for all API calls
- **At Rest:** Supabase encrypts all data (AES-256)
- **Passwords:** Bcrypt hashed (cost factor: 10)

#### Input Validation
- **Frontend:** Client-side validation (email format, password strength, age range)
- **Backend:** Server-side validation (Supabase RLS + check constraints)
- **SQL Injection:** Prevented by parameterized queries (Supabase handles this)

#### XSS Prevention
- React auto-escapes JSX content
- Use `dangerouslySetInnerHTML` only when necessary (never for user input)

#### CSRF Prevention
- Supabase JWT tokens in Authorization header (not cookies)
- No CSRF risk for API calls

### 5.3 Privacy & Compliance (PDPA)

#### Data Collection
- **Minimal Data:** Only collect email, birthday, age (no phone, address)
- **Consent:** Checkbox during registration: "I agree to Terms & Privacy Policy"
- **Purpose:** Clearly state data usage (discounts, referrals, analytics)

#### User Rights
- **Access:** Users can view their data via dashboard
- **Deletion:** Users can request account deletion via support email
- **Portability:** Users can export their data (CSV download)

#### Data Retention
- **Active Users:** Data retained indefinitely
- **Deleted Accounts:** Soft-delete (anonymize email, keep transactions for audit)

---

## 6. Performance Optimization

### 6.1 Frontend Optimization

#### Code Splitting
- Lazy load routes: `const CustomerDashboard = lazy(() => import('./pages/CustomerDashboard'))`
- Reduces initial bundle size

#### Image Optimization
- Compress receipt photos before upload (max 1MB)
- Use WebP format if supported

#### Caching
- Cache wallet balance for 30 seconds (reduce API calls)
- Cache referral tree for 5 minutes

### 6.2 Backend Optimization

#### Database Indexing
- All foreign keys indexed
- Frequently queried columns indexed (email, referral_code, user_id)

#### Query Optimization
- Use views for complex aggregations (wallet balance, downline count)
- Avoid N+1 queries (use JOINs or batch requests)

#### Connection Pooling
- Supabase handles connection pooling automatically
- Max 60 concurrent connections on free tier

### 6.3 Monitoring & Alerting

#### Performance Metrics
- **Frontend:** Vercel Analytics (page load time, Core Web Vitals)
- **Backend:** Supabase Dashboard (query performance, error rate)

#### Error Tracking
- **Frontend:** Console errors logged to Vercel
- **Backend:** Supabase logs (database errors, function errors)

#### Alerts
- Email alert if error rate >5% (Supabase webhook to SendGrid)
- Email alert if database CPU >80% (Supabase built-in alert)

---

## 7. Deployment Architecture

### 7.1 Environments

#### Development
- **Frontend:** Local dev server (Vite)
- **Backend:** Supabase project (dev instance)
- **Database:** Separate dev database (with seed data)

#### Staging (Optional for MVP)
- **Frontend:** Vercel preview deployment (per PR)
- **Backend:** Supabase project (staging instance)
- **Database:** Copy of production schema (anonymized data)

#### Production
- **Frontend:** Vercel production deployment (main branch)
- **Backend:** Supabase project (production instance)
- **Database:** Production database (real data)

### 7.2 CI/CD Pipeline

```
┌──────────────┐
│ Git Push to  │
│ GitHub       │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ GitHub       │
│ Actions      │
│ - Lint       │
│ - Test       │
│ - Build      │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Vercel       │
│ Deploy       │
│ (automatic)  │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Production   │
│ Live         │
└──────────────┘
```

**GitHub Actions Workflow:**
```yaml
name: CI/CD
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm install
      - run: npm run lint
      - run: npm run test
      - run: npm run build
```

### 7.3 Rollback Strategy

#### Frontend Rollback
- Vercel keeps last 10 deployments
- One-click rollback via Vercel dashboard

#### Backend Rollback
- Supabase migrations are versioned
- Can revert to previous migration if needed
- Database backups retained for 7 days (free tier)

---

## 8. Scalability Considerations

### 8.1 Current Limitations (Free Tier)

#### Supabase Free Tier
- **Database:** 500MB storage, 2GB bandwidth/month
- **Storage:** 1GB files
- **Edge Functions:** 500K invocations/month
- **Realtime:** 200 concurrent connections

#### Vercel Free Tier
- **Bandwidth:** 100GB/month
- **Builds:** 6,000 minutes/month
- **Serverless Functions:** 100GB-hours/month

### 8.2 Scaling Plan (When Needed)

#### Phase 1 (100-500 users)
- Stay on free tier
- Monitor usage via dashboards

#### Phase 2 (500-5,000 users)
- Upgrade Supabase to Pro ($25/month)
  - 8GB database, 250GB bandwidth
  - Daily backups, point-in-time recovery
- Stay on Vercel free tier (sufficient)

#### Phase 3 (5,000+ users)
- Upgrade Vercel to Pro ($20/month)
- Consider read replicas for database (Supabase Enterprise)
- Add CDN for receipt photos (Cloudflare R2)

---

## 9. Disaster Recovery

### 9.1 Backup Strategy

#### Database Backups
- **Automatic:** Daily backups (Supabase, retained 7 days)
- **Manual:** Weekly CSV exports (stored in Google Drive)

#### Code Backups
- **Git:** All code in GitHub (version controlled)
- **Vercel:** Deployment history (last 10 deployments)

### 9.2 Recovery Procedures

#### Database Corruption
1. Restore from latest Supabase backup (1-click)
2. Verify data integrity (run test queries)
3. Notify users of any data loss

#### Frontend Outage
1. Check Vercel status page
2. Rollback to previous deployment if needed
3. Investigate error logs

#### Backend Outage
1. Check Supabase status page
2. Contact Supabase support if prolonged
3. Notify users via social media

---

## 10. Third-Party Integrations

### 10.1 SendGrid (Email Service)

#### Configuration
- **API Key:** Stored in Supabase Edge Function secrets
- **Sender Email:** noreply@sharesaji.com (verified domain)
- **Templates:** HTML email templates for:
  - Registration verification
  - Password recovery
  - Earning notification
  - Expiry warning

#### Email Flow
```javascript
// Example: Send earning notification
async function sendEarningNotification(userId, amount, downlineName) {
  const user = await supabase.from('users').select('email').eq('id', userId).single();
  
  await fetch('https://api.sendgrid.com/v3/mail/send', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${SENDGRID_API_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      personalizations: [{
        to: [{ email: user.email }],
        dynamic_template_data: {
          amount: amount,
          downline_name: downlineName
        }
      }],
      from: { email: 'noreply@sharesaji.com' },
      template_id: 'd-xxxxxxxxxxxxx' // SendGrid template ID
    })
  });
}
```

### 10.2 Future Integrations (Phase 2+)

#### Google Cloud Vision API (OCR)
- Extract receipt data from photos
- Confidence score for validation

#### WhatsApp Business API
- Send notifications via WhatsApp (higher engagement)

#### Google Analytics
- Track user behavior, conversion funnels

---

## 11. Development Workflow

### 11.1 Git Branching Strategy

```
main (production)
  │
  ├── develop (staging)
  │     │
  │     ├── feature/customer-registration
  │     ├── feature/staff-checkout
  │     └── feature/owner-analytics
  │
  └── hotfix/fix-wallet-calculation
```

#### Branch Naming Convention
- `feature/{feature-name}` - New features
- `bugfix/{bug-description}` - Bug fixes
- `hotfix/{critical-fix}` - Production hotfixes

### 11.2 Code Review Process

1. Developer creates feature branch
2. Implements feature with tests
3. Creates pull request (PR) to `develop`
4. Code review by team lead
5. Automated tests run (GitHub Actions)
6. Merge to `develop` after approval
7. Deploy to staging for QA
8. Merge `develop` to `main` for production

### 11.3 Testing Strategy

#### Unit Tests
- Test utility functions (formatCurrency, validators)
- Test React hooks (useAuth, useWallet)
- Coverage target: 80%

#### Integration Tests
- Test API service layer (authService, walletService)
- Mock Supabase responses

#### E2E Tests (Future)
- Test critical flows (registration, checkout)
- Use Playwright or Cypress

---

## 12. Appendix

### 12.1 Environment Variables

#### Frontend (.env)
```bash
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
VITE_APP_URL=https://sharesaji.com
```

#### Backend (Supabase Edge Function Secrets)
```bash
SENDGRID_API_KEY=SG.xxxxxxxxxxxxx
DATABASE_URL=postgresql://postgres:xxxxx@db.xxxxx.supabase.co:5432/postgres
```

### 12.2 Useful Commands

```bash
# Development
npm run dev                 # Start dev server
npm run build               # Build for production
npm run preview             # Preview production build
npm run lint                # Run ESLint
npm run test                # Run tests

# Deployment
git push origin main        # Deploy to production (auto via Vercel)
vercel --prod               # Manual deploy to production

# Database
supabase db reset           # Reset local database
supabase db push            # Push migrations to remote
supabase db pull            # Pull schema from remote
```

---

**Document Approval:**
- [ ] Technical Lead
- [ ] Frontend Developer
- [ ] Backend Developer
- [ ] DevOps Engineer

**Next Steps:**
1. Review and approve architecture
2. Setup Supabase project
3. Setup Vercel project
4. Create initial React app structure
5. Implement authentication flow
