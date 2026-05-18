# Zepto E-Commerce SQL Analysis
---

## Overview

This project delivers an end-to-end SQL-based analysis of Zepto's grocery and FMCG product catalog using **Microsoft SQL Server (T-SQL)**. It covers the full data workflow — from raw data exploration and cleaning to structured business analysis — answering eight key business questions around pricing, inventory, discounts, and revenue estimation.

The approach mirrors real-world data analyst workflows in a quick-commerce environment, demonstrating practical SQL skills applicable to product, operations, and business intelligence teams.

---

## Objectives

- Explore and understand the structure and quality of the raw dataset
- Clean and standardise data for accurate analysis
- Answer targeted business questions using optimised T-SQL queries
- Surface actionable insights across pricing, inventory, and revenue dimensions

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| Microsoft SQL Server | Relational database engine |
| T-SQL | Query language for data manipulation and analysis |
| SSMS | Query execution, testing, and result inspection |

---

## Dataset Description

| Column | Data Type | Description |
|---|---|---|
| `name` | VARCHAR | Product name |
| `Category` | VARCHAR | Product category |
| `mrp` | FLOAT | Maximum Retail Price (originally in paise, converted to ₹) |
| `discountedSellingPrice` | FLOAT | Final selling price after discount (paise → ₹) |
| `discountPercent` | FLOAT | Discount percentage applied |
| `outOfStock` | BIT | 1 = Out of stock · 0 = Available |
| `availableQuantity` | INT | Units currently in inventory |
| `weightInGms` | FLOAT | Product weight in grams |

---

## Data Cleaning

Before analysis, the following cleaning steps were applied to ensure data integrity:

| Step | Action | Reason |
|---|---|---|
| Remove zero-price records | Deleted rows where MRP = 0 | Invalid / incomplete product entries |
| Convert paise to rupees | Divided MRP and selling price by 100 | Raw data stored in paise, not rupees |

---

## Business Questions Answered

| # | Question | Insight |
|---|---|---|
| Q1 | Top 10 best-value products by discount | Identifies products offering maximum savings for promotional targeting |
| Q2 | High MRP products currently out of stock | Highlights premium unmet demand and priority restocking candidates |
| Q3 | Estimated revenue by category | Quantifies financial contribution per category for procurement decisions |
| Q4 | Premium products with low discount | Surfaces high-ticket items ideal for promotional campaigns |
| Q5 | Top 5 categories by average discount | Reveals which categories compete most aggressively on price |
| Q6 | Price per gram for products ≥ 100g | Normalises price across pack sizes to surface true unit-economy value |
| Q7 | Product weight segmentation (Low / Medium / Bulk) | Segments products for logistics planning and packaging strategy |
| Q8 | Total inventory weight per category | Measures physical inventory load for warehouse and cold-chain planning |

---

## Key Findings

| # | Finding |
|---|---|
| 1 | ~21% of all products are currently out of stock |
| 2 | Baby Care and Household categories offer the deepest average discounts |
| 3 | Premium products (MRP > ₹500) carry less than 10% discount — significant room for promotions |
| 4 | Fruits & Vegetables drive the highest estimated category revenue |
| 5 | Price per gram varies up to 5× across different pack sizes within the same category |
| 6 | Several product names appear under 10+ SKUs due to size and flavour variants |
| 7 | Bulk products dominate total inventory weight, with direct implications for logistics |

---

## Repository Structure

```
Zepto-E-Commerce-SQL-Analysis/
│
├── zepto_analysis.sql        ← All queries: exploration, cleaning, and analysis
├── README.md                 ← Project documentation
└── dataset/
    └── zepto_dataset.csv     ← Raw dataset
```

---

## How to Run

1. Import `zepto_dataset.csv` into SQL Server as `zepto.dbo.zepto`
2. Open `zepto_analysis.sql` in SSMS
3. Execute section by section — **Exploration → Cleaning → Analysis**

---

*Dataset sourced from public Zepto product listings. Used for educational and portfolio purposes only.*
