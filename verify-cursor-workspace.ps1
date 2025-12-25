#Requires -Version 5.1
<#
.SYNOPSIS
    Cursor Workspace Setup Verification Script
.DESCRIPTION
    This script verifies that the ZOLO-A6-9VxNUNA project workspace is properly 
    configured for Cursor IDE with all necessary files, rules, and configurations.
#>

$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Cursor Workspace Verification" -ForegroundColor Cyan
Write-Host "  ZOLO-A6-9VxNUNA Project" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$issues = @()
$warnings = @()
$passed = @()

# Get the repository root
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoRoot

Write-Host "[INFO] Repository Root: $repoRoot" -ForegroundColor Cyan
Write-Host ""

# ============================================
# 1. Check Repository Structure
# ============================================
Write-Host "[1/10] Checking repository structure..." -ForegroundColor Yellow

if (Test-Path ".git") {
    $passed += "Git repository initialized"
    Write-Host "    [OK] Git repository found" -ForegroundColor Green
} else {
    $issues += "Git repository not initialized"
    Write-Host "    [ERROR] Git repository not found" -ForegroundColor Red
}

# ============================================
# 2. Check Cursor Configuration Directory
# ============================================
Write-Host "[2/10] Checking Cursor configuration..." -ForegroundColor Yellow

if (Test-Path ".cursor") {
    $passed += "Cursor configuration directory exists"
    Write-Host "    [OK] .cursor directory found" -ForegroundColor Green
} else {
    $warnings += "Cursor configuration directory not found"
    Write-Host "    [WARNING] .cursor directory not found" -ForegroundColor Yellow
}

# ============================================
# 3. Check Cursor Rules
# ============================================
Write-Host "[3/10] Checking Cursor rules..." -ForegroundColor Yellow

$cursorRulesPath = ".cursor\rules"
if (Test-Path $cursorRulesPath) {
    $passed += "Cursor rules directory exists"
    Write-Host "    [OK] Cursor rules directory found" -ForegroundColor Green
    
    $expectedRules = @(
        "powershell-standards\RULE.md",
        "system-configuration\RULE.md",
        "automation-patterns\RULE.md",
        "security-tokens\RULE.md",
        "github-desktop-integration\RULE.md"
    )
    
    foreach ($rule in $expectedRules) {
        $rulePath = Join-Path $cursorRulesPath $rule
        if (Test-Path $rulePath) {
            $passed += "Rule found: $rule"
            Write-Host "    [OK] Rule: $rule" -ForegroundColor Green
        } else {
            $warnings += "Missing rule: $rule"
            Write-Host "    [WARNING] Missing: $rule" -ForegroundColor Yellow
        }
    }
} else {
    $warnings += "Cursor rules directory not found"
    Write-Host "    [WARNING] Cursor rules directory not found" -ForegroundColor Yellow
}

# ============================================
# 4. Check VS Code / Cursor Settings
# ============================================
Write-Host "[4/10] Checking editor settings..." -ForegroundColor Yellow

if (Test-Path ".vscode\settings.json") {
    $passed += "VS Code/Cursor settings file exists"
    Write-Host "    [OK] .vscode/settings.json found" -ForegroundColor Green
} else {
    $warnings += "VS Code/Cursor settings file not found"
    Write-Host "    [WARNING] .vscode/settings.json not found" -ForegroundColor Yellow
}

# ============================================
# 5. Check Workspace Files
# ============================================
Write-Host "[5/10] Checking workspace files..." -ForegroundColor Yellow

$workspaceFiles = Get-ChildItem -Path $repoRoot -Recurse -Filter "*.code-workspace" -ErrorAction SilentlyContinue
if ($workspaceFiles.Count -gt 0) {
    $passed += "Workspace file(s) found: $($workspaceFiles.Count)"
    Write-Host "    [OK] Found $($workspaceFiles.Count) workspace file(s)" -ForegroundColor Green
    foreach ($ws in $workspaceFiles) {
        Write-Host "         - $($ws.Name)" -ForegroundColor White
    }
} else {
    $warnings += "No VS Code/Cursor workspace files found"
    Write-Host "    [WARNING] No .code-workspace files found" -ForegroundColor Yellow
}

# ============================================
# 6. Check Essential Configuration Files
# ============================================
Write-Host "[6/10] Checking essential configuration files..." -ForegroundColor Yellow

$essentialFiles = @(
    ".gitignore",
    ".cursorignore",
    "README.md",
    "AGENTS.md"
)

foreach ($file in $essentialFiles) {
    if (Test-Path $file) {
        $passed += "Essential file found: $file"
        Write-Host "    [OK] $file" -ForegroundColor Green
    } else {
        $warnings += "Missing essential file: $file"
        Write-Host "    [WARNING] Missing: $file" -ForegroundColor Yellow
    }
}

# ============================================
# 7. Check Documentation Files
# ============================================
Write-Host "[7/10] Checking documentation..." -ForegroundColor Yellow

$docFiles = @(
    "WORKSPACE-SETUP.md",
    "CURSOR-RULES-SETUP.md",
    "SYSTEM-INFO.md",
    "AUTOMATION-RULES.md",
    "GITHUB-DESKTOP-RULES.md"
)

$docCount = 0
foreach ($doc in $docFiles) {
    if (Test-Path $doc) {
        $docCount++
        Write-Host "    [OK] $doc" -ForegroundColor Green
    }
}
$passed += "Documentation files found: $docCount/$($docFiles.Count)"

