<#
.SYNOPSIS
Generates configuration for Windows Sandbox.

.DESCRIPTION
Run this to create files to be able to start the installation process in Windows Sandbox.

.PARAMETER Foobar
Descriptions of parameter Foobar

.EXAMPLE
./gen-supportConf.ps1

.NOTES
Run a sandbox that maps files from the download folder. For checking out bad code as an example.
#>

# The name for the sandbox, can be changed.
$wsbName = "Emacs"

# Hostfolders
$scriptFolder = Split-Path $PSScriptroot -Parent
$wsbFile = Join-Path -Path $ScriptFolder -ChildPath "sandboxes\${wsbName}.wsb"

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
<MappedFolders>
<MappedFolder>
  <HostFolder>${scriptFolder}</HostFolder>
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
