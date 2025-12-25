@echo off
echo ========================================
echo   Trading System Setup and Start
echo ========================================
echo.

cd /d "D:\ZOLO-A6-9VxNUNA-\trading-bridge"

if not exist "python\services\background_service.py" (
    echo [ERROR] Service file not found!
    pause
    exit /b 1
)

echo [1/3] Checking Python...
python --version
if errorlevel 1 (
    echo [ERROR] Python not found!
    pause
    exit /b 1
)

echo [2/3] Installing dependencies...
pip install -q pyzmq requests python-dotenv cryptography schedule pywin32
if errorlevel 1 (
    echo [WARNING] Some dependencies may have failed
)

echo [3/3] Starting trading service...
if exist "run-trading-service.py" (
    start /B python run-trading-service.py
    echo [OK] Service started using run-trading-service.py
) else (
    start /B python python\services\background_service.py
    echo [OK] Service started using background_service.py
)

timeout /t 3 /nobreak >nul

echo.
echo ========================================
echo   Trading System Status
echo ========================================
echo.
echo Service should be running in background
echo Check logs in: trading-bridge\logs\
echo.
echo To stop: taskkill /F /FI "WINDOWTITLE eq python*"
echo.
pause

