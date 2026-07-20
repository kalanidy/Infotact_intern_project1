-- ============================================================
-- Day 10 - Customer Journey Sequencing
-- Project: Multi-Touch Marketing Attribution & ROI Dashboard
-- Description:
-- Assign a sequential order to every customer event using
-- the ROW_NUMBER() window function.
-- ============================================================

---------------------------------------------------------------
-- 1. Display Raw Events
---------------------------------------------------------------

SELECT *
FROM events
LIMIT 10;

---------------------------------------------------------------
-- 2. Sequence Customer Journey
---------------------------------------------------------------

SELECT
    customer_id,
    event_id,
    timestamp,
    event_type,
    traffic_source,
    campaign_id,

    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY timestamp
    ) AS journey_step

FROM events
ORDER BY customer_id, journey_step;

---------------------------------------------------------------
-- 3. Sequence Events Within Each Session
---------------------------------------------------------------

SELECT
    session_id,
    customer_id,
    event_id,
    timestamp,
    event_type,

    ROW_NUMBER() OVER (
        PARTITION BY session_id
        ORDER BY timestamp
    ) AS session_step

FROM events
ORDER BY session_id, session_step;

---------------------------------------------------------------
-- 4. Count Events Per Customer
---------------------------------------------------------------

SELECT
    customer_id,
    COUNT(*) AS total_events
FROM events
GROUP BY customer_id
ORDER BY total_events DESC;

---------------------------------------------------------------
-- 5. First Customer Interaction
---------------------------------------------------------------

SELECT
    customer_id,
    MIN(timestamp) AS first_interaction
FROM events
GROUP BY customer_id
ORDER BY first_interaction;

---------------------------------------------------------------
-- 6. Last Customer Interaction
---------------------------------------------------------------

SELECT
    customer_id,
    MAX(timestamp) AS last_interaction
FROM events
GROUP BY customer_id
ORDER BY last_interaction DESC;

---------------------------------------------------------------
-- 7. Customer Journey Timeline
---------------------------------------------------------------

SELECT
    customer_id,
    event_type,
    timestamp,

    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY timestamp
    ) AS journey_step

FROM events
ORDER BY customer_id, timestamp;

---------------------------------------------------------------
-- 8. Verify Journey Sequence
---------------------------------------------------------------

SELECT
    customer_id,
    COUNT(*) AS events_in_journey,
    MIN(timestamp) AS journey_start,
    MAX(timestamp) AS journey_end
FROM events
GROUP BY customer_id
ORDER BY customer_id;