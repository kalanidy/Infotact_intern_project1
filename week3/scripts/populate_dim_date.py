from pathlib import Path
import sqlite3
from datetime import datetime, timedelta

BASE = Path(__file__).resolve().parent.parent
DB = BASE / "database" / "marketing_attribution.db"

conn = sqlite3.connect(DB)
cursor = conn.cursor()

# Clear existing data
cursor.execute("DELETE FROM dim_date")

start_date = datetime(2021, 1, 1)
end_date = datetime(2025, 12, 31)

current = start_date

while current <= end_date:

    date_key = int(current.strftime("%Y%m%d"))

    full_date = current.strftime("%Y-%m-%d")

    day = current.day

    month = current.month

    month_name = current.strftime("%B")

    quarter = (current.month - 1) // 3 + 1

    year = current.year

    week_of_year = int(current.strftime("%U"))

    day_of_week = current.isoweekday()

    day_name = current.strftime("%A")

    is_weekend = "Yes" if current.weekday() >= 5 else "No"

    cursor.execute(
        """
        INSERT INTO dim_date
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        (
            date_key,
            full_date,
            day,
            month,
            month_name,
            quarter,
            year,
            week_of_year,
            day_of_week,
            day_name,
            is_weekend,
        ),
    )

    current += timedelta(days=1)

conn.commit()

cursor.execute("SELECT COUNT(*) FROM dim_date")
print("Rows inserted:", cursor.fetchone()[0])

conn.close()

print("dim_date populated successfully!")