# HealthFlow Analytics 🏥

**Hospital readmissions intelligence dashboard** — an end-to-end data analytics project analyzing the CMS Hospital Readmissions Reduction Program (HRRP) dataset, built to identify which hospitals, states, and conditions are driving excess patient readmissions across the US.

**Live Dashboard:** [Looker Studio / Data Studio link here]
**Stack:** Python → Google BigQuery → Looker Studio (Data Studio) → GitHub

---

## The Question

Which hospitals and clinical conditions have the worst 30-day readmission performance relative to national benchmarks — and where should healthcare systems focus improvement efforts?

## Key Findings

- **53.7%** of hospital/condition combinations perform worse than the national benchmark (excess readmission ratio > 1.0)
- **Massachusetts** is the worst-performing state, with an average excess readmission ratio of **1.0444** across 52 hospitals
- **Hip/Knee Replacement** has the highest average excess ratio (**1.0357**) of any condition — but also the smallest sample size (253 records), making it the most volatile category
- **Heart Bypass Surgery** is the most structurally concerning condition: **60.9%** of hospitals performing it exceed the national benchmark — the highest share of any condition, despite not having the highest average ratio
- **Carle Bromenn Medical Center (IL)** is the single worst-performing hospital/condition combination in the dataset, with a **1.5827** excess readmission ratio for Hip/Knee Replacement
- **15 of the 20 worst hospital/condition combinations** are Hip/Knee Replacement cases — suggesting either genuine clinical risk concentration in this procedure or a volume-related statistical effect worth flagging as a limitation
- **Oroville Hospital (CA)** stands out for consistency of poor performance: an average excess ratio of **1.2825** across 4 different conditions (Pneumonia, Heart Failure, COPD, Heart Attack), totaling 384 readmissions

## Data Quality: A Deliberate Fix

During EDA, the initial dataset used two overlapping classification schemes for hospital risk: one column mixed "Above/Below Average" (relative to the mean) with "High/Low Risk" (fixed thresholds) into a single inconsistent categorical field. This made downstream analysis ambiguous — the four labels weren't on one ordered scale.

**Fix:** consolidated into a single ordered `readmission_risk_tier` column (Low Risk / Average / High Risk) using consistent excess-ratio cutoffs (0.98 / 1.02), replacing the earlier column entirely. All dashboard logic and BigQuery views reference this single field.

## Architecture

```
Raw CSV (CMS HRRP data, 18,330 rows)
    ↓
Python cleaning (pandas) — dropped nulls, fixed data types,
mapped condition codes to labels, consolidated risk categorization
    ↓
Clean dataset (8,037 rows × 12 columns)
    ↓
Google BigQuery (healthflow-analytics.hospital_readmissions)
    ↓
Single enriched view: v_enriched_readmissions
(adds rate_gap and readmission_risk_tier — single source of truth)
    ↓
Looker Studio (Data Studio) — interactive dashboard
```

**Why one view instead of several?** Rather than creating a separate BigQuery view for every chart (top states, top conditions, top hospitals), all dashboard charts pull from a single enriched view. Aggregation and filtering happen at the dashboard layer. This avoids duplicated business logic across multiple database objects and keeps a single source of truth — the more defensible architecture when asked "how is your data layer structured?"

## Repository Structure

```
healthflow-analytics/
├── data/
│   ├── raw/hospital_readmissions.csv
│   └── clean/hospital_readmissions_clean.csv
├── notebooks/
│   └── 01_eda_exploration.ipynb
├── sql/
│   ├── 01_summary_stats.sql
│   ├── 02_top_states.sql
│   ├── 03_conditions_breakdown.sql
│   ├── 04_top_hospitals.sql
│   └── 05_enriched_dataset.sql
├── dashboard/
│   └── eda_overview.png
├── .gitignore
├── requirements.txt
└── README.md
```

## Dashboard Structure

The dashboard follows a national → geographic → clinical → institutional narrative, with interactive filters (state, condition) for drill-down exploration:

1. **National Overview** — key scorecards (avg excess ratio, hospital count, % above benchmark)
2. **Geographic Breakdown** — top 10 worst-performing states
3. **Clinical Breakdown** — conditions ranked by severity and by share above benchmark
4. **Hospital-Level Detail** — top 20 worst hospital/condition combinations
5. **Interactive Filtering** — explore any state or condition combination

## Dataset

[CMS Hospital Readmissions Reduction Program](https://data.cms.gov/) — publicly available data on 30-day risk-adjusted readmission rates across US hospitals for six conditions: Heart Attack, Heart Failure, Pneumonia, COPD, Hip/Knee Replacement, and Heart Bypass Surgery.

## Tools

- **Python** (pandas) — data cleaning and exploratory analysis
- **Google BigQuery** — cloud data warehouse
- **Looker Studio (Data Studio)** — dashboard and visualization layer
- **Git/GitHub** — version control

---

_Built as a portfolio project demonstrating end-to-end data analytics: cleaning, cloud warehousing, SQL analysis, and dashboard design._
