$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
git -C $root fetch origin
if($LASTEXITCODE){throw 'Git fetch failed'}
foreach($branch in @('specifications','dwh-schema','sql-server','ssis','powerbi','ml-notebooks','data','validation')){
    $target=Join-Path $root "work/$branch"
    if(Test-Path $target){Write-Host "Already present: $target";continue}
    git -C $root worktree add --detach $target "origin/$branch"
    if($LASTEXITCODE){throw "Failed to check out $branch"}
}
