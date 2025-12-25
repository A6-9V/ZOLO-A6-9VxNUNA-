<#
.SYNOPSIS
    Automated Python Error Fix Script
.DESCRIPTION
    Diagnoses and fixes python.exe application errors automatically
    Installs Python if missing, fixes PATH issues, installs dependencies
.PARAMETER DiagnoseOnly
    Run diagnostic mode only (don't make changes)
.PARAMETER ForceReinstall
    Force reinstall Python and packages
.EXAMPLE
    .\fix-python-error.ps1
.EXAMPLE
    .\fix-python-error.ps1 -DiagnoseOnly
.EXAMPLE
    .\fix-python-error.ps1 -ForceReinstall
#>

param(
    [switch]$DiagnoseOnlyOnly,
    [switch]$ForceReinstallReinstall
)

$ErrorActionPreference = "Continue"
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   Python Error Fix Script" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Step 1: Detect Python installation
Write-Host "[1/6] Detecting Python installation..." -ForegroundColor Yellow

$pythonLocations = @(
    "C:\Python311\python.exe",
    "C:\Python310\python.exe",
    "C:\Python39\python.exe",
    "$env:LOCALAPPDATA\Programs\Python\Python311\python.exe",
    "$env:LOCALAPPDATA\Programs\Python\Python310\python.exe",
    "C:\Program Files\Python311\python.exe",
    "C:\Program Files\Python310\python.exe"
)

$pythonPath = $null
$pythonVersion = $null

# Try to find Python in PATH first
try {
    $pythonPath = (Get-Command python -ErrorAction Stop).Source
    $pythonVersion = & python --version 2>&1 | Out-String
    Write-Host "    [OK] Found Python in PATH: $pythonPath" -ForegroundColor Green
    Write-Host "    Version: $pythonVersion" -ForegroundColor Cyan
} catch {
    Write-Host "    [WARNING] Python not found in PATH" -ForegroundColor Yellow
    
    # Search common locations
    foreach ($location in $pythonLocations) {
        if (Test-Path $location) {
            $pythonPath = $location
            $pythonVersion = & $pythonPath --version 2>&1 | Out-String
            Write-Host "    [OK] Found Python at: $pythonPath" -ForegroundColor Green
            Write-Host "    Version: $pythonVersion" -ForegroundColor Cyan
            break
        }
    }
}

if (-not $pythonPath) {
    Write-Host "    [ERROR] Python not found on system!" -ForegroundColor Red
    Write-Host "`n    Python is required for the trading system." -ForegroundColor Yellow
    Write-Host "    Please install Python from: https://www.python.org/downloads/`n" -ForegroundColor Yellow
    Write-Host "    Quick install options:" -ForegroundColor Cyan
    Write-Host "    1. Download from python.org (recommended)" -ForegroundColor White
    Write-Host "    2. Use winget: winget install Python.Python.3.11" -ForegroundColor White
    Write-Host "    3. Use chocolatey: choco install python --version=3.11.0" -ForegroundColor White
    Write-Host "`n    IMPORTANT: Check 'Add Python to PATH' during installation!`n" -ForegroundColor Yellow
    
    if ($DiagnoseOnly) {
        Write-Host "[DIAGNOSIS COMPLETE] Python needs to be installed" -ForegroundColor Yellow
    }
    exit 1
}

# Step 2: Check Python version
Write-Host "`n[2/6] Verifying Python version..." -ForegroundColor Yellow

if ($pythonVersion -match "Python (\d+)\.(\d+)\.(\d+)") {
    $major = [int]$matches[1]
    $minor = [int]$matches[2]
    
    if ($major -ge 3 -and $minor -ge 9) {
        Write-Host "    [OK] Python version is compatible (3.9+)" -ForegroundColor Green
    } else {
        Write-Host "    [WARNING] Python version may be too old" -ForegroundColor Yellow
        Write-Host "    Recommended: Python 3.11 or newer" -ForegroundColor Yellow
    }
}

# Step 3: Check if Python is in PATH
Write-Host "`n[3/6] Checking PATH configuration..." -ForegroundColor Yellow

$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
$pythonDir = Split-Path $pythonPath -Parent
$scriptsDir = Join-Path $pythonDir "Scripts"

$pythonInPath = $currentPath -like "*$pythonDir*"
$scriptsInPath = $currentPath -like "*$scriptsDir*"

if ($pythonInPath -and $scriptsInPath) {
    Write-Host "    [OK] Python is correctly configured in PATH" -ForegroundColor Green
} else {
    Write-Host "    [WARNING] Python not in system PATH" -ForegroundColor Yellow
    
    if ($DiagnoseOnly) {
        Write-Host "    Would add to PATH:" -ForegroundColor Cyan
        Write-Host "    - $pythonDir" -ForegroundColor White
        Write-Host "    - $scriptsDir" -ForegroundColor White
    } else {
        Write-Host "    Adding Python to PATH..." -ForegroundColor Yellow
        
        try {
            $newPath = $currentPath
            if (-not $pythonInPath) {
                $newPath += ";$pythonDir"
            }
            if (-not $scriptsInPath) {
                $newPath += ";$scriptsDir"
            }
            
            [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
            $env:Path += ";$pythonDir;$scriptsDir"
            
            Write-Host "    [OK] Added Python to PATH" -ForegroundColor Green
            Write-Host "    Note: Restart PowerShell for changes to take effect" -ForegroundColor Yellow
        } catch {
            Write-Host "    [ERROR] Failed to add to PATH: $_" -ForegroundColor Red
            Write-Host "    You may need to run this script as Administrator" -ForegroundColor Yellow
        }
    }
}

# Step 4: Check pip
Write-Host "`n[4/6] Checking pip (Python package manager)..." -ForegroundColor Yellow

try {
    $pipVersion = & $pythonPath -m pip --version 2>&1 | Out-String
    Write-Host "    [OK] pip is installed" -ForegroundColor Green
    Write-Host "    $pipVersion" -ForegroundColor Cyan
} catch {
    Write-Host "    [WARNING] pip not found" -ForegroundColor Yellow
    
    if ($DiagnoseOnly) {
        Write-Host "    Would install pip using ensurepip" -ForegroundColor Cyan
    } else {
        Write-Host "    Installing pip..." -ForegroundColor Yellow
        try {
            & $pythonPath -m ensurepip --upgrade
            & $pythonPath -m pip install --upgrade pip
            Write-Host "    [OK] pip installed successfully" -ForegroundColor Green
        } catch {
            Write-Host "    [ERROR] Failed to install pip: $_" -ForegroundColor Red
        }
    }
}

# Step 5: Check required packages
Write-Host "`n[5/6] Checking required Python packages..." -ForegroundColor Yellow

$requirementsFile = Join-Path $PSScriptRoot "trading-bridge\requirements.txt"
if (Test-Path $requirementsFile) {
    Write-Host "    Found requirements.txt" -ForegroundColor Cyan
    
    # Check key packages
    $keyPackages = @("pyzmq", "requests", "pandas", "numpy")
    $missingPackages = @()
    
    foreach ($package in $keyPackages) {
        try {
            $packageCheck = & $pythonPath -c "import $package; print('OK')" 2>&1
            if ($packageCheck -like "*OK*") {
                Write-Host "    [OK] $package is installed" -ForegroundColor Green
            } else {
                Write-Host "    [MISSING] $package" -ForegroundColor Red
                $missingPackages += $package
            }
        } catch {
            Write-Host "    [MISSING] $package" -ForegroundColor Red
            $missingPackages += $package
        }
    }
    
    if ($missingPackages.Count -gt 0 -or $ForceReinstall) {
        if ($DiagnoseOnly) {
            Write-Host "`n    Would install packages from requirements.txt" -ForegroundColor Cyan
        } else {
            Write-Host "`n    Installing required packages..." -ForegroundColor Yellow
            Write-Host "    This may take several minutes..." -ForegroundColor Cyan
            
            try {
                & $pythonPath -m pip install -r $requirementsFile --upgrade
                Write-Host "    [OK] Packages installed successfully" -ForegroundColor Green
            } catch {
                Write-Host "    [ERROR] Some packages failed to install" -ForegroundColor Red
                Write-Host "    Error: $_" -ForegroundColor Red
                Write-Host "`n    You may need to install Visual C++ Build Tools:" -ForegroundColor Yellow
                Write-Host "    https://visualstudio.microsoft.com/visual-cpp-build-tools/" -ForegroundColor White
            }
        }
    } else {
        Write-Host "    [OK] All key packages are installed" -ForegroundColor Green
    }
} else {
    Write-Host "    [WARNING] requirements.txt not found at: $requirementsFile" -ForegroundColor Yellow
}

# Step 6: Test trading bridge
Write-Host "`n[6/6] Testing trading system..." -ForegroundColor Yellow

$testScript = Join-Path $PSScriptRoot "trading-bridge\test-bridge-debug.py"
if (Test-Path $testScript) {
    if ($DiagnoseOnly) {
        Write-Host "    Would test: $testScript" -ForegroundColor Cyan
    } else {
        Write-Host "    Running test script..." -ForegroundColor Yellow
        try {
            $testOutput = & $pythonPath $testScript 2>&1 | Out-String
            if ($LASTEXITCODE -eq 0) {
                Write-Host "    [OK] Trading bridge test passed" -ForegroundColor Green
            } else {
                Write-Host "    [WARNING] Test completed with warnings" -ForegroundColor Yellow
                Write-Host "    Output: $testOutput" -ForegroundColor Cyan
            }
        } catch {
            Write-Host "    [ERROR] Test failed: $_" -ForegroundColor Red
        }
    }
} else {
    Write-Host "    [INFO] Test script not found (optional)" -ForegroundColor Cyan
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   SUMMARY" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

if ($DiagnoseOnly) {
    Write-Host "[DIAGNOSIS MODE] No changes were made" -ForegroundColor Yellow
    Write-Host "Run without -DiagnoseOnly flag to apply fixes`n" -ForegroundColor Yellow
} else {
    Write-Host "Python Configuration:" -ForegroundColor White
    Write-Host "  Path: $pythonPath" -ForegroundColor Cyan
    Write-Host "  Version: $pythonVersion" -ForegroundColor Cyan
    Write-Host "`nNext Steps:" -ForegroundColor White
    Write-Host "  1. Close and reopen PowerShell to refresh PATH" -ForegroundColor Yellow
    Write-Host "  2. Test: python --version" -ForegroundColor Yellow
    Write-Host "  3. Launch trading system: .\launch-trading-405347405.ps1`n" -ForegroundColor Yellow
}

# Create Python path reference file
if (-not $DiagnoseOnly) {
    $pathFile = Join-Path $PSScriptRoot "PYTHON-PATH.txt"
    @"
Python Installation Path
========================
Generated: $(Get-Date)

Python Executable: $pythonPath
Python Version: $pythonVersion
Scripts Directory: $scriptsDir

To use this Python explicitly in scripts:
& "$pythonPath" script.py

To add to PATH manually:
[Environment]::SetEnvironmentVariable("Path", `$env:Path + ";$pythonDir;$scriptsDir", "Machine")
"@ | Set-Content $pathFile
    
    Write-Host "Python path saved to: $pathFile" -ForegroundColor Green
}

Write-Host "`n[FIX COMPLETE]" -ForegroundColor Green
Write-Host "`nFor detailed troubleshooting, see: PYTHON-ERROR-FIX.md`n" -ForegroundColor Cyan
