-- Week 2 - Day 9
-- Linear Attribution Model

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

)

SELECT

    ct.transaction_id,

    ct.customer_id,

    ct.event_id,

    ct.campaign_id,

    ct.traffic_source,

    ct.touchpoint_time,

    ct.conversion_time,

    ct.gross_revenue,

    tc.total_touchpoints,

    ROUND(
        1.0 / tc.total_touchpoints,
        4
    ) AS attribution_weight,

    ROUND(
        ct.gross_revenue /
        tc.total_touchpoints,
        2
    ) AS attributed_revenue

FROM customer_touchpoints ct

JOIN touchpoint_count tc

ON ct.transaction_id = tc.transaction_id

ORDER BY

ct.transaction_id,
ct.touchpoint_time;