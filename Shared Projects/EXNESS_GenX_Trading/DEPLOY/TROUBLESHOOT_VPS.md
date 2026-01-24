# 🔧 Troubleshooting - EA Not Running on VPS 6773048

## Issue Identified

**VPS Logs Show:**
```
'411534497': 0 charts, 0 EAs, 0 custom indicators, signal disabled
```

**Problem:** EA is not running on VPS despite migration.

---

## 🔍 Root Cause Analysis

The EA needs to be:
1. ✅ Compiled (done)
2. ✅ Attached to chart locally (need to verify)
3. ✅ AutoTrading enabled (confirmed)
4. ✅ Migrated to VPS (in progress)
5. ❌ **EA must be attached to chart BEFORE migration**

---

## ✅ Solution Steps

### Step 1: Verify EA is Attached Locally

**In your LOCAL MT5 terminal:**

1. **Check Chart:**
   - [ ] Open a chart (e.g., EURUSD H1)
   - [ ] Look for EA name in chart title or corner
   - [ ] Verify smiley face icon (😊) is visible
   - [ ] If NO smiley face → EA is not attached

2. **Attach EA if Not Attached:**
   - [ ] Press **Ctrl+N** to open Navigator
   - [ ] Expand **Expert Advisors**
   - [ ] Find **EXNESS_GenX_Trader**
   - [ ] **Drag and drop** onto chart
   - [ ] Configure settings → Click **OK**
   - [ ] Verify smiley face appears

3. **Verify AutoTrading:**
   - [ ] AutoTrading button should be **GREEN**
   - [ ] If gray, click to enable

4. **Check EA Logs:**
   - [ ] Press **Ctrl+T** → **Experts** tab
   - [ ] Look for initialization message:
     ```
     EXNESS GenX Trader v2.0 Initialized
     ```

### Step 2: Re-Migrate to VPS

**After EA is attached locally:**

1. **In MT5 Terminal:**
   - Go to: **Tools → Options → Virtual Hosting**
   - OR: **View → Virtual Hosting**

2. **Re-Migrate:**
   - Click on **VPS 6773048**
   - Click **Migrate Local Account** or **Synchronize**
   - Wait for completion (1-2 minutes)

3. **Verify Migration:**
   - Status should show: **Synchronized**
   - Charts section should show: **1 chart** (or more)
   - EAs section should show: **1 EA** (or more)

### Step 3: Verify EA on VPS

**After re-migration:**

1. **Check VPS Status:**
   - In Virtual Hosting → **VPS 6773048**
   - Verify: **1 chart, 1 EA** (not 0)

2. **Check VPS Logs:**
   - Navigate to: **hosting.6773048.experts**
   - Look for EA initialization

3. **Verify EA Running:**
   - In Virtual Hosting → **Charts**
   - EA should be visible and running

---

## 🎯 Critical Requirements

### EA Must Be Attached BEFORE Migration

**Why?**
- VPS migration copies **active charts with EAs**
- If EA is not attached to chart locally, it won't be on VPS
- Migration only syncs what's currently active

**Checklist Before Migration:**
- [ ] EA is attached to at least ONE chart
- [ ] Smiley face icon visible on chart
- [ ] AutoTrading enabled (green button)
- [ ] EA logs showing initialization
- [ ] No errors in Journal tab

---

## 📋 Complete Deployment Checklist

### Local Setup (MUST DO FIRST):
- [x] EA compiled (F7 in MetaEditor)
- [ ] **EA attached to chart** ← CRITICAL
- [ ] **Smiley face visible** ← CRITICAL
- [x] AutoTrading enabled
- [ ] EA logs showing initialization
- [ ] No errors

### VPS Migration:
- [ ] EA attached locally (verified)
- [ ] Re-migrate to VPS 6773048
- [ ] Verify: 1+ charts, 1+ EAs on VPS
- [ ] Check VPS logs for EA activity
- [ ] Verify EA running on VPS

---

## 🔄 Quick Fix Procedure

**If EA shows 0 on VPS:**

1. **Attach EA Locally:**
   ```
   - Open chart (EURUSD H1)
   - Ctrl+N → Expert Advisors
   - Drag EXNESS_GenX_Trader to chart
   - Configure → OK
   - Verify smiley face
   ```

2. **Enable AutoTrading:**
   ```
   - Click AutoTrading button (should turn green)
   ```

3. **Re-Migrate:**
   ```
   - View → Virtual Hosting
   - Click VPS 6773048
   - Click Migrate/Synchronize
   - Wait 1-2 minutes
   ```

4. **Verify:**
   ```
   - Check VPS status: Should show 1+ EAs
   - Check VPS logs: Should show EA initialization
   ```

---

## 🚨 Common Mistakes

### Mistake 1: EA Not Attached Before Migration
- **Symptom:** VPS shows 0 EAs
- **Solution:** Attach EA to chart, then re-migrate

### Mistake 2: AutoTrading Disabled
- **Symptom:** EA attached but not running
- **Solution:** Enable AutoTrading (green button)

### Mistake 3: EA Not Compiled
- **Symptom:** EA won't attach or shows errors
- **Solution:** Compile in MetaEditor (F7)

### Mistake 4: Wrong Chart/Symbol
- **Symptom:** EA attached but not trading
- **Solution:** Use recommended chart (EURUSD H1)

---

## ✅ Expected Result After Fix

**VPS Logs Should Show:**
```
'411534497': 1 chart, 1 EA, 0 custom indicators, signal enabled
```

**VPS Status Should Show:**
- Charts: 1 (or more)
- EAs: 1 (or more)
- Status: Online/Synchronized

**VPS Logs Should Show:**
```
EXNESS GenX Trader v2.0 Initialized
Symbol: EURUSD
Trading: ENABLED
```

---

## 📞 Next Steps

1. **Verify EA is attached locally** (most important!)
2. **Re-migrate to VPS** after EA is attached
3. **Check VPS status** - should show 1+ EAs
4. **Monitor VPS logs** for EA activity

---

**Last Updated**: 2026.01.21
**Issue**: EA not running on VPS (0 EAs shown)
**Solution**: Attach EA locally, then re-migrate
