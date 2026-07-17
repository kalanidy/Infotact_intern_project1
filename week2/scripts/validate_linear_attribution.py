from pathlib import Path
import sqlite3
import pandas as pd

BASE = Path(__file__).resolve().parent.parent

DB = BASE / "database" / "marketing_attribution.db"
SQL = BASE / "sql" / "validate_linear_attribution.sql"
OUTPUT = BASE / "output"

conn = sqlite3.connect(DB)

with open(SQL, "r") as f:
    query = f.read()

validation = pd.read_sql_query(query, conn)

print(validation.head())

print("\nTotal Transactions:", len(validation))

print(
    "\nPassed:",
    (validation["validation_status"] == "PASS").sum()
)

print(
    "Failed:",
    (validation["validation_status"] == "FAIL").sum()
)

validation.to_csv(
    OUTPUT / "linear_attribution_validation.csv",
    index=False
)

print("\nValidation report saved.")

conn.close()