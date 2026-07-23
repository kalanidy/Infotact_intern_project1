from pathlib import Path
import sqlite3
import pandas as pd

BASE = Path(__file__).resolve().parent.parent

DB = BASE / "database" / "marketing_attribution.db"
SQL = BASE / "sql" / "revenue_by_channel.sql"
OUTPUT = BASE / "output"

OUTPUT.mkdir(exist_ok=True)

conn = sqlite3.connect(DB)

with open(SQL, "r") as f:
    query = f.read()

revenue = pd.read_sql_query(query, conn)

print(revenue.head())

print("\nRows:", len(revenue))

revenue.to_csv(
    OUTPUT / "revenue_by_channel.csv",
    index=False
)

print("\nRevenue report saved successfully!")

conn.close()