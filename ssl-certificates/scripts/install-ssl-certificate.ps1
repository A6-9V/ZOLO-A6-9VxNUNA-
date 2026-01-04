# SSL Certificate Installation Script for Windows VPS
# Installs SSL certificate for ZOLO-A6-9VxNUNA web hosting on MQL5 VPS

<#
.SYNOPSIS
    Installs SSL certificate to Windows Certificate Store and configures web server

.DESCRIPTION
    This script automates SSL certificate installation for secure web hosting on VPS.
    Supports both IIS and Nginx web servers.

.PARAMETER CertPath
    Path to the certificate file (.pfx format)

.PARAMETER Password
    Password for the PFX file (optional - will prompt if not provided)

.PARAMETER WebServer
    Web server to configure: "IIS" or "Nginx" (default: IIS)

.PARAMETER SiteName
    Name of the website (default: ZOLO-Trading)

.EXAMPLE
    .\install-ssl-certificate.ps1 -CertPath "C:\SSL\certificate.pfx"
    
.EXAMPLE
    .\install-ssl-certificate.ps1 -CertPath "C:\SSL\certificate.pfx" -WebServer "Nginx"
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$CertPath = "C:\SSL\certificate.pfx",
    
    [Parameter(Mandatory=$false)]
    [SecureString]$Password,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("IIS", "Nginx")]
    [string]$WebServer = "IIS",
    
    [Parameter(Mandatory=$false)]
    [string]$SiteName = "ZOLO-Trading",
    
    [Parameter(Mandatory=$false)]
    [int]$HttpsPort = 443
)

$ErrorActionPreference = "Stop"

