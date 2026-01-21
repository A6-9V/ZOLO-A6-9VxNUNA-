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

# Configuration
$exnessTerminalPath = "C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe"
$mql5DataPath = "$env:APPDATA\MetaQuotes\Terminal"

# Verify EXNESS Terminal Installation
Write-Host "[1/3] Verifying EXNESS Terminal Installation..." -ForegroundColor Yellow
if (-not (Test-Path $exnessTerminalPath)) {
    Write-Host "    [ERROR] EXNESS Terminal not found!" -ForegroundColor Red
    Write-Host "    [INFO] Expected location: $exnessTerminalPath" -ForegroundColor Yellow
    Write-Host "    [INFO] Please install EXNESS Terminal and run this script again." -ForegroundColor Yellow
    exit 1
}
else {
    Write-Host "    [OK] EXNESS Terminal found." -ForegroundColor Green
}

# Instructions for MQL5 Account Login
Write-Host ""
Write-Host "[2/3] How to Connect Your MQL5 Account:" -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Gray
Write-Host "1. Open EXNESS MetaTrader 5 Terminal." -ForegroundColor White
Write-Host "2. Go to 'Tools' -> 'Options' from the top menu." -ForegroundColor White
Write-Host "3. Click on the 'Community' tab." -ForegroundColor White
Write-Host "4. Enter your MQL5 username and password." -ForegroundColor White
Write-Host "   - Your username is: lengkundee" -ForegroundColor Cyan
Write-Host "5. Click 'OK' to save." -ForegroundColor White
Write-Host ""
Write-Host "After logging in, your purchased assets will be available in the" -ForegroundColor Green
Write-Host "'Market' section of the 'Toolbox' window (usually at the bottom)." -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Gray

# Locate MQL5 Market folder
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

# Offer to launch EXNESS terminal
Write-Host ""
Write-Host "[3/3] Launch EXNESS Terminal?" -ForegroundColor Yellow
$choice = Read-Host "    (Y)es / (N)o"

if ($choice -eq 'y' -or $choice -eq 'Y') {
    Write-Host "    [INFO] Starting EXNESS Terminal..." -ForegroundColor Cyan
    Start-Process -FilePath $exnessTerminalPath
    Write-Host "    [OK] EXNESS Terminal launched." -ForegroundColor Green
} else {
    Write-Host "    [INFO] Skipping terminal launch." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Script execution completed." -ForegroundColor Green
