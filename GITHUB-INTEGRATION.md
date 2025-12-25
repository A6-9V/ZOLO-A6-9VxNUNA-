# GitHub Integration Guide

Complete guide for integrating this repository with GitHub Apps, Actions, and automation tools.

## 📋 Table of Contents

1. [GitHub App Setup](#github-app-setup)
2. [GitHub Actions](#github-actions)
3. [Repository Settings](#repository-settings)
4. [MCP Integration](#mcp-integration)
5. [Automation Scripts](#automation-scripts)
6. [Security](#security)

## 🔧 GitHub App Setup

### Option 1: Using GitHub App (Recommended for Organizations)

Follow the detailed guide in [system-setup/GITHUB-APP-SETUP.md](system-setup/GITHUB-APP-SETUP.md) or use the quick start:

1. **Create GitHub App:**
   - Go to: Settings → Developer settings → GitHub Apps → New GitHub App
   - Name: `GenX` (or similar)
   - Set required permissions
   - Download private key (.pem file)

2. **Install the App:**
   - Install on your repositories
   - Note the Installation ID

3. **Configure MCP:**
   ```powershell
   # Edit system-setup/mcp-config.json
   # Add your App ID, Installation ID, and private key path
   ```

4. **Apply Configuration:**
   ```powershell
   cd system-setup
   .\complete-setup.ps1
   ```

### Option 2: Using Personal Access Token (Simpler for Personal Use)

1. **Generate Token:**
   - Go to: Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Click "Generate new token (classic)"
   - Select scopes: `repo`, `workflow`, `read:org`
   - Generate and copy the token

2. **Configure MCP:**
   ```powershell
   # Edit system-setup/mcp-config.json
   # Replace GITHUB_PERSONAL_ACCESS_TOKEN value with your token
   ```

3. **Apply Configuration:**
   ```powershell
   cd system-setup
   .\complete-setup.ps1
   ```

## 🔄 GitHub Actions

This repository includes automated workflows:

### CI Workflow (`.github/workflows/ci.yml`)

**Triggers:**
- Push to main, develop, or copilot/** branches
- Pull requests to main or develop
- Only when .ps1 files are modified

**Jobs:**
- **PowerShell Linting**: Uses PSScriptAnalyzer
- **Syntax Testing**: Validates all PowerShell scripts

### Security Workflow (`.github/workflows/security.yml`)

**Triggers:**
- Push to main or develop
- Pull requests
- Weekly schedule (Mondays at 00:00 UTC)

**Jobs:**
- **Secret Scanning**: Uses Gitleaks to detect secrets
- **Security Audit**: Checks for hardcoded credentials

### Viewing Workflow Results

```powershell
# Using GitHub CLI
gh run list
gh run view <run-id>
gh run watch <run-id>
```

## ⚙️ Repository Settings

### Required Settings

1. **Branch Protection (Main Branch):**
   - Require pull request reviews
   - Require status checks to pass
   - Require conversation resolution
   - Do not allow bypassing

2. **Security:**
   - Enable Dependabot alerts
   - Enable Dependabot security updates
   - Enable secret scanning
   - Enable code scanning (if available)

3. **Collaborators:**
   - Add team members
   - Set appropriate permissions

### Applying Settings via GitHub CLI

```powershell
# Enable security features
gh api -X PATCH /repos/Mouy-leng/ZOLO-A6-9VxNUNA- -f has_issues=true -f has_projects=true -f has_wiki=false

# Configure branch protection
gh api -X PUT /repos/Mouy-leng/ZOLO-A6-9VxNUNA-/branches/main/protection `
  -F required_status_checks='{"strict":true,"contexts":["powershell-lint","powershell-test"]}' `
  -F enforce_admins=false `
  -F required_pull_request_reviews='{"required_approving_review_count":1}'
```

## 🔌 MCP Integration

### What is MCP?

MCP (Model Context Protocol) enables AI tools like Cursor IDE to interact with your GitHub repositories, file systems, and other services.

### Current Configuration

Located in `system-setup/mcp-config.json`:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": ""
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "D:\\"],
      "env": {}
    },
    "drive-scanner": { ... },
    "storage-manager": { ... }
  }
}
```

### Setting Up MCP

1. **Install Node.js** (if not already installed)
2. **Update MCP Configuration:**
   ```powershell
   # Edit system-setup/mcp-config.json
   # Add your GitHub token or App credentials
   ```

3. **Apply to Cursor:**
   ```powershell
   cd system-setup
   .\complete-setup.ps1
   ```

4. **Restart Cursor IDE**

5. **Verify:**
   ```powershell
   .\verify-github-app.ps1 -Verbose
   ```

### Testing MCP Integration

In Cursor IDE:
1. Open Command Palette (Ctrl+Shift+P)
2. Type "MCP" to see available MCP commands
3. Test GitHub integration with AI features

## 🤖 Automation Scripts

### GitHub Desktop Integration

```powershell
# Check for updates
.\check-github-desktop-updates.ps1

# Setup GitHub Desktop
.\github-desktop-setup.ps1
```

### Repository Management

```powershell
# Push to all remotes
.\push-to-all-repos.ps1

# Review and push all repos
.\review-and-push-all-repos.ps1

# Clone repository
.\clone-repo.ps1
```

### Git Operations

```powershell
# Setup git
.\git-setup.ps1

# Push to GitHub
.\PUSH-TO-GITHUB.ps1

# Auto push
.\auto-git-push.ps1
```

## 🔒 Security

### Best Practices

1. **Never Commit Secrets:**
   - All tokens are in `.gitignore`
   - Use environment variables
   - Use Windows Credential Manager

2. **Token Storage:**
   ```powershell
   # Store in Credential Manager
   cmdkey /generic:GitHub /user:your-username /pass:your-token
   
   # Or use environment variables (User level)
   [Environment]::SetEnvironmentVariable("GITHUB_TOKEN", "your-token", "User")
   ```

3. **Private Key Protection:**
   ```powershell
   # Secure .pem file
   $keyPath = "$env:USERPROFILE\.github\genx-app-private-key.pem"
   icacls $keyPath /inheritance:r /grant:r "$env:USERNAME:(R)"
   ```

### Security Scanning

```powershell
# Run security check
.\run-security-check.ps1

# Security check for VPS
.\security-check-vps.ps1
```

### Excluded from Git

The `.gitignore` includes:
- `*.token`
- `*.secret`
- `*credentials*`
- `*.pem`
- `.github-token`
- `Secrets/`

## 📝 Issue Templates

Located in `.github/ISSUE_TEMPLATE/`:

- **Bug Report**: `bug_report.yml`
- **Feature Request**: `feature_request.yml`
- **Config**: `config.yml`

## 🎯 Pull Request Template

Located at `.github/pull_request_template.md`

Includes sections for:
- Description
- Type of change
- Testing details
- Checklist

## 👥 CODEOWNERS

Located at `.github/CODEOWNERS`

Defines who reviews PRs for different parts of the repository.

## 🔄 Dependabot

Located at `.github/dependabot.yml`

Configured to:
- Update GitHub Actions weekly
- Update npm dependencies weekly
- Auto-assign reviewers
- Label dependency updates

## 📊 Monitoring and Maintenance

### Check Repository Status

```powershell
# View workflow runs
gh run list --limit 10

# Check repository settings
gh repo view Mouy-leng/ZOLO-A6-9VxNUNA-

# View recent commits
gh api repos/Mouy-leng/ZOLO-A6-9VxNUNA-/commits --jq '.[].commit.message'
```

### Update Repository

```powershell
# Pull latest changes
git pull origin main

# Update submodules (if any)
git submodule update --init --recursive

# Run workspace setup
.\setup-workspace.ps1
```

## 🆘 Troubleshooting

### MCP Not Working

1. **Check MCP Config:**
   ```powershell
   .\verify-github-app.ps1 -Verbose
   ```

2. **Verify Token:**
   ```powershell
   # Test with GitHub CLI
   gh auth status
   ```

3. **Restart Cursor:**
   - Close all Cursor windows
   - Reopen and wait for MCP to initialize

### GitHub Actions Failing

1. **Check Workflow Status:**
   ```powershell
   gh run list --workflow=ci.yml
   gh run view <run-id>
   ```

2. **View Logs:**
   ```powershell
   gh run view <run-id> --log
   ```

3. **Re-run Failed Jobs:**
   ```powershell
   gh run rerun <run-id>
   ```

### Authentication Issues

1. **Regenerate Token:**
   - Go to GitHub Settings → Developer settings
   - Regenerate token with required scopes
   - Update MCP configuration

2. **Clear Cached Credentials:**
   ```powershell
   # Remove cached credentials
   cmdkey /delete:GitHub
   
   # Re-login with GitHub CLI
   gh auth logout
   gh auth login
   ```

## 📚 Additional Resources

- [GitHub Apps Documentation](https://docs.github.com/en/apps)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [MCP Protocol](https://github.com/modelcontextprotocol)
- [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)

## 🎓 Learning Path

1. ✅ Set up GitHub App or Personal Access Token
2. ✅ Configure MCP integration
3. ✅ Test GitHub Actions workflows
4. ✅ Review security settings
5. ✅ Practice PR workflow
6. ✅ Monitor and maintain

---

**Last Updated**: December 2025  
**Status**: Active Development  
**Maintained By**: @Mouy-leng
