# Osonye Onyemazuwa — Ad Spend Data
Branch: `hiren`

## Role
Data Engineer — Ad Spend data, DB schema, Fact table, funnel visual
(see main `README.md` on `main` for full team roles and project overview)

## Status
Week 1 - completed (Days 1-7)  
Week 2 - completed (Day 8-14)  
Week 3, Day 16 of 28 - in progress

## Files in this branch
- `hiren_ad_spend.ipynb` — Week 1 EDA notebook (Complete)
- `cleaned/ad_spend_clean.csv` — output of Day 3 cleaning, local only
- `charts/spend_by_channel.png`, `charts/top10_campaigns.png`, `charts/daily_spend_trend.png` — Day 4 EDA charts, local only
- `Week1_Peer_Review.md` — Day 6 peer review notes for Yash and Kalanidy
- `hiren_schema_design.md` — Day 8 relational schema design
- `hiren_database_postgres.ipynb` — Week 2 SQL/Notebook (PostgreSQL - Complete)
- `.env` — local database credentials, never committed (see .gitignore)
- `.gitignore` — excludes .env, data/, *.csv, checkpointd
- `ad_spend.csv, campaigns.csv` — local only, not committed (see .gitignore)
- `hiren_week3_kpis.ipynb` —  Week 3 SQL/Notebook (PostgreSQL)

## Progress Log

## Week 1
### Day 1 — Repo & Kanban setup
- created Main branch README.md 
- Added own Week 1 Issues (#8-#12)

### Day 2 — Acquire and load Ad Spend dataset
- Loaded `ad_spend.csv` (2,599 rows, 11 columns) into Pandas
- Checked dtypes, missing values (none found), summary stats
- Initial spend-by-channel breakdown

### Day 3 — Clean campaign IDs and standardize channel naming
- Verified `campaign_id` integrity: all 50 IDs match `campaigns.csv` exactly, no orphans either direction
- Verified no duplicate `spend_id` rows
- Converted `date` from string to proper `datetime64` type
- Standardized `channel` and `utm_source` to `lowercase_with_underscores` convention
  (e.g. `Paid Search` → `paid_search`) — matches the team-wide convention documented
  in the main README
- Saved cleaned output to `cleaned/ad_spend_clean.csv`

### Day 4 — EDA on Ad Spend: spend by channel/campaign/day
- Spend by channel: Affiliate highest, Social lowest (matches Day 2 totals)
- Spend by campaign: Campaign #48 is the single highest-spend campaign
  ($1,001.70) — flagged for a possible outlier check on Day 5
- Daily spend: ranges $10-$78.36/day, averaging ~$27.79/day across 967
  active spend-days, no obvious seasonal spike pattern at a glance
- Saved 3 charts to `charts/`: spend by channel, top 10 campaigns, daily
  spend trend over time

### Day 5 — Identify and flag outlier/suspicious spend entries
- Cleared Day 4's Campaign #48 flag — it's a long-running campaign (90
  days of spend), not a single suspicious entry
- No structural issues found: no zero-click spend, no duplicate
  campaign+date charges, no negative values, no zero impressions
- Plain IQR is unreliable on this data (spend clusters at a $10 floor) —
  used implied CPC (spend/clicks) instead as a better signal
- Highest implied CPC: $17.63/click (2 clicks, low-volume day) — not
  necessarily an error, just noisy on low-click days
- Conclusion: dataset has no clearly suspicious spend entries going into
  Week 2

### Day 6 — Peer review
- Reviewed Member B and C's notebooks; found real issues (traffic_source casting
  not standardized, Day 4/5 not using cleaned data, hardcoded paths for B; refund
  filtering not explicit, hardcoded path for C)
- Sent direct, actionable feedback to both (see Week1_Peer_Review.md)
- Reeviewed own script ffor the same issues - none found

### Day 7 — Finalize notebook, uppdate README, close Week 1 Issues
- Adde Week 1 Summary section to notebook
- cleared all cell outputs before final commit
- closed Issues #8 - #12

## Week 2
### Day 8 — Design relational schema for spend/web/conversion table
- Designed full schema for all 6 tables: Campaigns, ad_spend, customers, products,
  events, transactions
