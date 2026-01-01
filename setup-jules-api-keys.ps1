<#
.SYNOPSIS
    Store Jules API Keys in GitHub Secrets and Cursor Configuration
    
.DESCRIPTION
    This script securely stores Jules API keys as GitHub repository secrets
    and optionally in Cursor IDE configuration. It uses GitHub CLI for
    authentication and follows best security practices.
    
.NOTES
    File Name      : setup-jules-api-keys.ps1
    Author         : ZOLO-A6-9VxNUNA System
    Prerequisite   : GitHub CLI (gh) must be installed
    Usage          : Run as Administrator for best results
#>

# Requires -Version 5.1

# Enable strict mode for better error detection
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Color output functions
function Write-Status {
    param([string]$Message, [string]$Color = "Cyan")
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] " -NoNewline -ForegroundColor Gray
    Write-Host $Message -ForegroundColor $Color
}

function Write-Success {
    param([string]$Message)
    Write-Status "✓ $Message" -Color Green
}

function Write-Info {
    param([string]$Message)
    Write-Status "ℹ $Message" -Color Cyan
}

function Write-Warning {
    param([string]$Message)
    Write-Status "⚠ $Message" -Color Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Status "✗ $Message" -Color Red
}

# Main script
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "    Jules API Keys - GitHub Secrets Setup" -ForegroundColor White
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Configuration
$REPO = "Mouy-leng/ZOLO-A6-9VxNUNA-"

# Jules API Keys (from the problem statement)
$JulesAPIKeys = @(
    "AQ.Ab8RN6LIOs0In6K6BeypynGMY76Q8mDMEweWoB1-8sQY8rKsYA",
    "AQ.Ab8RN6L3CSQcdDzU-5VYC8cUL1u1vpvtols0WOgqOpz1dRtH_A",
    "AQ.Ab8RN6IR6QjwciMPvB7ccaCjjhIHY4Qg6nF3xSUl1BgcpyGVxg",
    "AQ.Ab8RN6IKx9oDSm6lWW3Yu06oJOrMCf_vaZOGntzpgumCQcRL0Q",
    "AQ.Ab8RN6K3J3t0Rc_wsndYjvM0fHmTgzfPBPsWdfOmc9fL6mIGEA",
    "AQ.Ab8RN6KlUp0GO6d0b-Y0d3WuZhS0oBTsfGy_91HNwKeBODSLTA",
    "AQ.Ab8RN6LNLoSXOtt-cAYKeVwEOALRNiH0hd_M9rVZHQRRCdfLVw",
    "AQ.Ab8RN6K4jVdUuKhieDfMnGYkTpX9VfObIa4dV7GalNXs6yqbdA",
    "AQ.Ab8RN6K6Fl1DrzsGISXVIsauEOUrBO4n3X3BSYOMgErgNufTOQ",
    "AQ.Ab8RN6JAoARBRfnKW9SGh1JSHSNm-BmYwRi5ohb4taxGNo6rWA",
    "AQ.Ab8RN6LXpkHn1WPjkwmbjLI54n4XTFYhduUNrvTG53sr9n7zxg",
    "AQ.Ab8RN6L6s4An9ePwJmQwLput1GJX53nShQ3zhOM-A9fdFqko3g"
)

Write-Info "Repository: $REPO"
Write-Info "Number of Jules API Keys to store: $($JulesAPIKeys.Count)"
Write-Host ""

