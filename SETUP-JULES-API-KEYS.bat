@echo off
REM Jules API Keys Setup - Windows Launcher
REM This script runs the PowerShell setup script with elevated privileges

echo.
echo ================================================================
echo     Jules API Keys - GitHub Secrets Setup
echo ================================================================
echo.

REM Check if PowerShell is available
where powershell >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: PowerShell is not installed or not in PATH
    echo Please install PowerShell and try again.
    pause
    exit /b 1
)

echo Running setup script with PowerShell...
echo.

REM Run PowerShell script
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-jules-api-keys.ps1"

echo.
echo ================================================================
echo.

pause
