# 📊 How to Review EA Logs - EXNESS GenX Trader

## 🔍 Accessing EA Logs

### Method 1: VPS Logs (Recommended)

**Step-by-Step:**
1. Open **MetaTrader 5 EXNESS** terminal
2. Go to: **View → Virtual Hosting**
3. Click on **VPS 6773048** (Singapore 09)
4. Navigate to **Logs** section
5. Open: **hosting.6773048.experts**

**What You'll See:**
- All EA activity from the VPS
- Real-time logs
- Trading activity
- Error messages (if any)

### Method 2: Local Terminal Logs

**Step-by-Step:**
1. Press **Ctrl+T** to open Toolbox
2. Go to **Experts** tab
3. Look for **EXNESS_GenX_Trader** entries
4. Filter by EA name if needed

---

## 📋 What to Look For in Logs

### ✅ Good Signs (EA Working Correctly)

#### 1. Initialization Message
```
═══════════════════════════════════════════════════
  EXNESS GenX Trader v2.0 Initialized
  Symbol: EURUSD
  Strategy: MA(10/30) + RSI(14)
  Risk: 1.0% per trade
  Trading: ENABLED
═══════════════════════════════════════════════════
```
**Meaning:** EA started successfully

#### 2. Market Monitoring
```
Low volatility. ATR: 0.0003 < Min: 0.0005
```
**Meaning:** EA is monitoring market, waiting for better conditions

#### 3. Signal Generation
```
Checking for signals...
```
**Meaning:** EA is actively analyzing market

#### 4. Trading Activity
```
══════════════════════════════════════════
  ✓ BUY ORDER OPENED
  Symbol: EURUSD
  Lot: 0.01
  Price: 1.0850
  SL: 1.0800 (50.0 pips)
  TP: 1.0900 (50.0 pips)
══════════════════════════════════════════
```
**Meaning:** Trade executed successfully

#### 5. Position Management
```
✓ Position #123456 SL moved to 1.0820 (profit: 30.0 pips)
```
**Meaning:** Trailing stop or break-even activated

---

### ⚠️ Warning Signs (Normal but Monitor)

#### Low Volatility Messages
```
Low volatility. ATR: 0.0003 < Min: 0.0005
```
**Status:** Normal - EA waiting for better conditions
**Action:** No action needed, EA will trade when volatility increases

#### Daily Trade Limit
```
Daily trade limit reached (10 trades)
```
**Status:** Normal - Risk management working
**Action:** EA will resume trading next day

#### Max Positions Reached
```
Maximum positions limit reached (3 positions)
```
**Status:** Normal - Risk management working
**Action:** EA will trade when positions close

---

### ❌ Error Signs (Need Attention)

