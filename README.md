# HealthRetailers — Business Intelligence & Machine Learning

Retail analytics project: original CSV exports, data cleaning, a SQL Server data warehouse, native SSIS integration, a seven-page Power BI report, and four ML notebooks.

## Architecture
+
+```mermaid
+flowchart LR
+    A[Original CSV exports] --> B[SQL staging via SSIS]
+    B --> C[Five dimensions and five facts]
+    C --> D[Power BI and DAX]
+    A --> E[Cleaning and feature engineering]
+    F[Separate synthetic data] --> E
+    G[Weather and epidemiology] --> E
+    E --> H[Four ML notebooks]
+```
+
+## Branches

| Branch | Deliverable |
|---|---|
| [main](https://github.com/Firas443/Bi-and-ML-Project/tree/main) | Project overview and checkout helper |
| [specifications](https://github.com/Firas443/Bi-and-ML-Project/tree/specifications) | Updated cahier de spécifications and source-data guide |
| [dwh-schema](https://github.com/Firas443/Bi-and-ML-Project/tree/dwh-schema) | Actual five-dimension/five-fact SQL schema and editable diagram |
| [sql-server](https://github.com/Firas443/Bi-and-ML-Project/tree/sql-server) | Staging/warehouse DDL, transformation logic and SQL checks |
| [ssis](https://github.com/Firas443/Bi-and-ML-Project/tree/ssis) | Visual Studio solution, native packages and portable setup scripts |
| [powerbi](https://github.com/Firas443/Bi-and-ML-Project/tree/powerbi) | Seven report pages, semantic model, 36 DAX measures and theme |
| [ml-notebooks](https://github.com/Firas443/Bi-and-ML-Project/tree/ml-notebooks) | Cash anomalies, sales anomalies, segmentation and demand forecasting |
| [data](https://github.com/Firas443/Bi-and-ML-Project/tree/data) | Separate original, generated and cleaned data folders |
| [validation](https://github.com/Firas443/Bi-and-ML-Project/tree/validation) | SSIS checks, Excel/SQL reconciliation and Power BI checks |

Each branch contains its own deliverable and README. Branches are parallel deliverable snapshots, not features waiting to merge. Presentations and the final report are intentionally excluded.

## Check out the deliverables together

```powershell
git clone https://github.com/Firas443/Bi-and-ML-Project.git
cd Bi-and-ML-Project
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/checkout.ps1
```

The helper fetches branches and creates sibling worktrees under `work/`. They are detached for reading/running; create a local feature branch before editing one. `work/data`, `work/sql-server`, `work/ssis` and `work/ml-notebooks` share the expected relative layout without making eight additional clones.

## BI workflow

1. Read `work/specifications/docs/cahier-de-spec.pdf` and `work/dwh-schema/README.md`.
2. Install SQL Server/SSIS 2022, Visual Studio 2022 with SSIS Projects, MSOLEDBSQL, sqlcmd and Python 3.12.
3. From `work/ssis`, run `scripts/setup.ps1`, then execute `Master.dtsx` in Visual Studio.
4. Open `work/powerbi/HealthRetailers/HealthRetailers.pbip`; authenticate to local SQL and refresh.
5. Review `work/validation` for historical evidence; rerun tests before claiming a new validation.

## ML workflow

Install `work/ml-notebooks/requirements.txt` in a Python 3.12 virtual environment and open its notebooks in JupyterLab. The data checkout includes the inputs; use `HEALTH_RETAILERS_DATA` if it is stored elsewhere. Generated months are clearly separated from real records.

## Model and scope

Dimensions: `dim_temps`, `dim_produit`, `dim_client`, `dim_fournisseur`, `dim_paiement`.

Facts: `fait_ventes`, `fait_achats`, `fait_stock_actuel`, `fait_encaissements`, `fait_decaissements`.

SQL Server stores the warehouse; SSMS is the management/query application. Power BI supplies the analytical semantic model. No separate SSAS cube is claimed. The BI report loads real transactions from 2024-09-30 to 2025-04-30; its calendar runs to 2026-09-29. ML experiments may use the separately generated continuation. Stock has no known snapshot date; missing costs and thresholds remain unknown.

## Credits and data

Repository owner: Firas443. The SSIS baseline derives from [amal-mh/HealthRetailers_DW](https://github.com/amal-mh/HealthRetailers_DW); earlier data-preparation scripts and specifications derive from [Youssef-ben-ali/DataWarehouseProject_3AI4](https://github.com/Youssef-ben-ali/DataWarehouseProject_3AI4). Supplied notebooks and the project's subsequent corrections are retained with provenance. No license is invented for third-party source material.

Data publication was explicitly authorized by the project owner. Authentication values are removed; see `data/publication_changes.json`. Credentials, local machine settings, runtime DLLs, build caches and local Power BI data caches are not committed.

## Verification snapshot

The supplied ML analyses were freshly rerun after path adaptation: all four notebooks and 49 code cells completed successfully. The portable SSIS configuration was tested in a disposable copy without the old Git history. Current SQL metadata confirms five dimensions, five facts and 14 physical foreign keys. Historical ETL and SQL/DAX evidence remains labelled by its execution date on `validation`.
