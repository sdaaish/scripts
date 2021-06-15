# Extracts scripts to this folder
$wsbfiles = Get-ChildItem -Path $PSScriptRoot -Filter gen*.ps1
$wsbfiles| Foreach-Object {
    & $_.FullName
}
