-- Week 2 - Day 10
-- Validate Linear Attribution Weights

WITH customer_touchpoints AS (

    SELECT
        t.transaction_id,
        t.customer_id,
        t.timestamp AS conversion_time,
        t.gross_revenue,

        e.event_id,
        e.timestamp AS touchpoint_time,
        e.campaign_id,
        e.traffic_source

    FROM transactions t

    JOIN events e
        ON t.customer_id = e.customer_id

    WHERE
        datetime(e.timestamp) <= datetime(t.timestamp)
        AND e.event_type IN ('view','click')

),

touchpoint_count AS (

    SELECT
        transaction_id,
        COUNT(event_id) AS total_touchpoints

    FROM customer_touchpoints

    GROUP BY transaction_id

),

linear_attribution AS (

    SELECT
        ct.transaction_id,
        1.0 / tc.total_touchpoints AS attribution_weight

    FROM customer_touchpoints ct

    JOIN touchpoint_count tc
        ON ct.transaction_id = tc.transaction_id
)

SELECT

    transaction_id,

    COUNT(*) AS touchpoints,

    ROUND(SUM(attribution_weight),4) AS total_weight,

    CASE
        WHEN ROUND(SUM(attribution_weight),4) = 1.0000
        THEN 'PASS'
        ELSE 'FAIL'
    END AS validation_status

FROM linear_attribution

GROUP BY transaction_id

ORDER BY transaction_id;