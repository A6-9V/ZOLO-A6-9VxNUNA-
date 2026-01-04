@echo off
title ZOLO-A6-9VxNUNA Full Setup
color 0B
echo.
echo ========================================
echo   ZOLO-A6-9VxNUNA Full Setup
echo   Complete System Configuration
echo ========================================
echo.
echo Device: NuNa
echo OS: Windows 11 Home 25H2
echo.
echo This will configure:
echo   [1] Complete Device Setup (Windows configuration)
echo   [2] Workspace Setup (Directory structure)
echo   [3] Windows Auto Setup (Automated configuration)
echo   [4] Cloud Sync (OneDrive, Google Drive, Dropbox)
echo   [5] Git Setup (Repository configuration)
echo   [6] Security Setup (Security checks)
echo   [7] EXNESS Trading System (MetaTrader 5 ^& EAs)
echo   [8] VPS Services (Optional 24/7 trading)
echo.
echo Press Ctrl+C to cancel, or
pause
echo.
echo Requesting administrator privileges...
echo.
powershell.exe -ExecutionPolicy Bypass -NoExit -File "%~dp0full-setup.ps1"
