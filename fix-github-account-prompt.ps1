# Quick Fix for GitHub Account Selection
# Automatically configures Git to use Mouy-leng account

Write-Host "`n╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Quick Fix: GitHub Account Setup        ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "This will configure Git to always use: Mouy-leng" -ForegroundColor Yellow
Write-Host "You won't be asked to choose between accounts anymore.`n" -ForegroundColor White

# Run the configuration script
$scriptPath = Join-Path $PSScriptRoot "configure-github-account.ps1"

if (Test-Path $scriptPath) {
    Write-Host "Running configuration..." -ForegroundColor Cyan
    & $scriptPath -Account "Mouy-leng" -SetGlobal
} else {
    Write-Host "Error: configure-github-account.ps1 not found" -ForegroundColor Red
    Write-Host "Please ensure the script is in the same directory." -ForegroundColor Yellow
}

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
