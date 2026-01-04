# EA Compilation Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Compiling EA" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Find EA file
$mt5AppData = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$mt5Dirs = Get-ChildItem -Path $mt5AppData -Directory -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $mt5Dirs) {
    Write-Host "[ERROR] MT5 directory not found" -ForegroundColor Red
    exit 1
}

$eaPath = Join-Path $mt5Dirs.FullName "MQL5\Experts\PythonBridgeEA.mq5"
$ex5Path = $eaPath -replace '\.mq5$', '.ex5'

if (-not (Test-Path $eaPath)) {
    Write-Host "[ERROR] EA file not found: $eaPath" -ForegroundColor Red
    exit 1
}

Write-Host "EA File: $eaPath" -ForegroundColor Cyan
Write-Host ""

# Search for MetaEditor in multiple locations
Write-Host "Searching for MetaEditor..." -ForegroundColor Yellow

$searchPaths = @(
    "C:\Program Files\MetaTrader 5 EXNESS\metaeditor64.exe",
    "C:\Program Files (x86)\MetaTrader 5 EXNESS\metaeditor64.exe",
    "$env:LOCALAPPDATA\Programs\MetaTrader 5 EXNESS\metaeditor64.exe",
    "C:\Program Files\MetaTrader 5\metaeditor64.exe",
    "C:\Program Files (x86)\MetaTrader 5\metaeditor64.exe"
)

# Also search in common MT5 installation directories
$mt5BasePaths = @(
    "C:\Program Files",
    "C:\Program Files (x86)",
    "$env:LOCALAPPDATA\Programs",
    "$env:ProgramFiles",
    "${env:ProgramFiles(x86)}"
)

$metaEditor = $null

# Check standard paths first
foreach ($path in $searchPaths) {
    if (Test-Path $path) {
        $metaEditor = $path
        break
    }
}

# If not found, search recursively in base paths
if (-not $metaEditor) {
    Write-Host "Searching in installation directories..." -ForegroundColor Yellow
    foreach ($basePath in $mt5BasePaths) {
        if (Test-Path $basePath) {
            $found = Get-ChildItem -Path $basePath -Filter "metaeditor64.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($found) {
                $metaEditor = $found.FullName
                break
            }
        }
    }
}

if ($metaEditor) {
    Write-Host "[OK] Found MetaEditor: $metaEditor" -ForegroundColor Green
    Write-Host ""
    Write-Host "Compiling..." -ForegroundColor Yellow
    
    # Try compilation with different methods
    $compileArgs = "/compile:`"$eaPath`""
    
    try {
        # Method 1: Direct compilation
        $process = Start-Process -FilePath $metaEditor -ArgumentList $compileArgs -Wait -PassThru -WindowStyle Hidden -NoNewWindow
        
        Start-Sleep -Seconds 3
        
        # Check if .ex5 file was created
        if (Test-Path $ex5Path) {
            Write-Host "[SUCCESS] EA compiled successfully!" -ForegroundColor Green
            Write-Host "Compiled file: $ex5Path" -ForegroundColor Cyan
            exit 0
        } else {
            Write-Host "[INFO] Compilation attempted but .ex5 file not found" -ForegroundColor Yellow
            Write-Host "This may require manual compilation in MetaEditor" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "[ERROR] Compilation failed: $_" -ForegroundColor Red
    }
} else {
    Write-Host "[ERROR] MetaEditor not found" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please compile manually:" -ForegroundColor Yellow
    Write-Host "  1. Open MT5 Terminal" -ForegroundColor Cyan
    Write-Host "  2. Press F4 (MetaEditor)" -ForegroundColor Cyan
    Write-Host "  3. Open: $eaPath" -ForegroundColor Cyan
    Write-Host "  4. Press F7 (Compile)" -ForegroundColor Cyan
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[TIP] Check MetaEditor logs for compilation details:" -ForegroundColor Yellow
Write-Host "  ..\monitor-metaeditor-logs.ps1 -Mode errors" -ForegroundColor White
Write-Host ""
