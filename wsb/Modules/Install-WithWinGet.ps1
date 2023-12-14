# Install package with WinGet
Function Install-WithWinGet {
    [cmdletbinding()]

    param(
        [string]$Package
    )

    $start_time = Get-Date

    if (-not (Test-Path (Join-Path $env:UserProfile Desktop\Logs))) {
        New-Item -Path (Join-Path $env:UserProfile Desktop) -Name Logs -ItemType Directory -Force
    }

    $logfile = Join-Path $env:UserProfile Desktop\Logs\${Package}.log

    # Winget
    $options = @(
        "--id", $Package
        "--exact"
        "--source", "winget"
        "--accept-package-agreements"
        "--accept-source-agreements"
        "--log", $logfile
    )

    & winget install @options

    $time = $((Get-Date).subtract($start_time).seconds)
    Write-Verbose "Installed $Package in $time seconds"
}
