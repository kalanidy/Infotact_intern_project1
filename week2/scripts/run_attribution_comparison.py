from pathlib import Path
import sqlite3
import pandas as pd

BASE = Path(__file__).resolve().parent.parent

DB = BASE / "database" / "marketing_attribution.db"
SQL = BASE / "sql" / "attribution_comparison.sql"
OUTPUT = BASE / "output"

conn = sqlite3.connect(DB)

with open(SQL, "r") as f:
    query = f.read()

comparison = pd.read_sql_query(query, conn)

print(comparison.head())
print("\nRows:", len(comparison))

comparison.to_csv(
    OUTPUT / "attribution_comparison.csv",
    index=False
)

print("\nComparison report saved successfully!")

conn.close()