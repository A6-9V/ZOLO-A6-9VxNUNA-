# GitHub Secrets Setup Guide

This document provides complete instructions for setting up GitHub OAuth credentials as repository secrets.

## 📋 Overview

GitHub Secrets allow you to store sensitive information like OAuth credentials securely. These secrets can be used in GitHub Actions workflows without exposing the actual values in your code.

## 🔑 OAuth Credentials

The following OAuth credentials have been configured for this repository:

- **Client ID**: `Ov23liVH34OCl6XkcrH6`
- **Client Secret**: `666665669ac851c05533d8ee472d64cbd2061eba`
- **Repository**: `Mouy-leng/ZOLO-A6-9VxNUNA-`

## ✅ Setup Status

**Secrets have been successfully configured:**
- ✓ `CLIENT_ID` - Set for repository `Mouy-leng/ZOLO-A6-9VxNUNA-`
- ✓ `CLIENT_SECRET` - Set for repository `Mouy-leng/ZOLO-A6-9VxNUNA-`

## 🚀 Method 1: Using GitHub CLI (Recommended)

### Prerequisites
- GitHub CLI (`gh`) installed on your system
- Authenticated with GitHub

### Steps

1. **Authenticate with GitHub CLI:**
   ```bash
   gh auth login
   ```
   Follow the prompts to authenticate via web browser.

2. **Set the secrets:**
   ```bash
   gh secret set CLIENT_ID --body "Ov23liVH34OCl6XkcrH6" --repo Mouy-leng/ZOLO-A6-9VxNUNA-
   gh secret set CLIENT_SECRET --body "666665669ac851c05533d8ee472d64cbd2061eba" --repo Mouy-leng/ZOLO-A6-9VxNUNA-
   ```
   
   **Important:** Secret names cannot start with `GITHUB_` as that prefix is reserved by GitHub.

3. **Verify the secrets were added:**
   ```bash
   gh secret list --repo Mouy-leng/ZOLO-A6-9VxNUNA-
   ```

## 🌐 Method 2: Using GitHub Web Interface

### Steps

1. **Navigate to your repository:**
   - Go to: https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-

2. **Access Secrets Settings:**
   - Click on **Settings** (in the repository navigation bar)
   - In the left sidebar, click on **Secrets and variables** → **Actions**

3. **Add CLIENT_ID Secret:**
   - Click **New repository secret**
   - **Name**: `CLIENT_ID`
   - **Secret**: `Ov23liVH34OCl6XkcrH6`
   - Click **Add secret**

4. **Add CLIENT_SECRET Secret:**
   - Click **New repository secret** again
   - **Name**: `CLIENT_SECRET`
   - **Secret**: `666665669ac851c05533d8ee472d64cbd2061eba`
   - Click **Add secret**

**Note:** Secret names cannot start with `GITHUB_` as that prefix is reserved by GitHub.

## 📝 Using Secrets in GitHub Actions

### Method 1: Environment Variables

Set secrets as environment variables for the entire job:

```yaml
jobs:
  my-job:
    runs-on: ubuntu-latest
    
    env:
      CLIENT_ID: ${{ secrets.CLIENT_ID }}
      CLIENT_SECRET: ${{ secrets.CLIENT_SECRET }}
    
    steps:
      - name: Use OAuth credentials
        run: |
          echo "Client ID is set: ${CLIENT_ID:+YES}"
          # Use credentials in your scripts
```

### Method 2: Direct Reference

Use secrets directly in specific steps:

```yaml
steps:
  - name: Authenticate with OAuth
    run: |
      curl -X POST https://api.example.com/oauth/token \
        -d "client_id=${{ secrets.CLIENT_ID }}" \
        -d "client_secret=${{ secrets.CLIENT_SECRET }}"
```

### Method 3: Pass as Input to Actions

```yaml
steps:
  - name: Custom action with OAuth
    uses: some/action@v1
    with:
      client_id: ${{ secrets.CLIENT_ID }}
      client_secret: ${{ secrets.CLIENT_SECRET }}
```

## 🔒 Security Best Practices

### ✅ DO:
- Use secrets for all sensitive data (API keys, tokens, passwords)
- Limit access to secrets by using environment-specific secrets
- Rotate secrets regularly
- Use different secrets for development, staging, and production
- Review secret access in audit logs

### ❌ DON'T:
- Never echo or print secret values in logs
- Don't commit secrets to the repository
- Avoid using secrets in pull requests from forks (they won't have access)
- Don't name secrets starting with `GITHUB_` (reserved prefix)
- Never expose secrets in error messages

## 🛡️ Secret Security Features

### Automatic Masking
GitHub automatically masks secret values in workflow logs. If a secret is accidentally printed, it will appear as `***`.

### Access Control
- Secrets are encrypted at rest
- Only available to workflows in the repository
- Not accessible in forked repositories (for security)
- Can be scoped to specific environments

## 📊 Verification

To verify secrets are properly configured, you can:

1. **Check via GitHub CLI:**
   ```bash
   gh secret list --repo Mouy-leng/ZOLO-A6-9VxNUNA-
   ```

2. **Run the example workflow:**
   - Navigate to Actions tab in your repository
   - Run the "OAuth Integration Example" workflow
   - Check the workflow output for verification

3. **Check in GitHub UI:**
   - Go to Settings → Secrets and variables → Actions
   - You should see `CLIENT_ID` and `CLIENT_SECRET` listed

## 🔄 Updating Secrets

To update a secret, you can either:

1. **Using GitHub CLI:**
   ```bash
   gh secret set CLIENT_ID --body "new-value" --repo Mouy-leng/ZOLO-A6-9VxNUNA-
   ```

2. **Using GitHub Web Interface:**
   - Go to Settings → Secrets and variables → Actions
   - Click on the secret name
   - Click "Update secret"
   - Enter new value and save

## 🗑️ Deleting Secrets

To remove a secret:

1. **Using GitHub CLI:**
   ```bash
   gh secret remove CLIENT_ID --repo Mouy-leng/ZOLO-A6-9VxNUNA-
   ```

2. **Using GitHub Web Interface:**
   - Go to Settings → Secrets and variables → Actions
   - Click "Remove" next to the secret

## 📚 Additional Resources

- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [GitHub CLI Secrets Reference](https://cli.github.com/manual/gh_secret)
- [Security Hardening for GitHub Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)

## 🎯 Example Workflow

An example workflow demonstrating OAuth credential usage is available at:
`.github/workflows/oauth-example.yml`

This workflow:
- ✅ Verifies that secrets are properly configured
- ✅ Demonstrates how to use secrets securely
- ✅ Shows best practices for secret handling
- ✅ Provides status summary in workflow output

## 📞 Support

For issues with secret configuration:
1. Verify you have admin access to the repository
2. Check that secret names don't start with `GITHUB_`
3. Ensure secrets don't contain trailing whitespace
4. Review GitHub Actions logs for any error messages

---

**Last Updated**: December 22, 2024
**Repository**: Mouy-leng/ZOLO-A6-9VxNUNA-
**Status**: ✅ Secrets Configured
