param (
    [string]$p
)

$alias = "greadr"
$p = $p

$profileLocation = & Write-Output $profile | out-string
$profileLocation = "$profileLocation"
$profileLocation = $profileLocation.Trim()

if (Test-Path $profileLocation) {
}
else {
    New-Item $profileLocation >$null
}

$existing = get-Content $profileLocation | out-string

if($existing -Match "Set-Alias $alias") {
    Write-Host "Alias already set!" -ForegroundColor Cyan -BackgroundColor Black
    Exit
}

Set-Content $profileLocation "Set-Alias $alias $p -Scope Global`n$existing"

& "$profileLocation"

Write-Host "Set" -ForegroundColor Green -BackgroundColor Black  
Write-Host "Type: " -NoNewline
Write-Host "greadr" -NoNewline -ForegroundColor Green
Write-Host " to call greadr"
Write-Host "GReadr global alias set." -ForegroundColor Cyan -BackgroundColor Black