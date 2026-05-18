-- ============================================================
--  ZEPTO E-COMMERCE SQL ANALYSIS
--  Tool    : Microsoft SQL Server (T-SQL)
--  Dataset : zepto.dbo.zepto
-- ============================================================


-- ============================================================
--  SECTION 1 : DATA EXPLORATION
-- ============================================================

-- Preview all records
SELECT * FROM zepto.dbo.zepto;

-- Total number of rows
SELECT COUNT(*) AS total_rows
FROM zepto.dbo.zepto;

-- All distinct product categories
SELECT DISTINCT Category
FROM zepto.dbo.zepto
ORDER BY Category;

-- Products in stock vs out of stock
SELECT outOfStock, COUNT(*) AS stock_count
FROM zepto.dbo.zepto
GROUP BY outOfStock;

-- Products listed under multiple SKUs
SELECT name, COUNT(*) AS number_of_skus
FROM zepto.dbo.zepto
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;


-- ============================================================
--  SECTION 2 : DATA CLEANING
-- ============================================================

-- Inspect zero-price records
SELECT * FROM zepto.dbo.zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

-- Remove products with MRP = 0 (invalid records)
DELETE FROM zepto.dbo.zepto
WHERE mrp = 0;

-- Convert prices from paise to rupees (1 rupee = 100 paise)
UPDATE zepto.dbo.zepto
SET mrp                   = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;

-- Verify the conversion
SELECT mrp, discountedSellingPrice
FROM zepto.dbo.zepto;


-- ============================================================
--  SECTION 3 : BUSINESS ANALYSIS
-- ============================================================

-- Q1. Top 10 best-value products based on discount percentage
SELECT DISTINCT TOP 10
    name,
    mrp,
    discountPercent
FROM zepto.dbo.zepto
ORDER BY discountPercent DESC;


-- Q2. High MRP products that are currently out of stock
SELECT DISTINCT name, mrp
FROM zepto.dbo.zepto
WHERE outOfStock = 1
  AND mrp > 300
ORDER BY mrp DESC;


-- Q3. Estimated revenue per category
SELECT
    Category,
    SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto.dbo.zepto
GROUP BY Category
ORDER BY total_revenue DESC;


-- Q4. Premium products (MRP > 500) with low discount (< 10%)
SELECT DISTINCT name, mrp, discountPercent
FROM zepto.dbo.zepto
WHERE mrp > 500
  AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;


-- Q5. Top 5 categories by highest average discount
SELECT TOP 5
    Category,
    ROUND(AVG(CAST(discountPercent AS FLOAT)), 2) AS avg_discount
FROM zepto.dbo.zepto
GROUP BY Category
ORDER BY avg_discount DESC;


-- Q6. Price per gram for products >= 100g (best unit-value)
SELECT DISTINCT
    name,
    weightInGms,
    discountedSellingPrice,
    ROUND(discountedSellingPrice / weightInGms, 2) AS price_per_gram
FROM zepto.dbo.zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;


-- Q7. Weight segmentation: Low / Medium / Bulk
SELECT DISTINCT
    name,
    weightInGms,
    CASE
        WHEN weightInGms < 1000 THEN 'Low'
        WHEN weightInGms < 5000 THEN 'Medium'
        ELSE 'Bulk'
    END AS weight_category
FROM zepto.dbo.zepto;


-- Q8. Total inventory weight per category (logistics planning)
SELECT
    Category,
    SUM(weightInGms * availableQuantity) AS total_weight_gms
FROM zepto.dbo.zepto
GROUP BY Category
ORDER BY total_weight_gms DESC;
