# -Zepto-E-Commerce-SQL-Analysis
End-to-end SQL Server analysis on Zepto's grocery dataset — covering data cleaning, pricing, inventory, discount patterns, and revenue estimation using T-SQL.

# -Topics 
sql
sql-server
t-sql
data-analysis
data-cleaning
e-commerce
zepto
portfolio-project
business-intelligence

## 📌 Project Overview

This project performs a structured SQL-based analysis on Zepto's grocery and FMCG product dataset. The goal is to extract actionable business insights around pricing strategy, inventory gaps, discount patterns, and revenue estimation — mimicking the kind of queries a data analyst would run at a quick-commerce company.

**Tools used:** Microsoft SQL Server · T-SQL · SSMS
---
## 📂 Dataset Description

| Column | Description |
|---|---|
| `name` | Product name |
| `Category` | Product category |
| `mrp` | Maximum Retail Price (stored in paise, converted to ₹) |
| `discountedSellingPrice` | Selling price after discount (paise → ₹) |
| `discountPercent` | Discount percentage |
| `outOfStock` | 1 = Out of stock, 0 = Available |
| `availableQuantity` | Units available in inventory |
| `weightInGms` | Product weight in grams |

> **Note:** Prices were originally stored in paise (1 ₹ = 100 paise). A data cleaning step converts them to rupees.
---
## 🧹 Data Cleaning

Before analysis, the following cleaning steps were performed:

### 1. Identify and remove zero-price records
```sql
-- Inspect zero-price products
SELECT * FROM zepto.dbo.zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

-- Remove invalid records
DELETE FROM zepto.dbo.zepto
WHERE mrp = 0;
```

### 2. Convert prices from paise to rupees
```sql
UPDATE zepto.dbo.zepto
SET mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;
```

---

## 🔍 Exploratory Data Analysis

```sql
-- Preview data
SELECT * FROM zepto.dbo.zepto;

-- Total row count
SELECT COUNT(*) FROM zepto.dbo.zepto;

-- Distinct product categories
SELECT DISTINCT Category FROM zepto.dbo.zepto ORDER BY Category;

-- Stock availability breakdown
SELECT outOfStock, COUNT(*) AS stock_count
FROM zepto.dbo.zepto
GROUP BY outOfStock;

-- Products listed under multiple SKUs
SELECT name, COUNT(*) AS "number of skus"
FROM zepto.dbo.zepto
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;
```

---

## 📊 Business Analysis Queries

### Q1 — Top 10 Best-Value Products by Discount
```sql
SELECT DISTINCT TOP 10 name, mrp, discountPercent
FROM zepto.dbo.zepto
ORDER BY discountPercent DESC;
```
**Insight:** Identifies products where customers get maximum savings — useful for marketing and promotions.

---

### Q2 — High MRP Products Currently Out of Stock
```sql
SELECT DISTINCT name, mrp
FROM zepto.dbo.zepto
WHERE outOfStock = 1 AND mrp > 300
ORDER BY mrp DESC;
```
**Insight:** Premium products that are unavailable represent direct lost revenue. These are priority restocking candidates.

---

### Q3 — Estimated Revenue by Category
```sql
SELECT Category,
       SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto.dbo.zepto
GROUP BY Category
ORDER BY total_revenue DESC;
```
**Insight:** Quantifies which category contributes most to top-line revenue. Fruits & Vegetables typically lead due to high volume.

---

### Q4 — Premium Products with Low Discount
```sql
SELECT DISTINCT name, mrp, discountPercent
FROM zepto.dbo.zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;
```
**Insight:** High-ticket items with minimal markdowns — ideal targets for promotional campaigns to drive conversion.

---

### Q5 — Top 5 Categories by Average Discount
```sql
SELECT TOP 5 Category,
       ROUND(AVG(CAST(discountPercent AS FLOAT)), 2) AS avg_discount
FROM zepto.dbo.zepto
GROUP BY Category
ORDER BY avg_discount DESC;
```
**Insight:** Non-food categories like Baby Care and Household Supplies often offer deeper discounts to drive trial.

---

### Q6 — Price per Gram (Best Value for Large Packs)
```sql
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
       ROUND(discountedSellingPrice / weightInGms, 2) AS price_per_gram
FROM zepto.dbo.zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;
```
**Insight:** Normalises price across pack sizes. Reveals which products offer true unit-economy value.

---

### Q7 — Product Weight Segmentation
```sql
SELECT DISTINCT name, weightInGms,
    CASE
        WHEN weightInGms < 1000 THEN 'Low'
        WHEN weightInGms < 5000 THEN 'Medium'
        ELSE 'Bulk'
    END AS weight_category
FROM zepto.dbo.zepto;
```
**Insight:** Segments products for logistics planning, packaging strategy, and customer targeting (household vs. individual).

---

### Q8 — Total Inventory Weight per Category
```sql
SELECT Category,
       SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto.dbo.zepto
GROUP BY Category
ORDER BY total_weight DESC;
```
**Insight:** Calculates physical inventory load by category — critical for warehouse capacity and cold-chain management.

---

## 💡 Key Findings

| # | Finding |
|---|---|
| 1 | ~21% of all products are currently out of stock |
| 2 | Baby Care and Household categories offer the deepest average discounts |
| 3 | Many premium products (MRP > ₹500) carry less than 10% discount — room for promotions |
| 4 | Fruits & Vegetables drive the highest estimated revenue |
| 5 | Price per gram varies up to 5× across different pack sizes in the same category |
| 6 | Several product names appear under 10+ SKUs (size/flavour variants) |
| 7 | Bulk category dominates total inventory weight, influencing logistics strategy |

---

## 🚀 How to Run


1. **Set up the database**  
   Import the dataset into SQL Server as `zepto.dbo.zepto` (CSV import via SSMS or `BULK INSERT`).

2. **Run the scripts in order**
   - `01_exploration.sql` — initial data exploration
   - `02_cleaning.sql` — data cleaning (remove zeros, convert paise to ₹)
   - `03_analysis.sql` — all 8 business queries

3. **Open in SSMS** and execute each script against your `zepto` database.

---

## 📁 Repository Structure

```
zepto-sql-analysis/
│
├── data/
│   └── zepto_dataset.csv         # Raw dataset
│
├── scripts/
│   ├── 01_exploration.sql        # EDA queries
│   ├── 02_cleaning.sql           # Data cleaning
│   └── 03_analysis.sql           # Business queries (Q1–Q8)
│
├── visuals/
│   └── charts/                   # Revenue, discount, stock charts
│
└── README.md
```

*Dataset sourced from public Zepto product listings. Used for educational purposes only.*