# Colors for output
function Write-StatusOK { param($msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-StatusInfo { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-StatusWarning { param($msg) Write-Host "[WARNING] $msg" -ForegroundColor Yellow }
function Write-StatusError { param($msg) Write-Host "[ERROR] $msg" -ForegroundColor Red }

Write-Host "`n=== SSL Certificate Installation for ZOLO-A6-9VxNUNA ===" -ForegroundColor Cyan
Write-Host "VPS ID: 675930 (MQL5 VPS Jakarta 01)" -ForegroundColor Cyan
Write-Host "Web Server: $WebServer" -ForegroundColor Cyan
Write-Host "Certificate: $CertPath`n" -ForegroundColor Cyan

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-StatusError "This script must be run as Administrator!"
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

Write-StatusOK "Running with Administrator privileges"

# Verify certificate file exists
if (-not (Test-Path $CertPath)) {
    Write-StatusError "Certificate file not found: $CertPath"
    Write-Host "Please place your certificate.pfx file in C:\SSL\" -ForegroundColor Yellow
    exit 1
}

Write-StatusOK "Certificate file found: $CertPath"

# Get password if not provided
if (-not $Password) {
    Write-StatusInfo "Please enter the password for the PFX file:"
    $Password = Read-Host "Password" -AsSecureString
}

try {
    # Step 1: Import certificate to Windows Certificate Store
    Write-StatusInfo "Importing certificate to LocalMachine\My store..."
    
    $cert = Import-PfxCertificate -FilePath $CertPath `
        -CertStoreLocation Cert:\LocalMachine\My `
        -Password $Password `
        -Exportable
    
    $thumbprint = $cert.Thumbprint
    Write-StatusOK "Certificate imported successfully"
    Write-Host "   Thumbprint: $thumbprint" -ForegroundColor Gray
    Write-Host "   Subject: $($cert.Subject)" -ForegroundColor Gray
    Write-Host "   Issuer: $($cert.Issuer)" -ForegroundColor Gray
    Write-Host "   Valid From: $($cert.NotBefore)" -ForegroundColor Gray
    Write-Host "   Valid Until: $($cert.NotAfter)" -ForegroundColor Gray
    
    # Check expiry
    $daysUntilExpiry = ($cert.NotAfter - (Get-Date)).Days
    if ($daysUntilExpiry -lt 30) {
        Write-StatusWarning "Certificate expires in $daysUntilExpiry days - plan renewal soon!"
    } else {
        Write-StatusInfo "Certificate valid for $daysUntilExpiry days"
    }
    
    # Step 2: Import intermediate certificates
    Write-StatusInfo "Checking for intermediate certificates..."
    
    $chainPath = "C:\SSL\chain.pem"
    if (Test-Path $chainPath) {
        try {
            Import-Certificate -FilePath $chainPath -CertStoreLocation Cert:\LocalMachine\CA
            Write-StatusOK "Intermediate certificates imported"
        } catch {
            Write-StatusWarning "Could not import intermediate certificates: $_"
        }
    } else {
        Write-StatusInfo "No intermediate certificate file found (chain.pem)"
    }
    
    # Step 3: Configure web server
    if ($WebServer -eq "IIS") {
        Write-StatusInfo "Configuring IIS..."
        
        # Check if IIS is installed
        $iisFeature = Get-WindowsFeature -Name Web-Server -ErrorAction SilentlyContinue
        if (-not $iisFeature -or $iisFeature.InstallState -ne "Installed") {
            Write-StatusWarning "IIS is not installed"
            Write-Host "To install IIS, run:" -ForegroundColor Yellow
            Write-Host "   Install-WindowsFeature -Name Web-Server -IncludeManagementTools" -ForegroundColor Gray
            exit 1
        }
        
        Write-StatusOK "IIS is installed"
        
        # Import WebAdministration module
        Import-Module WebAdministration -ErrorAction SilentlyContinue
        
        # Check if site exists
        $site = Get-Website -Name $SiteName -ErrorAction SilentlyContinue
        if (-not $site) {
            Write-StatusInfo "Creating new IIS website: $SiteName"
            
            $webRoot = "C:\inetpub\$SiteName"
            if (-not (Test-Path $webRoot)) {
                New-Item -Path $webRoot -ItemType Directory -Force | Out-Null
                Write-StatusOK "Created web root: $webRoot"
            }
            
            # Create basic index.html if not exists
            $indexPath = "$webRoot\index.html"
            if (-not (Test-Path $indexPath)) {
                @"
<!DOCTYPE html>
<html>
<head>
    <title>ZOLO-A6-9VxNUNA Trading System</title>
    <meta charset="UTF-8">
</head>
<body>
    <h1>ZOLO-A6-9VxNUNA</h1>
    <p>AI-Powered Trading System - Secure Web Hosting</p>
    <p>SSL Certificate: Active</p>
</body>
</html>
"@ | Out-File -FilePath $indexPath -Encoding UTF8
                Write-StatusOK "Created default index.html"
            }
            
            # Create website
            New-IISSite -Name $SiteName -PhysicalPath $webRoot -BindingInformation "*:80:" | Out-Null
            Write-StatusOK "Created IIS website: $SiteName"
        }
        
        # Remove existing HTTPS binding if exists
        $existingBinding = Get-WebBinding -Name $SiteName -Protocol "https" -ErrorAction SilentlyContinue
        if ($existingBinding) {
            Write-StatusInfo "Removing existing HTTPS binding..."
            Remove-WebBinding -Name $SiteName -Protocol "https" -Port $HttpsPort
        }
        
        # Create new HTTPS binding
        Write-StatusInfo "Creating HTTPS binding on port $HttpsPort..."
        New-WebBinding -Name $SiteName -Protocol "https" -Port $HttpsPort -IPAddress "*" | Out-Null
        
        # Bind SSL certificate
        Write-StatusInfo "Binding SSL certificate to website..."
        $binding = Get-WebBinding -Name $SiteName -Protocol "https"
        $binding.AddSslCertificate($thumbprint, "My")
        
        Write-StatusOK "SSL certificate bound to $SiteName"
        
        # Configure security settings
        Write-StatusInfo "Configuring security settings..."
        
        # Require SSL
        Set-WebConfigurationProperty -PSPath "IIS:\Sites\$SiteName" `
            -Filter "system.webServer/security/access" `
            -Name "sslFlags" `
            -Value "Ssl" `
            -ErrorAction SilentlyContinue
        
        # Add security headers
        Add-WebConfigurationProperty -PSPath "IIS:\Sites\$SiteName" `
            -Filter "system.webServer/httpProtocol/customHeaders" `
            -Name "." `
            -Value @{name='Strict-Transport-Security';value='max-age=31536000; includeSubDomains'} `
            -ErrorAction SilentlyContinue
        
        Write-StatusOK "Security settings configured"
        
        # Start website if not running
        $siteState = (Get-Website -Name $SiteName).State
        if ($siteState -ne "Started") {
            Start-Website -Name $SiteName
            Write-StatusOK "Website started"
        }
        
    } elseif ($WebServer -eq "Nginx") {
        Write-StatusInfo "Configuring Nginx..."
        
        $nginxPath = "C:\nginx"
        if (-not (Test-Path $nginxPath)) {
            Write-StatusWarning "Nginx not found at $nginxPath"
            Write-Host "Please install Nginx first" -ForegroundColor Yellow
            exit 1
        }
        
        Write-StatusOK "Nginx found at $nginxPath"
        
        # Export certificate to PEM format for Nginx
        Write-StatusInfo "Exporting certificate to PEM format for Nginx..."
        
        $certPem = "$nginxPath\ssl\certificate.pem"
        $keyPem = "$nginxPath\ssl\private.key"
        
        # Create SSL directory
        $sslDir = "$nginxPath\ssl"
        if (-not (Test-Path $sslDir)) {
            New-Item -Path $sslDir -ItemType Directory -Force | Out-Null
        }
        
        # Export certificate
        $certContent = [System.Convert]::ToBase64String($cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert), [System.Base64FormattingOptions]::InsertLineBreaks)
        @"
-----BEGIN CERTIFICATE-----
$certContent
-----END CERTIFICATE-----
"@ | Out-File -FilePath $certPem -Encoding ASCII
        
        Write-StatusOK "Certificate exported to: $certPem"
        Write-StatusWarning "You must manually copy the private key to: $keyPem"
        
        # Set secure permissions
        Write-StatusInfo "Setting secure file permissions..."
        icacls $certPem /inheritance:r /grant:r "SYSTEM:(R)" "Administrators:(R)" | Out-Null
        
        Write-StatusOK "Nginx certificate files prepared"
        Write-Host "`nNext steps for Nginx:" -ForegroundColor Yellow
        Write-Host "1. Copy your private key to: $keyPem" -ForegroundColor Gray
        Write-Host "2. Update nginx.conf with SSL settings" -ForegroundColor Gray
        Write-Host "3. Test configuration: nginx.exe -t" -ForegroundColor Gray
        Write-Host "4. Reload Nginx: nginx.exe -s reload" -ForegroundColor Gray
    }
    
    # Step 4: Configure Windows Firewall
    Write-StatusInfo "Configuring Windows Firewall..."
    
    $firewallRule = Get-NetFirewallRule -DisplayName "HTTPS Inbound" -ErrorAction SilentlyContinue
    if (-not $firewallRule) {
        New-NetFirewallRule -DisplayName "HTTPS Inbound" `
            -Direction Inbound `
            -Protocol TCP `
            -LocalPort 443 `
            -Action Allow `
            -Profile Any | Out-Null
        Write-StatusOK "Firewall rule added for HTTPS (port 443)"
    } else {
        Write-StatusInfo "Firewall rule already exists"
    }
    
    # Step 5: Test HTTPS endpoint
    Write-StatusInfo "Testing HTTPS endpoint..."
    Start-Sleep -Seconds 2
    
    try {
        $response = Invoke-WebRequest -Uri "https://localhost:$HttpsPort" -UseBasicParsing -ErrorAction Stop
        Write-StatusOK "HTTPS endpoint responding: $($response.StatusCode)"
    } catch {
        Write-StatusWarning "Could not test HTTPS endpoint (this is normal if external access not configured yet)"
        Write-Host "   Error: $_" -ForegroundColor Gray
    }
    
    # Summary
    Write-Host "`n=== Installation Complete ===" -ForegroundColor Green
    Write-Host "Certificate Thumbprint: $thumbprint" -ForegroundColor Cyan
    Write-Host "Web Server: $WebServer" -ForegroundColor Cyan
    Write-Host "HTTPS Port: $HttpsPort" -ForegroundColor Cyan
    Write-Host "Valid Until: $($cert.NotAfter)" -ForegroundColor Cyan
    Write-Host "Days Remaining: $daysUntilExpiry days" -ForegroundColor Cyan
    
    Write-Host "`nNext Steps:" -ForegroundColor Yellow
    Write-Host "1. Copy your website files to the web root" -ForegroundColor Gray
    
    if ($WebServer -eq "IIS") {
        Write-Host "   Web Root: C:\inetpub\$SiteName" -ForegroundColor Gray
        Write-Host "2. Test locally: https://localhost:$HttpsPort" -ForegroundColor Gray
        Write-Host "3. Configure DNS to point to your VPS" -ForegroundColor Gray
        Write-Host "4. Test externally: https://yourdomain.com" -ForegroundColor Gray
    } else {
        Write-Host "   Web Root: C:\nginx\html" -ForegroundColor Gray
        Write-Host "2. Complete Nginx configuration" -ForegroundColor Gray
        Write-Host "3. Start Nginx service" -ForegroundColor Gray
        Write-Host "4. Configure DNS to point to your VPS" -ForegroundColor Gray
    }
    
    Write-Host "5. Run SSL Labs test: https://www.ssllabs.com/ssltest/" -ForegroundColor Gray
    Write-Host "6. Set up certificate expiry monitoring" -ForegroundColor Gray
    
    Write-Host "`nCertificate will expire on: $($cert.NotAfter.ToString('MMMM dd, yyyy'))" -ForegroundColor Yellow
    Write-Host "Plan renewal at least 30 days before expiry.`n" -ForegroundColor Yellow
    
} catch {
    Write-StatusError "Installation failed: $_"
    Write-Host "Stack Trace:" -ForegroundColor Gray
    Write-Host $_.ScriptStackTrace -ForegroundColor Gray
    exit 1
}
