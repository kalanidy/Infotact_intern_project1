import pandas as pd
from pathlib import Path

# -----------------------------
# Load Master Attribution
# -----------------------------
master = pd.read_csv(r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\output\master_attribution.csv")

# -----------------------------
# Channel Performance Summary
# -----------------------------
summary = (
    master
    .groupby(
        ["attribution_model", "traffic_source"],
        as_index=False
    )
    .agg(
        total_revenue=("attributed_revenue", "sum"),
        total_conversions=("customer_id", "count"),
        unique_customers=("customer_id", "nunique")
    )
)

# -----------------------------
# Average Revenue Per Conversion
# -----------------------------
summary["avg_revenue"] = (
    summary["total_revenue"] /
    summary["total_conversions"]
)

# -----------------------------
# Revenue Share (%)
# -----------------------------
summary["revenue_share"] = (
    summary.groupby("attribution_model")["total_revenue"]
    .transform(lambda x: x / x.sum() * 100)
)

# -----------------------------
# Round Values
# -----------------------------
summary["total_revenue"] = summary["total_revenue"].round(2)
summary["avg_revenue"] = summary["avg_revenue"].round(2)
summary["revenue_share"] = summary["revenue_share"].round(2)

# -----------------------------
# Save
# -----------------------------
output_dir = Path("../output")
output_dir.mkdir(exist_ok=True)

summary.to_csv(
    output_dir / r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\output\channel_summary.csv",
    index=False
)

print(summary.head())
print("\nChannel Summary Created Successfully")