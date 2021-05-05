Write-Host "`nThank you for using Git Readme Builder - GReadr v1.1! By Owen Steele (c) 2021" -ForegroundColor Yellow -BackgroundColor Black
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
Write-Host "    [j], [jupyter]" -NoNewline -ForegroundColor Green -BackgroundColor Black; Write-Host " to create your config file from a template, can use ANY template (see -templaet below)"
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