# Branch Management Guide

This guide provides instructions for managing branches in the ZOLO-A6-9VxNUNA repository, including merging feature branches and cleaning up old branches.

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Merging Branches](#merging-branches)
- [Deleting Merged Branches](#deleting-merged-branches)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Overview

The repository includes two PowerShell scripts for branch management:

1. **`merge-branches.ps1`** - Automates merging pull requests
2. **`delete-merged-branches.ps1`** - Cleans up old and merged branches

## Prerequisites

### Required Tools

- **Git** - Version control system
- **GitHub CLI (gh)** - For PR operations
  - Install: `winget install GitHub.cli` or download from https://cli.github.com/
- **PowerShell 7+** - Script execution environment

### Authentication

Authenticate with GitHub CLI:

```powershell
gh auth login
```

Follow the prompts to authenticate using your preferred method.

## Merging Branches

### Quick Start

**Interactive Mode** (recommended):
```powershell
.\merge-branches.ps1
```

This will:
1. List all open pull requests
2. Prompt you to select a PR number
3. Show PR details
4. Ask for confirmation
5. Merge the PR and delete the branch

### Advanced Usage

**Merge Specific PR:**
```powershell
.\merge-branches.ps1 -PRNumber 6
```

**Use Squash Merge:**
```powershell
.\merge-branches.ps1 -PRNumber 6 -MergeMethod squash
```

**Merge Without Deleting Branch:**
```powershell
.\merge-branches.ps1 -PRNumber 6 -DeleteBranch $false
```

### Merge Methods

- **`merge`** (default) - Creates a merge commit
- **`squash`** - Squashes all commits into one
- **`rebase`** - Rebases and merges

## Deleting Merged Branches

### Quick Start

**Dry Run** (see what would be deleted):
```powershell
.\delete-merged-branches.ps1
```

**Actually Delete Branches:**
```powershell
.\delete-merged-branches.ps1 -DryRun $false
```

### Advanced Usage

**Delete Remote Branches Too:**
```powershell
.\delete-merged-branches.ps1 -DryRun $false -IncludeRemote $true
```

**Custom Age Threshold:**
```powershell
.\delete-merged-branches.ps1 -OlderThanDays 60
```

### Protected Branches

The following branches are never deleted:
- `main`
- `master`
- `develop`
- `development`
- Current branch (whatever you're on)

## Best Practices

### Before Merging

1. **Review the PR** - Check code changes, comments, and tests
2. **Check CI/CD** - Ensure all checks pass
3. **Resolve Conflicts** - Fix any merge conflicts
4. **Get Approval** - Ensure PR is approved by reviewers

### After Merging

1. **Delete Feature Branch** - Remove merged branches promptly
2. **Update Local Repository** - Pull latest changes
3. **Clean Up** - Run cleanup script periodically

### Branching Strategy

**Current Open PRs:**
- PR #6: Setup workspace and GitHub app integration
- PR #5: Add Cursor workspace verification
- PR #1: Add HTTP website for project
- PR #10: Current merge and delete branch work (this one)

**Recommended Merge Order:**
1. Merge foundational PRs first (PR #1 - website)
2. Merge development tools (PR #5 - workspace)
3. Merge infrastructure (PR #6 - GitHub integration)
4. Merge utility work last (PR #10 - branch management)

## Troubleshooting

### Common Issues

#### "GitHub CLI not found"

**Solution:**
```powershell
# Install GitHub CLI
winget install GitHub.cli

# Verify installation
gh --version
```

#### "Authentication failed"

**Solution:**
```powershell
# Re-authenticate
gh auth logout
gh auth login
```

#### "Branch has conflicts"

**Solution:**
1. Manually resolve conflicts in the PR
2. Update the PR branch
3. Try merging again

#### "Cannot delete branch"

**Possible causes:**
- Branch is protected
- Branch is the current branch
- Branch doesn't exist locally

**Solution:**
```powershell
# Switch to main first
git checkout main

# Try again
.\delete-merged-branches.ps1 -DryRun $false
```

### Manual Branch Operations

#### Manually Merge a PR via GitHub Web UI:

1. Go to `https://github.com/<OWNER>/<REPO>/pulls` (replace with your repository)
2. Click on the PR
3. Click "Merge pull request"
4. Confirm the merge
5. Delete the branch

#### Manually Delete Local Branch:

```powershell
# Delete local branch
git branch -d branch-name

# Force delete
git branch -D branch-name
```

#### Manually Delete Remote Branch:

```powershell
# Delete remote branch
git push origin --delete branch-name
```

## Workflow Example

### Complete Merge and Cleanup Workflow:

```powershell
# 1. List open PRs and merge one
.\merge-branches.ps1

# 2. Pull latest changes
git checkout main
git pull origin main

# 3. Check for old branches (dry run)
.\delete-merged-branches.ps1

# 4. Actually delete old branches
.\delete-merged-branches.ps1 -DryRun $false

# 5. Clean up remote branches too
.\delete-merged-branches.ps1 -DryRun $false -IncludeRemote $true
```

## Quick Reference

### merge-branches.ps1 Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `-PRNumber` | int | *prompt* | PR number to merge |
| `-MergeMethod` | string | `merge` | merge, squash, or rebase |
| `-DeleteBranch` | bool | `true` | Delete branch after merge |

### delete-merged-branches.ps1 Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `-DryRun` | bool | `true` | Show what would be deleted |
| `-IncludeRemote` | bool | `false` | Also delete remote branches |
| `-OlderThanDays` | int | `30` | Age threshold for old branches |

## Additional Resources

- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Git Branch Management](https://git-scm.com/book/en/v2/Git-Branching-Branch-Management)
- [GitHub Flow Guide](https://guides.github.com/introduction/flow/)

---

**Last Updated:** 2025-12-25  
**Maintained By:** ZOLO Project Team
