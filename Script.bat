@echo off
taskkill /f /im Microsoft.exe
del /f /q "%APPDATA%\Microsoft.exe"
powershell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"
del "%~f0"
