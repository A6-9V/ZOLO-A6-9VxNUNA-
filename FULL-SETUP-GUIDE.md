# Full Setup Guide

## Overview

The **Full Setup** script (`full-setup.ps1`) is the master orchestration script that configures your entire ZOLO-A6-9VxNUNA system in one go. It automatically runs all necessary setup components in the correct order.

## What Gets Configured

The full setup process configures:

### 1. Complete Device Setup ✅
- Windows 11 configuration
- File Explorer preferences
- System optimizations
- Device-specific settings

### 2. Workspace Setup ✅
- Directory structure verification
- OneDrive workspace setup
- Project organization
- Development environment

### 3. Windows Auto Setup ✅
- Windows sync settings
- Default browser configuration
- Default apps
- Automated intelligent configuration

### 4. Cloud Sync Setup ✅
- OneDrive configuration
- Google Drive setup
- Dropbox integration
- Cloud storage optimization

### 5. Git Setup ✅
- Git configuration (user.name, user.email)
- Multiple remote repositories
- GitHub integration
- Credential management

### 6. Security Setup ✅
- Windows Defender exclusions
- Firewall rules for cloud services
- Windows Security configuration
- Token security validation

### 7. EXNESS Trading System Setup ✅
- MetaTrader 5 terminal verification
- Expert Advisor (EA) file deployment
- Terminal launch and configuration
- MetaEditor setup for EA compilation

### 8. VPS Services (Optional) ℹ️
- 24/7 automated trading services
- Background service configuration
- Auto-restart capabilities

## How to Run

### Option 1: Using the BAT Launcher (Recommended for Windows)

1. Navigate to the project root directory
2. Double-click **`RUN-FULL-SETUP.bat`**
3. Click "Yes" when prompted for administrator privileges
4. Follow the on-screen prompts

### Option 2: Using PowerShell

```powershell
# Open PowerShell as Administrator
# Navigate to project directory
cd C:\Users\USER\OneDrive

# Run the full setup script
.\full-setup.ps1
```

### Option 3: From Any Location

```powershell
# Run with explicit execution policy bypass
powershell.exe -ExecutionPolicy Bypass -File "C:\Users\USER\OneDrive\full-setup.ps1"
```

## Prerequisites

- **Operating System**: Windows 11 Home 25H2 or later
- **Privileges**: Administrator rights required
- **PowerShell**: Version 5.1 or higher
- **Internet Connection**: Required for cloud sync and downloads

## Setup Process Flow

```
┌─────────────────────────────────────┐
│   Full Setup Initialization         │
│   - Check admin privileges          │
│   - Verify workspace directory      │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   [1/8] Complete Device Setup       │
│   - Windows configuration           │
│   - System optimizations            │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   [2/8] Workspace Setup             │
│   - Directory structure             │
│   - Project organization            │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   [3/8] Windows Auto Setup          │
│   - Sync settings                   │
│   - Default apps                    │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   [4/8] Cloud Sync Setup            │
│   - OneDrive, Google Drive, Dropbox │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   [5/8] Git Setup                   │
│   - Repository configuration        │
│   - Multiple remotes                │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   [6/8] Security Setup              │
│   - Defender exclusions             │
│   - Firewall rules                  │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   [7/8] EXNESS Trading Setup        │
│   - MT5 terminal                    │
│   - EA deployment                   │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   [8/8] VPS Services (Info)         │
│   - Optional 24/7 trading           │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   Summary Report                    │
│   - Success/Warning/Error counts    │
│   - Execution time                  │
│   - Next steps                      │
└─────────────────────────────────────┘
```

## What to Expect

### During Setup

- **Progress Indicators**: Each step shows `[X/8]` progress
- **Status Messages**: `[OK]`, `[WARNING]`, `[ERROR]`, `[INFO]`
- **Color Coding**:
  - 🟢 Green = Success
  - 🟡 Yellow = Warning/Optional
  - 🔴 Red = Error
  - 🔵 Cyan = Information

### After Setup

The script will display:
- ✅ Setup steps summary with status icons
- ⚠️ Any warnings encountered
- ❌ Any errors that need attention
- 📋 Next steps to complete configuration

## Post-Setup Steps

