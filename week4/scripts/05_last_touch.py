import pandas as pd
from pathlib import Path

# -----------------------------
# Load Data
# -----------------------------
journey = pd.read_csv(r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\output\conversion_journey.csv")
transactions = pd.read_csv(r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\data\transactions.csv")

# Convert timestamps
journey["timestamp"] = pd.to_datetime(journey["timestamp"])
transactions["timestamp"] = pd.to_datetime(transactions["timestamp"])

# -----------------------------
# Get Last Touch
# -----------------------------
last_touch = (
    journey
    .sort_values(["customer_id", "timestamp"])
    .groupby("customer_id", as_index=False)
    .last()
)

# -----------------------------
# Calculate Revenue Per Customer
# -----------------------------
customer_revenue = (
    transactions
    .groupby("customer_id", as_index=False)["gross_revenue"]
    .sum()
)

# -----------------------------
# Merge Revenue
# -----------------------------
last_touch = last_touch.merge(
    customer_revenue,
    on="customer_id",
    how="left"
)

# Replace missing revenue with 0
last_touch["gross_revenue"] = last_touch["gross_revenue"].fillna(0)

# Rename column
last_touch = last_touch.rename(
    columns={"gross_revenue": "attributed_revenue"}
)

# -----------------------------
# Save
# -----------------------------
output_dir = Path("../output")
output_dir.mkdir(exist_ok=True)

last_touch.to_csv(
    output_dir / r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\output\last_touch_attribution.csv",
    index=False
)

print("Last Touch Attribution Created Successfully")
print(last_touch.head())