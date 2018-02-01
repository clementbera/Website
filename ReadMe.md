# Gem TD Website

## I am not a developer and I want to contribute

- Go talk on reddit/GemTD for suggestions & improvements. Multiple people have contributed (images, fall-back name list, etc.)

## I am a developer and I want to understand this non-sense

This repository includes scripts to generate html pages from GemTD source code. The flow is as follow:
- Go to Master branch for generation
- Parsing of GemTD files from vpk folders resource and scripts into a model
- Exportation of the model to pillar files (Markdown like syntax)
- Compilation of pillar files + theme to html files
- deployment on gh-pages branch of the html files

### I am on Mac

Since I am on Mac, I put some Mac specific files to ease deployment form Mac.

1) Go to branch master
2) Copy from the game vpk the resource and scripts folder into GemTD-Generation folder in branch
3) Run: bash generateSite (Note: you may need to edit the git command inside to match your fork)
DONE.

### I am not on Mac

1) Go to Master branch
2) Copy the resource and scripts folders from the vpk to GemTD-Generation folder
3) Download a Pharo VM: 

wget -O- get.pharo.org/vmLatest | bash 

Note: you can use curl if you don't have wget installed, or directly go download a VM from http://files.pharo.org/vm/pharo-spur32/ 

4) Generate the pillar files with ./pharo Pharo.image eval 'GemTDGod new process'
5) Copy the generated files from GemTD-Generation/export to GemTD-Site
6) Cd to GemTD-Site
7) Run: 

../ecstatic generate 

to generate the html pages in GemTD-Site/_site

8) commit and push you stuff on github
9) copy the html files somewhere
10) Switch to gh-pages branch, paste the html files there, commit and push for deployment

PR are welcomed.


