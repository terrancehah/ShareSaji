-- ShareSaji Database Schema - Menu Items Migration
-- Version: 1.0
-- Date: 2025-10-10
-- Description: Menu items/products table for restaurant inventory and ordering

-- ============================================================================
-- 1. MENU ITEMS TABLE
-- ============================================================================

CREATE TABLE menu_items (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Association (optional - NULL means available for all restaurants)
  restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
  
  -- Item Details
  item_number INTEGER, -- Sequential number (e.g., 1, 2, 3...)
  name VARCHAR(255) NOT NULL,
  category VARCHAR(100), -- 'meat', 'seafood', 'vegetables', 'processed', 'noodles_rice', 'others'
  
  -- Pricing
  price DECIMAL(10,2), -- Price in RM (nullable if price varies)
  unit VARCHAR(50), -- 'Kg', 'Pack', 'Box', 'Pcs', '500g/pack', etc.
  
  -- Nutritional Information (per 100g)
  calories_per_100g INTEGER,
  protein_per_100g DECIMAL(5,2),
  fat_per_100g DECIMAL(5,2),
  
  -- Inventory
  stock_quantity DECIMAL(10,2) DEFAULT 0, -- Current stock level
  low_stock_threshold DECIMAL(10,2), -- Alert when stock below this
  
  -- Status
  is_available BOOLEAN DEFAULT TRUE,
  is_active BOOLEAN DEFAULT TRUE,
  
  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  notes TEXT
);

-- Indexes for menu_items
CREATE INDEX idx_menu_items_restaurant_id ON menu_items(restaurant_id);
CREATE INDEX idx_menu_items_category ON menu_items(category);
CREATE INDEX idx_menu_items_is_available ON menu_items(is_available);
CREATE INDEX idx_menu_items_name ON menu_items(name);

COMMENT ON TABLE menu_items IS 'Restaurant menu items/products for inventory and ordering';
COMMENT ON COLUMN menu_items.restaurant_id IS 'NULL means item available for all restaurants (global catalog)';
COMMENT ON COLUMN menu_items.item_number IS 'Sequential number for display order';

-- ============================================================================
-- 2. INSERT SAMPLE MENU ITEMS DATA
-- ============================================================================

-- Category: Meat & Poultry
INSERT INTO menu_items (item_number, name, category, price, unit, calories_per_100g, protein_per_100g, fat_per_100g, is_available) VALUES
(1, 'Beef Chuck Tender', 'meat', 24.90, 'Kg', 180, 20, 11, TRUE),
(2, 'Chicken Wing', 'meat', NULL, '2Kg/6Pack', 203, 17, 15, TRUE),
(3, 'Chicken Breast', 'meat', 17.99, 'Kg', 165, 31, 3.6, TRUE),
(4, 'Lamb', 'meat', NULL, NULL, 250, 25, 17, TRUE);

-- Category: Seafood
INSERT INTO menu_items (item_number, name, category, price, unit, calories_per_100g, protein_per_100g, fat_per_100g, is_available) VALUES
(5, 'Tiger Prawns', 'seafood', 36.99, 'Kg', 105, 20, 2, TRUE),
(6, 'Dory Fillet', 'seafood', NULL, '10kg/Box', 90, 18, 2, TRUE),
(7, 'Patin Fillet', 'seafood', 12.00, '1Kg/pack', 140, 20, 7, TRUE),
(8, 'Sotong Ring', 'seafood', NULL, '1kg/Pack', 92, 15, 2, TRUE),
(9, 'Bamboo Clam', 'seafood', NULL, '1Kg/Pack/8-10Cm', 80, 14, 1, TRUE);

-- Category: Processed Items (Tofu, Balls, etc.)
INSERT INTO menu_items (item_number, name, category, price, unit, calories_per_100g, protein_per_100g, fat_per_100g, is_available) VALUES
(10, 'Cheese Tofu', 'processed', 10.80, '500g/pack', 170, 8, 10, TRUE),
(11, 'Seafood Tofu', 'processed', 10.50, '500g/pack', 150, 6, 8, TRUE),
(12, 'Crab Stick', 'processed', 5.20, '250g/pack', 95, 7, 3, TRUE),
(13, 'Crab Claw', 'processed', NULL, '240g/pack', 120, 6, 6, TRUE),
(14, 'Lobster Ball', 'processed', 10.50, '500g/pack', 140, 7, 7, TRUE),
(15, 'Quail Egg', 'processed', 14.70, 'Pack/50pcs', 158, 13, 11, TRUE),
(16, 'White Fish Ball', 'processed', NULL, '1kg/pack', 110, 12, 1, TRUE),
(17, 'Ekonomi Fish Ball', 'processed', NULL, '1kg/pack', 130, 8, 4, TRUE),
(18, 'Chicken Hotdog', 'processed', 151.20, '800g/12pack/box', 150, 7, 12, TRUE),
(19, 'Nugget Jimat', 'processed', NULL, '1kg/pack', 270, 13, 17, TRUE),
(20, 'Fries', 'processed', 6.99, '1kg/pack', 312, 3, 15, TRUE),
(21, 'Egg', 'processed', 13.50, 'Pack/30pcs', 156, 13, 11, TRUE);

