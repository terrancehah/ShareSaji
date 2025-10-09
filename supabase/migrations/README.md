# ShareSaji Database Migrations

Complete database schema migrations for ShareSaji MVP.

## Migration Files

### 1. `20251009000001_initial_schema.sql`
Creates all core tables with complete schema including:
- restaurants, branches, users
- referrals, transactions, virtual_currency_ledger
- saved_referral_codes, customer_restaurant_history
- email_notifications, audit_logs, system_config

**Includes gap fixes:**
- PDPA-compliant user deletion fields
- Email notification tracking
- Audit logging
- System configuration
- Performance indexes

### 2. `20251009000002_views.sql`
Creates helper views for common queries:
- customer_wallet_balance
- customer_downlines
- restaurant_analytics_summary
- customer_expiring_balance
- staff_daily_stats
- customer_referral_tree
- branch_performance

### 3. `20251009000003_functions.sql`
Creates stored procedures and functions:
- `create_referral_chain()` - Restaurant-specific upline chain creation
- `distribute_upline_rewards()` - 1% reward distribution
- `redeem_virtual_currency()` - Checkout redemption with race condition protection
- `expire_virtual_currency()` - Daily cron job for expiry
- `anonymize_user()` - PDPA compliance
- `generate_unique_referral_code()` - Code generation with retry logic
- `process_checkout_transaction()` - Atomic transaction wrapper

### 4. `20251009000004_rls_policies.sql`
Implements Row Level Security policies for:
- Customer: View/update own data only
- Staff: View customers and process transactions at assigned branch
- Owner: Full access to restaurant data
- Public: View active restaurants and branches

### 5. `20251009000005_seed_data.sql`
Inserts test data for development:
- 1 restaurant (Nasi Lemak Corner) with 2 branches
- 1 owner, 2 staff members
- 4 customers in referral chain (A → B → C → D)
- Sample transactions and virtual currency ledger
- Test saved codes and customer history

### 6. `20251010000006_menu_items.sql`
Creates menu items table and populates inventory:
- menu_items table with nutritional info and pricing
- 48 pre-populated items across 7 categories
- Categories: meat, seafood, processed, vegetables, herbs, noodles_rice, others
- Includes inventory tracking (stock_quantity, low_stock_threshold)
- RLS policies for public viewing and owner management
- menu_items_summary view for category statistics

### 7. `20251010000007_schema_updates_scenario_b.sql`
Updates schema for Scenario B (5% guaranteed on all transactions):
- **Removes `age` field from users table** (calculated from birthday)
- **Updates `process_checkout_transaction()` function** to always apply 5% guaranteed discount
- **Clarifies table purposes** in comments (customer_restaurant_history for analytics only)
- **Creates `customer_profiles_with_age` view** for calculated age display
- **Business decision:** 5% guaranteed discount applied to EVERY transaction (not just first)

## Deployment Instructions

### Option 1: Supabase Dashboard (Recommended)
1. Go to your Supabase project dashboard
2. Navigate to SQL Editor
3. Run migrations in order (001, 002, 003, 004, 005, 006, 007)
4. Copy-paste each file content and execute

### Option 2: Supabase CLI
```bash
# Install Supabase CLI
npm install -g supabase

# Login to Supabase
supabase login

# Link to your project
supabase link --project-ref your-project-ref

# Run migrations
supabase db push

# Or run individually
supabase db execute --file supabase/migrations/20251009000001_initial_schema.sql
supabase db execute --file supabase/migrations/20251009000002_views.sql
supabase db execute --file supabase/migrations/20251009000003_functions.sql
supabase db execute --file supabase/migrations/20251009000004_rls_policies.sql
supabase db execute --file supabase/migrations/20251009000005_seed_data.sql
supabase db execute --file supabase/migrations/20251010000006_menu_items.sql
supabase db execute --file supabase/migrations/20251010000007_schema_updates_scenario_b.sql
```

### Option 3: Local Development with Docker
```bash
# Start local Supabase
supabase start

# Migrations will auto-apply from migrations folder

# Access local dashboard
open http://localhost:54323
```

