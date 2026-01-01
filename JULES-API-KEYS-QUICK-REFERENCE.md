# Jules API Keys - Quick Reference

## 🚀 Quick Setup (3 Steps)

### Windows Users:
```cmd
# Double-click or run in CMD:
SETUP-JULES-API-KEYS.bat
```

### Linux/macOS Users:
```bash
chmod +x setup-jules-api-keys.sh
./setup-jules-api-keys.sh
```

### Using PowerShell Directly:
```powershell
.\setup-jules-api-keys.ps1
```

---

## 📝 What This Does

1. ✅ Stores **12 Jules API keys** as GitHub repository secrets
2. ✅ Creates secret names: `JULES_API_KEY_1` through `JULES_API_KEY_12`
3. ✅ Creates combined secret: `JULES_API_KEYS_ALL` (comma-separated)
4. ✅ Generates usage documentation
5. ✅ Validates GitHub CLI installation and authentication

---

## 🔐 Stored Secrets

| Secret Name | Description |
|------------|-------------|
| `JULES_API_KEY_1` | Jules API Key #1 |
| `JULES_API_KEY_2` | Jules API Key #2 |
| ... | ... |
| `JULES_API_KEY_12` | Jules API Key #12 |
| `JULES_API_KEYS_ALL` | All keys (comma-separated) |

**Total:** 13 secrets

---

## 💻 Usage Examples

### In GitHub Actions:
```yaml
- name: Use Jules API
  env:
    JULES_KEY: ${{ secrets.JULES_API_KEY_1 }}
  run: |
    echo "Using Jules API key..."
    # Your code here
```

### In Python:
```python
# Use the included manager
from jules_api_keys_manager import JulesAPIKeyManager

manager = JulesAPIKeyManager()
key = manager.get_key(1)  # Get first key
all_keys = manager.get_all_keys()  # Get all keys
```

### In Bash:
```bash
# Keys are available as environment variables in GitHub Actions
if [ -n "$JULES_API_KEY_1" ]; then
    echo "Key available!"
fi
```

### In PowerShell:
```powershell
# Access from environment variables
$apiKey = $env:JULES_API_KEY_1
Write-Host "Using key: ${apiKey:0:10}...***"
```

---

## 🔧 Common Commands

### View All Secrets:
```bash
gh secret list --repo Mouy-leng/ZOLO-A6-9VxNUNA-
```

### Update a Secret:
```bash
echo "NEW_KEY" | gh secret set JULES_API_KEY_1 --repo Mouy-leng/ZOLO-A6-9VxNUNA-
```

### Delete a Secret:
```bash
gh secret delete JULES_API_KEY_1 --repo Mouy-leng/ZOLO-A6-9VxNUNA-
```

---

## 🆘 Troubleshooting

### GitHub CLI Not Installed?
```bash
# Windows
winget install --id GitHub.cli

# macOS
brew install gh

# Ubuntu/Debian
sudo apt install gh
```

### Not Authenticated?
```bash
gh auth login
# Follow prompts to authenticate
```

### Permission Denied?
- Check you have write access to the repository
- Verify authentication: `gh auth status`
- Try: `gh auth logout && gh auth login`

---

## 📚 Full Documentation

- **Setup Guide:** [JULES-API-KEYS-SETUP.md](JULES-API-KEYS-SETUP.md)
- **Usage Guide:** `JULES-API-KEYS-USAGE.md` (created after setup)
- **Workflow Example:** [.github/workflows/jules-api-example.yml](.github/workflows/jules-api-example.yml)

---

## 🔒 Security Reminders

- ✅ **Never commit** API keys to the repository
- ✅ **Never log** full API key values
- ✅ **Use secrets** only in secure environments
- ✅ **Rotate keys** regularly (every 90 days recommended)
- ✅ **Monitor usage** for unauthorized access

---

## 📞 Need Help?

1. Check [JULES-API-KEYS-SETUP.md](JULES-API-KEYS-SETUP.md) for detailed instructions
2. Review [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
3. Check [GitHub CLI Manual](https://cli.github.com/manual/gh_secret)

---

**Repository:** Mouy-leng/ZOLO-A6-9VxNUNA-  
**Last Updated:** 2026-01-01
