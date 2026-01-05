#Requires -Version 5.1
<#
.SYNOPSIS
    Launch Repository from HTML Trade Logs
.DESCRIPTION
    Opens the ReportTrade HTML log file and launches the complete repository startup sequence.
    This script provides a unified entry point using the HTML trading logs as a launch reference.
    Note: Some components (VPS system) may require Administrator privileges.
.PARAMETER HtmlLogPath
    Path to the HTML log file. If not specified, reads from html-log-config.txt or uses default.
.PARAMETER SkipLogOpen
    Skip opening the HTML log file and only launch the repository
.EXAMPLE
    .\launch-from-html-logs.ps1
    Opens the HTML log and launches all repository systems
.EXAMPLE
    .\launch-from-html-logs.ps1 -SkipLogOpen
    Launches repository without opening HTML log
.EXAMPLE
    .\launch-from-html-logs.ps1 -HtmlLogPath "C:\Custom\Path\Report.html"
    Uses a custom HTML log path
#>

param(
    [string]$HtmlLogPath = "",
    [switch]$SkipLogOpen
)

$ErrorActionPreference = "Continue"

# Function to read configuration file
function Read-Configuration {
    $configFile = Join-Path $PSScriptRoot "html-log-config.txt"
    $config = @{
        HtmlLogPath = "J:\OneDrive-Backup\ReportTrade.html"  # Generic default - update in config file
        OpenHtmlLogOnStartup = $true
        LaunchVpsSystem = $true
        LaunchTradingSystem = $true
        OpenGithubWebsite = $true
    }
    
    if (Test-Path $configFile) {
        try {
            $content = Get-Content $configFile -ErrorAction SilentlyContinue
            foreach ($line in $content) {
                if ($line -match '^HTML_LOG_PATH=(.+)$') {
                    $config.HtmlLogPath = $matches[1].Trim()
                }
                if ($line -match '^OPEN_HTML_LOG_ON_STARTUP=(true|false)$') {
                    $config.OpenHtmlLogOnStartup = $matches[1] -eq 'true'
                }
                if ($line -match '^LAUNCH_VPS_SYSTEM=(true|false)$') {
                    $config.LaunchVpsSystem = $matches[1] -eq 'true'
                }
                if ($line -match '^LAUNCH_TRADING_SYSTEM=(true|false)$') {
                    $config.LaunchTradingSystem = $matches[1] -eq 'true'
                }
                if ($line -match '^OPEN_GITHUB_WEBSITE=(true|false)$') {
                    $config.OpenGithubWebsite = $matches[1] -eq 'true'
                }
            }
        } catch {
            Write-Host "Warning: Could not read configuration file, using defaults" -ForegroundColor Yellow
        }
    }
    
    return $config
}

# Read configuration
$config = Read-Configuration

# Use parameter if provided, otherwise use config file value
if ([string]::IsNullOrEmpty($HtmlLogPath)) {
    $HtmlLogPath = $config.HtmlLogPath
}

# Color functions for output
function Write-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  $Message" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
}

function Write-Status {
    param([string]$Message, [string]$Status = "INFO")
    $color = switch($Status) {
        "OK" { "Green" }
        "INFO" { "Cyan" }
        "WARNING" { "Yellow" }
        "ERROR" { "Red" }
        default { "White" }
    }
    Write-Host "[$Status] $Message" -ForegroundColor $color
}

# Log file for launch tracking
$logDir = Join-Path $PSScriptRoot "logs"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}
$launchLogFile = Join-Path $logDir "html-launch-log.txt"

function Write-LaunchLog {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    Add-Content -Path $launchLogFile -Value $logMessage -ErrorAction SilentlyContinue
    Write-Status $Message "INFO"
}

Write-Header "ZOLO Repository Launch from HTML Logs"

# Check if running as Administrator (required for some components)
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Status "Not running as Administrator - some components may require elevation" "WARNING"
    Write-LaunchLog "Warning: Not running with administrator privileges"
} else {
    Write-Status "Running with administrator privileges" "OK"
}

Write-LaunchLog "Starting repository launch sequence"
Write-LaunchLog "HTML Log Path: $HtmlLogPath"

# Step 1: Open HTML Log File
if (-not $SkipLogOpen -and $config.OpenHtmlLogOnStartup) {
    Write-Status "Opening HTML Trade Report Log..." "INFO"
    
    if (Test-Path $HtmlLogPath) {
        try {
            Start-Process $HtmlLogPath
            Write-LaunchLog "HTML log opened successfully: $HtmlLogPath"
            Write-Status "HTML log opened in default browser" "OK"
        } catch {
            Write-Status "Failed to open HTML log: $_" "WARNING"
            Write-LaunchLog "Warning: Could not open HTML log - $_"
        }
    } else {
        Write-Status "HTML log file not found at: $HtmlLogPath" "WARNING"
        Write-LaunchLog "Warning: HTML log file not found"
        
        # Try to find the file in common locations
        # These are generic patterns - users should update html-log-config.txt with their actual paths
        $searchPaths = @(
            "J:\OneDrive*\ReportTrade*.html",
            "C:\Users\*\OneDrive*\ReportTrade*.html",
            "D:\Backup*\ReportTrade*.html",
            "$env:USERPROFILE\OneDrive*\ReportTrade*.html"
        )
        
        foreach ($searchPath in $searchPaths) {
            $foundFiles = Get-ChildItem -Path $searchPath -ErrorAction SilentlyContinue
            if ($foundFiles) {
                Write-Status "Found alternative HTML log: $($foundFiles[0].FullName)" "INFO"
                Write-LaunchLog "Using alternative HTML log: $($foundFiles[0].FullName)"
                Start-Process $foundFiles[0].FullName
                break
            }
        }
    }
    
    Start-Sleep -Seconds 2
}

