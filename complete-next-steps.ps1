#Requires -Version 5.1
<#
.SYNOPSIS
    Complete Next Steps Automation - EA Compilation and MT5 Setup
.DESCRIPTION
    Automates the remaining setup steps:
    - Verifies EA files are in MT5 directory
    - Compiles Expert Advisors
    - Provides MT5 attachment instructions
    - Verifies bridge connection
#>

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Complete Next Steps Automation" -ForegroundColor Cyan
Write-Host "  EA Compilation & MT5 Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$tradingBridgePath = "D:\ZOLO-A6-9VxNUNA-\trading-bridge"
$sourceEAPath = Join-Path $tradingBridgePath "mql5\Experts\PythonBridgeEA.mq5"
$sourceIncludePath = Join-Path $tradingBridgePath "mql5\Include\PythonBridge.mqh"

# Step 1: Verify Trading Service
Write-Host "[1/6] Verifying trading service..." -ForegroundColor Yellow
$pythonProcesses = Get-Process python -ErrorAction SilentlyContinue | Where-Object {
    try {
        $cmdLine = (Get-CimInstance Win32_Process -Filter "ProcessId = $($_.Id)" -ErrorAction SilentlyContinue).CommandLine
        $cmdLine -like "*trading*" -or $cmdLine -like "*run-trading-service*" -or $cmdLine -like "*background_service*"
    } catch {
        $false
    }
}

if ($pythonProcesses) {
    Write-Host "    [OK] Trading service is running" -ForegroundColor Green
    Write-Host "      PIDs: $($pythonProcesses.Id -join ', ')" -ForegroundColor Cyan
} else {
    Write-Host "    [WARNING] Trading service not detected" -ForegroundColor Yellow
    Write-Host "    Starting service..." -ForegroundColor Cyan
    Push-Location $tradingBridgePath
    if (Test-Path "run-trading-service.py") {
        Start-Process python -ArgumentList "run-trading-service.py" -WindowStyle Hidden
        Start-Sleep -Seconds 3
        Write-Host "    [OK] Service started" -ForegroundColor Green
    }
    Pop-Location
}

Write-Host ""

# Step 2: Find MT5 Terminal Directory
Write-Host "[2/6] Locating MT5 Terminal directory..." -ForegroundColor Yellow
$mt5TerminalDirs = Get-ChildItem -Path "$env:APPDATA\MetaQuotes\Terminal" -Directory -ErrorAction SilentlyContinue

