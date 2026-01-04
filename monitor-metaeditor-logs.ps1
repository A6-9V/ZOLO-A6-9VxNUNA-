#Requires -Version 5.1
<#
.SYNOPSIS
    Monitor MetaEditor compilation logs and errors
.DESCRIPTION
    Monitors MetaEditor log files for compilation errors, warnings, and general activity.
    Provides real-time monitoring and historical log viewing capabilities.
.PARAMETER Mode
    Operation mode: 'tail' for real-time monitoring, 'recent' for recent logs, 'errors' for error summary
.PARAMETER Lines
    Number of lines to display (default: 50)
.EXAMPLE
    .\monitor-metaeditor-logs.ps1 -Mode tail
    Monitor logs in real-time
.EXAMPLE
    .\monitor-metaeditor-logs.ps1 -Mode recent -Lines 100
    Display last 100 lines of logs
.EXAMPLE
    .\monitor-metaeditor-logs.ps1 -Mode errors
    Show compilation errors and warnings
#>

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("tail", "recent", "errors", "summary")]
    [string]$Mode = "recent",
    
    [Parameter(Mandatory=$false)]
    [int]$Lines = 50
)

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MetaEditor Log Monitor" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# MetaTrader 5 Terminal ID (EXNESS)
$terminalId = "53785E099C927DB68A545C249CDBCE06"
$metaQuotesPath = "$env:APPDATA\MetaQuotes\Terminal\$terminalId"
$logsPath = Join-Path $metaQuotesPath "Logs"
$metaEditorLog = Join-Path $logsPath "metaeditor.log"

# Check if log path exists
Write-Host "[INFO] Checking MetaEditor installation..." -ForegroundColor Yellow

if (-not (Test-Path $metaQuotesPath)) {
    Write-Host "[ERROR] MetaTrader 5 data directory not found at: $metaQuotesPath" -ForegroundColor Red
    Write-Host "[INFO] Expected path: $metaQuotesPath" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Please ensure MetaTrader 5 EXNESS is installed and has been launched at least once." -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path $logsPath)) {
    Write-Host "[WARNING] Logs directory not found at: $logsPath" -ForegroundColor Yellow
    Write-Host "[INFO] Creating logs directory..." -ForegroundColor Cyan
    try {
        New-Item -Path $logsPath -ItemType Directory -Force | Out-Null
        Write-Host "[OK] Logs directory created" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Failed to create logs directory: $_" -ForegroundColor Red
        exit 1
    }
}

if (-not (Test-Path $metaEditorLog)) {
    Write-Host "[WARNING] MetaEditor log file not found at: $metaEditorLog" -ForegroundColor Yellow
    Write-Host "[INFO] Log file will be created when MetaEditor is used" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To generate logs, open MetaEditor and compile an Expert Advisor." -ForegroundColor Yellow
    exit 0
}

Write-Host "[OK] Found MetaEditor log: $metaEditorLog" -ForegroundColor Green
$logInfo = Get-Item $metaEditorLog
Write-Host "[INFO] Log size: $([math]::Round($logInfo.Length/1KB, 2)) KB" -ForegroundColor Cyan
Write-Host "[INFO] Last modified: $($logInfo.LastWriteTime)" -ForegroundColor Cyan
Write-Host ""

# Function to parse and colorize log lines
function Format-LogLine {
    param([string]$Line)
    
    if ($Line -match "error|failed|exception") {
        Write-Host $Line -ForegroundColor Red
    }
    elseif ($Line -match "warning") {
        Write-Host $Line -ForegroundColor Yellow
    }
    elseif ($Line -match "success|completed|ok") {
        Write-Host $Line -ForegroundColor Green
    }
    elseif ($Line -match "info|started|begin") {
        Write-Host $Line -ForegroundColor Cyan
    }
    else {
        Write-Host $Line -ForegroundColor White
    }
}

# Function to extract compilation summary
function Get-CompilationSummary {
    param([string[]]$LogContent)
    
    $errors = @()
    $warnings = @()
    $successes = @()
    
    foreach ($line in $LogContent) {
        if ($line -match "error") {
            $errors += $line
        }
        elseif ($line -match "warning") {
            $warnings += $line
        }
        elseif ($line -match "success|compiled") {
            $successes += $line
        }
    }
    
    return @{
        Errors = $errors
        Warnings = $warnings
        Successes = $successes
    }
}

