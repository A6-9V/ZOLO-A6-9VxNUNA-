@echo off
REM Quick launcher for automated git workflow
REM Powered by @copilot @jules @cursor
REM Note: Runs without automatic elevation (follows least-privilege security best practices)

echo ========================================
echo   Automated Git Workflow Launcher
echo   Copilot/Jules/Cursor Integration
echo ========================================
echo.

echo [INFO] Starting automated git workflow...
echo.

REM Run the PowerShell script
powershell -ExecutionPolicy Bypass -File "%~dp0auto-git-workflow.ps1" -Action auto

echo.
echo ========================================
echo   Workflow Complete!
echo ========================================
echo.

pause
