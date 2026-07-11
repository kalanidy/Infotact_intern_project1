# Multi-Touch Marketing Attribution & ROI Dashboard

## Day 0 - Project Setup

### Objective
Set up the project environment and understand the project workflow.

### Tasks Completed
- Reviewed the 4-week project plan.
- Selected the required datasets.
- Identified team roles and responsibilities.
- Set up the project repository structure.

---

## Day 1 - Data Dictionary & GitHub Issues

### Objective
Understand the project datasets and organize Week 1 tasks.

### Tasks Completed
- Reviewed all project datasets.
- Created the shared data dictionary.
- Identified dataset relationships.
- Created Week 1 GitHub Issues.
- Added tasks to the GitHub Kanban board.

---

## Day 2 - CRM Data Acquisition

### Objective
Acquire and load the raw CRM conversion data into Pandas.

### Tasks Completed
- Loaded customer sign-up data.
- Loaded transaction and purchase data.
- Verified successful dataset loading.
- Checked dataset dimensions.

### CRM Datasets
- `customers.csv` - Customer sign-ups.
- `transactions.csv` - Customer purchases and conversions.

---

## Day 3 - CRM Data Cleaning

### Objective
Clean CRM conversion data by removing duplicate, invalid, and test records.

### Tasks Completed
- Checked and removed duplicate customer IDs.
- Removed invalid and test customer records.
- Removed duplicate and invalid transactions.
- Validated customer IDs.
- Saved the cleaned CRM datasets.

### Output Files
- `customers_clean.csv`
- `transactions_clean.csv`

---

## Day 4 - CRM Conversion EDA

### Objective
Analyze CRM conversions based on volume, timing, and value.

### Tasks Completed
- Analyzed total conversion volume.
- Visualized daily conversion trends.
- Analyzed conversions by hour of day.
- Calculated total and average revenue.
- Visualized conversion value distribution.
- Analyzed daily revenue trends.

### Outcome
The cleaned CRM data has been explored and is ready for validation against Web Analytics data on Day 5.

---

# Week 1 - Day 5

## CRM and Web Analytics Validation

### Objective
Validate CRM conversion data against Web Analytics data by matching customer IDs.

### Tasks Completed
- Matched CRM customers with Web Analytics users.
- Identified matched and unmatched customer IDs.
- Validated transaction customers against web activity.
- Calculated customer ID match rates.
- Added a Web Analytics match flag to transactions.

### Outcome
CRM conversion data was successfully validated against Web Analytics data and is ready for further attribution analysis.

