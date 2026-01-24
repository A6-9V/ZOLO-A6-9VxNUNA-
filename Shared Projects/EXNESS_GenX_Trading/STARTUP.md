# EXNESS GenX Trading - Startup Management Guide

## Quick Start

### Option 1: Use the Startup Script (Recommended)

Double-click or run:
```batch
start_exness_terminal.bat
```

This script will:
- Set environment variables for GitHub and MQL5.io
- Start MetaTrader 5 EXNESS terminal with account 411534497
- Display connection status

### Option 2: Manual Terminal Start

Navigate to the terminal directory and run:
```batch
cd "E:\Program Files\MetaTrader 5 EXNESS"
terminal64.exe /login:411534497 /password:"Leng3A69V[@Una]"
```

### Option 3: WSL Deployment (Advanced)

If you use WSL, you can automate compilation and deployment using the provided bash script:
```bash
./Shared Projects/EXNESS_GenX_Trading/DEPLOY/wsl_deploy.sh
```
See `DEPLOY/WSL_DEPLOYMENT_GUIDE.md` for setup instructions.

## Configuration

### Environment Variables

The following environment variables are set by the startup script:

| Variable | Value | Purpose |
|----------|-------|---------|
| `GITHUB_TOKEN` | `{{GITHUB_TOKEN}}` | GitHub API access |
| `MQL5_CLIENT_ID` | `{{MQL5_CLIENT_ID}}` | MQL5.io OAuth client ID |
| `MQL5_CLIENT_SECRET` | `{{MQL5_CLIENT_SECRET}}` | MQL5.io OAuth client secret |
| `MQL5_REDIRECT_URI` | `http://127.0.0.1:50729/` | MQL5.io OAuth redirect URI |

### Account Credentials

- **Account Number**: {{MT5_ACCOUNT}}
- **Password**: {{MT5_PASSWORD}}
- **Terminal Path**: `E:\Program Files\MetaTrader 5 EXNESS`

## MQL5.io Integration

When you authorize the MQL5.io application, you will be redirected to:
```
http://127.0.0.1:50729/
```

This local redirect URI is configured for OAuth authentication with MQL5.io services.

## Project Files

- `start_exness_terminal.bat` - Main startup script
- `project_config.env` - Configuration file (DO NOT commit to git)
- `.gitignore` - Git ignore rules for sensitive files

## System Information (Current Device: NuNa)

- **Device name**: NuNa
- **Processor**: Intel(R) Core(TM) i3-N305 (1.80 GHz)
- **Installed RAM**: 8.00 GB (7.63 GB usable)
- **Device ID**: 32680105-F98A-49B6-803C-8A525771ABA3
- **Product ID**: 00356-24782-61221-AAOEM
- **System type**: 64-bit operating system, x64-based processor
- **Windows Edition**: Windows 11 Home Single Language
- **Version**: 25H2
- **OS build**: 26220.7653
- **Experience**: Windows Feature Experience Pack 1000.26100.323.0
- **Terminal Path**: `E:\Program Files\MetaTrader 5 EXNESS`

## Next Steps After Terminal Starts

1. **Wait for Connection**: Allow the terminal to connect to the Exness server
2. **Open MetaEditor**: Press `F4` or go to `Tools → MetaQuotes Language Editor`
3. **Compile EA**: 
   - Navigate to `Shared Projects → EXNESS_GenX_Trading → EXPERTS → EXNESS_GenX_Trader.mq5`
   - Press `F7` to compile
4. **Attach EA to Chart**:
   - Open a chart (recommended: EURUSD M15 or H1)
   - Press `Ctrl+N` to open Navigator
   - Drag `EXNESS_GenX_Trader` onto the chart
5. **Enable AutoTrading**: Click the green AutoTrading button in the toolbar

## Troubleshooting

### Terminal Won't Start
- Verify the path: `E:\Program Files\MetaTrader 5 EXNESS\terminal64.exe`
- Check if another instance is already running
- Run as Administrator if permission issues occur

### Connection Issues
- Verify account credentials are correct
- Check internet connection
- Ensure Exness server is accessible

### Environment Variables Not Set
- Run the startup script from the project directory
- Manually set variables if needed:
  ```batch
  set GITHUB_TOKEN={{GITHUB_TOKEN}}
  set MQL5_CLIENT_ID={{MQL5_CLIENT_ID}}
  set MQL5_CLIENT_SECRET={{MQL5_CLIENT_SECRET}}
  set MQL5_REDIRECT_URI=http://127.0.0.1:50729/
  ```

## Security Notes

⚠️ **Important**: 
- Never commit `project_config.env` to version control
- Keep credentials secure and private
- The `.gitignore` file is configured to exclude sensitive files

