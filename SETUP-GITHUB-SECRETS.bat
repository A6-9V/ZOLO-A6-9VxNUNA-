@echo off
REM SETUP-GITHUB-SECRETS.bat
REM Wrapper script to set up GitHub repository secrets

echo ============================================
echo GitHub Secrets Setup
echo ============================================
echo.
echo This script will configure OAuth credentials
echo as GitHub repository secrets.
echo.
echo Repository: Mouy-leng/ZOLO-A6-9VxNUNA-
echo.
echo Prerequisites:
echo   - GitHub CLI (gh) installed
echo   - Authenticated with GitHub
echo.
pause

REM Run the PowerShell script
powershell.exe -ExecutionPolicy Bypass -File "%~dp0setup-github-secrets.ps1"

echo.
echo ============================================
echo.
pause
