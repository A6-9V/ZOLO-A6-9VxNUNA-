# List MQL5 Directory Structure
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MQL5 Directory Structure Review" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$mt5AppData = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$mt5Dirs = Get-ChildItem -Path $mt5AppData -Directory -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $mt5Dirs) {
    Write-Host "[ERROR] MT5 directory not found" -ForegroundColor Red
    exit 1
}

Write-Host "MT5 Terminal ID: $($mt5Dirs.Name)" -ForegroundColor Yellow
Write-Host "Full Path: $($mt5Dirs.FullName)" -ForegroundColor Yellow
Write-Host ""

$mql5 = Join-Path $mt5Dirs.FullName "MQL5"

if (-not (Test-Path $mql5)) {
    Write-Host "[ERROR] MQL5 directory not found" -ForegroundColor Red
    exit 1
}

Write-Host "=== MQL5 Root Directories ===" -ForegroundColor Green
Write-Host ""

$rootDirs = Get-ChildItem -Path $mql5 -Directory -ErrorAction SilentlyContinue

foreach ($dir in $rootDirs) {
    Write-Host "[$($dir.Name)]" -ForegroundColor Cyan
    Write-Host "  Path: $($dir.FullName)" -ForegroundColor Gray
    
    # Count files
    $fileCount = (Get-ChildItem -Path $dir.FullName -File -Recurse -ErrorAction SilentlyContinue).Count
    Write-Host "  Files: $fileCount" -ForegroundColor Gray
    
    # List subdirectories
    $subDirs = Get-ChildItem -Path $dir.FullName -Directory -ErrorAction SilentlyContinue
    if ($subDirs) {
        Write-Host "  Subdirectories:" -ForegroundColor Yellow
        foreach ($sub in $subDirs) {
            $subFileCount = (Get-ChildItem -Path $sub.FullName -File -ErrorAction SilentlyContinue).Count
            Write-Host "    [$($sub.Name)] ($subFileCount files)" -ForegroundColor Yellow
            
            # Show first few files in subdirectory
            $files = Get-ChildItem -Path $sub.FullName -File -ErrorAction SilentlyContinue | Select-Object -First 10
            foreach ($file in $files) {
                Write-Host "      - $($file.Name)" -ForegroundColor White
            }
            if ($subFileCount -gt 10) {
                Write-Host "      ... and $($subFileCount - 10) more files" -ForegroundColor Gray
            }
        }
    }
    
    # List files in root of directory
    $rootFiles = Get-ChildItem -Path $dir.FullName -File -ErrorAction SilentlyContinue
    if ($rootFiles) {
        Write-Host "  Root files:" -ForegroundColor Yellow
        foreach ($file in $rootFiles) {
            Write-Host "    - $($file.Name)" -ForegroundColor White
        }
    }
    
    Write-Host ""
}

# Special focus on Experts and Include
Write-Host "=== Key Directories Detail ===" -ForegroundColor Green
Write-Host ""

$expertsPath = Join-Path $mql5 "Experts"
$includePath = Join-Path $mql5 "Include"

if (Test-Path $expertsPath) {
    Write-Host "[Experts]" -ForegroundColor Cyan
    $expertsFiles = Get-ChildItem -Path $expertsPath -Recurse -File -ErrorAction SilentlyContinue
    Write-Host "  Total files: $($expertsFiles.Count)" -ForegroundColor Yellow
    foreach ($file in $expertsFiles) {
        $relPath = $file.FullName.Replace($expertsPath, "").TrimStart('\')
        Write-Host "  $relPath" -ForegroundColor White
    }
    Write-Host ""
}

if (Test-Path $includePath) {
    Write-Host "[Include]" -ForegroundColor Cyan
    $includeFiles = Get-ChildItem -Path $includePath -Recurse -File -ErrorAction SilentlyContinue
    Write-Host "  Total files: $($includeFiles.Count)" -ForegroundColor Yellow
    foreach ($file in $includeFiles) {
        $relPath = $file.FullName.Replace($includePath, "").TrimStart('\')
        Write-Host "  $relPath" -ForegroundColor White
    }
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan

