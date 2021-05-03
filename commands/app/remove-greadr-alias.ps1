Remove-Item alias:greadr 2>&1

Write-Host "Alias removed:" -NoNewline
Write-Host " greadr"-ForegroundColor red
Write-Host "Type: " -NoNewline
Write-Host ".\greadr.ps1 --set-alias" -NoNewline -ForegroundColor Green
Write-Host " to add it back"