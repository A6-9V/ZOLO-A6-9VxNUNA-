# SSL Certificate Setup for VPS Web Hosting

This directory contains SSL certificate configuration and deployment scripts for the ZOLO-A6-9VxNUNA trading system on MQL5 VPS.

## Overview

**VPS Details:**
- **VPS ID**: 675930
- **Location**: MQL5 VPS Jakarta 01
- **Purpose**: Secure web hosting for trading system

**Certificate Details:**
- **Type**: Extended Validation (EV) SSL Certificate
- **Issuer**: DigiCert SHA2 Extended Validation Server CA
- **Subject**: a.stripecdn.com
- **Validity**: November 12, 2025 - February 19, 2026
- **Key Size**: RSA 2048-bit
- **Signature Algorithm**: SHA-256 with RSA Encryption

## Directory Structure

```
ssl-certificates/
├── certs/                          # Certificate files (gitignored for security)
│   ├── certificate.pem             # Server certificate
│   ├── chain.pem                   # Certificate chain
│   ├── fullchain.pem              # Full certificate chain
│   └── private.key                # Private key (NEVER commit!)
├── scripts/                        # Deployment scripts
│   ├── install-ssl-certificate.ps1 # Certificate installation
│   ├── configure-webserver.ps1     # Web server configuration
│   └── deploy-to-vps.ps1          # VPS deployment
├── docs/                           # Documentation
│   ├── CERTIFICATE-INFO.md        # Certificate information
│   └── DEPLOYMENT-GUIDE.md        # Deployment guide
└── README.md                       # This file
```

## Quick Start

### 1. Prepare Certificate Files

Place your certificate files in the `certs/` directory:

```powershell
# Required files:
ssl-certificates/certs/
├── certificate.pem      # Server certificate
├── chain.pem           # Intermediate certificates
└── private.key         # Private key
```

### 2. Install Certificate on Windows VPS

```powershell
# Run as Administrator
.\scripts\install-ssl-certificate.ps1
```

### 3. Configure Web Server

```powershell
# Configure IIS or Nginx with SSL
.\scripts\configure-webserver.ps1 -WebServer "IIS"
```

### 4. Deploy to MQL5 VPS

```powershell
# Deploy to VPS ID: 675930
.\scripts\deploy-to-vps.ps1 -VpsId 675930
```

## Security Notes

⚠️ **IMPORTANT SECURITY INFORMATION:**

1. **Private Key Protection**
   - Private key files are automatically excluded from git
   - Never share or commit private keys
   - Store keys in encrypted form when not in use

2. **Certificate Storage**
   - All certificate files in `certs/` are gitignored
   - Keep backup copies in secure, encrypted storage
   - Use Windows Credential Manager for sensitive data

3. **Access Control**
   - Only administrators should access certificate files
   - Restrict file permissions on VPS
   - Use separate keys for development and production

## Supported Domains

This certificate supports multiple domains (Subject Alternative Names):

- a.stripecdn.com
- b.stripecdn.com
- c.stripecdn.com
- d.stripecdn.com
- f.stripecdn.com
- g.stripecdn.com
- stripecdn.com
- js.stripe.com
- checkout.stripe.com
- stripe.network
- And many more (see Certificate Info for full list)

## Certificate Validation

Verify certificate installation:

```powershell
# Test SSL configuration
Test-Certificate -FilePath "certs\certificate.pem"

# Verify certificate chain
openssl verify -CAfile certs\chain.pem certs\certificate.pem

# Check certificate details
openssl x509 -in certs\certificate.pem -text -noout
```

## Web Server Configuration

### IIS (Internet Information Services)

```powershell
# Import certificate to IIS
Import-PfxCertificate -FilePath cert.pfx -CertStoreLocation Cert:\LocalMachine\My

# Bind to website
New-IISSiteBinding -Name "Default Web Site" -BindingInformation "*:443:" -Protocol https -CertificateThumbprint $thumbprint
```

### Nginx

```nginx
server {
    listen 443 ssl http2;
    server_name yourdomain.com;
    
    ssl_certificate /path/to/fullchain.pem;
    ssl_certificate_key /path/to/private.key;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
}
```

## Renewal Process

Certificate expires: **February 19, 2026**

### Renewal Steps:

1. **60 days before expiry** (December 21, 2025):
   - Request new certificate from DigiCert
   - Prepare for renewal

2. **30 days before expiry** (January 20, 2026):
   - Obtain new certificate
   - Test in staging environment

3. **7 days before expiry** (February 12, 2026):
   - Deploy new certificate
   - Verify all services

## Troubleshooting

### Certificate Not Trusted

```powershell
# Install certificate chain
certutil -addstore -f "Root" chain.pem
```

### Permission Denied

```powershell
# Fix certificate permissions
icacls cert.pfx /grant "NT AUTHORITY\NETWORK SERVICE:R"
```

### Certificate Mismatch

```powershell
# Verify certificate matches private key
openssl x509 -noout -modulus -in certificate.pem | openssl md5
openssl rsa -noout -modulus -in private.key | openssl md5
# Output should match
```

## Additional Resources

- [DigiCert Installation Guide](https://www.digicert.com/kb/ssl-certificate-installation.htm)
- [IIS SSL Configuration](https://docs.microsoft.com/iis/manage/configuring-security/how-to-set-up-ssl-on-iis)
- [Nginx SSL Configuration](https://nginx.org/en/docs/http/configuring_https_servers.html)
- [MQL5 VPS Documentation](https://www.mql5.com/en/vps)

## Support

For issues:
1. Check logs in VPS logs directory
2. Review security settings
3. Verify certificate validity dates
4. Contact VPS support if needed

---

**Created**: 2026-01-04  
**VPS ID**: 675930  
**Certificate Expiry**: February 19, 2026
