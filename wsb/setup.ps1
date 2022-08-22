# Extracts scripts to this folder
Get-ChildItem -Path $PSScriptRoot\src -Filter gen*.ps1 | Foreach-Object {
    & $_.FullName
    Write-Output ""
}
