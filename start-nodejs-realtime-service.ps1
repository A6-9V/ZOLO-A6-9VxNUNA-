#Requires -Version 5.1
<#
.SYNOPSIS
    Starts the Node.js real-time data service.
.DESCRIPTION
    Navigates to the realtime-service directory, installs dependencies,
    and starts the Node.js server in the background.
#>

$ErrorActionPreference = "Stop"

$serviceRoot = Join-Path $PSScriptRoot "realtime-service"

if (-not (Test-Path $serviceRoot)) {
    Write-Host "[ERROR] Real-time service directory not found at: $serviceRoot" -ForegroundColor Red
    exit 1
}

Push-Location $serviceRoot

try {
    Write-Host "[INFO] Installing Node.js dependencies in $serviceRoot..." -ForegroundColor Yellow
    npm install

    Write-Host "[INFO] Starting Node.js real-time service..." -ForegroundColor Yellow
    # Start the Node.js server as a background process
    Start-Process node -ArgumentList "index.js" -NoNewWindow

    Write-Host "[OK] Node.js real-time service started successfully." -ForegroundColor Green
}
catch {
    Write-Host "[ERROR] Failed to start the Node.js service: $_" -ForegroundColor Red
    exit 1
}
finally {
    Pop-Location
}
