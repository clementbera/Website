# Gem TD Website

## I am not a developer and I want to contribute

- Get me a folder with pictures for creeps, the name of the png file should be the "code" from the website (gemtd_kuangbaoyezhu for Frenzied pig for example), I'll add pictures to the creep page. Get a link to download the folder.
- Get me a diamond picture that I don't have compatible for base towers page
- Anything that could improve the site is welcomed.

Contact me either on github or on Gem TD reddit

## I am a developer and I want to understand this non-sense

To generate:
1) Cd to GemTD-Generation folder
2) Copy the resource and scripts folders from the vpk to GemTD-Generation folder
3) Remove files in GemTD-Generation/export
4) Generate the files with ./pharo Pharo.image eval 'GemTD-Generation folder'
Note: default repo has the Mac runtime, you need to download other runtime from other OS. I could set-up things if someone request.
Also, you need to be in GemTD-Generation folder.
5) Copy the generated files in GemTD-Generation/export to GemTD-Site
6) Cd to GemTD-Site
7) Run ../ecstatic generate to generate the html pages in GemTD-Site/_site
8) Double click on html pages generated to see the result.

PR are welcomed.


