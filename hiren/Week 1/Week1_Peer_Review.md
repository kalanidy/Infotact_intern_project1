# Peer Review — Week 1 Day 6

## Member B — Web Analytics (`workday5.ipynb`)

**Overall:** Good structure for Days 1-5, thorough initial checks (shape, dtypes,
missing values). Two things need fixing before Week 2 SQL work starts.

**1. `traffic_source` casing was never standardized (blocking issue)**
We are to standardize categorical fields to
`lowercase_with_underscores` (e.g. `Paid Search` → `paid_search`) so this
column can join cleanly to `ad_spend.channel_clean`. Right now
`Organic`/`ORGANIC`, `Paid Search`/`PAID SEARCH` etc. are still separate
values. Fix:
```python
events['traffic_source_clean'] = (
    events['traffic_source'].str.strip().str.lower().str.replace(' ', '_', regex=False)
)
```

**2. Day 3 cleaning doesn't carry into Day 4/5**
Day 3 converts `timestamp` to datetime and drops duplicates — but Day 4 and
Day 5 both re-read the raw `events.csv` from scratch instead of reusing the
Day 3 cleaned dataframe. That means the EDA and anomaly detection are
currently running on unclean data. Suggest removing the repeated
`pd.read_csv(...)` calls in Day 4/5 and just continuing with the `events`
variable from Day 3.

**3. Minor — hardcoded local file path**
`C:/Users/yash6/Internship 1/Project 2/events.csv` won't run on anyone
else's machine. Switch to a relative path like `data/events.csv` so the
notebook is portable across the team.

---

## Member C — CRM (`Week1_member_c.ipynb`)

**Overall:** Really strong — clear markdown documentation on every step,
data dictionary included, already structured through Day 7. Nice work.

**1. Refund filtering works, but isn't explicit**
Checked this against the real data: refunded transactions all end up with
negative or null `gross_revenue`, so your `gross_revenue >= 0` filter
happens to remove them anyway — current output is correct. But it's a bit
fragile since the code doesn't actually reference `refund_flag`, so the
intent isn't obvious to a reader, and it could silently break if future
data ever has a refund logged with `gross_revenue == 0`. Suggest adding an
explicit filter for clarity and robustness:
```python
transactions_clean = transactions_clean[transactions_clean['refund_flag'] == 0]
```

**2. Minor — hardcoded local file path**
Same as Member B: `A:\Multi-Touch Marketing Attribution\...` should be a
relative path for portability.

---

*General note for both: once file paths are relativized and the traffic_source
fix is in, we should be in good shape for Week 2's SQL joins.*
