# Manual Next Steps - EA Compilation & MT5 Setup

**Current Status**: ✅ Trading Service Running  
**Action Required**: Complete EA compilation and MT5 attachment

---

## 🚀 Quick Start - Automated Setup

**Recommended**: Use the automation script for easiest setup:

```batch
cd "D:\ZOLO-A6-9VxNUNA-\trading-bridge"
setup-ea.bat
```

Or run PowerShell script directly:
```powershell
cd "D:\ZOLO-A6-9VxNUNA-\trading-bridge"
.\setup-ea-and-compile.ps1
```

This will automatically:
- Check/start trading service
- Copy EA files to MT5
- Attempt compilation
- Show verification status

**See `EA-SETUP-COMPLETE.md` for full automation details.**

---

## Step 1: Copy EA Files to MT5 (If Not Already Done)

### Option A: Use Automation Script (Recommended)
Run `setup-ea.bat` or `setup-ea-and-compile.ps1` (see above)

### Option B: Manual PowerShell Copy
Run this PowerShell command:
```powershell
cd "D:\ZOLO-A6-9VxNUNA-\trading-bridge"
$mt5Dirs = Get-ChildItem "$env:APPDATA\MetaQuotes\Terminal" | Where-Object { $_.PSIsContainer } | Select-Object -First 1
if ($mt5Dirs) {
    $mt5Experts = Join-Path $mt5Dirs.FullName "MQL5\Experts"
    $mt5Include = Join-Path $mt5Dirs.FullName "MQL5\Include"
    if (-not (Test-Path $mt5Experts)) { New-Item -ItemType Directory -Path $mt5Experts -Force }
    if (-not (Test-Path $mt5Include)) { New-Item -ItemType Directory -Path $mt5Include -Force }
    Copy-Item "mql5\Experts\PythonBridgeEA.mq5" -Destination "$mt5Experts\PythonBridgeEA.mq5" -Force
    Copy-Item "mql5\Include\PythonBridge.mqh" -Destination "$mt5Include\PythonBridge.mqh" -Force
    Write-Host "Files copied successfully!" -ForegroundColor Green
}
```

### Option C: Manual File Copy
1. Navigate to: `D:\ZOLO-A6-9VxNUNA-\trading-bridge\mql5\`
2. Copy `Experts\PythonBridgeEA.mq5` to:
   - `C:\Users\USER\AppData\Roaming\MetaQuotes\Terminal\[YOUR_MT5_ID]\MQL5\Experts\`
3. Copy `Include\PythonBridge.mqh` to:
   - `C:\Users\USER\AppData\Roaming\MetaQuotes\Terminal\[YOUR_MT5_ID]\MQL5\Include\`

---

## Step 2: Compile Expert Advisor

### Method 1: Using MetaEditor GUI (Recommended)

1. **Open MetaEditor**
   - Press **F4** in MT5 Terminal, OR
   - Tools → MetaQuotes Language Editor, OR
   - Launch: `C:\Program Files\MetaTrader 5 EXNESS\metaeditor64.exe`

2. **Open EA File**
   - Press **Ctrl+O** (or File → Open)
   - Navigate to: `C:\Users\USER\AppData\Roaming\MetaQuotes\Terminal\[YOUR_MT5_ID]\MQL5\Experts\PythonBridgeEA.mq5`
   - Click Open

3. **Compile**
   - Press **F7** (or click Compile button)
   - Wait for compilation to complete

4. **Verify**
   - Check compile log at bottom: Should show "0 error(s), 0 warning(s)"
   - Verify file created: `PythonBridgeEA.ex5` in same directory

### Method 2: Command Line (If MetaEditor Found)

```powershell
$metaEditor = "C:\Program Files\MetaTrader 5 EXNESS\metaeditor64.exe"
$eaPath = "$env:APPDATA\MetaQuotes\Terminal\[YOUR_MT5_ID]\MQL5\Experts\PythonBridgeEA.mq5"
& $metaEditor /compile:"$eaPath" /log
```

---

## Step 3: Attach EA to Chart in MT5

1. **Open MetaTrader 5 Terminal**
   - Launch MT5 if not already running
   - Log into your Exness account

2. **Open a Chart**
   - Open a chart for one of your active symbols:
     - **Weekdays**: EURUSD, GBPUSD, USDJPY, AUDUSD, USDCAD, EURJPY, GBPJPY
     - **Weekends**: BTCUSD, ETHUSD, XAUUSD
   - Example: Right-click EURUSD → Chart Window

3. **Attach Expert Advisor**
   - Open **Navigator** panel (Ctrl+N if not visible)
   - Expand **Expert Advisors** section
   - Find **PythonBridgeEA**
   - **Drag and drop** PythonBridgeEA onto the chart
   - OR: Right-click chart → Expert Advisors → PythonBridgeEA

4. **Configure Parameters**
   In the dialog that appears, set:
   - **BridgePort**: `5555` (must match Python bridge port)
   - **BrokerName**: `EXNESS`
   - **AutoExecute**: `true` (to execute trades automatically)
   - **DefaultLotSize**: `0.01` (or your preferred lot size)
   - **MaxRetries**: `3` (default)
   - **RetryDelay**: `5` (default)
   - Click **OK**

5. **Enable AutoTrading**
   - Click the **AutoTrading** button in MT5 toolbar (should turn green)
   - This allows EAs to execute trades

---

## Step 4: Verify Connection

### Check MT5 Experts Tab

1. In MT5, go to **Terminal** tab (bottom panel)
2. Click **Experts** sub-tab
3. Look for messages like:
   - ✅ "Python Bridge EA initialized"
   - ✅ "Bridge connection initialized on port 5555"
   - ✅ "Connected to Python bridge"
   - ❌ **No error messages**

### Check Python Logs

```powershell
Get-Content "D:\ZOLO-A6-9VxNUNA-\trading-bridge\logs\*.log" -Tail 30
```

Look for:
- "Bridge listening on port 5555"
- "Client connected"
- "Signal received"

### Test Bridge Connection

```powershell
cd "D:\ZOLO-A6-9VxNUNA-\trading-bridge"
python test-bridge-connection.py
```

This will:
- Start a test bridge instance
- Show connection status
- Test signal queuing
- Display bridge statistics

**Note**: The test script runs a separate bridge. Your main service continues running.

---

## Troubleshooting

### EA Won't Compile

**Error: Cannot find PythonBridge.mqh**
- Verify include file is in: `MQL5\Include\PythonBridge.mqh`
- Check file path in EA: `#include "PythonBridge.mqh"`

