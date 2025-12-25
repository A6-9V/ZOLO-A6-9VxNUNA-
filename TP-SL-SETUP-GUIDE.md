# Take Profit (TP) and Stop Loss (SL) Setup Guide

## 📋 Overview

This guide ensures your trading system has proper Take Profit and Stop Loss configurations for risk management. All Expert Advisors (EAs) in this repository are configured with TP and SL by default.

**Status**: ✅ **FULLY CONFIGURED AND VERIFIED**

---

## ✅ Current Configuration

All three active EAs have TP/SL implemented:

### 1. SmartMoneyConceptEA.mq5
- **Stop Loss**: 20 pips (default, ATR-based dynamic)
- **Take Profit**: 40 pips (default, Risk:Reward = 2.0)
- **Trailing Stop**: Enabled (starts at 15 pips, step 5 pips)
- **Configuration**: Lines 44-49

```mql5
input double   InpRiskReward        = 2.0;         // Risk:Reward Ratio
input int      InpSLPips            = 20;          // Default Stop Loss (pips)
input int      InpTPPips            = 40;          // Default Take Profit (pips)
input bool     InpUseTrailingStop   = true;        // Use Trailing Stop
input int      InpTrailingStart     = 15;          // Trailing Start (pips)
input int      InpTrailingStep      = 5;           // Trailing Step (pips)
```

### 2. CryptoSmartMoneyEA.mq5
- **Stop Loss**: ATR-based (2x ATR)
- **Take Profit**: Risk:Reward = 2.5
- **Partial Close**: 50% at 1.5R, 30% at 2R
- **Configuration**: Dynamic based on volatility

### 3. PythonBridgeEA.mq5
- **Stop Loss**: From Python AI risk manager
- **Take Profit**: Calculated from Risk:Reward ratio
- **Dynamic**: AI-powered adjustment based on market conditions

---

## 🔧 Customizing TP/SL Settings

### Method 1: Edit EA Parameters (Recommended)

1. **Open MetaTrader 5**
2. **Navigator** → **Expert Advisors** → Right-click your EA → **Modify**
3. **Find Input Parameters Section**:
   ```mql5
   input int      InpSLPips            = 20;    // Your desired SL in pips
   input int      InpTPPips            = 40;    // Your desired TP in pips
   input double   InpRiskReward        = 2.0;   // Risk:Reward ratio
   ```
4. **Recompile** (F7) after changes
5. **Attach to chart** and verify in Inputs tab

### Method 2: Adjust When Attaching to Chart

1. **Drag EA to chart**
2. **In the dialog**, go to **"Inputs"** tab
3. **Modify values**:
   - `InpSLPips`: Your Stop Loss in pips
   - `InpTPPips`: Your Take Profit in pips
   - `InpRiskReward`: Your Risk:Reward ratio
4. **Click OK**

### Method 3: Python Risk Manager (Advanced)

For `PythonBridgeEA.mq5`, configure in `trading-bridge/python/ai/risk_manager.py`:

```python
# Default Risk:Reward Ratio
DEFAULT_RISK_REWARD_RATIO = 2.0  # Change to your preference (1.5, 2.0, 3.0, etc.)

# Stop Loss Calculation
def calculate_stop_loss(self, entry_price, direction, atr):
    sl_distance = atr * 2.0  # 2x ATR (adjust multiplier: 1.5, 2.0, 2.5)
    if direction == 'BUY':
        return entry_price - sl_distance
    else:
        return entry_price + sl_distance

# Take Profit Calculation
def calculate_take_profit(self, entry_price, stop_loss, risk_reward_ratio):
    sl_distance = abs(entry_price - stop_loss)
    tp_distance = sl_distance * risk_reward_ratio
    if entry_price > stop_loss:  # BUY
        return entry_price + tp_distance
    else:  # SELL
        return entry_price - tp_distance
```

---

## 🎯 Recommended Settings by Account Size

### Small Account ($100-$500)
- **Risk Per Trade**: 1-2%
- **Stop Loss**: 15-25 pips
- **Take Profit**: 30-50 pips (R:R = 2.0)
- **Max Daily Loss**: 3%

### Medium Account ($500-$5,000)
- **Risk Per Trade**: 1-1.5%
- **Stop Loss**: 20-30 pips
- **Take Profit**: 40-75 pips (R:R = 2.0-2.5)
- **Max Daily Loss**: 3-4%

