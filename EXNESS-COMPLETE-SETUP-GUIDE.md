# 🚀 EXNESS Complete Setup Guide

Complete setup guide for EXNESS Terminal, App Settings, Expert Advisors, and VPS configuration.

---

## 📋 Table of Contents

1. [EXNESS Terminal Installation & Setup](#1-exness-terminal-installation--setup)
2. [EXNESS App Settings (Color & Symbol)](#2-exness-app-settings-color--symbol)
3. [Expert Advisor (EA) Setup](#3-expert-advisor-ea-setup)
4. [Connecting Your MQL5 Account](#4-connecting-your-mql5-account)
5. [VPS Setup for 24/7 Trading](#5-vps-setup-for-247-trading)

---

## 1. EXNESS Terminal Installation & Setup

### Step 1.1: Download and Install EXNESS Terminal

1. **Download EXNESS Terminal:**
   - Visit: https://www.exness.com/
   - Navigate to: **Trading** → **MetaTrader 5**
   - Download **MetaTrader 5 EXNESS** installer

2. **Install EXNESS Terminal:**
   - Run the installer as Administrator
   - Default installation path: `C:\Program Files\MetaTrader 5 EXNESS\`
   - Complete the installation wizard

3. **Verify Installation:**
   ```powershell
   Test-Path "C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe"
   ```

### Step 1.2: Launch EXNESS Terminal

**Option A: Manual Launch**
```cmd
"C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe"
```

**Option B: Using PowerShell Script**
```powershell
.\launch-exness-trading.ps1
```

**Option C: Using Batch File**
```cmd
.\LAUNCH-EXNESS-TRADING.bat
```

### Step 1.3: Login to EXNESS Account

1. **Open EXNESS Terminal**
2. **Login:**
   - Enter your EXNESS account number
   - Enter your password
   - Select server (if multiple available)
   - Click **Login**

3. **Verify Connection:**
   - Check bottom-right corner for connection status
   - Should show: **"Connected"** (green indicator)
   - Account balance should be visible

### Step 1.4: Terminal Configuration

1. **Enable AutoTrading:**
   - Click **AutoTrading** button in toolbar (should turn green)
   - Or: Tools → Options → Expert Advisors → ✅ **Allow automated trading**

2. **Configure Expert Advisors:**
   - Tools → Options → Expert Advisors
   - ✅ Allow automated trading
   - ✅ Allow DLL imports (if needed)
   - ✅ Allow external experts imports
   - Set **Maximum bars in chart**: 1000000
   - Set **Maximum bars in history**: 1000000

3. **Network Settings:**
   - Tools → Options → Server
   - Enable **Auto configuration**
   - Set **Timeout**: 60 seconds

4. **Charts Settings:**
   - Tools → Options → Charts
   - Set **History bars**: 1000000
   - Set **Max bars in chart**: 1000000
   - Enable **Show OHLC**
   - Enable **Show Bid line**

---

## 2. EXNESS App Settings (Color & Symbol)

### Step 2.1: Chart Color Scheme Configuration

1. **Open Chart Settings:**
   - Right-click on any chart → **Properties**
   - Or: Press `F8` while chart is active

2. **Color Tab Configuration:**

   **Background Colors:**
   - **Background**: Dark theme (RGB: 30, 30, 30) or Light theme (RGB: 255, 255, 255)
   - **Foreground**: Text color (RGB: 200, 200, 200) for dark theme
   - **Grid**: Grid line color (RGB: 60, 60, 60) for dark theme
   - **Volumes**: Volume bar color (RGB: 100, 100, 200)

   **Candle Colors:**
   - **Bullish (Buy)**: Green (RGB: 0, 200, 0) or custom color
   - **Bearish (Sell)**: Red (RGB: 200, 0, 0) or custom color
   - **Bullish (Border)**: Dark green (RGB: 0, 150, 0)
   - **Bearish (Border)**: Dark red (RGB: 150, 0, 0)

   **Line Colors:**
   - **Bid Line**: Yellow (RGB: 255, 255, 0)
   - **Ask Line**: Cyan (RGB: 0, 255, 255)
   - **Last**: White (RGB: 255, 255, 255)

3. **Apply Color Scheme:**
   - Click **OK** to apply
   - Or save as template: **Charts** → **Templates** → **Save Template**

### Step 2.2: Symbol Configuration

1. **Add Symbols to Market Watch:**
   - Press `Ctrl+M` to open Market Watch
   - Right-click in Market Watch → **Symbols**
   - Search for symbol (e.g., EURUSD, GBPUSD, BTCUSD)
   - Click **Show** to add to Market Watch
   - Click **Close**

2. **Configure Symbol Properties:**
   - Right-click symbol in Market Watch → **Specification**
   - Review:
     - **Contract Size**: Usually 100,000 for forex
     - **Digits**: Number of decimal places (5 for most forex)
     - **Point**: Smallest price change (0.00001 for 5-digit)
     - **Min Lot**: Minimum trade size (usually 0.01)
     - **Max Lot**: Maximum trade size
     - **Lot Step**: Increment size (usually 0.01)
     - **Swap Long/Short**: Overnight swap rates

3. **Symbol Display Settings:**
   - Right-click symbol in Market Watch → **Properties**
   - Configure:
     - **Show**: ✅ Enabled
     - **Digits**: Number of decimal places
     - **Spread**: Show spread in points
     - **High/Low**: Show daily high/low

### Step 2.3: Chart Symbol Setup

1. **Open Chart for Symbol:**
   - Right-click symbol in Market Watch → **Chart Window**
   - Or: Drag symbol from Market Watch to chart area

2. **Chart Timeframe:**
   - Select timeframe: M1, M5, M15, M30, H1, H4, D1, W1, MN1
   - Right-click chart → **Timeframes** → Select desired timeframe

3. **Chart Type:**
   - **Candlesticks** (default): Right-click → **Candles**
   - **Bars**: Right-click → **Bars**
   - **Line**: Right-click → **Line**

4. **Save Chart Template:**
   - Configure chart with desired colors and settings
   - **Charts** → **Templates** → **Save Template**
   - Name: "EXNESS-Dark" or "EXNESS-Light"
   - Apply to other charts: **Charts** → **Templates** → **Load Template**

### Step 2.4: Recommended Color Schemes

**Dark Theme (Recommended for Trading):**
```
Background: RGB(30, 30, 30)
Foreground: RGB(200, 200, 200)
Grid: RGB(60, 60, 60)
Bullish Candle: RGB(0, 200, 0)
Bearish Candle: RGB(200, 0, 0)
Bid Line: RGB(255, 255, 0)
Ask Line: RGB(0, 255, 255)
```

**Light Theme:**
```
Background: RGB(255, 255, 255)
Foreground: RGB(0, 0, 0)
Grid: RGB(200, 200, 200)
Bullish Candle: RGB(0, 150, 0)
Bearish Candle: RGB(150, 0, 0)
Bid Line: RGB(255, 200, 0)
Ask Line: RGB(0, 150, 255)
```

---

## 3. Expert Advisor (EA) Setup

### Step 3.1: Locate EA Files

**EA Directory:**
```
C:\Users\USER\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\MQL5\Experts\Advisors
```

**MQL5 Repository:**
```
C:\Users\USER\OneDrive\mql5-repo\Experts\Advisors
```

### Step 3.2: Copy EA to Terminal Directory

**Option A: Manual Copy**
1. Navigate to MQL5 repository: `C:\Users\USER\OneDrive\mql5-repo\Experts\Advisors`
2. Copy desired EA files (`.mq5` files)
3. Paste to: `C:\Users\USER\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06\MQL5\Experts\Advisors`

**Option B: Using PowerShell Script**
```powershell
.\push-mql5-to-repos-and-setup-exness.ps1
```

### Step 3.3: Compile Expert Advisors

**Option A: Using MetaEditor (Recommended)**

1. **Open MetaEditor:**
   ```cmd
   "C:\Program Files\MetaTrader 5 EXNESS\metaeditor64.exe"
   ```

2. **Open EA File:**
   - Press `Ctrl+O` (Open)
   - Navigate to: `MQL5\Experts\Advisors`
   - Select EA file (e.g., `ExpertMACD_Enhanced.mq5`)

3. **Compile:**
   - Press `F7` or click **Compile** button
   - Check **Errors** tab: Should show "0 error(s), 0 warning(s)"
   - Verify `.ex5` file is created in same directory

4. **Repeat for Other EAs:**
   - `ExpertMAMA_Enhanced.mq5`
   - `ExpertMAPSAR_Enhanced.mq5`
   - `PythonBridgeEA.mq5` (if using Python bridge)

**Option B: Using PowerShell Script**
```powershell
.\compile-mql5-eas.ps1
```

### Step 3.4: Attach EA to Chart

1. **Open Chart:**
   - Open EXNESS Terminal
   - Right-click symbol in Market Watch → **Chart Window**
   - Select desired timeframe (e.g., H1, M15)

2. **Open Navigator:**
   - Press `Ctrl+N` or View → **Navigator**

3. **Attach EA:**
   - Expand **Expert Advisors** in Navigator
   - **Drag EA** (e.g., `ExpertMACD_Enhanced`) onto chart
   - ⚠️ **IMPORTANT**: Use **Enhanced** versions (have risk management!)

4. **Configure EA Parameters:**

   **For ExpertMACD_Enhanced:**
   - **Inp_Money_FixedRisk_Percent**: `1.0` (1% risk per trade)
   - **Inp_Signal_MACD_StopLoss**: `20` (20 pips)
   - **Inp_Signal_MACD_TakeProfit**: `50` (50 pips)
   - **Inp_Signal_MACD_MagicNumber**: `123456` (unique ID)
   - **Inp_Signal_MACD_Period_Fast**: `12` (default)
   - **Inp_Signal_MACD_Period_Slow**: `26` (default)
   - **Inp_Signal_MACD_Period_Signal**: `9` (default)

   **For PythonBridgeEA:**
   - **BridgePort**: `5555` (must match Python bridge)
   - **BrokerName**: `EXNESS`
   - **AutoExecute**: `true`
   - **DefaultLotSize**: `0.01`

5. **Enable AutoTrading:**
   - Click **AutoTrading** button in toolbar (should turn green)
   - EA name should appear in top-right of chart
   - Check **Experts** tab in Terminal for EA status

### Step 3.5: Monitor EA Activity

1. **Terminal Tab:**
   - View → **Terminal** or press `Ctrl+T`
   - Monitor trade execution and orders

2. **Journal Tab:**
   - View → **Journal** or press `Ctrl+J`
   - Monitor EA messages and errors

3. **Experts Tab:**
   - View → **Toolbox** → **Experts**
   - See EA status, logs, and execution details

4. **Trade Tab:**
   - View → **Trade** or press `Ctrl+T`
   - Monitor open positions and pending orders

### Step 3.6: EA Risk Management Settings

**Recommended Configuration:**
- **Risk per Trade**: 1% (`Inp_Money_FixedRisk_Percent = 1.0`)
- **Stop Loss**: 20-30 pips
- **Take Profit**: 50-75 pips
- **Risk/Reward Ratio**: 1:2.5 to 1:3
- **Magic Number**: Unique ID per EA instance

**⚠️ CRITICAL: Use Enhanced EAs Only!**

✅ **SAFE - Use These:**
- `ExpertMACD_Enhanced.mq5` - Has 1% risk management
- `ExpertMAMA_Enhanced.mq5` - Has 1% risk management
- `ExpertMAPSAR_Enhanced.mq5` - Has 1% risk management

❌ **DANGEROUS - Do NOT Use:**
- `ExpertMACD.mq5` - NO risk management!
- `ExpertMAMA.mq5` - NO risk management!
- `ExpertMAPSAR.mq5` - NO risk management!

---

## 4. Connecting Your MQL5 Account

### Step 4.1: Why Connect Your MQL5 Account?

Connecting your MQL5 account to the MetaTrader 5 terminal allows you to:
- **Access Purchased Assets**: Download and use Expert Advisors (EAs), indicators, and scripts that you have purchased from the MQL5 Market.
- **Use Community Assets**: Access free and open-source tools shared by the MQL5 community.
- **Stay Updated**: Easily update your purchased assets to the latest versions.

### Step 4.2: How to Connect

You can connect your MQL5 account by following the guided instructions in the `connect-mql5-account.ps1` script.

**Run the script:**
```powershell
.\connect-mql5-account.ps1
```

This script will provide you with the following manual steps:

1.  **Open EXNESS MetaTrader 5 Terminal.**
2.  Go to **'Tools' -> 'Options'** from the top menu.
3.  Click on the **'Community'** tab.
4.  Enter your MQL5 username and password.
    - Your username is: `lengkundee`
5.  Click **'OK'** to save.

### Step 4.3: Verify Your Connection and Assets

After connecting your account, you can verify that your assets are available by running the `verify-mql5-assets.ps1` script.

**Run the script:**
```powershell
.\verify-mql5-assets.ps1
```

This script will:
- Locate your MetaTrader 5 data directory.
- Check for the `MQL5\Market` folder.
- List any assets you have downloaded from the MQL5 Market.

If the script shows an empty list, you may need to go to the "Market" tab in the terminal's "Toolbox" window and download your purchased items.

---

## 5. VPS Setup for 24/7 Trading

### Step 5.1: VPS Requirements

**Minimum Requirements:**
- **OS**: Windows Server 2019/2022 or Windows 10/11
- **RAM**: 2GB minimum (4GB recommended)
- **CPU**: 2 cores minimum
- **Storage**: 20GB minimum (SSD recommended)
- **Network**: Stable internet connection (low latency to broker)

**Recommended VPS Providers:**
- **Vultr**: https://www.vultr.com/
- **DigitalOcean**: https://www.digitalocean.com/
- **AWS EC2**: https://aws.amazon.com/ec2/
- **Azure**: https://azure.microsoft.com/

### Step 4.2: Initial VPS Setup

1. **Connect to VPS:**
   - Use Remote Desktop Connection (RDP)
   - Enter VPS IP address and credentials
   - Connect and login

2. **Install EXNESS Terminal on VPS:**
   - Download EXNESS Terminal installer
   - Install as Administrator
   - Login with your EXNESS account

3. **Install Required Software:**
   - **Python 3.8+** (if using Python bridge)
   - **Git** (for repository management)
   - **Firefox** (for web services, if needed)
   - **PowerShell 5.1+** (usually pre-installed)

### Step 4.3: Deploy VPS Services

1. **Copy Project Files to VPS:**
   - Copy entire `OneDrive` folder or specific trading folders
   - Or clone repository: `git clone https://github.com/A6-9V/my-drive-projects.git`

2. **Run VPS Deployment Script:**
   ```powershell
   # Run as Administrator
   .\vps-deployment.ps1
   ```

   This will:
   - Create service directories (`vps-services\`, `vps-logs\`)
   - Create all 6 service scripts
   - Create master controller
   - Create Windows Scheduled Task for auto-start

3. **Verify Deployment:**
   ```powershell
   .\vps-verification.ps1
   ```

### Step 4.4: Start VPS System

**Option A: Using PowerShell Script**
```powershell
# Run as Administrator
.\start-vps-system.ps1
```

**Option B: Using Batch File**
```cmd
.\START-VPS-SYSTEM.bat
```

This will:
1. Run `launch-admin.ps1`
2. Run `launch-exness-trading.ps1` (starts Exness Terminal)
3. Deploy VPS services (if needed)
4. Start master controller (starts all background services)

### Step 4.5: VPS Services Overview

**Services Included:**

1. **Exness Trading Service** - MT5 Terminal 24/7
   - Monitors EXNESS Terminal
   - Auto-restarts if stopped
   - Logs trading activity

2. **Web Research Service** - Perplexity AI finance research
   - Auto-searches finance topics
   - Generates reports every 6 hours
   - Sets up trading schedules

3. **GitHub Website Service** - ZOLO-A6-9VxNUNA running in Firefox
   - Opens website every hour
   - Monitors for updates

4. **CI/CD Automation** - Auto-runs Python GitHub projects
   - Runs every 30 minutes
   - Executes automated tasks

5. **MQL5 Forge Integration**
   - Syncs with MQL5 repository
   - Updates every 12 hours
   - URL: https://forge.mql5.io/LengKundee/mql5

6. **Master Controller** - Monitors and restarts all services
   - Checks service health every 5 minutes
   - Auto-restarts failed services
   - Logs all activities

### Step 4.6: VPS Auto-Start Configuration

**Windows Scheduled Task:**
- Created automatically by `vps-deployment.ps1`
- Starts on system boot
- Runs master controller
- Master controller starts all services

**Manual Configuration (if needed):**
```powershell
# Create scheduled task
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File `"C:\Users\USER\OneDrive\start-vps-system.ps1`""
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -RunLevel Highest
Register-ScheduledTask -TaskName "VPS-Trading-System" -Action $action -Trigger $trigger -Principal $principal
```

### Step 4.7: VPS Monitoring and Maintenance

**Check Service Status:**
```powershell
.\vps-verification.ps1
```

**View Logs:**
- Logs location: `vps-logs\`
- Service-specific logs: `vps-logs\exness-service.log`, etc.

**Stop Services:**
```powershell
.\stop-vps.ps1
```

**Restart Services:**
```powershell
.\stop-vps.ps1 -Restart
```

Or use batch files:
- `STOP-VPS.bat` - Stop all services
- `RESTART-VPS.bat` - Restart all services

**Update System:**
```powershell
.\update-vps.ps1
```

This will:
- Update all Git repositories
- Refresh VPS service scripts
- Check service status
- Update Python dependencies

**Update Expert Advisors:**
```powershell
.\update-expert-by-vps-log.ps1
```

This will:
- Analyze VPS logs for errors and trading signals
- Check MQL5 repository for updates
- Sync EA files from repository to MT5 terminal
- Compile updated Expert Advisors

### Step 4.8: VPS Security Best Practices

1. **Firewall Configuration:**
   - Allow RDP (port 3389) only from trusted IPs
   - Allow MT5 connections (ports 443, 4430)
   - Block unnecessary ports

2. **Windows Updates:**
   - Enable automatic updates
   - Schedule maintenance windows

3. **Backup Configuration:**
   - Backup EA files regularly
   - Backup configuration files
   - Use version control (Git) for code

4. **Monitoring:**
   - Set up alerts for service failures
   - Monitor VPS resource usage
   - Check logs regularly

---

## 🔧 Troubleshooting

### EXNESS Terminal Issues

**Terminal Won't Start:**
- Check if already running: `Get-Process -Name "terminal64" -ErrorAction SilentlyContinue`
- Run as Administrator
- Check installation path: `Test-Path "C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe"`

**Can't Login:**
- Verify account credentials
- Check internet connection
- Verify server selection
- Contact EXNESS support if persistent

**AutoTrading Button Grayed Out:**
- Login to trading account first
- Check Tools → Options → Expert Advisors → Allow automated trading
- Verify account has trading permissions

### EA Issues

**EA Not Appearing in Navigator:**
- Compile the EA first (F7 in MetaEditor)
- Verify `.ex5` file exists in Advisors folder
- Restart MT5 Terminal

**EA Not Trading:**
- Check AutoTrading is enabled (green button)
- Check EA is attached to chart (name in top-right)
- Check Journal tab for error messages
- Verify account has sufficient margin
- Check EA parameters (risk settings, magic number)

**Compilation Errors:**
- Check all include files are in `MQL5\Include` folder
- Check MetaEditor Errors tab for specific errors
- Verify MQL5 syntax is correct

### VPS Issues

**Services Not Starting:**
- Check you're running as Administrator
- Run `vps-verification.ps1` to see what's missing
- Check logs in `vps-logs\` for errors
- Verify EXNESS Terminal is installed on VPS

**Connection Issues:**
- Verify VPS has stable internet connection
- Check firewall settings
- Verify EXNESS server connectivity
- Test ping to broker servers

**High Resource Usage:**
- Monitor CPU and RAM usage
- Close unnecessary applications
- Optimize EA settings (reduce chart bars, etc.)
- Consider upgrading VPS resources

---

## 📋 Quick Reference

### File Locations

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
C:\Users\USER\OneDrive\mql5-repo
```

**VPS Logs:**
```
C:\Users\USER\OneDrive\vps-logs\
```

### Quick Commands

**Launch EXNESS Terminal:**
```powershell
.\launch-exness-trading.ps1
```

**Compile EAs:**
```powershell
.\compile-mql5-eas.ps1
```

**Start VPS System:**
```powershell
.\start-vps-system.ps1
```

**Stop VPS System:**
```powershell
.\stop-vps.ps1
```

**Verify VPS:**
```powershell
.\vps-verification.ps1
```

**Update VPS:**
```powershell
.\update-vps.ps1
```

---

## ✅ Setup Checklist

### EXNESS Terminal
- [ ] EXNESS Terminal installed
- [ ] Logged in to EXNESS account
- [ ] AutoTrading enabled
- [ ] Expert Advisors enabled in settings
- [ ] Network settings configured

### App Settings
- [ ] Color scheme configured (dark/light theme)
- [ ] Symbol colors set (bullish/bearish)
- [ ] Symbols added to Market Watch
- [ ] Chart templates saved
- [ ] Chart timeframes configured

### Expert Advisors
- [ ] EA files copied to terminal directory
- [ ] EAs compiled successfully (no errors)
- [ ] Enhanced EAs used (with risk management)
- [ ] EA attached to chart
- [ ] EA parameters configured (1% risk)
- [ ] AutoTrading enabled
- [ ] EA monitoring set up (Terminal, Journal, Experts tabs)

### MQL5 Account
- [ ] MQL5 account connected in terminal
- [ ] MQL5 assets verified

### VPS Setup
- [ ] VPS provisioned and accessible
- [ ] EXNESS Terminal installed on VPS
- [ ] VPS services deployed (`vps-deployment.ps1`)
- [ ] VPS system started (`start-vps-system.ps1`)
- [ ] Services verified (`vps-verification.ps1`)
- [ ] Auto-start configured (Scheduled Task)
- [ ] Monitoring and logging set up

---

## 🎯 Next Steps

1. **Connect MQL5 Account:**
   - Run `.\connect-mql5-account.ps1`
   - Follow the on-screen instructions
   - Run `.\verify-mql5-assets.ps1` to confirm

2. **Test Trading:**
   - Start with demo account
   - Test EA with small lot sizes
   - Monitor performance

3. **Optimize Settings:**
   - Adjust risk parameters based on results
   - Fine-tune EA parameters
   - Optimize VPS resources

4. **Monitor Performance:**
   - Check logs regularly
   - Monitor trading activity
   - Review EA performance

5. **Maintain System:**
   - Update EAs regularly
   - Update VPS services
   - Backup configurations

---

**Status**: ✅ Complete Setup Guide  
**Created**: 2025-12-09  
**System**: NuNa (Windows 11 Home Single Language 25H2)