**Compilation Errors**
- Check compile log in MetaEditor for specific errors
- Verify all required MQL5 standard libraries are available
- Ensure file paths are correct

### EA Won't Connect to Bridge

**Connection Failed**
- Verify Python service is running: `Get-Process python`
- Check port 5555 is not blocked by firewall
- Ensure EA BridgePort (5555) matches Python bridge port
- Verify Python service started BEFORE attaching EA

**Port Already in Use**
- Check if another instance is using port 5555
- Stop other Python trading services if needed
- Restart Python service

### No Trades Executing

**Check These:**
- AutoTrading button is enabled (green) in MT5
- EA is attached to correct symbol chart
- Symbol is in active trading schedule (weekday vs weekend)
- Broker API credentials are correct (if using API)
- Check MT5 Journal tab for error messages

---

## Quick Reference

### File Locations

**Source Files:**
- EA: `D:\ZOLO-A6-9VxNUNA-\trading-bridge\mql5\Experts\PythonBridgeEA.mq5`
- Include: `D:\ZOLO-A6-9VxNUNA-\trading-bridge\mql5\Include\PythonBridge.mqh`

**MT5 Files:**
- EA: `%APPDATA%\MetaQuotes\Terminal\[MT5_ID]\MQL5\Experts\PythonBridgeEA.mq5`
- Include: `%APPDATA%\MetaQuotes\Terminal\[MT5_ID]\MQL5\Include\PythonBridge.mqh`

### Important Settings

- **Bridge Port**: 5555 (must match on both sides)
- **Broker Name**: EXNESS
- **AutoExecute**: true (for automatic trading)
- **Default Lot Size**: 0.01

### Status Check Commands

```powershell
# Check service
Get-Process python | Where-Object { $_.Path -like '*trading*' }

# View logs
Get-Content "D:\ZOLO-A6-9VxNUNA-\trading-bridge\logs\*.log" -Tail 50

# Check port
Get-NetTCPConnection -LocalPort 5555 -ErrorAction SilentlyContinue
```

---

## ✅ Completion Checklist

- [ ] EA files copied to MT5 directory
- [ ] EA compiled successfully (PythonBridgeEA.ex5 exists)
- [ ] MT5 Terminal running and logged in
- [ ] EA attached to chart
- [ ] Parameters configured (Port: 5555, Broker: EXNESS)
- [ ] AutoTrading enabled in MT5
- [ ] Connection verified in MT5 Experts tab
- [ ] Python logs show bridge activity
- [ ] No error messages in MT5 or Python logs

---

**Once all steps are complete, your trading system will be fully operational!**

*Last Updated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")*

