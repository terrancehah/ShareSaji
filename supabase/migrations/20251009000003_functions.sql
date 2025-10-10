-- MalaChilli Database Schema - Functions Migration
-- Version: 1.0
-- Date: 2025-10-09
-- Description: Stored procedures and functions for business logic

-- ============================================================================
-- 1. CREATE REFERRAL CHAIN FUNCTION
-- ============================================================================

CREATE OR REPLACE FUNCTION create_referral_chain(
  p_downline_id UUID,
  p_referral_code VARCHAR(20),
  p_restaurant_id UUID
)
RETURNS VOID AS $$
DECLARE
  v_level1_upline_id UUID;
  v_level2_upline_id UUID;
  v_level3_upline_id UUID;
BEGIN
  -- Check if downline already has referral chain at this restaurant
  IF EXISTS (
    SELECT 1 FROM referrals 
    WHERE downline_id = p_downline_id 
    AND restaurant_id = p_restaurant_id
  ) THEN
    RAISE EXCEPTION 'Customer already has a referral chain at this restaurant';
  END IF;
  
  -- Find Level 1 upline (direct referrer)
  SELECT id INTO v_level1_upline_id
  FROM users
  WHERE referral_code = p_referral_code AND role = 'customer' AND is_deleted = FALSE;
  
  IF v_level1_upline_id IS NULL THEN
    RAISE EXCEPTION 'Invalid referral code';
  END IF;
  
  -- Prevent self-referral
  IF v_level1_upline_id = p_downline_id THEN
    RAISE EXCEPTION 'Cannot use your own referral code';
  END IF;
  
  -- Insert Level 1 referral
  INSERT INTO referrals (downline_id, upline_id, upline_level, restaurant_id)
  VALUES (p_downline_id, v_level1_upline_id, 1, p_restaurant_id);
  
  -- Find Level 2 upline (referrer's upline at this restaurant)
  SELECT upline_id INTO v_level2_upline_id
  FROM referrals
  WHERE downline_id = v_level1_upline_id 
    AND upline_level = 1 
    AND restaurant_id = p_restaurant_id;
  
  IF v_level2_upline_id IS NOT NULL THEN
    INSERT INTO referrals (downline_id, upline_id, upline_level, restaurant_id)
    VALUES (p_downline_id, v_level2_upline_id, 2, p_restaurant_id);
    
    -- Find Level 3 upline (referrer's level 2 upline at this restaurant)
    SELECT upline_id INTO v_level3_upline_id
    FROM referrals
    WHERE downline_id = v_level1_upline_id 
      AND upline_level = 2 
      AND restaurant_id = p_restaurant_id;
    
    IF v_level3_upline_id IS NOT NULL THEN
      INSERT INTO referrals (downline_id, upline_id, upline_level, restaurant_id)
      VALUES (p_downline_id, v_level3_upline_id, 3, p_restaurant_id);
    END IF;
  END IF;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION create_referral_chain IS 'Creates restaurant-specific referral chain (up to 3 uplines) when customer uses a code at a restaurant for the first time';

-- ============================================================================
-- 2. DISTRIBUTE UPLINE REWARDS FUNCTION
-- ============================================================================

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
  v_restaurant_id UUID;
BEGIN
  -- Get restaurant context and configuration
  SELECT 
    r.id,
    r.upline_reward_percent,
    NOW() + INTERVAL '1 day' * r.virtual_currency_expiry_days
  INTO 
    v_restaurant_id,
    v_upline_reward_percent,
    v_expiry_date
  FROM transactions t
  JOIN branches b ON t.branch_id = b.id
  JOIN restaurants r ON b.restaurant_id = r.id
  WHERE t.id = p_transaction_id;
  
  -- Calculate reward amount (1% of bill by default)
  v_reward_amount := p_bill_amount * (v_upline_reward_percent / 100);
  
  -- Loop through uplines at this specific restaurant only (up to 3 levels)
  FOR v_upline IN 
    SELECT upline_id, upline_level
    FROM referrals
    WHERE downline_id = p_customer_id
      AND restaurant_id = v_restaurant_id
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
      expires_at,
      notes
    ) VALUES (
      v_upline.upline_id,
      'earn',
      v_reward_amount,
      v_new_balance,
      p_transaction_id,
      p_customer_id,
      v_upline.upline_level,
      v_expiry_date,
      'Earned from downline transaction'
    );
  END LOOP;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION distribute_upline_rewards IS 'Distributes 1% rewards to uplines at the specific restaurant when a transaction occurs';

-- ============================================================================
-- 3. REDEEM VIRTUAL CURRENCY FUNCTION (with race condition fix)
-- ============================================================================

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
  -- Get current balance with row-level lock (prevents race conditions)
  SELECT COALESCE(SUM(amount), 0) INTO v_current_balance
  FROM virtual_currency_ledger
  WHERE user_id = p_user_id
  FOR UPDATE;
  
  -- Check if sufficient balance
  IF v_current_balance < p_redeem_amount THEN
    RAISE EXCEPTION 'Insufficient virtual currency balance. Available: RM%, Requested: RM%', v_current_balance, p_redeem_amount;
  END IF;
  
  -- Calculate new balance
  v_new_balance := v_current_balance - p_redeem_amount;
  
  -- Insert redemption record
  INSERT INTO virtual_currency_ledger (
    user_id,
    transaction_type,
    amount,
    balance_after,
    related_transaction_id,
    notes
  ) VALUES (
    p_user_id,
    'redeem',
    -p_redeem_amount,
    v_new_balance,
    p_transaction_id,
    'Redeemed at checkout'
  );
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION redeem_virtual_currency IS 'Redeems virtual currency at checkout with race condition protection (FOR UPDATE lock)';

-- ============================================================================
-- 4. EXPIRE VIRTUAL CURRENCY FUNCTION
-- ============================================================================

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
      vcl.id AS ledger_id,
      vcl.user_id,
      vcl.amount,
      vcl.expires_at
    FROM virtual_currency_ledger vcl
    WHERE vcl.transaction_type = 'earn'
      AND vcl.expires_at < NOW()
      AND vcl.expired_at IS NULL  -- Not yet expired
  LOOP
    -- Get current balance
    SELECT COALESCE(SUM(amount), 0) INTO v_current_balance
    FROM virtual_currency_ledger
    WHERE user_id = v_expired_record.user_id;
    
    -- Calculate new balance
    v_new_balance := v_current_balance - v_expired_record.amount;
    
    -- Mark the original earning as expired
    UPDATE virtual_currency_ledger
    SET expired_at = NOW()
    WHERE id = v_expired_record.ledger_id;
    
    -- Insert expiry record (negative transaction)
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

COMMENT ON FUNCTION expire_virtual_currency IS 'Expires virtual currency past expiry date (run daily via cron job)';

-- ============================================================================
-- 5. ANONYMIZE USER FUNCTION (PDPA compliance)
-- ============================================================================

CREATE OR REPLACE FUNCTION anonymize_user(p_user_id UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE users
  SET 
    email = 'deleted_' || id || '@deleted.local',
    full_name = 'Deleted User',
    birthday = NULL,
    is_deleted = TRUE,
    deleted_at = NOW()
  WHERE id = p_user_id;
  
  -- Log the anonymization
  INSERT INTO audit_logs (user_id, action, entity_type, entity_id, metadata)
  VALUES (p_user_id, 'user_anonymized', 'user', p_user_id, jsonb_build_object('anonymized_at', NOW()));
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION anonymize_user IS 'Anonymizes user data for PDPA compliance (soft-delete with data anonymization)';

-- ============================================================================
-- 6. GENERATE UNIQUE REFERRAL CODE FUNCTION
-- ============================================================================

CREATE OR REPLACE FUNCTION generate_unique_referral_code()
RETURNS VARCHAR(20) AS $$
DECLARE
  v_code VARCHAR(20);
  v_chars VARCHAR(36) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  v_code_suffix VARCHAR(6);
  v_attempt INTEGER := 0;
  v_max_attempts INTEGER := 10;
BEGIN
  LOOP
    -- Generate random 6-character suffix
    v_code_suffix := '';
    FOR i IN 1..6 LOOP
      v_code_suffix := v_code_suffix || substring(v_chars FROM (floor(random() * length(v_chars)) + 1)::INTEGER FOR 1);
    END LOOP;
    
    v_code := 'SAJI-' || v_code_suffix;
    
    -- Check if code already exists
    IF NOT EXISTS (SELECT 1 FROM users WHERE referral_code = v_code) THEN
      RETURN v_code;
    END IF;
    
    v_attempt := v_attempt + 1;
    IF v_attempt >= v_max_attempts THEN
      RAISE EXCEPTION 'Failed to generate unique referral code after % attempts', v_max_attempts;
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION generate_unique_referral_code IS 'Generates a unique referral code in SAJI-XXXXXX format with retry logic';

-- ============================================================================
-- 7. PROCESS CHECKOUT TRANSACTION FUNCTION (Atomic wrapper)
-- ============================================================================

CREATE OR REPLACE FUNCTION process_checkout_transaction(
  p_customer_id UUID,
  p_branch_id UUID,
  p_staff_id UUID,
  p_bill_amount DECIMAL(10,2),
  p_guaranteed_discount_amount DECIMAL(10,2),
  p_virtual_currency_redeemed DECIMAL(10,2),
  p_is_first_transaction BOOLEAN,
  p_receipt_photo_url VARCHAR(500),
  p_saved_code_id UUID DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  v_transaction_id UUID;
  v_restaurant_id UUID;
  v_referral_code VARCHAR(20);
BEGIN
  -- Get restaurant context
  SELECT b.restaurant_id INTO v_restaurant_id
  FROM branches b
  WHERE b.id = p_branch_id;
  
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
    p_guaranteed_discount_amount,
    p_virtual_currency_redeemed,
    p_is_first_transaction,
    p_receipt_photo_url
  ) RETURNING id INTO v_transaction_id;
  
  -- Redeem virtual currency if any
  IF p_virtual_currency_redeemed > 0 THEN
    PERFORM redeem_virtual_currency(p_customer_id, v_transaction_id, p_virtual_currency_redeemed);
  END IF;
  
  -- Distribute upline rewards
  PERFORM distribute_upline_rewards(v_transaction_id, p_customer_id, p_bill_amount);
  
  -- If first transaction and saved code exists, create referral chain
  IF p_is_first_transaction AND p_saved_code_id IS NOT NULL THEN
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
  
  -- Update or create customer_restaurant_history
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
    jsonb_build_object('customer_id', p_customer_id, 'bill_amount', p_bill_amount, 'is_first_transaction', p_is_first_transaction));
  
  RETURN v_transaction_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION process_checkout_transaction IS 'Atomic transaction processing wrapper - creates transaction, redeems currency, distributes rewards, creates referral chain if needed';
