# SQL Server implementation

SQL Server 2022; Windows integrated authentication. The default databases are `SA_Health_Dimensions` (staging) and `DW_Health_Dimensions` (warehouse).

The supported end-to-end setup is `scripts/setup.ps1` on the `ssis` branch, which executes the SQL files in the required order and loads data through SSIS. Merely creating tables does not load data. These scripts use SQLCMD variables `StagingDatabase` and `WarehouseDatabase`; enable SQLCMD mode in SSMS or supply `sqlcmd -v`.

| Files | Purpose |
|---|---|
| 01, 02 | Create staging, warehouse and dimensions |
| 03, 04, 08 | Calendar and dimension preparation |
| 05, 06 | Five fact definitions and their preparation logic |
| 09 | Surrogate keys and member mappings |
| 07 | Analysis queries |
| 99 | Referential, record-level and amount reconciliation |

This branch is the current five-fact implementation. Historical two-fact documents and alternative Python warehouse totals are not the SQL reference.
