-- ===========================================
-- Day 8 - Database Setup and Data Loading
-- Project: Multi-Touch Marketing Attribution & ROI Dashboard
-- ===========================================

-- Drop existing tables (optional, for rerunning the script)

DROP TABLE IF EXISTS ad_spend CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS events CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS campaigns CASCADE;

----------------------------------------------------
-- Campaigns
----------------------------------------------------

CREATE TABLE campaigns (
    campaign_id NUMERIC PRIMARY KEY,
    channel VARCHAR(100),
    objective VARCHAR(100),
    start_date DATE,
    end_date DATE,
    target_segment VARCHAR(100),
    expected_uplift NUMERIC(10,2)
);

----------------------------------------------------
-- Customers
----------------------------------------------------

CREATE TABLE customers (
    customer_id NUMERIC PRIMARY KEY,
    signup_date DATE,
    country VARCHAR(100),
    age INT,
    gender VARCHAR(20),
    loyalty_tier VARCHAR(50),
    acquisition_channel VARCHAR(100)
);

----------------------------------------------------
-- Products
----------------------------------------------------

CREATE TABLE products (
    product_id NUMERIC PRIMARY KEY,
    category VARCHAR(100),
    brand VARCHAR(100),
    base_price NUMERIC(10,2),
    launch_date DATE,
    is_premium BOOLEAN
);

----------------------------------------------------
-- Events
----------------------------------------------------

CREATE TABLE events (
    event_id NUMERIC PRIMARY KEY,
    timestamp TIMESTAMP,
    customer_id NUMERIC,
    session_id BIGINT,
    event_type VARCHAR(100),
    product_id NUMERIC,
    device_type VARCHAR(50),
    traffic_source VARCHAR(100),
    campaign_id NUMERIC,
    page_category VARCHAR(100),
    session_duration_sec NUMERIC(10,2),
    experiment_group VARCHAR(50)
);

----------------------------------------------------
-- Transactions
----------------------------------------------------

CREATE TABLE transactions (
    transaction_id NUMERIC PRIMARY KEY,
    timestamp TIMESTAMP,
    customer_id NUMERIC,
    product_id NUMERIC,
    quantity INT,
    discount_applied NUMERIC(10,2),
    gross_revenue NUMERIC(12,2),
    campaign_id NUMERIC,
    refund_flag BOOLEAN
);

----------------------------------------------------
-- Ad Spend
----------------------------------------------------

CREATE TABLE ad_spend (
    spend_id VARCHAR(20) PRIMARY KEY,
    date DATE,
    campaign_id NUMERIC,
    channel VARCHAR(100),
    utm_source VARCHAR(100),
    utm_medium VARCHAR(100),
    utm_campaign VARCHAR(100),
    impressions INT,
    clicks INT,
    ad_spend NUMERIC(12,2),
    currency VARCHAR(20)
);

----------------------------------------------------
-- Verification Queries
----------------------------------------------------

SELECT COUNT(*) AS campaigns_count FROM campaigns;
SELECT COUNT(*) AS customers_count FROM customers;
SELECT COUNT(*) AS products_count FROM products;
SELECT COUNT(*) AS events_count FROM events;
SELECT COUNT(*) AS transactions_count FROM transactions;
SELECT COUNT(*) AS ad_spend_count FROM ad_spend;