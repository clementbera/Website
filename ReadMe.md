# Gem TD Website

## I am not a developer and I want to contribute

- Go talk on reddit/GemTD for suggestions & improvements. Multiple people have contributed (images, fall-back name list, etc.)

## I am a developer and I want to understand this non-sense

This repository includes scripts to generate html pages from GemTD source code. 

The execution flow is as follow:
- Parsing of GemTD files from vpk folders resource and scripts into a model
- Exportation of the model to pillar files (Markdown like syntax)
- Compilation of pillar files + theme to html files
- deployment of the html files

### I am on Mac & I want to make it work on my machine

Since I am on Mac, I put some Mac specific files to ease deployment from Mac.

1) Fork this repository & Clone master branch
2) Do any change you like. If yonjjhu want to update the website after a new GemTD release, copy the resource and scripts folders from the vpk to GemTD-Generation folder.
3) Run: bash generateSite "my commit message".

### I am not on Mac & I want to make it work on my machine

1) Fork this repository & Clone master branch
2) Do any change you like. If you want to update the website after a new GemTD release, copy the resource and scripts folders from the vpk to GemTD-Generation folder.
3) Download a Pharo VM, here is the command line I would use from Ubuntu:

wget -O- get.pharo.org/vmLatest | bash 

Here is an alternative version (no wget but curl):

curl get.pharo.org/vmLatest | bash 

Or, alternatively, directly go download a VM from http://files.pharo.org/vm/pharo-spur32/ 

4) Generate the pillar files with ./pharo Pharo.image eval 'GemTDGod new process'
5) Copy the generated files from GemTD-Generation/export to GemTD-Site
6) Cd to GemTD-Site
7) Run: 

../ecstatic generate 

to generate the html pages in GemTD-Site/_site

8) commit and push you stuff on github
9) copy the html files somewhere
10) Switch to gh-pages branch, paste the html files there, commit and push for deployment

### I want to contribute

Go talk on reddit/GemTD. In theory I would like to say PR are welcomed but since the code is mainly inside the Pharo image right now things are not suitable for PR. I would need to externalize code - but I am not going to spend time on this unless somebody ask something.


