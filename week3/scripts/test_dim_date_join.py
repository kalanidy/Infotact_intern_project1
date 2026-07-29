from pathlib import Path
import sqlite3
import pandas as pd

BASE = Path(__file__).resolve().parent.parent

DB = BASE / "database" / "marketing_attribution.db"
SQL = BASE / "sql" / "test_dim_date_join.sql"
OUTPUT = BASE / "output"

OUTPUT.mkdir(exist_ok=True)

conn = sqlite3.connect(DB)

with open(SQL) as f:
    query = f.read()

df = pd.read_sql_query(query, conn)

print(df.head())

df.to_csv(
    OUTPUT / "dim_date_join_validation.csv",
    index=False
)

print("Join validation completed successfully!")

conn.close()