param (
    [string]$dir,
    [Parameter(Mandatory = $false)][string]$jsonArgs,
    [string]$u
)    

$actionArg = " "
$actionArg2 = " "

if ([string]::IsNullOrWhiteSpace($jsonArgs)) {
    $actionArg = $strArgs.Split(" ")[0] 
    $actionArg2 = $strArgs.Split(" ")[1] 
}    
else {
    $actionArg = $strArgs.Split(" ")[1]
    $actionArg2 = $strArgs.Split(" ")[2]
}

if ($actionArg -ne "--overwrite" -and $actionArg2 -ne "--overwrite") {
    if (Test-Path "$dir\greadr.json") {
        Write-Host "greadr.json already exists. No changes made." -ForegroundColor Yellow -BackgroundColor Black
        Write-Host "use: " -NoNewline; Write-Host "--overwrite" -ForegroundColor Yellow -BackgroundColor Black -NoNewline; Write-Host " to overwrite your greadr.json"
        Exit
    }
}

$content = ""
$type = "default"    
if ($jsonArgs -eq "jupyter" -or $jsonArgs -eq "j") { 
    $content = '{"ignore":{"folders":[],"fileTypes":["png","jpg","jpeg"],"partials":["---images","---.ipynb_checkpoints","-checkpoint.ipynb"],"fileNames":[],"outputFile":false,"greadrFiles":true,"gitFiles":true},"output":{"name":"README","type":"md"},"format":{"fileTitle": "Jupyter Notebooks","doubleSpace":false,"ignoreEmpty":true},"data":{"before":{"text":"","filePath":"before.md"},"after":{"text":"","filePath":"after.md"}}}' 
    $type = "jupyter"
}
elseif ($jsonArgs -eq "txt" -or $jsonArgs -eq "text" -or $jsonArgs -eq "t") {
    $content = '{"ignore":{"folders":[],"fileTypes":[],"partials":[],"fileNames":[],"outputFile":false,"greadrFiles":true,"gitFiles":false},"output":{"name":"README","type":"txt"},"format":{"fileTitle":"GReadrDirTree","doubleSpace":false,"ignoreEmpty":true},"data":{"before":{"text":"","filePath":""},"after":{"text":"","filePath":""}}}'
}
else {
    $content = '{"ignore":{"folders":[],"fileTypes":[],"partials":[],"fileNames":[],"outputFile":false,"greadrFiles":true,"gitFiles":true},"output":{"name":"README","type":"md"},"format":{"fileTitle": "GReadr Dir Tree","doubleSpace":false,"ignoreEmpty": true},"data":{"before":{"text":"","filePath":"before.md"},"after":{"text":"","filePath":"after.md"}}}'
}

Set-Content $dir\greadr.json "$content"
Write-Host "greadr.json created ($type)" -ForegroundColor Cyan -BackgroundColor Black

if ($actionArg -eq "-i" -or $actionArg -eq "-ignore") {
    Invoke-Expression $u
}