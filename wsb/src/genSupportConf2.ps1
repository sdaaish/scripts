<#
.SYNOPSIS
Creates a new sandbox file.

.DESCRIPTION
Generates the WSB file with WindowsSandboxTools.
#>

#requires -modules WindowsSandboxTools

function New-SandboxFile {
    [CmdletBinding()]
    param (

    )

    process {
        $wsbName = "Support2"
        $Description = "Testing generation of new sandbox."
        $guestHome = "C:\Users\WDAGUtilityAccount"
        $guestPoshFile = Join-Path -Path $guestHome -ChildPath "Desktop\wsb\src\${wsbName}.ps1"

        if ([string]::IsNullOrWhiteSpace($env:Author)) {
            $Author = $env:UserName
        }
        else {
            $Author = $env:Author
        }

        $folder = @{
            HostFolder    = $PSScriptRoot
            SandboxFolder = "{0}\Desktop\wsb" -f $guestHome
            ReadOnly      = $false
        }
        $mfolder = @()
        $mfolder += New-WsbMappedFolder @folder

        $folder = @{
            HostFolder    = Join-Path -Path ${env:USERPROFILE} -ChildPath scoop
            SandboxFolder = "{0}\Desktop\scoop" -f $guestHome
            ReadOnly      = $false
        }
        $mfolder += New-WsbMappedFolder @folder

        $param = @{
            Name         = $wsbName
            LogonCommand = "Powershell Start-Process Powershell -WorkingDirectory ${guestHome} -WindowStyle Maximized -Argumentlist '-NoProfile -NoLogo -ExecutionPolicy Bypass -File ${guestPoshFile}'"
            MappedFolder = $mfolder
            Description  = $Description
            Author       = $Author
        }
        $wsb = New-WsbConfiguration @param

        $export = @{
            configuration = $wsb
            path          = "sandboxes\${wsbName}.wsb"
        }
        Export-WsbConfiguration @export
    }
}
New-SandboxFile
