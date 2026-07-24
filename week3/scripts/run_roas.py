from pathlib import Path
import sqlite3
import pandas as pd

BASE = Path(__file__).resolve().parent.parent

DB = BASE / "database" / "marketing_attribution.db"
SQL = BASE / "sql" / "roas_by_channel.sql"
OUTPUT = BASE / "output"

OUTPUT.mkdir(exist_ok=True)

conn = sqlite3.connect(DB)

with open(SQL, "r") as f:
    query = f.read()

roas = pd.read_sql_query(query, conn)

print(roas)

roas.to_csv(
    OUTPUT / "roas_by_channel.csv",
    index=False
)

print("\nROAS report generated successfully!")

conn.close()