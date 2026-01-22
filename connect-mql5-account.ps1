#Requires -Version 5.1
<#
.SYNOPSIS
    Interactive MQL5 Account Connection Guide for EXNESS MetaTrader 5.
.DESCRIPTION
    This script provides an interactive guide to connect your MQL5 account
    to the EXNESS MetaTrader 5 terminal and verifies the connection.
#>

$ErrorActionPreference = "Continue"

function Find-MT5DataDir {
    $mql5DataPath = "$env:APPDATA\MetaQuotes\Terminal"
    $mt5Directories = Get-ChildItem -Path $mql5DataPath -Directory -ErrorAction SilentlyContinue | Where-Object {
        $configPath = Join-Path $_.FullName "config"
        Test-Path $configPath
    }
    if ($mt5Directories) {
        return $mt5Directories[0].FullName
    }
    return $null
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Interactive MQL5 Account Connection" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$exnessTerminalPath = "C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe"
$verificationScriptName = "verify-mql5-assets.ps1"
$verificationScriptPath = Join-Path $PSScriptRoot $verificationScriptName

# Step 1: Verify EXNESS Terminal Installation
Write-Host "[1/4] Verifying EXNESS Terminal Installation..." -ForegroundColor Yellow
if (-not (Test-Path $exnessTerminalPath)) {
    Write-Host "    [ERROR] EXNESS Terminal not found at '$exnessTerminalPath'." -ForegroundColor Red
    Write-Host "    [INFO] Please install EXNESS Terminal from https://www.exness.com/ and try again." -ForegroundColor Cyan
    exit 1
}
Write-Host "    [OK] EXNESS Terminal is installed." -ForegroundColor Green

# Step 2: Instructions for MQL5 Account Login
Write-Host ""
Write-Host "[2/4] Manual Login Required" -ForegroundColor Yellow
Write-Host "----------------------------------------------------------------" -ForegroundColor Gray
Write-Host "To connect your MQL5 account, you need to log in manually inside the EXNESS Terminal."
Write-Host ""
Write-Host "Steps:" -ForegroundColor White
Write-Host "  1. Open EXNESS MetaTrader 5 Terminal."
Write-Host "  2. Go to 'Tools' -> 'Options' from the top menu."
Write-Host "  3. Click on the 'Community' tab."
Write-Host "  4. Enter your MQL5 username and password."
Write-Host "     - Your username is: lengkundee" -ForegroundColor Cyan
Write-Host "  5. Click 'OK' to save."
Write-Host "----------------------------------------------------------------" -ForegroundColor Gray
Write-Host ""

# Step 3: Launch EXNESS Terminal
$choice = Read-Host "Would you like to launch the EXNESS Terminal now? (Y/N)"
if ($choice -eq 'y' -or $choice -eq 'Y') {
    Write-Host "    [INFO] Starting EXNESS Terminal..." -ForegroundColor Cyan
    try {
        Start-Process -FilePath $exnessTerminalPath -ErrorAction Stop
        Write-Host "    [OK] EXNESS Terminal launched. Please follow the steps above to log in." -ForegroundColor Green
        Write-Host "    [INFO] After you have logged in, press any key to continue to the verification step..." -ForegroundColor Cyan
        [System.Console]::ReadKey($true) | Out-Null
    }
    catch {
        Write-Host "    [ERROR] Failed to launch EXNESS Terminal: $_" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "    [INFO] Skipping terminal launch. Please ensure you are logged into your MQL5 account before proceeding." -ForegroundColor Yellow
}

# Step 4: Verify Connection
Write-Host ""
Write-Host "[4/4] Verifying MQL5 Connection" -ForegroundColor Yellow
if (-not (Test-Path $verificationScriptPath)) {
    Write-Host "    [ERROR] Verification script '$verificationScriptName' not found." -ForegroundColor Red
    exit 1
}

$choice = Read-Host "Are you ready to run the verification script? (Y/N)"
if ($choice -eq 'y' -or $choice -eq 'Y') {
    Write-Host "    [INFO] Running verification script..." -ForegroundColor Cyan
    try {
        Invoke-Expression -Command "& '$verificationScriptPath'"
    }
    catch {
        Write-Host "    [ERROR] An error occurred while running the verification script: $_" -ForegroundColor Red
    }
} else {
    Write-Host "    [INFO] Skipping verification. You can run '.\$verificationScriptName' manually later." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Script execution completed." -ForegroundColor Green
