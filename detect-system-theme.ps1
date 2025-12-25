# Detect System Theme
# Detect Windows system theme and apply matching Cursor theme

param(
    [switch]$ContinuousMonitoring,
    [int]$CheckIntervalSeconds = 60
)

$ErrorActionPreference = "Stop"

Write-Host "`n╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Detect System Theme                     ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝`n" -ForegroundColor Cyan

function Get-SystemTheme {
    try {
        # Check Windows theme setting
        $regPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        $appsUseLightTheme = Get-ItemProperty -Path $regPath -Name "AppsUseLightTheme" -ErrorAction SilentlyContinue
        
        if ($null -ne $appsUseLightTheme) {
            if ($appsUseLightTheme.AppsUseLightTheme -eq 1) {
                return "Light"
            }
            else {
                return "Dark"
            }
        }
        else {
            Write-Host "⚠ Could not detect system theme, defaulting to Light" -ForegroundColor Yellow
            return "Light"
        }
    }
    catch {
        Write-Host "⚠ Error detecting system theme: $($_.Exception.Message)" -ForegroundColor Yellow
        return "Light"
    }
}

function Set-CursorThemeFromSystem {
    $systemTheme = Get-SystemTheme
    
    Write-Host "System theme detected: $systemTheme" -ForegroundColor White
    Write-Host "Applying matching Cursor theme..." -ForegroundColor Gray
    Write-Host ""
    
    $themeScript = Join-Path $PSScriptRoot "set-cursor-theme.ps1"
    
    if (-not (Test-Path $themeScript)) {
        Write-Host "Error: set-cursor-theme.ps1 not found" -ForegroundColor Red
        return $false
    }
    
    try {
        & $themeScript -Theme $systemTheme
        return $true
    }
    catch {
        Write-Host "Error applying theme: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Initial theme application
$success = Set-CursorThemeFromSystem

if (-not $success) {
    Write-Host "`nFailed to apply theme" -ForegroundColor Red
    exit 1
}

if ($ContinuousMonitoring) {
    Write-Host "`n📡 Continuous monitoring enabled" -ForegroundColor Cyan
    Write-Host "Checking for system theme changes every $CheckIntervalSeconds seconds" -ForegroundColor Gray
    Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
    Write-Host ""
    
    $lastTheme = Get-SystemTheme
    
    while ($true) {
        Start-Sleep -Seconds $CheckIntervalSeconds
        
        $currentTheme = Get-SystemTheme
        
        if ($currentTheme -ne $lastTheme) {
            Write-Host "`n[$(Get-Date -Format 'HH:mm:ss')] System theme changed: $lastTheme → $currentTheme" -ForegroundColor Yellow
            Set-CursorThemeFromSystem | Out-Null
            $lastTheme = $currentTheme
        }
    }
}
else {
    Write-Host "`n✓ Theme applied successfully!" -ForegroundColor Green
    Write-Host "`n💡 Tip: Use -ContinuousMonitoring to keep theme in sync with system" -ForegroundColor Yellow
    Write-Host ""
}
