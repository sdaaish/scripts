Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

New-Item -Path "C:\Program Files\WindowsPowershell\Modules" -Type Directory -Force
Copy-Item .\Desktop\Modules\PackageManagement\*\* "$env:programfiles\WindowsPowershell\Modules\Packagemanagement\" -Recurse -Force -ErrorAction Ignore
Copy-Item .\Desktop\Modules\PowerShellGet\*\* "$env:programfiles\WindowsPowershell\Modules\PowerShellget\" -Recurse -Force -ErrorAction Ignore
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ForceBootStrap
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Install-Module PowerShellGet -Force
Install-Module BuildHelpers -Force
Import-Module .\Desktop\repos\MyModule\MyModule\MyModule.psd1

