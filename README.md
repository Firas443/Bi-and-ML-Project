# HealthRetailers SSIS

Native Visual Studio 2022 solution targeting SQL Server/SSIS 2022. Five dimensions and five fact tables; 17 CSV-to-staging flows.

## Prerequisites

SQL Server 2022 Developer with Integration Services runtime, Visual Studio 2022 with SSIS Projects, MSOLEDBSQL, `sqlcmd`, Python 3.12 and Windows PowerShell 5.1.

## Setup

Use the `main` branch's `scripts/checkout.ps1` to check out sibling `data`, `sql-server` and `ssis` folders. Copy `settings.example.json` to `settings.json` only if changing the server/database names.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/setup.ps1
```

For a different layout, pass `-DataRoot C:\path\to\data -SqlRoot C:\path\to\sql-server`. A different VS installation can be supplied with `-VisualStudioPath`.

Setup copies source/SQL dependencies locally, regenerates portable connection managers and native data flows, then builds `HealthRetailers_SSIS.sln`. Open the solution and execute `Master.dtsx`: import → calendar → dimension/fact loading → verification. The checked-in packages are deliverable source; run setup first to configure paths for your machine.

`scripts/verify.ps1` runs the package twice and tests updates/restoration. It changes test data temporarily in the configured databases, restores its fixtures, and requires the full runtime. Use development databases.

Baseline templates are vendored under `scripts/templates`; configuration no longer depends on an absent Git commit. They originate from [Amal's HealthRetailers project](https://github.com/amal-mh/HealthRetailers_DW), commit `3d52d4f48c66da6eccee05ee1050188ae1a4af6d`. Subsequent five-fact implementation and corrections are preserved from the project workspace. No runtime DLLs, build outputs, user settings or credentials are included.
