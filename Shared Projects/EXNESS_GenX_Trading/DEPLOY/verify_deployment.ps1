# Verify EXNESS GenX Trader Deployment to VPS 6773048
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Deployment Verification - VPS 6773048" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

$MT5BasePath = "C:\Users\USER\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06"
$EAFile = Join-Path $MT5BasePath "MQL5\Experts\EXNESS_GenX_Trader.mq5"
$CompiledEA = Join-Path $MT5BasePath "MQL5\Experts\EXNESS_GenX_Trader.ex5"
$ConfigFile = Join-Path $MT5BasePath "MQL5\Include\EXNESS_GenX_Config.mqh"

$allGood = $true

Write-Host "1. Checking EA Files..." -ForegroundColor Yellow
Write-Host ""

# Check EA source
if (Test-Path $EAFile) {
    $eaInfo = Get-Item $EAFile
    Write-Host "   [OK] EA Source: EXNESS_GenX_Trader.mq5" -ForegroundColor Green
    Write-Host "        Size: $([math]::Round($eaInfo.Length/1KB, 2)) KB" -ForegroundColor Gray
} else {
    Write-Host "   [MISSING] EA source file not found!" -ForegroundColor Red
    $allGood = $false
}

# Check compiled EA
if (Test-Path $CompiledEA) {
    $compiledInfo = Get-Item $CompiledEA
    Write-Host "   [OK] Compiled EA: EXNESS_GenX_Trader.ex5" -ForegroundColor Green
    Write-Host "        Size: $([math]::Round($compiledInfo.Length/1KB, 2)) KB" -ForegroundColor Gray
    Write-Host "        Compiled: $($compiledInfo.LastWriteTime)" -ForegroundColor Gray
} else {
    Write-Host "   [ERROR] Compiled EA not found!" -ForegroundColor Red
    Write-Host "        EA needs to be compiled in MetaEditor (F7)" -ForegroundColor Yellow
    $allGood = $false
}

# Check config
if (Test-Path $ConfigFile) {
    $configInfo = Get-Item $ConfigFile
    Write-Host "   [OK] Config File: EXNESS_GenX_Config.mqh" -ForegroundColor Green
    Write-Host "        Size: $([math]::Round($configInfo.Length/1KB, 2)) KB" -ForegroundColor Gray
} else {
    Write-Host "   [MISSING] Config file not found!" -ForegroundColor Red
    $allGood = $false
}

Write-Host ""
Write-Host "2. Verification Checklist:" -ForegroundColor Yellow
Write-Host ""

Write-Host "   Please verify the following in MetaTrader 5:" -ForegroundColor Cyan
Write-Host ""
Write-Host "   [ ] EA is attached to a chart" -ForegroundColor White
Write-Host "   [ ] Smiley face icon visible on chart (EA running)" -ForegroundColor White
Write-Host "   [ ] AutoTrading button is GREEN" -ForegroundColor White
Write-Host "   [ ] EA logs visible in Experts tab" -ForegroundColor White
Write-Host "   [ ] No errors in Journal tab" -ForegroundColor White
Write-Host ""

Write-Host "3. VPS Migration Status:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   To verify VPS deployment:" -ForegroundColor Cyan
Write-Host "   1. Open MT5 terminal" -ForegroundColor White
Write-Host "   2. Go to: View -> Virtual Hosting" -ForegroundColor White
Write-Host "   3. Check VPS 6773048 status:" -ForegroundColor White
Write-Host "      - Should show 'Online' or 'Synchronized'" -ForegroundColor Gray
Write-Host "      - Check 'Last synchronization' time" -ForegroundColor Gray
Write-Host "   4. View VPS logs:" -ForegroundColor White
Write-Host "      - Click on VPS 6773048" -ForegroundColor Gray
Write-Host "      - Navigate to: hosting.6773048.experts" -ForegroundColor Gray
Write-Host "      - Should see EA initialization logs" -ForegroundColor Gray
Write-Host ""

Write-Host "4. EA Status Check:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   In MT5 Terminal:" -ForegroundColor Cyan
Write-Host "   1. Press Ctrl+T to open Toolbox" -ForegroundColor White
Write-Host "   2. Go to 'Experts' tab" -ForegroundColor White
Write-Host "   3. Look for EXNESS_GenX_Trader logs:" -ForegroundColor White
Write-Host "      Expected message:" -ForegroundColor Gray
Write-Host "      'EXNESS GenX Trader v2.0 Initialized'" -ForegroundColor Green
Write-Host "      'Symbol: [SYMBOL]'" -ForegroundColor Green
Write-Host "      'Trading: ENABLED'" -ForegroundColor Green
Write-Host ""

if ($allGood) {
    Write-Host "================================================" -ForegroundColor Green
    Write-Host "  Files Status: READY" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next: Verify EA is running in MT5 and on VPS" -ForegroundColor Yellow
} else {
    Write-Host "================================================" -ForegroundColor Red
    Write-Host "  Files Status: INCOMPLETE" -ForegroundColor Red
    Write-Host "================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please complete the missing steps above" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "For detailed verification guide, see: VERIFY_DEPLOYMENT.md" -ForegroundColor Cyan
Write-Host ""
