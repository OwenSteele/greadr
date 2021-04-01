
$basedir=Split-Path $MyInvocation.MyCommand.Path -Parent
$basedir += "/greadr"
$strArgs = "$args"
function Set-Json-File{
    param (
        [string]$dir,
        [string]$jsonArgs
    )  

    $content = ""

    Write-Host "$jsonArgs"
    
    if($jsonArgs -eq "jupyter")
    { $content = '{"name":"README","ignore":{"folders":[],"fileTypes":["png","jpg","jpeg"],"partials":["---images","---.ipynb_checkpoints","-checkpoint.ipynb"],"fileNames":[]},"output":{"type":"md"},"format":{"doubleSpace":false,"ignoreEmpty":true}}' 
       }
    else{
         $content = '{"name":"README","ignore":{"folders":[],"fileTypes":[],"partials":[],"fileNames":[]},"output":{"type":"md"},"format":{"doubleSpace":false}}'
       }

    Set-Content $dir\greadr.json "$content"
    Write-Host "greadr.json created" -ForegroundColor Blue -BackgroundColor Black
}

function Get-Json-Exists {
    param (
        [string]$dir,
        [bool]$exit
    )
    if ((Test-Path "$dir/greadr.json"))
    { 
        return $true
    }
    else {  
        
        if($exit) {
            Write-Host "'greadr.json' not found." -ForegroundColor Red
            Write-Host "Create with command: " -NoNewline
            Write-Host "greadr --create-json" -ForegroundColor Green -BackgroundColor Black  
    
            Exit
        }
        else {return $false}
    }
}


if ($strArgs.StartsWith("--create-json")){
    Set-Json-File $basedir $strArgs.Split(" ")[1]
    Exit
}
elseif ($strArgs -eq "--setup") {
    
    Write-Host "Checking for go compiler " -NoNewline
    $goparams = "version".Split(" ")
    $goinstalled = & "go" $goparams 2>&1 | out-string
    # need to hide error for when not installed
    if($goinstalled.StartsWith("go") -eq $true)
    {
        Write-Host "installed" -ForegroundColor Green -BackgroundColor Black  
    }
    else {
        Write-Host "not found." -ForegroundColor Red -BackgroundColor Black
        Write-Host "greader requires go to run, install it here: " -NoNewline
        Write-Host "https://golang.org/doc/install" -ForegroundColor Yellow red -BackgroundColor Black    
    }
    Write-Host "Checking for local json config file " -NoNewline
    $result = Get-Json-Exists $basedir $false
    if($result -eq $true){
        Write-Host "file found" -ForegroundColor Green -NoNewline
        Write-Host " ('greadr --create-json' will overwrite this file)"
    }
    else {
        Write-Host "no file found" -ForegroundColor red -BackgroundColor Black
        Write-Host "Creating greadr.json file.. " -NoNewline
        Set-Json-File($basedir)    
    }
}
else{
    Get-Json-Exists $basedir $true

    Write-Host "$basedir/ReadmeTree.go"

    if ((Test-Path "$basedir/ReadmeTree.go")){}
    else{
        Write-Host "'ReadmeTree.go' not found." -ForegroundColor Red
        Write-Host "Ensure it is in the correct folder."

        Exit
    }

    Write-Host "Starting GReadr" -ForegroundColor black -BackgroundColor Green
    $params = "run .\greadr\ReadmeTree.go".Split(" ")
    & "go" $params
}
