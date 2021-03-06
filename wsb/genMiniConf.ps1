<#
.SYNOPSIS
Generates configuration for Windows Sandbox.

.DESCRIPTION
Run this to create files to be able to start the installation process in Windows Sandbox.

.PARAMETER Foobar
Descriptions of parameter Foobar

.EXAMPLE
./genMiniConf.ps1

.NOTES
Run a sandbox that maps files from the download folder. Minimal config.
#>

$scriptFolder = Split-Path -Path $PSScriptroot -Parent
$wsbFile = Join-Path -Path $PSScriptRoot -ChildPath "Mini.wsb"
$sandboxFolder = New-Item ~/Downloads -ItemType Directory -Force -ErrorAction Ignore

# Generate the wsb-file to use to start the sandbox from Windows (outside).
$wsbContent = @"
<Configuration>
<VGpu>Default</VGpu>
<Networking>Default</Networking>
<MappedFolders>
   <MappedFolder>
<HostFolder>${sandboxFolder}</HostFolder>
<ReadOnly>true</ReadOnly>
   </MappedFolder>
</MappedFolders>
<LogonCommand>
   <Command>powershell.exe -WindowStyle Normal</Command>
</LogonCommand>
</Configuration>
"@

Set-Content -Path $wsbFile -Value $wsbContent -Force

Write-Output "Generated Windows sandbox file in ${wsbFile}."
Write-Output "Start sandbox with `"& .\${wsbFile}.`""
