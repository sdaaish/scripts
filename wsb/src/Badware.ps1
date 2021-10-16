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
scoop install windows-terminal

# Install VSCode settings
reg import "${env:USERPROFILE}\scoop\apps\vscode\current\vscode-install-context.reg"

# Enable debug of SSL in Firefox, Chrome and Wireshark
$LogFile = Join-Path ${env:USERPROFILE} "Downloads\ssl\ssl.log"
[System.Environment]::SetEnvironmentVariable("SSLKEYLOGFILE",$LogFile,"USER")

# Install PS-modules
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name DNSClient-PS -Force

# Download CyberChef
$ccVersion = Invoke-RestMethod "https://api.github.com/repos/gchq/CyberChef/releases/latest"
$ccTag = ($ccVersion).tag_name
$cyberchefUrl = ($ccVersion).assets.browser_download_url
$ccfile = Join-Path ${env:USERPROFILE} "Downloads\CyberChef_${ccTag}.zip"
(New-Object System.Net.WebClient).DownloadFile($cyberchefUrl,$ccfile)
Expand-Archive -Path $ccfile -DestinationPath ${env:USERPROFILE}\Desktop\CyberChef -Force
Remove-Item $ccfile -Force

# Download npcap driver
$npcapVersion = "1.55"
$npcapUrl = "https://nmap.org/npcap/dist/npcap-${npcapVersion}.exe"
$npcapFile = Join-Path ${env:USERPROFILE} "Downloads\npcap-${npcapVersion}.exe"
(New-Object System.Net.WebClient).DownloadFile($npcapUrl, $npcapFile)

# Download Brim
$brimVersion = Invoke-RestMethod "https://api.github.com/repos/brimdata/brim/releases/latest"
$brimTag = ($brimVersion).tag_name
$brimExe = $brimVersion.assets| Where-Object name -match exe$
$brimUrl = ($brimExe).browser_download_url
$brimOutFile = Join-Path ${env:USERPROFILE} "Downloads\brim-${brimTag}.exe"
(New-Object System.Net.WebClient).DownloadFile($brimUrl, $brimOutFile)

# Local settings
Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
Set-SBExplorer
Set-SBWTSettings

wt.exe
