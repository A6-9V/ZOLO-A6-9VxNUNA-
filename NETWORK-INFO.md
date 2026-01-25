# Network Configuration Information

This document records the specific network configuration for the "LengA6-9V" WiFi connection.

## WiFi Connection Details

- **SSID**: LengA6-9V
- **Protocol**: Wi-Fi 4 (802.11n)
- **Security Type**: WPA2-Personal
- **Network Band**: 2.4 GHz (Channel 1)
- **Link Speed**: 150/150 Mbps (Receive/Transmit)

## Adapter Information

- **Manufacturer**: Realtek Semiconductor Corp.
- **Description**: Realtek RTL8188EU Wireless LAN 802.11n USB 2.0 Network Adapter
- **Driver Version**: 1030.52.731.2025
- **Physical Address (MAC)**: 78:20:51:54:60:5C

## Network Settings

### IPv4 Configuration
- **IPv4 Address**: 192.168.18.6
- **Default Gateway**: 192.168.18.1
- **DNS Servers**:
  - 8.8.8.8 (Google)
  - 1.1.1.1 (Cloudflare)

### IPv6 Configuration
- **Link-local Address**: fe80::417b:4f29:7fd:caaa%12
- **DNS Servers**:
  - 2001:4860:4860::8888
  - 2606:4700:4700::1111

## Setup Instructions

To configure this WiFi connection on a new device or after a reset:

1.  Navigate to the `network-setup/` directory.
2.  Run the `setup-wifi.ps1` script as Administrator.
3.  Enter the WiFi password when prompted.

Alternatively, you can manually import the profile:
`netsh wlan add profile filename="network-setup\LengA6-9V.xml"`

Note: The `LengA6-9V.xml` file contains a placeholder for the password. You must edit it or use the script which handles the password insertion securely.
