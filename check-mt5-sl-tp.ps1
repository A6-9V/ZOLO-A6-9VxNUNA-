#Requires -Version 5.1
<#
.SYNOPSIS
    Check MT5 positions for Stop Loss and Take Profit
.DESCRIPTION
    Analyzes MT5 terminal data to verify if positions have SL/TP set
#>

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MT5 Stop Loss & Take Profit Checker" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# MT5 Data Path
$mt5DataPath = "$env:APPDATA\MetaQuotes\Terminal"
$terminalDirs = Get-ChildItem -Path $mt5DataPath -Directory -ErrorAction SilentlyContinue

if (-not $terminalDirs) {
    Write-Host "[ERROR] No MT5 terminal data found" -ForegroundColor Red
    Write-Host "[INFO] Expected location: $mt5DataPath" -ForegroundColor Yellow
    exit 1
}

Write-Host "[1/3] Checking MT5 Terminal Data..." -ForegroundColor Yellow
foreach ($dir in $terminalDirs) {
    Write-Host "    Found: $($dir.Name)" -ForegroundColor Cyan
}

# Check for open positions in terminal files
Write-Host ""
Write-Host "[2/3] Checking for position data..." -ForegroundColor Yellow

$positionsFound = $false
foreach ($terminalDir in $terminalDirs) {
    $testerDir = Join-Path $terminalDir.FullName "tester"
    $logsDir = Join-Path $terminalDir.FullName "MQL5\Logs"
    
    # Check tester logs for position info
    if (Test-Path $testerDir) {
        $logFiles = Get-ChildItem -Path $testerDir -Filter "*.log" -Recurse -ErrorAction SilentlyContinue | 
                    Sort-Object LastWriteTime -Descending | Select-Object -First 5
        
        if ($logFiles) {
            Write-Host "    Checking tester logs..." -ForegroundColor Cyan
            foreach ($log in $logFiles) {
                $content = Get-Content $log.FullName -Tail 50 -ErrorAction SilentlyContinue
                if ($content -match "SL|TP|StopLoss|TakeProfit|stop_loss|take_profit") {
                    Write-Host "      Found SL/TP references in: $($log.Name)" -ForegroundColor Green
                    $positionsFound = $true
                }
            }
        }
    }
    
    # Check MQL5 logs
    if (Test-Path $logsDir) {
        $logFiles = Get-ChildItem -Path $logsDir -Filter "*.log" -Recurse -ErrorAction SilentlyContinue | 
                    Sort-Object LastWriteTime -Descending | Select-Object -First 5
        
        if ($logFiles) {
            Write-Host "    Checking MQL5 logs..." -ForegroundColor Cyan
            foreach ($log in $logFiles) {
                $content = Get-Content $log.FullName -Tail 50 -ErrorAction SilentlyContinue
                if ($content -match "SL|TP|StopLoss|TakeProfit|BUY.*SL|SELL.*SL") {
                    Write-Host "      Found SL/TP in log: $($log.Name)" -ForegroundColor Green
                    $content | Select-String -Pattern "SL|TP|StopLoss|TakeProfit" | Select-Object -First 5 | ForEach-Object {
                        Write-Host "        $_" -ForegroundColor White
                    }
                    $positionsFound = $true
                }
            }
        }
    }
}

Write-Host ""
Write-Host "[3/3] Analysis Summary" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

if ($positionsFound) {
    Write-Host "[OK] SL/TP references found in logs" -ForegroundColor Green
    Write-Host ""
    Write-Host "To verify SL/TP are actually set on positions:" -ForegroundColor Cyan
    Write-Host "  1. Open MT5 Terminal" -ForegroundColor White
    Write-Host "  2. Go to View → Terminal (Ctrl+T)" -ForegroundColor White
    Write-Host "  3. Check the 'Trade' tab" -ForegroundColor White
    Write-Host "  4. Look at open positions:" -ForegroundColor White
    Write-Host "     - SL column should show stop loss price" -ForegroundColor Yellow
    Write-Host "     - TP column should show take profit price" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  If SL/TP columns show '0.00000' or empty:" -ForegroundColor Red
    Write-Host "    → SL/TP are NOT set" -ForegroundColor Red
    Write-Host ""
    Write-Host "  If SL/TP columns show prices:" -ForegroundColor Green
    Write-Host "    → SL/TP ARE set and working!" -ForegroundColor Green
} else {
    Write-Host "[INFO] No recent SL/TP activity found in logs" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "This could mean:" -ForegroundColor Cyan
    Write-Host "  - No trades have been executed yet" -ForegroundColor White
    Write-Host "  - Logs are in a different location" -ForegroundColor White
    Write-Host "  - EA is not running" -ForegroundColor White
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Manual Check Instructions" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To check if SL/TP are working:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Open EXNESS Terminal" -ForegroundColor White
Write-Host "2. Press Ctrl+T (or View → Terminal)" -ForegroundColor White
Write-Host "3. Click on 'Trade' tab" -ForegroundColor White
Write-Host "4. Look at your open positions:" -ForegroundColor White
Write-Host ""
Write-Host "   Position Columns:" -ForegroundColor Cyan
Write-Host "   - Symbol: Trading pair (e.g., EURUSD)" -ForegroundColor White
Write-Host "   - Volume: Position size" -ForegroundColor White
Write-Host "   - Price: Entry price" -ForegroundColor White
Write-Host "   - SL: Stop Loss price (should NOT be 0)" -ForegroundColor $(if ($true) { "Green" } else { "Red" })
Write-Host "   - TP: Take Profit price (should NOT be 0)" -ForegroundColor $(if ($true) { "Green" } else { "Red" })
Write-Host ""
Write-Host "5. Check Journal tab (Ctrl+J) for EA messages:" -ForegroundColor White
Write-Host "   Look for messages like:" -ForegroundColor Cyan
Write-Host "   - 'BUY order executed: EURUSD Lot: 0.01 SL: 1.0850 TP: 1.0900'" -ForegroundColor Green
Write-Host "   - 'SELL order executed: GBPUSD Lot: 0.01 SL: 1.2750 TP: 1.2650'" -ForegroundColor Green
Write-Host ""
Write-Host "6. Check Experts tab (View → Toolbox → Experts):" -ForegroundColor White
Write-Host "   Look for EA status and execution logs" -ForegroundColor Cyan
Write-Host ""

Write-Host "Script execution completed." -ForegroundColor Green

