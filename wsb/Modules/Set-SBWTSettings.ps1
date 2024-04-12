# Module to customize Windows Terminal
Function Set-SBWTSettings {

    $WinTerminalHome = Join-Path ${env:LocalAppdata} "\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

    New-Item -Path $WinTerminalHome -Type Directory -Force
    Copy-Item "${HOME}\Desktop\wsb\configs\WindowsTerminal\settings.json" $WinTerminalHome

    # Use Windows Terminal as default
    $key = 'HKCU:\Console\%%Startup'
    Set-ItemProperty $key "DelegationTerminal" "{E12CFF52-A866-4C77-9A90-F570A7AA2C6B}"
    Set-ItemProperty $key "DelegationConsole" "{2EACA947-7F5F-4CFA-BA87-8F7FBEEFBE69}"
}
