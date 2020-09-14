Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
scoop install git
scoop bucket add extras
scoop install vscode
reg import "C:\Users\WDAGUtilityAccount\scoop\apps\vscode\current\vscode-install-context.reg"

#if (Test-Path ~/Desktop/scoop){
#    New-item -Name scoop -Value ~\Desktop\scoop -Path ~ -ItemType SymbolicLink
#}
