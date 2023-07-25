# Module to customize Windows Terminal
Function Set-SBWTSettings {

    $WinTerminalHome = Join-Path ${env:LocalAppdata} "\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

    New-Item -Path $WinTerminalHome -Type Directory -Force
    Copy-Item "${HOME}\Desktop\wsb\configs\WindowsTerminal\settings.json" $WinTerminalHome
}
