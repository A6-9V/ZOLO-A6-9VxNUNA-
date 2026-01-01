# Jules API Keys Setup Guide

This guide explains how to securely store Jules API keys as GitHub repository secrets and use them in your workflows.

## 📋 Overview

The Jules API integration requires secure storage of API keys. This repository includes automated scripts to:

1. ✅ Store 12 Jules API keys as individual GitHub secrets
2. ✅ Create a combined secret containing all keys
3. ✅ Generate usage documentation
4. ✅ Follow security best practices

## 🔑 What Gets Stored

The setup creates the following GitHub secrets:

- `JULES_API_KEY_1` through `JULES_API_KEY_12` - Individual Jules API keys
- `JULES_API_KEYS_ALL` - All keys combined (comma-separated)

**Total: 13 secrets**

## 🚀 Quick Start

### Option 1: Windows (PowerShell)

1. **Run the batch file:**
   ```cmd
   SETUP-JULES-API-KEYS.bat
   ```

2. **Or run PowerShell script directly:**
   ```powershell
   .\setup-jules-api-keys.ps1
   ```

### Option 2: Linux/macOS (Bash)

1. **Make the script executable:**
   ```bash
   chmod +x setup-jules-api-keys.sh
   ```

2. **Run the script:**
   ```bash
   ./setup-jules-api-keys.sh
   ```

### Option 3: Manual Setup (Any Platform)

1. **Install GitHub CLI** if not already installed:
   - Windows: `winget install --id GitHub.cli`
   - macOS: `brew install gh`
   - Linux: `sudo apt install gh` (Ubuntu/Debian)

2. **Authenticate with GitHub:**
   ```bash
   gh auth login
   ```

3. **Run the appropriate setup script** (PowerShell or Bash)

## 📋 Prerequisites

### Required:
- ✅ **GitHub CLI (gh)** installed and in PATH
- ✅ **GitHub account** with access to the repository
- ✅ **Repository write permissions** to create secrets

### Optional:
- ⚙️ **PowerShell 5.1+** (Windows) or **Bash** (Linux/macOS)
- 🔐 **Administrator privileges** (recommended but not required)

## 🔐 Security Features

The setup scripts implement multiple security measures:

### ✅ Secure Storage
- API keys are **never committed** to the repository
- Keys are stored as **encrypted GitHub secrets**
- Local backups contain only metadata, not actual keys

### ✅ Best Practices
- **No logging** of full API key values
- **Rate limiting protection** between API calls
- **Verification** of successful secret creation
- **Gitignore patterns** to prevent accidental commits

### ✅ Access Control
- Secrets are **only accessible** in GitHub Actions workflows
- **Environment-based access** prevents unauthorized use
- **Audit trail** through GitHub's secret management

## 📖 Usage in GitHub Actions

### Example 1: Use a Single Key

```yaml
name: Jules API Integration
on: [push]

jobs:
  process:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Use Jules API
        env:
          JULES_API_KEY: ${{ secrets.JULES_API_KEY_1 }}
        run: |
          echo "Processing with Jules API..."
          # Your code here - API key is in $JULES_API_KEY
```

### Example 2: Use All Keys

```yaml
name: Process with All Jules Keys
on: [workflow_dispatch]

jobs:
  process-all:
    runs-on: ubuntu-latest
    steps:
      - name: Use All Jules API Keys
        env:
          JULES_API_KEYS: ${{ secrets.JULES_API_KEYS_ALL }}
        run: |
          # Split keys by comma
          IFS=',' read -ra KEYS <<< "$JULES_API_KEYS"
          
          # Process each key
          for i in "${!KEYS[@]}"; do
            KEY_NUM=$((i + 1))
            echo "Processing with key $KEY_NUM..."
            # Your code here
          done
```

### Example 3: PowerShell Script in Actions

```yaml
name: Windows PowerShell Integration
on: [push]

jobs:
  windows-process:
    runs-on: windows-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Run PowerShell with Jules API
        env:
          JULES_KEY_1: ${{ secrets.JULES_API_KEY_1 }}
          JULES_KEY_2: ${{ secrets.JULES_API_KEY_2 }}
        shell: pwsh
        run: |
          Write-Host "Using Jules API keys..."
          $apiKey = $env:JULES_KEY_1
          # Your PowerShell code here
```

## 🔧 Configuration

### Customize API Key Names

To use different secret names, edit the scripts:

**PowerShell (`setup-jules-api-keys.ps1`):**
```powershell
# Change this line:
$secretName = "JULES_API_KEY_$keyNumber"
# To:
$secretName = "YOUR_PREFIX_$keyNumber"
```

**Bash (`setup-jules-api-keys.sh`):**
```bash
# Change this line:
SECRET_NAME="JULES_API_KEY_$KEY_NUMBER"
# To:
SECRET_NAME="YOUR_PREFIX_$KEY_NUMBER"
```