- Central join keys: campaign_id, customer_id, product_id
- **Key Findings:** campaign_id = 0 in events/transactions is a  deliberate sentinel
  meaning "no campaign attribution" - verified 100% of paid traffic has a real
  campaign_id, nno exceptions. Not a data error.
- Decision: convert 0 → NULL during Day 9 load so campaign_id behaves as aa proper
  nullable foreign key (avoids silent misjoins or broken FK constraints
- Also applied the traaffic_source/campaigns.channel standardization fix myself
  (events.csv, campaigns.csv) since it was still blocking Week 2 joins as of today
  see main README for detaails
- Added Week 2 issues (#31 - #37)

### Day 9 — Create database, load cleaned Ad Spend data
- Used PostgreSQL (not SQLite) per team decision — created attribution
  database and both tables (campaigns, ad_spend) per Day 8 schema
- Credentials loaded from .env (never hardcoded/committed) — .gitignore
  added to cover .env, raw data files, and Jupyter checkpoints
- Debugging notes (kept for reference, since these will likely recur for
  teammates setting up their own connections):
  - Password contains @ — had to URL-encode with urllib.parse.quote_plus()
    since SQLAlchemy misreads @ as the user/host separator otherwise
  - attribution database had to be created manually first
    (CREATE DATABASE attribution;) — create_engine() doesn't do this
  - to_sql(if_exists='replace') failed with a foreign key conflict
    (Postgres won't drop campaigns while ad_spend references it) —
    fixed by switching to if_exists='append' plus a TRUNCATE cell to
    keep re-runs safe
- All verification passed: row counts match source CSVs exactly (50
  campaigns, 2,599 spend rows), spend-by-channel matches Week 1's pandas
  output exactly, and the ad_spend–campaigns join returns all 2,599
  rows with no orphans

### Day 10 — Load cleaned CRM Conversion data, verify row counts
- Had to create customers and products tables too (not in Day 9 scope)
  since transactions has foreign keys to both
- Replicated Kalanidy's Week 1 cleaning logic directly (dedup by
  transaction_id, filter quantity>0 and gross_revenue>=0, filter to valid
  customer_ids) rather than wait on a handoff file — raw 103,127 rows →
  cleaned 89,974, confirmed exact match to the pre-calculated expected count
- Applied Day 8's campaign_id = 0 → NULL finding for real this time —
  18,239 rows converted, 71,735 kept a real campaign_id
- Two boolean type mismatches hit and fixed: products.is_premium and
  transactions.refund_flag both came in as 0/1 integers from the CSVs,
  but the table schema defines them as BOOLEAN — Postgres doesn't
  auto-convert. Fixed both with .astype(bool) before loading
- All verification passed: customers 100,000/100,000, products 2,000/2,000,
  transactions 89,974/89,974, and the transactions–customers–campaigns
  join (LEFT JOIN for campaigns, since ~18k rows have no attribution)
  returns all 89,974 rows with nothing dropped

### Day 11 — Write helper SQL views for spend aggregation
- Built 3 views (not one-off queries) so Week 3's KPI calculations
  (CPC, CAC, ROAS) can reference these directly: vw_spend_by_channel,
  vw_spend_by_campaign (joined to campaigns for channel/objective
  context), vw_spend_by_day
- All expected numbers pre-validated against Week 1's pandas output and
  Day 9's SQL output before writing the views — every view matched exactly
  on first run (affiliate $6,454.96 → social $4,176.33; campaign #48
  leading at $1,001.70; 967 distinct spend days)
- Cross-check: all 3 views plus the raw ad_spend table sum to the same
  $26,876.24 grand total — confirms no view is silently dropping or
  double-counting rows via a bad GROUP BY or JOIN

### Day 12 — Add indexes on the spend table for query performance
- Indexed campaign_id (join key) and date (high cardinality, used in
  Day 11's daily view) — deliberately did NOT index channel (only 5
  distinct values on 2,599 rows, poor index selectivity)
- Verified via pg_indexes: 3 total indexes exist (automatic PK index on
  spend_id, plus the two new ones)
- Ran EXPLAIN on the Day 9 join query — confirmed Postgres actually uses
  idx_ad_spend_campaign_id (Index Only Scan), not just created-and-ignored
- Documented honestly that ad_spend's small size (2,599 rows) means the
  indexes won't show a dramatic measurable speedup today — the value is
  correct practice and readiness for scale, not a benchmark win here

### Day 13 — Test schema joins across spend, web, and CRM tables end-to-end
- Checked table existence first: events (Web Analytics, Member B's
  table) is not yet loaded — real cross-team blocker, not something
  fixable from this notebook. Flagged to team; deferring to work on it
  myself later given current team capacity (down to 2 active members
  this week)
- Tested everything that doesn't depend on events: ad_spend fully
  joins to campaigns (2,599/2,599), transactions fully joins to
  customers, products, and the full chain with LEFT JOIN campaigns
  (89,974/89,974 at every step) — zero data loss across 5 tables and 4
  join relationships
- Pre-wrote and pre-validated the events join query (Step 3) against
  the real data so it's ready to run the moment the table exists —
  expected 2,000,000 rows, 1,799,629 with a product, 200,371 view-only
  events with no product (expected, not an error)

### Day 14 — Commit final DB setup scripts, close own Week-2 Issues
- Added a Week 2 summary table to the notebook covering Days 8-14
- Database now holds: campaigns (50), ad_spend (2,599), customers
  (100,000), products (2,000), transactions (89,974 after cleaning),
  3 views, 2 indexes
- Closed Issues #31, #32, #33, #34, #35, #36, #37. Issue #36 closed as
  "partially complete" — blocked on events (Web Analytics), a
  cross-team dependency not resolvable from this notebook
- Documented Week 2's debugging lessons (password encoding, manual DB
  creation, FK-safe loading pattern, boolean type casting) for whoever
  sets up their own local connection next
- Flagged forward to Week 3: CAC calculation likely needs events too —
  worth raising with the team before Week 3 starts, not discovering it
  mid-week

## Week 2 complete (Days 8-14) — see notebook Day 14 summary for full detail

## Week 3

### Day 15 — Calculate Total Spend per channel/campaign/day
- Reused Week 2's three views (`vw_spend_by_channel`,
  `vw_spend_by_campaign`, `vw_spend_by_day`) rather than duplicating
  logic — all three still return identical numbers to Week 2, confirming
  the data hasn't drifted