# Step 2: Launch Repository Systems
Write-Header "Launching Repository Systems"

# 2a: Start VPS System if available
if ($config.LaunchVpsSystem) {
    $vpsScript = Join-Path $PSScriptRoot "start-vps-system.ps1"
    if (Test-Path $vpsScript) {
        Write-Status "Launching VPS System..." "INFO"
        if (-not $isAdmin) {
            Write-Status "VPS system requires Administrator privileges - attempting to elevate" "WARNING"
        }
        try {
            if ($isAdmin) {
                Start-Process powershell.exe -ArgumentList @('-ExecutionPolicy', 'RemoteSigned', '-File', $vpsScript) -WindowStyle Hidden
            } else {
                Start-Process powershell.exe -ArgumentList @('-ExecutionPolicy', 'RemoteSigned', '-File', $vpsScript) -Verb RunAs -WindowStyle Hidden
            }
            Write-LaunchLog "VPS system launched"
            Write-Status "VPS system started" "OK"
        } catch {
            Write-Status "VPS system launch failed: $_" "WARNING"
            Write-LaunchLog "Warning: VPS system launch failed - $_"
        }
    } else {
        Write-Status "VPS script not found, skipping" "WARNING"
    }
} else {
    Write-Status "VPS system launch disabled in configuration" "INFO"
}

Start-Sleep -Seconds 1

# 2b: Start Trading System if available
if ($config.LaunchTradingSystem) {
    $tradingScript = Join-Path $PSScriptRoot "setup-and-start-trading-auto.ps1"
    if (Test-Path $tradingScript) {
        Write-Status "Launching Trading System..." "INFO"
        try {
            Start-Process powershell.exe -ArgumentList @('-ExecutionPolicy', 'RemoteSigned', '-File', $tradingScript) -WindowStyle Hidden
            Write-LaunchLog "Trading system launched"
            Write-Status "Trading system started" "OK"
        } catch {
            Write-Status "Trading system launch failed: $_" "WARNING"
            Write-LaunchLog "Warning: Trading system launch failed - $_"
        }
    } else {
        Write-Status "Trading script not found, skipping" "WARNING"
    }
} else {
    Write-Status "Trading system launch disabled in configuration" "INFO"
}

Start-Sleep -Seconds 1

# 2c: Start the main system startup sequence
$startScript = Join-Path $PSScriptRoot "start.ps1"
if (Test-Path $startScript) {
    Write-Status "Launching main startup sequence..." "INFO"
    try {
        Start-Process powershell.exe -ArgumentList @('-ExecutionPolicy', 'RemoteSigned', '-File', $startScript) -NoNewWindow
        Write-LaunchLog "Main startup sequence launched"
        Write-Status "Startup sequence initiated" "OK"
    } catch {
        Write-Status "Startup sequence launch failed: $_" "WARNING"
        Write-LaunchLog "Warning: Startup sequence launch failed - $_"
    }
}

Start-Sleep -Seconds 1

# 2d: Open GitHub Pages website
if ($config.OpenGithubWebsite) {
    Write-Status "Opening GitHub Pages website..." "INFO"
    $websiteUrl = "https://mouy-leng.github.io/ZOLO-A6-9VxNUNA-/"
    try {
        Start-Process $websiteUrl
        Write-LaunchLog "GitHub Pages website opened"
        Write-Status "Website opened" "OK"
    } catch {
        Write-Status "Failed to open website: $_" "WARNING"
    }
} else {
    Write-Status "GitHub website launch disabled in configuration" "INFO"
}

# Step 3: Summary
Write-Header "Launch Complete"

Write-Status "Repository launch sequence completed!" "OK"
Write-Status "" "INFO"
Write-Status "Active Components:" "INFO"
Write-Status "  - HTML Trade Report Log" "INFO"
Write-Status "  - VPS Trading System" "INFO"
Write-Status "  - Trading Bridge" "INFO"
Write-Status "  - GitHub Pages Website" "INFO"
Write-Status "  - Repository Startup Scripts" "INFO"
Write-Status "" "INFO"
Write-Status "Launch log saved to: $launchLogFile" "INFO"
Write-Status "" "INFO"

Write-LaunchLog "Repository launch sequence completed successfully"

# Keep window open for a moment
Start-Sleep -Seconds 5
