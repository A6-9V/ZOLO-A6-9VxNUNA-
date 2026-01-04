# Deploy SSL Certificate to MQL5 VPS
# Automated deployment script for VPS Jakarta 01 (ID: 675930)

<#
.SYNOPSIS
    Deploys SSL certificate and website to MQL5 VPS

.DESCRIPTION
    Automates the deployment of SSL certificates and web hosting configuration
    to MQL5 VPS Jakarta 01 (ID: 675930)

.PARAMETER VpsId
    MQL5 VPS subscription ID (default: 675930)

.PARAMETER WebServer
    Web server to use: "IIS" or "Nginx" (default: IIS)

.EXAMPLE
    .\deploy-to-vps.ps1 -VpsId 675930
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$VpsId = "675930",
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("IIS", "Nginx")]
    [string]$WebServer = "IIS",
    
    [Parameter(Mandatory=$false)]
    [string]$VpsHostname = "",
    
    [Parameter(Mandatory=$false)]
    [PSCredential]$Credential
)

$ErrorActionPreference = "Stop"

function Write-StatusOK { param($msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-StatusInfo { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-StatusWarning { param($msg) Write-Host "[WARNING] $msg" -ForegroundColor Yellow }
function Write-StatusError { param($msg) Write-Host "[ERROR] $msg" -ForegroundColor Red }

Write-Host "`n=== SSL Certificate Deployment to MQL5 VPS ===" -ForegroundColor Cyan
Write-Host "VPS ID: $VpsId" -ForegroundColor Cyan
Write-Host "Location: Jakarta 01" -ForegroundColor Cyan
Write-Host "Web Server: $WebServer`n" -ForegroundColor Cyan

# Check if we're already on the VPS
$isVps = $false
try {
    $vpsConfig = Get-Content "C:\vps-config.txt" -ErrorAction SilentlyContinue
    if ($vpsConfig -match "VPS_SUBSCRIPTION_ID=$VpsId") {
        $isVps = $true
        Write-StatusOK "Running on target VPS (ID: $VpsId)"
    }
} catch {
    # Not on VPS
}

if ($isVps) {
    # We're on the VPS - run installation locally
    Write-StatusInfo "Executing local installation..."
    
    # Copy scripts to VPS scripts directory
    $scriptDir = "C:\VPS-Scripts"
    if (-not (Test-Path $scriptDir)) {
        New-Item -Path $scriptDir -ItemType Directory -Force | Out-Null
        Write-StatusOK "Created scripts directory: $scriptDir"
    }
    
    # Copy SSL scripts
    $sourceDir = $PSScriptRoot
    Copy-Item -Path "$sourceDir\install-ssl-certificate.ps1" -Destination $scriptDir -Force
    Copy-Item -Path "$sourceDir\configure-webserver.ps1" -Destination $scriptDir -Force
    Write-StatusOK "Copied scripts to VPS"
    
    # Run installation
    Write-StatusInfo "Installing SSL certificate..."
    & "$scriptDir\install-ssl-certificate.ps1" -WebServer $WebServer
    
    Write-StatusInfo "Configuring web server..."
    & "$scriptDir\configure-webserver.ps1" -WebServer $WebServer
    
    # Copy website files
    Write-StatusInfo "Deploying website files..."
    $webRoot = if ($WebServer -eq "IIS") { "C:\inetpub\ZOLO-Trading" } else { "C:\nginx\html" }
    
    $repoPath = "C:\Users\USER\OneDrive\ZOLO-A6-9VxNUNA"
    if (Test-Path $repoPath) {
        $filesToCopy = @("index.html", "css", "js", "assets")
        foreach ($file in $filesToCopy) {
            $source = Join-Path $repoPath $file
            if (Test-Path $source) {
                Copy-Item -Path $source -Destination $webRoot -Recurse -Force
                Write-StatusOK "Copied: $file"
            }
        }
    } else {
        Write-StatusWarning "Repository not found at: $repoPath"
    }
    
    # Create SSL monitoring task
    Write-StatusInfo "Setting up SSL certificate monitoring..."
    
    $monitorScript = @"
# SSL Certificate Expiry Monitor
`$cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { `$_.Subject -like "*stripecdn.com*" }
if (`$cert) {
    `$daysLeft = (`$cert.NotAfter - (Get-Date)).Days
    if (`$daysLeft -lt 30) {
        Write-Warning "SSL Certificate expires in `$daysLeft days - RENEW SOON!"
        # Send email alert (configure SMTP)
    }
    Write-Host "SSL Certificate valid for `$daysLeft days"
} else {
    Write-Error "SSL Certificate not found!"
}
"@
    
    $monitorPath = "$scriptDir\monitor-ssl-certificate.ps1"
    $monitorScript | Out-File -FilePath $monitorPath -Encoding UTF8
    
    # Create scheduled task
    $taskName = "SSL Certificate Monitor"
    $existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
    if ($existingTask) {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    }
    
    $action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
        -Argument "-ExecutionPolicy Bypass -File `"$monitorPath`""
    
    $trigger = New-ScheduledTaskTrigger -Daily -At "09:00"
    
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
    
    Register-ScheduledTask -TaskName $taskName `
        -Action $action `
        -Trigger $trigger `
        -Principal $principal `
        -Description "Monitors SSL certificate expiry for ZOLO-A6-9VxNUNA" | Out-Null
    
    Write-StatusOK "Created SSL monitoring scheduled task"
    
    Write-Host "`n=== Deployment Complete ===" -ForegroundColor Green
    Write-Host "VPS ID: $VpsId" -ForegroundColor Cyan
    Write-Host "Web Server: $WebServer" -ForegroundColor Cyan
    Write-Host "Website deployed successfully" -ForegroundColor Cyan
    
    Write-Host "`nTesting HTTPS endpoint..." -ForegroundColor Yellow
    Start-Sleep -Seconds 3
    try {
        $response = Invoke-WebRequest -Uri "https://localhost" -UseBasicParsing
        Write-StatusOK "HTTPS is working! Status: $($response.StatusCode)"
    } catch {
        Write-StatusWarning "Could not test HTTPS: $_"
    }
    
    Write-Host "`nNext steps:" -ForegroundColor Yellow
    Write-Host "1. Configure DNS to point to this VPS" -ForegroundColor Gray
    Write-Host "2. Test externally: https://yourdomain.com" -ForegroundColor Gray
    Write-Host "3. Run SSL Labs test for security grade" -ForegroundColor Gray
    Write-Host "4. Monitor certificate expiry daily" -ForegroundColor Gray
    
} else {
    # Remote deployment
    Write-StatusWarning "Remote deployment to MQL5 VPS"
    
    if (-not $VpsHostname) {
        Write-StatusError "VPS hostname required for remote deployment"
        Write-Host "Example: .\deploy-to-vps.ps1 -VpsHostname 'vps-jakarta-01.mql5.com'" -ForegroundColor Yellow
        exit 1
    }
    
    if (-not $Credential) {
        Write-StatusInfo "Enter VPS credentials:"
        $Credential = Get-Credential -Message "Enter VPS administrator credentials"
    }
    
    Write-StatusInfo "Connecting to VPS: $VpsHostname"
    
    try {
        # Test connection
        Test-WSMan -ComputerName $VpsHostname -Authentication Default -Credential $Credential | Out-Null
        Write-StatusOK "Connection established"
        
        # Create remote session
        $session = New-PSSession -ComputerName $VpsHostname -Credential $Credential
        Write-StatusOK "Remote session created"
        
        # Copy files to VPS
        Write-StatusInfo "Copying SSL certificates and scripts..."
        
        $localFiles = @(
            "C:\SSL\certificate.pfx",
            "$PSScriptRoot\install-ssl-certificate.ps1",
            "$PSScriptRoot\configure-webserver.ps1"
        )
        
        foreach ($file in $localFiles) {
            if (Test-Path $file) {
                $fileName = Split-Path $file -Leaf
                $remotePath = "C:\Temp\SSL-Deploy\$fileName"
                
                Invoke-Command -Session $session -ScriptBlock {
                    param($path)
                    if (-not (Test-Path (Split-Path $path))) {
                        New-Item -Path (Split-Path $path) -ItemType Directory -Force | Out-Null
                    }
                } -ArgumentList $remotePath
                
                Copy-Item -Path $file -Destination $remotePath -ToSession $session
                Write-StatusOK "Copied: $fileName"
            }
        }
        
        # Execute deployment on VPS
        Write-StatusInfo "Executing deployment on VPS..."
        
        $result = Invoke-Command -Session $session -ScriptBlock {
            param($webServer)
            
            # Run installation
            & "C:\Temp\SSL-Deploy\install-ssl-certificate.ps1" -WebServer $webServer -CertPath "C:\Temp\SSL-Deploy\certificate.pfx"
            
            # Run configuration
            & "C:\Temp\SSL-Deploy\configure-webserver.ps1" -WebServer $webServer
            
        } -ArgumentList $WebServer
        
        Write-Host $result
        
        # Remove session
        Remove-PSSession -Session $session
        
        Write-Host "`n=== Remote Deployment Complete ===" -ForegroundColor Green
        Write-Host "VPS: $VpsHostname" -ForegroundColor Cyan
        Write-Host "Web Server: $WebServer" -ForegroundColor Cyan
        
    } catch {
        Write-StatusError "Remote deployment failed: $_"
        Write-Host "`nTroubleshooting:" -ForegroundColor Yellow
        Write-Host "1. Verify VPS hostname and credentials" -ForegroundColor Gray
        Write-Host "2. Check if WinRM is enabled on VPS" -ForegroundColor Gray
        Write-Host "3. Verify network connectivity" -ForegroundColor Gray
        Write-Host "4. Try RDP and manual installation instead" -ForegroundColor Gray
        exit 1
    }
}

Write-Host "`nCertificate expires: February 19, 2026" -ForegroundColor Yellow
Write-Host "Plan renewal at least 30 days before expiry`n" -ForegroundColor Yellow
