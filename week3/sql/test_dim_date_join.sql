-- Week 3 - Day 20
-- Test dim_date Join with Transactions

SELECT

    d.full_date,
    d.month_name,
    d.quarter,
    d.year,

    COUNT(t.transaction_id) AS total_transactions,

    ROUND(SUM(t.gross_revenue), 2) AS total_revenue

FROM dim_date d

LEFT JOIN transactions t

ON d.full_date = DATE(t.timestamp)

GROUP BY

    d.full_date,
    d.month_name,
    d.quarter,
    d.year

ORDER BY d.full_date;