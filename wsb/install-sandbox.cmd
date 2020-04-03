@echo off

:: Settings for powershell
powershell -Command Set-ExecutionPolicy -ExecutionPolic RemoteSigned -Scope CurrentUser

:: Mount Sysinternals
net use S: \\live.sysinternals.com\tools

:: open the shared folder
explorer.exe C:\users\WDAGUtilityAccount\Desktop\Downloads
