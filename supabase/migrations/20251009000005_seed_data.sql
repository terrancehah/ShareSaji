-- ShareSaji Database Schema - Seed Data Migration
-- Version: 1.0
-- Date: 2025-10-09
-- Description: Sample data for testing and development

-- Note: These are test accounts with predictable UUIDs for easier testing
-- In production, use gen_random_uuid() for all new records

-- ============================================================================
-- 1. INSERT TEST RESTAURANT
-- ============================================================================

INSERT INTO restaurants (id, name, slug, description, logo_url) VALUES
('11111111-1111-1111-1111-111111111111', 'Nasi Lemak Corner', 'nasi-lemak-corner', 'Authentic Malaysian Nasi Lemak', NULL);

-- ============================================================================
-- 2. INSERT TEST BRANCHES
-- ============================================================================

INSERT INTO branches (id, restaurant_id, name, address, phone) VALUES
('22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', 'Main Branch', '123 Jalan Makan, Kuala Lumpur 50000', '+60123456789'),
('22222222-2222-2222-2222-222222222223', '11111111-1111-1111-1111-111111111111', 'KLCC Branch', '456 KLCC Avenue, Kuala Lumpur 50088', '+60123456790');

-- ============================================================================
-- 3. INSERT TEST OWNER
-- ============================================================================

-- Password: TestOwner123! (bcrypt hashed)
-- Note: In production, use proper bcrypt hashing from backend
INSERT INTO users (id, email, password_hash, email_verified, role, full_name, restaurant_id, age) VALUES
('33333333-3333-3333-3333-333333333333', 
 'owner@nasilemak.test', 
 '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 
 TRUE, 
 'owner', 
 'Test Owner', 
 '11111111-1111-1111-1111-111111111111',
 35);

-- ============================================================================
-- 4. INSERT TEST STAFF
-- ============================================================================

-- Password: TestStaff123!
INSERT INTO users (id, email, password_hash, email_verified, role, full_name, branch_id, restaurant_id, age) VALUES
('44444444-4444-4444-4444-444444444444', 
 'staff1@nasilemak.test', 
 '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 
 TRUE, 
 'staff', 
 'John Staff', 
 '22222222-2222-2222-2222-222222222222',
 '11111111-1111-1111-1111-111111111111',
 28),
('44444444-4444-4444-4444-444444444445', 
 'staff2@nasilemak.test', 
 '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 
 TRUE, 
 'staff', 
 'Mary Staff', 
 '22222222-2222-2222-2222-222222222223',
 '11111111-1111-1111-1111-111111111111',
 26);

-- ============================================================================
-- 5. INSERT TEST CUSTOMERS (Referral Chain)
-- ============================================================================

-- Customer A (Root - no upline)
-- Password: TestCustomer123!
INSERT INTO users (id, email, password_hash, email_verified, role, full_name, referral_code, birthday, age) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 
 'customer.a@test.com', 
 '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 
 TRUE, 
 'customer', 
 'Alice Customer', 
 'SAJI-AAA111', 
 '1990-01-15',
 34);

-- Customer B (Referred by A)
INSERT INTO users (id, email, password_hash, email_verified, role, full_name, referral_code, birthday, age) VALUES
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 
 'customer.b@test.com', 
 '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 
 TRUE, 
 'customer', 
 'Bob Customer', 
 'SAJI-BBB222', 
 '1995-05-20',
 29);

-- Customer C (Referred by B)
INSERT INTO users (id, email, password_hash, email_verified, role, full_name, referral_code, birthday, age) VALUES
('cccccccc-cccc-cccc-cccc-cccccccccccc', 
 'customer.c@test.com', 
 '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 
 TRUE, 
 'customer', 
 'Charlie Customer', 
 'SAJI-CCC333', 
 '2000-12-25',
 24);

-- Customer D (Referred by C)
INSERT INTO users (id, email, password_hash, email_verified, role, full_name, referral_code, birthday, age) VALUES
('dddddddd-dddd-dddd-dddd-dddddddddddd', 
 'customer.d@test.com', 
 '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 
 TRUE, 
 'customer', 
 'Diana Customer', 
 'SAJI-DDD444', 
 '1998-08-10',
 26);

-- ============================================================================
-- 6. INSERT TEST REFERRAL CHAINS (Restaurant-Specific)
-- ============================================================================

-- Chain at Nasi Lemak Corner:
-- A (root) <- B <- C <- D

-- B's uplines at restaurant
INSERT INTO referrals (downline_id, upline_id, upline_level, restaurant_id) VALUES
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 1, '11111111-1111-1111-1111-111111111111');

-- C's uplines at restaurant
INSERT INTO referrals (downline_id, upline_id, upline_level, restaurant_id) VALUES
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 1, '11111111-1111-1111-1111-111111111111'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 2, '11111111-1111-1111-1111-111111111111');

-- D's uplines at restaurant (full 3-level chain)
INSERT INTO referrals (downline_id, upline_id, upline_level, restaurant_id) VALUES
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 1, '11111111-1111-1111-1111-111111111111'),
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 2, '11111111-1111-1111-1111-111111111111'),
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 3, '11111111-1111-1111-1111-111111111111');

-- ============================================================================
-- 7. INSERT TEST TRANSACTIONS
-- ============================================================================

-- Customer A's first transaction (gets 5% discount)
INSERT INTO transactions (
  id,
  customer_id,
  branch_id,
  staff_id,
  bill_amount,
  guaranteed_discount_amount,
  virtual_currency_redeemed,
  is_first_transaction,
  transaction_date
) VALUES (
  'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  '22222222-2222-2222-2222-222222222222',
  '44444444-4444-4444-4444-444444444444',
  100.00,
  5.00,
  0.00,
  TRUE,
  NOW() - INTERVAL '10 days'
);

