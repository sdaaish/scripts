# Extracts scripts to this folder
Get-ChildItem -Path $PSScriptRoot\src -Filter gen*.ps1 | Foreach-Object {
    Write-Host "Generating WSB configuration: $_"
    & $_
    Write-Host "Sandbox file in $PSScriptroot\sandboxes"
    [System.Environment]::NewLine
}
