#Requires -Version 5.1
<#
.SYNOPSIS
    Complete Trading System Setup and Start
.DESCRIPTION
    Sets up and starts the complete trading system:
    - Checks Python installation
    - Installs dependencies
    - Verifies configuration
    - Starts trading services
    - Optionally starts MT5 terminal
.NOTES
    This script automatically detects the trading-bridge location
#>

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Trading System Setup & Start" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Detect trading-bridge location
$possiblePaths = @(
    "D:\ZOLO-A6-9VxNUNA-\trading-bridge",
    "C:\Users\USER\OneDrive\trading-bridge",
    "$env:USERPROFILE\OneDrive\trading-bridge",
    "$PSScriptRoot\trading-bridge"
)

$tradingBridgePath = $null
foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $tradingBridgePath = $path
        Write-Host "[OK] Found trading-bridge at: $tradingBridgePath" -ForegroundColor Green
        break
    }
}

if (-not $tradingBridgePath) {
    Write-Host "[ERROR] Could not find trading-bridge directory!" -ForegroundColor Red
    Write-Host "Searched in:" -ForegroundColor Yellow
    foreach ($path in $possiblePaths) {
        Write-Host "  - $path" -ForegroundColor Gray
    }
    exit 1
}

# Set paths
$pythonServicePath = Join-Path $tradingBridgePath "python\services\background_service.py"
$runServicePath = Join-Path $tradingBridgePath "run-trading-service.py"
$requirementsPath = Join-Path $tradingBridgePath "requirements.txt"
$logsPath = Join-Path $tradingBridgePath "logs"
$configPath = Join-Path $tradingBridgePath "config"
$symbolsConfig = Join-Path $configPath "symbols.json"
$brokersConfig = Join-Path $configPath "brokers.json"

# Step 1: Check Python installation
Write-Host "[1/6] Checking Python installation..." -ForegroundColor Yellow
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    Write-Host "[ERROR] Python not found!" -ForegroundColor Red
    Write-Host "Please install Python 3.8+ and add it to PATH" -ForegroundColor Yellow
    Write-Host "Download from: https://www.python.org/downloads/" -ForegroundColor Cyan
    exit 1
}

$pythonVersion = python --version 2>&1
Write-Host "    [OK] Python found: $pythonVersion" -ForegroundColor Green

# Step 2: Install Python dependencies
Write-Host "[2/6] Installing Python dependencies..." -ForegroundColor Yellow
if (Test-Path $requirementsPath) {
    try {
        Write-Host "    Installing from requirements.txt..." -ForegroundColor Cyan
        $installOutput = pip install -q -r $requirementsPath 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "    [OK] Dependencies installed successfully" -ForegroundColor Green
        } else {
            Write-Host "    [WARNING] Some dependencies may have failed to install" -ForegroundColor Yellow
            Write-Host "    Continuing anyway..." -ForegroundColor Cyan
        }
    } catch {
        Write-Host "    [WARNING] Dependency installation had issues: $_" -ForegroundColor Yellow
        Write-Host "    Installing core dependencies..." -ForegroundColor Cyan
        pip install -q pyzmq requests python-dotenv cryptography schedule pywin32 2>&1 | Out-Null
        Write-Host "    [OK] Core dependencies installed" -ForegroundColor Green
    }
} else {
    Write-Host "    [INFO] requirements.txt not found, installing core dependencies..." -ForegroundColor Cyan
    pip install -q pyzmq requests python-dotenv cryptography schedule pywin32 2>&1 | Out-Null
    Write-Host "    [OK] Core dependencies installed" -ForegroundColor Green
}

# Step 3: Create necessary directories
Write-Host "[3/6] Creating necessary directories..." -ForegroundColor Yellow
$directories = @($logsPath, $configPath)
foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "    [OK] Created: $dir" -ForegroundColor Green
    }
}

