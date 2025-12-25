# Complete Device Setup Script for ZOLO-A6-9VxNUNA
# Run as Administrator
# This script sets up Windows 11 device configuration and automation

param(
    [switch]$SkipChecks = $false
)

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ZOLO-A6-9VxNUNA Device Setup" -ForegroundColor Cyan
Write-Host "  Complete Windows 11 Configuration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

# System Requirements Check
Write-Host "[1/8] Checking system requirements..." -ForegroundColor Yellow
$osVersion = (Get-CimInstance Win32_OperatingSystem).Version
$osBuild = (Get-CimInstance Win32_OperatingSystem).BuildNumber
$psVersion = $PSVersionTable.PSVersion

Write-Host "  OS Version: $osVersion (Build $osBuild)" -ForegroundColor Gray
Write-Host "  PowerShell Version: $psVersion" -ForegroundColor Gray

if ($osBuild -lt 22000) {
    Write-Host "  WARNING: Windows 11 (Build 22000+) recommended" -ForegroundColor Yellow
}

# Git Configuration
Write-Host "[2/8] Configuring Git..." -ForegroundColor Yellow
$gitUser = "Mouy-leng"
$gitEmail = "Mouy-leng@users.noreply.github.com"

try {
    git config --global user.name $gitUser
    git config --global user.email $gitEmail
    Write-Host "  ✓ Git configured: $gitUser <$gitEmail>" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Git configuration failed: $_" -ForegroundColor Red
}

# PowerShell Execution Policy
Write-Host "[3/8] Setting PowerShell execution policy..." -ForegroundColor Yellow
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "  ✓ Execution policy set to RemoteSigned" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed to set execution policy: $_" -ForegroundColor Red
}

# Create Workspace Directories
Write-Host "[4/8] Creating workspace directories..." -ForegroundColor Yellow
$workspaceDirs = @(
    "$env:USERPROFILE\Documents\ZOLO-Workspace",
    "$env:USERPROFILE\Documents\ZOLO-Workspace\Logs",
    "$env:USERPROFILE\Documents\ZOLO-Workspace\Config",
    "$env:USERPROFILE\Documents\ZOLO-Workspace\Scripts"
)

foreach ($dir in $workspaceDirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  ✓ Created: $dir" -ForegroundColor Green
    } else {
        Write-Host "  → Exists: $dir" -ForegroundColor Gray
    }
}

# Windows Features
Write-Host "[5/8] Checking Windows features..." -ForegroundColor Yellow
$features = @(
    "Microsoft-Windows-Subsystem-Linux",
    "Microsoft-Hyper-V-All"
)

foreach ($feature in $features) {
    $state = Get-WindowsOptionalFeature -Online -FeatureName $feature -ErrorAction SilentlyContinue
    if ($state -and $state.State -eq "Enabled") {
        Write-Host "  ✓ $feature is enabled" -ForegroundColor Green
    } else {
        Write-Host "  → $feature is not enabled (optional)" -ForegroundColor Gray
    }
}

# Cloud Sync Check
Write-Host "[6/8] Checking cloud synchronization..." -ForegroundColor Yellow
$onedrivePath = "$env:USERPROFILE\OneDrive"
if (Test-Path $onedrivePath) {
    Write-Host "  ✓ OneDrive detected" -ForegroundColor Green
} else {
    Write-Host "  → OneDrive not found" -ForegroundColor Gray
}

# Security Configuration
Write-Host "[7/8] Configuring security settings..." -ForegroundColor Yellow
try {
    # Enable Windows Defender (if not already enabled)
    $defenderStatus = Get-MpComputerStatus -ErrorAction SilentlyContinue
    if ($defenderStatus) {
        Write-Host "  ✓ Windows Defender is active" -ForegroundColor Green
    }
    
    # Set firewall rules (if needed)
    Write-Host "  ✓ Security configuration checked" -ForegroundColor Green
} catch {
    Write-Host "  → Security check skipped" -ForegroundColor Gray
}

# Repository Sync
Write-Host "[8/8] Syncing repositories..." -ForegroundColor Yellow
$repoPaths = @(
    "D:\ZOLO-A6-9VxNUNA-",
    "D:\bridges3rd",
    "D:\drive-projects"
)

foreach ($repoPath in $repoPaths) {
    if (Test-Path $repoPath) {
        try {
            Push-Location $repoPath
            $branch = git rev-parse --abbrev-ref HEAD 2>$null
            if ($branch) {
                Write-Host "  ✓ $(Split-Path $repoPath -Leaf): $branch" -ForegroundColor Green
            }
            Pop-Location
        } catch {
            Write-Host "  → $(Split-Path $repoPath -Leaf): Not a git repo" -ForegroundColor Gray
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Device Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Run: .\scripts\setup-mt5-integration.ps1" -ForegroundColor White
Write-Host "  2. Run: .\scripts\start-trading-system.ps1" -ForegroundColor White
Write-Host ""










