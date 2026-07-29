-- Week 3 - Day 16
-- ROAS (Return on Ad Spend) by Marketing Channel

WITH revenue AS (

    SELECT

        e.traffic_source AS channel,

        ROUND(SUM(t.gross_revenue),2) AS total_revenue

    FROM transactions t

    JOIN events e
        ON t.customer_id = e.customer_id

    WHERE datetime(e.timestamp) <= datetime(t.timestamp)

    GROUP BY e.traffic_source

),

spend AS (

    SELECT

        channel,

        ROUND(SUM(ad_spend),2) AS total_spend

    FROM ad_spend

    GROUP BY channel

)

SELECT

    r.channel,

    r.total_revenue,

    s.total_spend,

    ROUND(
        r.total_revenue / s.total_spend,
        2
    ) AS roas

FROM revenue r

JOIN spend s
ON r.channel = s.channel

ORDER BY roas DESC;