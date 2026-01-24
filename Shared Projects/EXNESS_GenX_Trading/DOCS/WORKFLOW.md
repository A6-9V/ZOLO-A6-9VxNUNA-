## EXNESS GenX Trading v2.0 – Complete Setup Guide

This document explains how to deploy and run the GenX Trader EA on your EXNESS MetaTrader 5 terminal.

---

## 📁 Project Files

```
EXNESS_GenX_Trading/
├── EXPERTS/
│   └── EXNESS_GenX_Trader.mq5    ← Main Expert Advisor
├── INCLUDE/
│   └── EXNESS_GenX_Config.mqh    ← All settings & parameters
├── DOCS/
│   └── WORKFLOW.md               ← This file
└── README.md
```

---

## 🎯 Strategy Overview

**GenX Trader v2.0** uses a combination of:

| Indicator | Purpose |
|-----------|---------|
| **EMA Crossover** (10/30) | Trend direction & entry signals |
| **RSI** (14) | Filter overbought/oversold conditions |
| **ATR** (14) | Dynamic SL/TP based on volatility |

### Entry Rules

| Signal | Conditions |
|--------|------------|
| **BUY** | Fast EMA crosses ABOVE Slow EMA + RSI not overbought + RSI rising |
| **SELL** | Fast EMA crosses BELOW Slow EMA + RSI not oversold + RSI falling |

### Exit Rules

- **Stop Loss**: 1.5× ATR (or fixed pips)
- **Take Profit**: 2.5× ATR (or fixed pips)
- **Trailing Stop**: Activates after 30 pips profit, trails by 10 pips
- **Break-Even**: Moves SL to entry +5 pips after 20 pips profit

---

## 🚀 Installation Steps

### Step 1: Copy Files to MetaTrader

Copy the entire `EXNESS_GenX_Trading` folder to:

```
C:\Users\[YOUR_USER]\AppData\Roaming\MetaQuotes\Terminal\[TERMINAL_ID]\MQL5\Shared Projects\
```

Or use the existing location and set up a symbolic link.

### Step 2: Open MetaEditor

1. Open your **EXNESS MetaTrader 5** terminal
2. Press **F4** or go to **Tools → MetaQuotes Language Editor**

### Step 3: Compile the EA

1. In MetaEditor Navigator, open:
   - `Shared Projects` → `EXNESS_GenX_Trading` → `EXPERTS` → `EXNESS_GenX_Trader.mq5`
2. Press **F7** to compile
3. Check the **Errors** tab – should show **0 errors**

### Step 4: Attach to Chart

1. Back in MetaTrader 5
2. Open a chart (recommended: **EURUSD M15** or **H1**)
3. Press **Ctrl+N** to open Navigator
4. Find `Expert Advisors` → `EXNESS_GenX_Trader`
5. **Drag** it onto the chart

### Step 5: Configure EA Settings

In the EA dialog:

**Common Tab:**
- ✅ Allow live trading
- ✅ Allow DLL imports (if needed)

**Inputs Tab:**
- Review and adjust parameters as needed (see below)

### Step 6: Enable AutoTrading

- Click the **AutoTrading** button in the toolbar (must be **green**)
- A **smiley face 😊** should appear in the top-right of the chart

---

## ⚙️ Configuration Parameters

### Risk Management

| Parameter | Default | Description |
|-----------|---------|-------------|
| `CFG_Risk_Percent` | 1.0 | Risk % of balance per trade |
| `CFG_Fixed_Lot` | 0.01 | Fallback lot size |
| `CFG_Max_Lot` | 5.0 | Maximum lot size |
| `CFG_Max_Positions` | 3 | Max simultaneous trades |
| `CFG_Max_Daily_Trades` | 10 | Max trades per day |

### Stop Loss & Take Profit

| Parameter | Default | Description |
|-----------|---------|-------------|
| `CFG_Use_ATR_SL` | true | Use ATR for dynamic SL/TP |
| `CFG_ATR_SL_Multi` | 1.5 | ATR multiplier for SL |
| `CFG_ATR_TP_Multi` | 2.5 | ATR multiplier for TP |
| `CFG_Fixed_SL_Pips` | 50 | Fixed SL (if ATR disabled) |
| `CFG_Fixed_TP_Pips` | 100 | Fixed TP (if ATR disabled) |

