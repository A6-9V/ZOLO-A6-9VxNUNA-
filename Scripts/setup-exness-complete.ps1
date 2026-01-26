# ==============================================================================
#
#  MQL5 Account Setup Script for EXNESS MetaTrader 5
#  Copyright 2024, LengKundee
#
#  Purpose:
#  This script automates the initial setup for the EXNESS MetaTrader 5
#  terminal by configuring the necessary MQL5 scripts with the user's
#  account information. It then provides clear, step-by-step instructions
#  for the user to complete the login process manually within the MT5
#  terminal.
#
#  Usage:
#  Run this script from a PowerShell terminal on your Windows VPS where the
#  EXNESS MetaTrader 5 terminal is installed.
#
# ==============================================================================

# --- Configuration ---
$Mql5ScriptPath = "Scripts\AccountSetup_411534497.mq5"
$Mt5TerminalPath = "C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe"
$Mql5Username = "lengkundee"

# --- Functions ---

# Function to display colored status messages
function Write-Status {
    param (
        [string]$Type,
        [string]$Message
    )

    $color = switch ($Type) {
        "INFO"    { "Cyan" }
        "OK"      { "Green" }
        "WARNING" { "Yellow" }
        "ERROR"   { "Red" }
        default   { "White" }
    }

    Write-Host "[$Type] " -ForegroundColor $color -NoNewline
    Write-Host $Message
}

# --- Script Start ---

Clear-Host
Write-Host "========================================================"
Write-Host "  Welcome to the EXNESS MetaTrader 5 Account Setup  "
Write-Host "========================================================"
Write-Host

# --- Step 1: Get MT5 Account Number ---
Write-Status "INFO" "This script will guide you through setting up your account."

$mt5Account = ""
while (-not ($mt5Account -match "^\d+$")) {
    $mt5Account = Read-Host "Please enter your MetaTrader 5 Account Number"
    if (-not ($mt5Account -match "^\d+$")) {
        Write-Status "ERROR" "Invalid input. Please enter numbers only."
    }
}

Write-Status "OK" "MetaTrader 5 Account Number set to: $mt5Account"
Write-Host

# --- Step 2: Update MQL5 Script ---
Write-Status "INFO" "Updating the account setup MQL5 script..."

try {
    if (-not (Test-Path $Mql5ScriptPath)) {
        throw "The MQL5 script at '$Mql5ScriptPath' was not found."
    }

    # Read, update, and write back to the MQL5 script
    $scriptContent = Get-Content $Mql5ScriptPath -Raw
    $newScriptContent = $scriptContent.Replace("{{MT5_ACCOUNT}}", $mt5Account)
    Set-Content -Path $Mql5ScriptPath -Value $newScriptContent

    Write-Status "OK" "Successfully updated '$Mql5ScriptPath' with your account number."
}
catch {
    Write-Status "ERROR" "An error occurred while updating the MQL5 script."
    Write-Status "ERROR" $_.Exception.Message
    Write-Host
    Write-Status "WARNING" "Please ensure the repository structure is correct and run the script again."
    exit 1
}

Write-Host

# --- Step 3: Display Manual Instructions ---
Write-Host "========================================================"
Write-Host "  Action Required: Manual Login and Verification  "
Write-Host "========================================================"
Write-Host
Write-Status "INFO" "The automated setup is complete. Please follow these manual steps:"
Write-Host

Write-Host "1. Open the EXNESS MetaTrader 5 Terminal."
Write-Host "   - If it's not open, you can find it at:"
Write-Host "     `"$Mt5TerminalPath`""
Write-Host

Write-Host "2. Login to your Trade Account:"
Write-Host "   - In the terminal, go to 'File' -> 'Login to Trade Account'."
Write-Host "   - Login: $mt5Account"
Write-Host "   - Password: [Enter your trading account password]"
Write-Host "   - Server: Exness-MT5Real8"
Write-Host "   - Click 'OK'."
Write-Host

Write-Host "3. Connect to your MQL5 Community Account:"
Write-Host "   - In the terminal, go to 'Tools' -> 'Options'."
Write-Host "   - Navigate to the 'Community' tab."
Write-Host "   - Login: $Mql5Username"
Write-Host "   - Password: [Enter your MQL5 community password]"
Write-Host "   - Click 'OK'."
Write-Host

Write-Host "4. Verify the Connection with the MQL5 Script:"
Write-Host "   - In the 'Navigator' panel on the left, find the 'Scripts' section."
Write-Host "   - Right-click on 'Scripts' and select 'Refresh'."
Write-Host "   - Find the script named 'AccountSetup_411534497'."
Write-Host "   - Drag the script onto any open chart window."
Write-Host "   - Go to the 'Experts' tab at the bottom of the Terminal window."
Write-Host "   - Look for a message confirming 'Account $mt5Account is connected!'"
Write-Host

Write-Host "========================================================"
Write-Status "OK" "Setup instructions complete. Please follow the steps above."
Write-Host "========================================================"
Write-Host
