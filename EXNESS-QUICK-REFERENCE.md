# 🚀 EXNESS Quick Reference Card

Quick reference for EXNESS Terminal, App Settings, EA, and VPS.

---

## 📍 File Locations

**EXNESS Terminal:**
```
C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe
```

**MetaEditor:**
```
C:\Program Files\MetaTrader 5 EXNESS\metaeditor64.exe
```

**EA Directory:**
```
C:\Users\USER\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\MQL5\Experts\Advisors
```

**MQL5 Repository:**
```
C:\Users\USER\OneDrive\mql5-repo\Experts\Advisors
```

---

## ⚡ Quick Commands

### Launch & Setup
```powershell
# Complete setup (automated)
.\setup-exness-complete.ps1

# Launch EXNESS Terminal
.\launch-exness-trading.ps1

# Compile EAs
.\compile-mql5-eas.ps1
```

### VPS Commands
```powershell
# Deploy VPS services (one-time)
.\vps-deployment.ps1

# Start VPS system
.\start-vps-system.ps1

# Stop VPS system
.\stop-vps.ps1

# Restart VPS system
.\stop-vps.ps1 -Restart

# Verify VPS
.\vps-verification.ps1

# Update VPS
.\update-vps.ps1

# Update EAs from logs
.\update-expert-by-vps-log.ps1
```

---

## 🎨 Color Scheme Quick Setup

### Dark Theme (Recommended)
```
Background: RGB(30, 30, 30)
Foreground: RGB(200, 200, 200)
Grid: RGB(60, 60, 60)
Bullish: RGB(0, 200, 0)
Bearish: RGB(200, 0, 0)
Bid Line: RGB(255, 255, 0)
Ask Line: RGB(0, 255, 255)
```

**Apply:**
1. Right-click chart → Properties (or F8)
2. Colors tab → Configure colors
3. Click OK

---

## 📊 Symbol Setup

### Add Symbol to Market Watch
1. Press `Ctrl+M` (Market Watch)
2. Right-click → Symbols
3. Search symbol (e.g., EURUSD)
4. Click Show → Close

### Open Chart
- Right-click symbol → Chart Window
- Or drag symbol to chart area

### Chart Timeframe
- Right-click chart → Timeframes → Select (M1, M5, M15, M30, H1, H4, D1, W1, MN1)

---

## 🤖 EA Quick Setup

### 1. Copy EA to Terminal
```powershell
# Automated (via setup script)
.\setup-exness-complete.ps1

# Manual: Copy from mql5-repo to terminal directory
```

### 2. Compile EA
- Open MetaEditor
- Open EA file (Ctrl+O)
- Press F7 (Compile)
- Check Errors tab: "0 error(s), 0 warning(s)"

### 3. Attach EA to Chart
1. Open chart (symbol + timeframe)
2. Press Ctrl+N (Navigator)
3. Drag EA from Navigator to chart
4. Configure parameters:
   - Risk: 1.0 (1%)
   - Stop Loss: 20-30 pips
   - Take Profit: 50-75 pips
   - Magic Number: Unique ID
5. Click OK
6. Enable AutoTrading (green button)

### 4. Monitor EA
- **Terminal Tab**: Ctrl+T (trades)
- **Journal Tab**: Ctrl+J (messages)
- **Experts Tab**: View → Toolbox → Experts (EA status)

---

## ⚙️ EA Parameters (Recommended)

### ExpertMACD_Enhanced
```
Inp_Money_FixedRisk_Percent: 1.0
Inp_Signal_MACD_StopLoss: 20
Inp_Signal_MACD_TakeProfit: 50
Inp_Signal_MACD_MagicNumber: 123456
```

### PythonBridgeEA
```
BridgePort: 5555
BrokerName: EXNESS
AutoExecute: true
DefaultLotSize: 0.01
```

---

## ✅ Safety Checklist

### Use Enhanced EAs Only!
- ✅ `ExpertMACD_Enhanced.mq5` (has risk management)
- ✅ `ExpertMAMA_Enhanced.mq5` (has risk management)
- ✅ `ExpertMAPSAR_Enhanced.mq5` (has risk management)
- ❌ `ExpertMACD.mq5` (NO risk management - DANGEROUS!)
- ❌ `ExpertMAMA.mq5` (NO risk management - DANGEROUS!)
- ❌ `ExpertMAPSAR.mq5` (NO risk management - DANGEROUS!)

### Risk Management
- Risk per trade: **1% maximum**
- Stop Loss: **Always set** (20-30 pips)
- Take Profit: **Always set** (50-75 pips)
- Risk/Reward: **1:2.5 to 1:3**

---

## 🔧 Troubleshooting

### Terminal Won't Start
```powershell
# Check if running
Get-Process -Name "terminal64" -ErrorAction SilentlyContinue

# Launch manually
"C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe"
```

### EA Not Appearing
- Compile EA first (F7 in MetaEditor)
- Verify `.ex5` file exists
- Restart MT5 Terminal

### EA Not Trading
- ✅ AutoTrading enabled (green button)
- ✅ EA attached to chart
- ✅ Check Journal tab for errors
- ✅ Account has sufficient margin
- ✅ EA parameters configured correctly

### VPS Issues
```powershell
# Verify services
.\vps-verification.ps1

# Check logs
Get-Content vps-logs\exness-service.log -Tail 50

# Restart services
.\stop-vps.ps1 -Restart
```

---

## 📚 Documentation

- **Complete Guide**: `EXNESS-COMPLETE-SETUP-GUIDE.md`
- **VPS Guide**: `VPS-SYSTEM-READY.md`
- **Trading Ready**: `READY-TO-TRADE.md`

---

**Quick Reference** | **Last Updated**: 2025-12-09

