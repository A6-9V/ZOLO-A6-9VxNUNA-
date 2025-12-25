# MQL5 Directory Structure Review

## Purpose
Review all folders in MetaEditor/MQL5 directory before compilation to understand the structure and ensure proper file placement.

## Standard MQL5 Directory Structure

```
MQL5/
├── Experts/          # Expert Advisors (.mq5 files)
├── Indicators/       # Custom Indicators (.mq5 files)
├── Scripts/          # Scripts (.mq5 files)
├── Include/          # Header files (.mqh files)
├── Libraries/        # Library files (.mq5 files)
├── Files/            # Data files
└── Logs/             # Compilation logs
```

## Our EA Files Location

### Source Files (Project)
```
D:\ZOLO-A6-9VxNUNA-\trading-bridge\mql5\
├── Experts\
│   ├── PythonBridgeEA.mq5      ← Our EA
│   ├── CryptoSmartMoneyEA.mq5
│   └── SmartMoneyConceptEA.mq5
└── Include\
    └── PythonBridge.mqh         ← Our include file
```

### Target Location (MT5)
```
%APPDATA%\MetaQuotes\Terminal\[MT5_ID]\MQL5\
├── Experts\
│   ├── PythonBridgeEA.mq5      ← Should be here
│   └── PythonBridgeEA.ex5      ← Compiled file (after compilation)
└── Include\
    └── PythonBridge.mqh         ← Should be here
```

## Review Checklist

Before compiling, verify:

- [ ] **Experts folder exists** in MT5 MQL5 directory
- [ ] **Include folder exists** in MT5 MQL5 directory
- [ ] **PythonBridgeEA.mq5** is in Experts folder
- [ ] **PythonBridge.mqh** is in Include folder
- [ ] No duplicate files with different names
- [ ] File paths are correct

## Commands to Review Structure

### Open MQL5 Folder in Explorer
```powershell
$mt5 = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$d = Get-ChildItem $mt5 -Directory | Select-Object -First 1
$mql5 = Join-Path $d.FullName "MQL5"
Start-Process explorer.exe -ArgumentList $mql5
```

### List All Directories
```powershell
$mt5 = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$d = Get-ChildItem $mt5 -Directory | Select-Object -First 1
$mql5 = Join-Path $d.FullName "MQL5"
Get-ChildItem $mql5 -Directory | Select-Object Name
```

### Check Our Files
```powershell
$mt5 = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$d = Get-ChildItem $mt5 -Directory | Select-Object -First 1
$ea = Join-Path $d.FullName "MQL5\Experts\PythonBridgeEA.mq5"
$inc = Join-Path $d.FullName "MQL5\Include\PythonBridge.mqh"
Write-Host "EA exists:" (Test-Path $ea)
Write-Host "Include exists:" (Test-Path $inc)
```

## Next Steps After Review

1. **Verify folder structure** matches expected layout
2. **Check file locations** are correct
3. **Open MetaEditor** (F4 in MT5)
4. **Navigate to Experts folder** in MetaEditor
5. **Open PythonBridgeEA.mq5**
6. **Compile** (F7)

---

**Note:** The MQL5 folder has been opened in Explorer for visual review.

