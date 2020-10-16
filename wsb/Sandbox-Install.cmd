@echo off

:: Settings for powershell
powershell -Command {Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser}
powershell -ExecutionPolicy ByPass -File C:\users\WDAGUtilityAccount\Desktop\Scripts\wsb\Sandbox-Install.ps1
