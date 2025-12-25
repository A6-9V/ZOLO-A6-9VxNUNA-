# GitHub Workspace Quick Setup
# Automates the setup of GitHub integration for this workspace

param(
    [switch]$UsePersonalToken,
    [switch]$UseGitHubApp,
    [string]$Token,
    [switch]$SkipMCP,
    [switch]$Verify
)

$ErrorActionPreference = "Continue"

Write-Host "`n╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  GitHub Workspace Quick Setup            ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Step 1: Check Prerequisites
Write-Host "[1/5] Checking prerequisites..." -ForegroundColor Yellow

# Check Git
try {
    $gitVersion = git --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Git installed: $gitVersion" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Git not found" -ForegroundColor Red
        Write-Host "    Install Git from: https://git-scm.com/download/win" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "  ✗ Git not available" -ForegroundColor Red
    exit 1
}

# Check GitHub CLI (optional)
try {
    $ghVersion = gh --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ GitHub CLI installed" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ GitHub CLI not found (optional)" -ForegroundColor Yellow
        Write-Host "    Install from: https://cli.github.com/" -ForegroundColor Gray
    }
} catch {
    Write-Host "  ⚠ GitHub CLI not available (optional)" -ForegroundColor Yellow
}

# Check Node.js (for MCP)
if (-not $SkipMCP) {
    try {
        $nodeVersion = node --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ Node.js installed: $nodeVersion" -ForegroundColor Green
        } else {
            Write-Host "  ⚠ Node.js not found (needed for MCP)" -ForegroundColor Yellow
            Write-Host "    Install from: https://nodejs.org/" -ForegroundColor Gray
        }
    } catch {
        Write-Host "  ⚠ Node.js not available (MCP will not work)" -ForegroundColor Yellow
    }
}

# Step 2: Configure Git
Write-Host "`n[2/5] Configuring Git..." -ForegroundColor Yellow

try {
    # Check current git config
    $gitUser = git config user.name 2>&1
    $gitEmail = git config user.email 2>&1
    
    if ($gitUser -and $gitEmail) {
        Write-Host "  ✓ Git already configured" -ForegroundColor Green
        Write-Host "    User: $gitUser" -ForegroundColor Gray
        Write-Host "    Email: $gitEmail" -ForegroundColor Gray
    } else {
        Write-Host "  ℹ Git not fully configured" -ForegroundColor Gray
        Write-Host "    Run: .\git-setup.ps1" -ForegroundColor Yellow
    }
    
    # Check remote
    $remote = git remote get-url origin 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Remote configured: $remote" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ No remote configured" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ⚠ Could not check git configuration" -ForegroundColor Yellow
}

# Step 3: Setup GitHub Authentication
Write-Host "`n[3/5] Setting up GitHub authentication..." -ForegroundColor Yellow

$authMethod = $null

