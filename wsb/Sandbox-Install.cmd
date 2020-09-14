@echo off

:: Settings for powershell
powershell -Command Set-ExecutionPolicy -ExecutionPolic RemoteSigned -Scope CurrentUser
powershell -File C:\users\WDAGUtilityAccount\Desktop\Scripts\wsb\Sandbox-Install.ps1
