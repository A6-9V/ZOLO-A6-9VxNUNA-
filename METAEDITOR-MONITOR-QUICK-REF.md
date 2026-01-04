# 📊 MetaEditor Log Monitor - Quick Reference

Quick reference card for MetaEditor log monitoring commands.

---

## 🚀 Quick Start

### Interactive Menu
```cmd
MONITOR-METAEDITOR.bat
```

### PowerShell Commands
```powershell
# Recent logs (default)
.\monitor-metaeditor-logs.ps1

# Real-time monitoring
.\monitor-metaeditor-logs.ps1 -Mode tail

# Errors & warnings only
.\monitor-metaeditor-logs.ps1 -Mode errors

# Complete summary
.\monitor-metaeditor-logs.ps1 -Mode summary
```

---

## 📋 Command Options

| Mode | Description | Use Case |
|------|-------------|----------|
| `recent` | Shows last N lines | Quick check of recent activity |
| `tail` | Real-time monitoring | Active development sessions |
| `errors` | Errors & warnings only | Troubleshooting compilation |
| `summary` | Complete statistics | Overall health check |

---

## 🎨 Color Coding

- 🔴 **Red** = Errors, failures
- 🟡 **Yellow** = Warnings
- 🟢 **Green** = Success
- 🔵 **Cyan** = Information
- ⚪ **White** = Normal logs

---

## 📁 Log Location

```
C:\Users\USER\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\Logs\metaeditor.log
```

Quick access:
```powershell
notepad "$env:APPDATA\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\Logs\metaeditor.log"
```

---

## 🔗 Integration Examples

### After Compilation
```powershell
.\compile-mql5-eas.ps1
.\monitor-metaeditor-logs.ps1 -Mode errors
```

### During Development
```powershell
# Terminal 1: Monitor logs
.\monitor-metaeditor-logs.ps1 -Mode tail

# Terminal 2: Compile in MetaEditor (F7)
```

### Daily Check
```powershell
.\monitor-metaeditor-logs.ps1 -Mode summary
```

---

## 🛠 Troubleshooting

### Log Not Found
```powershell
# Check if MetaEditor has been used
Get-ChildItem "$env:APPDATA\MetaQuotes\Terminal\" -Recurse | Where-Object { $_.Name -eq "metaeditor.log" }
```

### Find Terminal ID
```powershell
Get-ChildItem "$env:APPDATA\MetaQuotes\Terminal\" -Directory | ForEach-Object {
    if (Test-Path (Join-Path $_.FullName "Logs")) {
        Write-Host $_.Name
    }
}
```

---

## 📖 Full Documentation

See [METAEDITOR-LOG-MONITOR-GUIDE.md](METAEDITOR-LOG-MONITOR-GUIDE.md) for complete documentation.

---

## ⚡ Common Workflows

### 1. Pre-Compilation Check
```powershell
.\monitor-metaeditor-logs.ps1 -Mode summary
```

### 2. Watch Compilation
```powershell
.\monitor-metaeditor-logs.ps1 -Mode tail
# Then compile in MetaEditor
```

### 3. Post-Compilation Review
```powershell
.\compile-mql5-eas.ps1
.\monitor-metaeditor-logs.ps1 -Mode errors
```

### 4. Debug Issues
```powershell
.\monitor-metaeditor-logs.ps1 -Mode errors
# Review errors
.\monitor-metaeditor-logs.ps1 -Mode recent -Lines 100
# See context
```

---

<div align="center">

**⚡ Part of ZOLO-A6-9VxNUNA Trading System**

[Full Guide](METAEDITOR-LOG-MONITOR-GUIDE.md) | [README](README.md) | [Trading System](TRADING-SYSTEM-SETUP-SUMMARY.md)

</div>
