import pandas as pd
from pathlib import Path

# -----------------------------
# Load Customer Journey
# -----------------------------
journey = pd.read_csv(r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\output\customer_journey.csv")

# Convert timestamp
journey["timestamp"] = pd.to_datetime(journey["timestamp"])

# -----------------------------
# Find Purchase Events
# -----------------------------
purchases = journey[
    journey["event_type"] == "purchase"
].copy()

# Keep first purchase for each customer
purchases = (
    purchases
    .sort_values("timestamp")
    .groupby("customer_id", as_index=False)
    .first()
)

# -----------------------------
# Save
# -----------------------------
output_dir = Path("../output")
output_dir.mkdir(exist_ok=True)

purchases.to_csv(
    output_dir / "customer_purchases.csv",
    index=False
)

print(f"Customers with purchases : {len(purchases)}")
print(purchases.head())