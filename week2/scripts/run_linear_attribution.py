from pathlib import Path
import sqlite3
import pandas as pd

BASE = Path(__file__).resolve().parent.parent

DB = BASE / "database" / "marketing_attribution.db"

SQL = BASE / "sql" / "linear_attribution.sql"

OUTPUT = BASE / "output"

OUTPUT.mkdir(exist_ok=True)

conn = sqlite3.connect(DB)

with open(SQL, "r") as f:
    query = f.read()

linear = pd.read_sql_query(query, conn)

print(linear.head())

print("\nRows:", len(linear))

linear.to_csv(
    OUTPUT / "linear_attribution.csv",
    index=False
)

print("\nSaved Successfully!")

conn.close()