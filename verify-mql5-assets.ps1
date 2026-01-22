#Requires -Version 5.1
<#
.SYNOPSIS
    Verifies that MQL5 Market assets are available in the EXNESS Terminal.
.DESCRIPTION
    This script checks if the MQL5 account is connected and synchronized
    by looking for downloaded asset files in the MetaTrader 5 data directory.
#>

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MQL5 Assets Verification" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$mql5DataPath = "$env:APPDATA\MetaQuotes\Terminal"
$marketFolderName = "Market"

# Step 1: Find MT5 Data Directory
Write-Host "[1/3] Locating MT5 Data Directory..." -ForegroundColor Yellow
$mt5DataDir = $null
try {
    $mt5Directories = Get-ChildItem -Path $mql5DataPath -Directory -ErrorAction SilentlyContinue | Where-Object {
        $configPath = Join-Path $_.FullName "config"
        Test-Path $configPath
    }

    if ($mt5Directories) {
        $mt5DataDir = $mt5Directories[0].FullName
        Write-Host "    [OK] MT5 Data Directory found: $mt5DataDir" -ForegroundColor Green
    }
    else {
        Write-Host "    [ERROR] MT5 Data Directory not found." -ForegroundColor Red
        Write-Host "    [INFO] This is normal if EXNESS Terminal hasn't been launched yet." -ForegroundColor Cyan
        Write-Host "    [INFO] Please launch EXNESS Terminal, log in, and then run this script again." -ForegroundColor Cyan
        exit 1
    }
}
catch {
    Write-Host "    [ERROR] Failed to locate MT5 Data Directory: $_" -ForegroundColor Red
    exit 1
}

# Step 2: Check for Market Folder
Write-Host "[2/3] Checking for MQL5 Market folder..." -ForegroundColor Yellow
$marketPath = Join-Path $mt5DataDir "MQL5\$marketFolderName"
if (Test-Path $marketPath) {
    Write-Host "    [OK] Market folder found: $marketPath" -ForegroundColor Green
}
else {
    Write-Host "    [ERROR] Market folder not found." -ForegroundColor Red
    Write-Host "    [INFO] This may indicate that you haven't connected your MQL5 account yet." -ForegroundColor Cyan
    Write-Host "    [INFO] In EXNESS Terminal, go to 'Tools' -> 'Options' -> 'Community' to log in." -ForegroundColor Cyan
    exit 1
}

# Step 3: Verify Downloaded Assets
Write-Host "[3/3] Verifying downloaded assets..." -ForegroundColor Yellow
try {
    $marketFiles = Get-ChildItem -Path $marketPath -Filter "*.dat" -Recurse -ErrorAction SilentlyContinue
    if ($marketFiles.Count -gt 0) {
        Write-Host "    [OK] Found $($marketFiles.Count) market asset file(s)." -ForegroundColor Green
        Write-Host "    [SUCCESS] Your MQL5 account appears to be connected and synchronized." -ForegroundColor Green
    }
    else {
        Write-Host "    [WARNING] No downloaded market assets found (*.dat files)." -ForegroundColor Yellow
        Write-Host "    [INFO] Please ensure you have purchased or downloaded assets from the MQL5 Market." -ForegroundColor Cyan
        Write-Host "    [INFO] After downloading, restart your terminal and run this script again." -ForegroundColor Cyan
    }
}
catch {
    Write-Host "    [ERROR] An error occurred while checking for asset files: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "Verification complete." -ForegroundColor Green
