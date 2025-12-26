# Setup Cursor Light Theme
# Copies system-setup/cursor-settings.json into Cursor User settings.

param(
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Cursor Light Theme Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

try {
    if (-not $env:APPDATA) {
        throw "APPDATA environment variable is not set. This script is intended for Windows."
    }

    $repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
    $sourceSettings = Join-Path $repoRoot "system-setup\cursor-settings.json"
    $targetSettings = Join-Path $env:APPDATA "Cursor\User\settings.json"

    if (-not (Test-Path $sourceSettings)) {
        throw "Source settings file not found: $sourceSettings"
    }

    if ($DryRun) {
        Write-Host "[INFO] DRY RUN - no changes will be made" -ForegroundColor Yellow
        Write-Host "[INFO] Would copy: $sourceSettings" -ForegroundColor Gray
        Write-Host "[INFO] To:         $targetSettings" -ForegroundColor Gray
        exit 0
    }

    $targetDir = Split-Path -Parent $targetSettings
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Write-Host "[OK] Created Cursor settings directory" -ForegroundColor Green
    }

    if (Test-Path $targetSettings) {
        $backupPath = "$targetSettings.backup-$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item $targetSettings $backupPath -Force -ErrorAction SilentlyContinue
        Write-Host "[OK] Backed up existing settings: $backupPath" -ForegroundColor Green
    } else {
        Write-Host "[INFO] No existing Cursor settings found (will create new)" -ForegroundColor Cyan
    }

    Copy-Item $sourceSettings $targetSettings -Force
    Write-Host "[OK] Applied Cursor settings (light theme)" -ForegroundColor Green
    Write-Host "[INFO] Restart Cursor to apply changes" -ForegroundColor Cyan
} catch {
    Write-Host "[ERROR] Failed to apply Cursor light theme: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