-- Category: Vegetables & Mushrooms
INSERT INTO menu_items (item_number, name, category, price, unit, calories_per_100g, protein_per_100g, fat_per_100g, is_available) VALUES
(22, 'Enoki Mushroom', 'vegetables', 33.00, 'Box/50pcs', 37, 2, 0, TRUE),
(23, 'Shiitake Mushroom', 'vegetables', 6.50, 'Pack', 34, 2, 0, TRUE),
(24, 'Yellow Onion', 'vegetables', 6.50, 'Kg', 40, 1, 0, TRUE),
(25, 'Lettuce', 'vegetables', 15.50, 'Kg', 15, 1, 0, TRUE),
(26, 'Chinese Cabbage', 'vegetables', 4.50, 'Kg', 16, 1, 0, TRUE),
(27, 'Chinese Flowering Cabbage', 'vegetables', 6.50, 'Kg', 19, 2, 0, TRUE),
(28, 'Broccoli', 'vegetables', 11.00, 'Kg', 34, 3, 0, TRUE),
(29, 'White Daikon', 'vegetables', 5.50, 'Kg', 18, 1, 0, TRUE),
(30, 'Potato', 'vegetables', 20.00, 'Pack', 77, 2, 0, TRUE),
(31, 'Lotus Root', 'vegetables', 12.00, 'Kg', 74, 2, 0, TRUE),
(32, 'Tomato', 'vegetables', 5.80, 'Kg', 18, 1, 0, TRUE),
(33, 'Baby Corn', 'vegetables', 2.50, 'Pack', 26, 2, 0, TRUE),
(34, 'Sweet Corn', 'vegetables', 4.50, 'Pack', 96, 3, 1, TRUE),
(35, 'Cucumber', 'vegetables', 4.50, 'Kg', 11, 1, 0, TRUE),
(36, 'Lemon', 'vegetables', 1.50, 'Pcs', 29, 1, 0, TRUE);

-- Category: Herbs & Spices
INSERT INTO menu_items (item_number, name, category, price, unit, calories_per_100g, protein_per_100g, fat_per_100g, is_available) VALUES
(37, 'Green Onion', 'herbs', 12.00, 'Kg', 32, 1, 0, TRUE),
(38, 'Garlic', 'herbs', 9.50, 'Pack', 149, 6, 0, TRUE),
(39, 'Small Red Chili', 'herbs', 12.50, 'Kg', 40, 2, 0, TRUE);

-- Category: Noodles & Rice
INSERT INTO menu_items (item_number, name, category, price, unit, calories_per_100g, protein_per_100g, fat_per_100g, is_available) VALUES
(40, 'Black Fungus', 'noodles_rice', 17.00, '1kg/pack', 25, 1, 0, TRUE),
(41, 'Konjac Knots', 'noodles_rice', 150.00, 'Box', 10, 0, 0, TRUE),
(42, 'Wei Yi Noodles', 'noodles_rice', 40.00, 'Pack', 180, 5, 1, TRUE),
(43, 'E Noodles', 'noodles_rice', 4.20, 'Pack/5pcs', 220, 7, 2, TRUE),
(44, 'Handmade Noodles', 'noodles_rice', 24.00, 'Box', 280, 9, 2, TRUE),
(45, 'White Rice', 'noodles_rice', 40.00, '10kg/pack', 130, 2, 0, TRUE);

-- Category: Others
INSERT INTO menu_items (item_number, name, category, price, unit, calories_per_100g, protein_per_100g, fat_per_100g, is_available) VALUES
(46, 'Bell Roll', 'others', 130.00, 'Box', 150, 10, 8, TRUE),
(47, 'White Tofu', 'others', 5.00, 'Pack/10pcs', 76, 8, 4, TRUE),
(48, 'Tofu Puffs', 'others', 6.50, 'Pack', 270, 12, NULL, TRUE);

-- ============================================================================
-- 3. MENU ITEMS VIEW (with category summary)
-- ============================================================================

CREATE VIEW menu_items_summary AS
SELECT 
  category,
  COUNT(*) AS item_count,
  COUNT(CASE WHEN is_available THEN 1 END) AS available_count,
  AVG(price) AS avg_price,
  MIN(price) AS min_price,
  MAX(price) AS max_price
FROM menu_items
WHERE is_active = TRUE
GROUP BY category;

COMMENT ON VIEW menu_items_summary IS 'Summary statistics for menu items by category';

-- ============================================================================
-- 4. RLS POLICIES FOR MENU ITEMS
-- ============================================================================

ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;

-- Everyone can view available menu items
CREATE POLICY public_view_available_menu_items ON menu_items
  FOR SELECT
  USING (is_active = TRUE AND is_available = TRUE);

-- Staff can view all menu items at their restaurant
CREATE POLICY staff_view_restaurant_menu_items ON menu_items
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
        AND users.role = 'staff'
        AND (menu_items.restaurant_id IS NULL OR users.restaurant_id = menu_items.restaurant_id)
    )
  );

-- Owners can manage menu items at their restaurant
CREATE POLICY owner_manage_restaurant_menu_items ON menu_items
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
        AND users.role = 'owner'
        AND (menu_items.restaurant_id IS NULL OR users.restaurant_id = menu_items.restaurant_id)
    )
  );

-- ============================================================================
-- 5. VERIFICATION QUERIES
-- ============================================================================

-- View all menu items by category
SELECT 
  category,
  COUNT(*) AS total_items,
  COUNT(CASE WHEN price IS NOT NULL THEN 1 END) AS items_with_price,
  ROUND(AVG(COALESCE(price, 0))::NUMERIC, 2) AS avg_price
FROM menu_items
GROUP BY category
ORDER BY category;

-- View items missing price information
SELECT item_number, name, unit, category
FROM menu_items
WHERE price IS NULL
ORDER BY item_number;

-- View high-protein items (>15g per 100g)
SELECT item_number, name, category, protein_per_100g, calories_per_100g
FROM menu_items
WHERE protein_per_100g > 15
ORDER BY protein_per_100g DESC;

-- View low-calorie items (<50 cal per 100g)
SELECT item_number, name, category, calories_per_100g
FROM menu_items
WHERE calories_per_100g < 50
ORDER BY calories_per_100g;
