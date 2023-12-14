# Content of Powershell script to use _inside_ sandbox

# Reference: https://github.com/jdhitsolutions/WindowsSandboxTools/blob/main/wsbScripts/demo-config.ps1

$StartTime = Get-Date
$transcript = Start-Transcript -IncludeInvocationHeader

# Enable logging
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

# Starting the installation
Loggit "Starting script $($MyInvocation.MyCommand)."
Loggit "${transcript}."

# Local settings
Loggit "Importing sandbox module."
Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
Loggit "Adding Proxy certificates."
Add-SBCertificate -Path ${env:USERPROFILE}\Desktop\wsb\certificates -Verbose

Loggit "Installing scoop."
(New-Object System.Net.WebClient).DownloadFile('https://get.scoop.sh','install.ps1')
.\install.ps1 -RunAsAdmin -NoProxy

Loggit "Add NuGet."
Install-PackageProvider -Name NuGet -Force -ForceBootstrap -Scope AllUsers
$null = Register-PackageSource -ProviderName NuGet -Name Nuget.org -Location https://www.nuget.org/api/v2
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Loggit "Installing WinGet."
Start-Job -Name "Install Winget" -ScriptBlock {
    Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
    Install-WinGet
}
Loggit "Wait for WinGet installation to finish."
Get-Job|Wait-Job|Format-Table Name,Command,State

# Install-WindowsTerminal
Loggit "Installing software:"
$packages = @(
    "Git.Git"
    "7zip.7zip"
    "Microsoft.PowerShell"
    "Microsoft.VisualStudioCode"
    "Microsoft.WindowsTerminal"
)
Loggit "$($packages -join('; '))"

$packages.foreach(
    {
        $pkg = $_
        Start-Job -Name "Install $pkg" -ScriptBlock {
            param($pkg)
            Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
            Install-WithWinGet -Package $pkg
        } -ArgumentList $pkg
    }
)

Loggit "Waiting for installation jobs to finish."
Get-Job|Wait-Job|Format-Table Name,Command, State

foreach($job in (Get-Job)){
    $result = "{0} {1} {2:hh\:mm\:ss\.ff}" -f $job.name, $job.state,(New-TimeSpan -Start $job.PSBeginTime -End $job.PSEndTime)
    Loggit "$result"
}

Loggit "Updating PATH for software packages."
Add-SBPath -Path 'C:\Program Files\Git\cmd'
Add-SBPath -Path 'C:\Program Files\7-Zip\'
Update-SBPath

Loggit "Install modules"
Start-Job -Name "Module-Install" -ScriptBlock { Install-Module PSScriptTools, BurntToast -Force }

Loggit "Waiting for installation of modules to finish."
Get-Job|Wait-Job|Format-Table Name,Command, State

# Local settings
Loggit "Set custom settings for Explorer, Windows terminal, WinGet and VS Code."
Set-SBExplorer
$null = Set-SBWTSettings
$null = Set-SBWinGetSettings
$null = Set-SBCodeSettings

# Done, starting a new terminal
Loggit "Start Windows Terminal."
Start-Process wt.exe "-f new-tab -d ~ -p PowerShell"

$stop = Stop-Transcript
Loggit "${stop}."

# Display a toast
$date = (Get-Date -Format s)
$timeTaken = ((Get-Date ) - $startTime)
$toastParams = @{
    Text = "Installation done at {1}, total time: {0:hh}:{0:mm}:{0:ss}" -f $timeTaken,$date
    Header = (New-BTHeader -Id 1 -Title "Setup Done")
}
Loggit "Display Toast"
New-BurntToastNotification @toastParams
Loggit "Script ended."
