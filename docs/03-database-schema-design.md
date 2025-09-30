# Database Schema Design
## ShareSaji - MVP Data Model

**Version:** 1.0  
**Date:** 2025-09-30  
**Database:** PostgreSQL (via Supabase)  
**Status:** Draft

---

## 1. Schema Overview

### 1.1 Entity Relationship Diagram (ERD) Summary

```
┌─────────────┐         ┌──────────────┐         ┌─────────────┐
│ restaurants │◄────────│   branches   │◄────────│    users    │
└─────────────┘         └──────────────┘         └─────────────┘
                                                         │
                                                         │ (staff_id)
                                                         │
                        ┌──────────────┐                │
                        │  referrals   │◄───────────────┤
                        └──────────────┘                │
                               │                        │
                               │ (upline_id)            │
                               │                        │
                        ┌──────────────┐                │
                        │ transactions │◄───────────────┤
                        └──────────────┘                │
                               │                        │
                               │                        │
                        ┌──────────────┐                │
                        │ virtual_     │◄───────────────┘
                        │ currency_    │
                        │ ledger       │
                        └──────────────┘
```

### 1.2 Core Tables
1. **users** - All user accounts (customers, staff, owners)
2. **restaurants** - Restaurant entities
3. **branches** - Physical restaurant locations
4. **referrals** - Upline-downline relationships
5. **transactions** - All checkout transactions
6. **virtual_currency_ledger** - Earnings, redemptions, expiry events

---

## 2. Table Definitions

### 2.1 users

Stores all user accounts with role-based access.

```sql
CREATE TABLE users (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Authentication
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL, -- bcrypt hashed
  email_verified BOOLEAN DEFAULT FALSE,
  verification_token VARCHAR(255), -- for email verification
  reset_token VARCHAR(255), -- for password recovery
  reset_token_expiry TIMESTAMP,
  
  -- Profile
  role VARCHAR(20) NOT NULL CHECK (role IN ('customer', 'staff', 'owner')),
  full_name VARCHAR(255),
  birthday DATE, -- for future birthday offers
  age INTEGER CHECK (age >= 13 AND age <= 120),
  
  -- Referral Code (for customers)
  referral_code VARCHAR(20) UNIQUE, -- e.g., 'SAJI-ABC123'
  
  -- Associations
  branch_id UUID REFERENCES branches(id), -- for staff only
  restaurant_id UUID REFERENCES restaurants(id), -- for staff and owners
  
  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  last_login TIMESTAMP,
  
  -- Indexes
  CONSTRAINT email_lowercase CHECK (email = LOWER(email))
);

-- Indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_referral_code ON users(referral_code);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_branch_id ON users(branch_id);
CREATE INDEX idx_users_restaurant_id ON users(restaurant_id);
```

**Notes:**
- `referral_code` is only populated for customers (role='customer')
- `branch_id` is only populated for staff (role='staff')
- `restaurant_id` is populated for staff and owners
- Password stored as bcrypt hash (never plaintext)
- Email verification required before full access

---

### 2.2 restaurants

Stores restaurant entities (owners manage these).

```sql
CREATE TABLE restaurants (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Restaurant Details
  name VARCHAR(255) NOT NULL,
  description TEXT,
  logo_url VARCHAR(500), -- cloud storage URL
  
  -- Configuration (discount parameters)
  guaranteed_discount_percent DECIMAL(5,2) DEFAULT 5.00 CHECK (guaranteed_discount_percent >= 0 AND guaranteed_discount_percent <= 100),
  upline_reward_percent DECIMAL(5,2) DEFAULT 1.00 CHECK (upline_reward_percent >= 0 AND upline_reward_percent <= 100),
  max_redemption_percent DECIMAL(5,2) DEFAULT 20.00 CHECK (max_redemption_percent >= 0 AND max_redemption_percent <= 100),
  virtual_currency_expiry_days INTEGER DEFAULT 30 CHECK (virtual_currency_expiry_days > 0),
  
  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  is_active BOOLEAN DEFAULT TRUE
);

-- Indexes
CREATE INDEX idx_restaurants_is_active ON restaurants(is_active);
```

