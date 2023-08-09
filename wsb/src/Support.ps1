# Content of Powershell script to use _inside_ sandbox

# Reference: https://github.com/jdhitsolutions/WindowsSandboxTools/blob/main/wsbScripts/demo-config.ps1

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

# Local settings
Loggit "Importing sandbox module."
Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
Loggit "Adding Proxy certificates."
Add-SBCertificate -Path ${env:USERPROFILE}\Desktop\wsb\certificates -Verbose

Loggit "Installing scoop."
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

Loggit "Add NuGet."
Install-PackageProvider -Name NuGet -Force -Forcebootstrap -Scope AllUsers
$null = Register-PackageSource -ProviderName NuGet -Name Nuget.org -Location https://www.nuget.org/api/v2
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Loggit "Install WinGet."
$null = Start-Job -Name "Winget" -ScriptBlock {
    Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
    Install-WinGet
}
Loggit "Waith for WinGet installation to finish."
Get-Job|Wait-Job

# Install-WindowsTerminal
Loggit "Installing software."
Loggit "Installing Git."
$null = Start-Job -Name "Install Git" -ScriptBlock {
    Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
    Install-WithWinGet -Package Git.Git
}
Loggit "Installing 7-Zip."
$null = Start-Job -Name "Install 7Zip" -ScriptBlock {
    Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
    Install-WithWinGet -Package 7zip.7zip
}
Loggit "Installing PowerShell."
$null = Start-Job -Name "Install PowerShell" -ScriptBlock {
    Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
    Install-WithWinGet -Package Microsoft.PowerShell
}
Loggit "Installing Visual Studio Code"
$null = Start-Job -Name "Install VS Code" -ScriptBlock {
    Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
    Install-WithWinGet -Package Microsoft.VisualStudioCode
}
Loggit "Installing Windows Terminal."
$null = Start-Job -Name "Install Windows Terminal" -ScriptBlock {
    Import-Module ${env:USERPROFILE}\Desktop\wsb\Modules\Sandbox.psd1
    Install-WithWinGet -Package Microsoft.WindowsTerminal
}

Loggit "Waiting for installation jobs to finish."
Get-Job|Wait-Job

foreach($job in (Get-Job)){
    $result = "{0} {1} {2:mm\:ss\.ff}" -f $job.name, $job.state,(New-TimeSpan -Start $job.PSBeginTime -End $job.PSEndTime)
    Loggit "$result"
}

Loggit "Updating PATH for software packages."
Add-SBPath -Path 'C:\Program Files\Git\cmd'
Add-SBPath -Path 'C:\Program Files\7-Zip\'
Update-SBPath

# Local settings
Loggit "Set custom settings for Explorer, Windows terminal and WinGet."
Set-SBExplorer
$null = Set-SBWTSettings
$null = Set-SBWinGetSettings

# Done, starting a new terminal
Loggit "Start Windows Terminal."
Start-Process wt.exe "-f new-tab -d ~ -p PowerShell"

Loggit "$transcript."
Stop-Transcript
Loggit "Script ended."
