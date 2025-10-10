-- MalaChilli Database Schema - RLS Policies Migration
-- Version: 1.0
-- Date: 2025-10-09
-- Description: Row Level Security policies for role-based access control

-- ============================================================================
-- ENABLE RLS ON ALL TABLES
-- ============================================================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE restaurants ENABLE ROW LEVEL SECURITY;
ALTER TABLE branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE referrals ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE virtual_currency_ledger ENABLE ROW LEVEL SECURITY;
ALTER TABLE saved_referral_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_restaurant_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE email_notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_config ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- USERS TABLE POLICIES
-- ============================================================================

-- Customers can view their own profile
CREATE POLICY customer_view_own_profile ON users
  FOR SELECT
  USING (auth.uid() = id AND role = 'customer');

-- Customers can update their own profile (limited fields)
CREATE POLICY customer_update_own_profile ON users
  FOR UPDATE
  USING (auth.uid() = id AND role = 'customer')
  WITH CHECK (auth.uid() = id AND role = 'customer');

-- Staff can view customers at their restaurant
CREATE POLICY staff_view_restaurant_customers ON users
  FOR SELECT
  USING (
    role = 'customer' AND
    EXISTS (
      SELECT 1 FROM users staff
      WHERE staff.id = auth.uid() 
        AND staff.role = 'staff'
        AND staff.restaurant_id = users.restaurant_id
    )
  );

-- Owners can view all users at their restaurant
CREATE POLICY owner_view_restaurant_users ON users
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users owner
      WHERE owner.id = auth.uid()
        AND owner.role = 'owner'
        AND owner.restaurant_id = users.restaurant_id
    )
  );

-- Owners can manage staff at their restaurant
CREATE POLICY owner_manage_staff ON users
  FOR ALL
  USING (
    role = 'staff' AND
    EXISTS (
      SELECT 1 FROM users owner
      WHERE owner.id = auth.uid()
        AND owner.role = 'owner'
        AND owner.restaurant_id = users.restaurant_id
    )
  );

-- ============================================================================
-- RESTAURANTS TABLE POLICIES
-- ============================================================================

-- Everyone can view active restaurants (for referral link validation)
CREATE POLICY public_view_active_restaurants ON restaurants
  FOR SELECT
  USING (is_active = TRUE);

-- Owners can view and update their own restaurant
CREATE POLICY owner_manage_own_restaurant ON restaurants
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
        AND users.role = 'owner'
        AND users.restaurant_id = restaurants.id
    )
  );

-- ============================================================================
-- BRANCHES TABLE POLICIES
-- ============================================================================

-- Everyone can view active branches (for restaurant discovery)
CREATE POLICY public_view_active_branches ON branches
  FOR SELECT
  USING (is_active = TRUE);

-- Owners can manage branches at their restaurant
CREATE POLICY owner_manage_restaurant_branches ON branches
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
        AND users.role = 'owner'
        AND users.restaurant_id = branches.restaurant_id
    )
  );

-- ============================================================================
-- REFERRALS TABLE POLICIES
-- ============================================================================

-- Customers can view their own upline chain
CREATE POLICY customer_view_own_uplines ON referrals
  FOR SELECT
  USING (downline_id = auth.uid());

-- Customers can view their own downlines
CREATE POLICY customer_view_own_downlines ON referrals
  FOR SELECT
  USING (upline_id = auth.uid());

-- Owners can view all referrals at their restaurant
CREATE POLICY owner_view_restaurant_referrals ON referrals
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
        AND users.role = 'owner'
        AND users.restaurant_id = referrals.restaurant_id
    )
  );

-- ============================================================================
-- TRANSACTIONS TABLE POLICIES
-- ============================================================================

-- Customers can view their own transactions
CREATE POLICY customer_view_own_transactions ON transactions
  FOR SELECT
  USING (customer_id = auth.uid());

-- Staff can view transactions at their branch
CREATE POLICY staff_view_branch_transactions ON transactions
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users staff
      WHERE staff.id = auth.uid()
        AND staff.role = 'staff'
        AND staff.branch_id = transactions.branch_id
    )
  );