## Test Credentials

**Owner Account:**
- Email: `owner@nasilemak.test`
- Password: `TestOwner123!`
- Role: Owner

**Staff Accounts:**
- Email: `staff1@nasilemak.test` / `staff2@nasilemak.test`
- Password: `TestStaff123!`
- Role: Staff

**Customer Accounts:**
- Email: `customer.a@test.com` through `customer.d@test.com`
- Password: `TestCustomer123!`
- Role: Customer
- Referral Codes: SAJI-AAA111, SAJI-BBB222, SAJI-CCC333, SAJI-DDD444

## Verification Queries

After running migrations, verify with these queries:

```sql
-- Check all tables exist
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Check customer wallet balances
SELECT * FROM customer_wallet_balance;

-- Check referral chains
SELECT * FROM customer_referral_tree ORDER BY downline_id, upline_level;

-- Check restaurant analytics
SELECT * FROM restaurant_analytics_summary;

-- Test referral code generation
SELECT generate_unique_referral_code();

-- Test expiry function (should return 0 if no expired currency)
SELECT expire_virtual_currency();
```

## Database Schema Diagram

```
restaurants (1) ──< branches (N)
     │                  │
     │                  │
     ├──< users (staff) ┘
     │
     └──< referrals (restaurant-specific)
              │
              └──< users (customers)
                       │
                       ├──< transactions
                       ├──< virtual_currency_ledger
                       ├──< saved_referral_codes
                       └──< customer_restaurant_history
```

## Important Notes

### Restaurant-Specific Referrals
Referral chains are restaurant-specific. Same customer can have different upline chains at different restaurants.

### Transaction Atomicity
Use `process_checkout_transaction()` function for all checkout operations to ensure atomicity.

### Race Condition Protection
`redeem_virtual_currency()` uses `FOR UPDATE` lock to prevent concurrent redemption race conditions.

### PDPA Compliance
User deletion uses soft-delete with anonymization via `anonymize_user()` function.

### Performance
All critical indexes are included. Monitor query performance with:
```sql
EXPLAIN ANALYZE SELECT ...;
```

## Rollback

To rollback migrations (use with caution):

```sql
-- Drop all functions
DROP FUNCTION IF EXISTS process_checkout_transaction CASCADE;
DROP FUNCTION IF EXISTS generate_unique_referral_code CASCADE;
DROP FUNCTION IF EXISTS anonymize_user CASCADE;
DROP FUNCTION IF EXISTS expire_virtual_currency CASCADE;
DROP FUNCTION IF EXISTS redeem_virtual_currency CASCADE;
DROP FUNCTION IF EXISTS distribute_upline_rewards CASCADE;
DROP FUNCTION IF EXISTS create_referral_chain CASCADE;

-- Drop all views
DROP VIEW IF EXISTS branch_performance CASCADE;
DROP VIEW IF EXISTS customer_referral_tree CASCADE;
DROP VIEW IF EXISTS staff_daily_stats CASCADE;
DROP VIEW IF EXISTS customer_expiring_balance CASCADE;
DROP VIEW IF EXISTS restaurant_analytics_summary CASCADE;
DROP VIEW IF EXISTS customer_downlines CASCADE;
DROP VIEW IF EXISTS customer_wallet_balance CASCADE;

-- Drop all tables (in reverse dependency order)
DROP TABLE IF EXISTS audit_logs CASCADE;
DROP TABLE IF EXISTS email_notifications CASCADE;
DROP TABLE IF EXISTS system_config CASCADE;
DROP TABLE IF EXISTS customer_restaurant_history CASCADE;
DROP TABLE IF EXISTS saved_referral_codes CASCADE;
DROP TABLE IF EXISTS virtual_currency_ledger CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS referrals CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS branches CASCADE;
DROP TABLE IF EXISTS restaurants CASCADE;
```

## Support

For issues or questions:
1. Check database logs in Supabase dashboard
2. Review migration files for comments
3. Consult `/docs/03-database-schema-design.md` for detailed schema documentation
