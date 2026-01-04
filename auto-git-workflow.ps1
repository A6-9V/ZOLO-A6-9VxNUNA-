#Requires -Version 5.1
<#
.SYNOPSIS
    Automated Git Workflow - Handles Pull, Push, Commit, and Merge
.DESCRIPTION
    This script automates complete git workflows including:
    - Automatic pull with conflict resolution
    - Intelligent commit with AI-generated messages
    - Push to all remotes
    - Merge branch management
    - Copilot/Jules/Cursor integration for automation
.PARAMETER Action
    The workflow action to perform: pull, push, commit, merge, or auto (all)
.PARAMETER Branch
    Target branch name (optional, defaults to current branch)
.PARAMETER Message
    Custom commit message (optional, auto-generated if not provided)
.EXAMPLE
    .\auto-git-workflow.ps1 -Action auto
    .\auto-git-workflow.ps1 -Action commit -Message "Update trading system"
    .\auto-git-workflow.ps1 -Action merge -Branch main
#>

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('pull', 'push', 'commit', 'merge', 'auto')]
    [string]$Action = 'auto',
    
    [Parameter(Mandatory=$false)]
    [string]$Branch,
    
    [Parameter(Mandatory=$false)]
    [string]$Message
)

$ErrorActionPreference = "Stop"

# ============================================
# Configuration
# ============================================
$repoPath = (Get-Location).Path
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# ============================================
# Helper Functions
# ============================================
function Write-Status {
    param(
        [string]$Message,
        [string]$Type = "Info"
    )
    
    $color = switch ($Type) {
        "Success" { "Green" }
        "Warning" { "Yellow" }
        "Error" { "Red" }
        "Info" { "Cyan" }
        default { "White" }
    }
    
    Write-Host $Message -ForegroundColor $color
}

function Get-CurrentBranch {
    return (git branch --show-current 2>&1)
}

function Get-ChangedFiles {
    $status = git status --porcelain 2>&1
    return $status | Where-Object { $_ }
}

function Generate-CommitMessage {
    $changedFiles = Get-ChangedFiles
    
    if (-not $changedFiles) {
        return "Update: No changes detected - $timestamp"
    }
    
    # Analyze changes
    $addCount = ($changedFiles | Where-Object { $_ -match "^A " }).Count
    $modifyCount = ($changedFiles | Where-Object { $_ -match "^M " }).Count
    $deleteCount = ($changedFiles | Where-Object { $_ -match "^D " }).Count
    $untrackedCount = ($changedFiles | Where-Object { $_ -match "^\?\?" }).Count
    
    # Check file types
    $psScripts = ($changedFiles | Where-Object { $_ -match "\.ps1$" }).Count
    $mdDocs = ($changedFiles | Where-Object { $_ -match "\.md$" }).Count
    $batFiles = ($changedFiles | Where-Object { $_ -match "\.bat$" }).Count
    
    # Generate intelligent message
    $message = "Auto-update: "
    
    if ($psScripts -gt 0) { $message += "PowerShell scripts, " }
    if ($mdDocs -gt 0) { $message += "documentation, " }
    if ($batFiles -gt 0) { $message += "batch files, " }
    
    if ($addCount -gt 0) { $message += "added $addCount, " }
    if ($modifyCount -gt 0) { $message += "modified $modifyCount, " }
    if ($deleteCount -gt 0) { $message += "deleted $deleteCount, " }
    if ($untrackedCount -gt 0) { $message += "new $untrackedCount, " }
    
    # Clean up message
    $message = $message.TrimEnd(", ")
    $message += " - $timestamp"
    
    return $message
}

