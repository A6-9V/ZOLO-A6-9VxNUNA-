# ✅ Verification Checklist - VPS 6773048

## Quick Verification Steps

### 1. ✅ Check EA is Running Locally

**In MetaTrader 5 Terminal:**

1. **Check Chart:**
   - [ ] Open the chart where EA is attached
   - [ ] Look for **smiley face icon** (😊) in top-right corner
   - ✅ **Smiley face** = EA running correctly
   - ❌ **Frown face** = EA has errors (check Experts tab)

2. **Check AutoTrading:**
   - [ ] Look at MT5 toolbar (top of terminal)
   - [ ] **AutoTrading button should be GREEN**
   - ✅ **Green** = Enabled
   - ❌ **Gray** = Disabled (click to enable)

3. **Check EA Logs:**
   - [ ] Press **Ctrl+T** to open Toolbox
   - [ ] Go to **Experts** tab
   - [ ] Look for **EXNESS_GenX_Trader** logs
   - [ ] **Expected message:**
     ```
     ═══════════════════════════════════════════════════
       EXNESS GenX Trader v2.0 Initialized
       Symbol: EURUSD (or your symbol)
       Strategy: MA(10/30) + RSI(14)
       Risk: 1.0% per trade
       Trading: ENABLED
     ═══════════════════════════════════════════════════
     ```

4. **Check for Errors:**
   - [ ] In Toolbox, go to **Journal** tab
   - [ ] Verify no critical errors related to EXNESS_GenX_Trader
   - [ ] Common errors to watch for:
     - "Cannot open include file" → Config missing
     - "Invalid magic number" → Check EA settings
     - "Not enough money" → Check account balance

---

### 2. ✅ Verify VPS Migration

**Check Virtual Hosting Status:**

1. **Open Virtual Hosting:**
   - [ ] In MT5: **View → Virtual Hosting**
   - OR: **Tools → Options → Virtual Hosting**

2. **Find VPS 6773048:**
   - [ ] Look for: **Singapore 09 (ID: 6773048)**
   - [ ] **Verify Status:**
     - ✅ **Online** or **Synchronized**
     - ✅ **Last synchronization**: Recent (within last few minutes)
     - ✅ **Charts**: Shows your chart with EA

3. **Check VPS Logs:**
   - [ ] Click on **VPS 6773048**
   - [ ] Navigate to **Logs** section
   - [ ] Open: **hosting.6773048.experts**
   - [ ] **Look for:**
     - EA initialization messages
     - "EXNESS GenX Trader v2.0 Initialized"
     - Trading activity logs
     - No critical errors

4. **Verify EA on VPS:**
   - [ ] In Virtual Hosting, check **Charts** section
   - [ ] **Verify:**
     - Your chart is visible
     - EA is attached to chart
     - EA status shows "Running"
     - Smiley face icon visible

---

### 3. ✅ Verify Trading Activity

**Check EA is Monitoring Market:**

1. **EA Logs Activity:**
   - [ ] In Toolbox → **Experts** tab
   - [ ] **Look for periodic messages:**
     - "Low volatility. ATR: X < Min: Y" (normal - waiting for conditions)
     - "Checking for signals..." (EA is active)
     - No connection or data errors

2. **Account Status:**
   - [ ] In MT5: **View → Trade** (or **Ctrl+T** → **Trade** tab)
   - [ ] **Verify:**
     - Account is connected
     - Balance is visible
     - Margin available
     - No connection errors

---

## 🎯 Success Indicators

### ✅ Local Success:
- Smiley face on chart
- AutoTrading button green
- EA logs showing initialization
- No errors in Journal

### ✅ VPS Success:
- VPS status: Online/Synchronized
- EA visible in VPS charts
- VPS logs showing EA activity
- Recent synchronization time

### ✅ Trading Success:
- EA monitoring market (logs show activity)
- Signals being generated (when conditions met)
- Positions being managed
- No trading errors

---

## 🚨 Common Issues & Solutions

### Issue: EA Not Running (Frown Face)
**Solution:**
1. Check Tools → Options → Expert Advisors → Allow automated trading
2. Restart MT5 terminal
3. Re-attach EA to chart
4. Check Journal tab for specific errors

### Issue: EA Not on VPS
**Solution:**
1. Verify migration completed (check Virtual Hosting status)
2. Re-migrate: Tools → Options → Virtual Hosting → Migrate
3. Check VPS subscription is active
4. Verify account is connected

### Issue: No Trading Activity
**Solution:**
1. Check EA inputs: `CFG_Enable_Trading = true`
2. Verify market is open
3. Check account has sufficient balance
4. Review EA logs for specific reasons
5. Check time filters (if enabled)

---

## 📝 Verification Report

**Date**: _______________
**VPS ID**: 6773048 (Singapore 09)

**Status:**
- [ ] ✅ All checks passed
- [ ] ⚠️ Minor issues found
- [ ] ❌ Critical issues found

**Notes:**
_________________________________
_________________________________

---

**Next Steps:**
1. Complete the checklist above
2. Report any issues found
3. Monitor EA performance
4. Check VPS logs regularly
