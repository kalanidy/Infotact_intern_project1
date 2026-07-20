-- ============================================================
-- Day 14 - Customer Journey Path Summary
-- Project: Multi-Touch Marketing Attribution & ROI Dashboard
-- ============================================================

------------------------------------------------------------
-- 1. Customer Journey Summary
------------------------------------------------------------

SELECT
    customer_id,
    COUNT(*) AS total_events,
    MIN(timestamp) AS first_interaction,
    MAX(timestamp) AS last_interaction,
    MAX(timestamp) - MIN(timestamp) AS journey_duration
FROM events
GROUP BY customer_id
ORDER BY customer_id;

------------------------------------------------------------
-- 2. Event Distribution by Customer
------------------------------------------------------------

SELECT
    customer_id,
    event_type,
    COUNT(*) AS event_count
FROM events
GROUP BY customer_id, event_type
ORDER BY customer_id, event_count DESC;

------------------------------------------------------------
-- 3. Campaign Participation Summary
------------------------------------------------------------

SELECT
    campaign_id,
    COUNT(*) AS total_customer_events,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM events
GROUP BY campaign_id
ORDER BY total_customer_events DESC;

------------------------------------------------------------
-- 4. Traffic Source Summary
------------------------------------------------------------

SELECT
    traffic_source,
    COUNT(*) AS total_events,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM events
GROUP BY traffic_source
ORDER BY total_events DESC;

------------------------------------------------------------
-- 5. Device Type Summary
------------------------------------------------------------

SELECT
    device_type,
    COUNT(*) AS total_events,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM events
GROUP BY device_type
ORDER BY total_events DESC;

------------------------------------------------------------
-- 6. Average Session Duration by Traffic Source
------------------------------------------------------------

SELECT
    traffic_source,
    ROUND(AVG(session_duration_sec),2) AS avg_session_duration
FROM events
GROUP BY traffic_source
ORDER BY avg_session_duration DESC;

------------------------------------------------------------
-- 7. Most Active Customers
------------------------------------------------------------

SELECT
    customer_id,
    COUNT(*) AS total_events
FROM events
GROUP BY customer_id
ORDER BY total_events DESC
LIMIT 20;

------------------------------------------------------------
-- 8. Customer Journey Duration Summary
------------------------------------------------------------

SELECT
    customer_id,
    ROUND(
        EXTRACT(EPOCH FROM (MAX(timestamp)-MIN(timestamp)))/3600,
        2
    ) AS journey_duration_hours
FROM events
GROUP BY customer_id
ORDER BY journey_duration_hours DESC;

------------------------------------------------------------
-- 9. Overall Journey Statistics
------------------------------------------------------------

SELECT
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(*) AS total_events,
    ROUND(AVG(session_duration_sec),2) AS avg_session_duration,
    MIN(timestamp) AS dataset_start,
    MAX(timestamp) AS dataset_end
FROM events;

------------------------------------------------------------
-- 10. Top Campaigns by Customer Engagement
------------------------------------------------------------

SELECT
    campaign_id,
    COUNT(*) AS engagement_count
FROM events
GROUP BY campaign_id
ORDER BY engagement_count DESC
LIMIT 10;