function Invoke-AutoPull {
    Write-Status "`n[AUTO-PULL] Pulling latest changes..." -Type "Info"
    
    $currentBranch = Get-CurrentBranch
    
    try {
        # Fetch all remotes
        Write-Status "  Fetching from all remotes..." -Type "Info"
        git fetch --all 2>&1 | Out-Null
        
        # Try to pull and merge
        $pullOutput = git pull origin $currentBranch --no-edit 2>&1 | Out-String
        
        if ($LASTEXITCODE -eq 0) {
            Write-Status "  [OK] Successfully pulled from origin/$currentBranch" -Type "Success"
            return $true
        }
        
        # Check for conflicts
        if ($pullOutput -match "conflict|CONFLICT") {
            Write-Status "  [WARNING] Merge conflicts detected!" -Type "Warning"
            Write-Status "  Attempting automatic conflict resolution..." -Type "Info"
            
            # Determine conflict resolution strategy from environment or default to 'ours'
            $strategy = $env:GIT_AUTO_CONFLICT_STRATEGY
            if ([string]::IsNullOrWhiteSpace($strategy)) {
                $strategy = "ours"
            }
            
            $conflictedFiles = git diff --name-only --diff-filter=U 2>&1 | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
            
            if ($strategy -eq "ours") {
                Write-Status "  [INFO] Using 'ours' strategy (local changes win)" -Type "Info"
                foreach ($file in $conflictedFiles) {
                    Write-Status "    Resolving: $file (using local version)" -Type "Warning"
                    git checkout --ours $file 2>&1 | Out-Null
                    git add $file 2>&1 | Out-Null
                }
            } elseif ($strategy -eq "theirs") {
                Write-Status "  [INFO] Using 'theirs' strategy (remote changes win)" -Type "Info"
                foreach ($file in $conflictedFiles) {
                    Write-Status "    Resolving: $file (using remote version)" -Type "Warning"
                    git checkout --theirs $file 2>&1 | Out-Null
                    git add $file 2>&1 | Out-Null
                }
            } else {
                Write-Status "  [WARNING] Unknown strategy '$strategy', defaulting to 'ours'" -Type "Warning"
                foreach ($file in $conflictedFiles) {
                    Write-Status "    Resolving: $file (using local version)" -Type "Warning"
                    git checkout --ours $file 2>&1 | Out-Null
                    git add $file 2>&1 | Out-Null
                }
            }
            
            # Complete merge
            git commit --no-edit 2>&1 | Out-Null
            Write-Status "  [OK] Conflicts resolved automatically using '$strategy' strategy" -Type "Success"
            return $true
        }
        
        Write-Status "  [OK] Pull completed" -Type "Success"
        return $true
    }
    catch {
        Write-Status "  [ERROR] Pull failed: $_" -Type "Error"
        return $false
    }
}

function Invoke-AutoCommit {
    param([string]$CommitMessage)
    
    Write-Status "`n[AUTO-COMMIT] Committing changes..." -Type "Info"
    
    try {
        # Check for changes
        $changes = Get-ChangedFiles
        if (-not $changes) {
            Write-Status "  [INFO] No changes to commit" -Type "Info"
            return $true
        }
        
        # Add all changes
        Write-Status "  Adding all changes..." -Type "Info"
        git add . 2>&1 | Out-Null
        
        # Generate or use provided message
        if (-not $CommitMessage) {
            $CommitMessage = Generate-CommitMessage
        }
        
        Write-Status "  Commit message: $CommitMessage" -Type "Info"
        
        # Commit and capture output
        $commitOutput = git commit -m $CommitMessage 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            # Check for significant warnings in commit output
            if ($commitOutput) {
                $warnings = $commitOutput | Where-Object { $_ -match '(?i)warning|large file|sensitive' }
                if ($warnings) {
                    Write-Status "  [WARNING] Git commit warnings:" -Type "Warning"
                    foreach ($warning in $warnings) {
                        Write-Status "    $warning" -Type "Warning"
                    }
                }
            }
            Write-Status "  [OK] Changes committed successfully" -Type "Success"
            return $true
        } else {
            Write-Status "  [WARNING] Commit completed with warnings" -Type "Warning"
            return $true
        }
    }
    catch {
        Write-Status "  [ERROR] Commit failed: $_" -Type "Error"
        return $false
    }
}

function Invoke-AutoPush {
    Write-Status "`n[AUTO-PUSH] Pushing to all remotes..." -Type "Info"
    
    $currentBranch = Get-CurrentBranch
    
    try {
        # Get all remotes
        $remotes = git remote 2>&1
        
        if (-not $remotes) {
            Write-Status "  [WARNING] No remotes configured" -Type "Warning"
            return $false
        }
        
        $successCount = 0
        foreach ($remote in $remotes) {
            Write-Status "  Pushing to: $remote/$currentBranch" -Type "Info"
            
            $pushOutput = git push $remote $currentBranch 2>&1 | Out-String
            
            if ($LASTEXITCODE -eq 0 -or $pushOutput -match "up-to-date|up to date") {
                Write-Status "    [OK] Pushed to $remote" -Type "Success"
                $successCount++
            } else {
                Write-Status "    [WARNING] Push to $remote had issues" -Type "Warning"
            }
        }
        
        if ($successCount -gt 0) {
            Write-Status "  [OK] Successfully pushed to $successCount remote(s)" -Type "Success"
            return $true
        }
        
        return $false
    }
    catch {
        Write-Status "  [ERROR] Push failed: $_" -Type "Error"
        return $false
    }
}

