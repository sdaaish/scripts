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
Install-WithWinGet -Package Microsoft.VisualStudioCode
# Download VSCode

Set-SBExplorer
Set-SBWTSettings|Out-Null
Set-SBWinGetSettings|Out-Null

& winget list --source winget --accept-source-agreements

$text = @"
Installation Done.

For information about installation, see ${transcript}.
"@

Set-Content -Path $(Join-Path ${env:USERPROFILE} "Desktop\done.txt") -Value $text
