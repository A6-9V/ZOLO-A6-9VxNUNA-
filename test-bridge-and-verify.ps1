#Requires -Version 5.1
<#
.SYNOPSIS
    Test Bridge Connection and Verify Trading System
.DESCRIPTION
    Tests the Python-MQL5 bridge connection and verifies system status
#>

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Bridge Connection Test & Verification" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$tradingBridgePath = "D:\ZOLO-A6-9VxNUNA-\trading-bridge"

if (-not (Test-Path $tradingBridgePath)) {
    Write-Host "[ERROR] Trading bridge not found!" -ForegroundColor Red
    exit 1
}

# Check if Python service is running
Write-Host "[1/5] Checking Python service..." -ForegroundColor Yellow
$pythonProcesses = Get-Process python -ErrorAction SilentlyContinue | Where-Object {
    try {
        $cmdLine = (Get-CimInstance Win32_Process -Filter "ProcessId = $($_.Id)" -ErrorAction SilentlyContinue).CommandLine
        $cmdLine -like "*trading*" -or $cmdLine -like "*run-trading-service*" -or $cmdLine -like "*background_service*"
    } catch {
        $false
    }
}

if ($pythonProcesses) {
    Write-Host "    [OK] Trading service is running" -ForegroundColor Green
    foreach ($proc in $pythonProcesses) {
        Write-Host "      PID: $($proc.Id)" -ForegroundColor Cyan
    }
} else {
    Write-Host "    [WARNING] Trading service not detected" -ForegroundColor Yellow
    Write-Host "    Starting service..." -ForegroundColor Cyan
    Push-Location $tradingBridgePath
    if (Test-Path "run-trading-service.py") {
        Start-Process python -ArgumentList "run-trading-service.py" -WindowStyle Hidden
        Start-Sleep -Seconds 3
        Write-Host "    [OK] Service started" -ForegroundColor Green
    }
    Pop-Location
}

Write-Host ""

# Check port 5555
Write-Host "[2/5] Checking bridge port (5555)..." -ForegroundColor Yellow
$portInUse = Get-NetTCPConnection -LocalPort 5555 -ErrorAction SilentlyContinue
if ($portInUse) {
    Write-Host "    [OK] Port 5555 is in use (bridge likely listening)" -ForegroundColor Green
} else {
    Write-Host "    [INFO] Port 5555 is not in use (bridge may not be listening yet)" -ForegroundColor Cyan
}

Write-Host ""

# Check configuration files
Write-Host "[3/5] Verifying configuration..." -ForegroundColor Yellow
$symbolsConfig = Join-Path $tradingBridgePath "config\symbols.json"
$brokersConfig = Join-Path $tradingBridgePath "config\brokers.json"

if (Test-Path $symbolsConfig) {
    Write-Host "    [OK] symbols.json found" -ForegroundColor Green
    $symbols = Get-Content $symbolsConfig | ConvertFrom-Json
    $enabledSymbols = ($symbols.symbols | Where-Object { $_.enabled }).Count
    Write-Host "      Enabled symbols: $enabledSymbols" -ForegroundColor Cyan
} else {
    Write-Host "    [ERROR] symbols.json not found!" -ForegroundColor Red
}

if (Test-Path $brokersConfig) {
    $brokers = Get-Content $brokersConfig | ConvertFrom-Json
    $hasPlaceholders = ($brokers.brokers | Where-Object { 
        $_.account_id -like "*YOUR_*" -or $_.api_key -like "*YOUR_*" -or $_.api_secret -like "*YOUR_*"
    })
    
    if ($hasPlaceholders) {
        Write-Host "    [WARNING] brokers.json has placeholder credentials" -ForegroundColor Yellow
        Write-Host "      Update with real Exness API credentials for trading" -ForegroundColor Cyan
    } else {
        Write-Host "    [OK] brokers.json configured" -ForegroundColor Green
    }
} else {
    Write-Host "    [WARNING] brokers.json not found" -ForegroundColor Yellow
}

Write-Host ""