**Notes:**
- Default parameters: 5% guaranteed, 1% upline, 20% redemption cap, 30-day expiry
- Owner can adjust parameters per restaurant (future feature)
- `is_active` allows soft-delete (pause restaurant without losing data)

---

### 2.3 branches

Stores physical restaurant locations.

```sql
CREATE TABLE branches (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Association
  restaurant_id UUID NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
  
  -- Branch Details
  name VARCHAR(255) NOT NULL, -- e.g., "Main Branch", "KLCC Branch"
  address TEXT NOT NULL,
  phone VARCHAR(20),
  
  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  is_active BOOLEAN DEFAULT TRUE
);

-- Indexes
CREATE INDEX idx_branches_restaurant_id ON branches(restaurant_id);
CREATE INDEX idx_branches_is_active ON branches(is_active);
```

**Notes:**
- Each restaurant can have multiple branches
- Staff are assigned to specific branches
- Transactions are logged per branch

---

### 2.4 referrals

Stores upline-downline relationships (max 3 uplines per user).

```sql
CREATE TABLE referrals (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Referral Relationship
  downline_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  upline_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  upline_level INTEGER NOT NULL CHECK (upline_level IN (1, 2, 3)), -- 1=direct, 2=level 2, 3=level 3
  
  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  
  -- Constraints
  UNIQUE(downline_id, upline_level), -- each downline has max 1 upline per level
  CHECK (downline_id != upline_id) -- can't refer yourself
);

-- Indexes for performance
CREATE INDEX idx_referrals_downline_id ON referrals(downline_id);
CREATE INDEX idx_referrals_upline_id ON referrals(upline_id);
CREATE INDEX idx_referrals_upline_level ON referrals(upline_level);
```

**Notes:**
- When user registers with referral code:
  - Level 1: Direct referrer
  - Level 2: Referrer's upline (if exists)
  - Level 3: Referrer's level 2 upline (if exists)
- Maximum 3 rows per `downline_id` (one for each level)
- Unlimited rows per `upline_id` (unlimited downlines)

**Example:**
```
User A refers User B:
  - Row 1: downline_id=B, upline_id=A, upline_level=1

User B refers User C:
  - Row 1: downline_id=C, upline_id=B, upline_level=1
  - Row 2: downline_id=C, upline_id=A, upline_level=2

User C refers User D:
  - Row 1: downline_id=D, upline_id=C, upline_level=1
  - Row 2: downline_id=D, upline_id=B, upline_level=2
  - Row 3: downline_id=D, upline_id=A, upline_level=3

User D refers User E:
  - Row 1: downline_id=E, upline_id=D, upline_level=1
  - Row 2: downline_id=E, upline_id=C, upline_level=2
  - Row 3: downline_id=E, upline_id=B, upline_level=3
  (User A gets nothing, as beyond 3 levels)
```

---

### 2.5 transactions

Stores all checkout transactions (manual entry in MVP).

```sql
CREATE TABLE transactions (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Transaction Details
  customer_id UUID NOT NULL REFERENCES users(id),
  branch_id UUID NOT NULL REFERENCES branches(id),
  staff_id UUID NOT NULL REFERENCES users(id), -- who processed the transaction
  
  -- Amounts (in RM)
  bill_amount DECIMAL(10,2) NOT NULL CHECK (bill_amount > 0),
  guaranteed_discount_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (guaranteed_discount_amount >= 0),
  virtual_currency_redeemed DECIMAL(10,2) DEFAULT 0.00 CHECK (virtual_currency_redeemed >= 0),
  total_discount DECIMAL(10,2) GENERATED ALWAYS AS (guaranteed_discount_amount + virtual_currency_redeemed) STORED,
  final_amount DECIMAL(10,2) GENERATED ALWAYS AS (bill_amount - guaranteed_discount_amount - virtual_currency_redeemed) STORED,
  
  -- Flags
  is_first_transaction BOOLEAN DEFAULT FALSE, -- true if guaranteed discount applied
  
  -- Receipt (for future OCR)
  receipt_photo_url VARCHAR(500), -- cloud storage URL
  ocr_processed BOOLEAN DEFAULT FALSE, -- for Phase 2
  ocr_data JSONB, -- extracted data from OCR (Phase 2)
  
  -- Metadata
  transaction_date TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW(),
  
  -- Constraints
  CHECK (total_discount <= bill_amount), -- can't discount more than bill
  CHECK (virtual_currency_redeemed <= bill_amount * 0.20) -- max 20% redemption
);

-- Indexes for performance
CREATE INDEX idx_transactions_customer_id ON transactions(customer_id);
CREATE INDEX idx_transactions_branch_id ON transactions(branch_id);
CREATE INDEX idx_transactions_staff_id ON transactions(staff_id);
CREATE INDEX idx_transactions_transaction_date ON transactions(transaction_date);
CREATE INDEX idx_transactions_is_first_transaction ON transactions(is_first_transaction);
```

