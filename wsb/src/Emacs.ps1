# Powershell script to use _inside_ sandbox
$transcript = Start-Transcript -IncludeInvocationHeader

# Add a notification that something is going on
Set-Content -Path $(Join-Path ${env:USERPROFILE} "Desktop\started.txt") -Value "Started installaion...."
& notepad.exe $(Join-Path ${env:USERPROFILE} "Desktop\started.txt")

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force

# Local settings
Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
Install-WinGet

# Workaround for bug with WinGet
Install-WindowsTerminal

# Install packages
Install-WithWinGet -Package GNU.Emacs
Install-WithWinGet -Package Git.Git
Install-WithWinGet -Package Microsoft.PowerShell
#Install-WithWinGet -Package Microsoft.WindowsTerminal

# Add local installed programs to PATH
$OldPath = $env:PATH
$NewPath = "C:\Program Files\git\bin;C:\Program Files\Emacs\x86_64\bin\;" + $OldPath
[System.Environment]::SetEnvironmentVariable("PATH",$NewPath,"Machine")

$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine")

# Clone emacs repositories
& git clone https://github.com/plexus/chemacs2.git $env:AppData/.emacs.d
#& git clone https://github.com/SystemCrafters/rational-emacs $env:AppData/rational-emacs
& git clone -b more-friendly-for-chemacs https://github.com/jeffbowman/rational-emacs.git $env:AppData/rational-test

# Write chemacs profiles file
$chemacs = @"
(("default" . ((user-emacs-directory . "~/rational-test"))))
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

Remove-Item $(Join-Path ${env:USERPROFILE} "Desktop\started.txt") -Force
Set-Content -Path $(Join-Path ${env:USERPROFILE} "Desktop\done.txt") -Value $text
