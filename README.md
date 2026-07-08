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
- `campaigns.csv` — campaign metadata (channel, objective, dates, target segment)
- `events.csv` — web/session events (view, click, add_to_cart, purchase)
- `transactions.csv` — purchase/conversion records
- `customers.csv` — customer dimension (signup, country, loyalty tier)
- `products.csv` — product dimension (category, brand, price)

**Known gap:** no ad spend/cost column currently exists in the source
data. Pending confirmation from the team on whether a spend file exists
separately or needs to be simulated. This will be documented here once
resolved.

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
