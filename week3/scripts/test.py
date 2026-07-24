from pathlib import Path
import sqlite3

BASE = Path(__file__).resolve().parent.parent
DB = BASE / "database" / "marketing_attribution.db"

conn = sqlite3.connect(DB)
cursor = conn.cursor()

cursor.execute("PRAGMA table_info(ad_spend)")

print("AD_SPEND TABLE")
for row in cursor.fetchall():
    print(row)

conn.close()