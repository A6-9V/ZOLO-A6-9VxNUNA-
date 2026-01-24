# EXNESS GenX Trader - VPS Deployment Script
# This script helps deploy the EA to a VPS via Remote Desktop

param(
    [string]$VPSHost = "",
    [string]$VPSUser = "",
    [string]$VPSPassword = "",
    [string]$MT5Path = "",
    [switch]$Interactive = $true
)

$ErrorActionPreference = "Stop"

# Colors for output
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

Write-ColorOutput "═══════════════════════════════════════════════════" "Cyan"
Write-ColorOutput "  EXNESS GenX Trader - VPS Deployment Tool" "Cyan"
Write-ColorOutput "═══════════════════════════════════════════════════" "Cyan"
Write-Host ""

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$ExpertsPath = Join-Path $ProjectRoot "EXPERTS"
$IncludePath = Join-Path $ProjectRoot "INCLUDE"

# Verify source files exist
$EAFile = Join-Path $ExpertsPath "EXNESS_GenX_Trader.mq5"
$ConfigFile = Join-Path $IncludePath "EXNESS_GenX_Config.mqh"

if (-not (Test-Path $EAFile)) {
    Write-ColorOutput "ERROR: EA file not found: $EAFile" "Red"
    exit 1
}

if (-not (Test-Path $ConfigFile)) {
    Write-ColorOutput "ERROR: Config file not found: $ConfigFile" "Red"
    exit 1
}

Write-ColorOutput "✓ Source files verified" "Green"
Write-Host ""

# Interactive mode - collect VPS information
if ($Interactive) {
    if ([string]::IsNullOrEmpty($VPSHost)) {
        $VPSHost = Read-Host "Enter VPS IP address or hostname"
    }
    
    if ([string]::IsNullOrEmpty($VPSUser)) {
        $VPSUser = Read-Host "Enter VPS username"
    }
    
    if ([string]::IsNullOrEmpty($VPSPassword)) {
        $SecurePassword = Read-Host "Enter VPS password" -AsSecureString
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
        $VPSPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    }
    
    if ([string]::IsNullOrEmpty($MT5Path)) {
        Write-Host ""
        Write-ColorOutput "Common MT5 paths on VPS:" "Yellow"
        Write-Host "  1. C:\Program Files\MetaTrader 5\MQL5"
        Write-Host "  2. C:\Users\$VPSUser\AppData\Roaming\MetaQuotes\Terminal\[ID]\MQL5"
        Write-Host ""
        $MT5Path = Read-Host "Enter MT5 MQL5 folder path on VPS"
    }
}

# Validate inputs
if ([string]::IsNullOrEmpty($VPSHost) -or 
    [string]::IsNullOrEmpty($VPSUser) -or 
    [string]::IsNullOrEmpty($MT5Path)) {
    Write-ColorOutput "ERROR: Missing required parameters" "Red"
    exit 1
}

Write-Host ""
Write-ColorOutput "Deployment Configuration:" "Yellow"
Write-Host "  VPS Host: $VPSHost"
Write-Host "  VPS User: $VPSUser"
Write-Host "  MT5 Path: $MT5Path"
Write-Host ""

$Confirm = Read-Host "Proceed with deployment? (Y/N)"
if ($Confirm -ne "Y" -and $Confirm -ne "y") {
    Write-ColorOutput "Deployment cancelled." "Yellow"
    exit 0
}

Write-Host ""

# Method 1: Try using PowerShell remoting (if enabled)
Write-ColorOutput "Attempting deployment via PowerShell Remoting..." "Cyan"

