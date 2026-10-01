# olist-ecommerce-powerbi-project
Olist E-Commerce Dashboard (Power BI + MySQL)

End-to-end analysis of a Brazilian e-commerce marketplace: SQL data cleaning → Power BI dashboard → business insights.

Show Image

Objective

Answer 40 business questions across 8 dimensions to understand sales, customers, logistics, and satisfaction.

Dataset

Olist Brazilian E-Commerce (Kaggle, public data)

Tools
MySQL: data cleaning, JOINs, window functions, VIEW
Power BI: data model, DAX measures, dashboards
Excel: supporting checks
Workflow
Imported 8 CSV tables into MySQL (LOAD DATA LOCAL INFILE)
Cleaned data: filled 610 missing product categories as unknown; deduplicated reviews to 1 per order using ROW_NUMBER()
Built the olist_master VIEW joining orders, items, customers, products, sellers, payments, and reviews
Connected Power BI to the view and built DAX measures
Designed dashboards by dimension
Analysis Framework (8 dimensions)
#	Dimension
1	Sales & Revenue Performance
2	Product Category Performance
3	Customer Behavior & Segmentation (RFM)
4	Geography / Regional Analysis
5	Payment Behavior
6	Delivery & Logistics Performance
7	Customer Satisfaction / Reviews
8	Seller Performance
Key Insights
Skills Demonstrated

SQL (JOIN, CTE, window functions, VIEW) · Data modeling · DAX · RFM segmentation · Dashboard design

Files
sql/ : import, cleaning, and olist_master view scripts
powerbi/ : olist_project.pbix file

Author
Daishi Takeuchi · LinkedIn
