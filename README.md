# MQL5 Account Setup for EXNESS

This repository contains scripts to help you set up and connect your MQL5 account to the EXNESS MetaTrader 5 terminal on a Windows VPS.

## Quick Start

The primary setup is handled by a PowerShell script that guides you through the process.

### Prerequisites

- You must be on a **Windows VPS** with the **EXNESS MetaTrader 5 terminal** installed.
- The terminal must be installed at the default location: `C:\Program Files\MetaTrader 5 EXNESS\terminal64.exe`.

### Instructions

1.  **Open PowerShell**:
    -   On your Windows VPS, open the Start Menu and type `PowerShell`.
    -   Select "Windows PowerShell" to open a terminal window.

2.  **Navigate to the Repository Directory**:
    -   In the PowerShell window, use the `cd` command to navigate to the directory where you have cloned this repository. For example:
        ```powershell
        cd C:\Users\YourUser\Documents\mql5-automation
        ```

3.  **Run the Setup Script**:
    -   Execute the setup script by running the following command:
        ```powershell
        .\Scripts\setup-exness-complete.ps1
        ```

4.  **Follow the On-Screen Instructions**:
    -   The script will first ask for your **MetaTrader 5 Account Number**.
    -   After you provide it, the script will configure the necessary files and then display a set of **manual instructions**.
    -   Follow these instructions carefully inside the **EXNESS MetaTrader 5 terminal** to log in to your trading account and connect your MQL5 community account.

5.  **Verify the Connection**:
    -   The final step in the instructions is to run the `AccountSetup_411534497` script inside the MT5 terminal to confirm that your account is successfully connected.

---

**MQL5 Profile**: [LengKundee](https://www.mql5.com/en/users/LengKundee)
