# HealthRetailers datasets

This branch contains the data authorized by the project owner for publication.

| Folder | Contents |
|---|---|
| `original/` | The 29 original export files, real period 2024-09-30 through 2025-04-30 |
| `generated/` | Reproducible synthetic continuation, 2025-05-01 through 2026-09-29 |
| `cleaned/` | Standardized real data; `synthetique/` contains separately cleaned generated data |
| `external/` | Weather and epidemiology inputs for demand forecasting |
| `warehouse/` | Authoritative CSV snapshot exported from the ten SQL warehouse tables |
| `ml-features/` | Prepared matrices, features and result tables exported by the four notebooks |
| `preparation/` | Cleaning, generation and legacy dataset-preparation scripts |

## Reproduce

From this branch's root, with Python 3.12:

```powershell
python preparation/generate_external_data.py
python preparation/clean_data.py
python preparation/clean_data.py --synthetique
```

The original local source files were not changed. In the published copy of `users_csv.csv`, `Password` and `PasswordSalt` are blanked (14 non-empty credential cells removed). IDs and analytical fields are preserved. No authentication values are needed by the notebooks.

The SQL/SSIS implementation imports 17 of these 29 files and uses only real transactions. The ML notebooks use a broader source selection. Do not merge real and generated records without keeping their date boundary. The Python `build_dataset.py` is the earlier CSV/ML preparation pipeline; SQL Server and SSIS are the authoritative source for the BI report's totals.

External sources: [Open-Meteo archive](https://open-meteo.com/en/docs/historical-weather-api), [Réseau Sentinelles](https://www.sentiweb.fr/). Source URLs and SHA-256 hashes are recorded in manifests. Results are experiments on the supplied export, not a deployed operational system.
