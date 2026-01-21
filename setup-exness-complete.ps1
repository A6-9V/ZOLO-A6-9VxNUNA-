#Requires -Version 5.1
#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Complete EXNESS Terminal, App Settings, EA, and VPS Setup Script
.DESCRIPTION
    This script automates the setup of:
    - EXNESS Terminal configuration
    - App settings (color and symbol configuration)
    - Expert Advisor setup and compilation
    - VPS deployment (optional)
#>

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  EXNESS Complete Setup" -ForegroundColor Cyan
Write-Host "  Terminal | App Settings | EA | VPS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$exnessTerminalPath = "C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe"
$exnessMetaEditorPath = "C:\Program Files\MetaTrader 5 EXNESS\metaeditor64.exe"
$mql5DataPath = "$env:APPDATA\MetaQuotes\Terminal"
$mql5RepoPath = "C:\Users\USER\OneDrive\mql5-repo"
$eaSourcePath = Join-Path $mql5RepoPath "Experts\Advisors"
$workspacePath = "C:\Users\USER\OneDrive"

# Step 1: Verify EXNESS Terminal Installation
Write-Host "[1/7] Verifying EXNESS Terminal Installation..." -ForegroundColor Yellow
try {
    if (Test-Path $exnessTerminalPath) {
        Write-Host "    [OK] EXNESS Terminal found: $exnessTerminalPath" -ForegroundColor Green
    }
    else {
        Write-Host "    [ERROR] EXNESS Terminal not found!" -ForegroundColor Red
        Write-Host "    [INFO] Expected location: $exnessTerminalPath" -ForegroundColor Yellow
        Write-Host "    [INFO] Please install EXNESS Terminal from: https://www.exness.com/" -ForegroundColor Yellow
        exit 1
    }

    if (Test-Path $exnessMetaEditorPath) {
        Write-Host "    [OK] MetaEditor found: $exnessMetaEditorPath" -ForegroundColor Green
    }
    else {
        Write-Host "    [WARNING] MetaEditor not found!" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "    [ERROR] Failed to verify EXNESS installation: $_" -ForegroundColor Red
    exit 1
}

# Step 2: Find MT5 Data Directory
Write-Host "[2/7] Locating MT5 Data Directory..." -ForegroundColor Yellow
try {
    $mt5Directories = Get-ChildItem -Path $mql5DataPath -Directory -ErrorAction SilentlyContinue | Where-Object {
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
        Write-Host "    [WARNING] MT5 Data Directory not found" -ForegroundColor Yellow
        Write-Host "    [INFO] This is normal if EXNESS Terminal hasn't been launched yet" -ForegroundColor Cyan
        Write-Host "    [INFO] Please launch EXNESS Terminal first, then run this script again" -ForegroundColor Cyan
        $eaTargetPath = $null
    }
}
catch {
    Write-Host "    [WARNING] Could not locate MT5 Data Directory: $_" -ForegroundColor Yellow
    $eaTargetPath = $null
}

# Step 3: Copy EA Files to Terminal Directory
Write-Host "[3/7] Copying Expert Advisors to Terminal..." -ForegroundColor Yellow
try {
    if ($eaTargetPath -and (Test-Path $eaSourcePath)) {
        # Create target directory if it doesn't exist
        if (-not (Test-Path $eaTargetPath)) {
            New-Item -ItemType Directory -Path $eaTargetPath -Force | Out-Null
            Write-Host "    [INFO] Created EA directory: $eaTargetPath" -ForegroundColor Cyan
        }

        # Copy Enhanced EA files
        $eaFiles = Get-ChildItem -Path $eaSourcePath -Filter "*Enhanced.mq5" -ErrorAction SilentlyContinue
        $copiedCount = 0

        foreach ($eaFile in $eaFiles) {
            $targetFile = Join-Path $eaTargetPath $eaFile.Name
            Copy-Item -Path $eaFile.FullName -Destination $targetFile -Force -ErrorAction SilentlyContinue
            if (Test-Path $targetFile) {
                Write-Host "    [OK] Copied: $($eaFile.Name)" -ForegroundColor Green
                $copiedCount++
            }
        }

        if ($copiedCount -gt 0) {
            Write-Host "    [OK] Copied $copiedCount EA file(s) to terminal directory" -ForegroundColor Green
        }
        else {
            Write-Host "    [WARNING] No Enhanced EA files found in source directory" -ForegroundColor Yellow
            Write-Host "    [INFO] Source: $eaSourcePath" -ForegroundColor Cyan
        }

        # Copy PythonBridgeEA if it exists
        $pythonBridgePath = Join-Path $workspacePath "trading-bridge\mql5\Experts\PythonBridgeEA.mq5"
        if (Test-Path $pythonBridgePath) {
            $targetBridge = Join-Path $eaTargetPath "PythonBridgeEA.mq5"
            Copy-Item -Path $pythonBridgePath -Destination $targetBridge -Force -ErrorAction SilentlyContinue
            if (Test-Path $targetBridge) {
                Write-Host "    [OK] Copied: PythonBridgeEA.mq5" -ForegroundColor Green
            }
        }
    }
    else {
        if (-not $eaTargetPath) {
            Write-Host "    [SKIP] MT5 Data Directory not found, skipping EA copy" -ForegroundColor Yellow
        }
        elseif (-not (Test-Path $eaSourcePath)) {
            Write-Host "    [WARNING] EA source directory not found: $eaSourcePath" -ForegroundColor Yellow
        }
    }
}
catch {
    Write-Host "    [WARNING] Failed to copy EA files: $_" -ForegroundColor Yellow
}

# Step 4: Compile Expert Advisors
Write-Host "[4/7] Compiling Expert Advisors..." -ForegroundColor Yellow
try {
    if ($eaTargetPath -and (Test-Path $exnessMetaEditorPath)) {
        $eaFiles = Get-ChildItem -Path $eaTargetPath -Filter "*.mq5" -ErrorAction SilentlyContinue
        $compiledCount = 0

        Write-Host "    [INFO] Found $($eaFiles.Count) EA file(s) to compile" -ForegroundColor Cyan
        Write-Host "    [INFO] Opening MetaEditor for compilation..." -ForegroundColor Cyan
        Write-Host "    [INFO] Please compile EAs manually in MetaEditor (F7)" -ForegroundColor Cyan
        Write-Host "    [INFO] Or run: .\compile-mql5-eas.ps1" -ForegroundColor Cyan

        # Optionally open MetaEditor
        if (Test-Path $exnessMetaEditorPath) {
            Start-Process -FilePath $exnessMetaEditorPath -ErrorAction SilentlyContinue
            Write-Host "    [OK] MetaEditor opened" -ForegroundColor Green
        }
    }
    else {
        Write-Host "    [SKIP] Cannot compile EAs (MetaEditor or EA directory not found)" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "    [WARNING] Failed to compile EAs: $_" -ForegroundColor Yellow
}

# Step 5: Launch EXNESS Terminal
Write-Host "[5/7] Launching EXNESS Terminal..." -ForegroundColor Yellow
try {
    $exnessProcess = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue

    if (-not $exnessProcess) {
        Write-Host "    [INFO] Starting EXNESS Terminal..." -ForegroundColor Cyan
        Start-Process -FilePath $exnessTerminalPath -ErrorAction Stop
        Start-Sleep -Seconds 3

        $exnessProcess = Get-Process -Name "terminal64" -ErrorAction SilentlyContinue
        if ($exnessProcess) {
            Write-Host "    [OK] EXNESS Terminal launched successfully" -ForegroundColor Green
        }
        else {
            Write-Host "    [WARNING] Terminal process not detected, but launch command executed" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "    [OK] EXNESS Terminal is already running" -ForegroundColor Green
    }
}
catch {
    Write-Host "    [WARNING] Failed to launch EXNESS Terminal: $_" -ForegroundColor Yellow
}

# Step 6: Connect MQL5 Account
Write-Host "[6/7] Connect MQL5 Account..." -ForegroundColor Yellow
$connectMql5Script = Join-Path $PSScriptRoot "connect-mql5-account.ps1"
if (Test-Path $connectMql5Script) {
    Write-Host "    [INFO] To access purchased EAs and assets from the MQL5 Market," -ForegroundColor Cyan
    Write-Host "    [INFO] you need to connect your MQL5 account in the terminal." -ForegroundColor Cyan
    Write-Host "    [INFO] For a step-by-step guide, run: .\connect-mql5-account.ps1" -ForegroundColor Cyan
}
else {
    Write-Host "    [INFO] MQL5 connection script not found, skipping." -ForegroundColor Yellow
}

# Step 7: VPS Setup (Optional)
Write-Host "[7/7] VPS Setup (Optional)..." -ForegroundColor Yellow
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

Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Login to EXNESS Terminal (if not already logged in)" -ForegroundColor White
Write-Host "  2. Enable AutoTrading (green button in toolbar)" -ForegroundColor White
Write-Host "  3. Configure chart colors: Right-click chart → Properties → Colors" -ForegroundColor White
Write-Host "  4. Add symbols to Market Watch: Press Ctrl+M → Right-click → Symbols" -ForegroundColor White
Write-Host "  5. Compile EAs in MetaEditor: Open EA → Press F7" -ForegroundColor White
Write-Host "  6. Attach EA to chart: Drag EA from Navigator to chart" -ForegroundColor White
Write-Host "  7. Configure EA parameters (1% risk recommended)" -ForegroundColor White
Write-Host "  8. Monitor EA activity in Terminal, Journal, and Experts tabs" -ForegroundColor White
Write-Host "  9. Connect your MQL5 Account to access purchased assets." -ForegroundColor White
Write-Host "     - Run '.\connect-mql5-account.ps1' for a guided setup." -ForegroundColor Cyan
Write-Host "  10. Verify MQL5 assets are available by running '.\verify-mql5-assets.ps1'" -ForegroundColor White
Write-Host ""

if ($eaTargetPath) {
    Write-Host "EA Directory:" -ForegroundColor Cyan
    Write-Host "  $eaTargetPath" -ForegroundColor White
    Write-Host ""
}

Write-Host "For detailed instructions, see: EXNESS-COMPLETE-SETUP-GUIDE.md" -ForegroundColor Cyan
Write-Host ""

Write-Host "Script execution completed." -ForegroundColor Green

