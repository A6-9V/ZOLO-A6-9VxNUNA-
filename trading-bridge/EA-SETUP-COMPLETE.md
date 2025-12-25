# EA Setup - Automation Scripts Created

## ✅ Current Status

- **EA Source Files**: Ready
  - `mql5\Experts\PythonBridgeEA.mq5` ✓
  - `mql5\Include\PythonBridge.mqh` ✓

- **Automation Scripts**: Created
  - `setup-ea-and-compile.ps1` - Full automation script
  - `setup-ea.bat` - Batch wrapper for easy execution
  - `verify-ea-setup.ps1` - Quick verification script

---

## 🚀 Quick Start

### Option 1: Automated Setup (Recommended)

**Double-click or run:**
```batch
setup-ea.bat
```

This will:
1. Check/start trading service
2. Copy EA files to MT5
3. Attempt compilation
4. Show verification status

### Option 2: Manual Steps

See `MANUAL-NEXT-STEPS.md` for detailed manual instructions.

---

## 📋 What the Scripts Do

### `setup-ea-and-compile.ps1`

**Step 1: Trading Service Check**
- Checks if Python trading service is running on port 5555
- Starts service if not running

**Step 2: MT5 Directory Detection**
- Finds MT5 installation in `%APPDATA%\MetaQuotes\Terminal`
- Creates MQL5 directories if needed

**Step 3: File Copy**
- Copies `PythonBridgeEA.mq5` → MT5 Experts folder
- Copies `PythonBridge.mqh` → MT5 Include folder

**Step 4: Compilation**
- Attempts to find MetaEditor
- Tries automatic compilation via command line
- Verifies `.ex5` file creation

### `verify-ea-setup.ps1`

Quick status check:
- Trading service status (port 5555)
- EA file presence
- Include file presence
- Compiled EX5 status

---

## 📍 File Locations

### Source Files
```
D:\ZOLO-A6-9VxNUNA-\trading-bridge\
├── mql5\
│   ├── Experts\
│   │   └── PythonBridgeEA.mq5
│   └── Include\
│       └── PythonBridge.mqh
```

### MT5 Target Files
```
%APPDATA%\MetaQuotes\Terminal\[MT5_ID]\
├── MQL5\
│   ├── Experts\
│   │   ├── PythonBridgeEA.mq5
│   │   └── PythonBridgeEA.ex5 (after compilation)
│   └── Include\
│       └── PythonBridge.mqh
```

---

## 🔧 Manual Compilation (If Needed)

If automatic compilation fails:

1. **Open MetaEditor**
   - Press **F4** in MT5 Terminal, OR
   - Tools → MetaQuotes Language Editor

2. **Open EA File**
   - File → Open
   - Navigate to: `%APPDATA%\MetaQuotes\Terminal\[MT5_ID]\MQL5\Experts\PythonBridgeEA.mq5`

3. **Compile**
   - Press **F7** (or click Compile button)
   - Verify: "0 error(s), 0 warning(s)" in compile log

4. **Verify**
   - Check for `PythonBridgeEA.ex5` in same directory

---

## 🎯 Next Steps After Setup

### 1. Attach EA to Chart

1. Open MT5 Terminal
2. Open a chart (e.g., EURUSD)
3. Drag **PythonBridgeEA** from Navigator to chart
4. Configure parameters:
   - **BridgePort**: `5555`
   - **BrokerName**: `EXNESS`
   - **AutoExecute**: `true`
   - **DefaultLotSize**: `0.01`
5. Click **OK**

### 2. Enable AutoTrading

- Click **AutoTrading** button in MT5 toolbar (should turn green)

### 3. Verify Connection

**Check MT5 Experts Tab:**
- Look for: "Python Bridge EA initialized"
- Look for: "Bridge connection initialized on port 5555"
- No error messages

**Check Python Logs:**
```powershell
Get-Content "D:\ZOLO-A6-9VxNUNA-\trading-bridge\logs\*.log" -Tail 30
```

---

## 🐛 Troubleshooting

### Script Won't Run

**PowerShell Execution Policy:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Files Not Copied

**Manual Copy:**
1. Copy `mql5\Experts\PythonBridgeEA.mq5` to MT5 Experts folder
2. Copy `mql5\Include\PythonBridge.mqh` to MT5 Include folder

### Compilation Fails

**Common Issues:**
- Missing include file → Verify `PythonBridge.mqh` is in Include folder
- Syntax errors → Check compile log in MetaEditor
- Missing libraries → Ensure MT5 is fully installed

### EA Won't Connect

**Check:**
- Trading service running: `Get-NetTCPConnection -LocalPort 5555`
- Port matches: EA BridgePort (5555) = Python bridge port
- Firewall not blocking port 5555
- Service started BEFORE attaching EA

---

## 📊 Status Commands

```powershell
# Check trading service
Get-NetTCPConnection -LocalPort 5555

# Verify EA files
.\verify-ea-setup.ps1

# View logs
Get-Content "logs\*.log" -Tail 50

# Check Python processes
Get-Process python | Where-Object { $_.Path -like '*trading*' }
```

---

## ✅ Completion Checklist

- [ ] Run `setup-ea.bat` or `setup-ea-and-compile.ps1`
- [ ] Verify files copied to MT5 (use `verify-ea-setup.ps1`)
- [ ] Compile EA (automatic or manual F7 in MetaEditor)
- [ ] Verify `PythonBridgeEA.ex5` exists
- [ ] Trading service running on port 5555
- [ ] Attach EA to chart in MT5
- [ ] Configure parameters (Port: 5555, Broker: EXNESS)
- [ ] Enable AutoTrading in MT5
- [ ] Check MT5 Experts tab for connection messages
- [ ] Verify Python logs show bridge activity

---

**Last Updated**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

