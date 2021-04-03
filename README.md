# GReadr - Git Readme Builder

 **By Owen Steele 2021**

GReadr is designed to help map out and visual project repo directories, for both the makers and visitors!

#### GReader is built in Go and Powershell

*Sample product below:*
# Greadr sample

### Created with **greadr**
https://github.com/OwenSteele/greadr
<pre><br>C:.
<br>|   greadr.json
<br>|   greadr.ps1
<br>|   README.md
<br>+---greadr
<br>|       ReadmeTree.go
<br>\---templates
<br>        default.json
<br>        jupyter.json
<br>        text.json

</pre>
# Installing and Setup

 Simply clone or download the Zip to any folder to get started.
* In powershell, navigate to the root folder and type:
<pre> > ./greadr.ps1 --setup </pre>
* **Go Lang compiler is required**, setup will help with it's installation
https://golang.org/doc/install
* **Once set up, greadr should be usable in any folder.**
<pre> > greadr --help</pre>

 ## Issues

 **Powershell execution policy may need to be altered to run GReadr:**
<pre>set-executionpolicy -executionpolicy unrestricted<br>OR<br>powershell.exe -executionpolicy unrestricted -command ./greadr.ps1</pre>

 ## Planned Features
* Compile to .exe
* Making requirement of Go optional
* rewrite in bash, and for CMD
* add more config options in the JSON files