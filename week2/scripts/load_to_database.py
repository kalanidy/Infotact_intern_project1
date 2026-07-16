from pathlib import Path
import pandas as pd
import sqlite3

# Project paths
BASE = Path(__file__).resolve().parent.parent

DATA = BASE / "data"
DB = BASE / "database" / "marketing_attribution.db"

# Load CSV files
customers = pd.read_csv(DATA / "customers_clean.csv")
transactions = pd.read_csv(DATA / "transactions_clean.csv")
events = pd.read_csv(DATA / "events_reduced.csv")

# Create database folder
DB.parent.mkdir(exist_ok=True)

# Connect to SQLite
conn = sqlite3.connect(DB)

# Write tables
customers.to_sql("customers", conn, if_exists="replace", index=False)
transactions.to_sql("transactions", conn, if_exists="replace", index=False)
events.to_sql("events", conn, if_exists="replace", index=False)

conn.close()

print("Database created successfully!")
print("Database location:", DB)