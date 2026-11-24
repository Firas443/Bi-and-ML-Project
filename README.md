# Verification evidence

`ssis/ETL_VERIFICATION.md` records the five-dimension/five-fact SSIS verification from 2026-11-11: 83 passed checks, rerun stability, update restoration, source/staging hashes, amounts and trusted foreign keys.

`ssis/HealthRetailers_CSV_vs_SQL.xlsx` compares independently calculated CSV results with SQL Server. Its three tabs cover aggregate comparisons, monthly comparisons and source/cleaning rules. CSV and SQL columns are stored snapshots; Excel recalculates the difference/status columns, not the underlying SQL queries. The 17 imported staging files total 244,300 rows.

`powerbi/validation_results.json` records 75 passing SQL/DAX comparisons from 2026-11-18. Later visual-only changes and removal of the eighth page did not change the semantic model. Current report-schema checks are in `powerbi/schema_validation.json` (73 definitions, no errors). These files are recorded evidence, not a claim that checks ran again on every clone.

Use `scripts/verify.ps1` on `ssis` to rerun the development-database ETL tests. The SQL assertions are on `sql-server/sql/99_verifications.sql`. `tools/checks.json` describes independent SQL/DAX comparisons; `compare_checks.py` needs a fresh matching `dax_checks.json` export from the live Power BI engine. Do not confuse an old PASS file with a fresh execution.

## Fresh ML execution — 2026-11-24

All four notebooks were executed from the published folder layout: cash anomalies (12 cells), customer segmentation (11), demand forecasting (14), sales anomalies (12). All 49 code cells completed without errors. Results and exact environment versions are in `ml/`; notebook-generated figures are in `ml/figures/`. Executing successfully does not imply strong predictive performance: review each model against its baseline and holdout metrics.
