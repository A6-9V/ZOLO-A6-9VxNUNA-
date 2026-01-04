# Quick verification script for EA setup
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  EA Setup Verification" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check trading service
Write-Host "Trading Service:" -ForegroundColor Yellow
$port5500 = Get-NetTCPConnection -LocalPort 5500 -ErrorAction SilentlyContinue
if ($port5500) {
    Write-Host "  ✓ Running on port 5500" -ForegroundColor Green
} else {
    Write-Host "  ✗ Not running" -ForegroundColor Red
    Write-Host "  Start with: python run-trading-service.py" -ForegroundColor Cyan
}
Write-Host ""

# Check MT5 files
Write-Host "MT5 Files:" -ForegroundColor Yellow
$mt5Dirs = Get-ChildItem "$env:APPDATA\MetaQuotes\Terminal" -Directory | Select-Object -First 1
if ($mt5Dirs) {
    Write-Host "  MT5 Path: $($mt5Dirs.FullName)" -ForegroundColor Cyan
    
    $eaPath = Join-Path $mt5Dirs.FullName "MQL5\Experts\PythonBridgeEA.mq5"
    $includePath = Join-Path $mt5Dirs.FullName "MQL5\Include\PythonBridge.mqh"
    $ex5Path = $eaPath -replace '\.mq5$', '.ex5'
    
    if (Test-Path $eaPath) {
        Write-Host "  ✓ EA file exists" -ForegroundColor Green
    } else {
        Write-Host "  ✗ EA file missing" -ForegroundColor Red
    }
    
    if (Test-Path $includePath) {
        Write-Host "  ✓ Include file exists" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Include file missing" -ForegroundColor Red
    }
    
    if (Test-Path $ex5Path) {
        Write-Host "  ✓ Compiled EX5 exists" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Not compiled yet" -ForegroundColor Yellow
        Write-Host "    Run: Open MT5 → F4 → Open EA → F7" -ForegroundColor Cyan
    }
} else {
    Write-Host "  ✗ MT5 directory not found" -ForegroundColor Red
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan

