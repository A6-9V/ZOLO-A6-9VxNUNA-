#Requires -Version 5.1
#Requires -RunAsAdministrator

if (-not $IsWindows) {
    Write-Host "This script is only compatible with Windows."
    Write-Host "Please run start.ps1 to begin the setup process."
    exit
}

<#
.SYNOPSIS
    Complete Automated Setup for EXNESS Terminal, EAs, and VPS
.DESCRIPTION
    Automates the complete setup process:
    - Verifies EXNESS Terminal installation
    - Copies EA files to terminal directory
    - Launches EXNESS Terminal
    - Opens MetaEditor for EA compilation
    - Sets up VPS services (optional)
#>

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  EXNESS Complete Automated Setup" -ForegroundColor Cyan
Write-Host "  Terminal | EA | VPS Configuration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$exnessTerminalPath = "C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe"
$exnessMetaEditorPath = "C:\Program Files\MetaTrader 5 EXNESS\metaeditor64.exe"
$mql5RepoPath = "C:\Users\USER\OneDrive\mql5-repo"
$eaSourcePath = Join-Path $mql5RepoPath "Experts\Advisors"
$workspacePath = "C:\Users\USER\OneDrive"
$mt5DataBasePath = "$env:APPDATA\MetaQuotes\Terminal"

# Step 1: Verify EXNESS Terminal Installation
Write-Host "[1/7] Verifying EXNESS Terminal Installation..." -ForegroundColor Yellow
$exnessInstalled = $false

if (Test-Path $exnessTerminalPath) {
    Write-Host "    [OK] EXNESS Terminal found: $exnessTerminalPath" -ForegroundColor Green
    $exnessInstalled = $true
}
else {
    Write-Host "    [ERROR] EXNESS Terminal not found!" -ForegroundColor Red
    Write-Host "    [INFO] Expected location: $exnessTerminalPath" -ForegroundColor Yellow
    Write-Host "    [INFO] Please install EXNESS Terminal from: https://www.exness.com/" -ForegroundColor Yellow
    Write-Host "    [INFO] Continuing with other setup steps..." -ForegroundColor Yellow
}

if (Test-Path $exnessMetaEditorPath) {
    Write-Host "    [OK] MetaEditor found: $exnessMetaEditorPath" -ForegroundColor Green
}
else {
    Write-Host "    [WARNING] MetaEditor not found!" -ForegroundColor Yellow
}

# Step 2: Find MT5 Data Directory
Write-Host "[2/7] Locating MT5 Data Directory..." -ForegroundColor Yellow
$mt5DataDir = $null
$eaTargetPath = $null

if (Test-Path $mt5DataBasePath) {
    $mt5Directories = Get-ChildItem -Path $mt5DataBasePath -Directory -ErrorAction SilentlyContinue | Where-Object {
        $configPath = Join-Path $_.FullName "config"
        Test-Path $configPath
    }

    if ($mt5Directories) {
        $mt5DataDir = $mt5Directories[0].FullName
        $eaTargetPath = Join-Path $mt5DataDir "MQL5\Experts\Advisors"
        Write-Host "    [OK] MT5 Data Directory: $mt5DataDir" -ForegroundColor Green
        Write-Host "    [OK] EA Target Path: $eaTargetPath" -ForegroundColor Green
    }
    else {
        Write-Host "    [INFO] MT5 Data Directory not found (normal if terminal hasn't been launched)" -ForegroundColor Cyan
        Write-Host "    [INFO] Will create directory structure after terminal launch" -ForegroundColor Cyan
        # Use default path
        $mt5DataDir = Join-Path $mt5DataBasePath "53785E099C927DB68A545C249CDBCE06"
        $eaTargetPath = Join-Path $mt5DataDir "MQL5\Experts\Advisors"
    }
}
else {
    Write-Host "    [INFO] MT5 base directory not found, will create after terminal launch" -ForegroundColor Cyan
    $mt5DataDir = Join-Path $mt5DataBasePath "53785E099C927DB68A545C249CDBCE06"
    $eaTargetPath = Join-Path $mt5DataDir "MQL5\Experts\Advisors"
}

# Step 3: Copy EA Files to Terminal Directory
Write-Host "[3/7] Copying Expert Advisors to Terminal..." -ForegroundColor Yellow
$eaFilesCopied = 0

if (Test-Path $eaSourcePath) {
    # Create target directory if it doesn't exist
    if (-not (Test-Path $eaTargetPath)) {
        try {
            New-Item -ItemType Directory -Path $eaTargetPath -Force | Out-Null
            Write-Host "    [OK] Created EA directory: $eaTargetPath" -ForegroundColor Green
        }
        catch {
            Write-Host "    [WARNING] Could not create EA directory: $_" -ForegroundColor Yellow
        }
    }

    if (Test-Path $eaTargetPath) {
        # Copy all .mq5 files
        $eaFiles = Get-ChildItem -Path $eaSourcePath -Filter "*.mq5" -ErrorAction SilentlyContinue
        
        if ($eaFiles) {
            foreach ($eaFile in $eaFiles) {
                $targetFile = Join-Path $eaTargetPath $eaFile.Name
                try {
                    Copy-Item -Path $eaFile.FullName -Destination $targetFile -Force -ErrorAction Stop
                    Write-Host "    [OK] Copied: $($eaFile.Name)" -ForegroundColor Green
                    $eaFilesCopied++
                }
                catch {
                    Write-Host "    [WARNING] Failed to copy $($eaFile.Name): $_" -ForegroundColor Yellow
                }
            }
        }
        else {
            Write-Host "    [WARNING] No .mq5 files found in source directory" -ForegroundColor Yellow
        }

        # Copy compiled .ex5 files if they exist
        $ex5Files = Get-ChildItem -Path $eaSourcePath -Filter "*.ex5" -ErrorAction SilentlyContinue
        if ($ex5Files) {
            foreach ($ex5File in $ex5Files) {
                $targetFile = Join-Path $eaTargetPath $ex5File.Name
                try {
                    Copy-Item -Path $ex5File.FullName -Destination $targetFile -Force -ErrorAction Stop
                    Write-Host "    [OK] Copied compiled: $($ex5File.Name)" -ForegroundColor Green
                }
                catch {
                    Write-Host "    [WARNING] Failed to copy $($ex5File.Name): $_" -ForegroundColor Yellow
                }
            }
        }

        # Copy PythonBridgeEA if it exists
        $pythonBridgePath = Join-Path $workspacePath "trading-bridge\mql5\Experts\PythonBridgeEA.mq5"
        if (Test-Path $pythonBridgePath) {
            $targetBridge = Join-Path $eaTargetPath "PythonBridgeEA.mq5"
            try {
                Copy-Item -Path $pythonBridgePath -Destination $targetBridge -Force -ErrorAction Stop
                Write-Host "    [OK] Copied: PythonBridgeEA.mq5" -ForegroundColor Green
                $eaFilesCopied++
            }
            catch {
                Write-Host "    [WARNING] Failed to copy PythonBridgeEA: $_" -ForegroundColor Yellow
            }
        }
    }

    if ($eaFilesCopied -gt 0) {
        Write-Host "    [OK] Successfully copied $eaFilesCopied EA file(s)" -ForegroundColor Green
    }
}
else {
    Write-Host "    [WARNING] EA source directory not found: $eaSourcePath" -ForegroundColor Yellow
}

# Step 4: Copy Include Files
Write-Host "[4/7] Copying Include Files..." -ForegroundColor Yellow
$includeSourcePath = Join-Path $mql5RepoPath "Include"
$includeTargetPath = Join-Path $mt5DataDir "MQL5\Include"

if (Test-Path $includeSourcePath) {
    if (-not (Test-Path $includeTargetPath)) {
        New-Item -ItemType Directory -Path $includeTargetPath -Force | Out-Null
    }
    
    if (Test-Path $includeTargetPath) {
        try {
            Copy-Item -Path "$includeSourcePath\*" -Destination $includeTargetPath -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "    [OK] Include files copied" -ForegroundColor Green
        }
        catch {
            Write-Host "    [WARNING] Some include files may not have copied: $_" -ForegroundColor Yellow
        }
    }
}
else {
    Write-Host "    [INFO] Include source directory not found, skipping" -ForegroundColor Cyan
}

