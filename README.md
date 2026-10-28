# Where Is the Money Leaking? — E-commerce Retention & Profitability Analysis

**An end-to-end analytics project: data cleaning → SQL → statistical testing → customer segmentation → predictive model → business recommendations.**

**Tools:** Python (pandas, SciPy, scikit-learn, seaborn) · SQL (SQLite, window functions, CTEs) · Statistics · Data storytelling
**Dataset:** 6,000 customers · 60 products · ~12,000 orders · Jan 2024 – Dec 2025 · currency ₹ INR

> ⚠️ **Data note:** No public dataset has this exact schema, so I generated a *synthetic but realistic* Indian e-commerce dataset (`src/generate_data.py`, seeded for reproducibility). I deliberately injected real-world mess (duplicates, invalid dates, nulls, inconsistent casing, impossible ages) to demonstrate cleaning. The findings describe this dataset; the **methods** are what transfer to real data.

---

## 🎯 The business question

> *A growing online retailer is spending heavily on acquisition and discounts. **Which customers are actually worth acquiring, which products actually make money, and are discounts helping or hurting?***

## 🔑 Headline findings

| # | Finding | Evidence |
|---|---------|----------|
| 1 | **Acquisition channel quality varies ~1.8× in customer value.** Referral customers are worth **₹14.6K** on average vs **₹8.1K** for Paid Social. | Repeat rate 62.8% vs 29.3%. Chi-square test (channel vs repeat) p < 0.001; Mann-Whitney on LTV p < 0.001 |
| 2 | **Paid Social + Influencer bring 32% of customers but the lowest repeat rates (29–36%).** Budget there should be judged on LTV, not cost-per-signup. | `outputs/charts/04_channel_quality.png` |
| 3 | **Discounts destroy profit without growing the basket.** Profit/order falls from **₹1,842 (no discount) to ₹526 (20% off) — a 71% drop** — while average order value *doesn't rise* (₹6.6K → ₹5.4K). | `outputs/charts/07_discount_impact.png` |
| 4 | **Electronics = 58% of revenue but the thinnest margin (18.5%)**; Beauty (49%) and Fashion (43.5%) are 2–3× more profitable per rupee. | `outputs/charts/02_category_profitability.png` |
| 5 | **Revenue is highly concentrated:** top 20% of customers = **64%** of revenue; top 10% = 43%. | Pareto curve, `05_pareto.png` |
| 6 | **~₹41 lakh of historical revenue sits with 447 "At-Risk" high-value customers** who've gone quiet — a ready-made win-back list. | RFM segmentation, `outputs/tables/rfm_customers.csv` |
| 7 | **Retention drops off a cliff after month 1**: ~66% order in month 0, ~22% in month 1, <10% by month 6 — across *every* cohort. The first 30 days are the whole game. | Cohort heatmap, `03_cohort_retention.png` |
| 8 | Festive months (Oct–Nov) deliver ~20% of revenue from 17% of the calendar — a real but **modest** lift. | `01_monthly_revenue.png` |

## 💡 Recommendations

1. **Shift acquisition spend toward referral and email programmes**; cap Paid Social/Influencer bids at a CAC that fits their ~₹8K LTV, not the blended average.
2. **Stop blanket 20% discounts.** Replace with targeted offers (e.g., win-back for At-Risk segment) and test whether bundling lifts basket size without the margin hit.
3. **Build a 30-day onboarding journey** (second-purchase nudge, category recommendations) — retention is lost almost entirely in month 1.
4. **Protect Electronics margin** (bundles with accessories, which carry higher margin) and **promote Beauty/Fashion cross-sell**.
5. **Launch a win-back campaign** on the 447 At-Risk customers; even a 10% reactivation is a measurable revenue target.

## 🧪 What I did (methodology)

1. **Data cleaning** – removed 134 duplicate orders, 35 invalid dates; standardised city names; handled 239 missing/impossible ages (median impute), 90 missing channels and 70 missing payment methods (labelled "Unknown" rather than guessed). Every step is logged in `outputs/tables/key_metrics.json`.
2. **SQL layer** – loaded into SQLite and wrote 6 analytical queries (`sql/queries.sql`) using **window functions** (`LAG`, `RANK`, running totals), **CTEs**, and **self-joins** (market-basket product pairs).
3. **Revenue & profit definition** – revenue counts *Delivered* orders only (excludes returns/cancellations); profit = category margin minus discount cost.
4. **Cohort retention** – monthly signup cohorts, with not-yet-observed months masked (avoiding right-censoring errors).
5. **Hypothesis testing** – chi-square (channel vs repeat), Mann-Whitney U (LTV is skewed, so non-parametric).
6. **RFM segmentation** – quintile scoring → 6 actionable segments.
7. **Predictive model** – logistic regression for "will a new customer reorder within 90 days?" (AUC 0.67). Kept deliberately interpretable: top drivers are acquisition channel (Referral/Email ↑, Paid Social/Influencer ↓) — consistent with the statistical findings.

## 📁 Repository structure

```
├── README.md
├── run_all.sh               # reproduce everything in one command
├── requirements.txt
├── src/
│   ├── generate_data.py     # seeded synthetic data with injected data-quality issues
│   └── run_analysis.py      # cleaning → SQL → analysis → charts → metrics
├── sql/queries.sql          # 6 documented SQL queries (window functions, CTEs)
├── data/
│   ├── raw/                 # messy source CSVs
│   └── processed/           # clean CSVs + retail.db (SQLite)
└── outputs/
    ├── charts/              # 8 publication-style charts
    └── tables/              # every result as CSV + key_metrics.json
```

## ▶️ Run it

```bash
pip install -r requirements.txt
python src/generate_data.py
python src/run_analysis.py
```

## ⚖️ Limitations & honest caveats

- **Synthetic data**: relationships (e.g., channel → repeat behaviour) were built into the generator, so the stats confirm them by design. On real data, I'd expect smaller, noisier effects.
- **Discount analysis is observational**: on real data, discounts are targeted, so confounding is likely. The right next step is an **A/B test**.
- **Predictive model is modest (AUC 0.67)**; it adds explanation more than prediction. Next steps: richer behavioural features (browsing, session data) and gradient boosting.
- Customer acquisition cost isn't in the data, so channel ROI is judged on LTV only.

## 🚀 If I had more time
Build a Power BI/Tableau dashboard on `retail.db`, add CAC data for true channel ROI, run survival analysis (Kaplan–Meier) on time-to-second-order, and design the discount A/B test.