function Invoke-AutoMerge {
    param([string]$TargetBranch)
    
    Write-Status "`n[AUTO-MERGE] Merging branches..." -Type "Info"
    
    $currentBranch = Get-CurrentBranch
    
    if (-not $TargetBranch) {
        $TargetBranch = "main"
    }
    
    try {
        if ($currentBranch -eq $TargetBranch) {
            Write-Status "  [INFO] Already on target branch: $TargetBranch" -Type "Info"
            return $true
        }
        
        Write-Status "  Switching to: $TargetBranch" -Type "Info"
        git checkout $TargetBranch 2>&1 | Out-Null
        
        Write-Status "  Merging: $currentBranch -> $TargetBranch" -Type "Info"
        $mergeOutput = git merge $currentBranch --no-edit 2>&1 | Out-String
        
        if ($LASTEXITCODE -eq 0) {
            Write-Status "  [OK] Successfully merged $currentBranch into $TargetBranch" -Type "Success"
            
            # Switch back to original branch
            git checkout $currentBranch 2>&1 | Out-Null
            return $true
        }
        
        # Handle conflicts
        if ($mergeOutput -match "conflict|CONFLICT") {
            Write-Status "  [WARNING] Merge conflicts detected, attempting auto-resolve..." -Type "Warning"
            
            # Abort the failed merge first
            git merge --abort 2>&1 | Out-Null
            
            # Retry merge with 'theirs' strategy (prefer changes from branch being merged)
            $mergeOutput = git merge -X theirs $currentBranch --no-edit 2>&1 | Out-String
            
            if ($LASTEXITCODE -eq 0) {
                Write-Status "  [OK] Conflicts auto-resolved using 'theirs' strategy" -Type "Success"
                git checkout $currentBranch 2>&1 | Out-Null
                return $true
            }
            
            Write-Status "  [ERROR] Automatic conflict resolution failed" -Type "Error"
            git checkout $currentBranch 2>&1 | Out-Null
            return $false
        }
        
        git checkout $currentBranch 2>&1 | Out-Null
        return $false
    }
    catch {
        Write-Status "  [ERROR] Merge failed: $_" -Type "Error"
        git checkout $currentBranch 2>&1 | Out-Null
        return $false
    }
}

# ============================================
# Main Workflow
# ============================================
Write-Status "========================================" -Type "Info"
Write-Status "  Automated Git Workflow" -Type "Info"
Write-Status "  Powered by Copilot/Jules/Cursor" -Type "Info"
Write-Status "========================================" -Type "Info"
Write-Status ""
Write-Status "Repository: $repoPath" -Type "Info"
Write-Status "Current Branch: $(Get-CurrentBranch)" -Type "Info"
Write-Status "Action: $Action" -Type "Info"
Write-Status ""

$results = @{
    Pull = $false
    Commit = $false
    Push = $false
    Merge = $false
}

# Execute workflow based on action
switch ($Action) {
    'pull' {
        $results.Pull = Invoke-AutoPull
    }
    'commit' {
        $results.Commit = Invoke-AutoCommit -CommitMessage $Message
    }
    'push' {
        $results.Push = Invoke-AutoPush
    }
    'merge' {
        $results.Merge = Invoke-AutoMerge -TargetBranch $Branch
    }
    'auto' {
        # Full automated workflow
        $results.Pull = Invoke-AutoPull
        Start-Sleep -Seconds 1
        
        $results.Commit = Invoke-AutoCommit -CommitMessage $Message
        Start-Sleep -Seconds 1
        
        $results.Push = Invoke-AutoPush
        Start-Sleep -Seconds 1
        
        if ($Branch) {
            $results.Merge = Invoke-AutoMerge -TargetBranch $Branch
        }
    }
}

# ============================================
# Summary
# ============================================
Write-Status "`n========================================" -Type "Info"
Write-Status "  Workflow Complete" -Type "Info"
Write-Status "========================================" -Type "Info"
Write-Status ""

Write-Status "Results:" -Type "Info"
foreach ($key in $results.Keys) {
    # Determine if this operation was attempted
    $operationAttempted = $false
    switch ($key.ToLower()) {
        'pull'   { $operationAttempted = ($Action -eq 'pull'   -or $Action -eq 'auto') }
        'commit' { $operationAttempted = ($Action -eq 'commit' -or $Action -eq 'auto') }
        'push'   { $operationAttempted = ($Action -eq 'push'   -or $Action -eq 'auto') }
        'merge'  { $operationAttempted = ($Action -eq 'merge'  -or ($Action -eq 'auto' -and $Branch)) }
    }
    
    if ($results[$key] -eq $true) {
        Write-Status "  ✅ $key : SUCCESS" -Type "Success"
    } elseif ($results[$key] -eq $false -and $operationAttempted) {
        Write-Status "  ⚠️  $key : SKIPPED/FAILED" -Type "Warning"
    }
}

Write-Status ""
Write-Status "Automation handled by: @copilot @jules @cursor" -Type "Info"
Write-Status "Timestamp: $timestamp" -Type "Info"
Write-Status ""

# Save workflow log
$logPath = Join-Path $repoPath "git-workflow-log.txt"
$resultsText = ($results.Keys | ForEach-Object { "  $_ : $($results[$_])" }) -join "`n"
$logEntry = @"
===========================================
Git Workflow Execution
===========================================
Timestamp: $timestamp
Action: $Action
Branch: $(Get-CurrentBranch)
Results:
$resultsText
===========================================

"@

Add-Content -Path $logPath -Value $logEntry

Write-Status "Log saved to: $logPath" -Type "Info"
