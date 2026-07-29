-- Week 3 - Day 18
-- Create Date Dimension Table

DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date (

    date_key INTEGER PRIMARY KEY,

    full_date DATE NOT NULL,

    day INTEGER NOT NULL,

    month INTEGER NOT NULL,

    month_name TEXT NOT NULL,

    quarter INTEGER NOT NULL,

    year INTEGER NOT NULL,

    week_of_year INTEGER NOT NULL,

    day_of_week INTEGER NOT NULL,

    day_name TEXT NOT NULL,

    is_weekend TEXT NOT NULL
);