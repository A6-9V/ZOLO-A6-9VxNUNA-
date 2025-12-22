#!/usr/bin/env pwsh
# setup-github-secrets.ps1
# Automated script to set up GitHub repository secrets using GitHub CLI

<#
.SYNOPSIS
    Sets up GitHub OAuth credentials as repository secrets.

.DESCRIPTION
    This script automates the process of setting up CLIENT_ID and CLIENT_SECRET
    as GitHub repository secrets using the GitHub CLI (gh).

.NOTES
    Requirements:
    - GitHub CLI (gh) must be installed
    - User must be authenticated with gh (run 'gh auth login')
    - User must have admin access to the repository
#>

# Script configuration
$ErrorActionPreference = "Stop"
$RepoName = "Mouy-leng/ZOLO-A6-9VxNUNA-"

# OAuth credentials
$ClientId = "Ov23liVH34OCl6XkcrH6"
$ClientSecret = "666665669ac851c05533d8ee472d64cbd2061eba"

function Write-Status {
    param(
        [string]$Message,
        [string]$Type = "Info"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    switch ($Type) {
        "Success" { Write-Host "[$timestamp] [✓] $Message" -ForegroundColor Green }
        "Error"   { Write-Host "[$timestamp] [✗] $Message" -ForegroundColor Red }
        "Warning" { Write-Host "[$timestamp] [!] $Message" -ForegroundColor Yellow }
        default   { Write-Host "[$timestamp] [i] $Message" -ForegroundColor Cyan }
    }
}

function Test-GitHubCLI {
    Write-Status "Checking GitHub CLI installation..."
    
    try {
        $ghVersion = gh --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Status "GitHub CLI is installed" -Type "Success"
            return $true
        }
    }
    catch {
        Write-Status "GitHub CLI is not installed" -Type "Error"
        Write-Status "Please install GitHub CLI from: https://cli.github.com/" -Type "Warning"
        return $false
    }
    
    return $false
}

function Test-GitHubAuth {
    Write-Status "Checking GitHub CLI authentication..."
    
    try {
        $authStatus = gh auth status 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Status "GitHub CLI is authenticated" -Type "Success"
            return $true
        }
    }
    catch {
        Write-Status "GitHub CLI is not authenticated" -Type "Error"
        Write-Status "Please run: gh auth login" -Type "Warning"
        return $false
    }
    
    return $false
}

function Set-GitHubSecret {
    param(
        [string]$SecretName,
        [string]$SecretValue,
        [string]$Repository
    )
    
    Write-Status "Setting secret: $SecretName"
    
    try {
        # Set the secret using gh CLI
        $result = echo $SecretValue | gh secret set $SecretName --repo $Repository 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Status "Secret '$SecretName' set successfully" -Type "Success"
            return $true
        }
        else {
            Write-Status "Failed to set secret '$SecretName': $result" -Type "Error"
            return $false
        }
    }
    catch {
        Write-Status "Error setting secret '$SecretName': $_" -Type "Error"
        return $false
    }
}

function Get-GitHubSecrets {
    param(
        [string]$Repository
    )
    
    Write-Status "Listing repository secrets..."
    
    try {
        gh secret list --repo $Repository
        
        if ($LASTEXITCODE -eq 0) {
            Write-Status "Secrets listed successfully" -Type "Success"
            return $true
        }
        else {
            Write-Status "Failed to list secrets" -Type "Warning"
            return $false
        }
    }
    catch {
        Write-Status "Error listing secrets: $_" -Type "Error"
        return $false
    }
}

# Main execution
Write-Status "=== GitHub Secrets Setup ===" -Type "Info"
Write-Status "Repository: $RepoName" -Type "Info"
Write-Host ""

# Check prerequisites
if (-not (Test-GitHubCLI)) {
    Write-Status "GitHub CLI is required. Exiting." -Type "Error"
    exit 1
}

if (-not (Test-GitHubAuth)) {
    Write-Status "Please authenticate with GitHub CLI first: gh auth login" -Type "Error"
    exit 1
}

Write-Host ""

# Set secrets
Write-Status "Setting up OAuth credentials as repository secrets..." -Type "Info"
Write-Host ""

$clientIdSet = Set-GitHubSecret -SecretName "CLIENT_ID" -SecretValue $ClientId -Repository $RepoName
$clientSecretSet = Set-GitHubSecret -SecretName "CLIENT_SECRET" -SecretValue $ClientSecret -Repository $RepoName

Write-Host ""

# Verify secrets
Write-Status "Verifying secrets..." -Type "Info"
Get-GitHubSecrets -Repository $RepoName

Write-Host ""

# Summary
if ($clientIdSet -and $clientSecretSet) {
    Write-Status "=== Setup Complete ===" -Type "Success"
    Write-Status "✓ CLIENT_ID configured" -Type "Success"
    Write-Status "✓ CLIENT_SECRET configured" -Type "Success"
    Write-Host ""
    Write-Status "Secrets are now available in GitHub Actions workflows!" -Type "Success"
    Write-Status "See GITHUB-SECRETS-SETUP.md for usage examples." -Type "Info"
    exit 0
}
else {
    Write-Status "=== Setup Failed ===" -Type "Error"
    Write-Status "Some secrets could not be configured." -Type "Error"
    Write-Status "Please check the error messages above." -Type "Warning"
    exit 1
}
