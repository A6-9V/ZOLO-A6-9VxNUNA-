# 📊 MetaEditor Log Monitoring Guide

Complete guide for monitoring MetaEditor compilation logs and troubleshooting MQL5 Expert Advisor development.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Quick Start](#quick-start)
3. [Usage Modes](#usage-modes)
4. [Log File Location](#log-file-location)
5. [Common Issues](#common-issues)
6. [Integration with Trading System](#integration-with-trading-system)
7. [Troubleshooting](#troubleshooting)

---

## 📖 Overview

The MetaEditor Log Monitor provides comprehensive monitoring and analysis of MetaEditor compilation logs. It helps developers:

- ✅ Monitor real-time compilation activity
- ✅ Quickly identify compilation errors and warnings
- ✅ Track successful compilations
- ✅ Analyze historical log data
- ✅ Debug Expert Advisor development issues

---

## 🚀 Quick Start

### Method 1: Using Batch File (Recommended for beginners)

Double-click: `MONITOR-METAEDITOR.bat`

This launches an interactive menu where you can select:
1. Recent logs (default)
2. Real-time monitoring
3. Errors and warnings only
4. Complete summary

### Method 2: Using PowerShell Script Directly

```powershell
# Show recent logs (default)
.\monitor-metaeditor-logs.ps1

# Real-time monitoring
.\monitor-metaeditor-logs.ps1 -Mode tail

# Show only errors and warnings
.\monitor-metaeditor-logs.ps1 -Mode errors

# Complete summary
.\monitor-metaeditor-logs.ps1 -Mode summary

# Custom number of lines
.\monitor-metaeditor-logs.ps1 -Mode recent -Lines 100
```

---

## 🔧 Usage Modes

### 1. Recent Mode (Default)

Displays the most recent log entries.

```powershell
.\monitor-metaeditor-logs.ps1 -Mode recent -Lines 50
```

**Use Case:**
- Quick check of recent compilation activity
- Review what happened in the last compilation session
- Default behavior for casual monitoring

**Output:**
- Last 50 lines (or specified number)
- Color-coded by severity
- Easy to scan for issues

---

### 2. Tail Mode (Real-Time Monitoring)

Monitors logs in real-time as compilation happens.

```powershell
.\monitor-metaeditor-logs.ps1 -Mode tail
```

**Use Case:**
- Active development sessions
- Watching compilation process live
- Debugging compilation issues as they occur

**How to Use:**
1. Start the monitor: `.\monitor-metaeditor-logs.ps1 -Mode tail`
2. Keep the window open
3. Compile your EAs in MetaEditor
4. See results appear in real-time
5. Press `Ctrl+C` to stop monitoring

---

### 3. Errors Mode

Shows only errors and warnings from recent compilations.

```powershell
.\monitor-metaeditor-logs.ps1 -Mode errors
```

**Use Case:**
- Troubleshooting compilation failures
- Quick error diagnosis
- Before committing code changes

**Output:**
- All errors (in red)
- All warnings (in yellow)
- Recent successful compilations (in green)
- Summary counts

---

### 4. Summary Mode

Provides complete log statistics and overview.

```powershell
.\monitor-metaeditor-logs.ps1 -Mode summary
```

**Use Case:**
- Overall health check
- Log file management
- System status reporting

**Output:**
- Log file information (size, location, last modified)
- Total statistics (errors, warnings, successes)
- Last 10 log entries
- Complete overview

---

## 📂 Log File Location

### Default Path

The MetaEditor log is located at:

```
C:\Users\USER\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\Logs\metaeditor.log
```

### Path Components

- **AppData\Roaming\MetaQuotes**: MetaTrader 5 data directory
- **Terminal\53785E099C927DB68A545C249CDBCE06**: Specific terminal instance (EXNESS)
- **Logs\metaeditor.log**: MetaEditor log file

### Verifying Path

```powershell
# Check if log exists
Test-Path "$env:APPDATA\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\Logs\metaeditor.log"

# View log directly
notepad "$env:APPDATA\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\Logs\metaeditor.log"
```

---

## 🛠 Common Issues

### Issue 1: Log File Not Found

**Symptom:**
```
[WARNING] MetaEditor log file not found
```

**Solution:**
1. Ensure MetaTrader 5 EXNESS is installed
2. Launch MetaEditor at least once
3. Compile any EA to generate initial log
4. Run monitor again

**Steps:**
```powershell
# 1. Launch MetaEditor
& "C:\Program Files\MetaTrader 5 EXNESS\metaeditor64.exe"

# 2. Compile any EA (press F7 in MetaEditor)

# 3. Run monitor
.\monitor-metaeditor-logs.ps1
```

---

### Issue 2: Permission Denied

**Symptom:**
```
[ERROR] Failed to read log: Access denied
```

**Solution:**
1. Close MetaEditor (it may lock the log file)
2. Run PowerShell as Administrator
3. Try again

```powershell
# Close MetaEditor
Stop-Process -Name metaeditor64 -ErrorAction SilentlyContinue

# Run monitor again
.\monitor-metaeditor-logs.ps1
```

---

### Issue 3: Empty or No Output

**Symptom:**
- Monitor runs but shows no logs
- Log file exists but appears empty

**Solution:**
1. Verify MetaEditor has been used for compilation
2. Check log file directly
3. Ensure terminal ID is correct

```powershell
# Check log content directly
Get-Content "$env:APPDATA\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\Logs\metaeditor.log"

# Check if any log files exist
Get-ChildItem "$env:APPDATA\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\Logs\"
```

---

## 🔗 Integration with Trading System

### With Compilation Scripts

Use the monitor after running EA compilation:

```powershell
# Compile all EAs
.\compile-mql5-eas.ps1

# Check results
.\monitor-metaeditor-logs.ps1 -Mode errors
```

### With Trading Bridge Setup

Monitor logs during EA setup:

```powershell
# Setup EA
.\trading-bridge\setup-ea-simple.ps1

# Monitor compilation
.\monitor-metaeditor-logs.ps1 -Mode tail
```

### Automated Workflow

Create a combined script:

```powershell
# compile-and-monitor.ps1
Write-Host "Compiling Expert Advisors..." -ForegroundColor Cyan
.\compile-mql5-eas.ps1

Write-Host ""
Write-Host "Checking compilation results..." -ForegroundColor Cyan
.\monitor-metaeditor-logs.ps1 -Mode errors

Write-Host ""
Write-Host "Complete summary..." -ForegroundColor Cyan
.\monitor-metaeditor-logs.ps1 -Mode summary
```

---

## 🐛 Troubleshooting

### Debug Mode

For detailed troubleshooting:

```powershell
# Run with verbose output
$VerbosePreference = "Continue"
.\monitor-metaeditor-logs.ps1 -Mode summary -Verbose

# Check terminal directory
Get-ChildItem "$env:APPDATA\MetaQuotes\Terminal\" -Recurse | Where-Object { $_.Name -eq "metaeditor.log" }
```

### Manual Log Access

If the script fails, access logs manually:

```powershell
# Open in Notepad
notepad "$env:APPDATA\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\Logs\metaeditor.log"

# Open logs folder in Explorer
explorer "$env:APPDATA\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\Logs\"

# View in PowerShell
Get-Content "$env:APPDATA\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\Logs\metaeditor.log" -Tail 50
```

### Finding Your Terminal ID

If your terminal ID is different:

```powershell
# List all MetaTrader terminal instances
Get-ChildItem "$env:APPDATA\MetaQuotes\Terminal\" -Directory | Select-Object Name

# Find the one with Logs folder
Get-ChildItem "$env:APPDATA\MetaQuotes\Terminal\" -Directory | ForEach-Object {
    $logsPath = Join-Path $_.FullName "Logs"
    if (Test-Path $logsPath) {
        Write-Host "Terminal ID: $($_.Name)" -ForegroundColor Green
        Write-Host "Logs Path: $logsPath" -ForegroundColor Cyan
    }
}
```

If you find a different terminal ID, update the script:

1. Open `monitor-metaeditor-logs.ps1`
2. Find line: `$terminalId = "53785E099C927DB68A545C249CDBCE06"`
3. Replace with your terminal ID
4. Save and run again

---

## 📊 Log Analysis Tips

### Color Coding

The monitor uses colors to highlight important information:

- 🔴 **Red**: Errors, failures, exceptions
- 🟡 **Yellow**: Warnings, potential issues
- 🟢 **Green**: Success, completed operations
- 🔵 **Cyan**: Information, status updates
- ⚪ **White**: Normal log entries

### Best Practices

1. **Check errors after each compilation:**
   ```powershell
   .\monitor-metaeditor-logs.ps1 -Mode errors
   ```

2. **Use tail mode during development:**
   ```powershell
   .\monitor-metaeditor-logs.ps1 -Mode tail
   ```

3. **Regular summary checks:**
   ```powershell
   .\monitor-metaeditor-logs.ps1 -Mode summary
   ```

4. **Clean old logs periodically:**
   ```powershell
   # Backup and clear old logs
   $logFile = "$env:APPDATA\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\Logs\metaeditor.log"
   Copy-Item $logFile "$logFile.backup"
   Clear-Content $logFile
   ```

---

## 🔄 Automation

### Scheduled Monitoring

Create a task to monitor logs daily:

```powershell
# Create scheduled task
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$PWD\monitor-metaeditor-logs.ps1`" -Mode summary"
$trigger = New-ScheduledTaskTrigger -Daily -At "23:00"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName "MetaEditor Log Check" -Action $action -Trigger $trigger -Settings $settings -Description "Daily MetaEditor log summary"
```

### Integration with CI/CD

Add to your deployment pipeline:

```yaml
# In your CI/CD workflow
- name: Check MetaEditor Compilation
  run: |
    powershell -File monitor-metaeditor-logs.ps1 -Mode errors
```

---

## 📞 Support

For issues or questions:

1. Check this guide first
2. Review [EXNESS Complete Setup Guide](EXNESS-COMPLETE-SETUP-GUIDE.md)
3. Check [Trading Bridge Documentation](trading-bridge/README.md)
4. Review existing issues in the repository

---

## 🔗 Related Documentation

- [EXNESS Complete Setup Guide](EXNESS-COMPLETE-SETUP-GUIDE.md)
- [Trading System Setup](TRADING-SYSTEM-SETUP-SUMMARY.md)
- [MQL5 EA Compilation](compile-mql5-eas.ps1)
- [Trading Bridge Setup](trading-bridge/SETUP-STATUS.md)

---

<div align="center">

**⚡ Part of ZOLO-A6-9VxNUNA Trading System**

</div>
