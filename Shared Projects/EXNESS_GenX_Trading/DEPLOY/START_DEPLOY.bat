@echo off
echo ================================================================
echo   EXNESS GenX Trader - VPS Deployment
echo ================================================================
echo.

REM Get script directory
set "SCRIPT_DIR=%~dp0"
set "DEPLOY_DIR=%SCRIPT_DIR%deployment_package"

echo Opening deployment package folder...
echo.
echo Location: %DEPLOY_DIR%
echo.
echo FILES READY FOR DEPLOYMENT:
echo   - EXNESS_GenX_Trader.mq5
echo   - EXNESS_GenX_Config.mqh
echo   - INSTALL.txt
echo.

REM Open the deployment package folder
explorer "%DEPLOY_DIR%"

echo.
echo ================================================================
echo   DEPLOYMENT OPTIONS:
echo ================================================================
echo.
echo OPTION 1: Manual Copy (Recommended for first-time setup)
echo   1. Connect to VPS via Remote Desktop
echo   2. Copy the deployment_package folder to VPS
echo   3. Follow instructions in INSTALL.txt
echo.
echo OPTION 2: Network Share
echo   1. Share the deployment_package folder
echo   2. Access from VPS via network path
echo   3. Copy files to MT5 directories
echo.
echo OPTION 3: Cloud Storage
echo   1. Upload deployment_package to OneDrive/Dropbox
echo   2. Download on VPS
echo   3. Copy files to MT5 directories
echo.
echo ================================================================
echo.
echo Press any key to continue with PowerShell deployment script...
pause >nul

REM Try PowerShell deployment
powershell -ExecutionPolicy Bypass -NoProfile -File "%SCRIPT_DIR%deploy_to_vps.ps1"
