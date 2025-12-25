# Quick Launch for Trading Account #405347405
# Configures and launches Exness trading for account 405347405

$ErrorActionPreference = "Continue"

Write-Host "`n╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Launch Trading Account #405347405       ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝`n" -ForegroundColor Cyan

$accountId = "405347405"

# Step 1: Configure account
Write-Host "[1/2] Configuring trading account #$accountId..." -ForegroundColor Yellow

$configScript = Join-Path $PSScriptRoot "configure-trading-account.ps1"
if (Test-Path $configScript) {
    try {
        & $configScript -AccountId $accountId
        Write-Host "  ✓ Account configured" -ForegroundColor Green
    } catch {
        Write-Host "  ⚠ Configuration step completed with warnings" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ⚠ Configuration script not found, skipping..." -ForegroundColor Yellow
}

Write-Host ""

# Step 2: Launch trading system
Write-Host "[2/2] Launching Exness trading system..." -ForegroundColor Yellow

$launchScript = Join-Path $PSScriptRoot "launch-exness-trading.ps1"
if (Test-Path $launchScript) {
    Write-Host "  Starting launch script..." -ForegroundColor Cyan
    Write-Host ""
    & $launchScript
} else {
    Write-Host "  ⚠ Launch script not found at: $launchScript" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Trying alternative: AUTO-START-VPS.bat..." -ForegroundColor Cyan
    $altScript = Join-Path $PSScriptRoot "AUTO-START-VPS.bat"
    if (Test-Path $altScript) {
        Start-Process -FilePath $altScript -Wait
    } else {
        Write-Host "  ✗ No launch script found" -ForegroundColor Red
        Write-Host ""
        Write-Host "  📝 Manual Steps:" -ForegroundColor Yellow
        Write-Host "    1. Open MetaTrader 5 EXNESS Terminal" -ForegroundColor White
        Write-Host "    2. Login with account #$accountId" -ForegroundColor White
        Write-Host "    3. Load Expert Advisors from trading-bridge/mql5/Experts/" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Trading Account #$accountId Ready!" -ForegroundColor Green
Write-Host "════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
