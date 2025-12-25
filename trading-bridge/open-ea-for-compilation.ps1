# Open EA in MetaEditor for Manual Compilation
Write-Host "Opening EA for manual compilation..." -ForegroundColor Cyan

$mt5AppData = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$mt5Dirs = Get-ChildItem -Path $mt5AppData -Directory -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $mt5Dirs) {
    Write-Host "[ERROR] MT5 directory not found" -ForegroundColor Red
    exit 1
}

$eaPath = Join-Path $mt5Dirs.FullName "MQL5\Experts\PythonBridgeEA.mq5"

if (-not (Test-Path $eaPath)) {
    Write-Host "[ERROR] EA file not found: $eaPath" -ForegroundColor Red
    exit 1
}

Write-Host "EA File: $eaPath" -ForegroundColor Green
Write-Host ""

# Try to find and open MetaEditor
$searchPaths = @(
    "C:\Program Files\MetaTrader 5 EXNESS\metaeditor64.exe",
    "C:\Program Files (x86)\MetaTrader 5 EXNESS\metaeditor64.exe",
    "$env:LOCALAPPDATA\Programs\MetaTrader 5 EXNESS\metaeditor64.exe",
    "C:\Program Files\MetaTrader 5\metaeditor64.exe"
)

$metaEditor = $null
foreach ($path in $searchPaths) {
    if (Test-Path $path) {
        $metaEditor = $path
        break
    }
}

if ($metaEditor) {
    Write-Host "Opening MetaEditor with EA file..." -ForegroundColor Yellow
    Start-Process -FilePath $metaEditor -ArgumentList "`"$eaPath`""
    Write-Host ""
    Write-Host "MetaEditor opened. Press F7 to compile." -ForegroundColor Green
} else {
    Write-Host "[INFO] MetaEditor not found in standard locations" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Manual steps:" -ForegroundColor Cyan
    Write-Host "  1. Open MetaTrader 5 Terminal" -ForegroundColor White
    Write-Host "  2. Press F4 (opens MetaEditor)" -ForegroundColor White
    Write-Host "  3. File → Open → Navigate to:" -ForegroundColor White
    Write-Host "     $eaPath" -ForegroundColor Yellow
    Write-Host "  4. Press F7 to compile" -ForegroundColor White
    Write-Host "  5. Verify: '0 error(s), 0 warning(s)' in compile log" -ForegroundColor White
    Write-Host ""
    
    # Try to open the folder in Explorer
    $eaFolder = Split-Path -Parent $eaPath
    Write-Host "Opening EA folder in Explorer..." -ForegroundColor Yellow
    Start-Process explorer.exe -ArgumentList "/select,`"$eaPath`""
}

