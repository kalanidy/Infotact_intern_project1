# Week 3 - Day 1

## Revenue by Channel

### Objective
Prepare revenue data for ROAS calculation by summarizing revenue for each marketing channel and campaign.

### Tasks Completed
- Joined transactions with marketing events.
- Calculated total revenue by channel and campaign.
- Counted transactions for each campaign.
- Exported the revenue summary.

### Output
- `revenue_by_channel.csv`

### Outcome
Revenue data is prepared for ROAS calculation in Day 1

# Week 3 - Day 2

## ROAS Calculation

### Objective
Calculate Return on Ad Spend (ROAS) for each marketing channel.

### Tasks Completed
- Calculated total revenue by channel.
- Calculated total ad spend by channel.
- Computed ROAS values.
- Exported the ROAS report.

### Output
- roas_by_channel.csv

### Outcome
ROAS was successfully calculated for each marketing channel.

# Week 3 - Day 3

## ROAS by Attribution Model

### Objective
Compare ROAS values across First-Click, Last-Click and Linear attribution models.

### Tasks Completed
- Calculated ROAS using First-Click Attribution.
- Calculated ROAS using Last-Click Attribution.
- Calculated ROAS using Linear Attribution.
- Exported comparison report.

### Output
- roas_by_attribution.csv

### Outcome
ROAS comparison is ready for dashboard visualization.

# Week 3 - Day 4

## Date Dimension Design

### Objective
Design the Date Dimension table for analytics and reporting.

### Tasks Completed
- Created the `dim_date` table.
- Added calendar attributes.
- Prepared the table for reporting and dashboard joins.

### Output
- create_dim_date.sql

### Outcome
The Date Dimension table structure was successfully created.

# Week 3 - Day 5

## Populate Date Dimension

### Objective
Populate the `dim_date` table with calendar dates.

### Tasks Completed
- Generated dates from 2021 to 2025.
- Filled calendar attributes.
- Inserted records into SQLite.

### Output
- Populated `dim_date` table

### Outcome
The Date Dimension is ready for joining with fact tables.

# Week 3 - Day 6

## Test Date Dimension Join

### Objective
Validate the relationship between the Date Dimension and Transactions table.

### Tasks Completed
- Joined dim_date with transactions.
- Verified transaction counts and revenue by date.
- Exported validation results.

### Output
- dim_date_join_validation.csv