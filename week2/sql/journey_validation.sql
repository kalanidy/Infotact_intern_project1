-- ============================================================
-- Day 12 - Customer Journey Validation
-- Project: Multi-Touch Marketing Attribution & ROI Dashboard
-- ============================================================

------------------------------------------------------------
-- 1. Generate Customer Journey Sequence
------------------------------------------------------------

SELECT
    customer_id,
    event_id,
    timestamp,
    event_type,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY timestamp
    ) AS journey_step
FROM events
ORDER BY customer_id, journey_step;

------------------------------------------------------------
-- 2. Verify Number of Events Per Customer
------------------------------------------------------------

SELECT
    customer_id,
    COUNT(*) AS total_events
FROM events
GROUP BY customer_id
ORDER BY total_events DESC;

------------------------------------------------------------
-- 3. First Event for Each Customer
------------------------------------------------------------

SELECT
    customer_id,
    MIN(timestamp) AS first_event
FROM events
GROUP BY customer_id
ORDER BY first_event;

------------------------------------------------------------
-- 4. Last Event for Each Customer
------------------------------------------------------------

SELECT
    customer_id,
    MAX(timestamp) AS last_event
FROM events
GROUP BY customer_id
ORDER BY last_event DESC;

------------------------------------------------------------
-- 5. Customers Having More Than One Event
------------------------------------------------------------

SELECT
    customer_id,
    COUNT(*) AS event_count
FROM events
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY event_count DESC;

------------------------------------------------------------
-- 6. Validate Session Order
------------------------------------------------------------

SELECT
    session_id,
    customer_id,
    event_type,
    timestamp,
    ROW_NUMBER() OVER (
        PARTITION BY session_id
        ORDER BY timestamp
    ) AS session_step
FROM events
ORDER BY session_id, session_step;

------------------------------------------------------------
-- 7. Distribution of Event Types
------------------------------------------------------------

SELECT
    event_type,
    COUNT(*) AS total_events
FROM events
GROUP BY event_type
ORDER BY total_events DESC;

------------------------------------------------------------
-- 8. Verify Campaign Usage
------------------------------------------------------------

SELECT
    campaign_id,
    COUNT(*) AS total_events
FROM events
GROUP BY campaign_id
ORDER BY total_events DESC;

------------------------------------------------------------
-- 9. Verify Device Distribution
------------------------------------------------------------

SELECT
    device_type,
    COUNT(*) AS total_events
FROM events
GROUP BY device_type
ORDER BY total_events DESC;

------------------------------------------------------------
-- 10. Journey Summary
------------------------------------------------------------

SELECT
    customer_id,
    COUNT(*) AS total_events,
    MIN(timestamp) AS first_interaction,
    MAX(timestamp) AS last_interaction
FROM events
GROUP BY customer_id
ORDER BY customer_id;