# EA Compilation Status

## Current Status

**EA Files:** ✅ Copied to MT5  
**Compilation:** ❌ Requires Manual Step

## Why Manual Compilation?

MetaEditor was not found in standard installation locations. This is common when:
- MT5 is installed in a custom location
- MetaEditor needs to be launched from within MT5
- Installation path is not in registry

## Quick Compilation Steps

### Method 1: Using MT5 Terminal (Easiest)

1. **Open MetaTrader 5 Terminal**
2. **Press F4** (opens MetaEditor)
3. **File → Open** (or Ctrl+O)
4. Navigate to: `%APPDATA%\MetaQuotes\Terminal\[MT5_ID]\MQL5\Experts\PythonBridgeEA.mq5`
5. **Press F7** (or click Compile button)
6. **Verify:** Check compile log shows "0 error(s), 0 warning(s)"
7. **Verify:** `PythonBridgeEA.ex5` file exists in same folder

### Method 2: Using Script

Run:
```powershell
cd "D:\ZOLO-A6-9VxNUNA-\trading-bridge"
.\open-ea-for-compilation.ps1
```

This will:
- Open the EA file location in Explorer
- Attempt to open MetaEditor if found
- Show manual steps if MetaEditor not found

## Verify Compilation

After compiling, verify with:
```powershell
powershell -Command "$mt5 = Join-Path $env:APPDATA 'MetaQuotes\Terminal'; $d = Get-ChildItem $mt5 -Directory | Select-Object -First 1; $ex5 = Join-Path $d.FullName 'MQL5\Experts\PythonBridgeEA.ex5'; Write-Host 'Compiled:' (Test-Path $ex5)"
```

## After Compilation

Once `PythonBridgeEA.ex5` exists:

1. **Open MT5 Terminal**
2. **Open a chart** (e.g., EURUSD)
3. **Drag PythonBridgeEA** from Navigator to chart
4. **Configure:**
   - BridgePort: `5555`
   - BrokerName: `EXNESS`
   - AutoExecute: `true`
5. **Enable AutoTrading** button (should turn green)
6. **Check Experts tab** for connection messages

---

**Note:** The EA source files are ready and in place. Only compilation step remains.