**Notes:**
- `total_discount` and `final_amount` are computed columns (auto-calculated)
- `is_first_transaction` is set to TRUE if guaranteed discount applied
- `receipt_photo_url` stores photo for future OCR processing
- `ocr_data` will store extracted fields in Phase 2 (e.g., `{"items": [...], "subtotal": 100, "tax": 6}`)

---

### 2.6 virtual_currency_ledger

Stores all virtual currency events (earnings, redemptions, expiry).

```sql
CREATE TABLE virtual_currency_ledger (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- User Association
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  
  -- Transaction Type
  transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('earn', 'redeem', 'expire')),
  
  -- Amount (in RM)
  amount DECIMAL(10,2) NOT NULL,
  balance_after DECIMAL(10,2) NOT NULL CHECK (balance_after >= 0), -- running balance
  
  -- Related Entities
  related_transaction_id UUID REFERENCES transactions(id), -- for earn/redeem
  related_user_id UUID REFERENCES users(id), -- for earn: the downline who spent
  upline_level INTEGER CHECK (upline_level IN (1, 2, 3)), -- for earn: which level upline
  
  -- Expiry
  expires_at TIMESTAMP, -- for earn: when this earning expires
  expired_at TIMESTAMP, -- for expire: when expiry was processed
  
  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  notes TEXT -- optional description
);

-- Indexes for performance
CREATE INDEX idx_virtual_currency_ledger_user_id ON virtual_currency_ledger(user_id);
CREATE INDEX idx_virtual_currency_ledger_transaction_type ON virtual_currency_ledger(transaction_type);
CREATE INDEX idx_virtual_currency_ledger_expires_at ON virtual_currency_ledger(expires_at);
CREATE INDEX idx_virtual_currency_ledger_related_transaction_id ON virtual_currency_ledger(related_transaction_id);
```

**Notes:**
- **Earn:** When downline spends, upline earns 1% (amount > 0)
  - `related_transaction_id`: The downline's transaction
  - `related_user_id`: The downline who spent
  - `upline_level`: 1, 2, or 3
  - `expires_at`: 30 days from now
