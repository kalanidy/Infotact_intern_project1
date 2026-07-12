# Osonye Onyemazuwa — Ad Spend Data
Branch: `hiren`

## Role
Data Engineer — Ad Spend data, DB schema, Fact table, funnel visual
(see main `README.md` on `main` for full team roles and project overview)

## Status
Week 1, Day 4 of 28 — in progress

## Files in this branch
- `member_a_ad_spend.ipynb` — main working notebook (Days 1-4 so far)
- `data/ad_spend.csv`, `data/campaigns.csv` — local only, not committed (see `.gitignore`)
- `cleaned/ad_spend_clean.csv` — output of Day 3 cleaning, local only
- `charts/spend_by_channel.png`, `charts/top10_campaigns.png`, `charts/daily_spend_trend.png` — Day 4 EDA charts, local only

## Progress Log

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

## Next up (Day 6)
- Peer-review Member B & C's cleaning notebooks; fix any issues in own Ad Spend script
-
