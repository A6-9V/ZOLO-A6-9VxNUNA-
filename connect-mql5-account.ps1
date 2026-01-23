#Requires -Version 5.1
<#
.SYNOPSIS
    MQL5 Account Connection Guide for EXNESS MetaTrader 5.
.DESCRIPTION
    This script provides instructions on how to connect your MQL5 account
    to the EXNESS MetaTrader 5 terminal to access purchased assets.
#>

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MQL5 Account Connection Guide" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration variables
$exnessTerminalPath = "C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe" # Path to the EXNESS MetaTrader 5 terminal executable
$mql5DataPath = "$env:APPDATA\MetaQuotes\Terminal" # Path to the MetaQuotes data directory

# Step 1: Verify EXNESS Terminal Installation
# Checks if the EXNESS MetaTrader 5 terminal is installed at the expected location.
Write-Host "[1/4] Verifying EXNESS Terminal Installation..." -ForegroundColor Yellow
if (-not (Test-Path $exnessTerminalPath)) {
    Write-Host "    [ERROR] EXNESS Terminal not found!" -ForegroundColor Red
    Write-Host "    [INFO] Expected location: $exnessTerminalPath" -ForegroundColor Yellow
    Write-Host "    [INFO] Please install EXNESS Terminal and run this script again." -ForegroundColor Yellow
    exit 1
}
else {
    Write-Host "    [OK] EXNESS Terminal found." -ForegroundColor Green
}

# Step 2: Check if Terminal is already running
# Checks if the EXNESS MetaTrader 5 terminal process is already running.
Write-Host ""
Write-Host "[2/4] Checking Terminal Status..." -ForegroundColor Yellow
$exnessProcess = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
if ($exnessProcess) {
    Write-Host "    [OK] EXNESS Terminal is already running." -ForegroundColor Green
}
else {
    Write-Host "    [INFO] EXNESS Terminal is not running." -ForegroundColor Cyan
}

# Step 3: Instructions for MQL5 Account Login
# Provides manual instructions for connecting the MQL5 account in the terminal.
Write-Host ""
Write-Host "[3/4] How to Connect Your MQL5 Account:" -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Gray
Write-Host "The following steps must be performed manually inside the EXNESS Terminal." -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Open the EXNESS MetaTrader 5 Terminal." -ForegroundColor White
Write-Host "   (This script can launch it for you in the next step)."
Write-Host ""
Write-Host "2. In the top menu, click on 'Tools', then select 'Options'." -ForegroundColor White
Write-Host "   A new window will appear."
Write-Host ""
Write-Host "3. In the Options window, click on the 'Community' tab." -ForegroundColor White
Write-Host ""
Write-Host "4. Enter your MQL5 login credentials:" -ForegroundColor White
Write-Host "   - Login:    lengkundee" -ForegroundColor Cyan
Write-Host "   - Password: [Enter your MQL5 password]" -ForegroundColor White
Write-Host ""
Write-Host "5. Click 'OK' to save and connect." -ForegroundColor White
Write-Host "----------------------------------------" -ForegroundColor Gray
Write-Host ""
Write-Host "[SUCCESS] Once connected, your purchased assets from the MQL5" -ForegroundColor Green
Write-Host "          Market will be available in the 'Market' section of" -ForegroundColor Green
Write-Host "          the 'Toolbox' window (usually at the bottom of the terminal)." -ForegroundColor Green
Write-Host ""

# Locate MQL5 Market folder
# Attempts to find the MQL5 Market directory to inform the user where their purchased assets will be stored.
try {
    $mt5Directories = Get-ChildItem -Path $mql5DataPath -Directory -ErrorAction SilentlyContinue | Where-Object {
        $configPath = Join-Path $_.FullName "config"
        Test-Path $configPath
    }

    if ($mt5Directories) {
        $mt5DataDir = $mt5Directories[0].FullName
        $marketPath = Join-Path $mt5DataDir "MQL5\Market"
        Write-Host ""
        Write-Host "[INFO] Your MQL5 assets will be downloaded to:" -ForegroundColor Cyan
        Write-Host $marketPath -ForegroundColor White
    }
}
catch {
    Write-Host "[WARNING] Could not automatically locate the MQL5 Market directory." -ForegroundColor Yellow
}

# Step 4: Offer to launch EXNESS terminal
# Prompts the user to launch the EXNESS MetaTrader 5 terminal if it is not already running.
Write-Host ""
Write-Host "[4/4] Launch EXNESS Terminal?" -ForegroundColor Yellow
if ($exnessProcess) {
    Write-Host "    [INFO] EXNESS Terminal is already running. No action needed." -ForegroundColor Cyan
}
else {
    $choice = Read-Host "    (Y)es / (N)o"
    if ($choice -eq 'y' -or $choice -eq 'Y') {
        Write-Host "    [INFO] Starting EXNESS Terminal..." -ForegroundColor Cyan
        Start-Process -FilePath $exnessTerminalPath
        Write-Host "    [OK] EXNESS Terminal launched." -ForegroundColor Green
    }
    else {
        Write-Host "    [INFO] Skipping terminal launch." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Script execution completed." -ForegroundColor Green
