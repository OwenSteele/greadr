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
    try {
        New-Item $profileLocation >$null        
    }
    catch {
        Write-Host "The listed dir for your powershell profile could not be found or accessed." -ForegroundColor Red -BackgroundColor Black
        Write-Host "Listed dir: '$p'"
        $forceAnswer = Read-Host "Attempt to forcefully create file? [y/n-AnyKey]]: "
        if ($forceAnswer -eq "y"){
            New-Item -type file -path $profileLocation -force
        }
    }
}
$existing = get-Content $profileLocation | out-string
try {
if($existing -match "Set-Alias $alias") {
    Write-Host "Alias already set!" -ForegroundColor Cyan -BackgroundColor Black -NoNewLine 
    Write-Host ""
    Exit
}
}
catch { 
    Write-Host ""
    Write-Host "Could not check alias settings of powershell profile:" -ForegroundColor Red -BackgroundColor Black -NoNewLine 
    Write-Host " '$p'"
    Write-Host "    Add this to file and execute: " -NoNewLine 
    Write-Host "Set-Alias $alias $p -Scope Global" -ForegroundColor Cyan -BackgroundColor Black  -NoNewLine 
    Write-Host ""
}
try {
    Set-Content $profileLocation "Set-Alias $alias $p -Scope Global`n$existing"    
}
catch { 
    Write-Host ""
    Write-Host "Could not add greadr to powershell profile." -ForegroundColor Red -BackgroundColor Black -NoNewLine 
    Write-Host ""
    Write-Host "'$p'"
    Write-Host "Add this to file and execute: " -NoNewLine 
    Write-Host "Set-Alias $alias $p -Scope Global" -ForegroundColor Cyan -BackgroundColor Black  -NoNewLine 
    Write-Host ""
    Exit
}
try {
& "$profileLocation"
}
catch { 
    Write-Host ""
    Write-Host "Could not execute action." -ForegroundColor Red -BackgroundColor Black -NoNewLine 
    Write-Host ""
    Write-Host "Copy this line to the terminal to manually execute:"
    Write-Host ".\$p" -ForegroundColor Cyan -BackgroundColor Black 
    Exit
}
 
Write-Host ""
Write-Host "Set" -ForegroundColor Green -BackgroundColor Black -NoNewline
Write-Host " Type: " -NoNewline
Write-Host "greadr" -NoNewline -ForegroundColor Green
Write-Host " to call greadr"