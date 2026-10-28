# Interview cheat-sheet (keep for yourself — delete before sharing if you like)

**30-second pitch**
"I built an end-to-end analysis of an e-commerce business to answer: which customers and products actually make money? I cleaned messy data, used SQL window functions, tested hypotheses statistically, segmented customers with RFM, and found that acquisition channel quality differs by ~1.8x in lifetime value and that 20% discounts cut profit per order by ~70% without raising basket size. I turned that into five recommendations."

**Questions you should be ready for**
1. *"Why synthetic data?"* — Needed a specific schema (orders, items, customers, channels) and wanted to control data-quality issues. Be upfront; say you'd validate on real data and that methods transfer.
2. *"Why Mann-Whitney instead of a t-test?"* — LTV is heavily right-skewed with power users; non-parametric is safer.
3. *"How did you define revenue?"* — Delivered orders only; returns/cancellations excluded.
4. *"Why is AUC only 0.67 — is the model useless?"* — Features are limited to signup/first-order info; value is interpretability. Next step: behavioural data + GBM.
5. *"Why did you label missing channels 'Unknown' instead of imputing?"* — Guessing a marketing channel would invent signal; 1.5% of rows, kept visible.
6. *"What would you do next?"* — A/B test discounts, add CAC, survival analysis on time-to-second-order.
7. *"What's right-censoring in your cohort chart?"* — Recent cohorts haven't had time to reach later months; zeros there would be misleading, so I masked them.
8. *"Walk me through one SQL query."* — Use `customer_repeat_gap_days` (LAG + PARTITION BY) or the product-pairs self-join.

**Resume bullet**
"Analysed 12K orders / 6K customers (Python, SQL): identified a 1.8x LTV gap between acquisition channels (p<0.001), showed 20% discounts cut profit/order by 71% with no AOV lift, and built RFM segments isolating ₹41L of at-risk revenue; delivered 5 data-backed recommendations."
