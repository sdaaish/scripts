# Get WinGet for Windows
Function Install-WinGet {
    [cmdletbinding()]

    param(
    )

    $start_time = Get-Date

    # Winget
    $version = Invoke-RestMethod "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
    $winget = ($version.assets|
      Where-Object Name -eq "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle").browser_download_url
    $download = Join-Path $(Resolve-Path ~\Downloads) "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    (New-Object System.Net.WebClient).DownloadFile($winget, $download)

    # Dependency
    $vclibs ="https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
    $vclibsfile = Join-Path $(Resolve-Path ~\Downloads) "Microsoft.VCLibs.x64.14.00.Desktop.app"
    (New-Object System.Net.WebClient).DownloadFile($vclibs, $vclibsfile)

    Add-AppxPackage $vclibsfile
    Add-AppxPackage $download

    Remove-Item $vclibsfile -Force
    Remove-Item $download -Force

    $time = $((Get-Date).subtract($start_time).seconds)
    Write-Output "Downloaded WinGet in $time seconds"
}
