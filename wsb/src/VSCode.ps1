# Download VSCode

$prog = "C:\users\WDAGUtilityAccount\Desktop\vscode.exe"

curl -L "https://update.code.visualstudio.com/latest/win32-x64-user/stable" --output $prog

# Install and run VSCode
& $prog /verysilent /suppressmsgboxes
