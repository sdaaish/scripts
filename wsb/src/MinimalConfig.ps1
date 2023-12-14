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

$stop = Stop-Transcript
Loggit "${stop}."

# Display a toast
Loggit "Script ended."
