# Osonye Onyemazuwa — Ad Spend Data
Branch: `hiren`

## Role
Data Engineer — Ad Spend data, DB schema, Fact table, funnel visual
(see main `README.md` on `main` for full team roles and project overview)

## Status
Week 1 - completed (Days 1-7)
Week 2, Day 9 0f 28 - in progress

## Files in this branch
- `hiren_ad_spend.ipynb` — Weekkk 1 EDA notebook (Complete)
- `ad_spend.csv`, `campaigns.csv` — local only, not committed (see `.gitignore`)
- `cleaned/ad_spend_clean.csv` — output of Day 3 cleaning, local only
- `charts/spend_by_channel.png`, `charts/top10_campaigns.png`, `charts/daily_spend_trend.png` — Day 4 EDA charts, local only
- `Week1_Peer_Review.md` — Day 6 peer review notes for Yash and Kalanidy
- `hiren_schema_design.md` — Day 8 relational schema design
- `hiren_database_postgres.ipynb` — Week 2 SQL/Notebook (Day 9, PostgreSQL)
- `.env` — local database credentials, never committed (see .gitignore)
- `.gitignore` — excludes .env, data/, *.csv, checkpointd
- `ad_spend.csv, campaigns.csv` — local only, not committed (see .gitignore)

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

## Next up (Day 10)
- Load cleaned CRM Conversion data into the database; verify row counts
