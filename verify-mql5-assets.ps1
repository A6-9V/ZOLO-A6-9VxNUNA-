#Requires -Version 5.1
<#
.SYNOPSIS
    Verifies the existence of downloaded MQL5 Market assets.
.DESCRIPTION
    This script checks for the MQL5 Market folder in the EXNESS
    MetaTrader 5 data directory and lists any downloaded products.
#>

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MQL5 Assets Verification" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$mql5DataPath = "$env:APPDATA\MetaQuotes\Terminal"

# Step 1: Locate MT5 Data Directory
Write-Host "[1/2] Locating MT5 Data Directory..." -ForegroundColor Yellow
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
        Write-Host "    [INFO] Please launch EXNESS Terminal at least once to create it." -ForegroundColor Yellow
        exit 1
    }
}
catch {
    Write-Host "    [ERROR] Failed to locate MT5 Data Directory: $_" -ForegroundColor Red
    exit 1
}

# Step 2: Check for MQL5 Market Assets
Write-Host ""
Write-Host "[2/2] Checking for Downloaded MQL5 Assets..." -ForegroundColor Yellow
$marketPath = Join-Path $mt5DataDir "MQL5\Market"

if (Test-Path $marketPath) {
    $downloadedAssets = Get-ChildItem -Path $marketPath | Select-Object -ExpandProperty Name

    if ($downloadedAssets) {
        Write-Host "    [OK] MQL5 Market folder found." -ForegroundColor Green
        Write-Host "    [INFO] Downloaded assets:" -ForegroundColor Cyan
        foreach ($asset in $downloadedAssets) {
            Write-Host "      - $asset" -ForegroundColor White
        }
    }
    else {
        Write-Host "    [OK] MQL5 Market folder found, but it's empty." -ForegroundColor Green
        Write-Host "    [INFO] You can download assets from the 'Market' tab in the terminal." -ForegroundColor Yellow
    }
}
else {
    Write-Host "    [WARNING] MQL5 Market folder not found." -ForegroundColor Yellow
    Write-Host "    [INFO] This means no assets have been downloaded from the MQL5 Market yet." -ForegroundColor Cyan
    Write-Host "    [INFO] Please connect your MQL5 account and download an asset first." -ForegroundColor Cyan
    Write-Host "    [INFO] Run 'connect-mql5-account.ps1' for instructions." -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Script execution completed." -ForegroundColor Green
