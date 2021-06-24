# Content of Powershell script to use _inside_ sandbox

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

scoop install git
scoop bucket add extras
scoop install vscode
scoop install putty
scoop install googlechrome
scoop install windows-terminal

reg import "C:\Users\WDAGUtilityAccount\scoop\apps\vscode\current\vscode-install-context.reg"

# Local settings
Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
Set-SBExplorer
Set-SBWTSettings

wt.exe

