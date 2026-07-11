# Multi-Touch Marketing Attribution & ROI Dashboard
Infotact Data Analytics Internship — Project 1

## Overview
This project builds a Multi-Touch Attribution model to fairly distribute
conversion credit across marketing touchpoints, replacing naive
"Last-Click" attribution. The dashboard lets marketing managers toggle
between First-Touch, Last-Touch, and Linear attribution models and
calculates true ROAS and CAC.

## Team
| Member | Role | Focus |
|---|---|---|
| Member A | Data Engineer | Ad Spend data, DB schema, Fact table, funnel visual |
| Member B | SQL Developer | Web Analytics data, window functions, CAC, dim tables |
| Member C | Data Analyst | CRM data, First/Last-Click attribution, ROAS |
| Member D | BI Lead / Docs | EDA consolidation, Linear attribution, dashboard, exec report |

## Data
Raw data files are **not** committed to this repo (see `.gitignore`).
Source files used:
- 
- `ad_spend.csv` — ad spend logs (date, campaign_id, channel, utm_source/medium/campaign, impressions, clicks, ad_spend, currency
- `campaigns.csv` — campaign metadata (channel, objective, dates, target segment)
- `events.csv` — web/session events (view, click, add_to_cart, purchase)
- `transactions.csv` — purchase/conversion records
- `customers.csv` — customer dimension (signup, country, loyalty tier)
- `products.csv` — product dimension (category, brand, price)

Join key across `ad_spend.csv` and `campaigns.csv` is the numeric `campaign_id`.
Date ranges overlap cleanly across all files (~Jan 2021–Jan 2024), so
attribution can be computed across the full dataset.

### Data cleaning conventions (apply consistently across all files)
- **Categorical text fields** (`channel`, `traffic_source`, `utm_source`, etc.):
  standardize to `lowercase_with_underscores` (e.g. `Paid Search` → `paid_search`).
  Applies to `ad_spend.channel` (done), `events.traffic_source` (pending —
  has casing dupes, see below), and `campaigns.channel` (pending — already
  spelled consistently, just needs the same format applied).

### Known data quality issues (track via GitHub Issues, don't fix silently)
- **`events.traffic_source` has inconsistent casing** — e.g. `Direct` /
  `DIRECT`, `Email` / `EMAIL`, `Social` / `SOCIAL`. Must be standardized
  to the convention above before joining to `ad_spend.channel`.
- **Category mismatch between `ad_spend.channel` and `events.traffic_source`:**
  - `ad_spend.channel` values: `Affiliate`, `Display`, `Email`, `Paid Search`, `Social`
  - `events.traffic_source` values: `Direct`, `Email`, `Organic`, `Paid Search`, `Social`
  - `Direct` / `Organic` traffic has no spend (expected — unpaid channels).
  - `Affiliate` / `Display` spend exists but has no direct equivalent in
    `events.traffic_source` — team needs to decide how this spend gets
    attributed before Week 3 KPI calculations.
- `ad_spend` values cluster tightly around $10 (25th/50th/75th percentile
  all ~$10, max $78.36) — worth a quick outlier sanity check in Week 1.

## Setup
1. Clone this repo
2. Place raw CSVs in a local `data/` folder (excluded from Git)
3. Install dependencies: `pip install pandas numpy jupyter`
4. Open notebooks in `notebooks/`

## Progress Log
- **Week 1:** Data ingestion & EDA (in progress)
- **Week 2:** SQL & attribution logic
- **Week 3:** KPI calculation & Star Schema
- **Week 4:** BI dashboard & executive report
