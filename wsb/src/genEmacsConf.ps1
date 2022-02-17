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

# Hostfolders
$scriptFolder = Convert-Path $PSScriptroot\..
$wsbFile = Join-Path -Path $ScriptFolder -ChildPath "sandboxes\Emacs.wsb"
$cmdFile = Join-Path -Path $ScriptFolder -ChildPath "build\Emacs.cmd"

# Guest folders
$guestHome = "C:\Users\WDAGUtilityAccount"
$guestCmdFile = Join-Path -Path $guestHome -ChildPath "Desktop\wsb\build\Emacs.cmd"
$guestPoshFile = Join-Path -Path $guestHome -ChildPath "Desktop\wsb\src\Emacs.ps1"

# Content of the cmd-file that are used _inside_ the Sandbox
$cmdContent = @"
@echo off

:: Settings for powershell
powershell -ExecutionPolicy ByPass -Command {Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser}
powershell -ExecutionPolicy ByPass -File $guestPoshFile
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
<Command>cmd.exe /c ${guestCmdFile}</Command>
</LogonCommand>
</Configuration>
"@

Set-Content -Path $wsbFile -Value $wsbContent -Encoding utf8 -NoNewLine -Force
Set-Content -Path $cmdFile -Value $cmdContent -Encoding utf8 -NoNewLine -Force

Write-Output "Generated Windows sandbox file in ${wsbFile}."
Write-Output "Start sandbox with `"& ${wsbFile}.`""
