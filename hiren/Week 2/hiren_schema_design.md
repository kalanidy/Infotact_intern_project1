# Day 8 — Relational Schema Design
## Multi-Touch Marketing Attribution & ROI Dashboard
**Issue #31:** Design relational schema for spend/web/conversion tables.

## Overview

Six source files become six tables in the database. Two keys tie
everything together:

- **`campaign_id`** — links `ad_spend` → `campaigns` → `events` → `transactions`
- **`customer_id`** — links `events` → `transactions` → `customers`
- **`product_id`** — links `events` → `transactions` → `products`

```
campaigns ──┬── ad_spend
            ├── events ──┬── customers
            │            └── products
            └── transactions ──┬── customers
                                └── products
```

## Table Definitions

### `campaigns` (dimension — campaign metadata)
```sql
CREATE TABLE campaigns (
    campaign_id      INTEGER PRIMARY KEY,
    channel          TEXT NOT NULL,       -- use channel_clean (lowercase_with_underscores)
    objective        TEXT,
    start_date       DATE,
    end_date         DATE,
    target_segment   TEXT,
    expected_uplift  NUMERIC
);
```

### `ad_spend` (fact — daily spend per campaign)
```sql
CREATE TABLE ad_spend (
    spend_id       TEXT PRIMARY KEY,
    date           DATE NOT NULL,
    campaign_id    INTEGER NOT NULL REFERENCES campaigns(campaign_id),
    channel        TEXT NOT NULL,         -- use channel_clean
    utm_source     TEXT,                  -- use utm_source_clean
    utm_medium     TEXT,
    utm_campaign   TEXT,
    impressions    INTEGER,
    clicks         INTEGER,
    ad_spend       NUMERIC NOT NULL,
    currency       TEXT
);
```

### `customers` (dimension — customer attributes)
```sql
CREATE TABLE customers (
    customer_id           INTEGER PRIMARY KEY,
    signup_date           DATE,
    country               TEXT,
    age                   INTEGER,
    gender                TEXT,
    loyalty_tier          TEXT,
    acquisition_channel   TEXT
);
```

### `products` (dimension — product attributes)
```sql
CREATE TABLE products (
    product_id     INTEGER PRIMARY KEY,
    category       TEXT,
    brand          TEXT,
    base_price     NUMERIC,
    launch_date    DATE,
    is_premium     BOOLEAN
);
```

### `events` (fact — web/session touchpoints)
```sql
CREATE TABLE events (
    event_id               INTEGER PRIMARY KEY,
    timestamp              TIMESTAMP NOT NULL,
    customer_id            INTEGER REFERENCES customers(customer_id),
    session_id             INTEGER NOT NULL,
    event_type             TEXT NOT NULL,   -- view/click/add_to_cart/bounce/purchase
    product_id             INTEGER REFERENCES products(product_id),
    device_type            TEXT,
    traffic_source         TEXT NOT NULL,  -- use traffic_source_clean
    campaign_id            INTEGER REFERENCES campaigns(campaign_id),  -- see note below: source data uses 0 as "no campaign", convert to NULL on load
    page_category          TEXT,
    session_duration_sec   NUMERIC,
    experiment_group       TEXT
);
```

### `transactions` (fact — conversions/purchases)
```sql
CREATE TABLE transactions (
    transaction_id     INTEGER PRIMARY KEY,
    timestamp          TIMESTAMP NOT NULL,
    customer_id        INTEGER NOT NULL REFERENCES customers(customer_id),
    product_id         INTEGER REFERENCES products(product_id),
    quantity           INTEGER,
    discount_applied   NUMERIC,
    gross_revenue      NUMERIC,
    campaign_id        INTEGER REFERENCES campaigns(campaign_id),  -- same 0-as-"no campaign" pattern, convert to NULL on load
    refund_flag        BOOLEAN
);
```

## Notes / decisions made

- `product_id` is nullable in `events` and `transactions` in the source
  data (stored as `float64` due to NaNs) — schema allows NULL rather than
  forcing a value.
- All `channel`/`traffic_source` columns reference the **`_clean`** version
  (lowercase_with_underscores) standardized this week, not the raw values.
- `campaign_id` is NOT NULL in `ad_spend` and `campaigns` (every spend row
  and every campaign must have one), but nullable in `events`/`transactions`
  since not every touchpoint or purchase is necessarily campaign-attributed
  (e.g. direct/organic traffic in events has no real campaign, even if the
  column happens to be populated — worth verifying this in Day 9 when data
  actually loads).
- No table stores `channel`/`traffic_source` in raw form — Day 9 load step
  should insert the `_clean` values directly, not the originals, to avoid
  ambiguity later.

## Verified: `campaign_id = 0` means "no campaign"

Checked this against the real data before finalizing the schema — this
was NOT a data integrity error, it's intentional design:

- `events.campaign_id`: 1,000,251 rows (50%) have `campaign_id = 0`
- `transactions.campaign_id`: 20,955 rows have `campaign_id = 0`
- Cross-checked against `traffic_source_clean`: **every** `direct` and
  `organic` row has `campaign_id = 0`; **every** `email`/`paid_search`/
  `social` row has a real campaign_id (1-50). Clean 1:1 split, no
  exceptions.

**Schema implication:** `campaign_id` is NOT a true foreign key to
`campaigns` in its raw form — `0` is a sentinel value meaning "not
campaign-attributed," not a reference. Options for Day 9:
1. Keep `campaign_id` as a plain INTEGER (not a FK constraint), and treat
   `0` as "no campaign" in all downstream queries — simplest, no schema
   change needed
2. Convert `0` → NULL during the Day 9 load and make it a proper
   nullable FK — cleaner semantically, matches standard practice, but
   needs an explicit transform step during load

Recommend **option 2** for Week 2 SQL work, since NULL is the standard
way to represent "no campaign" and makes JOIN behavior predictable
(a `0` FK would either fail on strict FK constraints or silently join to
a real campaign #0 if one existed by coincidence).
