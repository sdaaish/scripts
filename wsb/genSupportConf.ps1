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

$scriptFolder = Split-Path -Path $PSScriptroot -Parent
$wsbFile = Join-Path -Path $PSScriptRoot -ChildPath "Support.wsb"
$cmdFile = Join-Path -Path $PSScriptRoot -ChildPath "Support.cmd"
$poshFile = Join-Path -Path $PSScriptRoot -ChildPath "Support.ps1"
$sandboxFolder = New-Item ~/Downloads/Sandbox -ItemType Directory -Force -ErrorAction Ignore
$scoopFolder = Convert-Path ~/scoop
$sandboxHome = "C:\Users\WDAGUtilityAccount"

# Content of the cmd-file that are used _inside_ the Sandbox
$cmdContent = @"
@echo off

:: Settings for powershell
powershell -ExecutionPolicy ByPass -Command {Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser}
powershell -ExecutionPolicy ByPass -File C:\users\WDAGUtilityAccount\Desktop\Scripts\wsb\Support.ps1
"@

# Content of Powershell script to use _inside_ sandbox
$poshContent = @"
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
scoop install git
scoop bucket add extras
scoop install vscode
scoop install putty
scoop install googlechrome
scoop install windows-terminal
reg import "C:\Users\WDAGUtilityAccount\scoop\apps\vscode\current\vscode-install-context.reg"
Import-Module ${sandboxHome}\Desktop\scripts\wsb\Modules\My-Explorer.psm1
My-Explorer
"@

# Generate the wsb-file to use to start the sandbox from Windows (outside).
$wsbContent = @"
<Configuration>
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
<Command>cmd.exe /c C:\users\WDAGUtilityAccount\Desktop\scripts\wsb\Support.cmd</Command>
</LogonCommand>
</Configuration>
"@

Set-Content -Path $wsbFile -Value $wsbContent -Encoding utf8 -Force
Set-Content -Path $cmdFile -Value $cmdContent -Encoding utf8 -Force
Set-Content -Path $poshFile -Value $poshContent -Encoding utf8 -Force

Write-Output "Generated Windows sandbox file in ${wsbFile}."
Write-Output "Start sandbox with `"& .\${wsbFile}.`""
