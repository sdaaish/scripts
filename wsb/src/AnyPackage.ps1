# Powershell script to use _inside_ sandbox
$transcript = Start-Transcript -IncludeInvocationHeader

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force

# Local settings
Import-Module ${env:UserProfile}\Desktop\wsb\Modules\Sandbox.psd1
Add-SBCertificate -Path ${env:UserProfile}\Desktop\wsb\certificates -Verbose

# Use AnyPackage and PSResourceGet
Install-Module -Name Microsoft.PowerShell.PSResourceGet -AllowPrerelease
Install-PSResource AnyPackage
Install-PSResource AnyPackage.Scoop
Install-PSResource AnyPackage.WinGet

# New local directories
New-Item -Path ${env:UserProfile} -Name .config -ItemType Directory | Out-Null
New-Item -Path ${env:UserProfile} -Name .cache -ItemType Directory | Out-Null
New-Item -Path ${env:UserProfile} -Name .local -ItemType Directory | Out-Null

# Tune Windows
Set-SBExplorer
Set-SBWTSettings|Out-Null
Set-SBWinGetSettings|Out-Null

& winget list --source winget --accept-source-agreements

$text = @"
Installation Done.

For information about installation, see ${transcript}.
"@

Set-Content -Path $(Join-Path ${env:UserProfile} "Desktop\done.txt") -Value $text