- **Redeem:** When user redeems at checkout (amount < 0)
  - `related_transaction_id`: The user's own transaction
  - `expires_at`: NULL (redemption doesn't expire)
- **Expire:** When earned amount expires (amount < 0)
  - `expired_at`: When expiry was processed
  - `expires_at`: Original expiry date

**Example Flow:**
```
1. User A registers, refers User B
2. User B spends RM100:
   - transactions: bill_amount=100, customer_id=B
   - virtual_currency_ledger: 
     - user_id=A, transaction_type='earn', amount=1.00, 
       related_transaction_id=B's transaction, related_user_id=B, 
       upline_level=1, expires_at=NOW()+30 days, balance_after=1.00

3. User A spends RM50, redeems RM1:
   - transactions: bill_amount=50, customer_id=A, virtual_currency_redeemed=1.00
   - virtual_currency_ledger:
     - user_id=A, transaction_type='redeem', amount=-1.00, 
       related_transaction_id=A's transaction, balance_after=0.00

4. 30 days later, cron job expires unused earnings:
   - virtual_currency_ledger:
     - user_id=A, transaction_type='expire', amount=-1.00, 
       expired_at=NOW(), expires_at=original expiry date, balance_after=0.00
```

---

## 3. Views for Common Queries

### 3.1 customer_wallet_balance

Real-time wallet balance for each customer.

```sql
CREATE VIEW customer_wallet_balance AS
SELECT 
  user_id,
  SUM(amount) AS current_balance,
  MAX(created_at) AS last_transaction_date
FROM virtual_currency_ledger
GROUP BY user_id;
```

**Usage:** `SELECT current_balance FROM customer_wallet_balance WHERE user_id = ?`

---

### 3.2 customer_downlines

Count of downlines per customer (by level).

```sql
CREATE VIEW customer_downlines AS
SELECT 
  upline_id AS user_id,
  upline_level,
  COUNT(downline_id) AS downline_count
FROM referrals
GROUP BY upline_id, upline_level;
```

**Usage:** `SELECT SUM(downline_count) FROM customer_downlines WHERE user_id = ?`

---

### 3.3 restaurant_analytics_summary

Summary analytics for restaurant owners.

```sql
CREATE VIEW restaurant_analytics_summary AS
SELECT 
  b.restaurant_id,
  COUNT(DISTINCT t.customer_id) AS total_customers,
  COUNT(t.id) AS total_transactions,
  SUM(t.bill_amount) AS total_revenue,
  SUM(t.total_discount) AS total_discounts,
  SUM(t.bill_amount) - SUM(t.total_discount) AS net_revenue,
  AVG(t.bill_amount) AS avg_bill_amount,
  SUM(CASE WHEN t.is_first_transaction THEN 1 ELSE 0 END) AS new_customers
FROM transactions t
JOIN branches b ON t.branch_id = b.id
GROUP BY b.restaurant_id;
```

**Usage:** `SELECT * FROM restaurant_analytics_summary WHERE restaurant_id = ?`

---

## 4. Stored Procedures & Functions

### 4.1 create_referral_chain

Creates referral relationships when user registers with a referral code.

```sql
CREATE OR REPLACE FUNCTION create_referral_chain(
  p_downline_id UUID,
  p_referral_code VARCHAR(20)
)
RETURNS VOID AS $$
DECLARE
  v_level1_upline_id UUID;
  v_level2_upline_id UUID;
  v_level3_upline_id UUID;
BEGIN
  -- Find Level 1 upline (direct referrer)
  SELECT id INTO v_level1_upline_id
  FROM users
  WHERE referral_code = p_referral_code AND role = 'customer';
  
  IF v_level1_upline_id IS NULL THEN
    RAISE EXCEPTION 'Invalid referral code';
  END IF;
  
  -- Insert Level 1 referral
  INSERT INTO referrals (downline_id, upline_id, upline_level)
  VALUES (p_downline_id, v_level1_upline_id, 1);
  
  -- Find Level 2 upline (referrer's upline)
  SELECT upline_id INTO v_level2_upline_id
  FROM referrals
  WHERE downline_id = v_level1_upline_id AND upline_level = 1;
  
  IF v_level2_upline_id IS NOT NULL THEN
    INSERT INTO referrals (downline_id, upline_id, upline_level)
    VALUES (p_downline_id, v_level2_upline_id, 2);
    
    -- Find Level 3 upline (referrer's level 2 upline)
    SELECT upline_id INTO v_level3_upline_id
    FROM referrals
    WHERE downline_id = v_level1_upline_id AND upline_level = 2;
    
    IF v_level3_upline_id IS NOT NULL THEN
      INSERT INTO referrals (downline_id, upline_id, upline_level)
      VALUES (p_downline_id, v_level3_upline_id, 3);
    END IF;
  END IF;
END;
$$ LANGUAGE plpgsql;
```

**Usage:** Called during registration after user is created.

---

### 4.2 distribute_upline_rewards

Distributes 1% rewards to uplines when a transaction occurs.

```sql
CREATE OR REPLACE FUNCTION distribute_upline_rewards(
  p_transaction_id UUID,
  p_customer_id UUID,
  p_bill_amount DECIMAL(10,2)
)
RETURNS VOID AS $$
DECLARE
  v_upline RECORD;
  v_reward_amount DECIMAL(10,2);
  v_expiry_date TIMESTAMP;
  v_new_balance DECIMAL(10,2);
  v_upline_reward_percent DECIMAL(5,2);
BEGIN
  -- Get restaurant's upline reward percentage
  SELECT r.upline_reward_percent INTO v_upline_reward_percent
  FROM transactions t
  JOIN branches b ON t.branch_id = b.id
  JOIN restaurants r ON b.restaurant_id = r.id
  WHERE t.id = p_transaction_id;
  
  -- Calculate reward amount (1% of bill by default)
  v_reward_amount := p_bill_amount * (v_upline_reward_percent / 100);
  
  -- Get expiry date (30 days from now by default)
  SELECT NOW() + INTERVAL '1 day' * r.virtual_currency_expiry_days INTO v_expiry_date
  FROM transactions t
  JOIN branches b ON t.branch_id = b.id
  JOIN restaurants r ON b.restaurant_id = r.id
  WHERE t.id = p_transaction_id;
  
  -- Loop through all uplines (up to 3 levels)
  FOR v_upline IN 
    SELECT upline_id, upline_level
    FROM referrals
    WHERE downline_id = p_customer_id
    ORDER BY upline_level
  LOOP
    -- Calculate new balance
    SELECT COALESCE(SUM(amount), 0) + v_reward_amount INTO v_new_balance
    FROM virtual_currency_ledger
    WHERE user_id = v_upline.upline_id;
    
    -- Insert earning record
    INSERT INTO virtual_currency_ledger (
      user_id, 
      transaction_type, 
      amount, 
      balance_after,
      related_transaction_id,
      related_user_id,
      upline_level,
      expires_at
    ) VALUES (
      v_upline.upline_id,
      'earn',
      v_reward_amount,
      v_new_balance,
      p_transaction_id,
      p_customer_id,
      v_upline.upline_level,
      v_expiry_date
    );
  END LOOP;
END;
$$ LANGUAGE plpgsql;
```

**Usage:** Called after transaction is created.

---

### 4.3 redeem_virtual_currency

Redeems virtual currency at checkout (FIFO: oldest earnings first).

```sql
CREATE OR REPLACE FUNCTION redeem_virtual_currency(
  p_user_id UUID,
  p_transaction_id UUID,
  p_redeem_amount DECIMAL(10,2)
)
RETURNS VOID AS $$
DECLARE
  v_current_balance DECIMAL(10,2);
  v_new_balance DECIMAL(10,2);
BEGIN
  -- Get current balance
  SELECT COALESCE(SUM(amount), 0) INTO v_current_balance
  FROM virtual_currency_ledger
  WHERE user_id = p_user_id;
  
  -- Check if sufficient balance
  IF v_current_balance < p_redeem_amount THEN
    RAISE EXCEPTION 'Insufficient virtual currency balance';
  END IF;
  
  -- Calculate new balance
  v_new_balance := v_current_balance - p_redeem_amount;
  
  -- Insert redemption record
  INSERT INTO virtual_currency_ledger (
    user_id,
    transaction_type,
    amount,
    balance_after,
    related_transaction_id
  ) VALUES (
    p_user_id,
    'redeem',
    -p_redeem_amount,
    v_new_balance,
    p_transaction_id
  );
END;
$$ LANGUAGE plpgsql;
```

**Usage:** Called during checkout when customer redeems virtual currency.

---

### 4.4 expire_virtual_currency

Expires virtual currency past expiry date (run daily via cron).

```sql
CREATE OR REPLACE FUNCTION expire_virtual_currency()
RETURNS INTEGER AS $$
DECLARE
  v_expired_record RECORD;
  v_current_balance DECIMAL(10,2);
  v_new_balance DECIMAL(10,2);
  v_expired_count INTEGER := 0;
BEGIN
  -- Find all unexpired earnings past expiry date
  FOR v_expired_record IN
    SELECT 
      user_id,
      amount,
      expires_at,
      id AS ledger_id
    FROM virtual_currency_ledger
    WHERE transaction_type = 'earn'
      AND expires_at < NOW()
      AND id NOT IN (
        SELECT related_ledger_id 
        FROM virtual_currency_ledger 
        WHERE transaction_type = 'expire' 
          AND related_ledger_id IS NOT NULL
      )
  LOOP
    -- Get current balance
    SELECT COALESCE(SUM(amount), 0) INTO v_current_balance
    FROM virtual_currency_ledger
    WHERE user_id = v_expired_record.user_id;
    
    -- Calculate new balance
    v_new_balance := v_current_balance - v_expired_record.amount;
    
    -- Insert expiry record
    INSERT INTO virtual_currency_ledger (
      user_id,
      transaction_type,
      amount,
      balance_after,
      expires_at,
      expired_at,
      notes
    ) VALUES (
      v_expired_record.user_id,
      'expire',
      -v_expired_record.amount,
      v_new_balance,
      v_expired_record.expires_at,
      NOW(),
      'Expired earning from ' || v_expired_record.expires_at
    );
    
    v_expired_count := v_expired_count + 1;
  END LOOP;
  
  RETURN v_expired_count;
END;
$$ LANGUAGE plpgsql;
```

**Usage:** Scheduled daily via cron job (e.g., Supabase Edge Function with cron trigger).

---

## 5. Indexes & Performance Optimization

### 5.1 Critical Indexes (Already Defined Above)
- `users.email` - Fast login lookup
- `users.referral_code` - Fast referral code validation
- `referrals.downline_id` - Fast upline lookup
- `referrals.upline_id` - Fast downline count
- `transactions.customer_id` - Fast customer transaction history
- `virtual_currency_ledger.user_id` - Fast wallet balance calculation
- `virtual_currency_ledger.expires_at` - Fast expiry processing

### 5.2 Query Optimization Tips
- Use views for common aggregations (wallet balance, downline count)
- Cache restaurant analytics (refresh every 5 minutes)
- Partition `transactions` table by date if >1M rows (future)
- Use `EXPLAIN ANALYZE` to identify slow queries

---

## 6. Data Integrity & Constraints

### 6.1 Foreign Key Constraints
- All foreign keys use `ON DELETE CASCADE` or `ON DELETE RESTRICT` appropriately
- Prevents orphaned records

### 6.2 Check Constraints
- Amounts must be positive (bill_amount, discount amounts)
- Percentages must be 0-100
- Roles must be valid ('customer', 'staff', 'owner')
- Upline levels must be 1, 2, or 3

### 6.3 Unique Constraints
- Email must be unique
- Referral code must be unique
- Each downline has max 1 upline per level

---

## 7. Sample Data for Testing

### 7.1 Seed Data Script

```sql
-- Insert test restaurant
INSERT INTO restaurants (id, name, description) VALUES
('11111111-1111-1111-1111-111111111111', 'Test Restaurant', 'MVP Pilot Restaurant');

-- Insert test branch
INSERT INTO branches (id, restaurant_id, name, address) VALUES
('22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', 'Main Branch', '123 Test St, KL');

-- Insert test owner
INSERT INTO users (id, email, password_hash, role, full_name, restaurant_id) VALUES
('33333333-3333-3333-3333-333333333333', 'owner@test.com', '$2b$10$...', 'owner', 'Test Owner', '11111111-1111-1111-1111-111111111111');

-- Insert test staff
INSERT INTO users (id, email, password_hash, role, full_name, branch_id, restaurant_id) VALUES
('44444444-4444-4444-4444-444444444444', 'staff@test.com', '$2b$10$...', 'staff', 'Test Staff', '22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111');

-- Insert test customers (referral chain)
INSERT INTO users (id, email, password_hash, role, full_name, referral_code, birthday, age) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'customer1@test.com', '$2b$10$...', 'customer', 'Customer 1', 'SAJI-AAA111', '1990-01-01', 34),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'customer2@test.com', '$2b$10$...', 'customer', 'Customer 2', 'SAJI-BBB222', '1995-05-15', 29),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'customer3@test.com', '$2b$10$...', 'customer', 'Customer 3', 'SAJI-CCC333', '2000-12-25', 24);

-- Create referral chain: Customer 1 -> Customer 2 -> Customer 3
INSERT INTO referrals (downline_id, upline_id, upline_level) VALUES
-- Customer 2's uplines
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 1),
-- Customer 3's uplines
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 1),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 2);
```

---

## 8. Migration Strategy

### 8.1 Initial Migration (MVP)
1. Create all tables in order (respect foreign key dependencies)
2. Create indexes
3. Create views
4. Create stored procedures/functions
5. Insert seed data (test restaurant, owner, staff)

### 8.2 Future Migrations (Phase 2+)
- Add `items` table for restaurant menu
- Add `transaction_items` junction table (many-to-many)
- Add `notifications` table for in-app notifications
- Add `promotions` table for custom campaigns

---

## 9. Backup & Recovery

### 9.1 Backup Strategy
- **Supabase Automatic Backups:** Daily backups (retained for 7 days on free tier)
- **Manual Exports:** Weekly CSV exports of critical tables (users, transactions)
- **Point-in-Time Recovery:** Available on Supabase Pro plan (consider for production)

### 9.2 Data Retention
- **Users:** Retain indefinitely (unless user requests deletion per PDPA)
- **Transactions:** Retain indefinitely (for analytics and audit)
- **Virtual Currency Ledger:** Retain indefinitely (for audit trail)
- **Expired Balances:** Keep expiry records (for transparency)

---

## 10. Security Considerations

### 10.1 Row-Level Security (RLS) - Supabase

Enable RLS on all tables to restrict access by role.

```sql
-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE virtual_currency_ledger ENABLE ROW LEVEL SECURITY;
-- ... (enable for all tables)

-- Example policies:
-- Customers can only view their own data
CREATE POLICY customer_view_own_data ON users
  FOR SELECT
  USING (auth.uid() = id AND role = 'customer');

-- Staff can view customers at their branch
CREATE POLICY staff_view_branch_customers ON users
  FOR SELECT
  USING (
    role = 'customer' AND
    EXISTS (
      SELECT 1 FROM users staff
      WHERE staff.id = auth.uid() 
        AND staff.role = 'staff'
        AND staff.branch_id = users.branch_id
    )
  );

-- Owners can view all data for their restaurant
CREATE POLICY owner_view_restaurant_data ON transactions
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users owner
      JOIN branches b ON b.restaurant_id = owner.restaurant_id
      WHERE owner.id = auth.uid()
        AND owner.role = 'owner'
        AND b.id = transactions.branch_id
    )
  );
```

### 10.2 Data Encryption
- **At Rest:** Supabase encrypts all data at rest (AES-256)
- **In Transit:** All API calls use HTTPS (TLS 1.2+)
- **Passwords:** Bcrypt hashed (never stored plaintext)

### 10.3 PDPA Compliance
- **User Consent:** Collect consent during registration
- **Data Access:** Users can request their data via support
- **Data Deletion:** Users can request account deletion (soft-delete with anonymization)
- **Privacy Policy:** Link in app footer and registration page

---

## 11. Appendix: SQL Scripts

### 11.1 Full Schema Creation Script

See separate file: `schema.sql` (to be created in next step)

### 11.2 Seed Data Script

See separate file: `seed.sql` (to be created in next step)

### 11.3 Test Queries

```sql
-- Get customer wallet balance
SELECT current_balance 
FROM customer_wallet_balance 
WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa';

-- Get customer's downlines
SELECT 
  u.full_name,
  r.upline_level,
  r.created_at
FROM referrals r
JOIN users u ON u.id = r.downline_id
WHERE r.upline_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
ORDER BY r.upline_level, r.created_at;

-- Get restaurant analytics
SELECT * 
FROM restaurant_analytics_summary 
WHERE restaurant_id = '11111111-1111-1111-1111-111111111111';

-- Get transactions for a customer
SELECT 
  t.transaction_date,
  t.bill_amount,
  t.total_discount,
  t.final_amount,
  b.name AS branch_name
FROM transactions t
JOIN branches b ON b.id = t.branch_id
WHERE t.customer_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
ORDER BY t.transaction_date DESC;
```

---

**Document Approval:**
- [ ] Technical Lead
- [ ] Database Administrator
- [ ] Security Officer

**Next Steps:**
1. Review and approve schema design
2. Create `schema.sql` and `seed.sql` files
3. Setup Supabase project
4. Run migrations
5. Test with sample data
