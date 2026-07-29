import pandas as pd
from pathlib import Path

# -----------------------------
# Load Files
# -----------------------------
first = pd.read_csv(r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\output\first_touch_attribution.csv")
last = pd.read_csv(r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\output\last_touch_attribution.csv")
linear = pd.read_csv(r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\output\linear_attribution.csv")

# -----------------------------
# Add Attribution Model
# -----------------------------
first["attribution_model"] = "First Touch"
last["attribution_model"] = "Last Touch"
linear["attribution_model"] = "Linear"

# -----------------------------
# Select Common Columns
# -----------------------------
columns = [
    "customer_id",
    "traffic_source",
    "campaign_id",
    "attributed_revenue",
    "attribution_model"
]

first = first[columns]
last = last[columns]
linear = linear[columns]

# -----------------------------
# Combine
# -----------------------------
master = pd.concat(
    [first, last, linear],
    ignore_index=True
)

# -----------------------------
# Save
# -----------------------------
output_dir = Path("../output")
output_dir.mkdir(exist_ok=True)

master.to_csv(
    output_dir / r"A:\internship\Infotact-intern-project-1\Infotact_intern_project1\week4\output\master_attribution.csv",
    index=False
)

print("Master Attribution Table Created Successfully")
print(master.head())
print(f"\nTotal Rows: {len(master)}")