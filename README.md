# HealthRetailers Power BI

Open `HealthRetailers/HealthRetailers.pbip` in Power BI Desktop. Keep the Report and SemanticModel folders beside it. This is the current seven-page report; the workshop/quality page and requested explanatory text were removed.

1. Synthèse
2. Commercial
3. Clients
4. Stock
5. Paiements
6. Achats
7. Règlements

The semantic model contains five warehouse dimensions, five facts, 39 DAX measures and 13 active relationships. The current-stock fact has no active date relationship because its snapshot date is unknown.

Git does not contain the machine-local imported-data cache. First run SQL/SSIS setup, then refresh this project using Windows credentials for `localhost` / `DW_Health_Dimensions`. Change `ServeurSQL` and `BaseDW` in Power Query if needed. Authentication is performed by the user, not stored in the repository.

`HealthRetailers_Theme.json` is the reusable navy/teal/amber theme. Import it into another report through View → Themes → Browse for themes. `mesures_cahier.dax` contains all measure definitions. Previously recorded SQL/DAX reconciliation evidence is on `validation`.

BI uses real transactions through 2025-04-30. The calendar extends beyond the loaded sales history; no generated transactions were added to this report. Margin excludes lines with unknown costs. Payment allocations and sales amounts have different grains and should not be joined directly.

The Paiements trend shows daily values when one month is selected and monthly totals otherwise. Payment methods retain fixed theme colors when filtered.
