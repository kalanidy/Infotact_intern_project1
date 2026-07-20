-- ============================================================
-- Day 11 - Query Optimization for Customer Journey Analysis
-- Project: Multi-Touch Marketing Attribution & ROI Dashboard
-- ============================================================

------------------------------------------------------------
-- 1. Create Index on customer_id
------------------------------------------------------------

CREATE INDEX idx_events_customer
ON events(customer_id);

------------------------------------------------------------
-- 2. Create Index on timestamp
------------------------------------------------------------

CREATE INDEX idx_events_timestamp
ON events(timestamp);

------------------------------------------------------------
-- 3. Create Composite Index
------------------------------------------------------------

CREATE INDEX idx_events_customer_timestamp
ON events(customer_id, timestamp);

------------------------------------------------------------
-- 4. View Existing Indexes
------------------------------------------------------------

SELECT
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'events';

------------------------------------------------------------
-- 5. Analyze Events Table
------------------------------------------------------------

ANALYZE events;

------------------------------------------------------------
-- 6. Explain Query Execution Plan
------------------------------------------------------------

EXPLAIN ANALYZE
SELECT
    customer_id,
    event_id,
    timestamp,

    ROW_NUMBER() OVER(
        PARTITION BY customer_id
        ORDER BY timestamp
    ) AS journey_step

FROM events;

------------------------------------------------------------
-- 7. Optimized Customer Journey Query
------------------------------------------------------------

SELECT
    customer_id,
    event_id,
    event_type,
    timestamp,

    ROW_NUMBER() OVER(
        PARTITION BY customer_id
        ORDER BY timestamp
    ) AS journey_step

FROM events
ORDER BY customer_id, timestamp;

------------------------------------------------------------
-- 8. Top 20 Customers with Most Events
------------------------------------------------------------

SELECT
    customer_id,
    COUNT(*) AS total_events
FROM events
GROUP BY customer_id
ORDER BY total_events DESC
LIMIT 20;