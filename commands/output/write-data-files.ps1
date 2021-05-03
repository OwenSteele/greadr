param (
    [string]$dir
)     

if(Test-Path "$dir\greadr\"){
    
if(Test-Path "$dir\greadr\after.md"){
}
else{
    new-item .\greadr\after.md >$null
    Write-Host "created after.md" -ForegroundColor Cyan
}
if(Test-Path "$dir\greadr\before.md"){
}
else{
    new-item .\greadr\before.md >$null
    Write-Host "created before.md" -ForegroundColor Cyan
}
}
else{
    new-item "$dir\greadr" -itemtype directory >$null
    new-item "$dir\greadr\after.md" >$null
    new-item "$dir\greadr\before.md" >$null
    Write-Host "created after.md" -ForegroundColor Cyan
    Write-Host "created before.md" -ForegroundColor Cyan
}