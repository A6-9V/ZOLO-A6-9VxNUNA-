# Deploy EXNESS GenX Trader to MQL5 Hosting VPS (Singapore 6773048)
# This script prepares and deploys the EA to MQL5 Virtual Hosting

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Deploy to MQL5 Hosting VPS" -ForegroundColor Cyan
Write-Host "  Singapore VPS ID: 6773048" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$DeployPackage = Join-Path $ScriptDir "deployment_package"
$EAFile = Join-Path $DeployPackage "EXNESS_GenX_Trader.mq5"
$ConfigFile = Join-Path $DeployPackage "EXNESS_GenX_Config.mqh"

# MT5 directories
$MT5BasePath = "C:\Users\USER\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06"
$MT5ExpertsPath = Join-Path $MT5BasePath "MQL5\Experts"
$MT5IncludePath = Join-Path $MT5BasePath "MQL5\Include"

Write-Host "Step 1: Preparing EA files..." -ForegroundColor Yellow

# Verify deployment package exists
if (-not (Test-Path $EAFile)) {
    Write-Host "ERROR: EA file not found: $EAFile" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $ConfigFile)) {
    Write-Host "ERROR: Config file not found: $ConfigFile" -ForegroundColor Red
    exit 1
}

Write-Host "  [OK] Deployment package verified" -ForegroundColor Green
Write-Host ""

# Step 2: Copy files to local MT5 directories
Write-Host "Step 2: Deploying to local MT5 directories..." -ForegroundColor Yellow

# Create directories if they don't exist
if (-not (Test-Path $MT5ExpertsPath)) {
    New-Item -ItemType Directory -Path $MT5ExpertsPath -Force | Out-Null
    Write-Host "  [OK] Created Experts directory" -ForegroundColor Green
}

if (-not (Test-Path $MT5IncludePath)) {
    New-Item -ItemType Directory -Path $MT5IncludePath -Force | Out-Null
    Write-Host "  [OK] Created Include directory" -ForegroundColor Green
}

# Copy EA file
$EADestPath = Join-Path $MT5ExpertsPath "EXNESS_GenX_Trader.mq5"
Copy-Item -Path $EAFile -Destination $EADestPath -Force
Write-Host "  [OK] EA copied to: $EADestPath" -ForegroundColor Green

# Copy config file
$ConfigDestPath = Join-Path $MT5IncludePath "EXNESS_GenX_Config.mqh"
Copy-Item -Path $ConfigFile -Destination $ConfigDestPath -Force
Write-Host "  [OK] Config copied to: $ConfigDestPath" -ForegroundColor Green
Write-Host ""

# Step 3: Instructions for MQL5 Hosting migration
Write-Host "Step 3: MQL5 Hosting Migration Instructions" -ForegroundColor Yellow
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  NEXT STEPS - Deploy to VPS 6773048" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "METHOD 1: Migrate via MT5 Terminal (Recommended)" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Open MetaTrader 5 EXNESS terminal" -ForegroundColor White
Write-Host "2. Press F4 to open MetaEditor" -ForegroundColor White
Write-Host "3. Navigate to: Experts → EXNESS_GenX_Trader.mq5" -ForegroundColor White
Write-Host "4. Press F7 to compile the EA" -ForegroundColor White
Write-Host "5. Check for errors (should compile successfully)" -ForegroundColor White
Write-Host "6. Close MetaEditor" -ForegroundColor White
Write-Host ""
Write-Host "7. In MT5 terminal, go to:" -ForegroundColor Yellow
Write-Host "   Tools → Options → Expert Advisors" -ForegroundColor White
Write-Host "   - Enable 'Allow automated trading'" -ForegroundColor White
Write-Host "   - Enable 'Allow DLL imports' (if needed)" -ForegroundColor White
Write-Host ""
Write-Host "8. Attach EA to a chart:" -ForegroundColor Yellow
Write-Host "   - Open a chart (e.g., EURUSD H1)" -ForegroundColor White
Write-Host "   - Press Ctrl+N to open Navigator" -ForegroundColor White
Write-Host "   - Drag 'EXNESS_GenX_Trader' onto chart" -ForegroundColor White
Write-Host "   - Configure EA settings" -ForegroundColor White
Write-Host "   - Click OK" -ForegroundColor White
Write-Host ""
Write-Host "9. Enable AutoTrading (green button in toolbar)" -ForegroundColor Yellow
Write-Host ""
Write-Host "10. Migrate to MQL5 Hosting VPS:" -ForegroundColor Yellow
Write-Host "    - In MT5 terminal menu: Tools → Options → Virtual Hosting" -ForegroundColor White
Write-Host "    - Or: View → Virtual Hosting" -ForegroundColor White
Write-Host "    - Click 'Migrate Local Account' or 'Synchronize'" -ForegroundColor White
Write-Host "    - Select VPS: Singapore 09 (ID: 6773048)" -ForegroundColor White
Write-Host "    - Wait for synchronization to complete" -ForegroundColor White
Write-Host ""
Write-Host "11. Verify on VPS:" -ForegroundColor Yellow
Write-Host "    - Check logs at: hosting.6773048.experts" -ForegroundColor White
Write-Host "    - Verify EA is running (smiley face on chart)" -ForegroundColor White
Write-Host "    - Check Experts tab for EA logs" -ForegroundColor White
Write-Host ""
Write-Host "METHOD 2: Direct File Upload (If available)" -ForegroundColor Yellow
Write-Host ""
Write-Host "If you have direct access to VPS file system:" -ForegroundColor White
Write-Host "1. Connect to VPS via Remote Desktop or file manager" -ForegroundColor White
Write-Host "2. Copy files to VPS MT5 directories:" -ForegroundColor White
Write-Host "   - EXNESS_GenX_Trader.mq5 → [VPS_MT5_PATH]\MQL5\Experts\" -ForegroundColor Gray
Write-Host "   - EXNESS_GenX_Config.mqh → [VPS_MT5_PATH]\MQL5\Include\" -ForegroundColor Gray
Write-Host "3. Compile and attach EA on VPS" -ForegroundColor White
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Step 4: Open MetaEditor to compile
Write-Host "Step 4: Opening MetaEditor for compilation..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Would you like to open MetaEditor now? (Y/N)" -ForegroundColor Cyan
$openEditor = Read-Host

if ($openEditor -eq "Y" -or $openEditor -eq "y") {
    Write-Host ""
    Write-Host "Opening MetaEditor..." -ForegroundColor Green
    Write-Host "After MetaEditor opens:" -ForegroundColor Yellow
    Write-Host "  1. Navigate to: Experts → EXNESS_GenX_Trader.mq5" -ForegroundColor White
    Write-Host "  2. Press F7 to compile" -ForegroundColor White
    Write-Host "  3. Check for errors" -ForegroundColor White
    Write-Host ""
    
    # Try to open MetaEditor
    $metaEditorPath = Join-Path $MT5BasePath "metaeditor64.exe"
    if (Test-Path $metaEditorPath) {
        Start-Process $metaEditorPath
        Write-Host "[OK] MetaEditor opened" -ForegroundColor Green
    } else {
        Write-Host "[INFO] MetaEditor not found at: $metaEditorPath" -ForegroundColor Yellow
        Write-Host "Please open MetaEditor manually (F4 in MT5 terminal)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "  Deployment Preparation Complete!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "EA files are now in your local MT5 directories." -ForegroundColor White
Write-Host "Follow the migration steps above to deploy to VPS 6773048." -ForegroundColor White
Write-Host ""
