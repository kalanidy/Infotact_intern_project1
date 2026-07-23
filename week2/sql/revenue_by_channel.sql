-- Week 3 - Day 15
-- Revenue by Channel and Campaign

SELECT

    e.traffic_source AS channel,

    e.campaign_id,

    COUNT(DISTINCT t.transaction_id) AS total_transactions,

    ROUND(SUM(t.gross_revenue),2) AS total_revenue

FROM transactions t

JOIN events e

ON t.customer_id = e.customer_id

WHERE

datetime(e.timestamp) <= datetime(t.timestamp)

GROUP BY

e.traffic_source,
e.campaign_id

ORDER BY

total_revenue DESC;