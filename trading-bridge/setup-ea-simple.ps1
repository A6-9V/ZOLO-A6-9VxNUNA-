# Simple EA Setup Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  EA Setup and Compilation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# Step 1: Check Trading Service
Write-Host "[1/4] Checking trading service..." -ForegroundColor Yellow
$port5555 = Get-NetTCPConnection -LocalPort 5555 -ErrorAction SilentlyContinue
if ($port5555) {
    Write-Host "  [OK] Trading service running on port 5555" -ForegroundColor Green
} else {
    Write-Host "  [WARNING] Trading service not running" -ForegroundColor Yellow
    if (Test-Path "run-trading-service.py") {
        Write-Host "  Starting trading service..." -ForegroundColor Yellow
        Start-Process python -ArgumentList "run-trading-service.py" -WindowStyle Minimized
        Start-Sleep -Seconds 3
        $port5555 = Get-NetTCPConnection -LocalPort 5555 -ErrorAction SilentlyContinue
        if ($port5555) {
            Write-Host "  [OK] Trading service started" -ForegroundColor Green
        } else {
            Write-Host "  [INFO] Service may still be starting" -ForegroundColor Yellow
        }
    }
}
Write-Host ""

# Step 2: Find MT5 Directory
Write-Host "[2/4] Locating MT5 directory..." -ForegroundColor Yellow
$mt5AppData = Join-Path $env:APPDATA "MetaQuotes\Terminal"
if (-not (Test-Path $mt5AppData)) {
    Write-Host "  [ERROR] MT5 directory not found: $mt5AppData" -ForegroundColor Red
    Write-Host "  Please install MetaTrader 5 first." -ForegroundColor Yellow
    exit 1
}

$mt5Dirs = Get-ChildItem -Path $mt5AppData -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $mt5Dirs) {
    Write-Host "  [ERROR] No MT5 terminal directories found" -ForegroundColor Red
    exit 1
}

$mt5Path = $mt5Dirs.FullName
$mt5Experts = Join-Path $mt5Path "MQL5\Experts"
$mt5Include = Join-Path $mt5Path "MQL5\Include"

Write-Host "  [OK] Found MT5: $mt5Path" -ForegroundColor Green

# Create directories
if (-not (Test-Path $mt5Experts)) {
    New-Item -ItemType Directory -Path $mt5Experts -Force | Out-Null
}
if (-not (Test-Path $mt5Include)) {
    New-Item -ItemType Directory -Path $mt5Include -Force | Out-Null
}
Write-Host ""

# Step 3: Copy Files
Write-Host "[3/4] Copying EA files..." -ForegroundColor Yellow
$sourceEA = Join-Path $scriptPath "mql5\Experts\PythonBridgeEA.mq5"
$sourceInclude = Join-Path $scriptPath "mql5\Include\PythonBridge.mqh"
$destEA = Join-Path $mt5Experts "PythonBridgeEA.mq5"
$destInclude = Join-Path $mt5Include "PythonBridge.mqh"

if (-not (Test-Path $sourceEA)) {
    Write-Host "  [ERROR] EA source not found: $sourceEA" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $sourceInclude)) {
    Write-Host "  [ERROR] Include source not found: $sourceInclude" -ForegroundColor Red
    exit 1
}

try {
    Copy-Item -Path $sourceEA -Destination $destEA -Force
    Write-Host "  [OK] Copied PythonBridgeEA.mq5" -ForegroundColor Green
    Copy-Item -Path $sourceInclude -Destination $destInclude -Force
    Write-Host "  [OK] Copied PythonBridge.mqh" -ForegroundColor Green
} catch {
    Write-Host "  [ERROR] Failed to copy files: $_" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Step 4: Compilation
Write-Host "[4/4] Attempting compilation..." -ForegroundColor Yellow
$metaEditorPaths = @(
    "C:\Program Files\MetaTrader 5 EXNESS\metaeditor64.exe",
    "C:\Program Files (x86)\MetaTrader 5 EXNESS\metaeditor64.exe",
    "$env:LOCALAPPDATA\Programs\MetaTrader 5 EXNESS\metaeditor64.exe"
)

$metaEditor = $null
foreach ($path in $metaEditorPaths) {
    if (Test-Path $path) {
        $metaEditor = $path
        break
    }
}

if ($metaEditor) {
    Write-Host "  [OK] Found MetaEditor: $metaEditor" -ForegroundColor Green
    Write-Host "  Compiling..." -ForegroundColor Yellow
    
    $compileArgs = "/compile:`"$destEA`""
    try {
        Start-Process -FilePath $metaEditor -ArgumentList $compileArgs -Wait -WindowStyle Hidden
        Start-Sleep -Seconds 2
        
        $ex5File = $destEA -replace '\.mq5$', '.ex5'
        if (Test-Path $ex5File) {
            Write-Host "  [OK] EA compiled successfully!" -ForegroundColor Green
        } else {
            Write-Host "  [INFO] Please compile manually: F4 in MT5, then F7" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  [INFO] Compilation needs manual step: F4 in MT5, then F7" -ForegroundColor Yellow
    }
} else {
    Write-Host "  [INFO] MetaEditor not found. Compile manually:" -ForegroundColor Yellow
    Write-Host "    1. Open MT5 Terminal" -ForegroundColor Cyan
    Write-Host "    2. Press F4 (MetaEditor)" -ForegroundColor Cyan
    Write-Host "    3. Open: $destEA" -ForegroundColor Cyan
    Write-Host "    4. Press F7 (Compile)" -ForegroundColor Cyan
}
Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Setup Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "EA Location: $destEA" -ForegroundColor Cyan
$ex5File = $destEA -replace '\.mq5$', '.ex5'
if (Test-Path $ex5File) {
    Write-Host "Compiled: YES" -ForegroundColor Green
} else {
    Write-Host "Compiled: NO (compile manually)" -ForegroundColor Yellow
}
Write-Host ""
Write-Host "Next: Attach EA to chart in MT5" -ForegroundColor Yellow
Write-Host ""

