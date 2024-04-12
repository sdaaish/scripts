# Extracts scripts to this folder
Get-ChildItem -Path $PSScriptRoot\src -Filter gen*.ps1 | ForEach-Object {
    $configFile = $_
    Write-Host "Generating WSB configuration from: $configFile"
    & $configFile
    Write-Host "Sandbox file in $PSScriptroot\sandboxes"

    Write-Host "Start with:"
    $name = "& {0}\{1}.wsb" -f $configFile.directory, ($configFile.basename -replace "gen", "" -replace "(conf|config)", "" )
    Write-Host $name -ForegroundColor Green

    [System.Environment]::NewLine
}
