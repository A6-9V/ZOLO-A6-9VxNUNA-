# Verify GitHub App Setup
# Checks if GenX GitHub App is properly configured

param(
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"

Write-Host "`n🔍 Verifying GenX GitHub App Setup..." -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor Gray

$issues = @()
$warnings = @()

# Check 1: MCP Config File
Write-Host "`n[1/6] Checking MCP configuration..." -ForegroundColor Yellow
$mcpConfigPath = ".\mcp-config.json"
if (Test-Path $mcpConfigPath) {
    try {
        $mcpConfig = Get-Content $mcpConfigPath | ConvertFrom-Json
        $githubServer = $mcpConfig.mcpServers.github
        
        if ($githubServer) {
            Write-Host "   ✓ MCP config found" -ForegroundColor Green
            
            # Check for GitHub App credentials
            $hasAppId = $githubServer.env.GITHUB_APP_ID
            $hasPrivateKey = $githubServer.env.GITHUB_APP_PRIVATE_KEY_PATH
            $hasInstallationId = $githubServer.env.GITHUB_APP_INSTALLATION_ID
            $hasToken = $githubServer.env.GITHUB_PERSONAL_ACCESS_TOKEN
            
            if ($hasAppId -and $hasPrivateKey -and $hasInstallationId) {
                Write-Host "   ✓ GitHub App credentials configured" -ForegroundColor Green
                
                # Verify private key file exists
                if (Test-Path $hasPrivateKey) {
                    Write-Host "   ✓ Private key file found: $hasPrivateKey" -ForegroundColor Green
                    
                    # Check file permissions (basic check)
                    $keyFile = Get-Item $hasPrivateKey
                    if ($keyFile.Attributes -notmatch "ReadOnly") {
                        Write-Host "   ✓ Private key file is readable" -ForegroundColor Green
                    }
                } else {
                    $issues += "Private key file not found: $hasPrivateKey"
                    Write-Host "   ✗ Private key file missing: $hasPrivateKey" -ForegroundColor Red
                }
                
                # Check if values are placeholders
                if ($hasAppId -eq "YOUR_APP_ID" -or $hasInstallationId -eq "YOUR_INSTALLATION_ID") {
                    $warnings += "GitHub App credentials appear to be placeholders - update with real values"
                    Write-Host "   ⚠ App credentials may be placeholders" -ForegroundColor Yellow
                }
            }
            elseif ($hasToken) {
                Write-Host "   ⚠ Using Personal Access Token (not GitHub App)" -ForegroundColor Yellow
                if ([string]::IsNullOrWhiteSpace($hasToken)) {
                    $issues += "GITHUB_PERSONAL_ACCESS_TOKEN is empty"
                    Write-Host "   ✗ Personal Access Token is empty" -ForegroundColor Red
                } else {
                    Write-Host "   ✓ Personal Access Token configured" -ForegroundColor Green
                }
            }
            else {
                $issues += "No GitHub authentication method configured (neither App nor Token)"
                Write-Host "   ✗ No authentication configured" -ForegroundColor Red
            }
        } else {
            $issues += "GitHub server not found in MCP config"
            Write-Host "   ✗ GitHub server not configured" -ForegroundColor Red
        }
    }
    catch {
        $issues += "Failed to parse MCP config: $_"
        Write-Host "   ✗ Error reading MCP config: $_" -ForegroundColor Red
    }
} else {
    $issues += "MCP config file not found: $mcpConfigPath"
    Write-Host "   ✗ MCP config file missing" -ForegroundColor Red
}

# Check 2: GitHub CLI
Write-Host "`n[2/6] Checking GitHub CLI..." -ForegroundColor Yellow
try {
    $ghVersion = gh --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ GitHub CLI installed" -ForegroundColor Green
        if ($Verbose) {
            Write-Host "   $ghVersion" -ForegroundColor Gray
        }
    } else {
        $warnings += "GitHub CLI not found or not working"
        Write-Host "   ⚠ GitHub CLI not available" -ForegroundColor Yellow
    }
}
catch {
    $warnings += "GitHub CLI not installed"
    Write-Host "   ⚠ GitHub CLI not found" -ForegroundColor Yellow
}

# Check 3: GitHub CLI Authentication
Write-Host "`n[3/6] Checking GitHub CLI authentication..." -ForegroundColor Yellow
try {
    $authStatus = gh auth status 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ GitHub CLI authenticated" -ForegroundColor Green
        if ($Verbose) {
            Write-Host "   $authStatus" -ForegroundColor Gray
        }
    } else {
        $warnings += "GitHub CLI not authenticated - run 'gh auth login'"
        Write-Host "   ⚠ GitHub CLI not authenticated" -ForegroundColor Yellow
    }
}
catch {
    $warnings += "Could not check GitHub CLI authentication"
    Write-Host "   ⚠ Could not verify authentication" -ForegroundColor Yellow
}

# Check 4: Environment Variables
Write-Host "`n[4/6] Checking environment variables..." -ForegroundColor Yellow
$envVars = @(
    "GITHUB_APP_ID",
    "GITHUB_APP_INSTALLATION_ID",
    "GITHUB_APP_PRIVATE_KEY_PATH",
    "GITHUB_PERSONAL_ACCESS_TOKEN"
)