### 1. Trading System Configuration

```powershell
# Open MetaTrader 5 EXNESS Terminal
# Login with your EXNESS credentials
# Enable AutoTrading (green button)
# Compile EAs: Open EA in MetaEditor → Press F7
# Attach EA to chart: Drag from Navigator
```

### 2. Cloud Services Authentication

- **OneDrive**: Sign in with `Lengkundee01@outlook.com`
- **Google Drive**: Sign in with `Lengkundee01@gmail.com`
- **Dropbox**: Sign in with your Dropbox account

Verify sync status in system tray icons.

### 3. Git Configuration Verification

```powershell
# Check git configuration
git config --list

# Verify remotes
git remote -v

# Test push
git push origin main
```

### 4. Optional: Start VPS Services

For 24/7 automated trading:

```powershell
.\start-vps-system.ps1
```

Or double-click: `START-VPS-SYSTEM.bat`

## Troubleshooting

### Script Not Found Errors

If you see "Script not found" messages:
- Ensure you're running from the correct directory
- Verify all script files are present
- Re-clone the repository if files are missing

### Permission Errors

If you get permission denied errors:
- Make sure you're running as Administrator
- Right-click the BAT file → "Run as administrator"
- Check Windows Security settings

### Cloud Sync Issues

If cloud services don't start:
- Install the cloud service applications
- Sign in manually to each service
- Check Windows Firewall rules

### MetaTrader 5 Not Found

If EXNESS terminal is not detected:
- Download and install MT5 from: https://www.exness.com/
- Install to default location: `C:\Program Files\MetaTrader 5 EXNESS\`
- Re-run the full setup

## Script Behavior

### Error Handling

- **Critical Scripts**: Device setup, Windows auto setup
  - Errors are logged but don't stop the process
- **Optional Scripts**: Workspace, cloud sync, git, security, EXNESS
  - Failures are logged as warnings
  - Setup continues with remaining steps

### Exit Codes

- `0`: Success (all steps completed)
- `1`: Invalid system (not Windows)
- User cancellation: Clean exit

### Logging

All setup steps are tracked internally with status:
- `Success`: Step completed successfully
- `Warning`: Completed with warnings
- `Failed`: Step failed (critical)
- `Skipped`: Optional step skipped
- `NotFound`: Script not found
- `Info`: Informational only

## Advanced Usage

### Skip Confirmation Prompt

```powershell
# Modify the script to auto-confirm
# NOT RECOMMENDED: Always review what will be configured
```

### Run Specific Components Only

Instead of full setup, run individual scripts:

```powershell
# Just Windows configuration
.\complete-device-setup.ps1

# Just EXNESS setup
.\AUTO-SETUP-EXNESS-ALL.ps1

# Just cloud sync
.\setup-cloud-sync.ps1
```

### Re-run After Failure

If setup fails, you can:
1. Fix the issue manually
2. Re-run `.\full-setup.ps1` (idempotent - safe to re-run)
3. Or run only the failed component script

## Performance

- **Typical Duration**: 5-15 minutes
- **Network Required**: Yes (for cloud sync)
- **Reboots Required**: No
- **User Interaction**: Minimal (confirmation prompt at start)

## Security Considerations

- ✅ Runs as Administrator (required for system configuration)
- ✅ All scripts are signed and verified
- ✅ No sensitive data is logged
- ✅ Credentials stored in Windows Credential Manager
- ✅ GitHub tokens never committed to repository

## Related Documentation

- **README.md** - Project overview
- **EXNESS-COMPLETE-SETUP-GUIDE.md** - Detailed trading setup
- **VPS-SETUP-GUIDE.md** - 24/7 automation guide
- **AUTOMATION-RULES.md** - Automation patterns
- **SYSTEM-INFO.md** - System specifications

## Support

For issues or questions:
- Create an issue on GitHub: https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-/issues
- Check existing documentation in the repository
- Review the setup logs for detailed error messages

## Version History

- **v1.0.0** (2025-01-04): Initial full setup orchestration script
  - Complete device setup integration
  - EXNESS trading system automation
  - Cloud sync configuration
  - Git and security setup
  - Comprehensive error handling and reporting

---

**Built with ❤️ by A6-9V Organization**
