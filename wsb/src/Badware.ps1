# Powershell script to use _inside_ sandbox
$transcript = Start-Transcript -IncludeInvocationHeader

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force

# Local settings
Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
Add-SBCertificate -Path ${env:USERPROFILE}\Desktop\wsb\certificates -Verbose

# Use WinGet as main installer.
Install-WinGet

# Install packages
Install-WithWinGet -Package Git.Git
Install-WithWinGet -Package 7zip.7zip
Install-WithWinGet -Package Microsoft.PowerShell
Install-WithWinGet -Package Microsoft.GitCredentialManagerCore

Add-SBPath -Path 'C:\Program Files\Git\cmd'
Add-SBPath -Path 'C:\Program Files\7-Zip\'
Update-SBPath

# Install scoop
(New-Object System.Net.WebClient).DownloadFile('https://get.scoop.sh','install.ps1')
.\install.ps1 -RunAsAdmin -NoProxy

# Install applications
$ScoopLog = Join-Path ${env:USERPROFILE} "\Desktop\Scoop.log"
$scoopApps = @(
    "networkminer"
)
scoop bucket add extras
$scoopApps| Foreach-Object {scoop install $_ *>> $ScoopLog}

# Enable debug of SSL in Firefox, Chrome and Wireshark
# Create directory, set env variable
$SSLLogFile = Join-Path ${env:USERPROFILE} "Downloads\ssl\ssl.log"
New-Item -Path $(Split-Path $SSLLogFile -Parent) -Type Directory | Out-Null
[System.Environment]::SetEnvironmentVariable("SSLKEYLOGFILE",$SSLLogFile,"Machine")

# Install PS-modules
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ForceBootstrap
Install-Module -Name DNSClient-PS -Force
Save-Module -Name PSReadLine -Path 'C:\Program Files\WindowsPowerShell\Modules\' -Force

# Download NPcap driver
$npcapVersion = "1.71"
$npcapUrl = "https://npcap.com/dist/npcap-${npcapVersion}.exe"
$npcapFile = Join-Path ${env:USERPROFILE} "Downloads\npcap-${npcapVersion}.exe"
(New-Object System.Net.WebClient).DownloadFile($npcapUrl, $npcapFile)

# Download CyberChef
$ccVersion = Invoke-RestMethod "https://api.github.com/repos/gchq/CyberChef/releases/latest"
$ccTag = ($ccVersion).tag_name
$cyberchefUrl = ($ccVersion).assets.browser_download_url
$ccfile = Join-Path ${env:USERPROFILE} "Downloads\CyberChef_${ccTag}.zip"
(New-Object System.Net.WebClient).DownloadFile($cyberchefUrl,$ccfile)
Expand-Archive -Path $ccfile -DestinationPath ${env:USERPROFILE}\Desktop\CyberChef -Force
Remove-Item $ccfile -Force

# Install more packages late to improve UX
Install-WithWinGet -Package Microsoft.WindowsTerminal
Install-WithWinGet -Package Microsoft.VisualStudioCode
Install-WithWinGet -Package Mozilla.Firefox
Install-WithWinGet -Package WiresharkFoundation.Wireshark
Install-WithWinGet -Package mitmproxy.mitmproxy
Install-WithWinGet -Package brimdata.brim

Add-SBPath -Path 'C:\Program Files\Wireshark\'
Add-SBPath -Path 'C:\Program Files (x86)\mitmproxy\bin'
Update-SBPath

# Local settings
Set-SBExplorer
Set-SBWTSettings
Set-SBProfile

# Local configs
Copy-Item -Path ${env:USERPROFILE}\Desktop\wsb\configs\WireShark -Destination ${env:AppData} -Recurse -Force

# Start a terminal
& wt.exe

Set-Content -Path $(Join-Path ${env:USERPROFILE} "Desktop\done.txt") -Value "Installation Done"
