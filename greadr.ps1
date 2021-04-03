
$basedir = Split-Path $MyInvocation.MyCommand.Path -Parent
$terminalDir = get-location
$strArgs = "$args"
$templatePath = "$PSScriptRoot\templates\"
function Write-Help {
    Write-Host "`nThank you for using Git Readme Builder - GReadr v1.0! By Owen Steele (c) 2021" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "Find greadr on github: " -NoNewline; Write-Host "https://github.com/OwenSteele/greadr" -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "Type "-NoNewline; Write-Host "greadr --info" -NoNewline -ForegroundColor Green -BackgroundColor Black ; Write-Host " for info about how it works."
    Write-Host "`nGReadr builds a map of your directory, with customs ignores, and markdown formatting for git README's."
    Write-Host "JSON config files are used for formatting, ignores and design, custom json files can be built as well as provided templates."    
    Write-Host "`n --- Initial Setup --- " -ForegroundColor Red -BackgroundColor White -NoNewline; Write-Host ""
    Write-Host "GReadr requires initial setup before it can be used."
    Write-Host "Greadr uses golang to complile the map files, go compiler is required."
    Write-Host "    ---Steps---"
    Write-Host "    1. In Powershell, navigate to the root greadr installed folder (same as greader.ps1)."
    Write-Host "    2. Enter: " -NoNewline; Write-Host "./greadr.ps1 --setup" -ForegroundColor Green -BackgroundColor Black
    Write-Host "    This setup is required for GReadr to be used in any dir."
    Write-Host "    NOTE: this setup is required for each machine account user."
    Write-Host "`n----- Commands -----" -ForegroundColor Red -BackgroundColor White -NoNewline; Write-Host ""
    Write-Host "--create-json" -NoNewline -ForegroundColor Green -BackgroundColor Black; Write-Host " builds a blank greadr config file in your current dir."
    Write-Host "    [-i -ignore]" -NoNewline -ForegroundColor Green -BackgroundColor Black; Write-Host " in creating/overwriting greadr.json, adds the greadr.json file to you .gitignore (creates one if .git folder exists)."
    Write-Host "    [--overwrite]" -NoNewline -ForegroundColor Green -BackgroundColor Black; Write-Host " if a greadr.json file already exists, this param is required to change it."
    Write-Host "--create-files" -NoNewline -ForegroundColor Green -BackgroundColor Black; Write-Host " builds blank files for text/data before and after the map tree"
    Write-Host "    these files can be renamed, but must match in the greadr.json config file"
    Write-Host "--ignore-greadr" -NoNewline -ForegroundColor Green -BackgroundColor Black; Write-Host " same as -i -ignore, only adds config file to .gitignore, doesn't affect greadr.json content"
    Write-Host "--setup" -NoNewline -ForegroundColor Green -BackgroundColor Black; Write-Host " Initial greadr setup (checks for go compiler, local greadr.json file, sets up alias."
    Write-Host "--template -t" -NoNewline -ForegroundColor Green -BackgroundColor Black; Write-Host " designates that a template is used for creating the directory map."
    Write-Host "    If this is not called, and no local greadr.json file exists, map will not be created."
    Write-Host "    arguments after can select the template, if left blank, default (README.md) is used."
    Write-Host "    e.g. " -NoNewline; Write-Host "'greadr -t j' or 'greadr --template jupyter' or 'greadr -t jupyter.json'" -NoNewline -ForegroundColor Green -BackgroundColor Black; Write-Host " Will use the built in jupyter notebook template."
    Write-Host "--get-templates" -NoNewline -ForegroundColor Green -BackgroundColor Black; Write-Host " See all current templates"
    Write-Host "--set-alias" -NoNewline -ForegroundColor Green -BackgroundColor Black; Write-Host " manually reassign the alias temporarily, NOTE may need to be called in root: " -NoNewline; Write-Host "./greadr --set-alias" -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "--remove-alias" -NoNewline -ForegroundColor Green -BackgroundColor Black; Write-Host " manually removes the alias temporarily."

}function Write-Info {
    Write-Host "`nGit Readme Builder - GReadr v1.0! By Owen Steele (c) 2021"
    Write-Host "Find greadr on github: https://github.com/OwenSteele/greadr"
    Write-Host "GReadr is built in PowerShell and GoLang"
    Write-Host "The Files are managed in powershell, with the mapped files written in Go"
    Write-Host "`n --- Planned Updates ---"
    Write-Host "    Write powershell in .cmd/.sh languages too"
    Write-Host "    Introduce alternative to Go, using only powershell/bash"
    Write-Host "    Addtional features: increased options in config files, more templates, increased optional args in greader calls"
    Write-Host ""
}
function Update-Git-Ignore {
    if(Test-Path ".gitignore"){
    }
    else{
        New-Item .\.gitignore >$null
        Write-Host "created .gitignore" -ForegroundColor Cyan
    }
    $existing = Get-Content .\.gitignore | out-string

    if($existing -like "*greadr.json*"){}
    else {
        Add-Content .\.gitignore "`ngreadr.json"
        Write-Host "ignoring greadr.json" -ForegroundColor Cyan
    }
    if($existing -like "*greadr/*"){}
    else {
        Add-Content .\.gitignore "`ngreadr/"
        Write-Host "ignoring local greadr folder" -ForegroundColor Cyan
    }
    if($existing -like "*greadrsetup.exe*"){}
    else {
        Add-Content .\.gitignore "`ngreadrsetup.exe"
        Write-Host "ignoring greadr setup exe" -ForegroundColor Cyan
    }
}
function Write-Json-File {
    param (
        [string]$dir,
        [string]$jsonArgs
    )    

    $actionArg = " "
    $actionArg2 = " "

    if([string]::IsNullOrWhiteSpace($jsonArgs)) {
        $actionArg = $strArgs.Split(" ")[0] 
        $actionArg2 = $strArgs.Split(" ")[1] 
    }    
    else {
        $actionArg = $strArgs.Split(" ")[1]
        $actionArg2 = $strArgs.Split(" ")[2]
    }

    if($actionArg -ne "--overwrite" -and $actionArg2 -ne "--overwrite") {
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

    if ($actionArg -eq "-i" -or $actionArg -eq "-ignore"){
        Update-Git-Ignore
    }
}function Write-Data-Files {
    if(Test-Path "$terminalDir\greadr\"){
        
    if(Test-Path "$terminalDir\greadr\after.md"){
    }
    else{
        new-item .\greadr\after.md >$null
        Write-Host "created after.md" -ForegroundColor Cyan
    }
    if(Test-Path "$terminalDir\greadr\before.md"){
    }
    else{
        new-item .\greadr\before.md >$null
        Write-Host "created before.md" -ForegroundColor Cyan
    }
    }
    else{
        new-item "$terminalDir\greadr" -itemtype directory >$null
        new-item "$terminalDir\greadr\after.md" >$null
        new-item "$terminalDir\greadr\before.md" >$null
        Write-Host "created after.md" -ForegroundColor Cyan
        Write-Host "created before.md" -ForegroundColor Cyan
    }
}
function Confirm-File-Exists() {
    param (
        [string]$dir,
        [string]$fileName
    )

    if ($dir -eq "") {
        $dir = $templatePath
    }
    if ($fileName -eq "") {
        $fileName = "default.json"
    }

    if ((Test-Path "$dir$fileName")) { 
        return $true
    }
    else { 
        return $false
    } 
}

function Set-Greadr-Alias {
    $aliasparams = "greadr"
    $aliasparams2 = "C:\Users\owenf\source\repos\greadr\greadr.ps1"   

    $profileLocation = & Write-Output $profile | out-string
    $profileLocation = "$profileLocation"
    $profileLocation = $profileLocation.Trim()

    if (Test-Path $profileLocation) {
    }
    else {
        New-Item $profileLocation >$null
    }
    
    $existing = get-Content $profileLocation | out-string

    Set-Content $profileLocation "Set-Alias $aliasparams $aliasparams2 -Scope Global`n$existing"

    & "$profileLocation"

    Write-Host "Set" -ForegroundColor Green -BackgroundColor Black  
    Write-Host "Type: " -NoNewline
    Write-Host "greadr" -NoNewline -ForegroundColor Green
    Write-Host " to call greadr"
}

function Set-Setup() {
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
    if ((Confirm-File-Exists $basedir "\greadr.json")) {
        Write-Host "file found" -ForegroundColor Green -NoNewline -BackgroundColor Black  
        Write-Host " ('greadr --create-json' will overwrite this file)"
    }
    else {
        Write-Host "no file found" -ForegroundColor red -BackgroundColor Black
        Write-Host "Creating greadr.json file.. " -NoNewline
        Write-Json-File($basedir)    
    }
    Write-Host "Setting global alias: " -NoNewline
    Set-Greadr-Alias
}
function Invoke-ReadmeTree() {
    param (
        [string]$alternatePath
    )
    $templateArg = $strArgs.Split(" ")[1] 
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

    if ((Confirm-File-Exists $alternatePath "\$templateArg")) {}
    else {
        Write-Host "'$templateArg' was not found." -ForegroundColor Red
        Write-Host "Ensure this template file is in the GReader templates folder."
        Exit
    }
    if ((Confirm-File-Exists "$basedir\go" "\ReadmeTree.go")) {}
    else {
        Write-Host "'ReadmeTree.go' not found." -ForegroundColor Red
        Write-Host "Ensure it is in the correct folder."
        Exit
    }
    Write-Host "Starting GReadr" -ForegroundColor Green
    $params = "run $PSScriptRoot\go\ReadmeTree.go".Split(" ")
    if ($alternatePath -ne "") {
        $params += "$alternatePath$templateArg"
    }
    & "go" $params
    Exit
}

function Uninstall-GReadr {    
    $forced = $strArgs.Split(" ")[1] 

    if ($forced -ne "-force"){
        Write-Host "To Uninstall GReadr, add '--force'" -ForegroundColor Red   
        Write-Host "If you are Unhappy with GReadr" -ForegroundColor Cyan       
    }
}

if ($strArgs -eq "") {
    if (Confirm-File-Exists $terminalDir "\greadr.json") {
        Invoke-ReadmeTree
    }
    else {
        Write-Host "'greadr.json' not found." -ForegroundColor Red -NoNewline; Write-Host " Use template: " -NoNewline; Write-Host "greadr -t [templateType]" -ForegroundColor Green  
        Write-Host "Create with command: " -NoNewline; Write-Host "greadr --create-json" -ForegroundColor Green -BackgroundColor Black  
        Exit              
    }         
}

switch -regex ($strArgs) {
    ("^-t") {
        Invoke-ReadmeTree $templatePath
    }
    ("^--template") {
        Invoke-ReadmeTree $templatePath
    }
    "^--create-json" {
        Write-Json-File $terminalDir $strArgs.Split(" ")[1]
    }
    "^--create-files" {
        Write-Data-Files
    }
    "^--ignore-greadr" {
        Update-Git-Ignore
    }
    "^--get-templates" {
        & Get-ChildItem $templatePath
    }
    "^--setup" {
        Set-Setup
    }
    "^--remove-alias" {
        Remove-Item alias:greadr 2>&1

        Write-Host "Alias removed:" -NoNewline
        Write-Host " greadr"-ForegroundColor red
        Write-Host "Type: " -NoNewline
        Write-Host ".\greadr.ps1 --set-alias" -NoNewline -ForegroundColor Green
        Write-Host " to add it back"
    }
    "^--set-alias" {        
        Set-Greadr-Alias
        Write-Host "GReadr global alias set." -ForegroundColor Cyan -BackgroundColor Black
    }
    ("^-h") {
        Write-Help
    }
    ("^--help") {
        Write-Help
    }
    ("^-i") {
        Write-Info
    }
    ("^--info") {
        Write-Info
    }
    ("^--uninstall") {
        Uninstall-GReadr
    }
    default {        
        Write-Host "cmd not recognised. Ensure params start with " -ForegroundColor Red -NoNewline -BackgroundColor Black
        Write-Host "--"
        Write-Host "--help for listed commands" -ForegroundColor Cyan -BackgroundColor Black
    }
}
