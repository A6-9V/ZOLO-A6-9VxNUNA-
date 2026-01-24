# Quick Deployment Status Check
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  EXNESS GenX Trader - Deployment Status" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

$MT5BasePath = "C:\Users\USER\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06"
$EAFile = Join-Path $MT5BasePath "MQL5\Experts\EXNESS_GenX_Trader.mq5"
$ConfigFile = Join-Path $MT5BasePath "MQL5\Include\EXNESS_GenX_Config.mqh"
$CompiledEA = Join-Path $MT5BasePath "MQL5\Experts\EXNESS_GenX_Trader.ex5"

Write-Host "Checking deployment status..." -ForegroundColor Yellow
Write-Host ""

# Check EA source file
if (Test-Path $EAFile) {
    $eaSize = (Get-Item $EAFile).Length
    Write-Host "[OK] EA Source File: EXNESS_GenX_Trader.mq5" -ForegroundColor Green
    Write-Host "     Location: $EAFile" -ForegroundColor Gray
    Write-Host "     Size: $([math]::Round($eaSize/1KB, 2)) KB" -ForegroundColor Gray
} else {
    Write-Host "[MISSING] EA Source File not found!" -ForegroundColor Red
}

Write-Host ""

# Check config file
if (Test-Path $ConfigFile) {
    $configSize = (Get-Item $ConfigFile).Length
    Write-Host "[OK] Config File: EXNESS_GenX_Config.mqh" -ForegroundColor Green
    Write-Host "     Location: $ConfigFile" -ForegroundColor Gray
    Write-Host "     Size: $([math]::Round($configSize/1KB, 2)) KB" -ForegroundColor Gray
} else {
    Write-Host "[MISSING] Config File not found!" -ForegroundColor Red
}

Write-Host ""

# Check compiled EA
if (Test-Path $CompiledEA) {
    $compiledSize = (Get-Item $CompiledEA).Length
    Write-Host "[OK] Compiled EA: EXNESS_GenX_Trader.ex5" -ForegroundColor Green
    Write-Host "     Location: $CompiledEA" -ForegroundColor Gray
    Write-Host "     Size: $([math]::Round($compiledSize/1KB, 2)) KB" -ForegroundColor Gray
    Write-Host ""
    Write-Host "[INFO] EA is compiled and ready to attach!" -ForegroundColor Cyan
} else {
    Write-Host "[PENDING] EA not compiled yet" -ForegroundColor Yellow
    Write-Host "     Next step: Open MetaEditor (F4) and compile (F7)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Next Steps:" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $CompiledEA)) {
    Write-Host "1. Open MetaEditor (Press F4 in MT5)" -ForegroundColor Yellow
    Write-Host "2. Open: Experts -> EXNESS_GenX_Trader.mq5" -ForegroundColor White
    Write-Host "3. Press F7 to compile" -ForegroundColor White
    Write-Host ""
}

Write-Host "4. Attach EA to chart (Ctrl+N -> Drag EA to chart)" -ForegroundColor Yellow
Write-Host "5. Enable AutoTrading (green button)" -ForegroundColor Yellow
Write-Host "6. Migrate to VPS 6773048 (Tools -> Options -> Virtual Hosting)" -ForegroundColor Yellow
Write-Host ""
Write-Host "For detailed instructions, see: COMPLETE_DEPLOYMENT_NOW.md" -ForegroundColor Cyan
Write-Host ""
