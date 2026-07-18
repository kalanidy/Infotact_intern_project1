-- Week 2 - Day 11
-- Compare First-Click, Last-Click and Linear Attribution

WITH touchpoints AS (

    SELECT
        t.transaction_id,
        t.customer_id,
        t.gross_revenue,
        e.event_id,
        e.campaign_id,
        e.traffic_source,
        datetime(e.timestamp) AS touch_time,
        datetime(t.timestamp) AS conversion_time

    FROM transactions t
    JOIN events e
        ON t.customer_id = e.customer_id

    WHERE
        datetime(e.timestamp) <= datetime(t.timestamp)
        AND e.event_type IN ('view','click')
),

ranked_touchpoints AS (

    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY transaction_id
               ORDER BY touch_time ASC
           ) AS first_rank,

           ROW_NUMBER() OVER (
               PARTITION BY transaction_id
               ORDER BY touch_time DESC
           ) AS last_rank,

           COUNT(*) OVER (
               PARTITION BY transaction_id
           ) AS total_touchpoints

    FROM touchpoints
)

SELECT

    transaction_id,
    customer_id,
    campaign_id,
    traffic_source,

    CASE
        WHEN first_rank = 1 THEN gross_revenue
        ELSE 0
    END AS first_click_revenue,

    CASE
        WHEN last_rank = 1 THEN gross_revenue
        ELSE 0
    END AS last_click_revenue,

    ROUND(
        gross_revenue / total_touchpoints,
        2
    ) AS linear_revenue

FROM ranked_touchpoints

ORDER BY
transaction_id,
touch_time;