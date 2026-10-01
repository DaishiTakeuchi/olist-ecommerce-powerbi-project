# Olist E-Commerce Dashboard (Power BI + MySQL)

End-to-end analysis of a Brazilian e-commerce marketplace: SQL data cleaning → Power BI dashboard → business insights.

📊 **[View the dashboard & full project summary on Notion](https://app.notion.com/p/Brazilian-E-Commerce-Public-Dataset-by-Olist-3ea872d573c980c4aeaac94d1e709348?source=copy_link)**

## Objective
Answer business questions across 8 dimensions to understand sales, customers, logistics, and satisfaction.

## Dataset
Brazilian E-Commerce Public Dataset by Olist (Kaggle)

## Tools
- **MySQL**: data cleaning, JOINs, window functions, VIEW
- **Power BI**: data model, DAX measures, dashboards

## Workflow
1. Imported 8 CSV tables into MySQL (`LOAD DATA LOCAL INFILE`)
2. Cleaned data: filled 610 missing product categories as `unknown`; deduplicated reviews to 1 per order using `ROW_NUMBER()`
3. Built the `olist_master` VIEW joining orders, items, customers, products, sellers, payments, and reviews
4. Connected Power BI to the view and built DAX measures
5. Designed dashboards by dimension

## Analysis Framework (8 dimensions)

| # | Dimension |
|---|-----------|
| 1 | Sales & Revenue Performance |
| 2 | Product Category Performance |
| 3 | Customer Behavior & Segmentation (RFM) |
| 4 | Geography / Regional Analysis |
| 5 | Payment Behavior |
| 6 | Delivery & Logistics Performance |
| 7 | Customer Satisfaction / Reviews |
| 8 | Seller Performance |

## Key Insights
- [insight 1 + number]
- [insight 2 + number]
- [insight 3 + number]

See the Notion page above for dashboard screenshots and detailed findings.

## Skills Demonstrated
SQL (JOIN, CTE, window functions, VIEW) · Data modeling · DAX · RFM segmentation · Dashboard design

## Files
- [sql](olist.sql)
- `powerbi/olist_project.pbix` : Power BI file

## Author
Daishi Takeuchi · [LinkedIn](PASTE_LINKEDIN_LINK)
