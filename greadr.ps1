
$basedir = Split-Path $MyInvocation.MyCommand.Path -Parent
$terminalDir = get-location
$strArgs = "$args"
$greadrCmds = "$PSScriptRoot\commands"
$templatePath = "$PSScriptRoot\templates\"

$goFileLoc = "$PSScriptRoot\go\"

$psHelp = "$greadrCmds\greadr-help.ps1"
$psInfo = "$greadrCmds\greadr-info.ps1"
$psAppRemoveAlias = "$greadrCmds\app\remove-greadr-alias.ps1"
$psAppSetAlias = "$greadrCmds\app\set-greadr-alias.ps1"
$psAppSetup = "$greadrCmds\app\set-up-greadr.ps1"
$psAppUninstall = "$greadrCmds\app\uninstall-greadr.ps1"
$psCommonFileExists = "$greadrCmds\common\confirm-file-exists.ps1"
$psGitUpdateIgnore = "$greadrCmds\git\update-git-ignore.ps1"
$psGoInvoke = "$greadrCmds\goCommands\invoke-readme-tree.ps1"
$psOutputJson = "$greadrCmds\output\write-json-files.ps1"
$psOutputData = "$greadrCmds\output\write-data-files.ps1"


if ($strArgs -eq "") {
    if (Invoke-Expression "$psCommonFileExists -dir $terminalDir -fileName \greadr.json") {
        Invoke-Expression "$psGoInvoke -alternatePath $terminalDir -x \greadr.json -f $psCommonFileExists -g $goFileLoc"
        Exit
    }
    else {
        Write-Host "'greadr.json' not found." -ForegroundColor Red -NoNewline;
        Write-Host " Use template: " -NoNewline; 
        Write-Host "greadr -t [templateType]" -ForegroundColor Green  
        Write-Host "Create with command: " -NoNewline; 
        Write-Host "greadr --create-json" -ForegroundColor Green -BackgroundColor Black  
        Exit              
    }         
}
try {  
switch -regex ($strArgs) {
    ("^-t") { 
        Invoke-Expression "$psGoInvoke -alternatePath $templatePath -x $strArgs -f $psCommonFileExists -g $goFileLoc"  
     }
    ("^--template") {
        Invoke-Expression "$psGoInvoke -alternatePath $templatePath -x $strArgs -f $psCommonFileExists -g $goFileLoc" 
    }
    "^--create-json" {      
        $strArgsOne = $strArgs.Split(" ")[1]
        if([string]::IsNullOrWhiteSpace($strArgsOne)) {
            Invoke-Expression "$psOutputJson -dir $terminalDir -u $psGitUpdateIgnore"
        }
        else {
            Invoke-Expression "$psOutputJson -dir $terminalDir -u $psGitUpdateIgnore -jsonArgs $strArgsOne"
        }
    }
    "^--create-files" {
        Invoke-Expression "$psOutputData -dir $terminalDir"
    }
    "^--ignore-greadr" {
        Invoke-Expression $psGitUpdateIgnore
    }
    "^--get-templates" {
        & Get-ChildItem $templatePath
    }
    "^--setup" {
        Invoke-Expression "$psAppSetup -dir $basedir -ga $psAppSetAlias -j $psOutputJson -u $psGitUpdateIgnore -f $psCommonFileExists -p $PSScriptRoot\greadr.ps1"
    }
    "^--remove-alias" {
        Invoke-Expression $psAppRemoveAlias
    }
    "^--set-alias" {    
        Invoke-Expression "$psAppSetAlias -p $PSScriptRoot\greadr.ps1"
    }
    ("^-h") {
        & $psHelp
    }
    ("^--help") {
        & $psHelp
    }
    ("^-i") {
        & $psInfo
    }
    ("^--info") {
        & $psInfo
    }
    ("^--uninstall") {
        Invoke-Expression "$psAppUninstall -isForced $strArgs"
    }
    default {        
        Write-Host "cmd not recognised. Ensure params start with " -ForegroundColor Red -NoNewline -BackgroundColor Black
        Write-Host "--"
        Write-Host "--help for listed commands" -ForegroundColor Cyan -BackgroundColor Black
    }
}
}
catch {
    Write-Host "Sorry an unhnandled error occurred. Please 'greadr -h/i' for help." -ForegroundColor Red -BackgroundColor Black
}