# Step 4: Verify configuration files
Write-Host "[4/6] Verifying configuration..." -ForegroundColor Yellow
if (-not (Test-Path $symbolsConfig)) {
    Write-Host "    [WARNING] symbols.json not found" -ForegroundColor Yellow
    Write-Host "    Creating default symbols.json..." -ForegroundColor Cyan
    $defaultSymbols = @{
        symbols = @(
            @{
                symbol = "EURUSD"
                broker = "EXNESS"
                enabled = $true
                trading_days = @("monday", "tuesday", "wednesday", "thursday", "friday")
                risk_percent = 1.0
                max_positions = 1
                min_lot_size = 0.01
                max_lot_size = 10.0
            },
            @{
                symbol = "GBPUSD"
                broker = "EXNESS"
                enabled = $true
                trading_days = @("monday", "tuesday", "wednesday", "thursday", "friday")
                risk_percent = 1.0
                max_positions = 1
                min_lot_size = 0.01
                max_lot_size = 10.0
            },
            @{
                symbol = "USDJPY"
                broker = "EXNESS"
                enabled = $true
                trading_days = @("monday", "tuesday", "wednesday", "thursday", "friday")
                risk_percent = 1.0
                max_positions = 1
                min_lot_size = 0.01
                max_lot_size = 10.0
            },
            @{
                symbol = "BTCUSD"
                broker = "EXNESS"
                enabled = $true
                trading_days = @("saturday", "sunday")
                risk_percent = 1.0
                max_positions = 1
                min_lot_size = 0.01
                max_lot_size = 10.0
            },
            @{
                symbol = "ETHUSD"
                broker = "EXNESS"
                enabled = $true
                trading_days = @("saturday", "sunday")
                risk_percent = 1.0
                max_positions = 1
                min_lot_size = 0.01
                max_lot_size = 10.0
            },
            @{
                symbol = "XAUUSD"
                broker = "EXNESS"
                enabled = $true
                trading_days = @("saturday", "sunday")
                risk_percent = 1.0
                max_positions = 1
                min_lot_size = 0.01
                max_lot_size = 10.0
            }
        )
    } | ConvertTo-Json -Depth 10
    $defaultSymbols | Out-File -FilePath $symbolsConfig -Encoding UTF8
    Write-Host "    [OK] Created default symbols.json" -ForegroundColor Green
} else {
    Write-Host "    [OK] symbols.json found" -ForegroundColor Green
}

if (-not (Test-Path $brokersConfig)) {
    Write-Host "    [WARNING] brokers.json not found" -ForegroundColor Yellow
    Write-Host "    Broker API functionality will be limited" -ForegroundColor Cyan
    Write-Host "    Create brokers.json from brokers.json.example if needed" -ForegroundColor Cyan
} else {
    Write-Host "    [OK] brokers.json found" -ForegroundColor Green
}

# Step 5: Check if service is already running
Write-Host "[5/6] Checking for existing service..." -ForegroundColor Yellow
$existingProcesses = Get-Process python -ErrorAction SilentlyContinue | Where-Object {
    try {
        $cmdLine = (Get-CimInstance Win32_Process -Filter "ProcessId = $($_.Id)").CommandLine
        $cmdLine -like "*background_service*" -or $cmdLine -like "*run-trading-service*"
    } catch {
        $false
    }
}

if ($existingProcesses) {
    Write-Host "    [INFO] Trading service is already running:" -ForegroundColor Yellow
    foreach ($proc in $existingProcesses) {
        Write-Host "      PID: $($proc.Id) - $($proc.ProcessName)" -ForegroundColor Cyan
    }
    Write-Host ""
    Write-Host "Service Status: RUNNING" -ForegroundColor Green
    Write-Host "To stop: Stop-Process -Id $($existingProcesses[0].Id)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Would you like to restart the service? (Y/N)" -ForegroundColor Yellow
    $response = Read-Host
    if ($response -ne "Y" -and $response -ne "y") {
        Write-Host "Keeping existing service running." -ForegroundColor Green
        exit 0
    }
    Write-Host "    Stopping existing service..." -ForegroundColor Yellow
    foreach ($proc in $existingProcesses) {
        Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    }
    Start-Sleep -Seconds 2
}

# Step 6: Start trading service
Write-Host "[6/6] Starting trading service..." -ForegroundColor Yellow
$currentDay = (Get-Date).DayOfWeek
Write-Host "    Today is: $currentDay" -ForegroundColor Cyan

# Determine which script to use
$serviceScript = $null
if (Test-Path $runServicePath) {
    $serviceScript = $runServicePath
    Write-Host "    Using: run-trading-service.py" -ForegroundColor Cyan
} elseif (Test-Path $pythonServicePath) {
    $serviceScript = $pythonServicePath
    Write-Host "    Using: background_service.py" -ForegroundColor Cyan
} else {
    Write-Host "    [ERROR] Service script not found!" -ForegroundColor Red
    Write-Host "    Expected: $runServicePath" -ForegroundColor Yellow
    Write-Host "    Or: $pythonServicePath" -ForegroundColor Yellow
    exit 1
}

