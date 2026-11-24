# Four HealthRetailers ML notebooks

| Notebook | Case |
|---|---|
| cash_anomaly_v2_executed | Cash-operation anomalies and cancellation experiment |
| sales_anomaly_complete_commented | Sales-line anomaly review |
| customer_segmentation_complete_commented | Customer segmentation |
| demand_forecast_complete_commented | Weekly demand forecasting with a baseline |

Full filenames are under `notebooks/`. The supplied notebooks contained 49 executed code cells with no saved error outputs. The four notebooks were rerun successfully on 2026-11-24 after adapting the data paths: 49 code cells, zero execution errors. Current analytical outputs are saved in the notebooks. `notebook_provenance.json` records source hashes and changes. `fresh_execution.json` records the new execution and exact tested package versions. Exported CSVs are on `data/ml-features/`; figures and execution evidence are on `validation/ml/`.

## Run

Use Python 3.12. Check out the `data` branch beside this branch using the helper on `main`, then:

```powershell
python -m venv .venv
.venv/Scripts/python -m pip install -r requirements.txt
.venv/Scripts/python -m jupyter lab
```

Open a notebook and Run All. The setup cell finds sibling `data/original`, `data/generated`, `data/cleaned` and `data/external`. For another layout, set `HEALTH_RETAILERS_DATA` to the data checkout root. Generated files are written under the current directory's `outputs/`, which is ignored by Git.

Real and synthetic transactions stay separate. The forecast notebook opts into the generated extension; the other three default to real data. Evaluate chronological holdouts and compare forecasting models with the naive baseline. Cash/sales alerts are records to review, not confirmed fraud. The saved cancellation predictor has weak holdout performance; do not present it as a deployed or validated operational classifier.
