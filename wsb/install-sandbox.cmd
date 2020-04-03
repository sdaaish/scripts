@echo off

:: Settings for powershell
powershell -Command Set-ExecutionPolicy -ExecutionPolic RemoteSigned -Scope CurrentUser
powershell -File C:\users\WDAGUtilityAccount\Desktop\Scripts\install-sandbox.ps1

:: open the shared folder
explorer.exe C:\users\WDAGUtilityAccount\Desktop\Downloads