if ($UsePersonalToken) {
    $authMethod = "token"
    Write-Host "  ℹ Using Personal Access Token method" -ForegroundColor Cyan
    
    if ($Token) {
        Write-Host "  ℹ Token provided via parameter" -ForegroundColor Gray
        # Store in environment variable (user level)
        try {
            [System.Environment]::SetEnvironmentVariable("GITHUB_TOKEN", $Token, "User")
            Write-Host "  ✓ Token stored in environment variable" -ForegroundColor Green
        } catch {
            Write-Host "  ✗ Failed to store token: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "  ⚠ No token provided" -ForegroundColor Yellow
        Write-Host "    Generate token at: https://github.com/settings/tokens" -ForegroundColor Gray
        Write-Host "    Required scopes: repo, workflow, read:org" -ForegroundColor Gray
    }
} elseif ($UseGitHubApp) {
    $authMethod = "app"
    Write-Host "  ℹ Using GitHub App method" -ForegroundColor Cyan
    Write-Host "    Follow setup guide: .\system-setup\GITHUB-APP-SETUP.md" -ForegroundColor Gray
} else {
    Write-Host "  ℹ No authentication method specified" -ForegroundColor Gray
    Write-Host "    Use -UsePersonalToken or -UseGitHubApp flag" -ForegroundColor Yellow
}

# Step 4: Setup MCP Configuration
if (-not $SkipMCP) {
    Write-Host "`n[4/5] Setting up MCP configuration..." -ForegroundColor Yellow
    
    $mcpConfigPath = ".\system-setup\mcp-config.json"
    if (Test-Path $mcpConfigPath) {
        Write-Host "  ✓ MCP config file found" -ForegroundColor Green
        
        # Check if we should update it
        if ($UsePersonalToken -and $Token) {
            try {
                $mcpConfig = Get-Content $mcpConfigPath | ConvertFrom-Json
                $mcpConfig.mcpServers.github.env.GITHUB_PERSONAL_ACCESS_TOKEN = $Token
                $mcpConfig | ConvertTo-Json -Depth 10 | Set-Content $mcpConfigPath
                Write-Host "  ✓ MCP config updated with token" -ForegroundColor Green
            } catch {
                Write-Host "  ✗ Failed to update MCP config: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        
        # Check if complete-setup.ps1 exists
        $setupScript = ".\system-setup\complete-setup.ps1"
        if (Test-Path $setupScript) {
            Write-Host "  ℹ To apply MCP config to Cursor, run:" -ForegroundColor Cyan
            Write-Host "    .\system-setup\complete-setup.ps1" -ForegroundColor White
        }
    } else {
        Write-Host "  ⚠ MCP config file not found: $mcpConfigPath" -ForegroundColor Yellow
    }
} else {
    Write-Host "`n[4/5] Skipping MCP configuration..." -ForegroundColor Gray
}

# Step 5: Verify Setup
Write-Host "`n[5/5] Verifying setup..." -ForegroundColor Yellow

if ($Verify -or $authMethod) {
    # Check GitHub CLI authentication
    try {
        $authStatus = gh auth status 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ GitHub CLI authenticated" -ForegroundColor Green
        } else {
            Write-Host "  ⚠ GitHub CLI not authenticated" -ForegroundColor Yellow
            Write-Host "    Run: gh auth login" -ForegroundColor Gray
        }
    } catch {
        Write-Host "  ℹ GitHub CLI not available" -ForegroundColor Gray
    }
    
    # Check MCP verification script
    $verifyScript = ".\system-setup\verify-github-app.ps1"
    if (Test-Path $verifyScript) {
        Write-Host "  ℹ To verify GitHub App setup, run:" -ForegroundColor Cyan
        Write-Host "    .\system-setup\verify-github-app.ps1 -Verbose" -ForegroundColor White
    }
}

# Summary
Write-Host "`n╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Setup Complete!                         ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "📋 Next Steps:" -ForegroundColor Yellow
Write-Host ""

if (-not $authMethod) {
    Write-Host "  1. Choose authentication method:" -ForegroundColor White
    Write-Host "     • Personal Token: .\setup-github-workspace.ps1 -UsePersonalToken -Token 'ghp_xxx'" -ForegroundColor Gray
    Write-Host "     • GitHub App: .\setup-github-workspace.ps1 -UseGitHubApp" -ForegroundColor Gray
    Write-Host ""
}

Write-Host "  2. Review GitHub integration guide:" -ForegroundColor White
Write-Host "     GITHUB-INTEGRATION.md" -ForegroundColor Gray
Write-Host ""

if (-not $SkipMCP) {
    Write-Host "  3. Apply MCP configuration to Cursor:" -ForegroundColor White
    Write-Host "     .\system-setup\complete-setup.ps1" -ForegroundColor Gray
    Write-Host ""
}

Write-Host "  4. Verify setup:" -ForegroundColor White
Write-Host "     .\system-setup\verify-github-app.ps1 -Verbose" -ForegroundColor Gray
Write-Host ""

Write-Host "  5. Test GitHub Actions:" -ForegroundColor White
Write-Host "     git push origin <your-branch>" -ForegroundColor Gray
Write-Host ""

Write-Host "📚 Documentation:" -ForegroundColor Yellow
Write-Host "  • GITHUB-INTEGRATION.md - Complete integration guide" -ForegroundColor Gray
Write-Host "  • system-setup/GITHUB-APP-SETUP.md - GitHub App setup" -ForegroundColor Gray
Write-Host "  • system-setup/GITHUB-APP-QUICK-START.md - Quick start" -ForegroundColor Gray
Write-Host "  • .github/CONTRIBUTING.md - Contributing guidelines" -ForegroundColor Gray
Write-Host ""

Write-Host "✨ Happy coding!" -ForegroundColor Green
Write-Host ""
