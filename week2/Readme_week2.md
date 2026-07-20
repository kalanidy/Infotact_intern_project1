# Week 2 - Linear Attribution Model

## Objective
Implement and validate the Linear Attribution model using SQL to distribute conversion credit equally across all customer touchpoints.

---

## Attribution Models

### 1. First-Click Attribution
- Assigns 100% of the conversion credit to the first marketing touchpoint.
- Useful for identifying channels that initiate customer journeys.

### 2. Last-Click Attribution
- Assigns 100% of the conversion credit to the final touchpoint before conversion.
- Useful for identifying channels that directly drive conversions.

### 3. Linear Attribution
- Distributes conversion credit equally across every touchpoint in the customer journey.
- Every interaction receives the same attribution weight.

---

## Linear Attribution Logic

The Linear Attribution model follows these steps:

1. Identify all customer conversions.
2. Retrieve all marketing touchpoints before each conversion.
3. Count the number of touchpoints.
4. Calculate the attribution weight:
## Attribution Weight = 1 / Total Touchpoints
5. Calculate attributed revenue:
## Attributed Revenue = Gross Revenue × Attribution Weight



---

## Example

| Customer Journey | Revenue |
|------------------|---------|
| Google → Facebook → Email → Purchase | $120 |

There are **3 touchpoints**.

| Channel | Attribution Weight | Attributed Revenue |
|----------|-------------------:|-------------------:|
| Google | 33.33% | $40.00 |
| Facebook | 33.33% | $40.00 |
| Email | 33.33% | $40.00 |

Total attribution = **100%**.

---

## SQL Files

- `linear_attribution.sql`
- `validate_linear_attribution.sql`
- `attribution_comparison.sql`

---

## Output Files

- `linear_attribution.csv`
- `linear_attribution_validation.csv`
- `attribution_comparison.csv`

---

## Week 2 Deliverables

- Database created using SQLite.
- Customer, transaction, and event datasets loaded.
- Linear Attribution SQL implemented.
- Attribution validation completed.
- Comparison of First-Click, Last-Click, and Linear models completed.
- Documentation completed.

---

## Outcome

The Linear Attribution model has been successfully implemented, validated, and documented. The project is now ready for Week 3 Power BI dashboard development.