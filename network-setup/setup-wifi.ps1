<#
.SYNOPSIS
    Sets up the WiFi profile for LengA6-9V
.DESCRIPTION
    Imports the WiFi profile from LengA6-9V.xml.
    If the XML contains the placeholder password, it prompts the user for the password.
#>
param(
    [string]$Password
)

$ErrorActionPreference = "Stop"
$scriptPath = $PSScriptRoot
$xmlPath = Join-Path $scriptPath "LengA6-9V.xml"

if (-not (Test-Path $xmlPath)) {
    Write-Error "WiFi profile XML not found at $xmlPath"
    exit 1
}

$xmlContent = Get-Content $xmlPath -Raw

if ($xmlContent -match "PUT_PASSWORD_HERE") {
    if (-not $Password) {
        Write-Host "The WiFi profile XML contains a placeholder password." -ForegroundColor Yellow
        Write-Host "Please enter the WiFi password for SSID 'LengA6-9V':" -ForegroundColor Yellow
        $SecurePassword = Read-Host -AsSecureString
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
        $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    }

    if ([string]::IsNullOrWhiteSpace($Password)) {
        Write-Error "Password is required to setup the WiFi profile."
        exit 1
    }

    # Create a temporary XML with the real password
    Write-Host "Generating temporary profile configuration..." -ForegroundColor Cyan
    $xmlContent = $xmlContent -replace "PUT_PASSWORD_HERE", $Password
    $tempXmlPath = Join-Path $scriptPath "temp-profile.xml"
    Set-Content -Path $tempXmlPath -Value $xmlContent

    try {
        Write-Host "Adding WiFi profile to system..." -ForegroundColor Cyan
        $result = netsh wlan add profile filename="$tempXmlPath"
        Write-Host $result
    }
    catch {
        Write-Error "Failed to add WiFi profile: $_"
    }
    finally {
        # Clean up sensitive file immediately
        if (Test-Path $tempXmlPath) {
            Remove-Item $tempXmlPath -Force
            Write-Host "Temporary configuration cleaned up." -ForegroundColor Gray
        }
    }
} else {
    # Password already in file (user edited it manually)
    Write-Host "Adding WiFi profile from existing XML configuration..." -ForegroundColor Cyan
    $result = netsh wlan add profile filename="$xmlPath"
    Write-Host $result
}

Write-Host "Attempting to connect to 'LengA6-9V'..." -ForegroundColor Cyan
$connectResult = netsh wlan connect name="LengA6-9V"
Write-Host $connectResult

Write-Host "Setup complete." -ForegroundColor Green
