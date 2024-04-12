Function Install-WindowsTerminal {
    [cmdletbinding()]
    param()

    # Get the latest version MSIX bundle
    $latest = Invoke-RestMethod "https://api.github.com/repos/microsoft/terminal/releases/latest"
    $assets = Invoke-RestMethod $latest.assets_url
    $downloadUri = ($assets | Where-Object name -Match msixbundle$).browser_download_url

    $downloadFile = Join-Path $(Convert-Path ~/Downloads) "terminal.msixbundle"
    (New-Object System.Net.WebClient).DownloadFile($downloadUri, $downloadFile)

    Add-AppxPackage $downloadFile
    Remove-Item $downloadFile -Force
}