-- Staff can create transactions at their branch
CREATE POLICY staff_create_branch_transactions ON transactions
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users staff
      WHERE staff.id = auth.uid()
        AND staff.role = 'staff'
        AND staff.branch_id = transactions.branch_id
        AND staff.id = transactions.staff_id
    )
  );

-- Owners can view all transactions at their restaurant
CREATE POLICY owner_view_restaurant_transactions ON transactions
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

-- ============================================================================
-- VIRTUAL CURRENCY LEDGER POLICIES
-- ============================================================================

-- Customers can view their own ledger
CREATE POLICY customer_view_own_ledger ON virtual_currency_ledger
  FOR SELECT
  USING (user_id = auth.uid());

-- Staff can view customer ledger at their restaurant (for checkout)
CREATE POLICY staff_view_customer_ledger ON virtual_currency_ledger
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users staff
      WHERE staff.id = auth.uid()
        AND staff.role = 'staff'
    )
  );

-- Owners can view all ledger entries for their restaurant customers
CREATE POLICY owner_view_restaurant_ledger ON virtual_currency_ledger
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users owner
      JOIN users customer ON customer.id = virtual_currency_ledger.user_id
      WHERE owner.id = auth.uid()
        AND owner.role = 'owner'
    )
  );

-- ============================================================================
-- SAVED REFERRAL CODES POLICIES
-- ============================================================================

-- Customers can view and manage their own saved codes
CREATE POLICY customer_manage_own_saved_codes ON saved_referral_codes
  FOR ALL
  USING (user_id = auth.uid());

-- Staff can view customer saved codes at their restaurant (for checkout)
CREATE POLICY staff_view_customer_saved_codes ON saved_referral_codes
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users staff
      WHERE staff.id = auth.uid()
        AND staff.role = 'staff'
        AND staff.restaurant_id = saved_referral_codes.restaurant_id
    )
  );

-- ============================================================================
-- CUSTOMER RESTAURANT HISTORY POLICIES
-- ============================================================================

-- Customers can view their own restaurant history
CREATE POLICY customer_view_own_history ON customer_restaurant_history
  FOR SELECT
  USING (customer_id = auth.uid());

-- Staff can view customer history at their restaurant
CREATE POLICY staff_view_customer_history ON customer_restaurant_history
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users staff
      WHERE staff.id = auth.uid()
        AND staff.role = 'staff'
        AND staff.restaurant_id = customer_restaurant_history.restaurant_id
    )
  );

-- Owners can view all customer history at their restaurant
CREATE POLICY owner_view_restaurant_history ON customer_restaurant_history
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
        AND users.role = 'owner'
        AND users.restaurant_id = customer_restaurant_history.restaurant_id
    )
  );

-- ============================================================================
-- EMAIL NOTIFICATIONS POLICIES
-- ============================================================================

-- Customers can view their own email notifications
CREATE POLICY customer_view_own_notifications ON email_notifications
  FOR SELECT
  USING (user_id = auth.uid());

-- Owners can view notifications for their restaurant users
CREATE POLICY owner_view_restaurant_notifications ON email_notifications
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users owner
      JOIN users customer ON customer.id = email_notifications.user_id
      WHERE owner.id = auth.uid()
        AND owner.role = 'owner'
    )
  );

-- ============================================================================
-- AUDIT LOGS POLICIES
-- ============================================================================

-- Users can view their own audit logs
CREATE POLICY user_view_own_audit_logs ON audit_logs
  FOR SELECT
  USING (user_id = auth.uid());

-- Owners can view audit logs for their restaurant
CREATE POLICY owner_view_restaurant_audit_logs ON audit_logs
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users owner
      WHERE owner.id = auth.uid()
        AND owner.role = 'owner'
    )
  );

-- ============================================================================
-- SYSTEM CONFIG POLICIES
-- ============================================================================

-- Everyone can read system config (public settings)
CREATE POLICY public_read_system_config ON system_config
  FOR SELECT
  USING (TRUE);

-- Only owners can update system config (admin-level access)
CREATE POLICY owner_update_system_config ON system_config
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
        AND users.role = 'owner'
    )
  );

-- ============================================================================
-- NOTE: auth.uid() function is provided by Supabase
-- ============================================================================
-- No need to create auth.uid() - it's built into Supabase Auth
-- The function returns the authenticated user's ID from the JWT token
