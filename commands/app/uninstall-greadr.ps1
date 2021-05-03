param (
    [string]$isForced
)    
$forced = $isForced.Split(" ")[1] 
if ($forced -ne "-force"){
    Write-Host "To Uninstall GReadr, add '--force'" -ForegroundColor Red   
    Write-Host "If you are Unhappy with GReadr" -ForegroundColor Cyan       
}