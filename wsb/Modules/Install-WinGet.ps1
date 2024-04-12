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

    # Dependency of Microsoft.UI.Xaml
    [version]$version = "2.8.6"
    $verStr = "{0}.{1}" -f $version.major,$version.minor

    $xaml = "https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/{0}" -f ($version.ToString())
    $xamlfile = Join-Path $(Resolve-Path ~\Downloads) "Microsoft.UI.Xaml.${verStr}.zip"
    (New-Object System.Net.WebClient).DownloadFile($xaml, $xamlfile)
    Expand-Archive -Path $xamlfile -DestinationPath ~/Downloads/Microsoft.UI.Xaml.${verStr}
    Add-AppxPackage ~\Downloads\Microsoft.UI.Xaml.${verStr}\tools\AppX\x64\Release\Microsoft.UI.Xaml.${verStr}.appx

    Add-AppxPackage $vclibsfile
    Add-AppxPackage $download

    Remove-Item $vclibsfile -Force
    Remove-Item $download -Force
    Remove-Item $xamlfile -Force

    $time = $((Get-Date).subtract($start_time).seconds)
    Write-Verbose "Downloaded WinGet in $time seconds"
}
