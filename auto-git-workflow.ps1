#Requires -Version 5.1
<#
.SYNOPSIS
    Automated Git Workflow Script
.DESCRIPTION
    Automates standard Git operations: Pull, Commit, Push, and Merge.
    Designed for use by @copilot, @jules, and @Cursor.
.PARAMETER Action
    The action to perform: 'All', 'Pull', 'Commit', 'Push', 'Merge' (default: 'All')
.PARAMETER Message
    The commit message to use (required for 'Commit' and 'All')
.PARAMETER Branch
    The branch to operate on (default: current branch)
.PARAMETER Remote
    The remote to use (default: 'origin'). Use 'All' to push to all remotes.
.EXAMPLE
    .\auto-git-workflow.ps1 -Action All -Message "Update documentation"
#>

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('All', 'Pull', 'Commit', 'Push', 'Merge')]
    [string]$Action = 'All',

    [Parameter(Mandatory=$false)]
    [string]$Message,

    [Parameter(Mandatory=$false)]
    [string]$Branch,

    [Parameter(Mandatory=$false)]
    [string]$Remote = 'origin'
)

# Set Error Action Preference
$ErrorActionPreference = "Stop"

# Helper for colored output
function Write-Status {
    param([string]$Message, [string]$Type = "INFO")
    $color = switch ($Type) {
        "OK" { "Green" }
        "WARNING" { "Yellow" }
        "ERROR" { "Red" }
        "INFO" { "Cyan" }
        default { "White" }
    }
    Write-Host "[$Type] $Message" -ForegroundColor $color
}

# Check if git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Status "Git is not installed or not in PATH." "ERROR"
    exit 1
}

# Get current branch if not provided
if (-not $Branch) {
    try {
        $Branch = git rev-parse --abbrev-ref HEAD
    } catch {
        Write-Status "Not in a git repository or no branch found." "ERROR"
        exit 1
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Automated Git Workflow" -ForegroundColor Cyan
Write-Host "  Current Branch: $Branch" -ForegroundColor Yellow
Write-Host "  Action: $Action" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Action: Pull
function Invoke-Pull {
    Write-Status "Pulling latest changes from $Remote/$Branch..." "INFO"
    try {
        git pull $Remote $Branch
        Write-Status "Successfully pulled changes." "OK"
    } catch {
        Write-Status "Failed to pull changes: $_" "ERROR"
        return $false
    }
    return $true
}

# Action: Commit
function Invoke-Commit {
    param([string]$CommitMsg)
    if (-not $CommitMsg) {
        $CommitMsg = "Automated commit by Workflow Script"
    }
    
    Write-Status "Staging all changes..." "INFO"
    git add .
    
    Write-Status "Committing changes with message: '$CommitMsg'..." "INFO"
    try {
        $status = git status --porcelain
        if (-not $status) {
            Write-Status "Nothing to commit, working tree clean." "WARNING"
            return $true
        }
        git commit -m $CommitMsg
        Write-Status "Successfully committed changes." "OK"
    } catch {
        Write-Status "Failed to commit changes: $_" "ERROR"
        return $false
    }
    return $true
}

# Action: Push
function Invoke-Push {
    if ($Remote -eq 'All') {
        Write-Status "Getting list of all remotes..." "INFO"
        $remotes = git remote
        $success = $true
        foreach ($r in $remotes) {
            Write-Status "Pushing changes to $r/$Branch..." "INFO"
            try {
                git push $r $Branch
                Write-Status "Successfully pushed to $r." "OK"
            } catch {
                Write-Status "Failed to push to $r: $_" "WARNING"
                $success = $false
            }
        }
        return $success
    } else {
        Write-Status "Pushing changes to $Remote/$Branch..." "INFO"
        try {
            git push $Remote $Branch
            Write-Status "Successfully pushed changes." "OK"
        } catch {
            Write-Status "Failed to push changes: $_" "ERROR"
            return $false
        }
    }
    return $true
}

# Action: Merge
function Invoke-Merge {
    param([string]$SourceBranch = "main")
    Write-Status "Merging $SourceBranch into $Branch..." "INFO"
    try {
        git merge $SourceBranch
        Write-Status "Successfully merged $SourceBranch." "OK"
    } catch {
        Write-Status "Merge failed or has conflicts: $_" "ERROR"
        return $false
    }
    return $true
}

# Main Execution logic
try {
    switch ($Action) {
        'Pull' {
            Invoke-Pull
        }
        'Commit' {
            Invoke-Commit -CommitMsg $Message
        }
        'Push' {
            Invoke-Push
        }
        'Merge' {
            Invoke-Merge
        }
        'All' {
            if (-not $Message) {
                Write-Status "Commit message is required for action 'All'." "ERROR"
                exit 1
            }
            if (Invoke-Pull) {
                if (Invoke-Commit -CommitMsg $Message) {
                    Invoke-Push
                }
            }
        }
    }
} catch {
    Write-Status "An unexpected error occurred: $_" "ERROR"
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Workflow Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