# Test bridge connection
Write-Host "[4/5] Testing bridge connection..." -ForegroundColor Yellow
$testScript = Join-Path $tradingBridgePath "test-bridge-connection.py"
if (Test-Path $testScript) {
    Write-Host "    Running bridge test (this will start a test bridge)..." -ForegroundColor Cyan
    Write-Host "    Note: This is a separate test - your main service continues running" -ForegroundColor Gray
    Write-Host ""
    Write-Host "    To test manually, run:" -ForegroundColor Yellow
    Write-Host "      cd `"$tradingBridgePath`"" -ForegroundColor White
    Write-Host "      python test-bridge-connection.py" -ForegroundColor White
    Write-Host ""
    Write-Host "    [INFO] Skipping automatic test to avoid port conflicts" -ForegroundColor Cyan
} else {
    Write-Host "    [INFO] test-bridge-connection.py not found" -ForegroundColor Cyan
}

Write-Host ""

# Check MT5 EA files
Write-Host "[5/5] Checking MT5 Expert Advisor files..." -ForegroundColor Yellow
$mt5Paths = @(
    "$env:APPDATA\MetaQuotes\Terminal\*\MQL5\Experts\PythonBridgeEA.mq5",
    "$env:APPDATA\MetaQuotes\Terminal\*\MQL5\Experts\PythonBridgeEA.ex5"
)

$eaFound = $false
foreach ($pattern in $mt5Paths) {
    $files = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue
    if ($files) {
        foreach ($file in $files) {
            if ($file.Extension -eq ".mq5") {
                Write-Host "    [OK] EA source found: $($file.Name)" -ForegroundColor Green
                Write-Host "      Location: $($file.DirectoryName)" -ForegroundColor Cyan
                Write-Host "      [ACTION] Compile in MetaEditor (F7)" -ForegroundColor Yellow
            } elseif ($file.Extension -eq ".ex5") {
                Write-Host "    [OK] EA compiled: $($file.Name)" -ForegroundColor Green
                Write-Host "      [ACTION] Attach to chart in MT5" -ForegroundColor Yellow
                $eaFound = $true
            }
        }
    }
}

if (-not $eaFound) {
    Write-Host "    [INFO] EA files not found in standard MT5 location" -ForegroundColor Cyan
    Write-Host "      Check: $env:APPDATA\MetaQuotes\Terminal\*\MQL5\Experts\" -ForegroundColor Gray
}

Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Verification Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$currentDay = (Get-Date).DayOfWeek
Write-Host "Current Day: $currentDay" -ForegroundColor Cyan
if ($currentDay -eq "Saturday" -or $currentDay -eq "Sunday") {
    Write-Host "Active Symbols: BTCUSD, ETHUSD, XAUUSD (Weekend)" -ForegroundColor Green
} else {
    Write-Host "Active Symbols: EURUSD, GBPUSD, USDJPY, AUDUSD, USDCAD, EURJPY, GBPJPY (Weekday)" -ForegroundColor Green
}

Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. [OPTIONAL] Update Exness credentials in brokers.json" -ForegroundColor White
Write-Host "     Location: $brokersConfig" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. [REQUIRED] Compile PythonBridgeEA.mq5 in MetaEditor" -ForegroundColor White
Write-Host "     - Open MetaEditor (F4 in MT5)" -ForegroundColor Gray
Write-Host "     - Open PythonBridgeEA.mq5" -ForegroundColor Gray
Write-Host "     - Press F7 to compile" -ForegroundColor Gray
Write-Host ""
Write-Host "  3. [REQUIRED] Attach EA to chart in MT5" -ForegroundColor White
Write-Host "     - Open MT5 Terminal" -ForegroundColor Gray
Write-Host "     - Open a chart (e.g., EURUSD)" -ForegroundColor Gray
Write-Host "     - Drag PythonBridgeEA to chart" -ForegroundColor Gray
Write-Host "     - Verify port: 5555" -ForegroundColor Gray
Write-Host ""
Write-Host "  4. [VERIFY] Check connection" -ForegroundColor White
Write-Host "     - Check MT5 Experts tab for connection messages" -ForegroundColor Gray
Write-Host "     - Check Python logs: $tradingBridgePath\logs\" -ForegroundColor Gray
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

