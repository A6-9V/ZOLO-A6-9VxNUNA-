@echo off
REM Monitor MetaEditor Logs - Quick Launcher
REM This batch file launches the MetaEditor log monitoring script

echo ========================================
echo   MetaEditor Log Monitor
echo ========================================
echo.
echo Select monitoring mode:
echo   1. Recent logs (default)
echo   2. Real-time monitoring (tail)
echo   3. Errors and warnings only
echo   4. Complete summary
echo.

set /p choice="Enter choice (1-4) or press Enter for default: "

if "%choice%"=="" set choice=1
if "%choice%"=="1" (
    echo.
    echo Showing recent logs...
    powershell -ExecutionPolicy Bypass -File "%~dp0monitor-metaeditor-logs.ps1" -Mode recent
    goto end
)
if "%choice%"=="2" (
    echo.
    echo Starting real-time monitoring... Press Ctrl+C to stop
    powershell -ExecutionPolicy Bypass -File "%~dp0monitor-metaeditor-logs.ps1" -Mode tail
    goto end
)
if "%choice%"=="3" (
    echo.
    echo Analyzing errors and warnings...
    powershell -ExecutionPolicy Bypass -File "%~dp0monitor-metaeditor-logs.ps1" -Mode errors
    goto end
)
if "%choice%"=="4" (
    echo.
    echo Generating complete summary...
    powershell -ExecutionPolicy Bypass -File "%~dp0monitor-metaeditor-logs.ps1" -Mode summary
    goto end
)

echo Invalid choice. Using default mode.
powershell -ExecutionPolicy Bypass -File "%~dp0monitor-metaeditor-logs.ps1" -Mode recent

:end
echo.
pause
