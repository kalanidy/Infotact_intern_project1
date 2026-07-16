# Week 2 - Day 1

## Linear Attribution Model - Pseudocode

### Objective
Design the logic for distributing equal conversion credit across all marketing touchpoints in a customer's journey.

### Pseudocode

1. Identify all customers who completed a conversion.
2. Find all marketing touchpoints that occurred before each conversion.
3. Group touchpoints by conversion.
4. Count the total number of touchpoints for each conversion.
5. Calculate equal attribution weight:

   Attribution Weight = 1 / Total Number of Touchpoints

6. Assign the calculated weight to every touchpoint.
7. Distribute conversion value equally across all touchpoints:

   Attributed Revenue = Conversion Revenue × Attribution Weight

8. Verify that the attribution weights for each conversion sum to 1 or 100%.

### Example

A customer has 4 touchpoints before purchasing:

| Touchpoint | Channel | Weight |
|------------|---------|--------|
| 1      | Paid Search | 25%    |
| 2      | Social |         25% |
| 3      | Email | 25%          |
| 4      | Affiliate      | 25% |

Total attribution = 100%.