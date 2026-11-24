param([string]$DataRoot='', [string]$SqlRoot='', [string]$VisualStudioPath='C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.com')
$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
Set-Location $root
$python='python'
$prepArgs=@()
if($DataRoot){$prepArgs+=@('--data-root',$DataRoot)}
if($SqlRoot){$prepArgs+=@('--sql-root',$SqlRoot)}
& $python (Join-Path $PSScriptRoot 'prepare_workspace.py') @prepArgs
if($LASTEXITCODE){throw 'Source preparation failed'}
& $python (Join-Path $PSScriptRoot 'configure.py')
if($LASTEXITCODE){throw 'Configuration failed'}
$settingsFile=if(Test-Path 'settings.json'){'settings.json'}else{'settings.example.json'}
$settings=Get-Content $settingsFile -Raw | ConvertFrom-Json
foreach($name in @('01_SA_Health.sql','02_DW_Health.sql','04_dimension_sources.sql','05_faits.sql','06_faits_complementaires.sql','08_dimension_reference.sql','09_surrogate_keys.sql')){
 & sqlcmd -S $settings.Server -E -C -b -f 65001 -v "StagingDatabase=$($settings.StagingDatabase)" "WarehouseDatabase=$($settings.WarehouseDatabase)" -i (Join-Path $root "sql\$name")
 if($LASTEXITCODE){throw "SQL setup failed: $name"}
}
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'build-facts.ps1')
if($LASTEXITCODE){throw 'ETL diagram authoring failed'}
& $python (Join-Path $PSScriptRoot 'layout-facts.py')
if($LASTEXITCODE){throw 'ETL diagram layout failed'}
$vs=$VisualStudioPath
& $vs (Join-Path $root 'HealthRetailers_SSIS.sln') /Build Development /Out (Join-Path $root 'reports\build.log')
if($LASTEXITCODE){throw 'Visual Studio build failed'}
Write-Host 'Setup complete. Run scripts\verify.ps1 or execute Master.dtsx in Visual Studio.'
