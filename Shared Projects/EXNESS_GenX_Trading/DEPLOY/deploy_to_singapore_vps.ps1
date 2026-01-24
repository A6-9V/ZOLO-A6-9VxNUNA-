# Deploy EXNESS GenX Trader to Singapore VPS
# VPS: sangapur 09: 6773048

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Deploying to Singapore VPS" -ForegroundColor Cyan
Write-Host "  VPS: sangapur 09: 6773048" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DeployPackage = Join-Path $ScriptDir "deployment_package"
$EAFile = Join-Path $DeployPackage "EXNESS_GenX_Trader.mq5"
$ConfigFile = Join-Path $DeployPackage "EXNESS_GenX_Config.mqh"

# Verify files exist
if (-not (Test-Path $EAFile) -or -not (Test-Path $ConfigFile)) {
    Write-Host "ERROR: Deployment files not found!" -ForegroundColor Red
    exit 1
}

Write-Host "Files ready for deployment:" -ForegroundColor Green
Write-Host "  - $EAFile" -ForegroundColor White
Write-Host "  - $ConfigFile" -ForegroundColor White
Write-Host ""

# VPS connection details
Write-Host "Please provide VPS connection details:" -ForegroundColor Yellow
Write-Host ""

$vpsIP = Read-Host "Enter VPS IP address or hostname"
if ([string]::IsNullOrEmpty($vpsIP)) {
    Write-Host "ERROR: VPS IP is required" -ForegroundColor Red
    exit 1
}

$vpsUser = Read-Host "Enter VPS username (or press Enter for Administrator)"
if ([string]::IsNullOrEmpty($vpsUser)) {
    $vpsUser = "Administrator"
}

$vpsPassword = Read-Host "Enter VPS password" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($vpsPassword)
$vpsPasswordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

$mt5Path = Read-Host "Enter MT5 MQL5 path on VPS (e.g., C:\Program Files\MetaTrader 5\MQL5)"
if ([string]::IsNullOrEmpty($mt5Path)) {
    Write-Host "Trying default paths..." -ForegroundColor Yellow
    $mt5Path = "C:\Program Files\MetaTrader 5\MQL5"
}

Write-Host ""
Write-Host "Attempting to connect to VPS..." -ForegroundColor Cyan