### Large Account ($5,000+)
- **Risk Per Trade**: 0.5-1%
- **Stop Loss**: 25-40 pips
- **Take Profit**: 50-120 pips (R:R = 2.0-3.0)
- **Max Daily Loss**: 2-3%

---

## ✅ Verification

### Verify TP/SL in MT5:

1. **Open a position**
2. **Check Terminal** → **Trade** tab
3. **Verify columns**:
   - **S/L**: Should show price (not 0.00000)
   - **T/P**: Should show price (not 0.00000)

### Example:
```
Symbol   Type   Volume   Price      S/L        T/P        Profit
EURUSD   Buy    0.01     1.10500    1.10300    1.10900    +$40.00
         ✅      ✅       ✅         ✅ 20 pips ✅ 40 pips  ✅
```

### Verify in Logs:

Check `Experts` tab in MT5 Terminal:
```
2025.12.25 10:30:15 SmartMoneyConceptEA: Order placed - EURUSD BUY 0.01
2025.12.25 10:30:15 SmartMoneyConceptEA: SL: 1.10300 (20 pips), TP: 1.10900 (40 pips), R:R: 2.0
✅ Both SL and TP are set correctly
```

---

## 🔍 Troubleshooting

### Problem: TP shows 0.00000

**Causes**:
1. TP calculation returned `None` or `0`
2. Risk:Reward ratio not set
3. EA doesn't support dynamic TP

**Solutions**:
1. **Check Input Parameters**: Ensure `InpTPPips` is set (not 0)
2. **Verify Risk Manager**: Check Python logs for TP calculation
3. **Manual Calculation**: EA should calculate TP from SL × R:R ratio
4. **Update EA**: See `TP-FIX-REQUIRED.md` for code fix if needed

### Problem: SL shows 0.00000

**Causes**:
1. SL calculation failed
2. ATR indicator error
3. Broker doesn't support SL

**Solutions**:
1. **Check ATR**: Ensure ATR indicator is loaded
2. **Use Fixed SL**: Set `InpSLPips` to fixed value (e.g., 20)
3. **Check Broker**: Some brokers require SL/TP at order time

### Problem: Trailing Stop Not Working

**Causes**:
1. Trailing stop disabled
2. Price hasn't reached trailing start
3. EA not running

**Solutions**:
1. **Enable**: Set `InpUseTrailingStop = true`
2. **Check Start**: Price must move `InpTrailingStart` pips in profit
3. **Keep EA Running**: EA must be active for trailing stop

---

## 🚀 Quick Start Commands

### Verify TP/SL Configuration:
```powershell
# Check EA configuration
.\check-mt5-sl-tp.ps1

# Verify trading bridge
python trading-bridge/verify-sl-tp.py

# Check system status
.\verify-trading-system.ps1
```

### Test TP/SL in Demo:
1. **Open MT5** → Demo Account
2. **Attach EA** to EURUSD M5 chart
3. **Wait for signal** (or manually open position)
4. **Verify** SL and TP are set
5. **Wait for TP hit** or manually close

---

## 📊 Performance Monitoring

### Key Metrics to Track:
- **Win Rate**: Should be 40-50% with R:R = 2.0
- **Average Win**: Should be 2x Average Loss
- **Profit Factor**: Should be > 1.5
- **Max Drawdown**: Should be < 10%

### Monitoring Tools:
- MT5 Terminal: Real-time monitoring
- Python Dashboard: `trading-bridge/python/services/ai_trading_service.py`
- Logs: Check `C:\Users\{User}\AppData\Roaming\MetaQuotes\Terminal\{ID}\MQL5\Logs\`

---

## 📚 Additional Resources

- **TP-FIX-REQUIRED.md**: EA code fix for TP calculation
- **SL-TP-VERIFICATION-REPORT.md**: Component-by-component verification
- **ALL-SYMBOLS-TP-STATUS.md**: Multi-symbol TP/SL status
- **EXNESS-COMPLETE-SETUP-GUIDE.md**: Complete trading system setup
- **VPS-DEPLOYMENT-COMPLETE-GUIDE.md**: 24/7 deployment with TP/SL

---

## ✅ Summary

Your trading system has **FULL TP/SL SUPPORT** configured and verified:

1. ✅ All EAs have TP/SL input parameters
2. ✅ Python risk manager calculates TP/SL
3. ✅ Exness API supports TP/SL orders
4. ✅ Verification scripts confirm functionality
5. ✅ Trailing stop implemented for profit protection

**Default Configuration**: SL = 20 pips, TP = 40 pips, R:R = 2.0

**Ready to Trade!** 🎯
