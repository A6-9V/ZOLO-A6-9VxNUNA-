#Requires -Version 5.1
$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Step 1: Copy EA Files to MT5" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$sourceEA = "D:\ZOLO-A6-9VxNUNA-\trading-bridge\mql5\Experts\PythonBridgeEA.mq5"
$sourceInclude = "D:\ZOLO-A6-9VxNUNA-\trading-bridge\mql5\Include\PythonBridge.mqh"

# Find MT5 directory
$mt5Dirs = Get-ChildItem -Path "$env:APPDATA\MetaQuotes\Terminal" -Directory -ErrorAction SilentlyContinue | Select-Object -First 1

if ($mt5Dirs) {
    $mt5Experts = Join-Path $mt5Dirs.FullName "MQL5\Experts"
    $mt5Include = Join-Path $mt5Dirs.FullName "MQL5\Include"
    
    Write-Host "[OK] Found MT5 directory: $($mt5Dirs.Name)" -ForegroundColor Green
    Write-Host ""
    
    # Copy EA file
    if (Test-Path $sourceEA) {
        if (-not (Test-Path $mt5Experts)) {
            New-Item -ItemType Directory -Path $mt5Experts -Force | Out-Null
        }
        Copy-Item -Path $sourceEA -Destination (Join-Path $mt5Experts "PythonBridgeEA.mq5") -Force
        Write-Host "[OK] EA file copied to MT5" -ForegroundColor Green
        Write-Host "  Location: $mt5Experts\PythonBridgeEA.mq5" -ForegroundColor Cyan
    } else {
        Write-Host "[WARNING] Source EA not found: $sourceEA" -ForegroundColor Yellow
    }
    
    # Copy include file
    if (Test-Path $sourceInclude) {
        if (-not (Test-Path $mt5Include)) {
            New-Item -ItemType Directory -Path $mt5Include -Force | Out-Null
        }
        Copy-Item -Path $sourceInclude -Destination (Join-Path $mt5Include "PythonBridge.mqh") -Force
        Write-Host "[OK] Include file copied to MT5" -ForegroundColor Green
        Write-Host "  Location: $mt5Include\PythonBridge.mqh" -ForegroundColor Cyan
    } else {
        Write-Host "[WARNING] Source include not found: $sourceInclude" -ForegroundColor Yellow
    }
} else {
    Write-Host "[ERROR] MT5 Terminal directory not found!" -ForegroundColor Red
    Write-Host "Please install MetaTrader 5 first" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Step 2: Compile Expert Advisor" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Find MetaEditor
$metaEditorPaths = @(
    "C:\Program Files\MetaTrader 5 EXNESS\metaeditor64.exe",
    "$env:LOCALAPPDATA\Programs\MetaTrader 5 EXNESS\metaeditor64.exe",
    "$env:PROGRAMFILES\MetaTrader 5 EXNESS\metaeditor64.exe"
)

$metaEditor = $null
foreach ($path in $metaEditorPaths) {
    if (Test-Path $path) {
        $metaEditor = $path
        Write-Host "[OK] Found MetaEditor: $path" -ForegroundColor Green
        break
    }
}

if ($metaEditor) {
    $eaPath = Join-Path $mt5Experts "PythonBridgeEA.mq5"
    if (Test-Path $eaPath) {
        Write-Host ""
        Write-Host "Compiling EA..." -ForegroundColor Yellow
        Write-Host "  File: $eaPath" -ForegroundColor Cyan
        
        try {
            $compileArgs = "/compile:`"$eaPath`" /log"
            $process = Start-Process -FilePath $metaEditor -ArgumentList $compileArgs -Wait -PassThru -WindowStyle Hidden
            
            Start-Sleep -Seconds 3
            
            $ex5Path = $eaPath -replace "\.mq5$", ".ex5"
            if (Test-Path $ex5Path) {
                Write-Host ""
                Write-Host "[SUCCESS] EA compiled successfully!" -ForegroundColor Green
                Write-Host "  Compiled file: $ex5Path" -ForegroundColor Cyan
                Write-Host ""
                Write-Host "========================================" -ForegroundColor Cyan
                Write-Host "  Next: Attach EA to Chart in MT5" -ForegroundColor Green
                Write-Host "========================================" -ForegroundColor Cyan
                Write-Host ""
                Write-Host "1. Open MetaTrader 5 Terminal" -ForegroundColor White
                Write-Host "2. Open a chart (e.g., EURUSD)" -ForegroundColor White
                Write-Host "3. Drag PythonBridgeEA from Navigator to chart" -ForegroundColor White
                Write-Host "4. Set BridgePort: 5555, BrokerName: EXNESS" -ForegroundColor White
                Write-Host "5. Click OK" -ForegroundColor White
                Write-Host ""
            } else {
                Write-Host ""
                Write-Host "[WARNING] Compilation may have failed" -ForegroundColor Yellow
                Write-Host "Please compile manually:" -ForegroundColor Cyan
                Write-Host "  1. Open MetaEditor (F4 in MT5)" -ForegroundColor White
                Write-Host "  2. Open: $eaPath" -ForegroundColor White
                Write-Host "  3. Press F7 to compile" -ForegroundColor White
                Write-Host ""
            }
        } catch {
            Write-Host ""
            Write-Host "[ERROR] Compilation failed: $_" -ForegroundColor Red
            Write-Host "Please compile manually in MetaEditor (F7)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "[ERROR] EA file not found in MT5 directory" -ForegroundColor Red
    }
} else {
    Write-Host "[WARNING] MetaEditor not found" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please compile manually:" -ForegroundColor Cyan
    Write-Host "  1. Open MetaEditor (F4 in MT5, or Tools → MetaQuotes Language Editor)" -ForegroundColor White
    Write-Host "  2. Press Ctrl+O to open file" -ForegroundColor White
    Write-Host "  3. Navigate to: $mt5Experts\PythonBridgeEA.mq5" -ForegroundColor White
    Write-Host "  4. Press F7 to compile" -ForegroundColor White
    Write-Host "  5. Verify: '0 error(s), 0 warning(s)'" -ForegroundColor White
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

