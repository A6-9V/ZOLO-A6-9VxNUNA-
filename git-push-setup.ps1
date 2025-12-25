#Requires -Version 5.1
<#
.SYNOPSIS
    Add, commit, and push EXNESS setup files to git
.DESCRIPTION
    Stages all new EXNESS setup files, commits them, and pushes to remote repository
#>

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Git Push - EXNESS Setup Files" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Change to workspace directory
$workspacePath = "C:\Users\USER\OneDrive"
Set-Location $workspacePath

# Check if this is a git repository
if (-not (Test-Path ".git")) {
    Write-Host "[ERROR] This is not a git repository!" -ForegroundColor Red
    Write-Host "[INFO] Initializing git repository..." -ForegroundColor Yellow
    git init
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to initialize git repository" -ForegroundColor Red
        exit 1
    }
}

# Check git status
Write-Host "[1/4] Checking git status..." -ForegroundColor Yellow
$status = git status --porcelain
if ($status) {
    Write-Host "    Files to commit:" -ForegroundColor Cyan
    $status | ForEach-Object { Write-Host "      $_" -ForegroundColor White }
}
else {
    Write-Host "    [INFO] No changes to commit" -ForegroundColor Cyan
}

# Show remotes
Write-Host ""
Write-Host "[2/4] Checking git remotes..." -ForegroundColor Yellow
$remotes = git remote -v
if ($remotes) {
    Write-Host "    Remotes configured:" -ForegroundColor Cyan
    $remotes | ForEach-Object { Write-Host "      $_" -ForegroundColor White }
}
else {
    Write-Host "    [WARNING] No remotes configured" -ForegroundColor Yellow
    Write-Host "    [INFO] You may need to add a remote: git remote add origin <url>" -ForegroundColor Cyan
}

# Add all files
Write-Host ""
Write-Host "[3/4] Adding files to git..." -ForegroundColor Yellow
git add .

if ($LASTEXITCODE -eq 0) {
    Write-Host "    [OK] Files staged successfully" -ForegroundColor Green
}
else {
    Write-Host "    [ERROR] Failed to stage files" -ForegroundColor Red
    exit 1
}

# Commit
Write-Host ""
Write-Host "[4/4] Committing changes..." -ForegroundColor Yellow
$commitMessage = "Add EXNESS complete setup guide, automation scripts, and documentation

- Added EXNESS-COMPLETE-SETUP-GUIDE.md (comprehensive setup guide)
- Added EXNESS-QUICK-REFERENCE.md (quick reference card)
- Added EXNESS-SETUP-COMPLETED.md (setup completion summary)
- Added AUTO-SETUP-EXNESS-ALL.ps1 (automated setup script)
- Added setup-exness-complete.ps1 (alternative setup script)
- Added git-push-setup.ps1 (git automation script)

Includes:
- EXNESS Terminal installation and configuration
- App settings (color and symbol configuration)
- Expert Advisor (EA) setup and compilation
- VPS setup for 24/7 trading
- Complete automation scripts"

git commit -m $commitMessage

if ($LASTEXITCODE -eq 0) {
    Write-Host "    [OK] Changes committed successfully" -ForegroundColor Green
}
else {
    Write-Host "    [WARNING] Commit may have failed or no changes to commit" -ForegroundColor Yellow
}

# Push to remote
Write-Host ""
Write-Host "[5/5] Pushing to remote repository..." -ForegroundColor Yellow

# Get default branch name
$branch = git branch --show-current
if (-not $branch) {
    $branch = "main"
    # Try to create main branch if it doesn't exist
    git branch -M main 2>&1 | Out-Null
}

# Try to push
$pushResult = git push -u origin $branch 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "    [OK] Successfully pushed to remote repository" -ForegroundColor Green
}
else {
    # Check if remote exists
    $remotes = git remote -v
    if (-not $remotes) {
        Write-Host "    [WARNING] No remote repository configured" -ForegroundColor Yellow
        Write-Host "    [INFO] To add a remote: git remote add origin <repository-url>" -ForegroundColor Cyan
        Write-Host "    [INFO] Then run: git push -u origin $branch" -ForegroundColor Cyan
    }
    else {
        Write-Host "    [WARNING] Push may have failed. Error:" -ForegroundColor Yellow
        Write-Host "    $pushResult" -ForegroundColor Red
        Write-Host "    [INFO] You may need to:" -ForegroundColor Cyan
        Write-Host "      1. Set up remote: git remote add origin <url>" -ForegroundColor White
        Write-Host "      2. Or pull first: git pull origin $branch --allow-unrelated-histories" -ForegroundColor White
        Write-Host "      3. Then push: git push -u origin $branch" -ForegroundColor White
    }
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Git Operations Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Show final status
Write-Host "Current branch: $branch" -ForegroundColor Cyan
Write-Host ""

# Show what was committed
$lastCommit = git log -1 --oneline 2>&1
if ($lastCommit -and $lastCommit -notmatch "fatal") {
    Write-Host "Last commit:" -ForegroundColor Cyan
    Write-Host "  $lastCommit" -ForegroundColor White
}

Write-Host ""
Write-Host "Script execution completed." -ForegroundColor Green

