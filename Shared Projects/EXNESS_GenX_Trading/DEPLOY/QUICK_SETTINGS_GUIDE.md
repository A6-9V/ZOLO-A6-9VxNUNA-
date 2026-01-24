# ⚙️ Quick Settings Guide - EXNESS GenX Trader

## 🎯 Recommended Settings by Experience Level

### Beginner (Conservative)
- **Risk % per trade:** 0.5%
- **Max Positions:** 2
- **Max Daily Trades:** 5
- **Use ATR SL:** true
- **Use Trailing:** true
- **Use Break-Even:** true

### Intermediate (Balanced) - **CURRENT DEFAULT**
- **Risk % per trade:** 1.0%
- **Max Positions:** 3
- **Max Daily Trades:** 10
- **Use ATR SL:** true
- **Use Trailing:** true
- **Use Break-Even:** true

### Advanced (Aggressive)
- **Risk % per trade:** 2.0%
- **Max Positions:** 5
- **Max Daily Trades:** 20
- **Use ATR SL:** true
- **Use Trailing:** true
- **Use Break-Even:** true

---

## 🔧 How to Change Settings

### Quick Method (On Chart)

1. **Right-click** on chart where EA is attached
2. Select **Expert Advisors → Properties**
3. Go to **Inputs** tab
4. Adjust values
5. Click **OK**

**Changes take effect immediately!**

---

## 📊 Settings Explained

### Risk Management

#### Risk % per trade
- **What it does:** Calculates lot size based on account balance
- **Default:** 1.0%
- **Range:** 0.1% - 5.0%
- **Example:** $10,000 account, 1% risk = $100 risk per trade
- **Recommendation:** Start with 0.5-1.0%

#### Max Positions
- **What it does:** Limits number of open positions
- **Default:** 3
- **Range:** 1 - 10
- **Recommendation:** 2-3 for beginners, 3-5 for experienced

#### Max Daily Trades
- **What it does:** Limits trades per day
- **Default:** 10
- **Range:** 1 - 50
- **Recommendation:** 5-10 for beginners, 10-20 for experienced

---

### Strategy Settings

#### MA Fast Period
- **What it does:** Fast moving average period
- **Default:** 10
- **Range:** 5 - 50
- **Lower =** More sensitive, more signals
- **Higher =** Less sensitive, fewer signals

#### MA Slow Period
- **What it does:** Slow moving average period
- **Default:** 30
- **Range:** 20 - 100
- **Lower =** More sensitive
- **Higher =** Less sensitive

#### RSI Period
- **What it does:** RSI calculation period
- **Default:** 14
- **Range:** 10 - 30
- **Lower =** More sensitive
- **Higher =** Less sensitive

#### RSI Overbought/Oversold
- **What it does:** RSI levels for filtering
- **Default:** 70/30
- **Range:** 60-80 / 20-40
- **Tighter =** Fewer trades, higher quality
- **Wider =** More trades, lower quality

---

### Stop Loss / Take Profit

#### Use ATR SL
- **What it does:** Uses ATR for dynamic SL/TP
- **Default:** true
- **Recommendation:** Keep enabled (adapts to volatility)

#### ATR SL Multiplier
- **What it does:** Multiplies ATR for stop loss distance
- **Default:** 1.5
- **Range:** 1.0 - 3.0
- **Lower =** Tighter stops, more stop-outs
- **Higher =** Wider stops, fewer stop-outs

#### ATR TP Multiplier
- **What it does:** Multiplies ATR for take profit distance
- **Default:** 2.5
- **Range:** 1.5 - 5.0
- **Lower =** Smaller targets, more wins
- **Higher =** Larger targets, fewer wins

---

### Trailing Stop

#### Use Trailing
- **What it does:** Moves stop loss as price moves favorably
- **Default:** true
- **Recommendation:** Keep enabled (locks in profits)

#### Trail Start Pips
- **What it does:** Profit level to start trailing
- **Default:** 30 pips
- **Range:** 10 - 50 pips
- **Lower =** Starts trailing sooner
- **Higher =** Starts trailing later

#### Trail Step Pips
- **What it does:** Distance to trail stop loss
- **Default:** 10 pips
- **Range:** 5 - 20 pips
- **Lower =** Tighter trailing, more stop-outs
- **Higher =** Wider trailing, fewer stop-outs

#### Use Break-Even
- **What it does:** Moves SL to break-even when profitable
- **Default:** true
- **Recommendation:** Keep enabled (protects capital)

#### BE Trigger Pips
- **What it does:** Profit level to move to break-even
- **Default:** 20 pips
- **Range:** 10 - 30 pips
- **Lower =** Moves to BE sooner
- **Higher =** Moves to BE later

---

## 🎯 Common Adjustments

### More Trades
- Increase **Max Daily Trades** (10 → 20)
- Decrease **RSI Overbought** (70 → 65)
- Decrease **RSI Oversold** (30 → 35)
- Decrease **Min ATR** (if adjustable)

### Fewer Trades (Higher Quality)
- Decrease **Max Daily Trades** (10 → 5)
- Increase **RSI Overbought** (70 → 75)
- Increase **RSI Oversold** (30 → 25)
- Increase **Min ATR** (if adjustable)

### Tighter Risk Control
- Decrease **Risk %** (1.0% → 0.5%)
- Decrease **Max Positions** (3 → 2)
- Decrease **Max Daily Trades** (10 → 5)

### More Aggressive
- Increase **Risk %** (1.0% → 2.0%)
- Increase **Max Positions** (3 → 5)
- Increase **Max Daily Trades** (10 → 20)

---

## ⚠️ Important Notes

### Settings Changes
- **On Chart:** Changes take effect immediately
- **Config File:** Requires re-compilation and re-attachment
- **VPS:** Changes sync automatically after local change

### Testing Settings
- **Start conservative:** Test with lower risk first
- **Monitor performance:** Track results for 1-2 weeks
- **Adjust gradually:** Make small changes, not big jumps
- **Keep logs:** Document what works

### Best Practices
- **Don't over-optimize:** Too many changes = confusion
- **Test one change at a time:** Know what works
- **Keep risk management:** Never disable risk controls
- **Monitor regularly:** Check performance weekly

---

## 📝 Settings Checklist

**Before Changing:**
- [ ] Understand what setting does
- [ ] Know current value
- [ ] Have backup plan
- [ ] Document change

**After Changing:**
- [ ] Verify change took effect
- [ ] Monitor for 1-2 weeks
- [ ] Review performance
- [ ] Adjust if needed

---

## 🔗 Quick Reference

**Access Settings:**
- Right-click chart → Expert Advisors → Properties → Inputs

**Current Defaults:**
- Risk: 1.0%
- Max Positions: 3
- Max Daily Trades: 10
- MA: 10/30
- RSI: 14 (70/30)
- ATR SL: 1.5x
- ATR TP: 2.5x
- Trailing: 30/10 pips
- Break-Even: 20 pips

---

**Last Updated:** 2026.01.21
**EA Version:** 2.00
