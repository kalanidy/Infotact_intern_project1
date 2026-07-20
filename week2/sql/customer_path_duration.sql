-- ============================================================
-- Day 13 - Customer Path Duration Analysis
-- Project: Multi-Touch Marketing Attribution & ROI Dashboard
-- ============================================================

------------------------------------------------------------
-- 1. First and Last Interaction of Each Customer
------------------------------------------------------------

SELECT
    customer_id,
    MIN(timestamp) AS first_interaction,
    MAX(timestamp) AS last_interaction
FROM events
GROUP BY customer_id
ORDER BY customer_id;

------------------------------------------------------------
-- 2. Customer Journey Duration
------------------------------------------------------------

SELECT
    customer_id,
    MIN(timestamp) AS first_interaction,
    MAX(timestamp) AS last_interaction,
    MAX(timestamp) - MIN(timestamp) AS journey_duration
FROM events
GROUP BY customer_id
ORDER BY journey_duration DESC;

------------------------------------------------------------
-- 3. Journey Duration in Hours
------------------------------------------------------------

SELECT
    customer_id,
    ROUND(
        EXTRACT(EPOCH FROM (MAX(timestamp) - MIN(timestamp))) / 3600,
        2
    ) AS duration_hours
FROM events
GROUP BY customer_id
ORDER BY duration_hours DESC;

------------------------------------------------------------
-- 4. Journey Duration in Days
------------------------------------------------------------

SELECT
    customer_id,
    ROUND(
        EXTRACT(EPOCH FROM (MAX(timestamp) - MIN(timestamp))) / 86400,
        2
    ) AS duration_days
FROM events
GROUP BY customer_id
ORDER BY duration_days DESC;

------------------------------------------------------------
-- 5. Number of Events Per Customer
------------------------------------------------------------

SELECT
    customer_id,
    COUNT(*) AS total_events
FROM events
GROUP BY customer_id
ORDER BY total_events DESC;

------------------------------------------------------------
-- 6. Average Session Duration by Customer
------------------------------------------------------------

SELECT
    customer_id,
    ROUND(AVG(session_duration_sec),2) AS avg_session_duration_sec
FROM events
GROUP BY customer_id
ORDER BY avg_session_duration_sec DESC;

------------------------------------------------------------
-- 7. Longest Customer Journeys
------------------------------------------------------------

SELECT
    customer_id,
    COUNT(*) AS events,
    MIN(timestamp) AS first_event,
    MAX(timestamp) AS last_event,
    MAX(timestamp)-MIN(timestamp) AS duration
FROM events
GROUP BY customer_id
ORDER BY duration DESC
LIMIT 20;

------------------------------------------------------------
-- 8. Customers with Single Event
------------------------------------------------------------

SELECT
    customer_id,
    COUNT(*) AS total_events
FROM events
GROUP BY customer_id
HAVING COUNT(*) = 1;

------------------------------------------------------------
-- 9. Overall Dataset Summary
------------------------------------------------------------

SELECT
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(*) AS total_events,
    MIN(timestamp) AS dataset_start,
    MAX(timestamp) AS dataset_end
FROM events;