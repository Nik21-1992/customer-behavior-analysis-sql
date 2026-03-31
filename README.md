# 📊 Customer Behavior & Growth Analysis (SQL + Power BI)
SQL-based analysis of customer behavior, retention, and channel performance with actionable growth insights.


## Objective
Understand customer behavior, retention, and channel performance to identify key growth opportunities in an e-commerce business.

---

## Dataset
- Source: https://www.kaggle.com/datasets/kushsheth/kshashtra-ecommerce-store-martking-and-sales  
- Tables used:
  - customers  
  - orders  
  - website_sessions  

---

## Key Insights

- ~25% customers are digitally inactive (no recorded sessions)  
- ~46% customers are repeat buyers  
- Average Order Value (AOV): ₹2,533  
- Avg time to 2nd purchase: **412 days**  
- Meta contributes ~43% of total revenue  
- Organic Instagram has the highest conversion (~14%)  
- Only ~6.3% sessions convert to purchase  
- Major drop (~86%) from **Product View → Add to Cart**  

---

## Funnel Analysis

| Stage | Users |
|------|------|
| Total Sessions | 475K |
| Product Views | 456K |
| Add to Cart | 64K |
| Checkout | 49K |
| Purchases | 29K |

⚠️ Biggest drop-off occurs at **Add to Cart stage**

---

## 📈 Channel Performance

- **Meta** → Highest traffic & revenue (scale channel)  
- **Organic Instagram** → Best conversion (high efficiency)  
- **Google & Influencer** → Stable mid-tier channels  
- **Email/SMS** → Retention-driven channel  

---

## Tier Insights

- Tier 2 cities contribute nearly equal revenue as Tier 1  
     - Strong expansion opportunity beyond metro cities  

---

## 🚀 Business Recommendations

1. Improve product page experience (reduce cart drop-off)  
2. Invest more in high-conversion channels (Organic Instagram)  
3. Optimize Meta campaigns for better efficiency  
4. Reduce repurchase cycle using CRM, loyalty programs  
5. Expand marketing and logistics in Tier 2 cities  

---

## Project Structure

- `01_data_setup.sql` → Data loading & table creation  
- `02_data_cleaning.sql` → Data cleaning & transformations  
- `03_analysis.sql` → Business analysis & insights  
- `dashboard.pdf` → Power BI dashboard  
- `DATA_SOURCE.md` → Dataset details (Kaggle link)
