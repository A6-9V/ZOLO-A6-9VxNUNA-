# Complete VPS Deployment Guide for 24/7 Trading System

Comprehensive step-by-step guide to deploy your trading system on a Windows VPS for 24/7 operation without keeping your laptop running.

## Table of Contents
1. [Why You Need a VPS](#why-you-need-a-vps)
2. [Choosing a VPS Provider](#choosing-a-vps-provider)
3. [VPS Setup (Step-by-Step)](#vps-setup-step-by-step)
4. [Deploy Trading System to VPS](#deploy-trading-system-to-vps)
5. [Configure 24/7 Automation](#configure-247-automation)
6. [Monitoring & Maintenance](#monitoring--maintenance)
7. [Cost Estimates](#cost-estimates)
8. [Troubleshooting](#troubleshooting)

---

## Why You Need a VPS

**Problem**: Your laptop needs to stay on 24/7 for trading
**Solution**: Windows VPS server runs continuously in the cloud

**Benefits**:
- ✅ Trading runs 24/7 without your laptop
- ✅ No electricity costs at home
- ✅ No wear and tear on your laptop
- ✅ Reliable uptime (99.9% guarantee)
- ✅ Fast and stable internet connection
- ✅ Access from anywhere (phone, tablet, laptop)

---

## Choosing a VPS Provider

### Recommended Providers (Ranked)

#### 1. **Contabo** (Best Value)
- **Price**: €8.99/month (~$9.50/month)
- **Specs**: 4 vCPU, 6 GB RAM, 100 GB SSD
- **OS**: Windows Server 2019/2022
- **Location**: Multiple (US, Europe, Asia)
- **Website**: https://contabo.com/en/windows-vps/
- **Why**: Cheapest, great performance for trading

#### 2. **Vultr** (Good Balance)
- **Price**: $24/month
- **Specs**: 2 vCPU, 4 GB RAM, 80 GB SSD
- **OS**: Windows Server 2019/2022
- **Location**: 25+ global locations
- **Website**: https://www.vultr.com/pricing/
- **Why**: Easy to use, reliable, good support

#### 3. **Amazon AWS EC2** (Enterprise)
- **Price**: ~$30-50/month (varies by usage)
- **Specs**: t3a.medium (2 vCPU, 4 GB RAM)
- **OS**: Windows Server
- **Location**: Global AWS regions
- **Website**: https://aws.amazon.com/ec2/
- **Why**: Most reliable, enterprise-grade

#### 4. **DigitalOcean** (Simple)
- **Price**: $48/month
- **Specs**: 2 vCPU, 4 GB RAM, 80 GB SSD
- **OS**: Windows Server
- **Location**: Global data centers
- **Website**: https://www.digitalocean.com/pricing/droplets
- **Why**: Simple interface, good documentation

### Minimum Requirements for Trading
- **CPU**: 2+ cores
- **RAM**: 4 GB minimum (8 GB recommended)
- **Storage**: 50 GB minimum
- **OS**: Windows Server 2019 or 2022
- **Network**: Unlimited bandwidth

---

## VPS Setup (Step-by-Step)

### Step 1: Purchase and Create VPS

**Using Contabo (Example)**:

1. **Go to**: https://contabo.com/en/windows-vps/
2. **Select Plan**: 
   - VPS M: €8.99/month (recommended)
   - 4 vCPU, 6 GB RAM, 100 GB SSD
3. **Configuration**:
   - **Operating System**: Windows Server 2022
   - **Region**: Choose closest to you (US, Europe, Asia)
   - **Additional Options**: None needed
4. **Create Account**:
   - Enter your email
   - Create password
   - Add payment method
5. **Complete Purchase**
6. **Wait**: 15-30 minutes for VPS provisioning
7. **Check Email**: You'll receive:
   - VPS IP address
   - Administrator username
   - Administrator password
   - RDP connection details

### Step 2: Connect to Your VPS

**On Windows (Remote Desktop)**:

1. **Open Remote Desktop Connection**:
   - Press `Windows + R`
   - Type: `mstsc`
   - Press Enter

2. **Enter VPS Details**:
   - **Computer**: Enter VPS IP address (from email)
   - Click "Connect"

3. **Login Credentials**:
   - **Username**: Administrator
   - **Password**: (from email)

4. **Accept Certificate Warning**: Click "Yes"

5. **You're Connected**: You should see Windows Server desktop

**On Mac (Microsoft Remote Desktop)**:

1. **Install**: Microsoft Remote Desktop from App Store
2. **Add PC**: Click "+" → Add PC
3. **Enter**: VPS IP address
4. **Credentials**: Administrator + password
5. **Connect**: Double-click the PC

**On Linux (Remmina)**:

1. **Install**: `sudo apt install remmina`
2. **Protocol**: RDP
3. **Server**: VPS IP address
4. **Username/Password**: From email
5. **Connect**

### Step 3: Initial VPS Configuration

**Once connected to VPS**:

1. **Change Administrator Password**:
   ```powershell
   # Run in PowerShell as Administrator
   net user Administrator "YourNewStrongPassword123!"
   ```

2. **Set Time Zone**:
   ```powershell
   # Set to your timezone (example: Pacific Time)
   Set-TimeZone -Id "Pacific Standard Time"
   
   # List all timezones
   Get-TimeZone -ListAvailable
   ```

3. **Windows Updates**:
   - Open Settings → Windows Update
   - Click "Check for updates"
   - Install all updates
   - Restart VPS if needed

4. **Install Required Software**:

   **a) Google Chrome or Firefox**:
   - Download: https://www.google.com/chrome/ or https://www.mozilla.org/firefox/
   - Install normally

   **b) Git for Windows**:
   - Download: https://git-scm.com/download/win
   - Install with default options

   **c) Python (if not installed)**:
   - Download: https://www.python.org/downloads/
   - ✅ Check "Add Python to PATH"
   - Install

   **d) Node.js**:
   - Download: https://nodejs.org/
   - Install LTS version

---

## Deploy Trading System to VPS

### Step 1: Install Exness MT5 Terminal

1. **Download MT5 Terminal**:
   - Open browser on VPS
   - Go to: https://www.exness.com/trading-platforms/metatrader5/
   - Download MT5 Terminal
   - Install with default settings

2. **Login to MT5**:
   - Open MetaTrader 5
   - Enter your Exness account credentials:
     - Account ID: #405347405 (or your account)
     - Password: Your MT5 password
     - Server: Select Exness server
   - Click "Login"

3. **Verify Connection**:
   - Bottom right should show connection status
   - Should see your account balance
   - Charts should be updating

### Step 2: Clone Repository to VPS

1. **Open PowerShell as Administrator** on VPS:
   - Right-click Start → Windows PowerShell (Admin)

2. **Navigate to Your User Directory**:
   ```powershell
   cd $env:USERPROFILE
   ```

3. **Clone Repository**:
   ```powershell
   # Using HTTPS (easier, no SSH keys needed)
   git clone https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git
   
   # Navigate to repository
   cd ZOLO-A6-9VxNUNA-
   ```

4. **Configure Git** (if needed):
   ```powershell
   git config --global user.name "Mouy-leng"
   git config --global user.email "your-email@example.com"
   ```

### Step 3: Configure Trading Account

1. **Run Account Configuration**:
   ```powershell
   # In repository directory
   .\configure-trading-account.ps1 -AccountId '405347405'
   ```

2. **When Prompted**:
   - Enter your Exness API key (get from https://www.exness.com/accounts/api)
   - Enter your Exness API secret
   - Script will update `trading-bridge/config/brokers.json`

3. **Verify Configuration**:
   ```powershell
   Get-Content trading-bridge\config\brokers.json
   ```
   Should show your account ID (credentials are encrypted)

### Step 4: Deploy VPS System

1. **Run VPS Deployment Script**:
   ```powershell
   # In repository directory
   .\vps-deployment.ps1
   ```

   This script will:
   - Create VPS service directories
   - Install all service scripts
   - Configure scheduled tasks
   - Set up auto-start on boot

2. **Or Use Quick Start**:
   ```powershell
   .\START-VPS-SYSTEM.bat
   ```

---

## Configure 24/7 Automation

### Step 1: Start All Services

1. **Run Master Controller**:
   ```powershell
   .\start-vps-system.ps1
   ```

   This starts:
   - ✅ Exness MT5 Terminal (24/7 monitoring)
   - ✅ Trading system automation
   - ✅ Web services (if configured)
   - ✅ Monitoring and logging

2. **Verify Services Running**:
   ```powershell
   .\vps-verification.ps1
   ```

   Should show:
   ```
   ✅ Exness Service: Running
   ✅ Master Controller: Running
   ✅ Scheduled Task: Active
   ✅ MT5 Terminal: Connected
   ```

### Step 2: Configure Auto-Start on VPS Reboot

**The deployment script already creates a scheduled task, but to verify**:

1. **Check Scheduled Task**:
   ```powershell
   Get-ScheduledTask -TaskName "VPS-Trading-System-24-7"
   ```

2. **If Not Created, Create Manually**:
   ```powershell
   $action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
       -Argument "-ExecutionPolicy Bypass -File `"$PWD\start-vps-system.ps1`""
   
   $trigger = New-ScheduledTaskTrigger -AtStartup
   
   $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" `
       -LogonType ServiceAccount -RunLevel Highest
   
   Register-ScheduledTask -TaskName "VPS-Trading-System-24-7" `
       -Action $action -Trigger $trigger -Principal $principal `
       -Description "24/7 Trading System Auto-Start"
   ```

3. **Test Auto-Start**:
   - Restart VPS
   - Wait 2-3 minutes
   - Check if services are running:
     ```powershell
     .\vps-verification.ps1
     ```

### Step 3: Configure Launch Script for Account #405347405

1. **Use Quick Launch**:
   ```powershell
   .\launch-trading-405347405.ps1
   ```

   This automatically:
   - Configures account #405347405
   - Launches MT5 Terminal
   - Starts trading system
   - Enables 24/7 monitoring

2. **Add to Startup** (optional, if not using scheduled task):
   ```powershell
   # Create shortcut in Startup folder
   $WshShell = New-Object -ComObject WScript.Shell
   $Shortcut = $WshShell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Trading-System.lnk")
   $Shortcut.TargetPath = "PowerShell.exe"
   $Shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$PWD\launch-trading-405347405.ps1`""
   $Shortcut.Save()
   ```

---

## Monitoring & Maintenance

### Daily Monitoring (From Your Laptop/Phone)

1. **Connect to VPS via RDP**:
   - Use Remote Desktop Connection
   - Enter VPS IP address
   - Login

2. **Check System Status**:
   ```powershell
   # In repository directory
   .\vps-verification.ps1
   ```

3. **View Recent Logs**:
   ```powershell
   # View Exness service log
   Get-Content vps-logs\exness-service.log -Tail 50
   
   # View master controller log
   Get-Content vps-logs\master-controller.log -Tail 50
   ```

4. **Check MT5 Terminal**:
   - MT5 should be running and connected
   - Check "Journal" tab for any errors
   - Verify trades are being executed

### Weekly Maintenance

1. **Update Repository**:
   ```powershell
   cd $env:USERPROFILE\ZOLO-A6-9VxNUNA-
   git pull origin main
   ```

2. **Check Disk Space**:
   ```powershell
   Get-PSDrive C | Select-Object Used,Free
   ```

3. **Review Service Logs**:
   ```powershell
   Get-ChildItem vps-logs\*.log | ForEach-Object {
       Write-Host "`n=== $($_.Name) ===" -ForegroundColor Cyan
       Get-Content $_.FullName -Tail 20
   }
   ```

### Monthly Maintenance

1. **Windows Updates**:
   - Check for Windows Server updates
   - Schedule updates during low-trading hours

2. **Backup Configuration**:
   ```powershell
   # Backup broker config
   Copy-Item trading-bridge\config\brokers.json `
       -Destination "trading-bridge\config\brokers-backup-$(Get-Date -Format 'yyyy-MM-dd').json"
   ```

3. **Update Dependencies**:
   ```powershell
   # Update Python packages
   pip install --upgrade pip
   pip install -r requirements.txt --upgrade
   
   # Update npm packages
   npm update
   ```

---

## Cost Estimates

### Monthly Costs

| Provider | Plan | Monthly Cost | Annual Cost |
|----------|------|--------------|-------------|
| **Contabo** | VPS M | $9.50 | $114 |
| **Vultr** | 2 vCPU | $24 | $288 |
| **AWS EC2** | t3a.medium | $30-50 | $360-600 |
| **DigitalOcean** | 2 vCPU | $48 | $576 |

**Recommended**: Contabo VPS M ($9.50/month)

### Additional Costs (Optional)
- **Domain name**: $10-15/year (if you want custom URL)
- **SSL certificate**: $0 (Let's Encrypt free)
- **Backup storage**: $0-5/month (if using provider backup)

### Cost Comparison: VPS vs Laptop

| Factor | Laptop 24/7 | VPS |
|--------|-------------|-----|
| **Electricity** | ~$15-30/month | $0 |
| **Wear & Tear** | ~$50/month (depreciation) | $0 |
| **Internet** | Your existing | Included |
| **VPS Rental** | $0 | $10-50/month |
| **Total** | **$65-80/month** | **$10-50/month** |

**Savings**: $15-30/month or $180-360/year

---

## Troubleshooting

### VPS Connection Issues

**Problem**: Can't connect to VPS via RDP

**Solutions**:
1. Check VPS is running (provider control panel)
2. Verify IP address is correct
3. Check if firewall is blocking port 3389:
   ```powershell
   # On VPS (if you can access)
   New-NetFirewallRule -DisplayName "RDP" -Direction Inbound `
       -Protocol TCP -LocalPort 3389 -Action Allow
   ```
4. Contact VPS provider support

### MT5 Not Connecting

**Problem**: MT5 shows "No connection"

**Solutions**:
1. Check internet connection on VPS
2. Verify Exness server is correct
3. Check account credentials:
   - Account ID: #405347405
   - Password: Your MT5 password
   - Server: Exness server
4. Try different Exness server from list
5. Contact Exness support

### Services Not Starting

**Problem**: Trading system services won't start

**Solutions**:
1. Check if running as Administrator:
   ```powershell
   ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
   ```
2. Set execution policy:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
3. Check logs for errors:
   ```powershell
   Get-Content vps-logs\master-controller.log -Tail 100
   ```
4. Manually restart services:
   ```powershell
   .\start-vps-system.ps1
   ```

### Repository Access Issues

**Problem**: Can't clone/pull repository

**Solutions**:
1. Use HTTPS instead of SSH:
   ```powershell
   git clone https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git
   ```
2. Configure Git credentials:
   ```powershell
   git config --global credential.helper wincred
   ```
3. Generate GitHub personal access token:
   - Go to: https://github.com/settings/tokens
   - Generate new token (classic)
   - Use as password when prompted

### High Resource Usage

**Problem**: VPS running slow or out of memory

**Solutions**:
1. Check resource usage:
   ```powershell
   Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10
   ```
2. Close unnecessary applications
3. Restart services:
   ```powershell
   Stop-Process -Name "powershell" -Force
   .\start-vps-system.ps1
   ```
4. Consider upgrading VPS plan

---

## Quick Reference Commands

### Essential Commands

```powershell
# Start trading system
.\start-vps-system.ps1

# Launch account #405347405
.\launch-trading-405347405.ps1

# Verify all services
.\vps-verification.ps1

# View logs
Get-Content vps-logs\exness-service.log -Tail 50

# Update repository
git pull origin main

# Configure trading account
.\configure-trading-account.ps1 -AccountId '405347405'

# Check scheduled task
Get-ScheduledTask -TaskName "VPS-Trading-System-24-7"

# Restart VPS (from PowerShell)
Restart-Computer -Force
```

### Useful Shortcuts

- **Remote Desktop**: `Windows + R` → `mstsc`
- **PowerShell Admin**: `Windows + X` → `A`
- **Task Manager**: `Ctrl + Shift + Esc`
- **Services**: `Windows + R` → `services.msc`

---

## Next Steps After VPS Setup

1. ✅ **Test for 24 Hours**:
   - Let system run for 24 hours
   - Monitor logs and performance
   - Verify trades are executing correctly

2. ✅ **Set Up Monitoring**:
   - Configure email/SMS alerts
   - Set up UptimeRobot (optional): https://uptimerobot.com/

3. ✅ **Document Your Setup**:
   - Save VPS credentials securely
   - Document any customizations
   - Keep backup of configuration files

4. ✅ **Optimize Performance**:
   - Review and adjust service schedules
   - Monitor resource usage
   - Fine-tune trading parameters

5. ✅ **Turn Off Your Laptop**:
   - Once verified working, you can safely turn off your laptop
   - Access VPS from anywhere via RDP

---

## Support & Resources

### VPS Provider Support
- **Contabo**: support@contabo.com
- **Vultr**: https://www.vultr.com/support/
- **AWS**: https://aws.amazon.com/support/
- **DigitalOcean**: https://www.digitalocean.com/support/

### Trading Platform Support
- **Exness**: https://www.exness.com/support/
- **MT5**: https://www.metatrader5.com/en/support

### Repository Documentation
- `VPS-SETUP-GUIDE.md` - VPS system details
- `EXNESS-COMPLETE-SETUP-GUIDE.md` - Exness configuration
- `GITHUB-INTEGRATION.md` - GitHub setup
- `README.md` - Repository overview

---

## Frequently Asked Questions

**Q: Can I use a Linux VPS instead of Windows?**
A: No. MT5 Terminal requires Windows. You must use Windows Server VPS.

**Q: How much does it cost per month?**
A: $10-50/month depending on provider. Contabo is cheapest at $9.50/month.

**Q: Can I run multiple trading accounts?**
A: Yes. Configure each account separately and run multiple MT5 instances.

**Q: What happens if VPS goes down?**
A: Most providers guarantee 99.9% uptime. If it goes down, it will restart automatically.

**Q: Can I access VPS from my phone?**
A: Yes. Install Microsoft Remote Desktop app on iOS/Android.

**Q: Do I need to keep my laptop on?**
A: No. Once deployed to VPS, your laptop can be off. VPS runs independently.

**Q: How do I update my trading scripts?**
A: Connect to VPS, open repository, run `git pull origin main`

**Q: Can I use free VPS services?**
A: Not recommended for trading. Free services have limitations and poor reliability.

---

## Summary Checklist

Before you can turn off your laptop:

- [ ] VPS purchased and provisioned
- [ ] Connected to VPS via Remote Desktop
- [ ] Windows Server configured and updated
- [ ] Required software installed (Git, Python, Node.js)
- [ ] Exness MT5 Terminal installed and logged in
- [ ] Repository cloned to VPS
- [ ] Trading account configured (account #405347405)
- [ ] VPS deployment script executed
- [ ] All services started and verified
- [ ] Scheduled task created for auto-start
- [ ] Tested for 24 hours successfully
- [ ] Logs reviewed - no errors
- [ ] Trades executing correctly
- [ ] VPS credentials saved securely
- [ ] **Laptop can now be turned off!** 🎉

---

**Created**: 2025-12-25  
**For**: Mouy-leng / Account #405347405  
**System**: 24/7 VPS Trading Deployment  
**Status**: Ready for deployment
