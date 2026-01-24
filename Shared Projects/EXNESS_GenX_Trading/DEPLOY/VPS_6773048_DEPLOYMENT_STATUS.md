# Deployment Status - VPS 6773048 (Singapore)

## ✅ Completed Steps

1. **EA Files Prepared**
   - ✅ EXNESS_GenX_Trader.mq5 - VPS-ready version created
   - ✅ EXNESS_GenX_Config.mqh - Configuration file ready
   - ✅ Files copied to local MT5 directories:
     - `MQL5\Experts\EXNESS_GenX_Trader.mq5`
     - `MQL5\Include\EXNESS_GenX_Config.mqh`

## 🔄 Next Steps - Complete Deployment

### Step 1: Compile the EA
- [ ] Open MetaEditor (F4 in MT5 terminal)
- [ ] Navigate to: **Experts → EXNESS_GenX_Trader.mq5**
- [ ] Press **F7** to compile
- [ ] Verify compilation successful (no errors in Errors tab)

### Step 2: Configure MT5 Settings
- [ ] Open MT5 terminal
- [ ] Go to: **Tools → Options → Expert Advisors**
- [ ] Enable: **Allow automated trading**
- [ ] Enable: **Allow DLL imports** (if needed)
- [ ] Click **OK**

### Step 3: Attach EA to Chart
- [ ] Open a chart (recommended: **EURUSD H1**)
- [ ] Press **Ctrl+N** to open Navigator
- [ ] Expand **Expert Advisors**
- [ ] Drag **EXNESS_GenX_Trader** onto chart
- [ ] Configure EA settings:
  - Risk % per trade: 1.0% (default)
  - Enable Trading: **true**
  - Enable Logging: **true**
  - Magic Number: 81001
- [ ] Click **OK**

### Step 4: Enable AutoTrading
- [ ] Click **AutoTrading** button in MT5 toolbar (should turn green)
- [ ] Verify EA is running (smiley face icon on chart)
- [ ] Check **Experts** tab for EA initialization logs

### Step 5: Migrate to VPS 6773048
- [ ] In MT5 terminal menu: **Tools → Options → Virtual Hosting**
- [ ] Or: **View → Virtual Hosting**
- [ ] Click **Migrate Local Account** or **Synchronize**
- [ ] Select VPS: **Singapore 09 (ID: 6773048)**
- [ ] Wait for synchronization to complete
- [ ] Verify migration successful

### Step 6: Verify on VPS
- [ ] Check logs at: **hosting.6773048.experts**
- [ ] Verify EA is running (smiley face icon on chart)
- [ ] Check **Experts** tab for EA logs
- [ ] Monitor for trading activity

## 📋 EA Configuration Summary

### General Settings
- **Magic Number**: 81001
- **Trade Comment**: GenX_v2
- **Enable Trading**: true
- **Enable Logging**: true

### Risk Management
- **Risk % per trade**: 1.0%
- **Max Positions**: 3
- **Max Daily Trades**: 10
- **Min Lot**: 0.01
- **Max Lot**: 5.0

### Strategy Settings
- **MA Fast Period**: 10
- **MA Slow Period**: 30
- **RSI Period**: 14
- **ATR Period**: 14
- **Use ATR for SL/TP**: true

### Trailing Stop
- **Enable Trailing**: true
- **Trail Start**: 30 pips
- **Trail Step**: 10 pips
- **Break-Even**: true
- **BE Trigger**: 20 pips

## 🔍 Troubleshooting

### EA Not Appearing in Navigator
- Verify file is in `MQL5\Experts\` folder
- Check EA compiled successfully (look for `.ex5` file)
- Restart MT5 terminal

### Compilation Errors
- Check Include path is correct: `#include "EXNESS_GenX_Config.mqh"`
- Verify config file is in `MQL5\Include\` folder
- Check for syntax errors in MetaEditor

### EA Not Trading on VPS
- Verify AutoTrading enabled on VPS
- Check EA inputs: `CFG_Enable_Trading = true`
- Verify account balance and margin
- Check EA logs in Experts tab

### Migration Issues
- Ensure EA is attached and running locally first
- Check VPS subscription is active
- Verify account is connected
- Check network connection

## 📊 Monitoring

### Log Locations
- **Local MT5**: `MQL5\Logs\` folder
- **VPS Logs**: Access via MT5 terminal → View → Virtual Hosting → Logs
- **VPS Log Viewer**: `hosting.6773048.experts`

### Key Metrics to Monitor
- EA initialization status
- Trading signals generated
- Positions opened/closed
- Daily trade count
- Account balance changes
- Error messages

## ✅ Deployment Checklist

- [x] EA files prepared and copied to local MT5
- [ ] EA compiled successfully
- [ ] EA attached to chart locally
- [ ] AutoTrading enabled locally
- [ ] EA running locally (verified)
- [ ] Migrated to VPS 6773048
- [ ] EA running on VPS (verified)
- [ ] Logs accessible on VPS
- [ ] Trading activity confirmed

---

**Last Updated**: Deployment in progress
**VPS ID**: 6773048 (Singapore 09)
**EA Version**: 2.00
