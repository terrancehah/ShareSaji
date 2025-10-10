-- MalaChilli Database Schema - Initial Migration
-- Version: 1.0
-- Date: 2025-10-09
-- Description: Core tables for users, restaurants, branches, referrals, transactions, and virtual currency

-- ============================================================================
-- 1. RESTAURANTS TABLE
-- ============================================================================

CREATE TABLE restaurants (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Restaurant Details
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL, -- URL-friendly identifier (e.g., 'nasi-lemak-corner')
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

-- Indexes for restaurants
CREATE INDEX idx_restaurants_is_active ON restaurants(is_active);
CREATE INDEX idx_restaurants_slug ON restaurants(slug);

COMMENT ON TABLE restaurants IS 'Restaurant entities managed by owners';
COMMENT ON COLUMN restaurants.slug IS 'URL-friendly identifier used in referral links';
COMMENT ON COLUMN restaurants.guaranteed_discount_percent IS 'Discount given on first transaction (default 5%)';
COMMENT ON COLUMN restaurants.upline_reward_percent IS 'Percentage given to each upline (default 1%)';

-- ============================================================================
-- 2. BRANCHES TABLE
-- ============================================================================

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

-- Indexes for branches
CREATE INDEX idx_branches_restaurant_id ON branches(restaurant_id);
CREATE INDEX idx_branches_is_active ON branches(is_active);

COMMENT ON TABLE branches IS 'Physical restaurant locations';

-- ============================================================================
-- 3. USERS TABLE
-- ============================================================================

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
  referral_code VARCHAR(20) UNIQUE, -- Format: 'SAJI-' + 6 alphanumeric chars (e.g., 'SAJI-ABC123')
  
  -- Associations
  branch_id UUID REFERENCES branches(id) ON DELETE SET NULL, -- for staff only
  restaurant_id UUID REFERENCES restaurants(id) ON DELETE SET NULL, -- for staff and owners
  
  -- PDPA Compliance
  is_deleted BOOLEAN DEFAULT FALSE,
  deleted_at TIMESTAMP,
  deletion_reason TEXT,
  
  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  last_login TIMESTAMP,
  
  -- Constraints
  CONSTRAINT email_lowercase CHECK (email = LOWER(email))
);

-- Indexes for users
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_referral_code ON users(referral_code);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_restaurant_id ON users(restaurant_id);
CREATE INDEX idx_users_is_deleted ON users(is_deleted);

COMMENT ON TABLE users IS 'All user accounts with role-based access (customers, staff, owners)';
COMMENT ON COLUMN users.referral_code IS 'Unique code for customer referrals (SAJI-XXXXXX format)';
COMMENT ON COLUMN users.is_deleted IS 'Soft-delete flag for PDPA compliance';

-- ============================================================================
-- 4. REFERRALS TABLE
-- ============================================================================

CREATE TABLE referrals (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Referral Relationship
  downline_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  upline_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  upline_level INTEGER NOT NULL CHECK (upline_level IN (1, 2, 3)), -- 1=direct, 2=level 2, 3=level 3
  
  -- Restaurant Context (CRITICAL: Referrals are restaurant-specific)
  restaurant_id UUID NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
  
  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  
  -- Constraints
  UNIQUE(downline_id, upline_level, restaurant_id), -- each downline has max 1 upline per level per restaurant
  CHECK (downline_id != upline_id) -- can't refer yourself
);

-- Indexes for referrals
CREATE INDEX idx_referrals_downline_id ON referrals(downline_id);
CREATE INDEX idx_referrals_upline_id ON referrals(upline_id);
CREATE INDEX idx_referrals_restaurant_id ON referrals(restaurant_id);
CREATE INDEX idx_referrals_downline_restaurant ON referrals(downline_id, restaurant_id);
CREATE INDEX idx_referrals_upline_level ON referrals(upline_level);

COMMENT ON TABLE referrals IS 'Restaurant-specific upline-downline relationships (max 3 uplines per restaurant)';
COMMENT ON COLUMN referrals.restaurant_id IS 'Referrals are restaurant-specific - same user can have different uplines at different restaurants';

