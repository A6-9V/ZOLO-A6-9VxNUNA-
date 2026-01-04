# SSL Certificate Deployment Guide for MQL5 VPS

Complete guide for deploying SSL certificates to MQL5 VPS Jakarta 01 (ID: 675930) for secure web hosting.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Certificate Preparation](#certificate-preparation)
3. [VPS Configuration](#vps-configuration)
4. [Web Server Setup](#web-server-setup)
5. [Certificate Installation](#certificate-installation)
6. [Verification & Testing](#verification--testing)
7. [Troubleshooting](#troubleshooting)
8. [Maintenance](#maintenance)

## Prerequisites

### Required Items

✅ **Certificate Files**
- Server certificate (certificate.pem)
- Intermediate certificates (chain.pem)
- Private key (private.key)
- Full chain (fullchain.pem) - optional but recommended

✅ **VPS Access**
- MQL5 VPS ID: 675930
- RDP/SSH access credentials
- Administrator privileges

✅ **Software Requirements**
- Windows Server 2016+ or Windows 10/11
- IIS 10+ or Nginx 1.18+
- OpenSSL (for certificate conversion)
- PowerShell 5.1+

### VPS Specifications

| Item | Details |
|------|---------|
| **VPS ID** | 675930 |
| **Location** | MQL5 VPS Jakarta 01 |
| **OS** | Windows Server (or Windows 10/11) |
| **Purpose** | Web hosting for ZOLO-A6-9VxNUNA |

## Certificate Preparation

### Step 1: Obtain Certificate Files

From the certificate provider (DigiCert), download:

1. **Server Certificate** - Your domain certificate
2. **Intermediate Certificate** - DigiCert SHA2 Extended Validation Server CA
3. **Root Certificate** - DigiCert High Assurance EV Root CA
4. **Private Key** - Generated during CSR creation

### Step 2: Convert to PEM Format

If certificates are in other formats, convert to PEM:

```powershell
# Convert DER to PEM
openssl x509 -inform der -in certificate.der -out certificate.pem

# Convert P7B to PEM
openssl pkcs7 -print_certs -in certificate.p7b -out certificate.pem

# Create full chain
cat certificate.pem intermediate.pem root.pem > fullchain.pem
```

### Step 3: Verify Certificate Files

Verify certificate integrity:

```powershell
# Check certificate details
openssl x509 -in certificate.pem -text -noout

# Verify certificate chain
openssl verify -CAfile chain.pem certificate.pem

# Check private key
openssl rsa -in private.key -check

# Verify certificate matches private key
openssl x509 -noout -modulus -in certificate.pem | openssl md5
openssl rsa -noout -modulus -in private.key | openssl md5
# Both should output the same hash
```

### Step 4: Create PKCS#12 Format (for Windows)

Windows IIS prefers PKCS#12 (.pfx) format:

```powershell
# Create PFX file (you'll be prompted for password)
openssl pkcs12 -export -out certificate.pfx `
    -inkey private.key `
    -in certificate.pem `
    -certfile chain.pem `
    -name "ZOLO-A6-9VxNUNA SSL Certificate"

# Verify PFX file
openssl pkcs12 -info -in certificate.pfx
```

**⚠️ Important**: Choose a strong password and store it securely!

## VPS Configuration

### Step 1: Connect to VPS

```powershell
# Using RDP
mstsc /v:vps-jakarta-01.mql5.com:3389

# Or using PowerShell remoting
Enter-PSSession -ComputerName vps-jakarta-01.mql5.com -Credential $cred
```

### Step 2: Prepare VPS Environment

```powershell
# Create certificate directory
New-Item -Path "C:\SSL" -ItemType Directory -Force

# Set secure permissions
$acl = Get-Acl "C:\SSL"
$acl.SetAccessRuleProtection($true, $false)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
)
$acl.AddAccessRule($rule)
Set-Acl "C:\SSL" $acl
```

### Step 3: Transfer Certificate Files

```powershell
# Using RDP - Copy files via clipboard or shared folder

# Or using PowerShell copy
Copy-Item -Path ".\certificate.pfx" -Destination "C:\SSL\" -ToSession $session

# Or using SCP (if SSH is enabled)
scp certificate.pfx user@vps-jakarta-01.mql5.com:C:\SSL\
```

## Web Server Setup

### Option A: IIS (Internet Information Services)

#### Install IIS

```powershell
# Install IIS with management tools
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Install additional features
Install-WindowsFeature -Name Web-Security, Web-Filtering, Web-Cert-Auth
```

#### Create Website

```powershell
# Import IIS module
Import-Module WebAdministration

# Create website directory
New-Item -Path "C:\inetpub\zolo-trading" -ItemType Directory -Force

# Copy website files
Copy-Item -Path ".\index.html" -Destination "C:\inetpub\zolo-trading\" -Recurse

# Create IIS website
New-IISSite -Name "ZOLO-Trading" `
    -PhysicalPath "C:\inetpub\zolo-trading" `
    -BindingInformation "*:80:"
```

### Option B: Nginx

#### Install Nginx

```powershell
# Download Nginx for Windows
Invoke-WebRequest -Uri "http://nginx.org/download/nginx-1.24.0.zip" `
    -OutFile "C:\Temp\nginx.zip"

# Extract
Expand-Archive -Path "C:\Temp\nginx.zip" -DestinationPath "C:\nginx"

# Create directories
New-Item -Path "C:\nginx\ssl" -ItemType Directory -Force
New-Item -Path "C:\nginx\html" -ItemType Directory -Force
```

#### Configure Nginx

Create `C:\nginx\conf\nginx.conf`:

```nginx
worker_processes 2;

events {
    worker_connections 1024;
}

http {
    include mime.types;
    default_type application/octet-stream;
    
    sendfile on;
    keepalive_timeout 65;
    
    # HTTP Server - Redirect to HTTPS
    server {
        listen 80;
        server_name yourdomain.com;
        return 301 https://$server_name$request_uri;
    }
    
    # HTTPS Server
    server {
        listen 443 ssl http2;
        server_name yourdomain.com;
        
        # SSL Configuration
        ssl_certificate C:/SSL/fullchain.pem;
        ssl_certificate_key C:/SSL/private.key;
        
        # SSL Security Settings
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers on;
        
        # OCSP Stapling
        ssl_stapling on;
        ssl_stapling_verify on;
        ssl_trusted_certificate C:/SSL/chain.pem;
        
        # Security Headers
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
        
        # Website root
        root C:/nginx/html;
        index index.html;
        
        location / {
            try_files $uri $uri/ =404;
        }
        
        # Python backend proxy (if needed)
        location /api {
            proxy_pass http://127.0.0.1:8000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
```

## Certificate Installation

### Method 1: Using PowerShell Script

```powershell
# Run the installation script
.\scripts\install-ssl-certificate.ps1 -CertPath "C:\SSL\certificate.pfx" -Password "YourPassword"
```

### Method 2: Manual Installation (IIS)

```powershell
# Import PFX to certificate store
$pwd = ConvertTo-SecureString -String "YourPassword" -Force -AsPlainText
$cert = Import-PfxCertificate -FilePath "C:\SSL\certificate.pfx" `
    -CertStoreLocation Cert:\LocalMachine\My `
    -Password $pwd

# Get certificate thumbprint
$thumbprint = $cert.Thumbprint
Write-Host "Certificate Thumbprint: $thumbprint"

# Bind certificate to IIS website
Import-Module WebAdministration
New-WebBinding -Name "ZOLO-Trading" `
    -Protocol "https" `
    -Port 443 `
    -IPAddress "*"

$binding = Get-WebBinding -Name "ZOLO-Trading" -Protocol "https"
$binding.AddSslCertificate($thumbprint, "My")
```

### Method 3: Manual Installation (Nginx)

```powershell
# Copy certificate files to Nginx directory
Copy-Item -Path "certificate.pem" -Destination "C:\nginx\ssl\fullchain.pem"
Copy-Item -Path "private.key" -Destination "C:\nginx\ssl\private.key"
Copy-Item -Path "chain.pem" -Destination "C:\nginx\ssl\chain.pem"

# Set file permissions (restrict to SYSTEM and Administrators)
icacls "C:\nginx\ssl\private.key" /inheritance:r
icacls "C:\nginx\ssl\private.key" /grant:r "SYSTEM:(R)"
icacls "C:\nginx\ssl\private.key" /grant:r "Administrators:(R)"

# Test Nginx configuration
C:\nginx\nginx.exe -t

# Start Nginx
Start-Process -FilePath "C:\nginx\nginx.exe" -WorkingDirectory "C:\nginx"
```

## Verification & Testing

### Test Certificate Installation

```powershell
# Test local HTTPS connection
Invoke-WebRequest -Uri "https://localhost" -UseBasicParsing

# Check certificate binding (IIS)
Get-WebBinding -Name "ZOLO-Trading" -Protocol "https"

# View installed certificate
Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {
    $_.Subject -like "*stripecdn.com*"
}
```

### Online SSL Testing

1. **SSL Labs Test**
   - Visit: https://www.ssllabs.com/ssltest/
   - Enter your domain
   - Wait for analysis (5-10 minutes)
   - Aim for A+ rating

2. **Certificate Checker**
   - Visit: https://www.digicert.com/help/
   - Use DigiCert's certificate checker
   - Verify certificate chain

3. **Browser Testing**
   - Open Chrome/Firefox
   - Navigate to https://yourdomain.com
   - Check for green padlock
   - View certificate details
   - Verify no warnings

### Command Line Testing

```powershell
# Test SSL/TLS connection
openssl s_client -connect yourdomain.com:443 -showcerts

# Check certificate expiry
openssl s_client -connect yourdomain.com:443 | openssl x509 -noout -dates

# Test specific TLS version
openssl s_client -connect yourdomain.com:443 -tls1_2
```

## Troubleshooting

### Certificate Not Trusted

**Problem**: Browser shows "Not Secure" or certificate warning

**Solutions**:
```powershell
# Verify certificate chain is complete
openssl s_client -connect yourdomain.com:443 -showcerts

# Install intermediate certificates
certutil -addstore -f "CA" intermediate.pem

# Verify certificate store
Get-ChildItem -Path Cert:\LocalMachine\CA
```

### Port 443 Not Responding

**Problem**: Cannot connect on HTTPS port

**Solutions**:
```powershell
# Check if port is listening
netstat -ano | findstr ":443"

# Test firewall
Test-NetConnection -ComputerName localhost -Port 443

# Add firewall rule
New-NetFirewallRule -DisplayName "HTTPS Inbound" `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 443 `
    -Action Allow
```

### Private Key Mismatch

**Problem**: Certificate doesn't match private key

**Solutions**:
```powershell
# Check certificate modulus
openssl x509 -noout -modulus -in certificate.pem | openssl md5

# Check private key modulus
openssl rsa -noout -modulus -in private.key | openssl md5

# Both should match - if not, obtain correct key
```

### IIS Binding Issues

**Problem**: Certificate binding fails in IIS

**Solutions**:
```powershell
# Remove existing binding
Remove-WebBinding -Name "ZOLO-Trading" -Protocol "https"

# Re-import certificate
Remove-Item -Path "Cert:\LocalMachine\My\$thumbprint"
Import-PfxCertificate -FilePath "certificate.pfx" -CertStoreLocation Cert:\LocalMachine\My

# Recreate binding
New-WebBinding -Name "ZOLO-Trading" -Protocol "https" -Port 443
```

### Performance Issues

**Problem**: Slow HTTPS connections

**Solutions**:
```nginx
# Enable OCSP Stapling (Nginx)
ssl_stapling on;
ssl_stapling_verify on;

# Optimize SSL session cache
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 10m;

# Enable HTTP/2
listen 443 ssl http2;
```

## Maintenance

### Certificate Monitoring

```powershell
# Check certificate expiry
$cert = Get-ChildItem -Path Cert:\LocalMachine\My | 
    Where-Object { $_.Subject -like "*stripecdn.com*" }

$daysUntilExpiry = ($cert.NotAfter - (Get-Date)).Days
Write-Host "Certificate expires in $daysUntilExpiry days"

# Set up monitoring task
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "-File C:\Scripts\check-cert-expiry.ps1"
    
$trigger = New-ScheduledTaskTrigger -Daily -At "09:00"

Register-ScheduledTask -TaskName "SSL Certificate Monitor" `
    -Action $action -Trigger $trigger
```

### Renewal Process

**Timeline**:
- **90 days before**: Plan renewal
- **60 days before**: Request new certificate
- **30 days before**: Test new certificate
- **7 days before**: Deploy to production

**Steps**:
1. Generate new CSR (Certificate Signing Request)
2. Submit to DigiCert
3. Complete domain validation
4. Download new certificate
5. Test in staging environment
6. Deploy to production
7. Verify deployment
8. Remove old certificate

### Backup Procedures

```powershell
# Backup certificate
Export-PfxCertificate -Cert $cert `
    -FilePath "C:\Backups\cert-backup-$(Get-Date -Format 'yyyyMMdd').pfx" `
    -Password $pwd

# Backup IIS configuration
C:\Windows\System32\inetsrv\appcmd.exe add backup "Before-SSL-$(Get-Date -Format 'yyyyMMdd')"

# Backup Nginx configuration
Copy-Item "C:\nginx\conf\nginx.conf" `
    -Destination "C:\Backups\nginx.conf.$(Get-Date -Format 'yyyyMMdd')"
```

### Security Updates

```powershell
# Update TLS protocols
# Edit registry or use IIS Crypto tool
# Disable: TLS 1.0, TLS 1.1, SSL 3.0
# Enable: TLS 1.2, TLS 1.3

# Update cipher suites
# Use Mozilla SSL Configuration Generator
# https://ssl-config.mozilla.org/
```

## Automation Scripts

### Daily Health Check

Create `check-ssl-health.ps1`:

```powershell
$ErrorActionPreference = "Continue"
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Check certificate expiry
$cert = Get-ChildItem -Path Cert:\LocalMachine\My | 
    Where-Object { $_.Subject -like "*stripecdn.com*" }

if ($cert) {
    $daysLeft = ($cert.NotAfter - (Get-Date)).Days
    
    if ($daysLeft -lt 30) {
        Write-Warning "[$date] Certificate expires in $daysLeft days - RENEW SOON!"
        # Send email alert
    } else {
        Write-Host "[$date] Certificate valid for $daysLeft days"
    }
} else {
    Write-Error "[$date] Certificate not found!"
}

# Test HTTPS endpoint
try {
    $response = Invoke-WebRequest -Uri "https://localhost" -UseBasicParsing
    Write-Host "[$date] HTTPS endpoint responding: $($response.StatusCode)"
} catch {
    Write-Error "[$date] HTTPS endpoint error: $_"
}
```

## Additional Resources

- [DigiCert Installation Instructions](https://www.digicert.com/kb/ssl-certificate-installation.htm)
- [IIS SSL Setup Guide](https://docs.microsoft.com/iis/manage/configuring-security/how-to-set-up-ssl-on-iis)
- [Nginx SSL Guide](https://nginx.org/en/docs/http/configuring_https_servers.html)
- [SSL Labs Best Practices](https://github.com/ssllabs/research/wiki/SSL-and-TLS-Deployment-Best-Practices)
- [Mozilla SSL Configuration Generator](https://ssl-config.mozilla.org/)

## Support Contacts

- **DigiCert Support**: https://www.digicert.com/support/
- **MQL5 VPS Support**: https://www.mql5.com/en/vps
- **Project Issues**: Create issue in GitHub repository

---

**Document Version**: 1.0  
**Last Updated**: 2026-01-04  
**VPS ID**: 675930  
**Certificate Expiry**: February 19, 2026
