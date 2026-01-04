# Web Server Configuration Script for SSL
# Configures IIS or Nginx with optimal SSL settings

<#
.SYNOPSIS
    Configures web server with SSL/TLS best practices

.DESCRIPTION
    Sets up secure web server configuration following industry best practices
    for SSL/TLS, including security headers, cipher suites, and HTTPS enforcement

.PARAMETER WebServer
    Web server to configure: "IIS" or "Nginx"

.PARAMETER SiteName
    Name of the website (for IIS)

.PARAMETER EnableHSTS
    Enable HTTP Strict Transport Security (default: true)

.EXAMPLE
    .\configure-webserver.ps1 -WebServer "IIS" -SiteName "ZOLO-Trading"
#>

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("IIS", "Nginx")]
    [string]$WebServer,
    
    [Parameter(Mandatory=$false)]
    [string]$SiteName = "ZOLO-Trading",
    
    [Parameter(Mandatory=$false)]
    [bool]$EnableHSTS = $true,
    
    [Parameter(Mandatory=$false)]
    [bool]$RedirectHTTP = $true
)

$ErrorActionPreference = "Stop"

function Write-StatusOK { param($msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-StatusInfo { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-StatusWarning { param($msg) Write-Host "[WARNING] $msg" -ForegroundColor Yellow }
function Write-StatusError { param($msg) Write-Host "[ERROR] $msg" -ForegroundColor Red }

Write-Host "`n=== Web Server Configuration for SSL ===" -ForegroundColor Cyan
Write-Host "Web Server: $WebServer" -ForegroundColor Cyan
Write-Host "Site Name: $SiteName`n" -ForegroundColor Cyan

# Check administrator privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-StatusError "This script must be run as Administrator!"
    exit 1
}

if ($WebServer -eq "IIS") {
    Write-StatusInfo "Configuring IIS with SSL best practices..."
    
    try {
        Import-Module WebAdministration -ErrorAction Stop
        
        # Verify site exists
        $site = Get-Website -Name $SiteName -ErrorAction SilentlyContinue
        if (-not $site) {
            Write-StatusError "Website '$SiteName' not found. Run install-ssl-certificate.ps1 first."
            exit 1
        }
        
        Write-StatusOK "Website found: $SiteName"
        
        # Configure security headers
        Write-StatusInfo "Configuring security headers..."
        
        $headers = @(
            @{name='Strict-Transport-Security'; value='max-age=31536000; includeSubDomains; preload'},
            @{name='X-Frame-Options'; value='SAMEORIGIN'},
            @{name='X-Content-Type-Options'; value='nosniff'},
            @{name='X-XSS-Protection'; value='1; mode=block'},
            @{name='Referrer-Policy'; value='strict-origin-when-cross-origin'},
            @{name='Permissions-Policy'; value='geolocation=(), microphone=(), camera=()'}
        )
        
        foreach ($header in $headers) {
            try {
                # Remove existing header if present
                Remove-WebConfigurationProperty -PSPath "IIS:\Sites\$SiteName" `
                    -Filter "system.webServer/httpProtocol/customHeaders" `
                    -Name "." `
                    -AtElement @{name=$header.name} `
                    -ErrorAction SilentlyContinue
                
                # Add header
                Add-WebConfigurationProperty -PSPath "IIS:\Sites\$SiteName" `
                    -Filter "system.webServer/httpProtocol/customHeaders" `
                    -Name "." `
                    -Value $header
                
                Write-StatusOK "Added header: $($header.name)"
            } catch {
                Write-StatusWarning "Could not add header $($header.name): $_"
            }
        }
        
        # Configure HTTP to HTTPS redirect
        if ($RedirectHTTP) {
            Write-StatusInfo "Configuring HTTP to HTTPS redirect..."
            
            # Install URL Rewrite if needed
            $rewriteInstalled = Get-WindowsFeature -Name Web-Http-Redirect -ErrorAction SilentlyContinue
            if ($rewriteInstalled -and $rewriteInstalled.Installed) {
                try {
                    # Create web.config with redirect rule
                    $webConfig = @"
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <system.webServer>
        <rewrite>
            <rules>
                <rule name="HTTP to HTTPS redirect" stopProcessing="true">
                    <match url="(.*)" />
                    <conditions>
                        <add input="{HTTPS}" pattern="off" />
                    </conditions>
                    <action type="Redirect" url="https://{HTTP_HOST}/{R:1}" redirectType="Permanent" />
                </rule>
            </rules>
        </rewrite>
        <httpProtocol>
            <customHeaders>
                <add name="Strict-Transport-Security" value="max-age=31536000; includeSubDomains; preload" />
                <add name="X-Frame-Options" value="SAMEORIGIN" />
                <add name="X-Content-Type-Options" value="nosniff" />
                <add name="X-XSS-Protection" value="1; mode=block" />
                <add name="Referrer-Policy" value="strict-origin-when-cross-origin" />
            </customHeaders>
        </httpProtocol>
    </system.webServer>
</configuration>
"@
                    $webConfigPath = "$($site.PhysicalPath)\web.config"
                    $webConfig | Out-File -FilePath $webConfigPath -Encoding UTF8
                    Write-StatusOK "HTTP to HTTPS redirect configured"
                } catch {
                    Write-StatusWarning "Could not configure redirect: $_"
                }
            } else {
                Write-StatusWarning "URL Rewrite module not installed - HTTP redirect not configured"
                Write-Host "   To install: Install-WindowsFeature -Name Web-Http-Redirect" -ForegroundColor Gray
            }
        }
        
        # Disable weak protocols and ciphers (Registry)
        Write-StatusInfo "Configuring TLS protocols..."
        
        # Disable SSL 2.0, SSL 3.0, TLS 1.0, TLS 1.1
        $protocolsToDisable = @("SSL 2.0", "SSL 3.0", "TLS 1.0", "TLS 1.1")
        foreach ($protocol in $protocolsToDisable) {
            $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Server"
            if (-not (Test-Path $regPath)) {
                New-Item -Path $regPath -Force | Out-Null
            }
            Set-ItemProperty -Path $regPath -Name "Enabled" -Value 0 -Type DWord
            Set-ItemProperty -Path $regPath -Name "DisabledByDefault" -Value 1 -Type DWord
        }
        Write-StatusOK "Disabled weak protocols (SSL 2.0, 3.0, TLS 1.0, 1.1)"
        
        # Enable TLS 1.2 and TLS 1.3
        $protocolsToEnable = @("TLS 1.2", "TLS 1.3")
        foreach ($protocol in $protocolsToEnable) {
            $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Server"
            if (-not (Test-Path $regPath)) {
                New-Item -Path $regPath -Force | Out-Null
            }
            Set-ItemProperty -Path $regPath -Name "Enabled" -Value 1 -Type DWord
            Set-ItemProperty -Path $regPath -Name "DisabledByDefault" -Value 0 -Type DWord
        }
        Write-StatusOK "Enabled strong protocols (TLS 1.2, 1.3)"
        
        Write-StatusWarning "IIS must be restarted for TLS changes to take effect"
        
        # Configure compression
        Write-StatusInfo "Configuring compression..."
        Set-WebConfigurationProperty -PSPath "MACHINE/WEBROOT/APPHOST" `
            -Filter "system.webServer/httpCompression" `
            -Name "staticCompressionEnableCpuUsage" `
            -Value 90 `
            -ErrorAction SilentlyContinue
        
        Set-WebConfigurationProperty -PSPath "MACHINE/WEBROOT/APPHOST" `
            -Filter "system.webServer/httpCompression" `
            -Name "dynamicCompressionEnableCpuUsage" `
            -Value 75 `
            -ErrorAction SilentlyContinue
        
        Write-StatusOK "Compression configured"
        
        Write-Host "`n=== IIS Configuration Complete ===" -ForegroundColor Green
        Write-Host "Security headers: Configured" -ForegroundColor Cyan
        Write-Host "HTTP to HTTPS redirect: $RedirectHTTP" -ForegroundColor Cyan
        Write-Host "TLS 1.2/1.3: Enabled" -ForegroundColor Cyan
        Write-Host "Weak protocols: Disabled" -ForegroundColor Cyan
        
        Write-Host "`nRecommended next steps:" -ForegroundColor Yellow
        Write-Host "1. Restart IIS: iisreset" -ForegroundColor Gray
        Write-Host "2. Test with SSL Labs: https://www.ssllabs.com/ssltest/" -ForegroundColor Gray
        Write-Host "3. Verify security headers: https://securityheaders.com/" -ForegroundColor Gray
        
    } catch {
        Write-StatusError "IIS configuration failed: $_"
        exit 1
    }
    
} elseif ($WebServer -eq "Nginx") {
    Write-StatusInfo "Creating Nginx configuration with SSL best practices..."
    
    $nginxPath = "C:\nginx"
    if (-not (Test-Path $nginxPath)) {
        Write-StatusError "Nginx not found at $nginxPath"
        exit 1
    }
    
    $configPath = "$nginxPath\conf\nginx.conf"
    
    # Create optimized Nginx configuration
    $nginxConfig = @"
worker_processes 2;

events {
    worker_connections 1024;
}

http {
    include mime.types;
    default_type application/octet-stream;
    
    # Logging
    access_log logs/access.log;
    error_log logs/error.log;
    
    # Performance
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    
    # Compression
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types text/plain text/css text/xml text/javascript 
               application/json application/javascript application/xml+rss;
    
    # HTTP Server - Redirect to HTTPS
    server {
        listen 80;
        server_name localhost;
        
        # Redirect all HTTP to HTTPS
        return 301 https://`$host`$request_uri;
    }
    
    # HTTPS Server
    server {
        listen 443 ssl http2;
        server_name localhost;
        
        # Website root
        root C:/nginx/html;
        index index.html index.htm;
        
        # SSL Configuration
        ssl_certificate C:/nginx/ssl/certificate.pem;
        ssl_certificate_key C:/nginx/ssl/private.key;
        
        # SSL Protocols - Only TLS 1.2 and 1.3
        ssl_protocols TLSv1.2 TLSv1.3;
        
        # SSL Ciphers - Strong ciphers only
        ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256';
        ssl_prefer_server_ciphers on;
        
        # SSL Session Cache
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 10m;
        ssl_session_tickets off;
        
        # OCSP Stapling
        ssl_stapling on;
        ssl_stapling_verify on;
        ssl_trusted_certificate C:/nginx/ssl/chain.pem;
        resolver 8.8.8.8 8.8.4.4 valid=300s;
        resolver_timeout 5s;
        
        # Security Headers
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Referrer-Policy "strict-origin-when-cross-origin" always;
        add_header Permissions-Policy "geolocation=(), microphone=(), camera=()" always;
        
        # Hide Nginx version
        server_tokens off;
        
        # Main location
        location / {
            try_files `$uri `$uri/ =404;
        }
        
        # Security - Deny access to hidden files
        location ~ /\. {
            deny all;
            access_log off;
            log_not_found off;
        }
        
        # Python backend proxy (if needed)
        location /api {
            proxy_pass http://127.0.0.1:8000;
            proxy_set_header Host `$host;
            proxy_set_header X-Real-IP `$remote_addr;
            proxy_set_header X-Forwarded-For `$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto `$scheme;
        }
    }
}
"@
    
    try {
        # Backup existing config
        if (Test-Path $configPath) {
            $backupPath = "$configPath.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            Copy-Item -Path $configPath -Destination $backupPath
            Write-StatusOK "Backed up existing config to: $backupPath"
        }
        
        # Write new config
        $nginxConfig | Out-File -FilePath $configPath -Encoding UTF8
        Write-StatusOK "Created new Nginx configuration"
        
        # Test configuration
        Write-StatusInfo "Testing Nginx configuration..."
        $testResult = & "$nginxPath\nginx.exe" -t 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-StatusOK "Nginx configuration test passed"
        } else {
            Write-StatusError "Nginx configuration test failed:"
            Write-Host $testResult -ForegroundColor Red
            exit 1
        }
        
        Write-Host "`n=== Nginx Configuration Complete ===" -ForegroundColor Green
        Write-Host "Config file: $configPath" -ForegroundColor Cyan
        Write-Host "Security headers: Configured" -ForegroundColor Cyan
        Write-Host "HTTP to HTTPS redirect: Configured" -ForegroundColor Cyan
        Write-Host "TLS 1.2/1.3: Enabled" -ForegroundColor Cyan
        Write-Host "OCSP Stapling: Enabled" -ForegroundColor Cyan
        
        Write-Host "`nNext steps:" -ForegroundColor Yellow
        Write-Host "1. Verify SSL certificate files are in place:" -ForegroundColor Gray
        Write-Host "   - C:\nginx\ssl\certificate.pem" -ForegroundColor Gray
        Write-Host "   - C:\nginx\ssl\private.key" -ForegroundColor Gray
        Write-Host "   - C:\nginx\ssl\chain.pem" -ForegroundColor Gray
        Write-Host "2. Start Nginx: nginx.exe" -ForegroundColor Gray
        Write-Host "   Or reload: nginx.exe -s reload" -ForegroundColor Gray
        Write-Host "3. Test locally: https://localhost" -ForegroundColor Gray
        Write-Host "4. Test with SSL Labs: https://www.ssllabs.com/ssltest/" -ForegroundColor Gray
        
    } catch {
        Write-StatusError "Nginx configuration failed: $_"
        exit 1
    }
}

Write-Host "`n"
