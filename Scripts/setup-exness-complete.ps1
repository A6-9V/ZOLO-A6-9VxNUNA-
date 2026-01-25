# Main orchestration script for setting up the EXNESS MetaTrader 5 environment.

# Function to display colored messages
function Write-Log {
    param (
        [string]$Message,
        [string]$Level = "INFO"
    )
    $color = "White"
    switch ($Level) {
        "OK" { $color = "Green" }
        "INFO" { $color = "Cyan" }
        "WARNING" { $color = "Yellow" }
        "ERROR" { $color = "Red" }
    }
    Write-Host "[$Level] $Message" -ForegroundColor $color
}

# --- Main Script ---
Clear-Host
Write-Log "Welcome to the EXNESS MetaTrader 5 Setup Script." "INFO"
Write-Log "This script will guide you through connecting your MQL5 account." "INFO"
Write-Log "------------------------------------------------------------" "INFO"

try {
    # Step 1: Set MQL5 Credentials
    Write-Log "Step 1: Setting MQL5 Account Credentials..." "INFO"
    $credentialScript = Join-Path $PSScriptRoot "set-mt5-credentials.ps1"
    if (Test-Path $credentialScript) {
        & $credentialScript
        Write-Log "MQL5 credentials script executed." "OK"
    } else {
        Write-Log "set-mt5-credentials.ps1 not found. Skipping." "WARNING"
    }
    Read-Host "Press Enter to continue to the next step..."

    # Step 2: Manual Login Instructions
    Clear-Host
    Write-Log "Step 2: Manual Login to MetaTrader 5 Terminal" "INFO"
    Write-Log "The next step is to log in to your MQL5 account within the MetaTrader 5 terminal." "INFO"
    Write-Log "This is a manual process and cannot be automated." "INFO"
    Write-Host ""
    Write-Log "Please follow these instructions carefully:" "INFO"
    Write-Log "1. Open the MetaTrader 5 EXNESS terminal." "INFO"
    Write-Log "2. Go to 'Tools' -> 'Options'." "INFO"
    Write-Log "3. Click on the 'Community' tab." "INFO"
    Write-Log "4. Enter your MQL5 username ('lengkundee') and your password." "INFO"
    Write-Log "5. Click 'OK' to connect." "INFO"
    Write-Host ""
    Read-Host "Once you have completed these steps, press Enter to continue..."

    # Step 3: Verify Connection
    Clear-Host
    Write-Log "Step 3: Verifying MQL5 Connection..." "INFO"
    $verificationScript = Join-Path $PSScriptRoot "verify-mql5-connection.ps1"
    if (Test-Path $verificationScript) {
        & $verificationScript
        Write-Log "Verification script executed." "OK"
    } else {
        Write-Log "verify-mql5-connection.ps1 not found. Skipping." "WARNING"
    }
    Read-Host "Press Enter to complete the setup..."

    # Final Step
    Clear-Host
    Write-Log "Setup Complete!" "OK"
    Write-Log "Your MQL5 account should now be connected to the MetaTrader 5 terminal." "OK"
    Write-Log "Thank you for using the setup script." "INFO"

} catch {
    Write-Log "An unexpected error occurred during setup." "ERROR"
    Write-Log $_.Exception.Message "ERROR"
}
