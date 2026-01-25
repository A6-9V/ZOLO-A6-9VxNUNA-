# Network Setup Tools

This directory contains tools and configuration files for setting up the "LengA6-9V" WiFi connection.

## Files

- **`LengA6-9V.xml`**: The WiFi profile configuration file for Windows.
  - Contains SSID, security type (WPA2-Personal), and encryption settings.
  - **Important**: The password field is set to `PUT_PASSWORD_HERE`. You must either edit this file or use the setup script.
- **`setup-wifi.ps1`**: A PowerShell script to automate the setup process.

## Usage

### Using the PowerShell Script (Recommended)

1.  Open PowerShell as Administrator.
2.  Navigate to this directory.
3.  Run the script:
    ```powershell
    .\setup-wifi.ps1
    ```
4.  The script will prompt you for the WiFi password securely.
5.  It will create a temporary profile with the password, add it to Windows, connect to the network, and then clean up the temporary file.

### Manual Setup

1.  Open `LengA6-9V.xml` in a text editor (Notepad, VS Code, etc.).
2.  Find the line `<keyMaterial>PUT_PASSWORD_HERE</keyMaterial>`.
3.  Replace `PUT_PASSWORD_HERE` with your actual WiFi password.
4.  Save the file.
5.  Open Command Prompt or PowerShell as Administrator.
6.  Run:
    ```cmd
    netsh wlan add profile filename="LengA6-9V.xml"
    netsh wlan connect name="LengA6-9V"
    ```

## Google Drive Setup

If you need to setup these files in the Google Drive link provided (`https://drive.google.com/drive/folders/1hD4r0680IgBqgQMACMvgap3x8ZhfIuXD`):

1.  Download or copy `LengA6-9V.xml` and `setup-wifi.ps1` from this directory.
2.  Upload them to the Google Drive folder.
3.  You can also save the `NETWORK-INFO.md` file (located in the root of the repo) to the Drive for reference.
