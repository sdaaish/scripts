<#
.SYNOPSIS
Generates configuration for Windows Sandbox without networking.

.DESCRIPTION
Run this to create files to be able to start the installation process in Windows Sandbox.

.PARAMETER Foobar
Descriptions of parameter Foobar

.EXAMPLE
./genNoNetworkConf.ps1

.NOTES
Run a sandbox that maps files from the download folder. For checking out bad code as an example. Without networking
#>

$wsbName = "NoNetwork"

$scriptFolder = Split-Path -Path $PSScriptroot -Parent
$wsbFile = Join-Path -Path $scriptFolder -ChildPath "sandboxes\${wsbName}.wsb"
$downloadFolder = New-Item ~/Downloads -ItemType Directory -Force -ErrorAction Ignore
$scoopFolder = Convert-Path ~/scoop

# Generate the wsb-file to use to start the sandbox from Windows (outside).
$wsbContent = @"
<Configuration>
<VGpu>Default</VGpu>
<Networking>Disabled</Networking>
<MappedFolders>
   <MappedFolder>
<HostFolder>${downloadFolder}</HostFolder>
<ReadOnly>true</ReadOnly>
   </MappedFolder>
   <MappedFolder>
     <HostFolder>${scriptFolder}</HostFolder>
     <ReadOnly>true</ReadOnly>
   </MappedFolder>
   <MappedFolder>
<HostFolder>${scoopFolder}</HostFolder>
<ReadOnly>true</ReadOnly>
   </MappedFolder>
</MappedFolders>
<LogonCommand>
</LogonCommand>
</Configuration>
"@

Set-Content -Path $wsbFile -Value $wsbContent -Force

Write-Output "Generated Windows sandbox file in ${wsbFile}."
Write-Output "Start sandbox with `"& .\${wsbFile}`""
