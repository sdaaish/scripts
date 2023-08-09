# Powershell script to use _inside_ sandbox
$transcript = Start-Transcript -IncludeInvocationHeader
# Examples from https://github.com/jdhitsolutions/WindowsSandboxTools/blob/main/wsbScripts/demo-config.ps1
$logParams = @{
    Filepath = Join-Path (Resolve-Path "~/Desktop/") "setup.log"
    Append = $true
}

Function Write-SetupLog {
    param(
        [string[]]$Message
    )
    "{0} {1}" -f $(Get-Date -Format "s"), $($Message -join " ")|Tee-Object @logParams
}

New-Alias -Name Loggit -Value Write-SetupLog

# Main
Loggit "Starting $($MyInvocation.MyCommand)."
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force

# Local settings
Loggit "Import Sandbox module."
Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
Add-SBCertificate -Path ${env:USERPROFILE}\Desktop\wsb\certificates -Verbose


Loggit "Enabling PSRemoting"
Enable-PSRemoting -Force -SkipNetworkProfileCheck

Loggit "Install latest nuget package provider"
Install-PackageProvider -Name Nuget -Force -Forcebootstrap -Scope Allusers

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Loggit "Update PackageManagement and PowerShellGet modules"
Install-Module PackageManagement, PowerShellGet -Force

#run remaining commands in parallel background jobs
Loggit "Update help."
Start-Job -Name "Help-Update" -ScriptBlock { Update-Help -Force }

Loggit "Installing default modules."
Start-Job -Name "Module-Install" -ScriptBlock { Install-Module PSScriptTools, BurntToast -Force }

Loggit "Install Windows Terminal."
Start-Job -Name "Windows-Terminal" -ScriptBlock { Install-Module WTToolbox -Force ; Install-WTRelease }

#wait for everything to finish
Loggit "Waiting for jobs to finish."
Get-Job | Wait-Job

foreach ($job in (Get-Job)) {
    $result = "Job {0} {1} [{2:mm\:ss\.fff}]." -f $job.name, $job.state, (New-TimeSpan -Start $job.PSBeginTime -End $job.PSEndTime)
    Loggit "$result"
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

Start-Process winget -ArgumentList "list --source winget --accept-source-agreements"

Loggit "Starting Windows Terminal."
Start-Process wt.exe "-M new-tab -d C:\ -p Windows PowerShell"

$text = @"
Installation Done.

For information about installation, see ${transcript}.
"@

Set-Content -Path $(Join-Path ${env:UserProfile} "Desktop\done.txt") -Value $text

Loggit "Installation done."