#### 1. Include File Error
```
Cannot open include file 'EXNESS_GenX_Config.mqh'
```
**Problem:** Config file missing
**Solution:** Verify config file is in `MQL5\Include\` folder

#### 2. Trading Disabled
```
Trading: DISABLED
```
**Problem:** EA trading is disabled
**Solution:** Check EA inputs: `CFG_Enable_Trading = true`

#### 3. Not Enough Money
```
Not enough money
```
**Problem:** Insufficient account balance
**Solution:** Add funds to account

#### 4. Invalid Magic Number
```
Invalid magic number
```
**Problem:** Magic number conflict
**Solution:** Change magic number in EA settings

#### 5. Connection Issues
```
Connection lost
```
**Problem:** Network or broker connection issue
**Solution:** Check internet connection, verify broker server

---

## 📊 Log Analysis Guide

### Understanding Log Patterns

#### Normal Operation Pattern:
1. **Initialization** (once at start)
2. **Market monitoring** (continuous)
3. **Signal checks** (every tick/bar)
4. **Trade execution** (when conditions met)
5. **Position management** (continuous)

#### Expected Frequency:
- **Initialization:** Once per EA start
- **Market checks:** Every few seconds/minutes
- **Trades:** Depends on market conditions (could be 0-10 per day)
- **Position updates:** Every few seconds when positions exist

---

## 🔧 How to Adjust EA Settings

### Method 1: Adjust on Chart (Recommended)

**Steps:**
1. Right-click on chart where EA is attached
2. Select **Expert Advisors → Properties**
3. Adjust settings in **Inputs** tab
4. Click **OK**

**Settings You Can Adjust:**

#### Risk Management:
- **Risk % per trade:** 1.0% (default, can change to 0.5-5%)
- **Max Positions:** 3 (default, can change 1-10)
- **Max Daily Trades:** 10 (default, can change 1-50)

#### Strategy Settings:
- **MA Fast Period:** 10 (default, can change 5-50)
- **MA Slow Period:** 30 (default, can change 20-100)
- **RSI Period:** 14 (default, can change 10-30)
- **RSI Overbought:** 70 (default, can change 60-80)
- **RSI Oversold:** 30 (default, can change 20-40)

#### Stop Loss / Take Profit:
- **Use ATR SL:** true (default, recommended)
- **ATR SL Multiplier:** 1.5 (default, can change 1.0-3.0)
- **ATR TP Multiplier:** 2.5 (default, can change 1.5-5.0)

#### Trailing Stop:
- **Use Trailing:** true (default, recommended)
- **Trail Start Pips:** 30 (default, can change 10-50)
- **Trail Step Pips:** 10 (default, can change 5-20)
- **Use Break-Even:** true (default, recommended)
- **BE Trigger Pips:** 20 (default, can change 10-30)

### Method 2: Edit Config File

**Location:**
```
MQL5\Include\EXNESS_GenX_Config.mqh
```

**Steps:**
1. Open file in MetaEditor (F4)
2. Modify input values
3. Save file
4. Re-compile EA (F7)
5. Re-attach EA to chart

**Note:** Changes require re-compilation and re-attachment

---

## 📈 Performance Monitoring

### Key Metrics to Track

#### Daily:
- **Trades executed:** Count of opened positions
- **Win rate:** Percentage of profitable trades
- **Profit/Loss:** Daily P&L
- **Max drawdown:** Largest loss from peak

#### Weekly:
- **Total trades:** Weekly trade count
- **Average profit per trade:** P&L / trades
- **Risk-adjusted returns:** Profit vs risk taken
- **EA uptime:** Percentage of time EA was running

### Log Review Checklist

**Daily Review:**
- [ ] EA initialized successfully
- [ ] No critical errors
- [ ] Trading activity (if any)
- [ ] Position management working
- [ ] Account balance changes

**Weekly Review:**
- [ ] Overall performance
- [ ] Win rate analysis
- [ ] Risk management effectiveness
- [ ] Strategy performance
- [ ] Settings optimization needs

---

## 🎯 Common Questions

### Q: Why isn't EA trading?
**A:** Check logs for:
- Low volatility messages (normal - waiting)
- Daily trade limit reached (normal - will resume)
- Trading disabled (check EA settings)
- Insufficient balance (add funds)

### Q: How often should I check logs?
**A:** 
- **Daily:** Quick check for errors
- **Weekly:** Performance review
- **Monthly:** Strategy optimization

### Q: What if I see errors?
**A:** 
1. Note the error message
2. Check troubleshooting section
3. Verify EA settings
4. Check account status
5. Contact support if persistent

### Q: Can I change settings while EA is running?
**A:** 
- **Yes:** On chart (right-click → Properties)
- **Changes take effect immediately**
- **No re-compilation needed for input changes**

---

## 📝 Log Review Template

**Date:** _______________

**EA Status:**
- [ ] Initialized successfully
- [ ] Running without errors
- [ ] Trading activity normal

**Trading Activity:**
- Trades today: _____
- Positions open: _____
- Daily P&L: _____

**Issues Found:**
- [ ] None
- [ ] Errors (describe): _______________
- [ ] Warnings (describe): _______________

**Action Items:**
- [ ] None
- [ ] Adjust settings: _______________
- [ ] Investigate issue: _______________

**Notes:**
_________________________________
_________________________________

---

## 🔗 Quick Access

**VPS Logs:**
- View → Virtual Hosting → VPS 6773048 → Logs → hosting.6773048.experts

**Local Logs:**
- Ctrl+T → Experts tab

**EA Settings:**
- Right-click chart → Expert Advisors → Properties

**Config File:**
- MetaEditor → MQL5 → Include → EXNESS_GenX_Config.mqh

---

**Last Updated:** 2026.01.21
**EA Version:** 2.00
**Status:** Operational on VPS 6773048
