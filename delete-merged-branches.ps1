<#
.SYNOPSIS
    Cleans up old and merged branches
.DESCRIPTION
    This script helps identify and delete branches that have been merged or are stale.
    It provides options to delete both local and remote branches safely.
.PARAMETER DryRun
    If true, only shows what would be deleted without actually deleting (default: true)
.PARAMETER IncludeRemote
    If true, also deletes remote branches (default: false)
.PARAMETER OlderThanDays
    Only consider branches older than this many days (default: 30)
.EXAMPLE
    .\delete-merged-branches.ps1
    .\delete-merged-branches.ps1 -DryRun $false
    .\delete-merged-branches.ps1 -DryRun $false -IncludeRemote $true
#>

param(
    [Parameter(Mandatory=$false)]
    [bool]$DryRun = $true,
    
    [Parameter(Mandatory=$false)]
    [bool]$IncludeRemote = $false,
    
    [Parameter(Mandatory=$false)]
    [int]$OlderThanDays = 30
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

# Check if we're in a git repository
if (-not (Test-Path ".git")) {
    Write-ColorOutput "[ERROR] Not in a git repository!" -Type Error
    exit 1
}

# Branches to never delete
$protectedBranches = @('main', 'master', 'develop', 'development')

Write-ColorOutput "=== Branch Cleanup Tool ===" -Type Info
if ($DryRun) {
    Write-ColorOutput "[DRY RUN] No branches will be deleted" -Type Warning
}

# Get current branch
$currentBranch = git rev-parse --abbrev-ref HEAD
Write-ColorOutput "`nCurrent branch: $currentBranch" -Type Info

# Get all local branches
Write-ColorOutput "`n[INFO] Fetching local branches..." -Type Info
$allBranches = git branch --format='%(refname:short)|%(committerdate:iso8601)' | ForEach-Object {
    $parts = $_ -split '\|'
    $dateValue = [DateTime]::Now
    if ($parts.Count -gt 1) {
        $parseSuccess = [DateTime]::TryParse($parts[1], [ref]$dateValue)
        if (-not $parseSuccess) {
            $dateValue = [DateTime]::Now
        }
    }
    [PSCustomObject]@{
        Name = $parts[0].Trim()
        Date = $dateValue
    }
}

# Get merged branches
Write-ColorOutput "[INFO] Checking for merged branches..." -Type Info
$mergedBranches = git branch --merged main 2>$null | ForEach-Object { $_.Trim().TrimStart('* ') }
if (-not $mergedBranches) {
    $mergedBranches = git branch --merged master 2>$null | ForEach-Object { $_.Trim().TrimStart('* ') }
}

# Find branches to delete
$branchesToDelete = @()
$cutoffDate = (Get-Date).AddDays(-$OlderThanDays)

foreach ($branch in $allBranches) {
    $branchName = $branch.Name
    
    # Skip protected branches and current branch
    if ($protectedBranches -contains $branchName -or $branchName -eq $currentBranch) {
        continue
    }
    
    # Check if merged
    $isMerged = $mergedBranches -contains $branchName
    
    # Check if old
    $isOld = $branch.Date -lt $cutoffDate
    
    if ($isMerged -or $isOld) {
        $reason = if ($isMerged) { "merged" } else { "older than $OlderThanDays days" }
        $branchesToDelete += [PSCustomObject]@{
            Name = $branchName
            Date = $branch.Date
            Reason = $reason
            IsMerged = $isMerged
        }
    }
}

# Display results
if ($branchesToDelete.Count -eq 0) {
    Write-ColorOutput "`n[INFO] No branches found for deletion" -Type Success
    exit 0
}

Write-ColorOutput "`n=== Branches to Delete ===" -Type Info
foreach ($branch in $branchesToDelete) {
    $status = if ($branch.IsMerged) { "✓ MERGED" } else { "⏰ OLD" }
    Write-ColorOutput "$status | $($branch.Name) | Last commit: $($branch.Date.ToString('yyyy-MM-dd'))" -Type Warning
}

Write-ColorOutput "`nTotal: $($branchesToDelete.Count) branches" -Type Info

if ($DryRun) {
    Write-ColorOutput "`n[DRY RUN] Run with -DryRun `$false to actually delete branches" -Type Warning
    exit 0
}

# Confirm deletion
Write-ColorOutput "`n[WARNING] Delete these branches? (y/N): " -Type Warning
$confirmation = Read-Host

if ($confirmation -ne 'y' -and $confirmation -ne 'Y') {
    Write-ColorOutput "[INFO] Operation cancelled" -Type Info
    exit 0
}

# Delete local branches
Write-ColorOutput "`n[INFO] Deleting local branches..." -Type Info
$deleted = 0
$failed = 0

foreach ($branch in $branchesToDelete) {
    try {
        git branch -D $branch.Name 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "[OK] Deleted local branch: $($branch.Name)" -Type Success
            $deleted++
        } else {
            Write-ColorOutput "[ERROR] Failed to delete $($branch.Name)" -Type Error
            $failed++
        }
    }
    catch {
        Write-ColorOutput "[ERROR] Failed to delete $($branch.Name): $_" -Type Error
        $failed++
    }
}

# Delete remote branches if requested
if ($IncludeRemote) {
    Write-ColorOutput "`n[INFO] Checking remote branches..." -Type Info
    
    foreach ($branch in $branchesToDelete) {
        try {
            # Check if remote branch exists
            $remoteBranch = git ls-remote --heads origin $branch.Name 2>&1
            if ($LASTEXITCODE -eq 0 -and $remoteBranch) {
                git push origin --delete $branch.Name 2>&1 | Out-Null
                if ($LASTEXITCODE -eq 0) {
                    Write-ColorOutput "[OK] Deleted remote branch: $($branch.Name)" -Type Success
                    $deleted++
                } else {
                    Write-ColorOutput "[ERROR] Failed to delete remote $($branch.Name)" -Type Error
                    $failed++
                }
            }
        }
        catch {
            Write-ColorOutput "[ERROR] Failed to delete remote $($branch.Name): $_" -Type Error
            $failed++
        }
    }
}

# Summary
Write-ColorOutput "`n=== Summary ===" -Type Info
Write-ColorOutput "Deleted: $deleted branches" -Type Success
if ($failed -gt 0) {
    Write-ColorOutput "Failed: $failed branches" -Type Error
}

Write-ColorOutput "`n[INFO] Branch cleanup complete!" -Type Success
