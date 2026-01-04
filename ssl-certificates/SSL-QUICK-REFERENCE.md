# SSL Certificate Quick Reference

Fast reference guide for SSL certificate setup on MQL5 VPS Jakarta 01 (ID: 675930).

## Certificate Details

| Item | Value |
|------|-------|
| **VPS ID** | 675930 |
| **Location** | MQL5 VPS Jakarta 01 |
| **Certificate Type** | Extended Validation (EV) SSL |
| **Issuer** | DigiCert SHA2 Extended Validation Server CA |
| **Valid From** | November 12, 2025 |
| **Valid Until** | February 19, 2026 ⚠️ |
| **Days Remaining** | Check with: `(Get-Item Cert:\LocalMachine\My\*).NotAfter` |
| **Key Size** | RSA 2048-bit |
| **Domains** | 44 domains (multi-domain certificate) |

## Quick Setup Commands

### 1. Install Certificate (IIS)

```powershell
# Run as Administrator
.\ssl-certificates\scripts\install-ssl-certificate.ps1 -CertPath "C:\SSL\certificate.pfx" -WebServer "IIS"
```

### 2. Configure Web Server

```powershell
# Run as Administrator
.\ssl-certificates\scripts\configure-webserver.ps1 -WebServer "IIS"
```

### 3. Deploy to VPS

```powershell
# If on VPS
.\ssl-certificates\scripts\deploy-to-vps.ps1 -VpsId 675930
```

### 4. Verify HTTPS

```powershell
# Test locally
Invoke-WebRequest -Uri "https://localhost" -UseBasicParsing

# Check certificate
Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -like "*stripecdn.com*" }
```

## Common Commands

### Check Certificate Expiry

```powershell
$cert = Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -like "*stripecdn.com*" }
Write-Host "Expires: $($cert.NotAfter)"
Write-Host "Days left: $(($cert.NotAfter - (Get-Date)).Days)"
```

### Restart IIS

```powershell
iisreset
```

### Check IIS Status

```powershell
Get-Service W3SVC
Get-Website
```

### Test Port 443

```powershell
Test-NetConnection -ComputerName localhost -Port 443
netstat -ano | findstr ":443"
```

### View Certificate Details

```powershell
$cert = Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -like "*stripecdn.com*" }
$cert | Format-List Subject, Issuer, NotBefore, NotAfter, Thumbprint
```

### Add Firewall Rule

```powershell
New-NetFirewallRule -DisplayName "HTTPS Inbound" -Direction Inbound -Protocol TCP -LocalPort 443 -Action Allow
```

## File Locations

| File | Location |
|------|----------|
| Certificate (PFX) | `C:\SSL\certificate.pfx` |
| Certificate (PEM) | `C:\SSL\certificate.pem` |
| Private Key | `C:\SSL\private.key` |
| Chain | `C:\SSL\chain.pem` |
| IIS Web Root | `C:\inetpub\ZOLO-Trading` |
| Nginx Root | `C:\nginx\html` |
| Scripts | `C:\VPS-Scripts` or `ssl-certificates\scripts` |
| Logs | `C:\Users\USER\OneDrive\vps-logs` |

## Nginx Alternative

### Install Certificate (Nginx)

```powershell
# Copy certificate files
Copy-Item certificate.pem C:\nginx\ssl\
Copy-Item private.key C:\nginx\ssl\
Copy-Item chain.pem C:\nginx\ssl\

# Set permissions
icacls C:\nginx\ssl\private.key /inheritance:r /grant:r "SYSTEM:(R)" "Administrators:(R)"

# Test config
C:\nginx\nginx.exe -t

# Start/reload
C:\nginx\nginx.exe -s reload
```

## Troubleshooting Quick Fixes

### Certificate Not Trusted

```powershell
certutil -addstore -f "CA" C:\SSL\chain.pem
```

### IIS Binding Failed

```powershell
# Remove and recreate
Remove-WebBinding -Name "ZOLO-Trading" -Protocol https
New-WebBinding -Name "ZOLO-Trading" -Protocol https -Port 443
```

### Port 443 Blocked

```powershell
# Check firewall
Get-NetFirewallRule -DisplayName "*HTTPS*"

# Add rule if missing
New-NetFirewallRule -DisplayName "HTTPS Inbound" -Direction Inbound -Protocol TCP -LocalPort 443 -Action Allow
```

### Certificate Private Key Mismatch

```powershell
# Verify modulus match
openssl x509 -noout -modulus -in certificate.pem | openssl md5
openssl rsa -noout -modulus -in private.key | openssl md5
# Both should output same hash
```

## Online Testing Tools

| Tool | URL | Purpose |
|------|-----|---------|
| SSL Labs | https://www.ssllabs.com/ssltest/ | Full SSL/TLS analysis (aim for A+) |
| Security Headers | https://securityheaders.com/ | Check HTTP security headers |
| DigiCert Checker | https://www.digicert.com/help/ | Certificate chain verification |
| SSL Checker | https://www.sslshopper.com/ssl-checker.html | Quick SSL verification |

## Monitoring

### Scheduled Task Created

- **Name**: SSL Certificate Monitor
- **Schedule**: Daily at 09:00
- **Action**: Check certificate expiry
- **Alert**: If < 30 days until expiry

### View Scheduled Task

```powershell
Get-ScheduledTask -TaskName "SSL Certificate Monitor"
```

### Run Monitor Manually

```powershell
C:\VPS-Scripts\monitor-ssl-certificate.ps1
```

## Renewal Timeline

| Days Before Expiry | Action |
|-------------------|--------|
| 90 days | Start planning renewal |
| 60 days | Request new certificate from DigiCert |
| 30 days | Test new certificate in staging |
| 7 days | Deploy to production |
| 0 days | ⚠️ **Certificate expires!** |

**Current Expiry**: February 19, 2026

## Security Best Practices

✅ **Enabled**:
- TLS 1.2 and 1.3 only
- Strong cipher suites
- HSTS (HTTP Strict Transport Security)
- Security headers (X-Frame-Options, etc.)
- HTTP to HTTPS redirect

❌ **Disabled**:
- SSL 2.0, SSL 3.0
- TLS 1.0, TLS 1.1
- Weak ciphers
- Server version disclosure

## Support Resources

- **SSL Documentation**: `ssl-certificates/README.md`
- **Certificate Info**: `ssl-certificates/docs/CERTIFICATE-INFO.md`
- **Deployment Guide**: `ssl-certificates/docs/DEPLOYMENT-GUIDE.md`
- **VPS Guide**: `VPS-SETUP-GUIDE.md` (SSL section)
- **DigiCert Support**: https://www.digicert.com/support/

## Emergency Contacts

- **VPS Issues**: MQL5 VPS Support (https://www.mql5.com/en/vps)
- **Certificate Issues**: DigiCert Support (https://www.digicert.com/support/)
- **Project Issues**: GitHub Repository Issues

---

**Quick Reference Version**: 1.0  
**Last Updated**: 2026-01-04  
**Next Review**: When certificate < 60 days to expiry