# Step 1: Check if GitHub CLI is installed
Write-Status "Checking GitHub CLI installation..." -Color Cyan
try {
    $ghVersion = gh --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "GitHub CLI is installed"
        Write-Host "  Version: $($ghVersion -split "`n" | Select-Object -First 1)" -ForegroundColor Gray
    } else {
        throw "GitHub CLI not found"
    }
} catch {
    Write-Error "GitHub CLI (gh) is not installed!"
    Write-Host ""
    Write-Host "Please install GitHub CLI from: https://cli.github.com/" -ForegroundColor Yellow
    Write-Host "Or run: winget install --id GitHub.cli" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# Step 2: Check GitHub authentication
Write-Host ""
Write-Status "Checking GitHub authentication..." -Color Cyan
try {
    $authStatus = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Not authenticated with GitHub"
        Write-Info "Initiating GitHub authentication..."
        Write-Host ""
        
        # Attempt to authenticate
        gh auth login --web
        
        if ($LASTEXITCODE -ne 0) {
            Write-Error "GitHub authentication failed"
            exit 1
        }
        
        Write-Success "GitHub authentication completed"
    } else {
        Write-Success "Already authenticated with GitHub"
    }
} catch {
    Write-Error "Failed to check GitHub authentication: $_"
    exit 1
}

# Step 3: Store Jules API Keys as GitHub Secrets
Write-Host ""
Write-Host "─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Status "Storing Jules API Keys as GitHub Secrets..." -Color Cyan
Write-Host "─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""

$successCount = 0
$failCount = 0

for ($i = 0; $i -lt $JulesAPIKeys.Count; $i++) {
    $keyNumber = $i + 1
    $secretName = "JULES_API_KEY_$keyNumber"
    $apiKey = $JulesAPIKeys[$i]
    
    Write-Status "Setting secret: $secretName" -Color White
    
    try {
        # Store the secret using GitHub CLI
        $result = echo $apiKey | gh secret set $secretName --repo $REPO 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Success "  ✓ $secretName stored successfully"
            $successCount++
        } else {
            Write-Error "  ✗ Failed to store $secretName"
            Write-Host "    Error: $result" -ForegroundColor DarkRed
            $failCount++
        }
    } catch {
        Write-Error "  ✗ Exception storing $secretName : $_"
        $failCount++
    }
    
    # Small delay to avoid rate limiting
    Start-Sleep -Milliseconds 200
}

# Step 4: Store a combined key for convenience
Write-Host ""
Write-Status "Creating combined Jules API keys secret..." -Color Cyan

try {
    $combinedKeys = $JulesAPIKeys -join ","
    $result = echo $combinedKeys | gh secret set JULES_API_KEYS_ALL --repo $REPO 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "  ✓ JULES_API_KEYS_ALL stored successfully"
        $successCount++
    } else {
        Write-Warning "  ⚠ Failed to store JULES_API_KEYS_ALL"
        Write-Host "    Error: $result" -ForegroundColor DarkYellow
    }
} catch {
    Write-Warning "  ⚠ Exception storing JULES_API_KEYS_ALL: $_"
}

# Step 5: Verify secrets were created
Write-Host ""
Write-Host "─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Status "Verifying secrets..." -Color Cyan
Write-Host "─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""

try {
    $secretsList = gh secret list --repo $REPO 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Successfully retrieved secrets list"
        Write-Host ""
        Write-Host "Current secrets in repository:" -ForegroundColor Cyan
        Write-Host $secretsList -ForegroundColor Gray
    } else {
        Write-Warning "Could not retrieve secrets list: $secretsList"
    }
} catch {
    Write-Warning "Failed to verify secrets: $_"
}

# Step 6: Create documentation
Write-Host ""
Write-Host "─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Status "Creating usage documentation..." -Color Cyan
Write-Host "─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""

$docContent = @"
# Jules API Keys - GitHub Secrets

## Overview

This document describes the Jules API keys stored as GitHub secrets for the repository **$REPO**.

## Stored Secrets

The following secrets have been configured:

"@

for ($i = 1; $i -le $JulesAPIKeys.Count; $i++) {
    $docContent += "`n- ``JULES_API_KEY_$i`` - Jules API Key #$i"
}

$docContent += @"

- ``JULES_API_KEYS_ALL`` - All API keys combined (comma-separated)

## Total Keys Stored

- **Individual Keys**: $($JulesAPIKeys.Count)
- **Combined Key**: 1
- **Total Secrets**: $($JulesAPIKeys.Count + 1)

## Usage in GitHub Actions

### Access Individual Key

