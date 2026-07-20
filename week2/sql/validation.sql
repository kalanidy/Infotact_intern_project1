-- ===========================================
-- Day 9 - Data Validation and Schema Verification
-- Project: Multi-Touch Marketing Attribution & ROI Dashboard
-- ===========================================

----------------------------------------------------
-- 1. Verify Row Counts
----------------------------------------------------

SELECT COUNT(*) AS campaigns_count FROM campaigns;
SELECT COUNT(*) AS customers_count FROM customers;
SELECT COUNT(*) AS products_count FROM products;
SELECT COUNT(*) AS events_count FROM events;
SELECT COUNT(*) AS transactions_count FROM transactions;
SELECT COUNT(*) AS ad_spend_count FROM ad_spend;

----------------------------------------------------
-- 2. Check for Duplicate Primary Keys
----------------------------------------------------

SELECT campaign_id, COUNT(*)
FROM campaigns
GROUP BY campaign_id
HAVING COUNT(*) > 1;

SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT product_id, COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT event_id, COUNT(*)
FROM events
GROUP BY event_id
HAVING COUNT(*) > 1;

SELECT transaction_id, COUNT(*)
FROM transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;

----------------------------------------------------
-- 3. Check for NULL Values
----------------------------------------------------

SELECT *
FROM campaigns
WHERE campaign_id IS NULL;

SELECT *
FROM customers
WHERE customer_id IS NULL;

SELECT *
FROM products
WHERE product_id IS NULL;

SELECT *
FROM events
WHERE event_id IS NULL
   OR customer_id IS NULL
   OR product_id IS NULL;

SELECT *
FROM transactions
WHERE transaction_id IS NULL
   OR customer_id IS NULL
   OR product_id IS NULL;

----------------------------------------------------
-- 4. Validate Table Joins
----------------------------------------------------

-- Events ↔ Customers
SELECT
    e.event_id,
    c.customer_id,
    c.country
FROM events e
JOIN customers c
ON e.customer_id = c.customer_id
LIMIT 10;

-- Events ↔ Products
SELECT
    e.event_id,
    p.product_id,
    p.category
FROM events e
JOIN products p
ON e.product_id = p.product_id
LIMIT 10;

-- Events ↔ Campaigns
SELECT
    e.event_id,
    cp.campaign_id,
    cp.channel
FROM events e
JOIN campaigns cp
ON e.campaign_id = cp.campaign_id
LIMIT 10;

-- Transactions ↔ Customers
SELECT
    t.transaction_id,
    c.customer_id
FROM transactions t
JOIN customers c
ON t.customer_id = c.customer_id
LIMIT 10;

----------------------------------------------------
-- 5. Basic Data Quality Checks
----------------------------------------------------

SELECT MIN(timestamp) AS first_event,
       MAX(timestamp) AS last_event
FROM events;

SELECT MIN(timestamp) AS first_transaction,
       MAX(timestamp) AS last_transaction
FROM transactions;

SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM events;

SELECT COUNT(DISTINCT campaign_id) AS campaigns_used
FROM events;