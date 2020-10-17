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

$scriptFolder = Split-Path -Path $PSScriptroot -Parent
$wsbFile = Join-Path -Path $PSScriptRoot -ChildPath "Badware.wsb"
$cmdFile = Join-Path -Path $PSScriptRoot -ChildPath "Badware.cmd"
$poshFile = Join-Path -Path $PSScriptRoot -ChildPath "Badware.ps1"
$sandboxFolder = New-Item ~/Downloads/Sandbox -ItemType Directory -Force -ErrorAction Ignore
$scoopFolder = Convert-Path ~/scoop

# Content of the cmd-file that are used _inside_ the Sandbox
$cmdContent = @"
@echo off

:: Settings for powershell
powershell -Command {Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser}
powershell -ExecutionPolicy ByPass -File C:\users\WDAGUtilityAccount\Desktop\Scripts\wsb\Badware.ps1
"@

# Content of Powershell script to use _inside_ sandbox
$poshContent = @"
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
scoop install git
scoop bucket add extras
scoop install vscode
reg import "C:\Users\WDAGUtilityAccount\scoop\apps\vscode\current\vscode-install-context.reg"
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
  <HostFolder>${scriptFolder}</HostFolder>
  <ReadOnly>true</ReadOnly>
 </MappedFolder>
 <MappedFolder>
  <HostFolder>${scoopFolder}</HostFolder>
  <ReadOnly>true</ReadOnly>
 </MappedFolder>
 </MappedFolders>
  <LogonCommand>
<Command>cmd.exe /c C:\users\WDAGUtilityAccount\Desktop\scripts\wsb\Badware.cmd</Command>
</LogonCommand>
</Configuration>
"@

Set-Content -Path $wsbFile -Value $wsbContent -Force
Set-Content -Path $cmdFile -Value $cmdContent -Force
Set-Content -Path $poshFile -Value $poshContent -Force

Write-Output "Generated Windows sandbox file in ${wsbFile}."
Write-Output "Start sandbox with `"& .\${wsbFile}.`""
