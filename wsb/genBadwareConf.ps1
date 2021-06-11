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
$sandboxFolderRW = New-Item ~/Downloads/SandboxRW -ItemType Directory -Force -ErrorAction Ignore
$scoopFolder = Convert-Path ~/scoop
$sandboxHome = "C:\Users\WDAGUtilityAccount"

# Content of the cmd-file that are used _inside_ the Sandbox
$cmdContent = @"
@echo off

:: Settings for powershell
powershell -Command {Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser}
powershell -ExecutionPolicy ByPass -File C:\users\WDAGUtilityAccount\Desktop\Scripts\wsb\Badware.ps1
"@

# Content of Powershell script to use _inside_ sandbox
$poshContent = @"
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
scoop install git
scoop bucket add extras
scoop install vscode
scoop install firefox
scoop install curl
reg import "${sandboxHome}\scoop\apps\vscode\current\vscode-install-context.reg"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name DNSClient-PS -Force
curl.exe -o ${sandboxHome}\Downloads\CyperChef.zip https://gchq.github.io/CyberChef/CyberChef_v9.28.0.zip
Expand-Archive ${sandboxHome}\Downloads\CyperChef.zip -DestinationPath ${sandboxHome}\Desktop\CyberChef
Remove-Item ${sandboxHome}\Downloads\CyperChef.zip -Force
Import-Module ${sandboxHome}\Desktop\scripts\wsb\Modules\My-Explorer.psm1
My-Explorer
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
<Command>cmd.exe /c C:\users\WDAGUtilityAccount\Desktop\scripts\wsb\Badware.cmd</Command>
</LogonCommand>
</Configuration>
"@

Set-Content -Path $wsbFile -Value $wsbContent -Encoding utf8 -Force
Set-Content -Path $cmdFile -Value $cmdContent -Encoding utf8 -Force
Set-Content -Path $poshFile -Value $poshContent -Encoding utf8  -Force

Write-Output "Generated Windows sandbox file in ${wsbFile}."
Write-Output "Start sandbox with `"& .\${wsbFile}.`""