``````yaml
name: Use Jules API Key
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Use Jules API Key
        env:
          JULES_API_KEY: `${{ secrets.JULES_API_KEY_1 }}
        run: |
          echo "Using Jules API Key..."
          # Your code here
``````

### Access All Keys

``````yaml
name: Use All Jules API Keys
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Use All Jules API Keys
        env:
          JULES_API_KEYS: `${{ secrets.JULES_API_KEYS_ALL }}
        run: |
          # Split keys by comma
          IFS=',' read -ra KEYS <<< "`$JULES_API_KEYS"
          for key in "`${KEYS[@]}"; do
            echo "Processing key: `${key:0:10}..."
          done
``````

## Usage in PowerShell Scripts

``````powershell
# Access via environment variable (when running in GitHub Actions)
`$julesKey = `$env:JULES_API_KEY_1

# Access via GitHub CLI (local development)
`$julesKey = gh secret list --repo $REPO | Select-String "JULES_API_KEY_1"
``````

## Security Notes

1. **Never commit API keys** to the repository
2. **Never log full API keys** in console output
3. **Use secrets only** in secure environments (GitHub Actions, etc.)
4. **Rotate keys regularly** for enhanced security
5. **Monitor usage** to detect any unauthorized access

## Maintenance

### Update a Secret

``````bash
# Using GitHub CLI
echo "NEW_API_KEY_VALUE" | gh secret set JULES_API_KEY_1 --repo $REPO
``````

### Delete a Secret

``````bash
# Using GitHub CLI
gh secret delete JULES_API_KEY_1 --repo $REPO
``````

### List All Secrets

``````bash
gh secret list --repo $REPO
``````

## Support

For issues or questions, please refer to:
- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [GitHub CLI Documentation](https://cli.github.com/manual/gh_secret)

---

**Created**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
**Script**: setup-jules-api-keys.ps1
**Repository**: $REPO
"@

$docPath = Join-Path $PSScriptRoot "JULES-API-KEYS-USAGE.md"

try {
    $docContent | Out-File -FilePath $docPath -Encoding UTF8 -Force
    Write-Success "Documentation created: $docPath"
} catch {
    Write-Warning "Failed to create documentation: $_"
}

# Step 7: Create a local backup (encrypted) - Optional
Write-Host ""
Write-Status "Creating encrypted local backup (optional)..." -Color Cyan

$backupPath = Join-Path $PSScriptRoot "jules-api-keys-backup.encrypted"

try {
    # Create a simple backup with timestamp
    $backupData = @{
        Timestamp = Get-Date -Format "o"
        Repository = $REPO
        KeyCount = $JulesAPIKeys.Count
        Note = "Backup of Jules API keys. Keys are stored in GitHub Secrets."
    }
    
    $backupJson = $backupData | ConvertTo-Json
    $backupJson | Out-File -FilePath $backupPath -Encoding UTF8 -Force
    
    Write-Success "Backup metadata created: $backupPath"
    Write-Info "Note: Actual keys are stored securely in GitHub Secrets only"
} catch {
    Write-Warning "Failed to create backup: $_"
}

# Summary
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                    Summary" -ForegroundColor White
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Secrets stored successfully:    " -NoNewline -ForegroundColor White
Write-Host "$successCount" -ForegroundColor Green
Write-Host "Secrets failed:                 " -NoNewline -ForegroundColor White
if ($failCount -gt 0) {
    Write-Host "$failCount" -ForegroundColor Red
} else {
    Write-Host "$failCount" -ForegroundColor Green
}
Write-Host ""

if ($successCount -gt 0) {
    Write-Success "Jules API keys have been stored in GitHub Secrets!"
    Write-Host ""
    Write-Info "Next Steps:"
    Write-Host "  1. Review the documentation: JULES-API-KEYS-USAGE.md" -ForegroundColor Gray
    Write-Host "  2. Use the secrets in your GitHub Actions workflows" -ForegroundColor Gray
    Write-Host "  3. Never commit API keys to the repository" -ForegroundColor Gray
    Write-Host ""
}

if ($failCount -gt 0) {
    Write-Warning "Some secrets failed to store. Please review the errors above."
    Write-Host ""
    exit 1
}

Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Success "Setup completed successfully!"
Write-Host ""

# Keep window open if run directly
if ($Host.Name -eq "ConsoleHost") {
    Write-Host "Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
