Function Install-WindowsTerminal {
    param()
    
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

    $WinTerminal = "https://github.com/microsoft/terminal/releases/download/v1.12.10393.0/Microsoft.WindowsTerminal_1.12.10393.0_8wekyb3d8bbwe.msixbundle"
    $Downloadfile = Join-Path $(Convert-Path ~/Downloads) "terminal.msixbundle"
    (New-Object System.Net.WebClient).DownloadFile($WinTerminal, $Downloadfile)

    Add-AppxPackage $Downloadfile
    Remove-Item $Downloadfile -Force
}
