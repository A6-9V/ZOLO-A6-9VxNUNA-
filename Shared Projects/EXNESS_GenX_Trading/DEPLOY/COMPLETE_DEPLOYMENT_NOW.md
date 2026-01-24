# 🚀 Complete Deployment to VPS 6773048 - Step by Step

## ✅ Current Status
- [x] EA file deployed: `EXNESS_GenX_Trader.mq5` → `MQL5\Experts\`
- [x] Config file deployed: `EXNESS_GenX_Config.mqh` → `MQL5\Include\`
- [ ] EA compiled
- [ ] EA attached to chart
- [ ] AutoTrading enabled
- [ ] Migrated to VPS 6773048

---

## 📋 STEP-BY-STEP DEPLOYMENT GUIDE

### STEP 1: Open MetaTrader 5 EXNESS Terminal
1. Launch **MetaTrader 5 EXNESS** terminal
2. Ensure you're logged into your account
3. Wait for connection to establish (green connection indicator)

### STEP 2: Compile the EA
1. Press **F4** to open MetaEditor
2. In MetaEditor, navigate to:
   - **File → Open Data Folder** (to verify location)
   - Navigate to: **MQL5 → Experts**
3. Open: **EXNESS_GenX_Trader.mq5**
4. Press **F7** to compile
5. Check the **Errors** tab at the bottom:
   - ✅ **SUCCESS**: Should show "0 error(s), 0 warning(s)"
   - ❌ **If errors**: Check that `EXNESS_GenX_Config.mqh` is in `MQL5\Include\` folder
6. Close MetaEditor

### STEP 3: Configure MT5 Settings
1. In MT5 terminal, go to: **Tools → Options**
2. Click **Expert Advisors** tab
3. Enable these options:
   - ✅ **Allow automated trading**
   - ✅ **Allow DLL imports** (if needed)
   - ✅ **Allow live trading**
4. Click **OK**

### STEP 4: Attach EA to Chart
1. Open a chart (recommended: **EURUSD H1**)
   - Right-click on chart → **Symbol** → Select **EURUSD**
   - Right-click on chart → **Period** → Select **H1**
2. Press **Ctrl+N** to open Navigator panel
3. Expand **Expert Advisors** folder
4. Find **EXNESS_GenX_Trader**
5. **Drag and drop** the EA onto the chart
6. EA Settings window will open - configure:
   - **General Tab:**
     - ✅ Enable Trading: **true**
     - ✅ Enable Logging: **true**
     - Magic Number: **81001**
     - Trade Comment: **GenX_v2**
   - **Risk Management:**
     - Risk % per trade: **1.0** (or your preferred %)
     - Max Positions: **3**
     - Max Daily Trades: **10**
   - **Strategy Settings:**
     - Use MA Strategy: **true**
     - Use RSI Filter: **true**
     - Use ATR SL: **true**
   - **Trailing Stop:**
     - Use Trailing: **true**
     - Use Break-Even: **true**
7. Click **OK**

### STEP 5: Enable AutoTrading
1. Look at the MT5 toolbar (top of terminal)
2. Click the **AutoTrading** button
   - Should turn **GREEN** when enabled
   - Button shows "AutoTrading" text
3. Verify EA is running:
   - Check chart - should show **smiley face** icon in top-right corner
   - If showing **frown face**, check the **Experts** tab for errors

### STEP 6: Verify EA is Running Locally
1. Click **View → Toolbox** (or press **Ctrl+T**)
2. Go to **Experts** tab
3. Look for **EXNESS_GenX_Trader** logs:
   - Should see initialization message:
     ```
     ═══════════════════════════════════════════════════
       EXNESS GenX Trader v2.0 Initialized
       Symbol: EURUSD
       Strategy: MA(10/30) + RSI(14)
       Risk: 1.0% per trade
       Trading: ENABLED
     ═══════════════════════════════════════════════════
     ```
4. If you see errors, check the **Journal** tab for details

### STEP 7: Migrate to VPS 6773048 (Singapore)
1. In MT5 terminal menu: **Tools → Options → Virtual Hosting**
   - OR: **View → Virtual Hosting**
2. You should see your VPS subscription:
   - **Singapore 09** (ID: **6773048**)
3. Click **Migrate Local Account** or **Synchronize** button
4. Select your VPS: **6773048**
5. Wait for synchronization:
   - Progress bar will show
   - May take 1-2 minutes
   - All charts and EAs will be uploaded
6. Verify migration:
   - Status should show "Synchronized" or "Active"
   - Check VPS status is "Online"

### STEP 8: Verify EA on VPS
1. In MT5 terminal: **View → Virtual Hosting**
2. Click on your VPS (**6773048**)
3. Check **Logs** section:
   - Navigate to: **hosting.6773048.experts**
   - Should see EA initialization logs
4. Verify EA is running:
   - Check that EA shows in the VPS charts
   - Status should be "Running"
5. Monitor trading activity:
   - Check **Experts** tab in Toolbox
   - Look for trading signals and position opens

---

## 🔍 Troubleshooting

### EA Won't Compile
- **Error**: "Cannot open include file 'EXNESS_GenX_Config.mqh'"
  - **Solution**: Verify file is in `MQL5\Include\` folder
  - Check file name spelling (case-sensitive)

### EA Not Appearing in Navigator
- **Solution**: 
  - Restart MT5 terminal
  - Verify EA compiled successfully (check for `.ex5` file in `MQL5\Experts\`)

### AutoTrading Button Won't Turn Green
- **Solution**:
  - Check Tools → Options → Expert Advisors → Allow automated trading
  - Restart MT5 terminal
  - Check account permissions

### EA Not Trading
- **Check**:
  - AutoTrading is enabled (green button)
  - EA inputs: `CFG_Enable_Trading = true`
  - Account has sufficient balance
  - Market is open
  - Check EA logs in Experts tab

### Migration Fails
- **Check**:
  - VPS subscription is active
  - Account is connected
  - Internet connection is stable
  - Try migration again

### EA Not Running on VPS
- **Check**:
  - EA was attached to chart before migration
  - AutoTrading was enabled before migration
  - Check VPS logs: `hosting.6773048.experts`
  - Verify EA compiled successfully

---

## 📊 Post-Deployment Monitoring

### Daily Checks
- [ ] EA is running (smiley face on chart)
- [ ] No errors in Experts tab
- [ ] Trading activity is normal
- [ ] Account balance changes
- [ ] Positions are being managed correctly

### Weekly Checks
- [ ] Review EA performance
- [ ] Check VPS uptime
- [ ] Review trading logs
- [ ] Verify risk management is working

---

## ✅ Deployment Complete Checklist

- [ ] EA compiled successfully
- [ ] EA attached to chart locally
- [ ] AutoTrading enabled locally
- [ ] EA running locally (verified in Experts tab)
- [ ] Migrated to VPS 6773048
- [ ] EA running on VPS (verified in VPS logs)
- [ ] Trading activity confirmed

---

**VPS Details:**
- **Location**: Singapore 09
- **VPS ID**: 6773048
- **EA Version**: 2.00
- **Deployment Date**: In Progress

**Need Help?** Check the troubleshooting section above or review EA logs in the Experts tab.
