# Workspace & GitHub App Setup - Quick Reference

This guide provides quick commands and references for setting up the workspace and GitHub integration.

## 🚀 Quick Setup Commands

### 1. GitHub Workspace Setup (Fastest)

```powershell
# Option A: Using Personal Access Token (Recommended for personal use)
.\setup-github-workspace.ps1 -UsePersonalToken -Token 'your-github-token'

# Option B: Using GitHub App (Recommended for organizations)
.\setup-github-workspace.ps1 -UseGitHubApp

# Option C: Just verify prerequisites
.\setup-github-workspace.ps1 -Verify
```

### 2. Apply MCP Configuration to Cursor

```powershell
cd system-setup
.\complete-setup.ps1
```

### 3. Verify Setup

```powershell
.\system-setup\verify-github-app.ps1 -Verbose
```

## 📋 What Gets Set Up

### GitHub Repository Features
- ✅ **CI/CD Workflows**: Automatic PowerShell linting and testing
- ✅ **Security Scanning**: Secret detection and credential audits
- ✅ **Issue Templates**: Bug reports and feature requests
- ✅ **PR Template**: Standardized pull request format
- ✅ **CODEOWNERS**: Automatic reviewer assignment
- ✅ **Dependabot**: Automated dependency updates

### Workspace Configuration
- ✅ **Git Setup**: User configuration and remotes
- ✅ **MCP Integration**: GitHub server for Cursor AI
- ✅ **VS Code Settings**: Enhanced for PowerShell and GitHub
- ✅ **Environment Variables**: Secure token storage

## 🔑 Authentication Methods

### Method 1: Personal Access Token (Simple)

1. **Generate Token:**
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token (classic)"
   - Select scopes: `repo`, `workflow`, `read:org`
   - Copy token

2. **Use Token:**
   ```powershell
   .\setup-github-workspace.ps1 -UsePersonalToken -Token 'ghp_xxxxxxxxxxxx'
   ```

### Method 2: GitHub App (Advanced)

1. **Create App:**
   - Settings → Developer settings → GitHub Apps → New
   - Download private key (.pem)
   - Note App ID and Installation ID

2. **Configure:**
   ```powershell
   # Edit system-setup/mcp-config.json with your credentials
   .\setup-github-workspace.ps1 -UseGitHubApp
   ```

## 🔍 Verification Checklist

Run after setup to verify everything works:

```powershell
# 1. Check Git
git --version
git config user.name
git config user.email
git remote -v

# 2. Check GitHub CLI (optional)
gh --version
gh auth status

# 3. Check Node.js (for MCP)
node --version
npx --version

# 4. Verify MCP Configuration
.\system-setup\verify-github-app.ps1 -Verbose

# 5. Test PowerShell Script
$null = [System.Management.Automation.PSParser]::Tokenize((Get-Content .\setup-github-workspace.ps1 -Raw), [ref]$null)
Write-Host "✓ Script syntax valid" -ForegroundColor Green
```

## 📁 Important Files

| File | Purpose |
|------|---------|
| `setup-github-workspace.ps1` | Main setup automation script |
| `GITHUB-INTEGRATION.md` | Complete integration guide |
| `system-setup/mcp-config.json` | MCP server configuration |
| `system-setup/complete-setup.ps1` | Apply system configurations |
| `system-setup/verify-github-app.ps1` | Verify GitHub App setup |
| `.github/workflows/ci.yml` | CI workflow for PowerShell |
| `.github/workflows/security.yml` | Security scanning workflow |

## 🔄 Workflow

```
1. Clone Repo
   ↓
2. Run setup-github-workspace.ps1
   ↓
3. Configure MCP (edit mcp-config.json)
   ↓
4. Apply Setup (complete-setup.ps1)
   ↓
5. Verify (verify-github-app.ps1)
   ↓
6. Restart Cursor IDE
   ↓
7. Start Coding! 🎉
```

## 🛠️ Common Tasks

### Update GitHub Token

```powershell
# Method 1: Re-run setup
.\setup-github-workspace.ps1 -UsePersonalToken -Token 'new-token'

# Method 2: Update environment variable
[Environment]::SetEnvironmentVariable("GITHUB_TOKEN", "new-token", "User")

# Method 3: Update MCP config
# Edit system-setup/mcp-config.json, then:
.\system-setup\complete-setup.ps1
```

### Check Workflow Status

```powershell
# Using GitHub CLI
gh run list
gh run view <run-id>
gh run watch

# Using web browser
# Go to: https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-/actions
```

### Update Repository

```powershell
# Pull latest changes
git pull origin main

# Check status
git status

# Push changes
git add .
git commit -m "Your message"
git push origin your-branch
```

## 🔒 Security Best Practices

1. **Never commit tokens:**
   - All tokens are in `.gitignore`
   - Use environment variables
   - Use Windows Credential Manager

2. **Secure private keys:**
   ```powershell
   $keyPath = "$env:USERPROFILE\.github\your-key.pem"
   icacls $keyPath /inheritance:r /grant:r "$env:USERNAME:(R)"
   ```

3. **Regular token rotation:**
   - Rotate tokens every 90 days
   - Use token expiration when creating
   - Monitor token usage

## 📚 Documentation Links

- **Main README**: [README.md](README.md)
- **GitHub Integration**: [GITHUB-INTEGRATION.md](GITHUB-INTEGRATION.md)
- **GitHub App Setup**: [system-setup/GITHUB-APP-SETUP.md](system-setup/GITHUB-APP-SETUP.md)
- **GitHub App Quick Start**: [system-setup/GITHUB-APP-QUICK-START.md](system-setup/GITHUB-APP-QUICK-START.md)
- **Contributing**: [.github/CONTRIBUTING.md](.github/CONTRIBUTING.md)
- **Workspace Setup**: [WORKSPACE-SETUP.md](WORKSPACE-SETUP.md)

## 🆘 Troubleshooting

### Issue: "Git not found"
**Solution:** Install Git from https://git-scm.com/download/win

### Issue: "Node.js not found"
**Solution:** Install Node.js from https://nodejs.org/

### Issue: "MCP not connecting"
**Solution:** 
```powershell
# 1. Verify configuration
.\system-setup\verify-github-app.ps1 -Verbose

# 2. Restart Cursor
# Close all windows and reopen

# 3. Check MCP logs in Cursor
# Settings → Output → Select "MCP" from dropdown
```

### Issue: "GitHub CLI not authenticated"
**Solution:**
```powershell
gh auth logout
gh auth login
```

### Issue: "Workflows not running"
**Solution:**
1. Check workflow files in `.github/workflows/`
2. Verify GitHub Actions are enabled in repo settings
3. Check workflow run logs on GitHub

## 🎯 Next Steps

After setup is complete:

1. ✅ Read [GITHUB-INTEGRATION.md](GITHUB-INTEGRATION.md)
2. ✅ Review [CONTRIBUTING.md](.github/CONTRIBUTING.md)
3. ✅ Test creating an issue using templates
4. ✅ Test creating a PR using the template
5. ✅ Explore GitHub Actions workflows
6. ✅ Set up branch protection rules (if admin)

---

**Last Updated**: December 2025  
**Quick Help**: Run `.\setup-github-workspace.ps1 -Verify` to check setup status
