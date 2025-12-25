#Requires -Version 5.1
<#
.SYNOPSIS
    Verify Trading System Status
.DESCRIPTION
    Checks if the trading system is running and displays status
#>

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Trading System Status Check" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$tradingBridgePath = "D:\ZOLO-A6-9VxNUNA-\trading-bridge"

# Check if trading bridge exists
if (-not (Test-Path $tradingBridgePath)) {
    Write-Host "[ERROR] Trading bridge not found at: $tradingBridgePath" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Trading bridge found" -ForegroundColor Green
Write-Host ""

# Check Python processes
Write-Host "Python Processes:" -ForegroundColor Yellow
$pythonProcesses = Get-Process python -ErrorAction SilentlyContinue
if ($pythonProcesses) {
    foreach ($proc in $pythonProcesses) {
        try {
            $cmdLine = (Get-CimInstance Win32_Process -Filter "ProcessId = $($proc.Id)" -ErrorAction SilentlyContinue).CommandLine
            if ($cmdLine -like "*trading*" -or $cmdLine -like "*run-trading-service*" -or $cmdLine -like "*background_service*") {
                Write-Host "  [RUNNING] PID: $($proc.Id) - Trading Service" -ForegroundColor Green
                Write-Host "    Command: $cmdLine" -ForegroundColor Gray
            } else {
                Write-Host "  [OTHER] PID: $($proc.Id)" -ForegroundColor Cyan
            }
        } catch {
            Write-Host "  [UNKNOWN] PID: $($proc.Id)" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "  [NOT RUNNING] No Python processes found" -ForegroundColor Red
}

Write-Host ""

# Check log files
Write-Host "Log Files:" -ForegroundColor Yellow
$logsPath = Join-Path $tradingBridgePath "logs"
if (Test-Path $logsPath) {
    $logFiles = Get-ChildItem -Path $logsPath -Filter "*.log" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
    if ($logFiles) {
        foreach ($log in $logFiles | Select-Object -First 5) {
            Write-Host "  [LOG] $($log.Name) - $($log.LastWriteTime)" -ForegroundColor Cyan
            $errorCount = (Select-String -Path $log.FullName -Pattern "ERROR" -ErrorAction SilentlyContinue).Count
            if ($errorCount -gt 0) {
                Write-Host "    Warnings: $errorCount errors found" -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "  [INFO] No log files yet (service may have just started)" -ForegroundColor Cyan
    }
} else {
    Write-Host "  [INFO] Logs directory not created yet" -ForegroundColor Cyan
}

Write-Host ""

# Check configuration
Write-Host "Configuration:" -ForegroundColor Yellow
$symbolsConfig = Join-Path $tradingBridgePath "config\symbols.json"
$brokersConfig = Join-Path $tradingBridgePath "config\brokers.json"

if (Test-Path $symbolsConfig) {
    Write-Host "  [OK] symbols.json found" -ForegroundColor Green
} else {
    Write-Host "  [MISSING] symbols.json" -ForegroundColor Red
}

if (Test-Path $brokersConfig) {
    Write-Host "  [OK] brokers.json found" -ForegroundColor Green
} else {
    Write-Host "  [MISSING] brokers.json" -ForegroundColor Yellow
}

Write-Host ""

# Check current day and active symbols
$currentDay = (Get-Date).DayOfWeek
Write-Host "Trading Schedule:" -ForegroundColor Yellow
Write-Host "  Today: $currentDay" -ForegroundColor Cyan

if ($currentDay -eq "Saturday" -or $currentDay -eq "Sunday") {
    Write-Host "  Active Symbols (Weekend):" -ForegroundColor Green
    Write-Host "    - BTCUSD" -ForegroundColor White
    Write-Host "    - ETHUSD" -ForegroundColor White
    Write-Host "    - XAUUSD" -ForegroundColor White
} else {
    Write-Host "  Active Symbols (Weekday):" -ForegroundColor Green
    Write-Host "    - EURUSD, GBPUSD, USDJPY, AUDUSD" -ForegroundColor White
    Write-Host "    - USDCAD, EURJPY, GBPJPY" -ForegroundColor White
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Status Check Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

