# Auto-Switch Cursor Theme
# Automatically switch Cursor theme based on time of day

param(
    [Parameter(Mandatory=$false)]
    [string]$LightThemeStart = "07:00",
    
    [Parameter(Mandatory=$false)]
    [string]$DarkThemeStart = "19:00",
    
    [switch]$Silent
)

$ErrorActionPreference = "Stop"

if (-not $Silent) {
    Write-Host "`n╔══════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  Auto-Switch Cursor Theme                ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════╝`n" -ForegroundColor Cyan
}

# Get current time
$currentTime = Get-Date
$currentHour = $currentTime.Hour
$currentMinute = $currentTime.Minute

# Parse time strings
$lightStart = [datetime]::ParseExact($LightThemeStart, "HH:mm", $null)
$darkStart = [datetime]::ParseExact($DarkThemeStart, "HH:mm", $null)

# Determine if current time is in light or dark period
$lightStartMinutes = $lightStart.Hour * 60 + $lightStart.Minute
$darkStartMinutes = $darkStart.Hour * 60 + $darkStart.Minute
$currentMinutes = $currentHour * 60 + $currentMinute

$shouldUseLightTheme = $false

if ($lightStartMinutes -lt $darkStartMinutes) {
    # Normal day: light starts before dark (e.g., 7:00-19:00)
    $shouldUseLightTheme = ($currentMinutes -ge $lightStartMinutes) -and ($currentMinutes -lt $darkStartMinutes)
}
else {
    # Spanning midnight: dark starts before light (e.g., 19:00-7:00 next day)
    $shouldUseLightTheme = ($currentMinutes -ge $lightStartMinutes) -or ($currentMinutes -lt $darkStartMinutes)
}

if (-not $Silent) {
    Write-Host "Current time: $($currentTime.ToString('HH:mm'))" -ForegroundColor White
    Write-Host "Light theme period: $LightThemeStart - $DarkThemeStart" -ForegroundColor Gray
    Write-Host ""
}

# Set theme based on time
$themeScript = Join-Path $PSScriptRoot "set-cursor-theme.ps1"

if (-not (Test-Path $themeScript)) {
    Write-Host "Error: set-cursor-theme.ps1 not found" -ForegroundColor Red
    exit 1
}

try {
    if ($shouldUseLightTheme) {
        if (-not $Silent) {
            Write-Host "⛅ Daytime - Switching to light theme..." -ForegroundColor Yellow
        }
        & $themeScript -Theme Light
    }
    else {
        if (-not $Silent) {
            Write-Host "🌙 Nighttime - Switching to dark theme..." -ForegroundColor Cyan
        }
        & $themeScript -Theme Dark
    }
    
    if (-not $Silent) {
        Write-Host "`n✓ Theme switched successfully!" -ForegroundColor Green
    }
    
} catch {
    Write-Host "`nError: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

if (-not $Silent) {
    Write-Host ""
}
