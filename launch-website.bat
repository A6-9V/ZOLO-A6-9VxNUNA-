@echo off
REM ZOLO-A6-9VxNUNA Website Launcher
REM Double-click this file to launch the website locally

title ZOLO-A6-9VxNUNA Website Launcher

REM Navigate to script directory
cd /d "%~dp0"

echo.
echo ╔════════════════════════════════════════════════════════╗
echo ║      ZOLO-A6-9VxNUNA Website Launcher                 ║
echo ╚════════════════════════════════════════════════════════╝
echo.
echo Starting local development server...
echo.

REM Run PowerShell script with RemoteSigned policy (more secure)
powershell.exe -ExecutionPolicy RemoteSigned -NoProfile -File "%~dp0launch-website.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ Failed to launch website
    echo.
    pause
)