### Change Repository

Both scripts have a `REPO` variable at the top:

```powershell
$REPO = "Mouy-leng/ZOLO-A6-9VxNUNA-"
```

Change this to target a different repository.

## 🛠️ Maintenance

### View All Secrets

```bash
gh secret list --repo Mouy-leng/ZOLO-A6-9VxNUNA-
```

### Update a Secret

```bash
echo "NEW_API_KEY_VALUE" | gh secret set JULES_API_KEY_1 --repo Mouy-leng/ZOLO-A6-9VxNUNA-
```

### Delete a Secret

```bash
gh secret delete JULES_API_KEY_1 --repo Mouy-leng/ZOLO-A6-9VxNUNA-
```

### Rotate Keys

1. Generate new API keys from Jules platform
2. Run the setup script again with updated keys
3. The script will overwrite existing secrets

## 🐛 Troubleshooting

### Error: "GitHub CLI not found"

**Solution:** Install GitHub CLI:
```bash
# Windows
winget install --id GitHub.cli

# macOS
brew install gh

# Ubuntu/Debian
sudo apt install gh
```

### Error: "Not authenticated with GitHub"

**Solution:** Authenticate with GitHub CLI:
```bash
gh auth login
```

Follow the prompts to authenticate via web browser.

### Error: "Permission denied"

**Solution:** Ensure you have write access to the repository:
1. Check you're authenticated as the correct user: `gh auth status`
2. Verify repository permissions in GitHub settings
3. Try logging out and back in: `gh auth logout && gh auth login`

### Error: "Rate limit exceeded"

**Solution:** The script includes delays between API calls. If you still hit rate limits:
1. Wait a few minutes before retrying
2. Check your GitHub API rate limit: `gh api rate_limit`

### Secrets Not Showing in Actions

**Solution:**
1. Verify secrets were created: `gh secret list --repo Mouy-leng/ZOLO-A6-9VxNUNA-`
2. Check the secret names match exactly in your workflow
3. Remember: Secrets are **case-sensitive**

## 📝 Script Output

Both scripts provide detailed output:

```
═══════════════════════════════════════════════════════════════
    Jules API Keys - GitHub Secrets Setup
═══════════════════════════════════════════════════════════════

[HH:MM:SS] ℹ Repository: Mouy-leng/ZOLO-A6-9VxNUNA-
[HH:MM:SS] ℹ Number of Jules API Keys to store: 12

[HH:MM:SS] Checking GitHub CLI installation...
[HH:MM:SS] ✓ GitHub CLI is installed

[HH:MM:SS] Checking GitHub authentication...
[HH:MM:SS] ✓ Already authenticated with GitHub

─────────────────────────────────────────────────────────────
[HH:MM:SS] Storing Jules API Keys as GitHub Secrets...
─────────────────────────────────────────────────────────────

[HH:MM:SS] Setting secret: JULES_API_KEY_1
[HH:MM:SS] ✓   ✓ JULES_API_KEY_1 stored successfully
...
```

## 📚 Additional Resources

- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [GitHub CLI Manual](https://cli.github.com/manual/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## 🔒 Security Best Practices

### DO:
- ✅ Store API keys as GitHub secrets
- ✅ Use environment variables in workflows
- ✅ Rotate keys regularly
- ✅ Monitor usage and access logs
- ✅ Use secrets only in trusted workflows

### DON'T:
- ❌ Commit API keys to the repository
- ❌ Log full API key values
- ❌ Share secrets in pull requests
- ❌ Use secrets in public repositories without caution
- ❌ Expose secrets in error messages

## 📄 Files Created

After running the setup, you'll have:

1. **`setup-jules-api-keys.ps1`** - PowerShell setup script
2. **`setup-jules-api-keys.sh`** - Bash setup script
3. **`SETUP-JULES-API-KEYS.bat`** - Windows batch launcher
4. **`JULES-API-KEYS-USAGE.md`** - Detailed usage documentation
5. **`JULES-API-KEYS-SETUP.md`** - This file
6. **`jules-api-keys-backup.encrypted`** - Metadata backup (optional)

## 🎯 Next Steps

After running the setup:

1. ✅ Review generated documentation: `JULES-API-KEYS-USAGE.md`
2. ✅ Verify secrets: `gh secret list --repo Mouy-leng/ZOLO-A6-9VxNUNA-`
3. ✅ Update GitHub Actions workflows to use the secrets
4. ✅ Test workflows to ensure keys work correctly
5. ✅ Set up key rotation schedule (recommended: every 90 days)

## 💬 Support

For issues or questions:

1. Check the [Troubleshooting](#-troubleshooting) section
2. Review GitHub's [Encrypted Secrets Guide](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
3. Open an issue in the repository

---

**Repository**: Mouy-leng/ZOLO-A6-9VxNUNA-  
**Last Updated**: 2026-01-01  
**Version**: 1.0.0
