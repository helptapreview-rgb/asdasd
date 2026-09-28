@echo off
echo === PROCESS ===
tasklist | findstr /I "Microsoft.exe"
echo.
echo === FILE ===
if exist "%APPDATA%\Microsoft.exe" (
    echo FILE EXISTS: %APPDATA%\Microsoft.exe
) else (
    echo FILE NOT FOUND
)
pause
