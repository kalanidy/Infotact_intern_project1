from pathlib import Path
import sqlite3

BASE = Path(__file__).resolve().parent.parent

DB = BASE / "database" / "marketing_attribution.db"
SQL = BASE / "sql" / "create_dim_date.sql"

conn = sqlite3.connect(DB)

with open(SQL, "r") as f:
    conn.executescript(f.read())

print("dim_date table created successfully!")

conn.close()