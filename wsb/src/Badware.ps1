# Powershell script to use _inside_ sandbox

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force

# Install scoop
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh') -ErrorAction Continue

# Install applications
$ScoopLog = Join-Path ${env:USERPROFILE} "\Desktop\Scoop.log"
$scoopApps = @(
    "windows-terminal"
    "vscode"
    "curl"
    "firefox"
    "networkminer"
    "wireshark"
    "mitmproxy"
)
scoop install git
scoop bucket add extras
$scoopApps| Foreach-Object {scoop install $_ *>> $ScoopLog}

# Install VSCode settings
reg import "${env:USERPROFILE}\scoop\apps\vscode\current\install-context.reg"

# Enable debug of SSL in Firefox, Chrome and Wireshark
# Create directory, set env variable
$SSLLogFile = Join-Path ${env:USERPROFILE} "Downloads\ssl\ssl.log"
New-Item -Path $(Split-Path $SSLLogFile -Parent) -Type Directory
[System.Environment]::SetEnvironmentVariable("SSLKEYLOGFILE",$SSLLogFile,"Machine")

# Install PS-modules
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name DNSClient-PS -Force

# Download NPcap driver
$npcapVersion = "1.55"
$npcapUrl = "https://nmap.org/npcap/dist/npcap-${npcapVersion}.exe"
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

& wt.exe

Set-Content -Path $(Join-Path ${env:USERPROFILE} "Desktop\done.txt") -Value "Installation Done"Set-Content -Path $(Join-Path ${env:USERPROFILE} "Desktop\done.txt") -Value "Installation Done"

