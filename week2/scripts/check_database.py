from pathlib import Path
import sqlite3

BASE = Path(__file__).resolve().parent.parent

DB = BASE / "database" / "marketing_attribution.db"

conn = sqlite3.connect(DB)
cursor = conn.cursor()

tables = ["customers", "transactions", "events"]

for table in tables:
    print(f"\n===== {table.upper()} =====")
    cursor.execute(f"PRAGMA table_info({table})")
    for row in cursor.fetchall():
        print(row)

conn.close()