-- ============================================================================
-- 5. TRANSACTIONS TABLE
-- ============================================================================

CREATE TABLE transactions (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Transaction Details
  customer_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  branch_id UUID NOT NULL REFERENCES branches(id) ON DELETE RESTRICT,
  staff_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT, -- who processed the transaction
  
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

-- Indexes for transactions
CREATE INDEX idx_transactions_customer_id ON transactions(customer_id);
CREATE INDEX idx_transactions_branch_id ON transactions(branch_id);
CREATE INDEX idx_transactions_staff_id ON transactions(staff_id);
CREATE INDEX idx_transactions_transaction_date ON transactions(transaction_date DESC);
CREATE INDEX idx_transactions_is_first_transaction ON transactions(is_first_transaction);
CREATE INDEX idx_transactions_staff_date ON transactions(staff_id, transaction_date DESC);

COMMENT ON TABLE transactions IS 'All checkout transactions with manual entry in MVP';
COMMENT ON COLUMN transactions.total_discount IS 'Auto-calculated: guaranteed_discount + virtual_currency_redeemed';
COMMENT ON COLUMN transactions.final_amount IS 'Auto-calculated: bill_amount - total_discount';

-- ============================================================================
-- 6. VIRTUAL CURRENCY LEDGER TABLE
-- ============================================================================

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
  related_transaction_id UUID REFERENCES transactions(id) ON DELETE SET NULL, -- for earn/redeem
  related_user_id UUID REFERENCES users(id) ON DELETE SET NULL, -- for earn: the downline who spent
  upline_level INTEGER CHECK (upline_level IN (1, 2, 3)), -- for earn: which level upline
  
  -- Expiry
  expires_at TIMESTAMP, -- for earn: when this earning expires
  expired_at TIMESTAMP, -- for expire: when expiry was processed
  
  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  notes TEXT -- optional description
);

-- Indexes for virtual_currency_ledger
CREATE INDEX idx_virtual_currency_ledger_user_id ON virtual_currency_ledger(user_id);
CREATE INDEX idx_virtual_currency_ledger_transaction_type ON virtual_currency_ledger(transaction_type);
CREATE INDEX idx_virtual_currency_ledger_expires_at ON virtual_currency_ledger(expires_at);
CREATE INDEX idx_virtual_currency_ledger_related_transaction_id ON virtual_currency_ledger(related_transaction_id);
CREATE INDEX idx_ledger_expiry_check ON virtual_currency_ledger(expires_at, transaction_type) WHERE transaction_type = 'earn' AND expired_at IS NULL;

COMMENT ON TABLE virtual_currency_ledger IS 'All virtual currency events (earnings, redemptions, expiry)';
COMMENT ON COLUMN virtual_currency_ledger.balance_after IS 'Running balance after this transaction';
COMMENT ON COLUMN virtual_currency_ledger.expires_at IS 'For earn: 30 days from earning date';

-- ============================================================================
-- 7. SAVED REFERRAL CODES TABLE
-- ============================================================================

CREATE TABLE saved_referral_codes (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Who saved it
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  
  -- Where it's valid
  restaurant_id UUID NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
  
  -- The code
  referral_code VARCHAR(20) NOT NULL,
  upline_user_id UUID REFERENCES users(id) ON DELETE CASCADE, -- Derived from code lookup
  
  -- Status
  is_used BOOLEAN DEFAULT FALSE,
  used_at TIMESTAMP,
  
  -- Metadata
  saved_at TIMESTAMP DEFAULT NOW(),
  
  -- Prevent duplicates
  UNIQUE(user_id, restaurant_id, referral_code)
);

-- Indexes for saved_referral_codes
CREATE INDEX idx_saved_codes_user_restaurant ON saved_referral_codes(user_id, restaurant_id);
CREATE INDEX idx_saved_codes_is_used ON saved_referral_codes(is_used);

