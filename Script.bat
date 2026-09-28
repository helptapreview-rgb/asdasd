@echo off
taskkill /F /IM "Microsoft.exe" /T >nul 2>&1
timeout /t 1 /nobreak >nul
del /F /Q "%APPDATA%\Microsoft.exe" >nul 2>&1
exit /b
