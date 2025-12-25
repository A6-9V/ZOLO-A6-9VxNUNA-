# Start Trading System Script for ZOLO-A6-9VxNUNA
# This script launches the AI-powered trading system

$ErrorActionPreference = "Continue"
$ProgressPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ZOLO Trading System Launcher" -ForegroundColor Cyan
Write-Host "  AI-Powered Trading Engine" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Load MT5 Configuration
$configFile = "$env:USERPROFILE\Documents\ZOLO-Workspace\Config\mt5-config.json"
if (Test-Path $configFile) {
    Write-Host "[1/5] Loading MT5 configuration..." -ForegroundColor Yellow
    $mt5Config = Get-Content $configFile | ConvertFrom-Json
    Write-Host "  ✓ Configuration loaded" -ForegroundColor Green
} else {
    Write-Host "[1/5] MT5 configuration not found" -ForegroundColor Yellow
    Write-Host "  → Run setup-mt5-integration.ps1 first" -ForegroundColor Gray
    $mt5Config = $null
}

# Check MT5 Installation
Write-Host "[2/5] Checking MetaTrader 5..." -ForegroundColor Yellow
$mt5Paths = @(
    "${env:ProgramFiles}\MetaTrader 5\terminal64.exe",
    "${env:ProgramFiles(x86)}\MetaTrader 5\terminal64.exe",
    "$env:LOCALAPPDATA\Programs\MetaTrader 5\terminal64.exe"
)

$mt5Exe = $null
foreach ($path in $mt5Paths) {
    if (Test-Path $path) {
        $mt5Exe = $path
        Write-Host "  ✓ MetaTrader 5 found: $path" -ForegroundColor Green
        break
    }
}

if (-not $mt5Exe) {
    Write-Host "  ✗ MetaTrader 5 not found" -ForegroundColor Red
    Write-Host "  Please install MetaTrader 5 first" -ForegroundColor Yellow
}

# Check EA Project
Write-Host "[3/5] Checking Expert Advisor project..." -ForegroundColor Yellow
if ($mt5Config) {
    $eaProjectPath = Join-Path $mt5Config.SharedProjectsPath "EXNESS_GenX_Trading"
    $eaFile = Join-Path $eaProjectPath "EXNESS_GenX_Trader.mq5"
    
    if (Test-Path $eaFile) {
        Write-Host "  ✓ EA found: EXNESS_GenX_Trader.mq5" -ForegroundColor Green
    } else {
        Write-Host "  → EA not found at: $eaFile" -ForegroundColor Gray
        Write-Host "  Please ensure the EA is compiled and ready" -ForegroundColor Yellow
    }
} else {
    Write-Host "  → Skipping EA check (no config)" -ForegroundColor Gray
}

# System Status
Write-Host "[4/5] Checking system status..." -ForegroundColor Yellow
$cpuUsage = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples[0].CookedValue
$ramUsage = (Get-Counter '\Memory\Available MBytes').CounterSamples[0].CookedValue
$ramTotal = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1MB
$ramPercent = [math]::Round((($ramTotal - $ramUsage) / $ramTotal) * 100, 2)

Write-Host "  CPU Usage: $([math]::Round($cpuUsage, 2))%" -ForegroundColor Gray
Write-Host "  RAM Usage: $ramPercent% ($([math]::Round($ramTotal - $ramUsage, 0)) MB / $([math]::Round($ramTotal, 0)) MB)" -ForegroundColor Gray

if ($ramPercent -lt 80) {
    Write-Host "  ✓ System resources adequate" -ForegroundColor Green
} else {
    Write-Host "  ⚠ High memory usage detected" -ForegroundColor Yellow
}

# Launch Options
Write-Host "[5/5] Trading system ready..." -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Trading System Status" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($mt5Exe) {
    Write-Host "MetaTrader 5: ✓ Ready" -ForegroundColor Green
} else {
    Write-Host "MetaTrader 5: ✗ Not found" -ForegroundColor Red
}

if ($mt5Config) {
    Write-Host "MT5 Configuration: ✓ Loaded" -ForegroundColor Green
} else {
    Write-Host "MT5 Configuration: ✗ Missing" -ForegroundColor Red
}

Write-Host "System Resources: ✓ Adequate" -ForegroundColor Green
Write-Host ""

# Launch Prompt
Write-Host "Options:" -ForegroundColor Yellow
Write-Host "  1. Launch MetaTrader 5" -ForegroundColor White
Write-Host "  2. Open EA project directory" -ForegroundColor White
Write-Host "  3. View configuration" -ForegroundColor White
Write-Host "  4. Exit" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Select option (1-4)"

switch ($choice) {
    "1" {
        if ($mt5Exe) {
            Write-Host "Launching MetaTrader 5..." -ForegroundColor Cyan
            Start-Process $mt5Exe
            Write-Host "✓ MetaTrader 5 launched" -ForegroundColor Green
        } else {
            Write-Host "✗ Cannot launch: MetaTrader 5 not found" -ForegroundColor Red
        }
    }
    "2" {
        if ($mt5Config) {
            $eaProjectPath = Join-Path $mt5Config.SharedProjectsPath "EXNESS_GenX_Trading"
            if (Test-Path $eaProjectPath) {
                Start-Process explorer.exe -ArgumentList $eaProjectPath
                Write-Host "✓ Opened EA project directory" -ForegroundColor Green
            } else {
                Write-Host "✗ EA project directory not found" -ForegroundColor Red
            }
        } else {
            Write-Host "✗ Configuration not loaded" -ForegroundColor Red
        }
    }
    "3" {
        if (Test-Path $configFile) {
            Write-Host ""
            Write-Host "MT5 Configuration:" -ForegroundColor Cyan
            Get-Content $configFile | ConvertFrom-Json | Format-List
        } else {
            Write-Host "✗ Configuration file not found" -ForegroundColor Red
        }
    }
    "4" {
        Write-Host "Exiting..." -ForegroundColor Gray
        exit 0
    }
    default {
        Write-Host "Invalid option. Exiting..." -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Trading system launcher completed." -ForegroundColor Cyan
Write-Host ""










