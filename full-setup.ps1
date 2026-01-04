#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Master Full Setup Script for ZOLO-A6-9VxNUNA System
.DESCRIPTION
    This script orchestrates the complete setup process for the entire system including:
    - Windows 11 configuration and optimization
    - EXNESS trading system setup
    - Workspace structure verification
    - Cloud synchronization services
    - Security configuration
    - Git repository setup
    - Documentation verification
.NOTES
    Author: A6-9V Organization
    Device: NuNa (Windows 11 Home 25H2)
    Requires: Administrator privileges
#>

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Requesting administrator privileges..." -ForegroundColor Yellow
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

if (-not $IsWindows) {
    Write-Host "This script is only compatible with Windows." -ForegroundColor Red
    Write-Host "Please run start.ps1 to begin the setup process." -ForegroundColor Yellow
    exit 1
}

$ErrorActionPreference = "Continue"
$workspaceRoot = "C:\Users\USER\OneDrive"
$scriptRoot = $PSScriptRoot

# Change to workspace root if it exists
if (Test-Path $workspaceRoot) {
    Set-Location $workspaceRoot
} else {
    Write-Host "WARNING: Workspace root not found: $workspaceRoot" -ForegroundColor Yellow
    Write-Host "Using script directory: $scriptRoot" -ForegroundColor Cyan
    Set-Location $scriptRoot
}

# Banner
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ZOLO-A6-9VxNUNA Full Setup" -ForegroundColor Cyan
Write-Host "  Complete System Configuration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Device: NuNa" -ForegroundColor White
Write-Host "OS: Windows 11 Home 25H2" -ForegroundColor White
Write-Host "User: $env:USERNAME" -ForegroundColor White
Write-Host ""

# Initialize tracking
$setupSteps = @()
$errors = @()
$warnings = @()
$startTime = Get-Date

# Function to run a setup script safely
function Invoke-SetupScript {
    param(
        [string]$ScriptName,
        [string]$StepNumber,
        [string]$Description,
        [switch]$Optional = $false
    )
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  $StepNumber $Description" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    $scriptPath = Join-Path $PSScriptRoot $ScriptName
    
    if (-not (Test-Path $scriptPath)) {
        # Try workspace root
        $scriptPath = Join-Path $workspaceRoot $ScriptName
    }
    
    if (Test-Path $scriptPath) {
        Write-Host "[INFO] Running: $ScriptName" -ForegroundColor Cyan
        try {
            & powershell.exe -ExecutionPolicy Bypass -File $scriptPath -ErrorAction Continue
            
            if ($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq $null) {
                Write-Host ""
                Write-Host "[OK] $Description completed successfully" -ForegroundColor Green
                $script:setupSteps += @{Step=$StepNumber; Name=$Description; Status="Success"; Script=$ScriptName}
            } else {
                Write-Host ""
                Write-Host "[WARNING] $Description completed with warnings (Exit Code: $LASTEXITCODE)" -ForegroundColor Yellow
                $script:warnings += "$Description completed with exit code $LASTEXITCODE"
                $script:setupSteps += @{Step=$StepNumber; Name=$Description; Status="Warning"; Script=$ScriptName}
            }
        } catch {
            if ($Optional) {
                Write-Host ""
                Write-Host "[WARNING] $Description had issues but is optional: $_" -ForegroundColor Yellow
                $script:warnings += "$Description (optional): $_"
                $script:setupSteps += @{Step=$StepNumber; Name=$Description; Status="Skipped"; Script=$ScriptName}
            } else {
                Write-Host ""
                Write-Host "[ERROR] $Description failed: $_" -ForegroundColor Red
                $script:errors += "$Description: $_"
                $script:setupSteps += @{Step=$StepNumber; Name=$Description; Status="Failed"; Script=$ScriptName}
            }
        }
    } else {
        if ($Optional) {
            Write-Host "[INFO] Script not found: $ScriptName (optional, skipping)" -ForegroundColor Cyan
            $script:setupSteps += @{Step=$StepNumber; Name=$Description; Status="NotFound"; Script=$ScriptName}
        } else {
            Write-Host "[WARNING] Script not found: $ScriptName" -ForegroundColor Yellow
            $script:warnings += "Script not found: $ScriptName"
            $script:setupSteps += @{Step=$StepNumber; Name=$Description; Status="NotFound"; Script=$ScriptName}
        }
    }
}

Write-Host "This will run the complete setup process:" -ForegroundColor Yellow
Write-Host "  [1] Complete Device Setup (Windows configuration)" -ForegroundColor White
Write-Host "  [2] Workspace Setup (Directory structure)" -ForegroundColor White
Write-Host "  [3] Windows Auto Setup (Automated configuration)" -ForegroundColor White
Write-Host "  [4] Cloud Sync Setup (OneDrive, Google Drive, Dropbox)" -ForegroundColor White
Write-Host "  [5] Git Setup (Repository configuration)" -ForegroundColor White
Write-Host "  [6] Security Setup (Security checks and configuration)" -ForegroundColor White
Write-Host "  [7] EXNESS Trading System Setup (MetaTrader 5 & EAs)" -ForegroundColor White
Write-Host "  [8] VPS Services (Optional 24/7 trading system)" -ForegroundColor White
Write-Host ""