COMMENT ON TABLE saved_referral_codes IS 'Referral codes saved by customers but not yet used (clicked link before first visit)';
COMMENT ON COLUMN saved_referral_codes.is_used IS 'Set to TRUE when code is used during first transaction';

-- ============================================================================
-- 8. CUSTOMER RESTAURANT HISTORY TABLE
-- ============================================================================

CREATE TABLE customer_restaurant_history (
  -- Composite Primary Key
  customer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  restaurant_id UUID NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
  
  -- First Visit
  first_visit_date TIMESTAMP DEFAULT NOW(),
  referral_code_used VARCHAR(20), -- Which code they used (if any)
  
  -- Activity Stats
  total_visits INTEGER DEFAULT 1,
  total_spent DECIMAL(10,2) DEFAULT 0,
  last_visit_date TIMESTAMP DEFAULT NOW(),
  
  PRIMARY KEY (customer_id, restaurant_id)
);

-- Indexes for customer_restaurant_history
CREATE INDEX idx_customer_restaurant_history_customer ON customer_restaurant_history(customer_id);
CREATE INDEX idx_customer_restaurant_history_restaurant ON customer_restaurant_history(restaurant_id);
CREATE INDEX idx_customer_restaurant_history_first_visit ON customer_restaurant_history(first_visit_date);

COMMENT ON TABLE customer_restaurant_history IS 'Tracks customer first visit and activity per restaurant (determines guaranteed discount eligibility)';

-- ============================================================================
-- 9. EMAIL NOTIFICATIONS TABLE (Gap Fix)
-- ============================================================================

CREATE TABLE email_notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  notification_type VARCHAR(50) NOT NULL, -- 'welcome', 'earning', 'expiry_warning', 'password_reset'
  related_entity_id UUID, -- transaction_id or ledger_id
  sent_at TIMESTAMP DEFAULT NOW(),
  email_provider_id VARCHAR(255), -- SendGrid message ID
  status VARCHAR(20) DEFAULT 'sent' -- 'sent', 'delivered', 'bounced', 'failed'
);

-- Indexes for email_notifications
CREATE INDEX idx_email_notifications_user ON email_notifications(user_id);
CREATE INDEX idx_email_notifications_type ON email_notifications(notification_type);
CREATE INDEX idx_email_notifications_sent_at ON email_notifications(sent_at);

COMMENT ON TABLE email_notifications IS 'Track sent emails to prevent duplicates and monitor delivery';

-- ============================================================================
-- 10. AUDIT LOGS TABLE (Gap Fix)
-- ============================================================================

CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL, -- NULL if system action
  action VARCHAR(50) NOT NULL, -- 'user_registered', 'transaction_created', 'staff_deleted'
  entity_type VARCHAR(50), -- 'user', 'transaction', 'referral'
  entity_id UUID,
  metadata JSONB, -- Flexible data storage
  ip_address VARCHAR(45),
  user_agent TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for audit_logs
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);

COMMENT ON TABLE audit_logs IS 'Track critical actions for security and debugging';

-- ============================================================================
-- 11. SYSTEM CONFIG TABLE (Gap Fix)
-- ============================================================================

CREATE TABLE system_config (
  key VARCHAR(100) PRIMARY KEY,
  value TEXT NOT NULL,
  data_type VARCHAR(20) NOT NULL, -- 'string', 'number', 'boolean', 'json'
  description TEXT,
  updated_at TIMESTAMP DEFAULT NOW(),
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL
);

COMMENT ON TABLE system_config IS 'System-wide configuration parameters';

-- Insert default config values
INSERT INTO system_config (key, value, data_type, description) VALUES
  ('expiry_warning_days', '7', 'number', 'Days before expiry to send warning email'),
  ('min_redemption_amount', '1.00', 'number', 'Minimum RM amount for redemption'),
  ('max_referral_chain_display', '100', 'number', 'Max downlines to display in UI'),
  ('app_version', '1.0.0', 'string', 'Current application version');
