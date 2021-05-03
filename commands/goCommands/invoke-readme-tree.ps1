param (
    [string]$alternatePath,
    [string]$x,        
    [string]$f,
    [string]$g
)
if ($x -eq "\greadr.json") {
    $templateArg = $x
}
else {
    $templateArg = $x.Split(" ")[1]
    if ([string]::IsNullOrEmpty($templateArg)) {
        $templateArg = "default.json"
    }
    $templateArg = $templateArg.ToLower()
    if ($templateArg -eq "j" -or $templateArg -eq "jupyter" -or $templateArg -eq "jupyter.json") {
        $templateArg = "jupyter.json"
    }
    elseif ($templateArg -eq "t" -or $templateArg -eq "text" -or $templateArg -eq "text.json") {
        $templateArg = "text.json"
    }
    if (Invoke-Expression "$f -dir $alternatePath -fileName $templateArg") {}
    else {
        Write-Host "'$templateArg' was not found." -ForegroundColor Red
        Write-Host "Ensure this template file is in the GReader templates folder."
        Exit
    }
}

if (Invoke-Expression "$f -dir $g -fileName ReadmeTree.go") {}
else {
    Write-Host "'ReadmeTree.go' not found." -ForegroundColor Red
    Write-Host "Ensure it is in the correct folder."
    Exit
}
Write-Host "Starting GReadr" -ForegroundColor Green
$params = "run $g\ReadmeTree.go".Split(" ")
if ($alternatePath -ne "") {
    $params += "$alternatePath$templateArg"
}
& "go" $params