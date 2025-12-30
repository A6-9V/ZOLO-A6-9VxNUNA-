# Linux (WSL) Setup Guide

This project is designed to run on Windows to automate a Windows-based trading platform. However, you can use the Windows Subsystem for Linux (WSL) as your development environment.

This guide will walk you through setting up WSL and running this project.

## Prerequisites

- Windows 10 (version 2004 and higher) or Windows 11.

## Step 1: Enable WSL

You need to enable the "Windows Subsystem for Linux" and "Virtual Machine Platform" optional features before installing any Linux distributions on Windows.

1.  Open PowerShell as Administrator.
2.  Run the following command to enable WSL:
    ```powershell
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    ```
3.  Run the following command to enable the Virtual Machine Platform feature:
    ```powershell
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    ```
4.  **Restart your computer** to complete the installation of the requested changes.

## Step 2: Install Ubuntu for WSL

1.  Open the Microsoft Store and search for "Ubuntu".
2.  Install "Ubuntu 24.04.1 LTS". You can also use this link: [Ubuntu 24.04.1 LTS on Microsoft Store](https://apps.microsoft.com/detail/9nz3klhxdjp5?ocid=webpdpshare)
3.  Once the installation is complete, launch Ubuntu from the Start Menu.
4.  The first time you launch it, a console window will open, and you'll be asked to wait for a few minutes for the files to de-compress and be stored on your machine.
5.  You will then be prompted to create a user account and password for your new Linux distribution. This user account is specific to this Linux environment and is not related to your Windows user account.

## Step 3: Clone the Repository

**Important:** You should run the project setup from Windows, not from within the WSL environment.

1.  Open a **Windows PowerShell** terminal (not the Ubuntu terminal).
2.  Navigate to the directory where you want to store the project on your Windows file system. For example:
    ```powershell
    cd C:\Users\YourUsername\Documents
    ```
3.  Clone the repository:
    ```powershell
    git clone https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git
    cd ZOLO-A6-9VxNUNA-
    ```

## Step 4: Run the Setup

From the same **Windows PowerShell** terminal, run the master launch script:

```powershell
.\start.ps1
```

This will initiate the complete setup and launch process on your Windows machine. You can use your WSL terminal for any development work or other tasks, but the core trading system runs on Windows.