try {
    # Create credential
    $SecurePassword = ConvertTo-SecureString $vpsPasswordPlain -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential($vpsUser, $SecurePassword)
    
    # Test connection
    Write-Host "Testing connection to $vpsIP..." -ForegroundColor Yellow
    
    # Try to create PSSession
    $Session = New-PSSession -ComputerName $vpsIP -Credential $Credential -ErrorAction Stop
    
    Write-Host "Connected successfully!" -ForegroundColor Green
    Write-Host ""
    
    # Verify MT5 path exists
    Write-Host "Verifying MT5 path: $mt5Path" -ForegroundColor Yellow
    $pathExists = Invoke-Command -Session $Session -ScriptBlock {
        param($Path)
        Test-Path $Path
    } -ArgumentList $mt5Path
    
    if (-not $pathExists) {
        Write-Host "WARNING: MT5 path not found. Trying to locate..." -ForegroundColor Yellow
        
        # Try common paths
        $commonPaths = @(
            "C:\Program Files\MetaTrader 5\MQL5",
            "C:\Program Files (x86)\MetaTrader 5\MQL5",
            "C:\Users\$vpsUser\AppData\Roaming\MetaQuotes\Terminal\*\MQL5"
        )
        
        $foundPath = $null
        foreach ($path in $commonPaths) {
            $result = Invoke-Command -Session $Session -ScriptBlock {
                param($SearchPath)
                if ($SearchPath -like "*\*") {
                    # Wildcard path
                    $parent = Split-Path $SearchPath -Parent
                    $pattern = Split-Path $SearchPath -Leaf
                    Get-ChildItem -Path $parent -Directory -Filter $pattern -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
                } else {
                    if (Test-Path $SearchPath) { $SearchPath } else { $null }
                }
            } -ArgumentList $path
            
            if ($result) {
                $foundPath = $result
                break
            }
        }
        
        if ($foundPath) {
            $mt5Path = $foundPath
            Write-Host "Found MT5 at: $mt5Path" -ForegroundColor Green
        } else {
            Write-Host "ERROR: Could not find MT5 installation. Please provide the correct path." -ForegroundColor Red
            Remove-PSSession $Session
            exit 1
        }
    }
    
    # Create directories if needed
    $ExpertsPath = Join-Path $mt5Path "Experts"
    $IncludePath = Join-Path $mt5Path "Include"
    
    Invoke-Command -Session $Session -ScriptBlock {
        param($ExpertsPath, $IncludePath)
        if (-not (Test-Path $ExpertsPath)) { New-Item -ItemType Directory -Path $ExpertsPath -Force | Out-Null }
        if (-not (Test-Path $IncludePath)) { New-Item -ItemType Directory -Path $IncludePath -Force | Out-Null }
    } -ArgumentList $ExpertsPath, $IncludePath
    
    Write-Host "Copying files to VPS..." -ForegroundColor Cyan
    
    # Copy files via network share or temp folder
    $tempPath = "\\$vpsIP\C$\Temp"
    if (-not (Test-Path $tempPath)) {
        # Try alternative: copy via session
        Write-Host "Using PowerShell session to copy files..." -ForegroundColor Yellow
        
        # Read file contents and transfer
        $eaContent = Get-Content $EAFile -Raw -Encoding UTF8
        $configContent = Get-Content $ConfigFile -Raw -Encoding UTF8
        
        Invoke-Command -Session $Session -ScriptBlock {
            param($EAContent, $ConfigContent, $ExpertsPath, $IncludePath)
            
            $eaFile = Join-Path $ExpertsPath "EXNESS_GenX_Trader.mq5"
            $configFile = Join-Path $IncludePath "EXNESS_GenX_Config.mqh"
            
            [System.IO.File]::WriteAllText($eaFile, $EAContent, [System.Text.Encoding]::UTF8)
            [System.IO.File]::WriteAllText($configFile, $ConfigContent, [System.Text.Encoding]::UTF8)
            
            Write-Output "Files copied successfully"
        } -ArgumentList $eaContent, $configContent, $ExpertsPath, $IncludePath
        
    } else {
        # Copy via network share
        Copy-Item $EAFile "$tempPath\EXNESS_GenX_Trader.mq5" -Force
        Copy-Item $ConfigFile "$tempPath\EXNESS_GenX_Config.mqh" -Force
        
        # Move to final location
        Invoke-Command -Session $Session -ScriptBlock {
            param($ExpertsPath, $IncludePath)
            Move-Item "C:\Temp\EXNESS_GenX_Trader.mq5" $ExpertsPath -Force
            Move-Item "C:\Temp\EXNESS_GenX_Config.mqh" $IncludePath -Force
        } -ArgumentList $ExpertsPath, $IncludePath
    }
    
    Write-Host "Files deployed successfully!" -ForegroundColor Green
    Write-Host ""
    
    # Verify files
    $verify = Invoke-Command -Session $Session -ScriptBlock {
        param($ExpertsPath, $IncludePath)
        @{
            EAExists = Test-Path (Join-Path $ExpertsPath "EXNESS_GenX_Trader.mq5")
            ConfigExists = Test-Path (Join-Path $IncludePath "EXNESS_GenX_Config.mqh")
        }
    } -ArgumentList $ExpertsPath, $IncludePath
    
    if ($verify.EAExists -and $verify.ConfigExists) {
        Write-Host "Verification successful!" -ForegroundColor Green
        Write-Host "  - EA file: $ExpertsPath\EXNESS_GenX_Trader.mq5" -ForegroundColor White
        Write-Host "  - Config file: $IncludePath\EXNESS_GenX_Config.mqh" -ForegroundColor White
    } else {
        Write-Host "WARNING: File verification failed" -ForegroundColor Yellow
    }
    
    Remove-PSSession $Session
    
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Green
    Write-Host "  Deployment Complete!" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps on VPS:" -ForegroundColor Yellow
    Write-Host "  1. Open MetaTrader 5" -ForegroundColor White
    Write-Host "  2. Press F4 to open MetaEditor" -ForegroundColor White
    Write-Host "  3. Navigate to Experts folder" -ForegroundColor White
    Write-Host "  4. Open EXNESS_GenX_Trader.mq5" -ForegroundColor White
    Write-Host "  5. Press F7 to compile" -ForegroundColor White
    Write-Host "  6. Attach EA to chart" -ForegroundColor White
    Write-Host "  7. Enable AutoTrading" -ForegroundColor White
    Write-Host ""
    
} catch {
    Write-Host ""
    Write-Host "ERROR: Failed to deploy via PowerShell Remoting" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Alternative: Manual deployment via Remote Desktop" -ForegroundColor Yellow
    Write-Host "  1. Connect to VPS: mstsc /v:$vpsIP" -ForegroundColor White
    Write-Host "  2. Copy deployment_package folder to VPS" -ForegroundColor White
    Write-Host "  3. Follow instructions in INSTALL.txt" -ForegroundColor White
    Write-Host ""
    
    # Offer to open RDP connection
    $openRDP = Read-Host "Open Remote Desktop connection? (Y/N)"
    if ($openRDP -eq "Y" -or $openRDP -eq "y") {
        Start-Process "mstsc.exe" -ArgumentList "/v:$vpsIP"
    }
    
    exit 1
}
