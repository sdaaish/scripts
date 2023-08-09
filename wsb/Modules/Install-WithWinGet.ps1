# Install package with WinGet
Function Install-WithWinGet {
    [cmdletbinding()]

    param(
        [string]$Package
    )

    $start_time = Get-Date

    # Winget
    $options = @(
        "--id", $Package
        "--exact"
        "--source", "winget"
        "--accept-package-agreements"
        "--accept-source-agreements"
    )

    & winget install @options
    
    $time = $((Get-Date).subtract($start_time).seconds)
    Write-Verbose "Installed $Package in $time seconds"
}
