Function Add-SBCertificate {
    [cmdletbinding()]
    param(
        $Path
    )

    Get-ChildItem -Path $Path -File -Filter *.cer | Foreach-Object {
        Write-verbose "Installing certificate: ${$_.FullName}"
        certutil -addstore Root $_.FullName
    }
}
