-- ShareSaji Database Schema - Updates for Scenario B
-- Version: 1.1
-- Date: 2025-10-10
-- Description: 
--   1. Remove age field (can be calculated from birthday)
--   2. Update logic to always apply 5% guaranteed discount
--   3. Keep customer_restaurant_history for analytics only (not discount eligibility)

-- ============================================================================
-- 1. REMOVE AGE FIELD FROM USERS TABLE
-- ============================================================================

ALTER TABLE users DROP COLUMN IF EXISTS age;

COMMENT ON COLUMN users.birthday IS 'Date of birth - age can be calculated as: EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthday))';

-- ============================================================================
-- 2. UPDATE PROCESS_CHECKOUT_TRANSACTION FUNCTION
-- ============================================================================

-- Drop the old function signature (9 parameters)
DROP FUNCTION IF EXISTS process_checkout_transaction(
  UUID, UUID, UUID, DECIMAL, DECIMAL, DECIMAL, BOOLEAN, VARCHAR, UUID
);

-- Create new function with updated logic (8 parameters - removed p_guaranteed_discount_amount)
CREATE OR REPLACE FUNCTION process_checkout_transaction(
  p_customer_id UUID,
  p_branch_id UUID,
  p_staff_id UUID,
  p_bill_amount DECIMAL(10,2),
  p_virtual_currency_redeemed DECIMAL(10,2),
  p_receipt_photo_url VARCHAR(500),
  p_saved_code_id UUID DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  v_transaction_id UUID;
  v_restaurant_id UUID;
  v_referral_code VARCHAR(20);
  v_guaranteed_discount DECIMAL(10,2);
  v_guaranteed_discount_percent DECIMAL(5,2);
  v_is_first_visit BOOLEAN;
BEGIN
  -- Get restaurant context and configuration
  SELECT 
    r.id,
    r.guaranteed_discount_percent
  INTO 
    v_restaurant_id,
    v_guaranteed_discount_percent
  FROM branches b
  JOIN restaurants r ON b.restaurant_id = r.id
  WHERE b.id = p_branch_id;
  
  -- Calculate guaranteed discount (ALWAYS applied, not just first visit)
  v_guaranteed_discount := p_bill_amount * (v_guaranteed_discount_percent / 100);
  
  -- Check if this is first visit (for analytics only, not discount eligibility)
  SELECT NOT EXISTS (
    SELECT 1 FROM customer_restaurant_history 
    WHERE customer_id = p_customer_id 
    AND restaurant_id = v_restaurant_id
  ) INTO v_is_first_visit;
  
  -- Insert transaction
  INSERT INTO transactions (
    customer_id,
    branch_id,
    staff_id,
    bill_amount,
    guaranteed_discount_amount,
    virtual_currency_redeemed,
    is_first_transaction,
    receipt_photo_url
  ) VALUES (
    p_customer_id,
    p_branch_id,
    p_staff_id,
    p_bill_amount,
    v_guaranteed_discount,
    p_virtual_currency_redeemed,
    v_is_first_visit, -- For analytics: track if this was first visit
    p_receipt_photo_url
  ) RETURNING id INTO v_transaction_id;
  
  -- Redeem virtual currency if any
  IF p_virtual_currency_redeemed > 0 THEN
    PERFORM redeem_virtual_currency(p_customer_id, v_transaction_id, p_virtual_currency_redeemed);
  END IF;
  
  -- Distribute upline rewards
  PERFORM distribute_upline_rewards(v_transaction_id, p_customer_id, p_bill_amount);
  
  -- If first visit and saved code exists, create referral chain
  IF v_is_first_visit AND p_saved_code_id IS NOT NULL THEN
    SELECT referral_code INTO v_referral_code
    FROM saved_referral_codes
    WHERE id = p_saved_code_id;
    
    IF v_referral_code IS NOT NULL THEN
      PERFORM create_referral_chain(p_customer_id, v_referral_code, v_restaurant_id);
      
      -- Mark saved code as used
      UPDATE saved_referral_codes
      SET is_used = TRUE, used_at = NOW()
      WHERE id = p_saved_code_id;
    END IF;
  END IF;
  
  -- Update or create customer_restaurant_history (for analytics)
  INSERT INTO customer_restaurant_history (
    customer_id,
    restaurant_id,
    referral_code_used,
    total_spent,
    last_visit_date
  ) VALUES (
    p_customer_id,
    v_restaurant_id,
    v_referral_code,
    p_bill_amount,
    NOW()
  )
  ON CONFLICT (customer_id, restaurant_id)
  DO UPDATE SET
    total_visits = customer_restaurant_history.total_visits + 1,
    total_spent = customer_restaurant_history.total_spent + EXCLUDED.total_spent,
    last_visit_date = NOW();
  
  -- Log the transaction
  INSERT INTO audit_logs (user_id, action, entity_type, entity_id, metadata)
  VALUES (p_staff_id, 'transaction_created', 'transaction', v_transaction_id, 
    jsonb_build_object(
      'customer_id', p_customer_id, 
      'bill_amount', p_bill_amount, 
      'is_first_transaction', v_is_first_visit,
      'guaranteed_discount', v_guaranteed_discount
    ));
  
  RETURN v_transaction_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION process_checkout_transaction IS 'Atomic transaction processing - 5% guaranteed discount ALWAYS applied, is_first_transaction tracked for analytics only';

-- ============================================================================
-- 3. UPDATE TABLE COMMENTS FOR CLARITY
-- ============================================================================

COMMENT ON TABLE customer_restaurant_history IS 'Tracks customer visit history and statistics per restaurant (for analytics, not discount eligibility)';

COMMENT ON COLUMN transactions.is_first_transaction IS 'Analytics flag: TRUE if this was customer''s first visit to the restaurant (guaranteed discount always applied regardless)';

-- ============================================================================
-- 4. CREATE HELPER VIEW FOR CUSTOMER AGE CALCULATION
-- ============================================================================

CREATE OR REPLACE VIEW customer_profiles_with_age AS
SELECT 
  id,
  email,
  full_name,
  birthday,
  EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthday))::INTEGER AS age,
  referral_code,
  role,
  branch_id,
  restaurant_id,
  created_at,
  last_login
FROM users
WHERE birthday IS NOT NULL;

COMMENT ON VIEW customer_profiles_with_age IS 'User profiles with calculated age from birthday field';

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Verify age field removed
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'users' 
AND column_name = 'age';
-- Should return 0 rows

-- Test age calculation
SELECT 
  full_name,
  birthday,
  EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthday))::INTEGER AS calculated_age
FROM users
WHERE birthday IS NOT NULL
LIMIT 5;

-- Verify guaranteed discount logic
SELECT 
  t.id,
  t.bill_amount,
  t.guaranteed_discount_amount,
  t.is_first_transaction,
  ROUND((t.guaranteed_discount_amount / t.bill_amount * 100)::NUMERIC, 2) AS discount_percent
FROM transactions t
ORDER BY t.created_at DESC
LIMIT 10;
-- All transactions should have guaranteed_discount_amount = bill_amount * 5%
