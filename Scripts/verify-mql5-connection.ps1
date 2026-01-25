# Helper script to guide the user in verifying the MQL5 connection.

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
Write-Log "--- MQL5 Connection Verification ---" "INFO"
Write-Log "Please follow the steps below to verify that your MQL5 account is connected." "INFO"
Write-Host ""

try {
    # Manual verification checklist
    Write-Log "Manual Verification Checklist:" "INFO"
    Write-Log "1. In the MetaTrader 5 terminal, look at the 'Navigator' window." "INFO"
    Write-Log "2. Under 'Accounts', you should see your MQL5 username 'lengkundee'." "INFO"
    Write-Log "3. Go to the 'Toolbox' window at the bottom of the screen." "INFO"
    Write-Log "4. Click on the 'Journal' tab." "INFO"
    Write-Log "5. Look for a log entry that says 'Community: authorization successful as lengkundee'." "INFO"
    Write-Host ""

    # Confirmation prompt
    $confirmation = Read-Host "Did you successfully verify the connection? (yes/no)"

    if ($confirmation -eq "yes") {
        Write-Log "Great! The MQL5 account is connected." "OK"
    } else {
        Write-Log "It seems the connection was not successful." "WARNING"
        Write-Log "Please double-check your username and password in 'Tools' -> 'Options' -> 'Community'." "WARNING"
        Write-Log "You can run the main setup script again if needed." "WARNING"
    }

} catch {
    Write-Log "An error occurred during the verification process." "ERROR"
    Write-Log $_.Exception.Message "ERROR"
}
