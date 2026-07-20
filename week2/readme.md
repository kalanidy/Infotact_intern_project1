# Day 8 - Load Cleaned Web Analytics Data into Shared Database

## Objective
Load the cleaned web analytics dataset into the SQL database so it can be used for marketing attribution analysis.

## Tasks Completed
- Created the required database tables.
- Imported cleaned web analytics data.
- Verified successful data loading.
- Checked for missing records after import.

## Technologies Used
- SQL
- MySQL

## Expected Outcome
A structured database containing clean web analytics data ready for analysis.

# Day 9 - Data Validation and Schema Verification

## Objective

Validate the imported marketing datasets to ensure data quality before performing customer journey and attribution analysis.

## Tasks Completed

- Verified row counts for all tables.
- Checked duplicate primary keys.
- Identified NULL values in important columns.
- Tested joins between related tables.
- Verified referential consistency between datasets.

## SQL Concepts Used

- COUNT()
- GROUP BY
- HAVING
- INNER JOIN
- DISTINCT
- IS NULL

## Outcome

The imported datasets were validated successfully and confirmed to be ready for analytical queries.

# Day 10 - Customer Journey Sequencing

## Objective

Sequence every customer's interaction history using SQL Window Functions. This helps analyze how customers interact with marketing campaigns before making a purchase.

## Tasks Completed

- Displayed raw customer event data.
- Generated customer journey sequence using `ROW_NUMBER()`.
- Sequenced events within each session.
- Counted the total number of events per customer.
- Identified first and last customer interactions.
- Built a chronological customer journey timeline.
- Verified customer journey statistics.

## SQL Concepts Used

- ROW_NUMBER()
- OVER()
- PARTITION BY
- ORDER BY
- COUNT()
- MIN()
- MAX()
- GROUP BY

## Outcome

Successfully generated ordered customer journeys that will be used for multi-touch attribution analysis and ROI calculations.

# Day 11 - Query Optimization

## Objective

Improve SQL query performance for customer journey sequencing using indexes and PostgreSQL query optimization techniques.

## Tasks Completed

- Created indexes on customer_id and timestamp.
- Created a composite index for customer_id and timestamp.
- Analyzed the events table using ANALYZE.
- Examined query execution using EXPLAIN ANALYZE.
- Executed an optimized customer journey sequencing query.
- Identified customers with the highest number of events.

## SQL Concepts Used

- CREATE INDEX
- Composite Index
- ANALYZE
- EXPLAIN ANALYZE
- ROW_NUMBER()
- GROUP BY
- ORDER BY

## Outcome

Optimized analytical queries for faster execution, improving the performance of customer journey analysis.