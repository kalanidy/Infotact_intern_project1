import pandas as pd

# -----------------------------
# Load datasets
# -----------------------------
events = pd.read_csv(r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\data\events.csv")
transactions = pd.read_csv(r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\data\transactions.csv")

# -----------------------------
# Convert timestamp to datetime
# -----------------------------
events["timestamp"] = pd.to_datetime(events["timestamp"])
transactions["timestamp"] = pd.to_datetime(transactions["timestamp"])

# -----------------------------
# Sort customer journey
# -----------------------------
events = events.sort_values(
    ["customer_id", "timestamp"]
).reset_index(drop=True)

# -----------------------------
# Create Touch Order
# -----------------------------
events["touch_order"] = (
    events
    .groupby("customer_id")
    .cumcount()
    + 1
)

# -----------------------------
# Save intermediate file
# -----------------------------
events.to_csv(
    "../output/customer_journey.csv",
    index=False
)

print(events.head())
print()
print("Customer Journey Created Successfully")