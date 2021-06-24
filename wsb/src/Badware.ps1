# Powershell script to use _inside_ sandbox

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force

# Install scoop
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh') -ErrorAction Continue

# Install applications
scoop install git
scoop bucket add extras
scoop install vscode
scoop install firefox
scoop install curl
scoop install networkminer
scoop install wireshark
scoop install nmap
scoop install windows-terminal

# Install VSCode settings
reg import "${env:USERPROFILE}\scoop\apps\vscode\current\vscode-install-context.reg"

# Enable debug of SSL in Firefox, Chrome and Wireshark
$LogFile = Join-Path ${env:USERPROFILE} "Downloads\ssl\ssl.log"
[System.Environment]::SetEnvironmentVariable("SSLKEYLOGFILE",$LogFile,"USER")

# Install PS-modules
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name DNSClient-PS -Force

# Install CyberChef
curl.exe -o ${env:USERPROFILE}\Downloads\CyperChef.zip https://gchq.github.io/CyberChef/CyberChef_v9.28.0.zip
Expand-Archive ${env:USERPROFILE}\Downloads\CyperChef.zip -DestinationPath ${env:USERPROFILE}\Desktop\CyberChef
Remove-Item ${env:USERPROFILE}\Downloads\CyperChef.zip -Force

# Local settings
Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
Set-SBExplorer
Set-SBWTSettings

wt.exe
