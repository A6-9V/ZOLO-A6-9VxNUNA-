# VPS Deployment Package

This folder contains tools and instructions for deploying the EXNESS GenX Trader EA to a VPS.

## Quick Start

### Option 1: Automated Deployment (Recommended)

1. **Run the PowerShell script**:
   ```powershell
   .\deploy_to_vps.ps1
   ```
   
   Or use the batch file:
   ```batch
   .\quick_deploy.bat
   ```

2. **Follow the prompts** to enter your VPS details

### Option 2: Manual Deployment

1. **Run the batch file** to create a deployment package:
   ```batch
   .\quick_deploy.bat
   ```

2. **Copy the `deployment_package` folder** to your VPS

3. **Follow the instructions** in `VPS_DEPLOYMENT.md`

## Files in This Package

- `deploy_to_vps.ps1` - PowerShell script for automated deployment
- `quick_deploy.bat` - Batch file for quick deployment package creation
- `VPS_DEPLOYMENT.md` - Complete deployment guide with troubleshooting
- `README.md` - This file

## Prerequisites

- VPS with Windows OS
- MetaTrader 5 installed on VPS
- Remote Desktop access to VPS
- PowerShell 5.0+ (for automated deployment)

## Deployment Package Contents

After running `quick_deploy.bat`, the `deployment_package` folder will contain:

- `EXNESS_GenX_Trader.mq5` - Main Expert Advisor file
- `EXNESS_GenX_Config.mqh` - Configuration file

## Post-Deployment Checklist

- [ ] Files copied to VPS MT5 directories
- [ ] EA compiled successfully in MetaEditor
- [ ] EA attached to chart
- [ ] AutoTrading enabled
- [ ] EA running (smiley face on chart)
- [ ] Logs visible in Experts tab

## Support

For detailed deployment instructions and troubleshooting, see `VPS_DEPLOYMENT.md`.
