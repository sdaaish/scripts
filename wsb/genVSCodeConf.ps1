<#
.SYNOPSIS
Generates configuration for Windows Sandbox.

.DESCRIPTION
Run this to create files to be able to start the installation process in Windows Sandbox.

.PARAMETER Foobar
Descriptions of parameter Foobar

.EXAMPLE
./genVSCodeConf.ps1

.NOTES
Run a sandbox that maps files from the download folder. Installs VSCode.
#>

$scriptFolder = Split-Path -Path $PSScriptroot -Parent
$wsbFile = Join-Path -Path $PSScriptRoot -ChildPath "VSCode.wsb"
$cmdFile = Join-Path -Path $PSScriptRoot -ChildPath "VSCode.cmd"
$sandboxFolder = New-Item ~/Downloads/Sandbox -ItemType Directory -Force -ErrorAction Ignore
$scoopFolder = Convert-Path ~/scoop

# Content of the cmd-file that are used _inside_ the Sandbox
$cmdContent = @"
@echo off
:: Download VSCode

curl -L "https://update.code.visualstudio.com/latest/win32-x64-user/stable" --output C:\users\WDAGUtilityAccount\Desktop\vscode.exe

REM Install and run VSCode
C:\users\WDAGUtilityAccount\Desktop\vscode.exe /verysilent /suppressmsgboxes
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
<ReadOnly>false</ReadOnly>
   </MappedFolder>
</MappedFolders>
<LogonCommand>
   <Command>C:\users\wdagutilityaccount\desktop\scripts\wsb\VSCode.cmd</Command>
</LogonCommand>
</Configuration>
"@

Set-Content -Path $wsbFile -Value $wsbContent -Force
Set-Content -Path $cmdFile -Value $cmdContent -Force

Write-Output "Generated Windows sandbox file in ${wsbFile}."
Write-Output "Start sandbox with `"& .\${wsbFile}.`""
