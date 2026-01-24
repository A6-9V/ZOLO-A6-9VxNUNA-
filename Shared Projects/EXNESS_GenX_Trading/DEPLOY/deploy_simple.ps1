# Simple VPS Deployment Script
$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  EXNESS GenX Trader - VPS Deployment" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DeployPackage = Join-Path $ScriptDir "deployment_package"

Write-Host "Deployment package location:" -ForegroundColor Yellow
Write-Host "  $DeployPackage" -ForegroundColor White
Write-Host ""

if (-not (Test-Path $DeployPackage)) {
    Write-Host "ERROR: Deployment package not found!" -ForegroundColor Red
    exit 1
}

Write-Host "Files ready for deployment:" -ForegroundColor Green
Get-ChildItem $DeployPackage | ForEach-Object {
    Write-Host "  - $($_.Name)" -ForegroundColor Green
}
Write-Host ""

Write-Host "Opening deployment package folder..." -ForegroundColor Green
Start-Process explorer.exe -ArgumentList $DeployPackage

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  DEPLOYMENT INSTRUCTIONS" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Connect to VPS via Remote Desktop" -ForegroundColor Yellow
Write-Host "2. Copy the deployment_package folder to VPS" -ForegroundColor Yellow
Write-Host "3. Copy files to MT5 directories:" -ForegroundColor Yellow
Write-Host "   - EXNESS_GenX_Trader.mq5 to [MT5_PATH]\MQL5\Experts\" -ForegroundColor White
Write-Host "   - EXNESS_GenX_Config.mqh to [MT5_PATH]\MQL5\Include\" -ForegroundColor White
Write-Host "4. Open MetaTrader 5 on VPS" -ForegroundColor Yellow
Write-Host "5. Press F4 to open MetaEditor" -ForegroundColor Yellow
Write-Host "6. Compile EXNESS_GenX_Trader.mq5 (Press F7)" -ForegroundColor Yellow
Write-Host "7. Attach EA to chart" -ForegroundColor Yellow
Write-Host "8. Enable AutoTrading" -ForegroundColor Yellow
Write-Host ""
Write-Host "For detailed instructions, see INSTALL.txt in the deployment package" -ForegroundColor Cyan
Write-Host ""
Write-Host "Deployment package folder is now open!" -ForegroundColor Green
Write-Host ""
