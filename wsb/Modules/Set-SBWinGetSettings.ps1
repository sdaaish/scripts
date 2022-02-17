Function Set-SBWinGetSettings {

    $WinGetHome = Join-Path ${env:LOCALAPPDATA} "Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\"

    $WinGetContent = @"
{
    // For documentation on these settings, see: https://aka.ms/winget-settingsdir
    // "source": {
        //    "autoUpdateIntervalInMinutes": 5
        // }
    "visual": {
        "progressBar": "rainbow"
    },
    "experimentalFeatures": {
        "experimentalMSStore": true,
        "list": true,
        "upgrade": true,
        "uninstall": true
    },
}
"@

    New-Item -Path $WinGetHome -Type Directory -Force
    Set-Content -Path $(Join-Path $WinGetHome "settings.json") -Value $WinGetContent
}
