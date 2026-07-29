-- Week 3 - Day 17
-- ROAS Comparison by Attribution Model

WITH touchpoints AS (

    SELECT

        t.transaction_id,
        t.customer_id,
        t.gross_revenue,

        e.event_id,
        UPPER(e.traffic_source) AS traffic_source,

        datetime(e.timestamp) AS touch_time,
        datetime(t.timestamp) AS conversion_time,

        ROW_NUMBER() OVER (
            PARTITION BY t.transaction_id
            ORDER BY datetime(e.timestamp)
        ) AS first_touch,

        ROW_NUMBER() OVER (
            PARTITION BY t.transaction_id
            ORDER BY datetime(e.timestamp) DESC
        ) AS last_touch,

        COUNT(*) OVER (
            PARTITION BY t.transaction_id
        ) AS total_touchpoints

    FROM transactions t

    JOIN events e
        ON t.customer_id = e.customer_id

    WHERE
        datetime(e.timestamp) <= datetime(t.timestamp)
        AND e.event_type IN ('view','click')

),

revenue AS (

    SELECT

        traffic_source,

        SUM(
            CASE
                WHEN first_touch = 1
                THEN gross_revenue
                ELSE 0
            END
        ) AS first_click_revenue,

        SUM(
            CASE
                WHEN last_touch = 1
                THEN gross_revenue
                ELSE 0
            END
        ) AS last_click_revenue,

        SUM(
            gross_revenue * (1.0 / total_touchpoints)
        ) AS linear_revenue

    FROM touchpoints

    GROUP BY traffic_source

),

spend AS (

    SELECT

        UPPER(channel) AS channel,

        SUM(ad_spend) AS total_spend

    FROM ad_spend

    GROUP BY UPPER(channel)

)

SELECT

    r.traffic_source AS channel,

    ROUND(r.first_click_revenue,2) AS first_click_revenue,

    ROUND(r.last_click_revenue,2) AS last_click_revenue,

    ROUND(r.linear_revenue,2) AS linear_revenue,

    ROUND(s.total_spend,2) AS total_spend,

    ROUND(
        r.first_click_revenue / s.total_spend,
        2
    ) AS first_click_roas,

    ROUND(
        r.last_click_revenue / s.total_spend,
        2
    ) AS last_click_roas,

    ROUND(
        r.linear_revenue / s.total_spend,
        2
    ) AS linear_roas

FROM revenue r

JOIN spend s

ON r.traffic_source = s.channel

ORDER BY linear_roas DESC;