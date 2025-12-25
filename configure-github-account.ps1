# Configure GitHub Account Preference
# This script sets up Git to use a specific GitHub account by default
# Prevents GitHub from asking which account to choose

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("Mouy-leng", "A6-9V")]
    [string]$Account = "Mouy-leng",
    
    [switch]$SetGlobal
)

$ErrorActionPreference = "Stop"

Write-Host "`n╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Configure GitHub Account                ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "Setting default GitHub account to: $Account" -ForegroundColor Yellow
Write-Host ""

# Determine scope
$scope = if ($SetGlobal) { "--global" } else { "--local" }
$scopeName = if ($SetGlobal) { "global" } else { "this repository" }

Write-Host "[1/4] Configuring Git user..." -ForegroundColor Yellow

# Configure Git user based on selected account
switch ($Account) {
    "Mouy-leng" {
        $email = "Mouy-leng@users.noreply.github.com"
        $name = "Mouy-leng"
        Write-Host "  • Account: Mouy-leng (Personal)" -ForegroundColor Cyan
    }
    "A6-9V" {
        $email = "A6-9V@users.noreply.github.com"
        $name = "A6-9V"
        Write-Host "  • Account: A6-9V (Organization)" -ForegroundColor Cyan
    }
}

try {
    git config $scope user.name $name
    git config $scope user.email $email
    Write-Host "  ✓ Git user configured for $scopeName" -ForegroundColor Green
    Write-Host "    Name: $name" -ForegroundColor Gray
    Write-Host "    Email: $email" -ForegroundColor Gray
} catch {
    Write-Host "  ✗ Failed to configure Git user: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`n[2/4] Configuring Git credentials..." -ForegroundColor Yellow

# Set credential username to match account
try {
    git config $scope credential.username $name
    Write-Host "  ✓ Credential username set to: $name" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Could not set credential username: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Configure credential helper for Windows
try {
    if ($IsWindows -or $env:OS -match "Windows") {
        # Use Windows Credential Manager
        git config $scope credential.helper manager-core
        Write-Host "  ✓ Credential helper set to: manager-core (Windows Credential Manager)" -ForegroundColor Green
    } else {
        # For other systems, use default credential helper
        git config $scope credential.helper cache
        Write-Host "  ✓ Credential helper set to: cache" -ForegroundColor Green
    }
} catch {
    Write-Host "  ⚠ Could not configure credential helper: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host "`n[3/4] Setting GitHub-specific configuration..." -ForegroundColor Yellow

# Set GitHub-specific user for this repository's origin
try {
    $remote = git remote get-url origin 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Current remote: $remote" -ForegroundColor Green
        
        # Extract repository owner from remote URL
        if ($remote -match "github\.com[:/]([^/]+)/") {
            $repoOwner = $matches[1]
            Write-Host "    Repository owner: $repoOwner" -ForegroundColor Gray
            
            # If the repository owner doesn't match the selected account, warn user
            if ($repoOwner -ne $Account) {
                Write-Host "  ⚠ Warning: Repository owner ($repoOwner) differs from selected account ($Account)" -ForegroundColor Yellow
                Write-Host "    You may need to transfer the repository or use the correct account." -ForegroundColor Gray
            }
        }
    }
} catch {
    Write-Host "  ⚠ Could not check remote configuration" -ForegroundColor Yellow
}

# Configure GitHub protocol preference
try {
    git config $scope url."https://github.com/".insteadOf "git://github.com/"
    Write-Host "  ✓ Configured to use HTTPS for GitHub" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ Could not set GitHub protocol preference" -ForegroundColor Yellow
}

Write-Host "`n[4/4] Verifying configuration..." -ForegroundColor Yellow

# Display current configuration
try {
    $configUser = git config user.name
    $configEmail = git config user.email
    $configCredUsername = git config credential.username
    
    Write-Host "  Current Git Configuration:" -ForegroundColor Cyan
    Write-Host "    User Name: $configUser" -ForegroundColor Gray
    Write-Host "    Email: $configEmail" -ForegroundColor Gray
    Write-Host "    Credential Username: $configCredUsername" -ForegroundColor Gray
} catch {
    Write-Host "  ⚠ Could not verify configuration" -ForegroundColor Yellow
}

Write-Host "`n╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Configuration Complete!                 ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "📝 Summary:" -ForegroundColor Yellow
Write-Host "  • Default GitHub account set to: $Account" -ForegroundColor White
Write-Host "  • Scope: $scopeName" -ForegroundColor White
Write-Host "  • Git will now use this account for commits and authentication" -ForegroundColor White
Write-Host ""

Write-Host "💡 Tips:" -ForegroundColor Yellow
Write-Host "  • To use globally: .\configure-github-account.ps1 -Account $Account -SetGlobal" -ForegroundColor Gray
Write-Host "  • To switch accounts: .\configure-github-account.ps1 -Account <AccountName>" -ForegroundColor Gray
Write-Host "  • Accounts available: Mouy-leng, A6-9V" -ForegroundColor Gray
Write-Host ""

Write-Host "🔐 Next Steps:" -ForegroundColor Yellow
Write-Host "  1. If prompted for credentials, enter your GitHub Personal Access Token" -ForegroundColor White
Write-Host "  2. The credentials will be saved in Windows Credential Manager" -ForegroundColor White
Write-Host "  3. You won't be asked to choose accounts again" -ForegroundColor White
Write-Host ""
