import pandas as pd
from pathlib import Path

# -----------------------------
# Load Data
# -----------------------------
journey = pd.read_csv(r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\output\customer_journey.csv")
purchases = pd.read_csv(r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\output\customer_purchases.csv")

# Convert timestamps
journey["timestamp"] = pd.to_datetime(journey["timestamp"])
purchases["timestamp"] = pd.to_datetime(purchases["timestamp"])

# Rename purchase timestamp for clarity
purchases = purchases.rename(columns={"timestamp": "purchase_time"})

# Keep only customer_id and purchase_time
purchases = purchases[["customer_id", "purchase_time"]]

# -----------------------------
# Merge purchase time
# -----------------------------
conversion = journey.merge(
    purchases,
    on="customer_id",
    how="inner"
)

# -----------------------------
# Keep only events before purchase
# -----------------------------
conversion = conversion[
    conversion["timestamp"] <= conversion["purchase_time"]
]

# -----------------------------
# Sort
# -----------------------------
conversion = conversion.sort_values(
    ["customer_id", "timestamp"]
)

# -----------------------------
# Save
# -----------------------------
output_dir = Path("../output")
output_dir.mkdir(exist_ok=True)

conversion.to_csv(
    output_dir / r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\output\conversion_journey.csv",
    index=False
)

print("Conversion Journey Created Successfully")
print(conversion.head())
print(f"\nTotal Rows: {len(conversion)}")