try {
    Write-Host "    Starting service..." -ForegroundColor Yellow
    
    # Change to trading-bridge directory
    Push-Location $tradingBridgePath
    
    # Start the service
    $process = Start-Process python -ArgumentList "`"$serviceScript`"" `
        -WindowStyle Hidden `
        -PassThru `
        -ErrorAction Stop
    
    Start-Sleep -Seconds 3
    
    # Verify process is running
    $verifyProcess = Get-Process -Id $process.Id -ErrorAction SilentlyContinue
    if ($verifyProcess -and -not $verifyProcess.HasExited) {
        Write-Host "    [OK] Service started (PID: $($process.Id))" -ForegroundColor Green
    } else {
        Write-Host "    [ERROR] Service failed to start or exited immediately" -ForegroundColor Red
        Write-Host "    Check logs in: $logsPath" -ForegroundColor Yellow
        if (Test-Path $logsPath) {
            $logFiles = Get-ChildItem -Path $logsPath -Filter "*.log" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
            if ($logFiles) {
                Write-Host "    Latest log: $($logFiles.FullName)" -ForegroundColor Cyan
                Write-Host "    Last 20 lines:" -ForegroundColor Cyan
                Get-Content $logFiles.FullName -Tail 20 | ForEach-Object { Write-Host "      $_" -ForegroundColor Gray }
            }
        }
        Pop-Location
        exit 1
    }
    
    Pop-Location
} catch {
    Write-Host "    [ERROR] Failed to start service: $_" -ForegroundColor Red
    Pop-Location
    exit 1
}

# Display status
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Trading System Status" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Status: RUNNING" -ForegroundColor Green
Write-Host "Process ID: $($process.Id)" -ForegroundColor White
Write-Host "Day: $currentDay" -ForegroundColor White
Write-Host "Trading Bridge: $tradingBridgePath" -ForegroundColor White
Write-Host "Logs: $logsPath" -ForegroundColor Cyan
Write-Host ""

# Show active symbols based on day
Write-Host "Active Symbols:" -ForegroundColor Yellow
if ($currentDay -eq "Saturday" -or $currentDay -eq "Sunday") {
    Write-Host "  - BTCUSD (Weekend)" -ForegroundColor Green
    Write-Host "  - ETHUSD (Weekend)" -ForegroundColor Green
    Write-Host "  - XAUUSD (Weekend)" -ForegroundColor Green
} else {
    Write-Host "  - EURUSD (Weekday)" -ForegroundColor Green
    Write-Host "  - GBPUSD (Weekday)" -ForegroundColor Green
    Write-Host "  - USDJPY (Weekday)" -ForegroundColor Green
    Write-Host "  - AUDUSD (Weekday)" -ForegroundColor Green
    Write-Host "  - USDCAD (Weekday)" -ForegroundColor Green
    Write-Host "  - EURJPY (Weekday)" -ForegroundColor Green
    Write-Host "  - GBPJPY (Weekday)" -ForegroundColor Green
}

Write-Host ""
Write-Host "Management Commands:" -ForegroundColor Yellow
Write-Host "  Stop Service:    Stop-Process -Id $($process.Id)" -ForegroundColor Cyan
Write-Host "  View Logs:       Get-Content `"$logsPath\trading_service_*.log`" -Tail 50" -ForegroundColor Cyan
Write-Host "  Check Status:    Get-Process -Id $($process.Id)" -ForegroundColor Cyan
Write-Host ""

# Optional: Check for MT5 terminal
$mt5Paths = @(
    "C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe",
    "C:\Program Files (x86)\MetaTrader 5 EXNESS\terminal64.exe",
    "$env:APPDATA\MetaQuotes\Terminal\*\terminal64.exe"
)

$mt5Found = $false
foreach ($mt5Path in $mt5Paths) {
    if (Test-Path $mt5Path) {
        $mt5Found = $true
        Write-Host "MT5 Terminal:" -ForegroundColor Yellow
        Write-Host "  Found at: $mt5Path" -ForegroundColor Cyan
        Write-Host "  Start manually if needed for EA execution" -ForegroundColor White
        break
    }
}

if (-not $mt5Found) {
    Write-Host "MT5 Terminal: Not found (optional for Python-only trading)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Setup Complete - Trading System Running" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