# Step 5: Launch EXNESS Terminal
Write-Host "[5/7] Launching EXNESS Terminal..." -ForegroundColor Yellow
if ($exnessInstalled) {
    $exnessProcess = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue

    if (-not $exnessProcess) {
        Write-Host "    [INFO] Starting EXNESS Terminal..." -ForegroundColor Cyan
        try {
            Start-Process -FilePath $exnessTerminalPath -ErrorAction Stop
            Start-Sleep -Seconds 5
            Write-Host "    [OK] EXNESS Terminal launched" -ForegroundColor Green
            Write-Host "    [INFO] Please login to your EXNESS account" -ForegroundColor Cyan
        }
        catch {
            Write-Host "    [WARNING] Failed to launch terminal: $_" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "    [OK] EXNESS Terminal is already running" -ForegroundColor Green
    }
}
else {
    Write-Host "    [SKIP] EXNESS Terminal not installed, skipping launch" -ForegroundColor Yellow
}

# Step 6: Open MetaEditor for Compilation
Write-Host "[6/7] Opening MetaEditor for EA Compilation..." -ForegroundColor Yellow
if (Test-Path $exnessMetaEditorPath) {
    try {
        Start-Process -FilePath $exnessMetaEditorPath -ErrorAction SilentlyContinue
        Write-Host "    [OK] MetaEditor opened" -ForegroundColor Green
        Write-Host "    [INFO] Please compile EAs: Open EA file → Press F7" -ForegroundColor Cyan
        if ($eaTargetPath) {
            Write-Host "    [INFO] EA location: $eaTargetPath" -ForegroundColor Cyan
        }
    }
    catch {
        Write-Host "    [WARNING] Could not open MetaEditor: $_" -ForegroundColor Yellow
    }
}
else {
    Write-Host "    [SKIP] MetaEditor not found, skipping" -ForegroundColor Yellow
}

# Step 7: VPS Setup (Optional)
Write-Host "[7/7] Checking VPS Setup..." -ForegroundColor Yellow
$vpsDeployScript = Join-Path $workspacePath "vps-deployment.ps1"
if (Test-Path $vpsDeployScript) {
    Write-Host "    [INFO] VPS deployment script found" -ForegroundColor Cyan
    Write-Host "    [INFO] To deploy VPS services, run: .\vps-deployment.ps1" -ForegroundColor Cyan
    Write-Host "    [INFO] To start VPS system, run: .\start-vps-system.ps1" -ForegroundColor Cyan
}
else {
    Write-Host "    [INFO] VPS deployment script not found, skipping" -ForegroundColor Yellow
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Setup Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Summary:" -ForegroundColor Yellow
Write-Host "  EXNESS Terminal: $(if ($exnessInstalled) { '[OK] Installed' } else { '[MISSING] Not found' })" -ForegroundColor $(if ($exnessInstalled) { "Green" } else { "Red" })
Write-Host "  EA Files Copied: $eaFilesCopied" -ForegroundColor $(if ($eaFilesCopied -gt 0) { "Green" } else { "Yellow" })
Write-Host "  Terminal Status: $(if (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) { '[RUNNING]' } else { '[NOT RUNNING]' })" -ForegroundColor $(if (Get-Process -Name "terminal64" -ErrorAction SilentlyContinue) { "Green" } else { "Yellow" })
Write-Host ""

Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Login to EXNESS Terminal (if not already logged in)" -ForegroundColor White
Write-Host "  2. Enable AutoTrading (green button in toolbar)" -ForegroundColor White
Write-Host "  3. Compile EAs in MetaEditor: Open EA → Press F7" -ForegroundColor White
Write-Host "  4. Configure chart colors: Right-click chart → Properties → Colors" -ForegroundColor White
Write-Host "  5. Add symbols: Press Ctrl+M → Right-click → Symbols" -ForegroundColor White
Write-Host "  6. Attach EA to chart: Drag EA from Navigator to chart" -ForegroundColor White
Write-Host "  7. Configure EA parameters (1% risk recommended)" -ForegroundColor White
Write-Host ""

if ($eaTargetPath) {
    Write-Host "EA Directory:" -ForegroundColor Cyan
    Write-Host "  $eaTargetPath" -ForegroundColor White
    Write-Host ""
}

Write-Host "For detailed instructions, see: EXNESS-COMPLETE-SETUP-GUIDE.md" -ForegroundColor Cyan
Write-Host ""

Write-Host "Script execution completed." -ForegroundColor Green

