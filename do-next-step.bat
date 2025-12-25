@echo off
echo ========================================
echo   Next Step: EA Compilation Setup
echo ========================================
echo.

cd /d "D:\ZOLO-A6-9VxNUNA-\trading-bridge"

echo [1/2] Copying EA files to MT5...
powershell.exe -ExecutionPolicy Bypass -Command "$mt5Dirs = Get-ChildItem -Path '$env:APPDATA\MetaQuotes\Terminal' | Where-Object { $_.PSIsContainer } | Select-Object -First 1; if ($mt5Dirs) { $mt5Experts = Join-Path $mt5Dirs.FullName 'MQL5\Experts'; $mt5Include = Join-Path $mt5Dirs.FullName 'MQL5\Include'; if (-not (Test-Path $mt5Experts)) { New-Item -ItemType Directory -Path $mt5Experts -Force | Out-Null }; if (-not (Test-Path $mt5Include)) { New-Item -ItemType Directory -Path $mt5Include -Force | Out-Null }; Copy-Item -Path 'mql5\Experts\PythonBridgeEA.mq5' -Destination (Join-Path $mt5Experts 'PythonBridgeEA.mq5') -Force -ErrorAction SilentlyContinue; Copy-Item -Path 'mql5\Include\PythonBridge.mqh' -Destination (Join-Path $mt5Include 'PythonBridge.mqh') -Force -ErrorAction SilentlyContinue; Write-Host '[OK] Files copied to MT5' -ForegroundColor Green } else { Write-Host '[WARNING] MT5 directory not found' -ForegroundColor Yellow }"

echo.
echo [2/2] Attempting EA compilation...
powershell.exe -ExecutionPolicy Bypass -Command "$metaEditor = @('C:\Program Files\MetaTrader 5 EXNESS\metaeditor64.exe', '$env:LOCALAPPDATA\Programs\MetaTrader 5 EXNESS\metaeditor64.exe') | Where-Object { Test-Path $_ } | Select-Object -First 1; if ($metaEditor) { $mt5Dirs = Get-ChildItem -Path '$env:APPDATA\MetaQuotes\Terminal' | Where-Object { $_.PSIsContainer } | Select-Object -First 1; if ($mt5Dirs) { $eaPath = Join-Path $mt5Dirs.FullName 'MQL5\Experts\PythonBridgeEA.mq5'; if (Test-Path $eaPath) { Write-Host 'Compiling...' -ForegroundColor Yellow; Start-Process -FilePath $metaEditor -ArgumentList '/compile:', $eaPath, '/log' -Wait -WindowStyle Hidden; Start-Sleep -Seconds 3; $ex5Path = $eaPath -replace '\.mq5$', '.ex5'; if (Test-Path $ex5Path) { Write-Host '[SUCCESS] EA compiled!' -ForegroundColor Green } else { Write-Host '[INFO] Please compile manually in MetaEditor (F7)' -ForegroundColor Yellow } } } } else { Write-Host '[INFO] MetaEditor not found. Compile manually: F4 in MT5, then F7' -ForegroundColor Yellow }"

echo.
echo ========================================
echo   Next: Attach EA to Chart in MT5
echo ========================================
echo.
echo 1. Open MetaTrader 5 Terminal
echo 2. Open a chart (e.g., EURUSD)
echo 3. Drag PythonBridgeEA to chart
echo 4. Set BridgePort: 5555
echo 5. Click OK
echo.
pause