if ($mt5TerminalDirs) {
    $mt5Dir = $mt5TerminalDirs | Select-Object -First 1
    $mt5ExpertsPath = Join-Path $mt5Dir.FullName "MQL5\Experts"
    $mt5IncludePath = Join-Path $mt5Dir.FullName "MQL5\Include"
    
    Write-Host "    [OK] Found MT5 directory: $($mt5Dir.Name)" -ForegroundColor Green
    Write-Host "      Experts: $mt5ExpertsPath" -ForegroundColor Cyan
    Write-Host "      Include: $mt5IncludePath" -ForegroundColor Cyan
} else {
    Write-Host "    [ERROR] MT5 Terminal directory not found!" -ForegroundColor Red
    Write-Host "    Please install MetaTrader 5 first" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Step 3: Copy EA Files to MT5 (if needed)
Write-Host "[3/6] Checking EA files in MT5 directory..." -ForegroundColor Yellow
$targetEAPath = Join-Path $mt5ExpertsPath "PythonBridgeEA.mq5"
$targetIncludePath = Join-Path $mt5IncludePath "PythonBridge.mqh"

$eaNeedsCopy = $false
$includeNeedsCopy = $false

if (-not (Test-Path $targetEAPath)) {
    if (Test-Path $sourceEAPath) {
        Write-Host "    [INFO] EA file not in MT5 directory, copying..." -ForegroundColor Cyan
        if (-not (Test-Path $mt5ExpertsPath)) {
            New-Item -ItemType Directory -Path $mt5ExpertsPath -Force | Out-Null
        }
        Copy-Item -Path $sourceEAPath -Destination $targetEAPath -Force
        Write-Host "    [OK] EA file copied to MT5" -ForegroundColor Green
    } else {
        Write-Host "    [ERROR] Source EA file not found: $sourceEAPath" -ForegroundColor Red
        $eaNeedsCopy = $true
    }
} else {
    Write-Host "    [OK] EA file already in MT5 directory" -ForegroundColor Green
}

if (-not (Test-Path $targetIncludePath)) {
    if (Test-Path $sourceIncludePath) {
        Write-Host "    [INFO] Include file not in MT5 directory, copying..." -ForegroundColor Cyan
        if (-not (Test-Path $mt5IncludePath)) {
            New-Item -ItemType Directory -Path $mt5IncludePath -Force | Out-Null
        }
        Copy-Item -Path $sourceIncludePath -Destination $targetIncludePath -Force
        Write-Host "    [OK] Include file copied to MT5" -ForegroundColor Green
    } else {
        Write-Host "    [WARNING] Source include file not found: $sourceIncludePath" -ForegroundColor Yellow
        $includeNeedsCopy = $true
    }
} else {
    Write-Host "    [OK] Include file already in MT5 directory" -ForegroundColor Green
}

Write-Host ""

# Step 4: Find MetaEditor
Write-Host "[4/6] Locating MetaEditor..." -ForegroundColor Yellow
$metaEditorPaths = @(
    "C:\Program Files\MetaTrader 5 EXNESS\metaeditor64.exe",
    "$env:LOCALAPPDATA\Programs\MetaTrader 5 EXNESS\metaeditor64.exe",
    "$env:PROGRAMFILES\MetaTrader 5 EXNESS\metaeditor64.exe",
    (Get-Item "Env:ProgramFiles(x86)").Value + "\MetaTrader 5 EXNESS\metaeditor64.exe"
)

$metaEditorPath = $null
foreach ($path in $metaEditorPaths) {
    if (Test-Path $path) {
        $metaEditorPath = $path
        Write-Host "    [OK] Found MetaEditor: $path" -ForegroundColor Green
        break
    }
}

if (-not $metaEditorPath) {
    Write-Host "    [WARNING] MetaEditor not found in standard locations" -ForegroundColor Yellow
    Write-Host "    You'll need to compile manually:" -ForegroundColor Cyan
    Write-Host "      1. Open MetaEditor (F4 in MT5)" -ForegroundColor White
    Write-Host "      2. Open: $targetEAPath" -ForegroundColor White
    Write-Host "      3. Press F7 to compile" -ForegroundColor White
}

Write-Host ""

# Step 5: Attempt Compilation
Write-Host "[5/6] Compiling Expert Advisor..." -ForegroundColor Yellow
if ($metaEditorPath -and (Test-Path $targetEAPath)) {
    try {
        Write-Host "    Attempting automatic compilation..." -ForegroundColor Cyan
        $compileArgs = @(
            "/compile:`"$targetEAPath`"",
            "/log"
        )
        
        $process = Start-Process -FilePath $metaEditorPath -ArgumentList $compileArgs -Wait -PassThru -WindowStyle Hidden
        
        Start-Sleep -Seconds 2
        
        # Check if .ex5 file was created
        $ex5Path = $targetEAPath -replace "\.mq5$", ".ex5"
        if (Test-Path $ex5Path) {
            Write-Host "    [OK] EA compiled successfully!" -ForegroundColor Green
            Write-Host "      Compiled file: $ex5Path" -ForegroundColor Cyan
        } else {
            Write-Host "    [WARNING] Compilation may have failed" -ForegroundColor Yellow
            Write-Host "    Please compile manually in MetaEditor (F7)" -ForegroundColor Cyan
        }
    } catch {
        Write-Host "    [WARNING] Automatic compilation failed: $_" -ForegroundColor Yellow
        Write-Host "    Please compile manually:" -ForegroundColor Cyan
        Write-Host "      1. Open MetaEditor" -ForegroundColor White
        Write-Host "      2. Open: $targetEAPath" -ForegroundColor White
        Write-Host "      3. Press F7" -ForegroundColor White
    }
} else {
    Write-Host "    [INFO] Skipping automatic compilation" -ForegroundColor Cyan
    if (-not $metaEditorPath) {
        Write-Host "      Reason: MetaEditor not found" -ForegroundColor Yellow
    }
    if (-not (Test-Path $targetEAPath)) {
        Write-Host "      Reason: EA file not found" -ForegroundColor Yellow
    }
}

Write-Host ""

# Step 6: Verify and Provide Next Steps
Write-Host "[6/6] Final verification and next steps..." -ForegroundColor Yellow

# Check if compiled EA exists
$ex5Path = Join-Path $mt5ExpertsPath "PythonBridgeEA.ex5"
if (Test-Path $ex5Path) {
    Write-Host "    [OK] Compiled EA found: PythonBridgeEA.ex5" -ForegroundColor Green
    $eaReady = $true
} else {
    Write-Host "    [PENDING] EA needs to be compiled" -ForegroundColor Yellow
    $eaReady = $false
}

# Check port 5555
$portInUse = Get-NetTCPConnection -LocalPort 5555 -ErrorAction SilentlyContinue
if ($portInUse) {
    Write-Host "    [OK] Bridge port 5555 is active" -ForegroundColor Green
} else {
    Write-Host "    [INFO] Bridge port 5555 not in use (service may be starting)" -ForegroundColor Cyan
}

Write-Host ""

# Summary and Next Steps
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Setup Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Status:" -ForegroundColor Yellow
Write-Host "  Trading Service: " -NoNewline -ForegroundColor White
if ($pythonProcesses) {
    Write-Host "RUNNING" -ForegroundColor Green
} else {
    Write-Host "NOT RUNNING" -ForegroundColor Red
}

Write-Host "  EA Files: " -NoNewline -ForegroundColor White
if ((Test-Path $targetEAPath) -and (Test-Path $targetIncludePath)) {
    Write-Host "READY" -ForegroundColor Green
} else {
    Write-Host "MISSING" -ForegroundColor Red
}

Write-Host "  EA Compiled: " -NoNewline -ForegroundColor White
if ($eaReady) {
    Write-Host "YES" -ForegroundColor Green
} else {
    Write-Host "NO" -ForegroundColor Yellow
}

Write-Host "  Bridge Port: " -NoNewline -ForegroundColor White
if ($portInUse) {
    Write-Host "ACTIVE" -ForegroundColor Green
} else {
    Write-Host "INACTIVE" -ForegroundColor Yellow
}

Write-Host ""

if ($eaReady) {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Ready for MT5 Attachment!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. Open MetaTrader 5 Terminal" -ForegroundColor White
    Write-Host "   - Launch MT5 if not already running" -ForegroundColor Gray
    Write-Host "   - Log into your Exness account" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Attach Expert Advisor to Chart" -ForegroundColor White
    Write-Host "   - Open a chart (e.g., EURUSD)" -ForegroundColor Gray
    Write-Host "   - Open Navigator panel (Ctrl+N)" -ForegroundColor Gray
    Write-Host "   - Find 'PythonBridgeEA' under Expert Advisors" -ForegroundColor Gray
    Write-Host "   - Drag and drop onto the chart" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. Configure EA Parameters" -ForegroundColor White
    Write-Host "   - BridgePort: 5555 (must match Python bridge)" -ForegroundColor Gray
    Write-Host "   - BrokerName: EXNESS" -ForegroundColor Gray
    Write-Host "   - AutoExecute: true" -ForegroundColor Gray
    Write-Host "   - DefaultLotSize: 0.01" -ForegroundColor Gray
    Write-Host "   - Click OK" -ForegroundColor Gray
    Write-Host ""
    Write-Host "4. Verify Connection" -ForegroundColor White
    Write-Host "   - Check MT5 Experts tab for connection messages" -ForegroundColor Gray
    Write-Host "   - Should see: 'Bridge connection initialized on port 5555'" -ForegroundColor Gray
    Write-Host "   - Check Python logs: $tradingBridgePath\logs\" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Compilation Required" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To compile the EA manually:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. Open MetaEditor" -ForegroundColor White
    Write-Host "   - Press F4 in MT5, or" -ForegroundColor Gray
    Write-Host "   - Tools → MetaQuotes Language Editor" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Open EA File" -ForegroundColor White
    Write-Host "   - Press Ctrl+O" -ForegroundColor Gray
    Write-Host "   - Navigate to: $targetEAPath" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. Compile" -ForegroundColor White
    Write-Host "   - Press F7 or click Compile button" -ForegroundColor Gray
    Write-Host "   - Verify: '0 error(s), 0 warning(s)'" -ForegroundColor Gray
    Write-Host ""
    Write-Host "4. Then follow MT5 attachment steps above" -ForegroundColor White
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Management Commands" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Check Status:" -ForegroundColor Yellow
Write-Host "  powershell.exe -ExecutionPolicy Bypass -File `"D:\ZOLO-A6-9VxNUNA-\verify-trading-status.ps1`"" -ForegroundColor White
Write-Host ""
Write-Host "View Logs:" -ForegroundColor Yellow
Write-Host "  Get-Content `"$tradingBridgePath\logs\*.log`" -Tail 50" -ForegroundColor White
Write-Host ""
Write-Host "Test Bridge:" -ForegroundColor Yellow
Write-Host "  cd `"$tradingBridgePath`"" -ForegroundColor White
Write-Host "  python test-bridge-connection.py" -ForegroundColor White
Write-Host ""

