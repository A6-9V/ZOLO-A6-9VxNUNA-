# Helper script to set and confirm the MQL5 username.

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
Write-Log "--- MQL5 Account Setup ---" "INFO"
Write-Log "This script will confirm your MQL5 username." "INFO"
Write-Host ""

try {
    # Expected username
    $expectedUsername = "lengkundee"
    Write-Log "The MQL5 username for this setup is: $expectedUsername" "INFO"
    Write-Host ""

    # Prompt the user to confirm
    $userInput = Read-Host "Please type your MQL5 username to confirm"

    if ($userInput -eq $expectedUsername) {
        # Set an environment variable for the session
        $env:MQL5_USERNAME = $userInput
        Write-Log "Username '$($env:MQL5_USERNAME)' has been confirmed and set for this session." "OK"
    } else {
        Write-Log "The entered username '$userInput' does not match the expected username '$expectedUsername'." "WARNING"
        Write-Log "Please ensure you use the correct username in the MetaTrader 5 terminal." "WARNING"
    }

    Write-Host ""
    Write-Log "You will need your MQL5 password for the next manual step." "INFO"
    Write-Log "This script will not ask for your password." "INFO"

} catch {
    Write-Log "An error occurred while setting credentials." "ERROR"
    Write-Log $_.Exception.Message "ERROR"
}