try {
    $SecurePassword = ConvertTo-SecureString $VPSPassword -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential($VPSUser, $SecurePassword)
    
    # Create remote session
    $Session = New-PSSession -ComputerName $VPSHost -Credential $Credential -ErrorAction Stop
    
    Write-ColorOutput "✓ Connected to VPS" "Green"
    
    # Verify MT5 path exists on VPS
    $MT5Exists = Invoke-Command -Session $Session -ScriptBlock {
        param($Path)
        Test-Path $Path
    } -ArgumentList $MT5Path
    
    if (-not $MT5Exists) {
        Write-ColorOutput "WARNING: MT5 path not found on VPS: $MT5Path" "Yellow"
        Write-ColorOutput "Please verify the path and try again." "Yellow"
        Remove-PSSession $Session
        exit 1
    }
    
    # Create directories if they don't exist
    $ExpertsDest = Join-Path $MT5Path "Experts"
    $IncludeDest = Join-Path $MT5Path "Include"
    
    Invoke-Command -Session $Session -ScriptBlock {
        param($ExpertsPath, $IncludePath)
        if (-not (Test-Path $ExpertsPath)) { New-Item -ItemType Directory -Path $ExpertsPath -Force | Out-Null }
        if (-not (Test-Path $IncludePath)) { New-Item -ItemType Directory -Path $IncludePath -Force | Out-Null }
    } -ArgumentList $ExpertsDest, $IncludeDest
    
    # Copy files
    Write-ColorOutput "Copying files to VPS..." "Cyan"
    
    $EAFileName = Split-Path $EAFile -Leaf
    $ConfigFileName = Split-Path $ConfigFile -Leaf
    
    Copy-Item -Path $EAFile -Destination "\\$VPSHost\C$\Temp\$EAFileName" -Force -ErrorAction Stop
    Copy-Item -Path $ConfigFile -Destination "\\$VPSHost\C$\Temp\$ConfigFileName" -Force -ErrorAction Stop
    
    # Move files to final location
    Invoke-Command -Session $Session -ScriptBlock {
        param($EAFile, $ConfigFile, $ExpertsDest, $IncludeDest)
        Move-Item -Path "C:\Temp\$EAFile" -Destination $ExpertsDest -Force
        Move-Item -Path "C:\Temp\$ConfigFile" -Destination $IncludeDest -Force
    } -ArgumentList $EAFileName, $ConfigFileName, $ExpertsDest, $IncludeDest
    
    Write-ColorOutput "✓ Files copied successfully" "Green"
    
    Remove-PSSession $Session
    
    Write-Host ""
    Write-ColorOutput "═══════════════════════════════════════════════════" "Green"
    Write-ColorOutput "  Deployment Complete!" "Green"
    Write-ColorOutput "═══════════════════════════════════════════════════" "Green"
    Write-Host ""
    Write-ColorOutput "Next Steps:" "Yellow"
    Write-Host "  1. Connect to VPS via Remote Desktop"
    Write-Host "  2. Open MetaTrader 5"
    Write-Host "  3. Press F4 to open MetaEditor"
    Write-Host "  4. Compile EXNESS_GenX_Trader.mq5 (F7)"
    Write-Host "  5. Attach EA to chart"
    Write-Host "  6. Enable AutoTrading"
    Write-Host ""
    
} catch {
    Write-ColorOutput "PowerShell Remoting failed: $($_.Exception.Message)" "Yellow"
    Write-Host ""
    Write-ColorOutput "Falling back to manual deployment instructions..." "Cyan"
    Write-Host ""
    
    # Method 2: Provide manual instructions
    Write-ColorOutput "═══════════════════════════════════════════════════" "Yellow"
    Write-ColorOutput "  Manual Deployment Instructions" "Yellow"
    Write-ColorOutput "═══════════════════════════════════════════════════" "Yellow"
    Write-Host ""
    Write-ColorOutput "1. Connect to VPS via Remote Desktop:" "White"
    Write-Host "   mstsc /v:$VPSHost"
    Write-Host ""
    Write-ColorOutput "2. Copy these files to VPS:" "White"
    Write-Host "   Source: $EAFile"
    Write-Host "   Destination: $MT5Path\Experts\EXNESS_GenX_Trader.mq5"
    Write-Host ""
    Write-Host "   Source: $ConfigFile"
    Write-Host "   Destination: $MT5Path\Include\EXNESS_GenX_Config.mqh"
    Write-Host ""
    Write-ColorOutput "3. On VPS, open MetaTrader 5 and:" "White"
    Write-Host "   - Press F4 to open MetaEditor"
    Write-Host "   - Navigate to Experts folder"
    Write-Host "   - Open EXNESS_GenX_Trader.mq5"
    Write-Host "   - Press F7 to compile"
    Write-Host "   - Attach EA to chart"
    Write-Host "   - Enable AutoTrading"
    Write-Host ""
    
    # Create a deployment package
    $DeployPackage = Join-Path $ScriptDir "deployment_package"
    if (-not (Test-Path $DeployPackage)) {
        New-Item -ItemType Directory -Path $DeployPackage -Force | Out-Null
    }
    
    Copy-Item $EAFile (Join-Path $DeployPackage "EXNESS_GenX_Trader.mq5") -Force
    Copy-Item $ConfigFile (Join-Path $DeployPackage "EXNESS_GenX_Config.mqh") -Force
    
    Write-ColorOutput "✓ Deployment package created at:" "Green"
    Write-Host "  $DeployPackage"
    Write-Host ""
    Write-ColorOutput "You can copy this folder to VPS via:" "Yellow"
    Write-Host "  - Remote Desktop (copy/paste)"
    Write-Host "  - Network share"
    Write-Host "  - USB drive"
    Write-Host "  - Cloud storage (OneDrive, Dropbox, etc.)"
    Write-Host ""
}