if ($docCount -eq $docFiles.Count) {
    Write-Host "    [OK] All documentation files present" -ForegroundColor Green
} else {
    Write-Host "    [INFO] Found $docCount/$($docFiles.Count) documentation files" -ForegroundColor Cyan
}

# ============================================
# 8. Check PowerShell Scripts
# ============================================
Write-Host "[8/10] Checking PowerShell scripts..." -ForegroundColor Yellow

$scriptFiles = Get-ChildItem -Path $repoRoot -Filter "*.ps1" -File -ErrorAction SilentlyContinue
if ($scriptFiles.Count -gt 0) {
    $passed += "PowerShell scripts found: $($scriptFiles.Count)"
    Write-Host "    [OK] Found $($scriptFiles.Count) PowerShell script(s)" -ForegroundColor Green
} else {
    $warnings += "No PowerShell scripts found"
    Write-Host "    [WARNING] No PowerShell scripts found" -ForegroundColor Yellow
}

# ============================================
# 9. Check Git Configuration
# ============================================
Write-Host "[9/10] Checking git configuration..." -ForegroundColor Yellow

try {
    $gitUser = git config user.name 2>$null
    $gitEmail = git config user.email 2>$null
    
    if ($gitUser) {
        $passed += "Git user configured: $gitUser"
        Write-Host "    [OK] Git user: $gitUser" -ForegroundColor Green
    } else {
        $warnings += "Git user.name not configured"
        Write-Host "    [WARNING] Git user.name not set" -ForegroundColor Yellow
    }
    
    if ($gitEmail) {
        $passed += "Git email configured: $gitEmail"
        Write-Host "    [OK] Git email: $gitEmail" -ForegroundColor Green
    } else {
        $warnings += "Git user.email not configured"
        Write-Host "    [WARNING] Git user.email not set" -ForegroundColor Yellow
    }
    
    # Check remotes
    $remotes = git remote 2>$null
    if ($remotes) {
        $passed += "Git remotes configured: $($remotes.Count)"
        Write-Host "    [OK] Git remotes configured" -ForegroundColor Green
        foreach ($remote in $remotes) {
            $url = git remote get-url $remote 2>$null
            Write-Host "         - $remote`: $url" -ForegroundColor White
        }
    } else {
        $warnings += "No git remotes configured"
        Write-Host "    [WARNING] No git remotes configured" -ForegroundColor Yellow
    }
} catch {
    $warnings += "Could not check git configuration"
    Write-Host "    [WARNING] Could not read git config" -ForegroundColor Yellow
}

# ============================================
# 10. Check Project Structure
# ============================================
Write-Host "[10/10] Checking project structure..." -ForegroundColor Yellow

$projectDirs = @(
    "vps-services",
    "projects",
    "project-scanner",
    "system-setup",
    "storage-management",
    "trading-bridge"
)

$dirCount = 0
foreach ($dir in $projectDirs) {
    if (Test-Path $dir) {
        $dirCount++
    }
}

if ($dirCount -gt 0) {
    $passed += "Project directories found: $dirCount/$($projectDirs.Count)"
    Write-Host "    [OK] Found $dirCount/$($projectDirs.Count) project directories" -ForegroundColor Green
} else {
    Write-Host "    [INFO] No standard project directories found" -ForegroundColor Cyan
}

# ============================================
# Summary Report
# ============================================
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Verification Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Passed Checks: $($passed.Count)" -ForegroundColor Green
Write-Host "Warnings: $($warnings.Count)" -ForegroundColor Yellow
Write-Host "Issues: $($issues.Count)" -ForegroundColor Red
Write-Host ""

if ($issues.Count -gt 0) {
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "  Critical Issues" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    foreach ($issue in $issues) {
        Write-Host "  [!] $issue" -ForegroundColor Red
    }
    Write-Host ""
}

if ($warnings.Count -gt 0) {
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "  Warnings" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "  [!] $warning" -ForegroundColor Yellow
    }
    Write-Host ""
}

# ============================================
# Recommendations
# ============================================
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Recommendations" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($issues.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "[OK] Workspace is properly configured for Cursor!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your ZOLO-A6-9VxNUNA workspace includes:" -ForegroundColor Cyan
    Write-Host "  ✅ Cursor rules configured" -ForegroundColor Green
    Write-Host "  ✅ Git repository initialized" -ForegroundColor Green
    Write-Host "  ✅ Documentation complete" -ForegroundColor Green
    Write-Host "  ✅ Scripts and automation ready" -ForegroundColor Green
} else {
    Write-Host "To complete workspace setup:" -ForegroundColor Cyan
    Write-Host ""
    
    if ($issues.Count -gt 0) {
        Write-Host "1. Fix critical issues listed above" -ForegroundColor Yellow
    }
    
    Write-Host "2. Run setup-workspace.ps1 to configure workspace" -ForegroundColor White
    Write-Host "3. Run git-setup.ps1 if git needs configuration" -ForegroundColor White
    Write-Host "4. Open workspace in Cursor and verify rules are loaded" -ForegroundColor White
    Write-Host "5. Check Cursor Settings → Rules, Commands" -ForegroundColor White
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Verification Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Return status
if ($issues.Count -gt 0) {
    exit 1
} else {
    exit 0
}
