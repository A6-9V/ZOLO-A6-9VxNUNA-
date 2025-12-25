# Quick Reference - EA Setup & MT5 Connection

## 🚀 One-Command Setup

```batch
cd "D:\ZOLO-A6-9VxNUNA-\trading-bridge"
setup-ea.bat
```

---

## ✅ Verification

```powershell
cd "D:\ZOLO-A6-9VxNUNA-\trading-bridge"
.\verify-ea-setup.ps1
```

---

## 📋 Quick Checklist

- [ ] Run `setup-ea.bat`
- [ ] Verify compilation (check for `.ex5` file)
- [ ] Open MT5 Terminal
- [ ] Attach EA to chart
- [ ] Set BridgePort: `5555`
- [ ] Set BrokerName: `EXNESS`
- [ ] Enable AutoTrading button
- [ ] Check Experts tab for connection

---

## 🔧 Common Commands

### Check Trading Service
```powershell
Get-NetTCPConnection -LocalPort 5555
```

### Start Trading Service
```powershell
cd "D:\ZOLO-A6-9VxNUNA-\trading-bridge"
python run-trading-service.py
```

### View Logs
```powershell
Get-Content "D:\ZOLO-A6-9VxNUNA-\trading-bridge\logs\*.log" -Tail 30
```

### Manual Compilation
1. Open MT5 → Press **F4** (MetaEditor)
2. Open `PythonBridgeEA.mq5`
3. Press **F7** (Compile)

---

## 📍 Key File Locations

**Source:**
- `D:\ZOLO-A6-9VxNUNA-\trading-bridge\mql5\Experts\PythonBridgeEA.mq5`
- `D:\ZOLO-A6-9VxNUNA-\trading-bridge\mql5\Include\PythonBridge.mqh`

**MT5 Target:**
- `%APPDATA%\MetaQuotes\Terminal\[MT5_ID]\MQL5\Experts\PythonBridgeEA.mq5`
- `%APPDATA%\MetaQuotes\Terminal\[MT5_ID]\MQL5\Include\PythonBridge.mqh`

---

## 🐛 Quick Troubleshooting

**EA won't compile?**
- Check include file is in MT5 Include folder
- Open MetaEditor and check compile log

**EA won't connect?**
- Verify trading service running: `Get-NetTCPConnection -LocalPort 5555`
- Check port matches: EA BridgePort = 5555
- Ensure service started BEFORE attaching EA

**No trades executing?**
- AutoTrading button enabled? (should be green)
- Check MT5 Journal tab for errors
- Verify symbol is in active schedule

---

**For detailed instructions, see:**
- `EA-SETUP-COMPLETE.md` - Full automation guide
- `MANUAL-NEXT-STEPS.md` - Detailed manual steps