# Execute based on mode
switch ($Mode) {
    "tail" {
        Write-Host "[MODE] Real-time Log Monitoring" -ForegroundColor Cyan
        Write-Host "[INFO] Press Ctrl+C to stop monitoring" -ForegroundColor Yellow
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host ""
        
        try {
            Get-Content $metaEditorLog -Tail $Lines -Wait | ForEach-Object {
                Format-LogLine $_
            }
        } catch {
            Write-Host "[ERROR] Failed to monitor log: $_" -ForegroundColor Red
        }
    }
    
    "recent" {
        Write-Host "[MODE] Recent Log Entries (Last $Lines lines)" -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host ""
        
        try {
            $recentLines = Get-Content $metaEditorLog -Tail $Lines
            foreach ($line in $recentLines) {
                Format-LogLine $line
            }
        } catch {
            Write-Host "[ERROR] Failed to read log: $_" -ForegroundColor Red
        }
    }
    
    "errors" {
        Write-Host "[MODE] Compilation Errors & Warnings" -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host ""
        
        try {
            $logContent = Get-Content $metaEditorLog -Tail 1000
            $summary = Get-CompilationSummary -LogContent $logContent
            
            if ($summary.Errors.Count -gt 0) {
                Write-Host "ERRORS ($($summary.Errors.Count)):" -ForegroundColor Red
                Write-Host "----------------------------------------" -ForegroundColor Red
                foreach ($error in $summary.Errors) {
                    Write-Host "  $error" -ForegroundColor Red
                }
                Write-Host ""
            } else {
                Write-Host "[OK] No compilation errors found" -ForegroundColor Green
                Write-Host ""
            }
            
            if ($summary.Warnings.Count -gt 0) {
                Write-Host "WARNINGS ($($summary.Warnings.Count)):" -ForegroundColor Yellow
                Write-Host "----------------------------------------" -ForegroundColor Yellow
                foreach ($warning in $summary.Warnings) {
                    Write-Host "  $warning" -ForegroundColor Yellow
                }
                Write-Host ""
            } else {
                Write-Host "[OK] No compilation warnings found" -ForegroundColor Green
                Write-Host ""
            }
            
            if ($summary.Successes.Count -gt 0) {
                Write-Host "SUCCESSFUL COMPILATIONS ($($summary.Successes.Count)):" -ForegroundColor Green
                Write-Host "----------------------------------------" -ForegroundColor Green
                $recentSuccesses = $summary.Successes | Select-Object -Last 5
                foreach ($success in $recentSuccesses) {
                    Write-Host "  $success" -ForegroundColor Green
                }
                if ($summary.Successes.Count -gt 5) {
                    Write-Host "  ... and $($summary.Successes.Count - 5) more" -ForegroundColor Gray
                }
                Write-Host ""
            }
        } catch {
            Write-Host "[ERROR] Failed to analyze log: $_" -ForegroundColor Red
        }
    }
    
    "summary" {
        Write-Host "[MODE] Log Summary" -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host ""
        
        try {
            $logContent = Get-Content $metaEditorLog
            $totalLines = $logContent.Count
            $summary = Get-CompilationSummary -LogContent $logContent
            
            Write-Host "Log File: $metaEditorLog" -ForegroundColor White
            Write-Host "Total Lines: $totalLines" -ForegroundColor White
            Write-Host "File Size: $([math]::Round($logInfo.Length/1KB, 2)) KB" -ForegroundColor White
            Write-Host "Last Modified: $($logInfo.LastWriteTime)" -ForegroundColor White
            Write-Host ""
            Write-Host "Summary Statistics:" -ForegroundColor Cyan
            Write-Host "  Errors: $($summary.Errors.Count)" -ForegroundColor $(if ($summary.Errors.Count -gt 0) { "Red" } else { "Green" })
            Write-Host "  Warnings: $($summary.Warnings.Count)" -ForegroundColor $(if ($summary.Warnings.Count -gt 0) { "Yellow" } else { "Green" })
            Write-Host "  Successful Compilations: $($summary.Successes.Count)" -ForegroundColor Green
            Write-Host ""
            
            # Show last 10 lines
            Write-Host "Last 10 Log Entries:" -ForegroundColor Cyan
            Write-Host "----------------------------------------" -ForegroundColor Cyan
            $lastLines = $logContent | Select-Object -Last 10
            foreach ($line in $lastLines) {
                Format-LogLine $line
            }
        } catch {
            Write-Host "[ERROR] Failed to generate summary: $_" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Log Monitor Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Additional information
Write-Host "[INFO] Log Location: $metaEditorLog" -ForegroundColor Cyan
Write-Host "[INFO] Usage Examples:" -ForegroundColor Cyan
Write-Host "  .\monitor-metaeditor-logs.ps1 -Mode tail        # Real-time monitoring" -ForegroundColor White
Write-Host "  .\monitor-metaeditor-logs.ps1 -Mode recent      # Recent logs" -ForegroundColor White
Write-Host "  .\monitor-metaeditor-logs.ps1 -Mode errors      # Errors & warnings" -ForegroundColor White
Write-Host "  .\monitor-metaeditor-logs.ps1 -Mode summary     # Complete summary" -ForegroundColor White
Write-Host ""
