# Check MT5 Profile Folder Structure
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MT5 Profile Folder Review" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$mt5AppData = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$mt5Dirs = Get-ChildItem -Path $mt5AppData -Directory -ErrorAction SilentlyContinue

if (-not $mt5Dirs) {
    Write-Host "[ERROR] No MT5 profile folders found" -ForegroundColor Red
    exit 1
}

foreach ($profile in $mt5Dirs) {
    Write-Host "Profile ID: $($profile.Name)" -ForegroundColor Yellow
    Write-Host "Full Path: $($profile.FullName)" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "Root Directories:" -ForegroundColor Green
    $rootDirs = Get-ChildItem -Path $profile.FullName -Directory -ErrorAction SilentlyContinue
    foreach ($dir in $rootDirs) {
        $fileCount = (Get-ChildItem -Path $dir.FullName -Recurse -File -ErrorAction SilentlyContinue).Count
        Write-Host "  [$($dir.Name)] ($fileCount files)" -ForegroundColor Cyan
    }
    Write-Host ""
    
    Write-Host "Root Files:" -ForegroundColor Green
    $rootFiles = Get-ChildItem -Path $profile.FullName -File -ErrorAction SilentlyContinue | Select-Object -First 10
    foreach ($file in $rootFiles) {
        Write-Host "  $($file.Name)" -ForegroundColor Gray
    }
    if ((Get-ChildItem -Path $profile.FullName -File -ErrorAction SilentlyContinue).Count -gt 10) {
        Write-Host "  ... and more files" -ForegroundColor Gray
    }
    Write-Host ""
    
    # Detailed MQL5 structure
    $mql5 = Join-Path $profile.FullName "MQL5"
    if (Test-Path $mql5) {
        Write-Host "=== MQL5 Directory Structure ===" -ForegroundColor Cyan
        Write-Host ""
        
        $mql5Dirs = Get-ChildItem -Path $mql5 -Directory -ErrorAction SilentlyContinue
        foreach ($mqlDir in $mql5Dirs) {
            Write-Host "[$($mqlDir.Name)]" -ForegroundColor Green
            
            # Check for subdirectories
            $subDirs = Get-ChildItem -Path $mqlDir.FullName -Directory -ErrorAction SilentlyContinue
            if ($subDirs) {
                foreach ($sub in $subDirs) {
                    $subFiles = Get-ChildItem -Path $sub.FullName -File -ErrorAction SilentlyContinue
                    Write-Host "  [$($sub.Name)] ($($subFiles.Count) files)" -ForegroundColor Yellow
                    $subFiles | Select-Object -First 10 | ForEach-Object {
                        Write-Host "    $($_.Name)" -ForegroundColor White
                    }
                    if ($subFiles.Count -gt 10) {
                        Write-Host "    ... and $($subFiles.Count - 10) more" -ForegroundColor Gray
                    }
                }
            }
            
            # Root files in MQL5 subdirectory
            $mqlFiles = Get-ChildItem -Path $mqlDir.FullName -File -ErrorAction SilentlyContinue
            if ($mqlFiles) {
                Write-Host "  Root files:" -ForegroundColor Yellow
                $mqlFiles | ForEach-Object {
                    Write-Host "    $($_.Name)" -ForegroundColor White
                }
            }
            Write-Host ""
        }
        
        # Check our specific files
        Write-Host "=== Our EA Files Status ===" -ForegroundColor Cyan
        Write-Host ""
        
        $eaPath = Join-Path $mql5 "Experts\PythonBridgeEA.mq5"
        $incPath = Join-Path $mql5 "Include\PythonBridge.mqh"
        $ex5Path = $eaPath -replace '\.mq5$', '.ex5'
        
        if (Test-Path $eaPath) {
            Write-Host "EA File: EXISTS" -ForegroundColor Green
            $eaInfo = Get-Item $eaPath
            Write-Host "  Location: $eaPath" -ForegroundColor Gray
            Write-Host "  Size: $([math]::Round($eaInfo.Length/1KB, 2)) KB" -ForegroundColor Gray
            Write-Host "  Modified: $($eaInfo.LastWriteTime)" -ForegroundColor Gray
        } else {
            Write-Host "EA File: MISSING" -ForegroundColor Red
        }
        
        if (Test-Path $incPath) {
            Write-Host "Include File: EXISTS" -ForegroundColor Green
            $incInfo = Get-Item $incPath
            Write-Host "  Location: $incPath" -ForegroundColor Gray
            Write-Host "  Size: $([math]::Round($incInfo.Length/1KB, 2)) KB" -ForegroundColor Gray
            Write-Host "  Modified: $($incInfo.LastWriteTime)" -ForegroundColor Gray
        } else {
            Write-Host "Include File: MISSING" -ForegroundColor Red
        }
        
        if (Test-Path $ex5Path) {
            Write-Host "Compiled EX5: EXISTS" -ForegroundColor Green
            $ex5Info = Get-Item $ex5Path
            Write-Host "  Location: $ex5Path" -ForegroundColor Gray
            Write-Host "  Size: $([math]::Round($ex5Info.Length/1KB, 2)) KB" -ForegroundColor Gray
            Write-Host "  Modified: $($ex5Info.LastWriteTime)" -ForegroundColor Gray
        } else {
            Write-Host "Compiled EX5: MISSING" -ForegroundColor Yellow
        }
        if (Test-Path $ex5Path) {
            $ex5Info = Get-Item $ex5Path
            Write-Host "  Location: $ex5Path" -ForegroundColor Gray
            Write-Host "  Size: $([math]::Round($ex5Info.Length/1KB, 2)) KB" -ForegroundColor Gray
            Write-Host "  Modified: $($ex5Info.LastWriteTime)" -ForegroundColor Gray
        }
    } else {
        Write-Host "[WARNING] MQL5 directory not found in this profile" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
}