$foundEnvVars = 0
foreach ($var in $envVars) {
    $value = [System.Environment]::GetEnvironmentVariable($var, "User")
    if ($value) {
        $foundEnvVars++
        if ($Verbose) {
            Write-Host "   ✓ $var is set" -ForegroundColor Green
        }
    }
}

if ($foundEnvVars -gt 0) {
    Write-Host "   ✓ Found $foundEnvVars environment variable(s)" -ForegroundColor Green
} else {
    Write-Host "   ℹ No GitHub environment variables set (using MCP config)" -ForegroundColor Gray
}

# Check 5: Private Key Directory
Write-Host "`n[5/6] Checking private key storage..." -ForegroundColor Yellow
$githubDir = "$env:USERPROFILE\.github"
if (Test-Path $githubDir) {
    Write-Host "   ✓ GitHub credentials directory exists: $githubDir" -ForegroundColor Green
    
    $pemFiles = Get-ChildItem -Path $githubDir -Filter "*.pem" -ErrorAction SilentlyContinue
    if ($pemFiles) {
        Write-Host "   ✓ Found $($pemFiles.Count) PEM file(s)" -ForegroundColor Green
        if ($Verbose) {
            foreach ($file in $pemFiles) {
                Write-Host "     - $($file.Name)" -ForegroundColor Gray
            }
        }
    } else {
        Write-Host "   ℹ No PEM files found in credentials directory" -ForegroundColor Gray
    }
} else {
    Write-Host "   ℹ GitHub credentials directory not created yet" -ForegroundColor Gray
    Write-Host "     Recommended: Create $githubDir for secure key storage" -ForegroundColor Gray
}

# Check 6: Cursor MCP Config
Write-Host "`n[6/6] Checking Cursor MCP configuration..." -ForegroundColor Yellow
$cursorMcpPath = "$env:APPDATA\Cursor\User\globalStorage\mcp.json"
if (Test-Path $cursorMcpPath) {
    Write-Host "   ✓ Cursor MCP config exists" -ForegroundColor Green
    
    try {
        $cursorConfig = Get-Content $cursorMcpPath | ConvertFrom-Json
        $cursorGitHub = $cursorConfig.mcpServers.github
        
        if ($cursorGitHub) {
            Write-Host "   ✓ GitHub server configured in Cursor" -ForegroundColor Green
            
            # Compare with local config
            $localConfig = Get-Content $mcpConfigPath | ConvertFrom-Json
            $localGitHub = $localConfig.mcpServers.github
            
            if ($localGitHub.env.GITHUB_APP_ID -and $cursorGitHub.env.GITHUB_APP_ID) {
                if ($localGitHub.env.GITHUB_APP_ID -eq $cursorGitHub.env.GITHUB_APP_ID) {
                    Write-Host "   ✓ Configs match" -ForegroundColor Green
                } else {
                    $warnings += "Cursor MCP config differs from local config - may need to sync"
                    Write-Host "   ⚠ Configs differ - consider running complete-setup.ps1" -ForegroundColor Yellow
                }
            }
        } else {
            $warnings += "GitHub server not configured in Cursor MCP config"
            Write-Host "   ⚠ GitHub server not in Cursor config" -ForegroundColor Yellow
        }
    }
    catch {
        $warnings += "Could not parse Cursor MCP config"
        Write-Host "   ⚠ Error reading Cursor config: $_" -ForegroundColor Yellow
    }
} else {
    $warnings += "Cursor MCP config not found - may need to run setup"
    Write-Host "   ⚠ Cursor MCP config missing" -ForegroundColor Yellow
    Write-Host "     Run: .\complete-setup.ps1" -ForegroundColor Gray
}

# Summary
Write-Host "`n" + ("=" * 50) -ForegroundColor Gray
Write-Host "📊 Verification Summary" -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor Gray

if ($issues.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "`n✅ All checks passed! GitHub App is properly configured." -ForegroundColor Green
    exit 0
}
else {
    if ($issues.Count -gt 0) {
        Write-Host "`n❌ Issues found ($($issues.Count)):" -ForegroundColor Red
        foreach ($issue in $issues) {
            Write-Host "   • $issue" -ForegroundColor Red
        }
    }
    
    if ($warnings.Count -gt 0) {
        Write-Host "`n⚠️  Warnings ($($warnings.Count)):" -ForegroundColor Yellow
        foreach ($warning in $warnings) {
            Write-Host "   • $warning" -ForegroundColor Yellow
        }
    }
    
    Write-Host "`n💡 Next Steps:" -ForegroundColor Cyan
    Write-Host "   1. Review GITHUB-APP-SETUP.md for setup instructions" -ForegroundColor White
    Write-Host "   2. Update mcp-config.json with your credentials" -ForegroundColor White
    Write-Host "   3. Run .\complete-setup.ps1 to apply configuration" -ForegroundColor White
    Write-Host "   4. Restart Cursor to load new MCP settings" -ForegroundColor White
    
    exit 1
}

