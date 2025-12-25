# Set Cursor Theme
# Manually set Cursor IDE theme to light or dark

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("Light", "Dark")]
    [string]$Theme,
    
    [Parameter(Mandatory=$false)]
    [string]$ThemeName
)

$ErrorActionPreference = "Stop"

Write-Host "`n╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Set Cursor Theme                        ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Default themes
$lightThemes = @{
    "Default" = "Default Light+"
    "Visual Studio" = "Visual Studio Light"
    "Quiet" = "Quiet Light"
    "Solarized" = "Solarized Light"
}

$darkThemes = @{
    "Default" = "Dark+"
    "Visual Studio" = "Visual Studio Dark"
    "Monokai" = "Monokai"
    "One Dark Pro" = "One Dark Pro"
    "GitHub" = "GitHub Dark"
}

# Settings file path
$settingsPath = Join-Path $PSScriptRoot ".vscode\settings.json"

if (-not (Test-Path $settingsPath)) {
    Write-Host "Error: settings.json not found at $settingsPath" -ForegroundColor Red
    exit 1
}

# Determine theme to use
$selectedTheme = $null

if ($ThemeName) {
    $selectedTheme = $ThemeName
    Write-Host "Using custom theme: $selectedTheme" -ForegroundColor Cyan
}
elseif ($Theme -eq "Light") {
    $selectedTheme = $lightThemes["Default"]
    Write-Host "Setting light theme: $selectedTheme" -ForegroundColor Yellow
}
elseif ($Theme -eq "Dark") {
    $selectedTheme = $darkThemes["Default"]
    Write-Host "Setting dark theme: $selectedTheme" -ForegroundColor Yellow
}
else {
    Write-Host "Error: Must specify -Theme or -ThemeName" -ForegroundColor Red
    Write-Host "`nUsage:" -ForegroundColor Yellow
    Write-Host "  .\set-cursor-theme.ps1 -Theme Light" -ForegroundColor Gray
    Write-Host "  .\set-cursor-theme.ps1 -Theme Dark" -ForegroundColor Gray
    Write-Host "  .\set-cursor-theme.ps1 -ThemeName 'Monokai'" -ForegroundColor Gray
    exit 1
}

try {
    # Read current settings
    $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json
    
    # Update theme
    $settings | Add-Member -NotePropertyName "workbench.colorTheme" -NotePropertyValue $selectedTheme -Force
    
    # Write back to file
    $settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8
    
    Write-Host "`n✓ Theme updated successfully!" -ForegroundColor Green
    Write-Host "  Current theme: $selectedTheme" -ForegroundColor White
    Write-Host "`n💡 Tip: Restart Cursor IDE to see the change" -ForegroundColor Yellow
    
} catch {
    Write-Host "`nError updating theme: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
