<#
.SYNOPSIS
Generates configuration for Windows Sandbox.

.DESCRIPTION
Run this to create files to be able to start the installation process in Windows Sandbox.

.PARAMETER Foobar
Descriptions of parameter Foobar

.EXAMPLE
./gen-sandboxConf.ps1

.NOTES
Run a sandbox that maps files from the download folder. For checking out bad code as an example.
#>

# The name for the sandbox, can be changed.
$wsbName = "Badware"

# HostFolders
$scriptFolder = Split-Path $PSScriptroot -Parent
$wsbFile = Join-Path -Path $scriptFolder -ChildPath "sandboxes\${wsbName}.wsb"
$sandboxFolder = New-Item ${env:USERPROFILE}\Downloads\Sandbox -ItemType Directory -Force -ErrorAction Ignore
$sandboxFolderRW = New-Item ${env:USERPROFILE}\Downloads\SandboxRW -ItemType Directory -Force -ErrorAction Ignore
$scoopFolder = Join-Path -Path ${env:USERPROFILE} -ChildPath scoop

# Guest folders
$guestHome = "C:\Users\WDAGUtilityAccount"
$guestPoshFile = Join-Path -Path $guestHome -ChildPath "Desktop\wsb\src\${wsbName}.ps1"

# Autorun this _inside_ the Sandbox
$cmdContent = @"
Powershell Start-Process Powershell -WorkingDirectory $guestHome -WindowStyle Maximized -Argumentlist '-NoProfile -NoLogo -ExecutionPolicy Bypass -File $guestPoshFile'
"@

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
<MappedFolder>
<HostFolder>${sandboxFolderRW}</HostFolder>
<ReadOnly>false</ReadOnly>
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
<Command>${cmdContent}</Command>
</LogonCommand>
</Configuration>
"@

Set-Content -Path $wsbFile -Value $wsbContent -Encoding utf8 -NoNewLine -Force

Write-Output "Generated Windows sandbox file in ${wsbFile}."
Write-Output "Start sandbox with `"& ${wsbFile}`""