### Trailing Stop & Break-Even

| Parameter | Default | Description |
|-----------|---------|-------------|
| `CFG_Use_Trailing` | true | Enable trailing stop |
| `CFG_Trail_Start_Pips` | 30 | Start trailing after X pips |
| `CFG_Trail_Step_Pips` | 10 | Trailing distance in pips |
| `CFG_Use_BreakEven` | true | Enable break-even |
| `CFG_BE_Trigger_Pips` | 20 | Move to BE after X pips |
| `CFG_BE_Plus_Pips` | 5 | Lock in X pips at BE |

### Strategy Indicators

| Parameter | Default | Description |
|-----------|---------|-------------|
| `CFG_MA_Fast_Period` | 10 | Fast Moving Average period |
| `CFG_MA_Slow_Period` | 30 | Slow Moving Average period |
| `CFG_MA_Method` | EMA | MA type (SMA/EMA/SMMA/LWMA) |
| `CFG_RSI_Period` | 14 | RSI indicator period |
| `CFG_RSI_Overbought` | 70 | RSI overbought level |
| `CFG_RSI_Oversold` | 30 | RSI oversold level |

### Time Filter

| Parameter | Default | Description |
|-----------|---------|-------------|
| `CFG_Use_Time_Filter` | false | Enable time-based trading |
| `CFG_Trade_Start_Hour` | 8 | Start trading hour |
| `CFG_Trade_End_Hour` | 20 | Stop trading hour |
| `CFG_Avoid_Friday_PM` | true | No trades Friday afternoon |

---

## 🧪 Backtesting

Before going live, **always backtest**:

1. Open **Strategy Tester** (Ctrl+R)
2. Select `EXNESS_GenX_Trader`
3. Configure:
   - Symbol: `EURUSD`
   - Period: `M15` or `H1`
   - Model: `Every tick based on real ticks` (best accuracy)
   - Date range: At least 1 year
   - Initial deposit: Your actual planned deposit
4. Click **Start**
5. Review results in the **Results**, **Graph**, and **Report** tabs

### Key Metrics to Check

| Metric | Good Value |
|--------|------------|
| Profit Factor | > 1.5 |
| Drawdown | < 20% |
| Win Rate | > 50% (for this R:R) |
| Sharpe Ratio | > 1.0 |

---

## 📊 Monitoring

### Check the Experts Tab

- Press **Ctrl+E** to see the Experts log
- Look for initialization message and trade logs

### Check the Journal Tab

- Shows all trade executions
- Verify SL/TP are being set correctly

### Expected Log Output

```
═══════════════════════════════════════════════════
  EXNESS GenX Trader v2.0 Initialized
  Symbol: EURUSD
  Strategy: MA(10/30) + RSI(14)
  Risk: 1% per trade
  Trading: ENABLED
═══════════════════════════════════════════════════

══════════════════════════════════════
  ✓ BUY ORDER OPENED
  Symbol: EURUSD
  Lot: 0.05
  Price: 1.08542
  SL: 1.08342 (20.0 pips)
  TP: 1.08892 (35.0 pips)
══════════════════════════════════════
```

---

## ⚠️ Risk Warning

- **Only trade with money you can afford to lose**
- **Start with demo account** until you're confident
- **Use small lot sizes** when going live initially
- **Monitor regularly** – no EA is 100% reliable
- **Past performance does not guarantee future results**

---

## 🔧 Troubleshooting

| Problem | Solution |
|---------|----------|
| EA not trading | Check AutoTrading is ON (green button) |
| No smiley face | Re-attach EA, enable "Allow live trading" |
| "Trade disabled" error | Check broker allows algo trading |
| Wrong lot size | Verify symbol min/max lot in Market Watch |
| SL/TP rejected | Check broker's minimum stop distance |

---

## 📝 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.00 | Initial | Basic placeholder EA |
| 2.00 | Current | Full strategy with MA+RSI, risk management, trailing stop |

---

**Happy Trading! 🚀**

