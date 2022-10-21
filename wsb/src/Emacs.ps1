# Powershell script to use _inside_ sandbox
$transcript = Start-Transcript -IncludeInvocationHeader

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force

# Local settings
Import-Module ${env:UserProfile}\Desktop\wsb\Modules\Sandbox.psd1
Add-SBCertificate -Path ${env:UserProfile}\Desktop\wsb\certificates -Verbose

Install-WinGet

# Workaround for bug with WinGet
Install-WindowsTerminal

# Install packages
Install-WithWinGet -Package GNU.Emacs
Install-WithWinGet -Package Git.Git
Install-WithWinGet -Package Microsoft.PowerShell
Install-WithWinGet -Package Microsoft.GitCredentialManagerCore
Install-WithWinGet -Package GnuPG.GnuPG
#Install-WithWinGet -Package Microsoft.WindowsTerminal

# Add local installed programs to PATH
Add-SBPath $(Resolve-Path "C:\Program Files\Emacs\*\bin\")
Update-SBPath

# Setup HOME environment
[System.Environment]::SetEnvironmentVariable("HOME",${env:UserProfile},"User")
${env:HOME} = [System.Environment]::GetEnvironmentVariable("HOME","User")

# New local directories
New-Item -Path ${env:UserProfile} -Name .config -ItemType Directory | Out-Null
New-Item -Path ${env:UserProfile} -Name .cache -ItemType Directory | Out-Null
New-Item -Path ${env:UserProfile} -Name .local -ItemType Directory | Out-Null

# Change settings for git to get Non-GNU Elpa to work
git config --global --add http.sslbackend schannel
git config --global --add http.https://git.savannah.gnu.org.sslVerify false
git config --global --add http.https://git.savannah.gnu.org.sslbackend openssl
git config --global --add http.https://git.savannah.gnu.org.cookieFile ~/.cache/cookie.txt

# Clone emacs repositories
& git clone https://github.com/plexus/chemacs2.git ${env:UserProfile}/.emacs.d
& git clone https://github.com/SystemCrafters/crafted-emacs ${env:UserProfile}/.config/crafted-emacs

# Write chemacs profiles file
$chemacs = @"
(("crafted" . ((user-emacs-directory . "~/.config/crafted-emacs")
               (env . (("CRAFTED_EMACS_HOME" . "~/.config/crafted-config")))))
 ("nano" . ((user-emacs-directory . "~/.config/nano-emacs"))))
"@
$chemacsprofile = Join-Path ${env:UserProfile} ".emacs-profiles.el"
Set-Content -Path $chemacsprofile -Value $chemacs -Force
Set-Content -Path ${env:UserProfile}\.emacs-profile -Value "crafted"

# Copy an example of Crafted Emacs config to the custom config folder
$options = @{
    Path = "${env:UserProfile}\Desktop\wsb\configs\Emacs\crafted-config.org"
    Destination = "${env:UserProfile}\.config\crafted-config\config.org"
}
New-Item -Path ${env:UserProfile}\.config -Name crafted-config -ItemType Directory | Out-Null
Copy-Item @options

# Copy an example of Nano Emacs config to the startup config folder
$options = @{
    Path = "${env:UserProfile}\Desktop\wsb\configs\Emacs\nano-config.el"
    Destination = "${env:UserProfile}\.config\nano-emacs\init.el"
}
New-Item -Path ${env:UserProfile}\.config -Name nano-emacs -ItemType Directory | Out-Null
Copy-Item @options

# Tune Windows
Set-SBExplorer
Set-SBWTSettings|Out-Null
Set-SBWinGetSettings|Out-Null

& winget list --source winget --accept-source-agreements

$text = @"
Installation Done.

For information about installation, see ${transcript}.
"@

Set-Content -Path $(Join-Path ${env:UserProfile} "Desktop\done.txt") -Value $text
