Function Set-SBWTSettings {

    New-Item -Name "Windows Terminal" -Path "${env:LOCALAPPDATA}\Microsoft\" -Type Directory
    Copy-Item "${HOME}\Desktop\wsb\src\settings.json" "${env:LOCALAppdata}\Microsoft\Windows Terminal\"
}
