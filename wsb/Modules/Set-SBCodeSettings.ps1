# Module to customize Windows Terminal
Function Set-SBCodeSettings {

    $VsCodeHome = Join-Path ${env:Appdata} "\Code\User\"
    New-Item -Path $VsCodeHome -Type Directory -Force
    Copy-Item "${HOME}\Desktop\wsb\configs\VScode\settings.json" $VsCodeHome
}
