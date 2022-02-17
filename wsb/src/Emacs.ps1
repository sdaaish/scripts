# Powershell script to use _inside_ sandbox
$transcript = Start-Transcript -IncludeInvocationHeader

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force

# Local settings
Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
Install-WinGet

# Workaround for bug with WinGet
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
$WinTerminal = "https://github.com/microsoft/terminal/releases/download/v1.12.10393.0/Microsoft.WindowsTerminal_1.12.10393.0_8wekyb3d8bbwe.msixbundle"
$Downloadfile = "terminal.msixbundle"
(New-Object System.Net.WebClient).DownloadFile($WinTerminal, $Downloadfile)
Add-AppxPackage $Downloadfile
Remove-Item $Downloadfile -Force

# Install packages
Install-WithWinGet -Package GNU.Emacs
Install-WithWinGet -Package Git.Git
Install-WithWinGet -Package Microsoft.PowerShell
#Install-WithWinGet -Package Microsoft.WindowsTerminal

$OldPath = $env:PATH
$NewPath = "C:\Program Files\git\bin;C:\Program Files\Emacs\x86_64\bin\;" + $OldPath
[System.Environment]::SetEnvironmentVariable("PATH",$NewPath,"Machine")

$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine")

& git clone https://github.com/plexus/chemacs2.git $env:AppData/.emacs.d
& git clone https://github.com/SystemCrafters/rational-emacs $env:AppData/rational-emacs

# Write chemacs profiles file
$chemacs = @"
(("default" . ((user-emacs-directory . "~/rational-emacs"))))
"@
$chemacsprofile = Join-Path $env:AppData ".emacs-profiles.el"

Set-Content -Path $chemacsprofile -Value $chemacs -Force

Set-SBExplorer
Set-SBWTSettings
Set-SBWinGetSettings

& winget list --accept-source-agreements

$text = @"
Installation Done.

For information about installation, see ${transcript}.
"@

Set-Content -Path $(Join-Path ${env:USERPROFILE} "Desktop\done.txt") -Value $text
