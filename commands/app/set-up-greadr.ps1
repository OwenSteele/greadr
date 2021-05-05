param (
        [string]$dir,
        [string]$ga,
        [string]$j,
        [string]$u,
        [string]$f,
        [string]$p
    )   
 
Write-Host ""
Write-Host "Checking for go compiler " -NoNewline
try {
$goinstalled = Invoke-Expression $("go version" 2>&1) | out-string    
}
catch {
    $goinstalled= "err"   
}

# need to hide error for when not installed
if ($goinstalled.StartsWith("Go") -eq $true -or $goinstalled.StartsWith("go") -eq $true) {
    Write-Host "installed" -ForegroundColor Green -BackgroundColor Black  
}
else {
    Write-Host "not found." -ForegroundColor Red -BackgroundColor Black
    Write-Host "    greadr requires go to run, install it here: " -NoNewline
    Write-Host "https://golang.org/doc/install" -ForegroundColor Yellow -BackgroundColor Black    
} 
Write-Host ""
Write-Host "Checking for local json config file " -NoNewline
if ((Invoke-Expression "$f -dir $dir -fileName \greadr.json")) {
    Write-Host "file found" -ForegroundColor Green -NoNewline -BackgroundColor Black  
    Write-Host " ('greadr --create-json' will overwrite this file)"
}
else {
    Write-Host "no file found" -ForegroundColor red -BackgroundColor Black
    Write-Host "    Creating greadr.json file.. " -NoNewline
    Invoke-Expression "$j -dir $dir -u $u"   
} 
Write-Host ""
Write-Host "Setting global alias: " -NoNewline
Invoke-Expression "$ga -p $p"