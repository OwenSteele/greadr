# GReadr - Git Readme Builder

 **By Owen Steele 2021**

GReadr is designed to help map out and visual project repo directories, for both the makers and visitors!

#### GReader is built in Go and Powershell

*Sample product below:*

# GReadr Dir Tree

### Created with **greadr**(https://github.com/OwenSteele/greadr)
<pre>ROOT_FOLDER
<br>|   .gitattributes
<br>|   greadr.json
<br>|   greadr.ps1
<br>|   greadrsetup.exe
<br>|   \---greadr
<br>|       \---v16
<br>+---commands
<br>|   |   greadr-help.ps1
<br>|   |   greadr-info.ps1
<br>|   +---app
<br>|   |       remove-greadr-alias.ps1
<br>|   |       set-greadr-alias.ps1
<br>|   |       set-up-greadr.ps1
<br>|   |       uninstall-greadr.ps1
<br>|   +---common
<br>|   |       confirm-file-exists.ps1
<br>|   +---git
<br>|   |       update-git-ignore.ps1
<br>|   +---goCommands
<br>|   |       invoke-readme-tree.ps1
<br>|   \---output
<br>|           write-data-files.ps1
<br>|           write-json-files.ps1
<br>+---go
<br>|       ReadmeTree.go
<br>+---greadr
<br>|       after.md
<br>|       before.md
<br>\---templates
<br>        default.json
<br>        jupyter.json
<br>        text.json

</pre>

# Installing and Setup

### greadrsetup.exe

* Open the app and setup
	* Installs Go Lang Compiler if needed
	* Creates required config files
	* Adds GReadr to powershell profile

**The installer is large ~80MB**

use single branch clone to only clone the installer branch:
```
 > git clone https://github.com/OwenSteele/greadr --branch installer --single-branch
```
Clone **without** installer:
```
 > git clone https://github.com/OwenSteele/greadr --branch master --single-branch
```

### Manual installation

 Simply clone or download the Zip to any folder to get started.
* In powershell, navigate to the root folder and type:
<pre> > ./greadr.ps1 --setup </pre>
* **Go Lang compiler is required**, setup will help with it's installation
https://golang.org/doc/install
* **Once set up, greadr should be usable in any folder.**
<pre> > greadr --help</pre>

# Config

* GReadr uses a JSON file for configuration and options
* Templates can be used, which are saved in the greadr installation folder
* Custom config files can be created and edited:
<pre> > greadr --create-json [templateType]</pre>

**GReadr files can be added to your .gitignore:**
<pre> > greadr --ignore-greadr</pre>

#### Ignoring from the dir map

**Can omit:** 
* entire folders
* file type extensions (e.g. "*.exe")
* file names (including and excluding file extension)
* partial names (i.e. contains "x")


* GReadr files can be omitted from the map produced (on by default)
* Git files (.gitignore, .git/, LICENSE) can also be omitted (on by default)

#### Created files

Can set any name or file extension with Output

#### Formatting

* Can set the dir map title, that appears above the map
* Double Space files/folders in map (useful for small projects)
* Omit 'Empty' lines that contain no files or are new folder spacers

#### Data

* This determine text or content that will be included before and after the map
	* (This text now is in the 'after.md' file!)
* Can use a file or JSON value text, or even both as providers

**!PLEASE NOTE: there are required properties for custom config files:**
* **Output**, both 'name' and 'type' fields are required
* **Boolean types fields** should not be removed

# Issues

 **Powershell execution policy may need to be altered to run GReadr:**
<pre> > set-executionpolicy -executionpolicy unrestricted<br>OR<br> > powershell.exe -executionpolicy unrestricted -command ./greadr.ps1</pre>

## Planned Features
* Compile to .exe
* Making requirement of Go optional
* rewrite in bash, and for CMD
* add more config options in the JSON files