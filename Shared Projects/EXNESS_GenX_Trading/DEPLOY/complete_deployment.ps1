# Complete Deployment to MQL5 Hosting VPS 6773048
# This script completes the deployment process

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Complete Deployment to MQL5 Hosting" -ForegroundColor Cyan
Write-Host "  VPS: Singapore 09 (ID: 6773048)" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# MT5 paths
$MT5BasePath = "C:\Users\USER\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06"
$EAFile = Join-Path $MT5BasePath "MQL5\Experts\EXNESS_GenX_Trader.mq5"
$CompiledEA = Join-Path $MT5BasePath "MQL5\Experts\EXNESS_GenX_Trader.ex5"

Write-Host "Checking EA deployment status..." -ForegroundColor Yellow
Write-Host ""

# Check if EA file exists
if (-not (Test-Path $EAFile)) {
    Write-Host "ERROR: EA file not found at: $EAFile" -ForegroundColor Red
    Write-Host "Please run deploy_to_mql5_hosting.ps1 first" -ForegroundColor Yellow
    exit 1
}

Write-Host "[OK] EA source file found" -ForegroundColor Green

# Check if compiled
if (Test-Path $CompiledEA) {
    $compiledDate = (Get-Item $CompiledEA).LastWriteTime
    Write-Host "[OK] Compiled EA found (Last compiled: $compiledDate)" -ForegroundColor Green
} else {
    Write-Host "[INFO] EA not yet compiled" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To compile the EA:" -ForegroundColor Cyan
    Write-Host "1. Open MetaTrader 5 EXNESS terminal" -ForegroundColor White
    Write-Host "2. Press F4 to open MetaEditor" -ForegroundColor White
    Write-Host "3. Navigate to: Experts → EXNESS_GenX_Trader.mq5" -ForegroundColor White
    Write-Host "4. Press F7 to compile" -ForegroundColor White
    Write-Host "5. Check for errors (should be empty)" -ForegroundColor White
    Write-Host ""
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  DEPLOYMENT CHECKLIST" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

$checklist = @(
    @{Task="EA files copied to MT5 directories"; Status=(Test-Path $EAFile)},
    @{Task="EA compiled (.ex5 file exists)"; Status=(Test-Path $CompiledEA)},
    @{Task="EA attached to chart locally"; Status=$false},
    @{Task="AutoTrading enabled locally"; Status=$false},
    @{Task="Migrated to MQL5 Hosting VPS"; Status=$false}
)

foreach ($item in $checklist) {
    $status = if ($item.Status) { "[OK]" -ForegroundColor Green } else { "[PENDING]" -ForegroundColor Yellow }
    Write-Host "$status $($item.Task)" -ForegroundColor White
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  MIGRATION TO VPS 6773048" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To complete deployment to MQL5 Hosting VPS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "STEP 1: Prepare EA Locally" -ForegroundColor Cyan
Write-Host "  [ ] Compile EA in MetaEditor (F7)" -ForegroundColor White
Write-Host "  [ ] Attach EA to a chart" -ForegroundColor White
Write-Host "  [ ] Configure EA settings" -ForegroundColor White
Write-Host "  [ ] Enable AutoTrading (green button)" -ForegroundColor White
Write-Host ""
Write-Host "STEP 2: Migrate to VPS" -ForegroundColor Cyan
Write-Host "  [ ] Open MT5 terminal" -ForegroundColor White
Write-Host "  [ ] Go to: Tools → Options → Virtual Hosting" -ForegroundColor White
Write-Host "  [ ] Or: View → Virtual Hosting" -ForegroundColor White
Write-Host "  [ ] Click 'Migrate Local Account' or 'Synchronize'" -ForegroundColor White
Write-Host "  [ ] Select VPS: Singapore 09 (ID: 6773048)" -ForegroundColor White
Write-Host "  [ ] Wait for synchronization" -ForegroundColor White
Write-Host ""
Write-Host "STEP 3: Verify Deployment" -ForegroundColor Cyan
Write-Host "  [ ] Check logs: hosting.6773048.experts" -ForegroundColor White
Write-Host "  [ ] Verify EA is running on VPS" -ForegroundColor White
Write-Host "  [ ] Check Experts tab for EA activity" -ForegroundColor White
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Try to open MT5 terminal
Write-Host "Would you like to open MetaTrader 5 now? (Y/N)" -ForegroundColor Cyan
$openMT5 = Read-Host

if ($openMT5 -eq "Y" -or $openMT5 -eq "y") {
    $mt5Path = "E:\Program Files\MetaTrader 5 EXNESS\terminal64.exe"
    if (Test-Path $mt5Path) {
        Write-Host ""
        Write-Host "Opening MetaTrader 5..." -ForegroundColor Green
        Start-Process $mt5Path
        Write-Host "[OK] MetaTrader 5 opened" -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Yellow
        Write-Host "1. Press F4 to open MetaEditor" -ForegroundColor White
        Write-Host "2. Compile EXNESS_GenX_Trader.mq5 (F7)" -ForegroundColor White
        Write-Host "3. Attach EA to chart" -ForegroundColor White
        Write-Host "4. Enable AutoTrading" -ForegroundColor White
        Write-Host "5. Migrate to VPS via Virtual Hosting menu" -ForegroundColor White
    } else {
        Write-Host "[INFO] MT5 path not found: $mt5Path" -ForegroundColor Yellow
        Write-Host "Please open MetaTrader 5 manually" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Deployment guide complete!" -ForegroundColor Green
Write-Host ""
