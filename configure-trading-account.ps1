# Configure Trading Account for Exness
# Sets up trading account #405347405 in the configuration

param(
    [Parameter(Mandatory=$false)]
    [string]$AccountId = "405347405",
    
    [Parameter(Mandatory=$false)]
    [string]$ApiKey,
    
    [Parameter(Mandatory=$false)]
    [string]$ApiSecret
)

$ErrorActionPreference = "Stop"

Write-Host "`n╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Configure Trading Account               ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝`n" -ForegroundColor Cyan

$configPath = Join-Path $PSScriptRoot "trading-bridge\config\brokers.json"

if (-not (Test-Path $configPath)) {
    Write-Host "Error: Configuration file not found at $configPath" -ForegroundColor Red
    exit 1
}

Write-Host "Configuring trading account: #$AccountId" -ForegroundColor Yellow
Write-Host ""

# Read current configuration
try {
    $config = Get-Content $configPath -Raw | ConvertFrom-Json
    
    Write-Host "[1/3] Current configuration:" -ForegroundColor Yellow
    Write-Host "  Account ID: $($config.brokers[0].account_id)" -ForegroundColor Gray
    Write-Host "  API Key: $($config.brokers[0].api_key)" -ForegroundColor Gray
    Write-Host "  API Secret: $($config.brokers[0].api_secret)" -ForegroundColor Gray
    Write-Host ""
    
    # Update account ID
    Write-Host "[2/3] Updating configuration..." -ForegroundColor Yellow
    $config.brokers[0].account_id = $AccountId
    
    if ($ApiKey) {
        $config.brokers[0].api_key = $ApiKey
        Write-Host "  ✓ API Key updated" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ API Key not provided (keeping current value)" -ForegroundColor Yellow
    }
    
    if ($ApiSecret) {
        $config.brokers[0].api_secret = $ApiSecret
        Write-Host "  ✓ API Secret updated" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ API Secret not provided (keeping current value)" -ForegroundColor Yellow
    }
    
    Write-Host "  ✓ Account ID updated to: #$AccountId" -ForegroundColor Green
    Write-Host ""
    
    # Save configuration
    Write-Host "[3/3] Saving configuration..." -ForegroundColor Yellow
    $config | ConvertTo-Json -Depth 10 | Set-Content $configPath -Encoding UTF8
    Write-Host "  ✓ Configuration saved" -ForegroundColor Green
    
} catch {
    Write-Host "`nError updating configuration: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`n╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Configuration Updated!                  ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "📋 Updated Configuration:" -ForegroundColor Yellow
Write-Host "  Account ID: #$AccountId" -ForegroundColor White
if ($ApiKey) {
    Write-Host "  API Key: $($ApiKey.Substring(0, [Math]::Min(10, $ApiKey.Length)))..." -ForegroundColor White
} else {
    Write-Host "  API Key: (not updated - use existing or set manually)" -ForegroundColor Gray
}
if ($ApiSecret) {
    Write-Host "  API Secret: ****** (hidden)" -ForegroundColor White
} else {
    Write-Host "  API Secret: (not updated - use existing or set manually)" -ForegroundColor Gray
}
Write-Host ""

Write-Host "🔐 Security Reminder:" -ForegroundColor Yellow
Write-Host "  • This configuration is local only (not committed to git)" -ForegroundColor White
Write-Host "  • Keep your API credentials secure" -ForegroundColor White
Write-Host "  • Never share your API key or secret" -ForegroundColor White
Write-Host ""

Write-Host "🚀 Next Steps:" -ForegroundColor Yellow
Write-Host "  1. If you haven't provided API credentials, get them from:" -ForegroundColor White
Write-Host "     https://www.exness.com/accounts/api" -ForegroundColor Cyan
Write-Host "  2. Run this script again with -ApiKey and -ApiSecret parameters" -ForegroundColor White
Write-Host "  3. Verify account in MT5 Terminal" -ForegroundColor White
Write-Host "  4. Launch trading with:" -ForegroundColor White
Write-Host "     .\launch-exness-trading.ps1" -ForegroundColor Cyan
Write-Host "     or" -ForegroundColor Gray
Write-Host "     .\AUTO-START-VPS.bat" -ForegroundColor Cyan
Write-Host ""

Write-Host "💡 Usage Example:" -ForegroundColor Yellow
Write-Host "  .\configure-trading-account.ps1 -AccountId '405347405' -ApiKey 'your_key' -ApiSecret 'your_secret'" -ForegroundColor Gray
Write-Host ""