$confirm = Read-Host "Continue with full setup? (Y/N)"
if ($confirm -ne "Y" -and $confirm -ne "y") {
    Write-Host "Setup cancelled by user." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Starting full setup process..." -ForegroundColor Green
Write-Host ""

# Step 1: Complete Device Setup
Invoke-SetupScript -ScriptName "complete-device-setup.ps1" -StepNumber "[1/8]" -Description "Complete Device Setup"

# Step 2: Workspace Setup
Invoke-SetupScript -ScriptName "setup-workspace.ps1" -StepNumber "[2/8]" -Description "Workspace Setup" -Optional

# Step 3: Windows Auto Setup
Invoke-SetupScript -ScriptName "auto-setup.ps1" -StepNumber "[3/8]" -Description "Windows Auto Setup"

# Step 4: Cloud Sync Setup
Invoke-SetupScript -ScriptName "setup-cloud-sync.ps1" -StepNumber "[4/8]" -Description "Cloud Sync Setup" -Optional

# Step 5: Git Setup
Invoke-SetupScript -ScriptName "git-setup.ps1" -StepNumber "[5/8]" -Description "Git Setup" -Optional

# Step 6: Security Setup
Invoke-SetupScript -ScriptName "setup-security.ps1" -StepNumber "[6/8]" -Description "Security Setup" -Optional

# Step 7: EXNESS Trading System Setup
Invoke-SetupScript -ScriptName "AUTO-SETUP-EXNESS-ALL.ps1" -StepNumber "[7/8]" -Description "EXNESS Trading System Setup" -Optional

# Step 8: VPS Services (Optional)
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  [8/8] VPS Services Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[INFO] VPS services provide 24/7 automated trading" -ForegroundColor Cyan
Write-Host "[INFO] To set up VPS services, run: .\start-vps-system.ps1" -ForegroundColor Cyan
$setupSteps += @{Step="[8/8]"; Name="VPS Services Setup"; Status="Info"; Script="start-vps-system.ps1"}

# Calculate execution time
$endTime = Get-Date
$duration = $endTime - $startTime

# Final Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Full Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Execution Time: $($duration.ToString('mm\:ss'))" -ForegroundColor Cyan
Write-Host ""

# Display setup steps status
Write-Host "Setup Steps Summary:" -ForegroundColor Yellow
Write-Host ""
foreach ($step in $setupSteps) {
    $statusColor = switch ($step.Status) {
        "Success" { "Green" }
        "Warning" { "Yellow" }
        "Failed" { "Red" }
        "Skipped" { "Gray" }
        "NotFound" { "Gray" }
        "Info" { "Cyan" }
        default { "White" }
    }
    
    $statusIcon = switch ($step.Status) {
        "Success" { "✓" }
        "Warning" { "⚠" }
        "Failed" { "✗" }
        "Skipped" { "○" }
        "NotFound" { "○" }
        "Info" { "ℹ" }
        default { "-" }
    }
    
    Write-Host "  $statusIcon $($step.Step) $($step.Name)" -ForegroundColor $statusColor
}

Write-Host ""

# Display errors and warnings
if ($errors.Count -gt 0) {
    Write-Host "Errors Encountered:" -ForegroundColor Red
    foreach ($error in $errors) {
        Write-Host "  - $error" -ForegroundColor Red
    }
    Write-Host ""
}

if ($warnings.Count -gt 0) {
    Write-Host "Warnings:" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "  - $warning" -ForegroundColor Yellow
    }
    Write-Host ""
}

# Next steps
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Next Steps" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($errors.Count -eq 0) {
    Write-Host "Your system is now configured! Here's what to do next:" -ForegroundColor Green
    Write-Host ""
    Write-Host "1. Trading System:" -ForegroundColor Yellow
    Write-Host "   - Open MetaTrader 5 EXNESS Terminal" -ForegroundColor White
    Write-Host "   - Login with your EXNESS account credentials" -ForegroundColor White
    Write-Host "   - Enable AutoTrading (green button in toolbar)" -ForegroundColor White
    Write-Host "   - Compile and attach Expert Advisors" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Cloud Services:" -ForegroundColor Yellow
    Write-Host "   - Sign in to OneDrive (Lengkundee01@outlook.com)" -ForegroundColor White
    Write-Host "   - Sign in to Google Drive (Lengkundee01@gmail.com)" -ForegroundColor White
    Write-Host "   - Verify sync status in system tray icons" -ForegroundColor White
    Write-Host ""
    Write-Host "3. Git Operations:" -ForegroundColor Yellow
    Write-Host "   - Verify git configuration: git config --list" -ForegroundColor White
    Write-Host "   - Push changes: git push origin main" -ForegroundColor White
    Write-Host "   - Use GitHub Desktop for easier management" -ForegroundColor White
    Write-Host ""
    Write-Host "4. Optional - VPS Services:" -ForegroundColor Yellow
    Write-Host "   - Run: .\start-vps-system.ps1" -ForegroundColor White
    Write-Host "   - Or double-click: START-VPS-SYSTEM.bat" -ForegroundColor White
    Write-Host ""
    Write-Host "5. Documentation:" -ForegroundColor Yellow
    Write-Host "   - Review README.md for complete project overview" -ForegroundColor White
    Write-Host "   - Check EXNESS-COMPLETE-SETUP-GUIDE.md for trading setup" -ForegroundColor White
    Write-Host "   - See VPS-SETUP-GUIDE.md for 24/7 automation" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "Setup completed with errors. Please review the errors above." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "You may need to:" -ForegroundColor Yellow
    Write-Host "  1. Fix the errors manually" -ForegroundColor White
    Write-Host "  2. Run specific setup scripts individually" -ForegroundColor White
    Write-Host "  3. Check logs for more details" -ForegroundColor White
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Support & Documentation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "GitHub Repository:" -ForegroundColor Yellow
Write-Host "  https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-" -ForegroundColor White
Write-Host ""
Write-Host "Live Website:" -ForegroundColor Yellow
Write-Host "  https://mouy-leng.github.io/ZOLO-A6-9VxNUNA-/" -ForegroundColor White
Write-Host ""
Write-Host "For issues or questions, please create an issue on GitHub." -ForegroundColor Cyan
Write-Host ""

Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
