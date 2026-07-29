import pandas as pd
from pathlib import Path

# -----------------------------
# Load Data
# -----------------------------
journey = pd.read_csv(r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\output\conversion_journey.csv")
transactions = pd.read_csv(r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\data\transactions.csv")

journey["timestamp"] = pd.to_datetime(journey["timestamp"])
transactions["timestamp"] = pd.to_datetime(transactions["timestamp"])

# -----------------------------
# Customer Revenue
# -----------------------------
customer_revenue = (
    transactions
    .groupby("customer_id", as_index=False)["gross_revenue"]
    .sum()
)

# -----------------------------
# Count Touchpoints
# -----------------------------
touch_counts = (
    journey
    .groupby("customer_id")
    .size()
    .reset_index(name="touch_count")
)

# -----------------------------
# Merge Revenue & Touch Count
# -----------------------------
linear = journey.merge(customer_revenue, on="customer_id", how="left")
linear = linear.merge(touch_counts, on="customer_id", how="left")

linear["gross_revenue"] = linear["gross_revenue"].fillna(0)

# -----------------------------
# Revenue Per Touch
# -----------------------------
linear["attributed_revenue"] = (
    linear["gross_revenue"] / linear["touch_count"]
)

# -----------------------------
# Keep Required Columns
# -----------------------------
linear = linear[
    [
        "customer_id",
        "timestamp",
        "traffic_source",
        "campaign_id",
        "event_type",
        "touch_order",
        "touch_count",
        "attributed_revenue",
    ]
]

# -----------------------------
# Save
# -----------------------------
output_dir = Path("../output")
output_dir.mkdir(exist_ok=True)

linear.to_csv(
    output_dir / r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\output\linear_attribution.csv",
    index=False
)

print("Linear Attribution Created Successfully")
print(linear.head())