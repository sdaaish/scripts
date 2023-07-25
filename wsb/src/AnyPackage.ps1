# Powershell script to use _inside_ sandbox
$transcript = Start-Transcript -IncludeInvocationHeader
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force

# Local settings
Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
Add-SBCertificate -Path ${env:USERPROFILE}\Desktop\wsb\certificates -Verbose

# Examples from https://github.com/jdhitsolutions/WindowsSandboxTools/blob/main/wsbScripts/demo-config.ps1
$logParams = @{
    Filepath = "C:\log\setup.txt"
    Append   = $True
}

"[$(Get-Date)] Starting $($MyInvocation.MyCommand)" | Out-File @logParams

"[$(Get-Date)] Enabling PSRemoting" | Out-File @logParams
Enable-PSRemoting -Force -SkipNetworkProfileCheck

"[$(Get-Date)] Install latest nuget package provider" | Out-File @logParams
Install-PackageProvider -name nuget -force -forcebootstrap -scope allusers

"[$(Get-Date)] Update PackageManagement and PowerShellGet modules" | Out-File @logParams
Install-Module PackageManagement, PowerShellGet -Force

#run remaining commands in parallel background jobs
"[$(Get-Date)] Update help" | Out-File @logParams
Start-Job -Name "Help-Update" -ScriptBlock { Update-Help -Force }

"[$(Get-Date)] Installing default modules" | Out-File @logParams
Start-Job -Name "Module-Install" -ScriptBlock { Install-Module PSScriptTools, BurntToast -Force }

"[$(Get-Date)] Install Windows Terminal" | Out-File @logParams
Start-Job -Name "Windows-Terminal" -ScriptBlock { Install-Module WTToolbox -Force ; Install-WTRelease }

#wait for everything to finish
"[$(Get-Date)] Waiting for jobs to finish" | Out-File @logParams
Get-Job | Wait-Job

foreach ($job in (Get-Job)) {
    $result = "Job {0} {1} [{2}]" -f $job.name, $job.state, (New-TimeSpan -Start $job.PSBeginTime -End $job.PSEndTime)
    "[$(Get-Date)] $result" | Out-File @logParams
}

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

"[$(Get-Date)] Starting Windows Terminal" | Out-File @logParams
Start-Process wt.exe "-M new-tab -d C:\ -p Windows PowerShell"

$text = @"
Installation Done.

For information about installation, see ${transcript}.
"@

Set-Content -Path $(Join-Path ${env:UserProfile} "Desktop\done.txt") -Value $text