-- Customer B's first transaction (gets 5% discount, A earns RM1)
INSERT INTO transactions (
  id,
  customer_id,
  branch_id,
  staff_id,
  bill_amount,
  guaranteed_discount_amount,
  virtual_currency_redeemed,
  is_first_transaction,
  transaction_date
) VALUES (
  'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee1',
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  '22222222-2222-2222-2222-222222222222',
  '44444444-4444-4444-4444-444444444444',
  100.00,
  5.00,
  0.00,
  TRUE,
  NOW() - INTERVAL '8 days'
);

-- Customer C's first transaction (gets 5% discount, B earns RM1, A earns RM1)
INSERT INTO transactions (
  id,
  customer_id,
  branch_id,
  staff_id,
  bill_amount,
  guaranteed_discount_amount,
  virtual_currency_redeemed,
  is_first_transaction,
  transaction_date
) VALUES (
  'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee2',
  'cccccccc-cccc-cccc-cccc-cccccccccccc',
  '22222222-2222-2222-2222-222222222223',
  '44444444-4444-4444-4444-444444444445',
  150.00,
  7.50,
  0.00,
  TRUE,
  NOW() - INTERVAL '5 days'
);

-- ============================================================================
-- 8. INSERT TEST VIRTUAL CURRENCY LEDGER
-- ============================================================================

-- A earns from B's transaction
INSERT INTO virtual_currency_ledger (
  user_id,
  transaction_type,
  amount,
  balance_after,
  related_transaction_id,
  related_user_id,
  upline_level,
  expires_at,
  notes,
  created_at
) VALUES (
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  'earn',
  1.00,
  1.00,
  'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee1',
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  1,
  NOW() + INTERVAL '22 days',
  'Earned from downline transaction',
  NOW() - INTERVAL '8 days'
);

-- B earns from C's transaction
INSERT INTO virtual_currency_ledger (
  user_id,
  transaction_type,
  amount,
  balance_after,
  related_transaction_id,
  related_user_id,
  upline_level,
  expires_at,
  notes,
  created_at
) VALUES (
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  'earn',
  1.50,
  1.50,
  'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee2',
  'cccccccc-cccc-cccc-cccc-cccccccccccc',
  1,
  NOW() + INTERVAL '25 days',
  'Earned from downline transaction',
  NOW() - INTERVAL '5 days'
);

-- A earns from C's transaction (level 2)
INSERT INTO virtual_currency_ledger (
  user_id,
  transaction_type,
  amount,
  balance_after,
  related_transaction_id,
  related_user_id,
  upline_level,
  expires_at,
  notes,
  created_at
) VALUES (
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  'earn',
  1.50,
  2.50,
  'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee2',
  'cccccccc-cccc-cccc-cccc-cccccccccccc',
  2,
  NOW() + INTERVAL '25 days',
  'Earned from downline transaction',
  NOW() - INTERVAL '5 days'
);

-- ============================================================================
-- 9. INSERT TEST CUSTOMER RESTAURANT HISTORY
-- ============================================================================

INSERT INTO customer_restaurant_history (
  customer_id,
  restaurant_id,
  first_visit_date,
  referral_code_used,
  total_visits,
  total_spent,
  last_visit_date
) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', NOW() - INTERVAL '10 days', NULL, 1, 100.00, NOW() - INTERVAL '10 days'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '11111111-1111-1111-1111-111111111111', NOW() - INTERVAL '8 days', 'SAJI-AAA111', 1, 100.00, NOW() - INTERVAL '8 days'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', '11111111-1111-1111-1111-111111111111', NOW() - INTERVAL '5 days', 'SAJI-BBB222', 1, 150.00, NOW() - INTERVAL '5 days');

-- ============================================================================
-- 10. INSERT TEST SAVED REFERRAL CODES
-- ============================================================================

-- Customer D has saved C's code but hasn't visited yet
INSERT INTO saved_referral_codes (
  user_id,
  restaurant_id,
  referral_code,
  upline_user_id,
  is_used,
  saved_at
) VALUES (
  'dddddddd-dddd-dddd-dddd-dddddddddddd',
  '11111111-1111-1111-1111-111111111111',
  'SAJI-CCC333',
  'cccccccc-cccc-cccc-cccc-cccccccccccc',
  FALSE,
  NOW() - INTERVAL '3 days'
);

-- ============================================================================
-- SUMMARY & VERIFICATION QUERIES
-- ============================================================================

-- Check wallet balances
SELECT 
  u.full_name,
  COALESCE(cwb.current_balance, 0) as balance
FROM users u
LEFT JOIN customer_wallet_balance cwb ON cwb.user_id = u.id
WHERE u.role = 'customer'
ORDER BY u.full_name;

-- Check referral chains
SELECT 
  d.full_name as downline,
  u.full_name as upline,
  r.upline_level,
  rest.name as restaurant
FROM referrals r
JOIN users d ON d.id = r.downline_id
JOIN users u ON u.id = r.upline_id
JOIN restaurants rest ON rest.id = r.restaurant_id
ORDER BY d.full_name, r.upline_level;

-- Check transaction summary
SELECT 
  COUNT(*) as total_transactions,
  SUM(bill_amount) as total_revenue,
  SUM(total_discount) as total_discounts
FROM transactions;