- Added a `GROUPING SETS` query to genuinely fulfill "Total Spend per
  channel/campaign/day" as one combined deliverable — channel, campaign,
  and day totals plus the grand total, all in a single table scan
- Verified the `GROUPING SETS` grand total ($26,876.24) matches the raw
  `ad_spend` table total exactly — `Match: True`, no rows lost or
  double-counted across the four grouping levels

### Day 16 — Calculate Cost Per Click (CPC) = Spend / Clicks
- Confirmed no zero-click rows exist (no division-by-zero risk)
- CPC calculated at the aggregate level (SUM(spend)/SUM(clicks) per
  group), not averaged row-by-row, since row-level averaging would
  over-weight low-volume rows and give a misleading number
- CPC by channel: `paid_search` highest at $3.03/click, `email` lowest
  at $2.71/click — a different ranking than Day 15's total spend
  (Affiliate led there), confirming spend volume and CPC are
  independent signals worth keeping distinct in Week 4's dashboard
- Campaign #48 (highest total spend) does NOT appear in the top-5 CPC
  list — its spend comes from volume/duration, not expensive clicks
- Overall CPC: $2.8043 (total spend $26,876.24 / total clicks 9,584) —
  headline number for Week 4's executive summary

## Findings worth remembering
- Dataset was already very clean on delivery — no missing values, no duplicate IDs.
  Real cleaning work here was narrower than expected (just casing standardization).
- Date range: 2021-01-20 to 2024-01-06 — overlaps correctly with `events.csv` and
  `transactions.csv` date ranges, so attribution modeling is not blocked.
- Spend by channel: Affiliate ($6,455) > Paid Search ($6,151) > Email ($5,614) >
  Display ($4,480) > Social ($4,176)
- **Open item raised with team:** `Affiliate` and `Display` channels in ad_spend
  have no equivalent category in `events.traffic_source` (which only has Direct/
  Email/Organic/Paid Search/Social). Need a team decision on how this spend gets
  attributed before Week 3 Fact table work — flagged in main README.

## Next up (Day 17)
- Validate CPC output against raw click data
