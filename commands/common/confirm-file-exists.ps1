param (
    [string]$dir,
    [string]$fileName
)

if ($dir -eq "") {
    $dir = "$dir\templates\"
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