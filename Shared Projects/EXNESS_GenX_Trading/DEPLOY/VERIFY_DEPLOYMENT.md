# ✅ Verification Guide - VPS 6773048 Deployment

## Quick Verification Checklist

### ✅ Step 1: Verify Files Are Deployed
- [x] EA source file: `EXNESS_GenX_Trader.mq5` in `MQL5\Experts\`
- [x] Config file: `EXNESS_GenX_Config.mqh` in `MQL5\Include\`
- [x] Compiled EA: `EXNESS_GenX_Trader.ex5` in `MQL5\Experts\`

### ✅ Step 2: Verify EA is Running Locally

#### Check Chart
1. Open MT5 terminal
2. Look at the chart where EA is attached
3. **Verify**: Smiley face icon (😊) in top-right corner of chart
   - ✅ **Smiley face** = EA is running
   - ❌ **Frown face** = EA has errors (check Experts tab)

#### Check AutoTrading
1. Look at MT5 toolbar (top of terminal)
2. **Verify**: AutoTrading button is **GREEN**
   - ✅ **Green** = AutoTrading enabled
   - ❌ **Gray** = AutoTrading disabled (click to enable)

#### Check EA Logs
1. Press **Ctrl+T** to open Toolbox
2. Go to **Experts** tab
3. **Look for**: EXNESS_GenX_Trader logs
4. **Expected messages**:
   ```
   ═══════════════════════════════════════════════════
     EXNESS GenX Trader v2.0 Initialized
     Symbol: EURUSD
     Strategy: MA(10/30) + RSI(14)
     Risk: 1.0% per trade
     Trading: ENABLED
   ═══════════════════════════════════════════════════
   ```

#### Check for Errors
1. In Toolbox, go to **Journal** tab
2. **Verify**: No critical errors related to EXNESS_GenX_Trader
3. **Common errors to check**:
   - ❌ "Cannot open include file" → Config file missing
   - ❌ "Invalid magic number" → Check EA settings
   - ❌ "Not enough money" → Check account balance

---

### ✅ Step 3: Verify VPS Migration

#### Check Virtual Hosting Status
1. In MT5 terminal: **View → Virtual Hosting**
   - OR: **Tools → Options → Virtual Hosting**
2. **Find**: Singapore 09 (ID: 6773048)
3. **Verify**:
   - ✅ Status: **Online** or **Synchronized**
   - ✅ Last synchronization: Recent time (within last few minutes)
   - ✅ Charts: Shows your chart with EA attached

#### Check VPS Logs
1. In Virtual Hosting window, click on **VPS 6773048**
2. Navigate to **Logs** section
3. Open: **hosting.6773048.experts**
4. **Look for**:
   - EA initialization messages
   - Trading signals
   - Position management logs
   - No critical errors

#### Verify EA on VPS
1. In Virtual Hosting, check **Charts** section
2. **Verify**:
   - Your chart is visible
   - EA is attached to chart
   - EA status shows "Running"
   - Smiley face icon visible

---

### ✅ Step 4: Verify Trading Activity

#### Check EA is Monitoring Market
1. In Toolbox → **Experts** tab
2. **Look for** periodic messages:
   - "Low volatility. ATR: X < Min: Y" (normal - waiting for good conditions)
   - "Checking for signals..." (EA is active)
   - No errors about connection or data

#### Check Account Status
1. In MT5 terminal: **View → Trade** (or press **Ctrl+T** → **Trade** tab)
2. **Verify**:
   - Account is connected
   - Balance is visible
   - Margin available
   - No connection errors

---

## 🔍 Detailed Verification Steps

### A. File System Verification

**Run this command to check files:**
```powershell
.\verify_deployment.ps1
```

**Expected output:**
- ✅ All files present
- ✅ Compiled EA exists
- ✅ File sizes are correct

### B. MT5 Terminal Verification

**1. EA Navigator Check:**
- Press **Ctrl+N** to open Navigator
- Expand **Expert Advisors**
- **Verify**: EXNESS_GenX_Trader appears in list
- **Verify**: No red X or error icons

**2. Chart Check:**
- Open chart where EA is attached
- **Verify**: EA name appears in chart title or corner
- **Verify**: Input parameters are set correctly
- **Verify**: EA is not paused

**3. Toolbox Check:**
- Press **Ctrl+T** to open Toolbox
- **Experts tab**: Should show EA logs
- **Journal tab**: Should show no critical errors
- **Trade tab**: Should show account connection

### C. VPS Status Verification

**1. Virtual Hosting Window:**
- **VPS Status**: Should be "Online"
- **Synchronization**: Should be recent (within 5 minutes)
- **Charts Count**: Should show 1+ charts
- **EAs Count**: Should show 1+ EAs

**2. VPS Logs:**
- **Access**: View → Virtual Hosting → VPS 6773048 → Logs
- **File**: hosting.6773048.experts
- **Content**: Should show EA activity
- **Errors**: Should be minimal or none

**3. VPS Performance:**
- **CPU Usage**: Should be low (<10%)
- **Memory Usage**: Should be reasonable
- **Network**: Should be connected

---

## 🚨 Troubleshooting Verification Issues

### Issue: EA Not Running Locally

**Symptoms:**
- Frown face on chart
- No logs in Experts tab
- AutoTrading button gray

**Solutions:**
1. Check Tools → Options → Expert Advisors → Allow automated trading
2. Restart MT5 terminal
3. Re-attach EA to chart
4. Check Journal tab for errors

### Issue: EA Not on VPS

**Symptoms:**
- VPS shows no charts
- VPS logs empty
- EA not in VPS charts list

**Solutions:**
1. Verify migration completed successfully
2. Re-migrate: Tools → Options → Virtual Hosting → Migrate
3. Check VPS subscription is active
4. Verify account is connected

### Issue: EA Not Trading

**Symptoms:**
- EA running but no trades
- Logs show "Low volatility" messages
- No signals generated

**Solutions:**
1. Check EA inputs: `CFG_Enable_Trading = true`
2. Verify market is open
3. Check account has sufficient balance
4. Review EA logs for specific reasons
5. Check time filters (if enabled)

### Issue: VPS Logs Not Accessible

**Symptoms:**
- Cannot open hosting.6773048.experts
- VPS logs section empty
- Access denied errors

**Solutions:**
1. Verify VPS subscription is active
2. Check account permissions
3. Try refreshing Virtual Hosting window
4. Contact MQL5 support if persistent

---

## ✅ Success Indicators

### Local Success:
- ✅ Smiley face on chart
- ✅ AutoTrading button green
- ✅ EA logs showing initialization
- ✅ No errors in Journal

### VPS Success:
- ✅ VPS status: Online/Synchronized
- ✅ EA visible in VPS charts
- ✅ VPS logs showing EA activity
- ✅ Recent synchronization time

### Trading Success:
- ✅ EA monitoring market (logs show activity)
- ✅ Signals being generated (when conditions met)
- ✅ Positions being managed (trailing stops, break-even)
- ✅ No trading errors

---

## 📊 Monitoring Commands

### Quick Status Check:
```powershell
.\verify_deployment.ps1
```

### Check Compiled EA:
```powershell
Test-Path "C:\Users\USER\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\MQL5\Experts\EXNESS_GenX_Trader.ex5"
```

### View EA Logs:
- In MT5: Ctrl+T → Experts tab
- Filter by: EXNESS_GenX_Trader

### View VPS Logs:
- In MT5: View → Virtual Hosting → VPS 6773048 → Logs → hosting.6773048.experts

---

## 📝 Verification Report Template

**Date**: _______________
**VPS ID**: 6773048 (Singapore 09)

**Files Status:**
- [ ] EA source file present
- [ ] Config file present
- [ ] Compiled EA present

**Local Status:**
- [ ] EA attached to chart
- [ ] Smiley face visible
- [ ] AutoTrading enabled
- [ ] EA logs visible
- [ ] No errors in Journal

**VPS Status:**
- [ ] VPS online
- [ ] Migration successful
- [ ] EA visible on VPS
- [ ] VPS logs accessible
- [ ] EA running on VPS

**Trading Status:**
- [ ] EA monitoring market
- [ ] Signals being generated
- [ ] Positions being managed
- [ ] No trading errors

**Notes:**
_________________________________
_________________________________

---

**Last Verified**: _______________
**Status**: ✅ Ready / ⚠️ Issues Found / ❌ Not Ready
