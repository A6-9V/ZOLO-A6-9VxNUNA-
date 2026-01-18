# NUNA Repository & Terminal Access Guide

This guide provides instructions on how to access the NUNA repository and the MetaTrader 5 terminal within the ZOLO-A6-9VxNUNA system.

## 🔗 NUNA Repository

The NUNA project is hosted on MQL5 Forge:
- **Forge URL**: [https://forge.mql5.io/LengKundee/NUNA](https://forge.mql5.io/LengKundee/NUNA)
- **Git URL**: `https://forge.mql5.io/LengKundee/NUNA.git`

### Automated Synchronization

The system is configured to automatically sync with the NUNA repository through the following services:
- **MQL5 Integration Service**: `vps-services/mql5-service.ps1`
- **Exness Trading Service**: `vps-services/exness-service.ps1`

The repository is cloned locally to:
`C:\Users\USER\OneDrive\mql5-repo`

## 🖥️ Terminal Access

### Accessing MetaTrader 5 Terminal

The MetaTrader 5 terminal (Exness) is managed by the `exness-service.ps1` and can be accessed in several ways:

1.  **Manual Access**:
    -   Path: `C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe`
    -   You can open the terminal manually from this location.

2.  **Automated Launch**:
    -   Run the `AUTO-START-VPS.bat` file on the desktop to start all services, including the MT5 terminal.
    -   Use `LAUNCH-FROM-HTML-LOGS.bat` to launch the system and terminal from trade reports.

3.  **Command Line Access**:
    -   The terminal can be started via PowerShell:
        ```powershell
        Start-Process -FilePath "C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe"
        ```

### Terminal Documentation (MQL5 Forge)

To access the official documentation and terminal settings on MQL5 Forge:
1.  Navigate to [https://forge.mql5.io/LengKundee/NUNA#](https://forge.mql5.io/LengKundee/NUNA#)
2.  Click on the "Documentation" or "Wiki" tabs for specific project details.

## 🛠️ System Environment

As of the latest update, the system is optimized for the following environment:
- **Device**: NuNa (Intel i3-N305, 8GB RAM)
- **OS**: Windows 11 Home 25H2
- **Network**: Chrome 143 on Android / IP: 203.147.134.90 (Phnom Penh, Cambodia)

## 🚀 GitHub Actions Integration

The repository now includes a GitHub Actions workflow for automated testing and status reporting.
- **Workflow File**: `.github/workflows/github-actions-demo.yml`
- **Trigger**: Every `push` to the repository.
- **View Results**: Navigate to the "Actions" tab on your GitHub repository page.
