param (
        [string]$dir,
        [string]$ga,
        [string]$j,
        [string]$u,
        [string]$f
    )   

Write-Host "Checking for go compiler " -NoNewline
$goparams = "version".Split(" ")
$goinstalled = & "go" $goparams 2>&1 | out-string
# need to hide error for when not installed
if ($goinstalled.StartsWith("go") -eq $true) {
    Write-Host "installed" -ForegroundColor Green -BackgroundColor Black  
}
else {
    Write-Host "not found." -ForegroundColor Red -BackgroundColor Black
    Write-Host "greader requires go to run, install it here: " -NoNewline
    Write-Host "https://golang.org/doc/install" -ForegroundColor Yellow red -BackgroundColor Black    
}
Write-Host "Checking for local json config file " -NoNewline
if ((Invoke-Expression "$f -dir $dir -fileName \greadr.json")) {
    Write-Host "file found" -ForegroundColor Green -NoNewline -BackgroundColor Black  
    Write-Host " ('greadr --create-json' will overwrite this file)"
}
else {
    Write-Host "no file found" -ForegroundColor red -BackgroundColor Black
    Write-Host "Creating greadr.json file.. " -NoNewline
    Invoke-Expression "$j -dir $dir -u $u"   
}
Write-Host "Setting global alias: " -NoNewline
Invoke-Expression $ga