if (Test-Path ".gitignore") {
}
else {
    New-Item .\.gitignore >$null
    Write-Host "created .gitignore" -ForegroundColor Cyan
}
$existing = Get-Content .\.gitignore | out-string

if ($existing -like "*greadr.json*") {}
else {
    Add-Content .\.gitignore "`ngreadr.json"
    Write-Host "ignoring greadr.json" -ForegroundColor Cyan
}
if ($existing -like "*greadr/*") {}
else {
    Add-Content .\.gitignore "`ngreadr/"
    Write-Host "ignoring local greadr folder" -ForegroundColor Cyan
}