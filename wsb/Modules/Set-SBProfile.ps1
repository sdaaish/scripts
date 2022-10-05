Function Set-SBProfile {

    $file = $Profile.CurrentUserCurrentHost
    New-Item $file -Force| Out-Null

    $uri = "https://raw.githubusercontent.com/sdaaish/boot/master/profile.ps1"
    (Invoke-WebRequest -Uri $uri -UseBasicParsing).Content|Out-File $file
}
