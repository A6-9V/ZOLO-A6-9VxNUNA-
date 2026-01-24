# Simple Interactive VPS Deployment Script
param()

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  EXNESS GenX Trader - VPS Deployment" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DeployPackage = Join-Path $ScriptDir "deployment_package"

Write-Host "Deployment package location:" -ForegroundColor Yellow
Write-Host "  $DeployPackage" -ForegroundColor White
Write-Host ""

# Check if package exists
if (-not (Test-Path $DeployPackage)) {
    Write-Host "ERROR: Deployment package not found!" -ForegroundColor Red
    exit 1
}

Write-Host "Files ready for deployment:" -ForegroundColor Green
Get-ChildItem $DeployPackage | ForEach-Object {
    Write-Host "  ✓ $($_.Name)" -ForegroundColor Green
}
Write-Host ""

Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Deployment Method Selection" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Choose deployment method:" -ForegroundColor Yellow
Write-Host "  1. Open folder for manual copy (Recommended)"
Write-Host "  2. Copy via Remote Desktop (RDP)"
Write-Host "  3. Show installation instructions"
Write-Host "  4. Exit"
Write-Host ""

$choice = Read-Host "Enter choice (1-4)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "Opening deployment package folder..." -ForegroundColor Green
        Start-Process explorer.exe -ArgumentList $DeployPackage
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Yellow
        Write-Host "  1. Connect to VPS via Remote Desktop"
        Write-Host "  2. Copy deployment_package folder to VPS"
        Write-Host "  3. Copy files to MT5 directories:"
        Write-Host "     - EXNESS_GenX_Trader.mq5 → [MT5_PATH]\MQL5\Experts\"
        Write-Host "     - EXNESS_GenX_Config.mqh → [MT5_PATH]\MQL5\Include\"
        Write-Host "  4. Open MT5 → F4 (MetaEditor) → Compile (F7)"
        Write-Host "  5. Attach EA to chart → Enable AutoTrading"
        Write-Host ""
    }
    "2" {
        Write-Host ""
        $vpsHost = Read-Host "Enter VPS IP address or hostname"
        if ($vpsHost) {
            Write-Host ""
            Write-Host "Connecting to VPS via Remote Desktop..." -ForegroundColor Green
            Write-Host "Command: mstsc /v:$vpsHost" -ForegroundColor Yellow
            Write-Host ""
            $confirm = Read-Host "Open Remote Desktop connection? (Y/N)"
            if ($confirm -eq "Y" -or $confirm -eq "y") {
                Start-Process "mstsc.exe" -ArgumentList "/v:$vpsHost"
                Write-Host ""
                Write-Host "After connecting to VPS:" -ForegroundColor Yellow
                Write-Host "  1. Copy deployment_package folder to VPS"
                Write-Host "  2. Follow instructions in INSTALL.txt"
                Write-Host ""
            }
        }
    }
    "3" {
        Write-Host ""
        Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Host "  Installation Instructions" -ForegroundColor Cyan
        Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1. COPY FILES TO MT5 DIRECTORIES:" -ForegroundColor Yellow
        Write-Host "   Copy EXNESS_GenX_Trader.mq5 to: [MT5_PATH]\MQL5\Experts\" -ForegroundColor White
        Write-Host "   Copy EXNESS_GenX_Config.mqh to: [MT5_PATH]\MQL5\Include\" -ForegroundColor White
        Write-Host ""
        Write-Host "2. COMPILE THE EA:" -ForegroundColor Yellow
        Write-Host "   - Open MetaTrader 5 on VPS" -ForegroundColor White
        Write-Host "   - Press F4 to open MetaEditor" -ForegroundColor White
        Write-Host "   - Navigate to: Experts → EXNESS_GenX_Trader.mq5" -ForegroundColor White
        Write-Host "   - Press F7 to compile" -ForegroundColor White
        Write-Host "   - Check Errors tab (should be empty)" -ForegroundColor White
        Write-Host ""
        Write-Host "3. ATTACH EA TO CHART:" -ForegroundColor Yellow
        Write-Host "   - Open a chart (recommended: EURUSD H1)" -ForegroundColor White
        Write-Host "   - Press Ctrl+N to open Navigator" -ForegroundColor White
        Write-Host "   - Drag EXNESS_GenX_Trader onto chart" -ForegroundColor White
        Write-Host "   - Configure settings and Click OK" -ForegroundColor White
        Write-Host ""
        Write-Host "4. ENABLE AUTOTRADING:" -ForegroundColor Yellow
        Write-Host "   - Click AutoTrading button (should turn green)" -ForegroundColor White
        Write-Host "   - Verify EA is running (smiley face icon)" -ForegroundColor White
        Write-Host "   - Check Experts tab for logs" -ForegroundColor White
        Write-Host ""
    }
    "4" {
        Write-Host "Exiting..." -ForegroundColor Yellow
        exit 0
    }
    default {
        Write-Host "Invalid choice. Exiting..." -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "Deployment process initiated!" -ForegroundColor Green
Write-Host ""
