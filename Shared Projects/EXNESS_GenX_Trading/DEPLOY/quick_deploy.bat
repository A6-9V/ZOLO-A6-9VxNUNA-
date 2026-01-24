@echo off
REM Quick deployment script for EXNESS GenX Trader to VPS
REM This script provides a simple way to deploy the EA

echo ================================================================
echo   EXNESS GenX Trader - Quick VPS Deployment
echo ================================================================
echo.

REM Get the script directory
set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."
set "EXPERTS_DIR=%PROJECT_ROOT%\EXPERTS"
set "INCLUDE_DIR=%PROJECT_ROOT%\INCLUDE"

REM Check if files exist
if not exist "%EXPERTS_DIR%\EXNESS_GenX_Trader.mq5" (
    echo ERROR: EA file not found!
    pause
    exit /b 1
)

if not exist "%INCLUDE_DIR%\EXNESS_GenX_Config.mqh" (
    echo ERROR: Config file not found!
    pause
    exit /b 1
)

echo Files found. Starting deployment...
echo.

REM Create deployment package
set "DEPLOY_DIR=%SCRIPT_DIR%deployment_package"
if not exist "%DEPLOY_DIR%" mkdir "%DEPLOY_DIR%"

copy "%EXPERTS_DIR%\EXNESS_GenX_Trader.mq5" "%DEPLOY_DIR%\" >nul
copy "%INCLUDE_DIR%\EXNESS_GenX_Config.mqh" "%DEPLOY_DIR%\" >nul

echo ================================================================
echo   Deployment Package Created
echo ================================================================
echo.
echo Package location: %DEPLOY_DIR%
echo.
echo Files included:
echo   - EXNESS_GenX_Trader.mq5
echo   - EXNESS_GenX_Config.mqh
echo.

REM Try PowerShell deployment if available
where powershell >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Attempting automated deployment...
    echo.
    powershell -ExecutionPolicy Bypass -File "%SCRIPT_DIR%deploy_to_vps.ps1"
) else (
    echo PowerShell not available. Using manual deployment.
    echo.
)

echo.
echo ================================================================
echo   Manual Deployment Steps
echo ================================================================
echo.
echo 1. Connect to your VPS via Remote Desktop
echo 2. Copy the deployment_package folder to VPS
echo 3. Copy files to MT5 directories:
echo    - EXNESS_GenX_Trader.mq5 → [MT5_PATH]\MQL5\Experts\
echo    - EXNESS_GenX_Config.mqh → [MT5_PATH]\MQL5\Include\
echo 4. Open MetaTrader 5 on VPS
echo 5. Press F4 to open MetaEditor
echo 6. Compile EXNESS_GenX_Trader.mq5 (F7)
echo 7. Attach EA to chart
echo 8. Enable AutoTrading
echo.
echo For detailed instructions, see: VPS_DEPLOYMENT.md
echo.

pause
