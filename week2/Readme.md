## Week 2 - Day 1

### Linear Attribution Design

- Drafted the Linear Attribution model pseudocode.
- Defined equal credit distribution across all customer touchpoints.
- Defined attribution weight and attributed revenue calculations.

### Outcome
The Linear Attribution logic is ready for SQL implementation.

# Week 2 - Day 2

## Linear Attribution SQL

### Objective
Implement the Linear Attribution model using SQL.

### Tasks Completed
- Connected customer transactions with previous marketing touchpoints.
- Counted touchpoints for each conversion.
- Assigned equal attribution weight to every touchpoint.
- Calculated attributed revenue.
- Exported the attribution results to `linear_attribution.csv`.

### Output
- `linear_attribution.csv`

### Outcome
The Linear Attribution model was successfully implemented and is ready for validation.

# Week 2 - Day 3

## Linear Attribution Validation

### Objective
Validate that the Linear Attribution weights sum to 100% for each conversion.

### Tasks Completed
- Verified attribution weights for every transaction.
- Calculated total weight per conversion.
- Identified PASS/FAIL status.
- Exported the validation report.

### Output
- `linear_attribution_validation.csv`

### Outcome
The Linear Attribution model was successfully validated.