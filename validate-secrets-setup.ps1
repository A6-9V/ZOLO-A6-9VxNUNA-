#!/usr/bin/env pwsh
# validate-secrets-setup.ps1
# Validates that all GitHub Secrets setup files are in place

<#
.SYNOPSIS
    Validates the GitHub Secrets setup configuration.

.DESCRIPTION
    This script checks that all necessary files for GitHub Secrets
    setup are present and properly configured.
#>

$ErrorActionPreference = "Continue"

function Write-CheckResult {
    param(
        [string]$Item,
        [bool]$Status,
        [string]$Details = ""
    )
    
    if ($Status) {
        Write-Host "  ✓ $Item" -ForegroundColor Green
    }
    else {
        Write-Host "  ✗ $Item" -ForegroundColor Red
    }
    
    if ($Details) {
        Write-Host "    $Details" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "=== GitHub Secrets Setup Validation ===" -ForegroundColor Cyan
Write-Host ""

# Check required files
Write-Host "Checking required files..." -ForegroundColor Yellow

$requiredFiles = @(
    @{Path = "GITHUB-SECRETS-SETUP.md"; Description = "Main setup documentation"},
    @{Path = "GITHUB-SECRETS-QUICK-REF.md"; Description = "Quick reference guide"},
    @{Path = "setup-github-secrets.ps1"; Description = "PowerShell automation script"},
    @{Path = "SETUP-GITHUB-SECRETS.bat"; Description = "Windows batch wrapper"},
    @{Path = ".github/workflows/oauth-example.yml"; Description = "Example workflow file"}
)

$filesOk = $true
foreach ($file in $requiredFiles) {
    $exists = Test-Path $file.Path
    Write-CheckResult -Item $file.Description -Status $exists -Details $file.Path
    $filesOk = $filesOk -and $exists
}

Write-Host ""

# Check README.md updates
Write-Host "Checking README.md updates..." -ForegroundColor Yellow

$readmeContent = Get-Content "README.md" -Raw -ErrorAction SilentlyContinue

if ($readmeContent) {
    $hasSecretsSection = $readmeContent -match "GitHub Secrets"
    Write-CheckResult -Item "GitHub Secrets mentioned in README" -Status $hasSecretsSection
    
    $hasSecretsDoc = $readmeContent -match "GITHUB-SECRETS-SETUP\.md"
    Write-CheckResult -Item "Documentation link in README" -Status $hasSecretsDoc
    
    $hasActionsFeature = $readmeContent -match "GitHub Actions"
    Write-CheckResult -Item "GitHub Actions feature listed" -Status $hasActionsFeature
}
else {
    Write-CheckResult -Item "README.md exists" -Status $false
}

Write-Host ""

# Check .gitignore for secrets protection
Write-Host "Checking .gitignore for secret protection..." -ForegroundColor Yellow

$gitignoreContent = Get-Content ".gitignore" -Raw -ErrorAction SilentlyContinue

if ($gitignoreContent) {
    $hasSecretPattern = $gitignoreContent -match "\*\.secret"
    Write-CheckResult -Item "*.secret pattern" -Status $hasSecretPattern
    
    $hasTokenPattern = $gitignoreContent -match "\*\.token"
    Write-CheckResult -Item "*.token pattern" -Status $hasTokenPattern
    
    $hasCredentialsPattern = $gitignoreContent -match "\*credentials\*"
    Write-CheckResult -Item "*credentials* pattern" -Status $hasCredentialsPattern
    
    $hasSecretsDir = $gitignoreContent -match "Secrets/"
    Write-CheckResult -Item "Secrets/ directory" -Status $hasSecretsDir
}
else {
    Write-CheckResult -Item ".gitignore exists" -Status $false
}

Write-Host ""

# Validate workflow file syntax
Write-Host "Validating workflow file..." -ForegroundColor Yellow

$workflowPath = ".github/workflows/oauth-example.yml"
if (Test-Path $workflowPath) {
    $workflowContent = Get-Content $workflowPath -Raw
    
    $hasSecretRef = $workflowContent -match "secrets\.CLIENT_ID" -and $workflowContent -match "secrets\.CLIENT_SECRET"
    Write-CheckResult -Item "Secret references present" -Status $hasSecretRef
    
    $hasJobName = $workflowContent -match "jobs:"
    Write-CheckResult -Item "Valid job definition" -Status $hasJobName
    
    $hasSteps = $workflowContent -match "steps:"
    Write-CheckResult -Item "Steps defined" -Status $hasSteps
}
else {
    Write-CheckResult -Item "Workflow file exists" -Status $false
}

Write-Host ""

# Check script executability
Write-Host "Checking script files..." -ForegroundColor Yellow

if (Test-Path "setup-github-secrets.ps1") {
    $scriptContent = Get-Content "setup-github-secrets.ps1" -Raw
    
    $hasClientId = $scriptContent -match 'ClientId.*=.*"Ov23liVH34OCl6XkcrH6"'
    Write-CheckResult -Item "Client ID configured" -Status $hasClientId
    
    $hasClientSecret = $scriptContent -match "ClientSecret.*=.*`"666665669ac851c05533d8ee472d64cbd2061eba`""
    Write-CheckResult -Item "Client Secret configured" -Status $hasClientSecret
    
    $hasRepo = $scriptContent -match "Mouy-leng/ZOLO-A6-9VxNUNA-"
    Write-CheckResult -Item "Repository configured" -Status $hasRepo
}

Write-Host ""

# Summary
Write-Host "=== Validation Summary ===" -ForegroundColor Cyan

if ($filesOk -and $hasSecretsSection -and $hasSecretPattern) {
    Write-Host ""
    Write-Host "✓ All checks passed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "GitHub Secrets setup is properly configured." -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Run: .\setup-github-secrets.ps1" -ForegroundColor Cyan
    Write-Host "  2. Or use: gh secret set commands manually" -ForegroundColor Cyan
    Write-Host "  3. Verify: gh secret list" -ForegroundColor Cyan
    Write-Host ""
    exit 0
}
else {
    Write-Host ""
    Write-Host "✗ Some checks failed." -ForegroundColor Red
    Write-Host "Please review the errors above." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}
