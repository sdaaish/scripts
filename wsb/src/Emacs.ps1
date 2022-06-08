# Powershell script to use _inside_ sandbox
$transcript = Start-Transcript -IncludeInvocationHeader

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force

# Local settings
Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
Add-SBCertificate -Path ${env:USERPROFILE}\Desktop\wsb\certificates -Verbose

Install-WinGet

# Workaround for bug with WinGet
Install-WindowsTerminal

# Install packages
Install-WithWinGet -Package GNU.Emacs
Install-WithWinGet -Package Git.Git
Install-WithWinGet -Package Microsoft.PowerShell
#Install-WithWinGet -Package Microsoft.WindowsTerminal

# Add local installed programs to PATH
$AddPath = @(
    [System.Environment]::GetEnvironmentVariable("PATH","Machine")
    "C:\Program Files\git\cmd\"
    (Get-ChildItem -Path "C:\Program Files\Emacs\*\bin\" -Directory).Fullname

)
$NewPath = $AddPath -join ";"
[System.Environment]::SetEnvironmentVariable("PATH",$NewPath,"Machine")

# Setup terminal path
$NewPath = @(
    [System.Environment]::GetEnvironmentVariable("PATH","Machine")
    [System.Environment]::GetEnvironmentVariable("PATH","User")
)
$env:PATH = $NewPath -join ";"

# Clone emacs repositories
& git clone https://github.com/plexus/chemacs2.git $env:AppData/.emacs.d
& git clone https://github.com/SystemCrafters/rational-emacs $env:AppData/rational-emacs

# Write chemacs profiles file
$chemacs = @"
(("default" . ((user-emacs-directory . "~/rational-emacs"))))
"@
$chemacsprofile = Join-Path $env:AppData ".emacs-profiles.el"

Set-Content -Path $chemacsprofile -Value $chemacs -Force

Set-SBExplorer
Set-SBWTSettings|Out-Null
Set-SBWinGetSettings|Out-Null

& winget list --source winget --accept-source-agreements

$text = @"
Installation Done.

For information about installation, see ${transcript}.
"@

Set-Content -Path $(Join-Path ${env:USERPROFILE} "Desktop\done.txt") -Value $text
