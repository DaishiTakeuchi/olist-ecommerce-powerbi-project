CREATE TABLE customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(5)
);

CREATE TABLE orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);

CREATE TABLE products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

CREATE TABLE sellers (
    seller_id VARCHAR(50),
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(5)
);

CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);

CREATE TABLE order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

CREATE TABLE category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);

LOAD DATA LOCAL INFILE 'D:/olistproject/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/olistproject/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/olistproject/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/olistproject/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/olistproject/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE 'D:/olistproject/olist_order_payments_dataset.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/olistproject/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'D:/olistproject/product_category_name_translation.csv'
INTO TABLE category_translation
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW WARNINGS;
 
-- เช็คโรลของแต่ละคอลัม
SELECT 'customers' AS tbl, COUNT(*) AS row_count FROM customers
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL SELECT 'category_translation', COUNT(*) FROM category_translation;

-- เช็คว่ามี review_score ที่ไม่ใช่ 1-5 ไหม (ถ้ามี แสดงว่าข้อมูลเลื่อนคอลัมน์ผิด)
SELECT COUNT(*) AS bad_score_rows
FROM order_reviews
WHERE review_score NOT BETWEEN 1 AND 5 OR review_score IS NULL;

-- เช็คว่ามี order_id ที่รูปแบบผิดปกติไหม (ควรเป็นรหัส 32 ตัวอักษร)
SELECT COUNT(*) AS bad_order_id_rows
FROM order_reviews
WHERE LENGTH(order_id) != 32;

SELECT COUNT(*) AS missing_delivery_date
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;
  
SELECT order_status, COUNT(*) AS jumlah
FROM orders
GROUP BY order_status
ORDER BY jumlah DESC;

SELECT COUNT(*) AS missing_category
FROM products
WHERE product_category_name IS NULL OR product_category_name = '';

SELECT
    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS missing_weight,
    SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS missing_length,
    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) AS missing_photos
FROM products;

SET SQL_SAFE_UPDATES = 0;

UPDATE products
SET product_category_name = 'unknown'
WHERE product_category_name IS NULL OR product_category_name = '';

SET SQL_SAFE_UPDATES = 1;

-- เช็ค order_id ซ้ำใน reviews
SELECT order_id, COUNT(*) AS dup_count
FROM order_reviews
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY dup_count DESC
LIMIT 20;

-- เช็ค order ที่ไม่มีรายการสินค้าเลย
SELECT COUNT(DISTINCT o.order_id) AS orders_without_items
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;

-- กรองให้เหลือรีวิวล่าสุดต่อ order_id
SELECT order_id, review_score, review_creation_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY review_creation_date DESC) AS rn
    FROM order_reviews
) t
WHERE rn = 1;

CREATE OR REPLACE VIEW olist_master AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    c.customer_unique_id,
    c.customer_city,
    c.customer_state,

    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,

    p.product_category_name,
    ct.product_category_name_english,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,

    s.seller_city,
    s.seller_state,

    COALESCE(op.payment_type, 'unknown') AS payment_type,
    op.payment_installments,
    op.payment_value,

    r.review_score

FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN category_translation ct ON p.product_category_name = ct.product_category_name
LEFT JOIN sellers s ON oi.seller_id = s.seller_id
LEFT JOIN order_payments op ON o.order_id = op.order_id
LEFT JOIN (
    SELECT order_id, review_score,
           ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY review_creation_date DESC) AS rn
    FROM order_reviews
) r ON o.order_id = r.order_id AND r.rn = 1;


-- เช็คจำนวนแถวทั้งหมดใน view
SELECT COUNT(*) AS total_rows FROM olist_master;

-- เช็คจำนวน order ที่ไม่ซ้ำ (
SELECT COUNT(DISTINCT order_id) AS unique_orders FROM olist_master;

-- ดูตัวอย่างข้อมูล 10 แถวแรก
SELECT * FROM olist_master LIMIT 10;
