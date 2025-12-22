# GitHub Secrets Quick Reference

## 🔐 Configured Secrets

| Secret Name | Purpose | Status |
|-------------|---------|--------|
| `CLIENT_ID` | OAuth Client ID | ✅ Configured |
| `CLIENT_SECRET` | OAuth Client Secret | ✅ Configured |

## 🚀 Quick Setup

```bash
# Method 1: Run the automated script
.\setup-github-secrets.ps1

# Method 2: Use GitHub CLI directly
gh secret set CLIENT_ID --body "Ov23liVH34OCl6XkcrH6" --repo Mouy-leng/ZOLO-A6-9VxNUNA-
gh secret set CLIENT_SECRET --body "666665669ac851c05533d8ee472d64cbd2061eba" --repo Mouy-leng/ZOLO-A6-9VxNUNA-

# Verify
gh secret list --repo Mouy-leng/ZOLO-A6-9VxNUNA-
```

## 📝 Usage in Workflows

```yaml
env:
  CLIENT_ID: ${{ secrets.CLIENT_ID }}
  CLIENT_SECRET: ${{ secrets.CLIENT_SECRET }}
```

## 🔗 Resources

- **Full Documentation**: [GITHUB-SECRETS-SETUP.md](GITHUB-SECRETS-SETUP.md)
- **Example Workflow**: [.github/workflows/oauth-example.yml](.github/workflows/oauth-example.yml)
- **GitHub Docs**: https://docs.github.com/en/actions/security-guides/encrypted-secrets

## ⚠️ Important Notes

- Secret names cannot start with `GITHUB_` (reserved prefix)
- Secrets are automatically masked in logs
- Secrets are not available in forked repositories
- Never commit secrets to the repository
