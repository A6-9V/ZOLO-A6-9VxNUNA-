#Requires -Version 5.1
<#
.SYNOPSIS
    Launch Repository from HTML Trade Logs
.DESCRIPTION
    Opens the ReportTrade HTML log file and launches the complete repository startup sequence.
    This script provides a unified entry point using the HTML trading logs as a launch reference.
    
    NOTE: This script intentionally does NOT require administrator privileges by default.
    Unlike start-vps-system.ps1 which has #Requires -RunAsAdministrator, this script
    performs selective elevation only for components that need it (e.g., VPS system).
    This allows the script to run in non-admin mode while still launching privileged components.
    
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
    # Use a more portable default path
    $defaultPath = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "ReportTrade.html"
    
    $config = @{
        HtmlLogPath = $defaultPath
        AltHtmlLogPaths = @(
            "C:\Users\*\Documents\*ReportTrade*.html",
            "C:\Users\*\OneDrive*\ReportTrade*.html",
            "D:\Backup*\ReportTrade*.html"
        )
        OpenHtmlLogOnStartup = $true
        LaunchVpsSystem = $true
        LaunchTradingSystem = $true
        OpenGithubWebsite = $true
        GithubWebsiteUrl = "https://accounting-pw8oj98.public.builtwithrocket.new/?rk_owner=true"
        KeepLaunchLogs = $true
        LaunchLogDir = "logs"
    }
    
    if (Test-Path $configFile) {
        try {
            $content = Get-Content $configFile -ErrorAction SilentlyContinue
            foreach ($line in $content) {
                # Normalize line: trim, remove inline comments, and skip empty/comment-only lines
                $cleanLine = $line.Trim()
                $commentIndex = $cleanLine.IndexOf('#')
                if ($commentIndex -ge 0) {
                    $cleanLine = $cleanLine.Substring(0, $commentIndex).Trim()
                }
                if ([string]::IsNullOrWhiteSpace($cleanLine)) {
                    continue
                }
                
                if ($cleanLine -match '^HTML_LOG_PATH=(.+)$') {
                    $val = $matches[1].Trim()
                    # Resolve environment variables like %USERPROFILE%
                    $config.HtmlLogPath = [System.Environment]::ExpandEnvironmentVariables($val)
                }
                if ($cleanLine -match '^ALT_HTML_LOG_PATHS=(.+)$') {
                    $paths = $matches[1].Trim() -split ','
                    # Expand environment variables in each alternative path
                    $config.AltHtmlLogPaths = $paths | ForEach-Object { 
                        [System.Environment]::ExpandEnvironmentVariables($_.Trim())
                    }
                }
                if ($cleanLine -match '^OPEN_HTML_LOG_ON_STARTUP=(true|false)$') {
                    $config.OpenHtmlLogOnStartup = $matches[1] -eq 'true'
                }
                if ($cleanLine -match '^LAUNCH_VPS_SYSTEM=(true|false)$') {
                    $config.LaunchVpsSystem = $matches[1] -eq 'true'
                }
                if ($cleanLine -match '^LAUNCH_TRADING_SYSTEM=(true|false)$') {
                    $config.LaunchTradingSystem = $matches[1] -eq 'true'
                }
                if ($cleanLine -match '^OPEN_GITHUB_WEBSITE=(true|false)$') {
                    $config.OpenGithubWebsite = $matches[1] -eq 'true'
                }
                if ($cleanLine -match '^GITHUB_WEBSITE_URL=(.+)$') {
                    $config.GithubWebsiteUrl = $matches[1].Trim()
                }
                if ($cleanLine -match '^KEEP_LAUNCH_LOGS=(true|false)$') {
                    $config.KeepLaunchLogs = $matches[1] -eq 'true'
                }
                if ($cleanLine -match '^LAUNCH_LOG_DIR=(.+)$') {
                    $val = $matches[1].Trim()
                    # Basic path traversal protection - only reject obvious directory traversal attempts
                    # Allow normal Windows paths (C:\logs) and relative paths (logs)
                    if ($val -like "*..*" -or $val -like "*../*" -or $val -like "*..\\*") {
                        Write-Host "Warning: Invalid LAUNCH_LOG_DIR in config (path traversal attempt), using default 'logs'" -ForegroundColor Yellow
                    } else {
                        $config.LaunchLogDir = $val
                    }
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

# Selective Elevation Design: 
# This script does not use '#Requires -RunAsAdministrator' at the top.
# Instead, it handles elevation selectively for components that need it (like VPS system).
# This ensures other components can still launch even if the user declines elevation.

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

# Log file for launch tracking (only if enabled in config)
$launchLogFile = $null
if ($config.KeepLaunchLogs) {
    $logDir = Join-Path $PSScriptRoot $config.LaunchLogDir
    if (-not (Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }
    $launchLogFile = Join-Path $logDir "html-launch-log.txt"
}

function Write-LaunchLog {
    param([string]$Message)
    if ($config.KeepLaunchLogs -and $launchLogFile) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent().Name
        $logMessage = "[$timestamp] [$currentUser] $Message"
        Add-Content -Path $launchLogFile -Value $logMessage -ErrorAction SilentlyContinue
    }
    Write-Status $Message "INFO"
}

# Helper function to launch PowerShell scripts
# NOTE: The return value only indicates that Start-Process was invoked without throwing.
# It does NOT wait for or validate the success or failure of the launched script itself.
function Start-PowerShellScript {
    param(
        [string]$ScriptPath,
        [switch]$Hidden,
        [switch]$NoNewWindow,
        [switch]$RequireElevation
    )
    
    # Use Bypass and NoProfile for consistency and reliability
    $argList = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $ScriptPath)
    
    try {
        # Note: Start-Process only indicates if the process was successfully started.
        # It does not wait for or validate the actual execution result of the script.
        if ($RequireElevation -and -not $isAdmin) {
            Start-Process powershell.exe -ArgumentList $argList -Verb RunAs -WindowStyle $(if($Hidden){'Hidden'}else{'Normal'})
        } else {
            if ($NoNewWindow) {
                Start-Process powershell.exe -ArgumentList $argList -NoNewWindow
            } else {
                Start-Process powershell.exe -ArgumentList $argList -WindowStyle $(if($Hidden){'Hidden'}else{'Normal'})
            }
        }
        # Return true only means Start-Process didn't throw - not that the script succeeded
        return $true
    } catch {
        # An exception here means the process could not be started (e.g., invalid path, access denied)
        return $false
    }
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
        
        # Try to find the file using configured alternative paths
        Write-Status "Searching for HTML log in configured alternative locations..." "INFO"
        
        foreach ($searchPath in $config.AltHtmlLogPaths) {
            # Sort by LastWriteTime to get the newest file first
            $foundFiles = Get-ChildItem -Path $searchPath -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
            if ($foundFiles) {
                $fileToOpen = $foundFiles[0].FullName
                Write-Status "Found alternative HTML log: $fileToOpen" "INFO"
                Write-LaunchLog "Using alternative HTML log: $fileToOpen"
                try {
                    Start-Process $fileToOpen
                    break
                } catch {
                    Write-Status "Failed to open found file $fileToOpen: $_" "WARNING"
                }
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
        
        if (Start-PowerShellScript -ScriptPath $vpsScript -Hidden -RequireElevation) {
            Write-LaunchLog "VPS system launched"
            Write-Status "VPS system started" "OK"
        } else {
            Write-Status "VPS system launch failed" "WARNING"
            Write-LaunchLog "Warning: VPS system launch failed"
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
        
        if (Start-PowerShellScript -ScriptPath $tradingScript -Hidden) {
            Write-LaunchLog "Trading system launched"
            Write-Status "Trading system started" "OK"
        } else {
            Write-Status "Trading system launch failed" "WARNING"
            Write-LaunchLog "Warning: Trading system launch failed"
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
    
    if (Start-PowerShellScript -ScriptPath $startScript -NoNewWindow) {
        Write-LaunchLog "Main startup sequence launched"
        Write-Status "Startup sequence initiated" "OK"
    } else {
        Write-Status "Startup sequence launch failed" "WARNING"
        Write-LaunchLog "Warning: Startup sequence launch failed"
    }
}

Start-Sleep -Seconds 1

# 2d: Open GitHub Pages website
if ($config.OpenGithubWebsite) {
    Write-Status "Opening GitHub Pages website..." "INFO"
    $websiteUrl = $config.GithubWebsiteUrl
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

if ($config.OpenHtmlLogOnStartup -and -not $SkipLogOpen) {
    Write-Status "  - HTML Trade Report Log" "INFO"
}
if ($config.LaunchVpsSystem) {
    Write-Status "  - VPS Trading System" "INFO"
}
if ($config.LaunchTradingSystem) {
    Write-Status "  - Trading Bridge" "INFO"
}
if ($config.OpenGithubWebsite) {
    Write-Status "  - GitHub Pages Website" "INFO"
}

$startScript = Join-Path $PSScriptRoot "start.ps1"
if (Test-Path $startScript) {
    Write-Status "  - Repository Startup Scripts" "INFO"
}
Write-Status "" "INFO"
if ($config.KeepLaunchLogs -and $launchLogFile) {
    Write-Status "Launch log saved to: $launchLogFile" "INFO"
} else {
    Write-Status "Launch logging disabled in configuration" "INFO"
}
Write-Status "" "INFO"

Write-LaunchLog "Repository launch sequence completed successfully"

# Keep window open for a moment
Start-Sleep -Seconds 5
