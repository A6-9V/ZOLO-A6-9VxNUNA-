# VPS Deployment Guide - EXNESS GenX Trader

## Prerequisites

1. **VPS Access**: Remote Desktop (RDP) access to your VPS
2. **MetaTrader 5**: MT5 terminal installed on VPS
3. **Account**: EXNESS account credentials ready
4. **Network**: Stable internet connection

## Quick Deployment Steps

### Method 1: Automated Deployment (Recommended)

1. **Run the deployment script**:
   ```powershell
   .\deploy_to_vps.ps1
   ```

2. **Follow the prompts** to enter:
   - VPS IP address or hostname
   - RDP username
   - VPS MT5 installation path
   - Account credentials (optional, can be set later)

### Method 2: Manual Deployment

#### Step 1: Copy Files to VPS

1. Connect to your VPS via Remote Desktop
2. Copy the following files to VPS:
   - `EXPERTS\EXNESS_GenX_Trader.mq5` → `[VPS_MT5_PATH]\MQL5\Experts\`
   - `INCLUDE\EXNESS_GenX_Config.mqh` → `[VPS_MT5_PATH]\MQL5\Include\`

   **Typical VPS MT5 Paths:**
   - `C:\Program Files\MetaTrader 5\MQL5\`
   - `C:\Users\[USERNAME]\AppData\Roaming\MetaQuotes\Terminal\[TERMINAL_ID]\MQL5\`

#### Step 2: Compile the EA

1. Open MetaTrader 5 on VPS
2. Press `F4` to open MetaEditor
3. Navigate to `Experts` folder
4. Open `EXNESS_GenX_Trader.mq5`
5. Press `F7` to compile
6. Check for errors in the "Errors" tab (should be empty if successful)

#### Step 3: Attach EA to Chart

1. In MT5 terminal, open a chart (e.g., EURUSD H1)
2. Press `Ctrl+N` to open Navigator
3. Expand `Expert Advisors`
4. Drag `EXNESS_GenX_Trader` onto the chart
5. Configure settings in the EA input parameters
6. Click `OK`

#### Step 4: Enable AutoTrading

1. Click the **AutoTrading** button in MT5 toolbar (should turn green)
2. Verify EA is running (smiley face icon on chart)
3. Check the "Experts" tab for EA logs

## VPS Configuration (Current Device: NuNa)

### Specifications

- **Device name**: NuNa
- **Processor**: Intel(R) Core(TM) i3-N305 (1.80 GHz)
- **RAM**: 8.00 GB (7.63 GB usable)
- **Storage**: 20GB+ SSD (Recommended)
- **OS**: Windows 11 Home Single Language (Build 26220.7653)
- **Network**: Low latency connection (<50ms to broker)
- **Device ID**: 32680105-F98A-49B6-803C-8A525771ABA3
- **Product ID**: 00356-24782-61221-AAOEM

### MT5 Terminal Settings on VPS

1. **AutoTrading**: Enable (green button)
2. **Allow DLL imports**: Enable if needed
3. **Allow automated trading**: Enable
4. **Allow live trading**: Enable
5. **Keep terminal running**: Enable
6. **Auto-start**: Configure Windows Task Scheduler (optional)

### Windows Task Scheduler Setup (Auto-Start)

1. Open Task Scheduler
2. Create Basic Task:
   - **Name**: MT5 AutoStart
   - **Trigger**: When computer starts
   - **Action**: Start program
   - **Program**: `[MT5_PATH]\terminal64.exe`
   - **Arguments**: `/login:[ACCOUNT] /password:[PASSWORD]`

## Verification Checklist

- [ ] EA files copied to correct VPS directories
- [ ] EA compiled successfully (no errors)
- [ ] EA attached to chart
- [ ] AutoTrading enabled (green button)
- [ ] EA shows smiley face on chart
- [ ] EA logs visible in "Experts" tab
- [ ] Account connected and online
- [ ] Test trade executed (optional, with small lot size)

## Troubleshooting

### EA Not Appearing in Navigator

- Check file is in `MQL5\Experts\` folder
- Verify file compiled successfully (check for `.ex5` file)
- Restart MT5 terminal

### EA Not Trading

- Verify AutoTrading is enabled
- Check EA inputs: `CFG_Enable_Trading = true`
- Check account balance and margin
- Verify symbol is available and trading hours
- Check EA logs for error messages

### Connection Issues

- Verify VPS has stable internet
- Check broker server status
- Verify account credentials
- Check firewall settings

### EA Stops Running

- Check VPS is not sleeping/hibernating
- Verify MT5 terminal is running
- Check Windows Event Viewer for errors
- Ensure VPS has sufficient resources

## Remote Monitoring

### Option 1: MT5 Mobile App

- Install MT5 mobile app
- Login with same account
- Monitor positions and EA status

### Option 2: VPS Remote Desktop

- Use RDP client to connect
- Monitor MT5 terminal directly
- Check EA logs and performance

### Option 3: MT5 Web Terminal

- Access via broker's web terminal
- Monitor account and positions
- Limited EA control

## Security Best Practices

1. **Use strong VPS passwords**
2. **Enable Windows Firewall**
3. **Use VPN for RDP access** (recommended)
4. **Regular backups** of EA files and settings
5. **Monitor account activity** regularly
6. **Set position limits** in EA configuration
7. **Use demo account first** to test deployment

## Support

For issues or questions:
- Check EA logs in MT5 "Experts" tab
- Review configuration in `EXNESS_GenX_Config.mqh`
- Verify all prerequisites are met
