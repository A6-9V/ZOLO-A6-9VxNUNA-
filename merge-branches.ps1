<#
.SYNOPSIS
    Automates the process of merging branches using GitHub CLI
.DESCRIPTION
    This script helps merge feature branches into main using GitHub CLI (gh).
    It lists open PRs, allows selection, and performs the merge operation.
.PARAMETER PRNumber
    The pull request number to merge (optional, will prompt if not provided)
.PARAMETER MergeMethod
    The merge method to use: merge, squash, or rebase (default: merge)
.PARAMETER DeleteBranch
    Whether to delete the branch after merging (default: true)
.EXAMPLE
    .\merge-branches.ps1
    .\merge-branches.ps1 -PRNumber 6 -MergeMethod squash
    .\merge-branches.ps1 -PRNumber 6 -DeleteBranch $false
#>

param(
    [Parameter(Mandatory=$false)]
    [int]$PRNumber,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet('merge', 'squash', 'rebase')]
    [string]$MergeMethod = 'merge',
    
    [Parameter(Mandatory=$false)]
    [bool]$DeleteBranch = $true
)

# Color codes for output
function Write-ColorOutput {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('Info', 'Success', 'Warning', 'Error')]
        [string]$Type = 'Info'
    )
    
    switch ($Type) {
        'Info'    { Write-Host $Message -ForegroundColor Cyan }
        'Success' { Write-Host $Message -ForegroundColor Green }
        'Warning' { Write-Host $Message -ForegroundColor Yellow }
        'Error'   { Write-Host $Message -ForegroundColor Red }
    }
}

# Check if gh CLI is installed
Write-ColorOutput "[INFO] Checking for GitHub CLI..." -Type Info
$ghInstalled = Get-Command gh -ErrorAction SilentlyContinue
if (-not $ghInstalled) {
    Write-ColorOutput "[ERROR] GitHub CLI (gh) is not installed!" -Type Error
    Write-ColorOutput "Please install it from: https://cli.github.com/" -Type Warning
    exit 1
}

Write-ColorOutput "[OK] GitHub CLI is installed" -Type Success

# Check if we're in a git repository
if (-not (Test-Path ".git")) {
    Write-ColorOutput "[ERROR] Not in a git repository!" -Type Error
    exit 1
}

# List open PRs if no PR number provided
if (-not $PRNumber) {
    Write-ColorOutput "`n=== Open Pull Requests ===" -Type Info
    try {
        $openPRs = gh pr list --state open --json number,title,headRefName,author | ConvertFrom-Json
        
        if ($openPRs.Count -eq 0) {
            Write-ColorOutput "[INFO] No open pull requests found." -Type Info
            exit 0
        }
        
        foreach ($pr in $openPRs) {
            Write-ColorOutput "PR #$($pr.number): $($pr.title)" -Type Info
            $authorName = if ($pr.author -and $pr.author.login) { $pr.author.login } else { "[deleted user]" }
            Write-ColorOutput "  Branch: $($pr.headRefName) | Author: $authorName" -Type Info
        }
        
        Write-ColorOutput "`nEnter PR number to merge (or 'q' to quit): " -Type Warning
        $input = Read-Host
        
        if ($input -eq 'q' -or $input -eq 'Q') {
            Write-ColorOutput "[INFO] Operation cancelled" -Type Info
            exit 0
        }
        
        $PRNumber = [int]$input
    }
    catch {
        Write-ColorOutput "[ERROR] Failed to list pull requests: $_" -Type Error
        exit 1
    }
}

# Get PR details
Write-ColorOutput "`n[INFO] Fetching PR #$PRNumber details..." -Type Info
try {
    $prInfo = gh pr view $PRNumber --json number,title,headRefName,baseRefName,mergeable,author | ConvertFrom-Json
    
    Write-ColorOutput "`n=== PR Details ===" -Type Info
    Write-ColorOutput "Number: #$($prInfo.number)" -Type Info
    Write-ColorOutput "Title: $($prInfo.title)" -Type Info
    $authorName = if ($prInfo.author -and $prInfo.author.login) { $prInfo.author.login } else { "[deleted user]" }
    Write-ColorOutput "Author: $authorName" -Type Info
    Write-ColorOutput "Branch: $($prInfo.headRefName) -> $($prInfo.baseRefName)" -Type Info
    Write-ColorOutput "Mergeable: $($prInfo.mergeable)" -Type Info
    
    if ($prInfo.mergeable -eq "CONFLICTING") {
        Write-ColorOutput "[WARNING] This PR has merge conflicts!" -Type Warning
        Write-ColorOutput "[INFO] Please resolve conflicts before merging." -Type Info
        exit 1
    }
}
catch {
    Write-ColorOutput "[ERROR] Failed to get PR details: $_" -Type Error
    exit 1
}

# Confirm merge
Write-ColorOutput "`n[WARNING] Are you sure you want to merge PR #$PRNumber? (y/N): " -Type Warning
$confirmation = Read-Host

if ($confirmation -ne 'y' -and $confirmation -ne 'Y') {
    Write-ColorOutput "[INFO] Merge cancelled" -Type Info
    exit 0
}

# Perform merge
Write-ColorOutput "`n[INFO] Merging PR #$PRNumber using $MergeMethod method..." -Type Info
try {
    $mergeArgs = @(
        'pr', 'merge', $PRNumber,
        "--$MergeMethod"
    )
    
    if ($DeleteBranch) {
        $mergeArgs += '--delete-branch'
    }
    
    & gh @mergeArgs
    
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput "`n[ERROR] Failed to merge PR #$PRNumber" -Type Error
        Write-ColorOutput "GitHub CLI returned exit code: $LASTEXITCODE" -Type Error
        exit 1
    }
    
    Write-ColorOutput "`n[SUCCESS] PR #$PRNumber merged successfully!" -Type Success
    
    if ($DeleteBranch) {
        Write-ColorOutput "[SUCCESS] Branch $($prInfo.headRefName) deleted" -Type Success
    }
}
catch {
    Write-ColorOutput "[ERROR] Failed to merge PR: $_" -Type Error
    exit 1
}

Write-ColorOutput "`n[INFO] Operation complete!" -Type Success
