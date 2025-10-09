-- ShareSaji Database Schema - Views Migration
-- Version: 1.0
-- Date: 2025-10-09
-- Description: Helper views for common queries (wallet balance, downlines, analytics)

-- ============================================================================
-- 1. CUSTOMER WALLET BALANCE VIEW
-- ============================================================================

CREATE VIEW customer_wallet_balance AS
SELECT 
  user_id,
  SUM(amount) AS current_balance,
  MAX(created_at) AS last_transaction_date
FROM virtual_currency_ledger
GROUP BY user_id;

COMMENT ON VIEW customer_wallet_balance IS 'Real-time wallet balance for each customer';

-- Usage: SELECT current_balance FROM customer_wallet_balance WHERE user_id = ?

-- ============================================================================
-- 2. CUSTOMER DOWNLINES VIEW
-- ============================================================================

CREATE VIEW customer_downlines AS
SELECT 
  upline_id AS user_id,
  restaurant_id,
  upline_level,
  COUNT(downline_id) AS downline_count
FROM referrals
GROUP BY upline_id, restaurant_id, upline_level;

COMMENT ON VIEW customer_downlines IS 'Count of downlines per customer by level and restaurant';

-- Usage: SELECT SUM(downline_count) FROM customer_downlines WHERE user_id = ? AND restaurant_id = ?

-- ============================================================================
-- 3. RESTAURANT ANALYTICS SUMMARY VIEW
-- ============================================================================

CREATE VIEW restaurant_analytics_summary AS
SELECT 
  b.restaurant_id,
  COUNT(DISTINCT t.customer_id) AS total_customers,
  COUNT(t.id) AS total_transactions,
  SUM(t.bill_amount) AS total_revenue,
  SUM(t.total_discount) AS total_discounts,
  SUM(t.bill_amount) - SUM(t.total_discount) AS net_revenue,
  AVG(t.bill_amount) AS avg_bill_amount,
  SUM(CASE WHEN t.is_first_transaction THEN 1 ELSE 0 END) AS new_customers,
  MAX(t.transaction_date) AS last_transaction_date
FROM transactions t
JOIN branches b ON t.branch_id = b.id
GROUP BY b.restaurant_id;

COMMENT ON VIEW restaurant_analytics_summary IS 'Summary analytics for restaurant owners';

-- Usage: SELECT * FROM restaurant_analytics_summary WHERE restaurant_id = ?

-- ============================================================================
-- 4. CUSTOMER VIRTUAL CURRENCY EXPIRY VIEW
-- ============================================================================

CREATE VIEW customer_expiring_balance AS
SELECT 
  vcl.user_id,
  u.email,
  u.full_name,
  SUM(vcl.amount) AS expiring_amount,
  MIN(vcl.expires_at) AS earliest_expiry_date
FROM virtual_currency_ledger vcl
JOIN users u ON u.id = vcl.user_id
WHERE vcl.transaction_type = 'earn'
  AND vcl.expired_at IS NULL
  AND vcl.expires_at <= NOW() + INTERVAL '7 days'
GROUP BY vcl.user_id, u.email, u.full_name
HAVING SUM(vcl.amount) > 0;

COMMENT ON VIEW customer_expiring_balance IS 'Customers with virtual currency expiring within 7 days (for email notifications)';

-- Usage: SELECT * FROM customer_expiring_balance (for cron job)

-- ============================================================================
-- 5. STAFF DAILY STATS VIEW
-- ============================================================================

CREATE VIEW staff_daily_stats AS
SELECT 
  t.staff_id,
  DATE(t.transaction_date) AS transaction_date,
  COUNT(t.id) AS transactions_count,
  SUM(t.bill_amount) AS total_revenue,
  SUM(t.total_discount) AS total_discounts,
  SUM(t.final_amount) AS net_revenue,
  SUM(CASE WHEN t.is_first_transaction THEN 1 ELSE 0 END) AS new_customers_acquired
FROM transactions t
GROUP BY t.staff_id, DATE(t.transaction_date);

COMMENT ON VIEW staff_daily_stats IS 'Daily performance stats for staff members';

-- Usage: SELECT * FROM staff_daily_stats WHERE staff_id = ? AND transaction_date = CURRENT_DATE

-- ============================================================================
-- 6. CUSTOMER REFERRAL TREE VIEW
-- ============================================================================

CREATE VIEW customer_referral_tree AS
SELECT 
  r.downline_id,
  r.upline_id,
  r.upline_level,
  r.restaurant_id,
  r.created_at,
  u_upline.full_name AS upline_name,
  u_upline.referral_code AS upline_code,
  u_downline.full_name AS downline_name,
  u_downline.referral_code AS downline_code,
  rest.name AS restaurant_name
FROM referrals r
JOIN users u_upline ON u_upline.id = r.upline_id
JOIN users u_downline ON u_downline.id = r.downline_id
JOIN restaurants rest ON rest.id = r.restaurant_id;

COMMENT ON VIEW customer_referral_tree IS 'Detailed referral relationships with user and restaurant info';

-- Usage: SELECT * FROM customer_referral_tree WHERE upline_id = ? ORDER BY upline_level

-- ============================================================================
-- 7. BRANCH PERFORMANCE VIEW
-- ============================================================================

CREATE VIEW branch_performance AS
SELECT 
  b.id AS branch_id,
  b.name AS branch_name,
  b.restaurant_id,
  r.name AS restaurant_name,
  COUNT(t.id) AS total_transactions,
  SUM(t.bill_amount) AS total_revenue,
  SUM(t.total_discount) AS total_discounts,
  SUM(t.final_amount) AS net_revenue,
  AVG(t.bill_amount) AS avg_bill_amount,
  COUNT(DISTINCT t.customer_id) AS unique_customers,
  COUNT(DISTINCT t.staff_id) AS active_staff
FROM branches b
JOIN restaurants r ON r.id = b.restaurant_id
LEFT JOIN transactions t ON t.branch_id = b.id
WHERE b.is_active = TRUE
GROUP BY b.id, b.name, b.restaurant_id, r.name;

COMMENT ON VIEW branch_performance IS 'Performance metrics per branch for owners';

-- Usage: SELECT * FROM branch_performance WHERE restaurant_id = ? ORDER BY total_revenue DESC
