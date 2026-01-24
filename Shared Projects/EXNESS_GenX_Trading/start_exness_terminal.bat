@echo off
REM ===================================================================
REM EXNESS GenX Trading - Terminal Startup Script
REM ===================================================================
REM This script starts the MetaTrader 5 EXNESS terminal with account
REM credentials and sets up environment variables for project management
REM ===================================================================

echo.
echo ================================================================
echo   EXNESS GenX Trading - Terminal Startup
echo ================================================================
echo.

REM Set environment variables for project management
set GITHUB_TOKEN={{GITHUB_TOKEN}}
set MQL5_CLIENT_ID={{MQL5_CLIENT_ID}}
set MQL5_CLIENT_SECRET={{MQL5_CLIENT_SECRET}}
set MQL5_REDIRECT_URI=http://127.0.0.1:50729/

echo [INFO] Environment variables set:
echo   - GITHUB_TOKEN: Configured
echo   - MQL5_CLIENT_ID: %MQL5_CLIENT_ID%
echo   - MQL5_REDIRECT_URI: %MQL5_REDIRECT_URI%
echo.

REM MetaTrader 5 EXNESS Terminal Path
set MT5_PATH=E:\Program Files\MetaTrader 5 EXNESS
set MT5_EXE=%MT5_PATH%\terminal64.exe

REM Account credentials
set MT5_ACCOUNT={{MT5_ACCOUNT}}
set MT5_PASSWORD={{MT5_PASSWORD}}
set MT5_SERVER=Exness-MT5Real8

echo [INFO] Starting MetaTrader 5 EXNESS Terminal...
echo   Account: %MT5_ACCOUNT%
echo   Server: %MT5_SERVER%
echo   Path: %MT5_PATH%
echo.

REM Check if terminal exists
if not exist "%MT5_EXE%" (
    echo [ERROR] Terminal executable not found at: %MT5_EXE%
    echo [ERROR] Please verify the installation path.
    pause
    exit /b 1
)

REM Start terminal with account credentials and server
echo [INFO] Launching terminal...
cd /d "%MT5_PATH%"
start "" "terminal64.exe" /login:%MT5_ACCOUNT% /password:"%MT5_PASSWORD%" /server:%MT5_SERVER%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo [SUCCESS] Terminal started successfully!
    echo.
    echo ================================================================
    echo   Next Steps:
    echo   1. Wait for terminal to connect
    echo   2. Open MetaEditor (F4) to compile EA
    echo   3. Attach EXNESS_GenX_Trader to a chart
    echo   4. Enable AutoTrading (green button)
    echo ================================================================
    echo.
) else (
    echo.
    echo [ERROR] Failed to start terminal. Error code: %ERRORLEVEL%
    echo.
    pause
    exit /b 1
)

REM Keep window open for 3 seconds to show messages
timeout /t 3 /nobreak >nul

exit /b 0

