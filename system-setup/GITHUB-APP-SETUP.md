# GenX GitHub App Setup Guide

Complete guide for setting up and configuring the GenX GitHub App properly.

## 📋 Prerequisites

- GitHub account with admin access
- Access to create GitHub Apps in your organization/account
- Basic understanding of GitHub Apps vs OAuth Apps

## 🚀 Step 1: Create the GitHub App

### 1.1 Navigate to GitHub App Settings

1. Go to your GitHub account/organization
2. Click on **Settings** (top right)
3. In the left sidebar, click **Developer settings**
4. Click **GitHub Apps**
5. Click **New GitHub App**

### 1.2 Configure Basic Information

Fill in the following:

- **GitHub App name**: `GenX` (or `GenX-App` if name is taken)
- **Homepage URL**: Your application homepage URL
- **User authorization callback URL**: Your OAuth callback URL (if using user auth)
- **Webhook URL**: Your webhook endpoint URL (e.g., `https://your-domain.com/webhook`)
- **Webhook secret**: Generate a secure random string (save this!)

  ```powershell
  # Generate webhook secret
  [Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32))
  ```

### 1.3 Set Permissions

Configure the following repository permissions:

| Permission | Access Level | Purpose |
|------------|--------------|---------|
| **Contents** | Read & write | Access and modify repository files |
| **Metadata** | Read-only | Access repository metadata |
| **Pull requests** | Read & write | Create and manage pull requests |
| **Issues** | Read & write | Create and manage issues |
| **Actions** | Read-only | View workflow runs (if needed) |

### 1.4 Subscribe to Events

Select the events you want to receive webhooks for:

- ✅ **Push** - Code pushes
- ✅ **Pull request** - PR opened, closed, merged
- ✅ **Issues** - Issue opened, closed
- ✅ **Installation** - App installed/uninstalled
- ✅ **Installation repositories** - Repositories added/removed

### 1.5 Installation Settings

- **Where can this GitHub App be installed?**:
  - Choose **Only on this account** (for personal use)
  - Or **Any account** (for distribution)

### 1.6 Create the App

Click **Create GitHub App**

## 🔑 Step 2: Generate and Save Credentials

After creating the app, you'll need to:

### 2.1 Note Your App ID

- The **App ID** is displayed on the app's general settings page
- Save this: `APP_ID=123456` (example)

### 2.2 Generate a Private Key

1. Scroll down to **Private keys** section
2. Click **Generate a private key**
3. **IMPORTANT**: Download the `.pem` file immediately (you can only download it once!)
4. Save it securely (e.g., `C:\Users\USER\.github\genx-app-private-key.pem`)

### 2.3 Generate Client Secret (if using OAuth)

1. Scroll to **Client secrets** section
2. Click **Generate a new client secret**
3. Save the secret immediately (you can only see it once!)

## 📥 Step 3: Install the GitHub App

### 3.1 Install on Your Account/Organization

1. Go to your app's settings page
2. Click **Install App** button (top right)
3. Choose where to install:
   - **Only select repositories** (recommended for testing)
   - **All repositories** (for full access)
4. Select the repositories you want to grant access to
5. Click **Install**

### 3.2 Get Installation ID

After installation:

1. Go to your app's **Installations** page
2. Click on the installation
3. The **Installation ID** is in the URL: `https://github.com/settings/installations/{INSTALLATION_ID}`
4. Save this: `INSTALLATION_ID=12345678` (example)

## ⚙️ Step 4: Configure MCP Server

Update your MCP configuration to use GitHub App authentication.

### 4.1 Update mcp-config.json

Edit `system-setup/mcp-config.json`:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-github"
      ],
      "env": {
        "GITHUB_APP_ID": "YOUR_APP_ID",
        "GITHUB_APP_PRIVATE_KEY_PATH": "C:\\Users\\USER\\.github\\genx-app-private-key.pem",
        "GITHUB_APP_INSTALLATION_ID": "YOUR_INSTALLATION_ID"
      }
    }
  }
}
```

### 4.2 Alternative: Use Personal Access Token

If you prefer using a Personal Access Token instead:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-github"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_your_token_here"
      }
    }
  }
}
```

## 🔐 Step 5: Secure Your Credentials

### 5.1 Store Private Key Securely

```powershell
# Create secure directory for GitHub credentials
$githubDir = "$env:USERPROFILE\.github"
if (-not (Test-Path $githubDir)) {
    New-Item -ItemType Directory -Path $githubDir -Force
}

# Set restrictive permissions (Windows)
icacls "$githubDir\genx-app-private-key.pem" /inheritance:r /grant:r "$env:USERNAME:(R)"
```

### 5.2 Store Credentials in Environment Variables (Optional)

```powershell
# Set user-level environment variables
[System.Environment]::SetEnvironmentVariable("GITHUB_APP_ID", "YOUR_APP_ID", "User")
[System.Environment]::SetEnvironmentVariable("GITHUB_APP_INSTALLATION_ID", "YOUR_INSTALLATION_ID", "User")
[System.Environment]::SetEnvironmentVariable("GITHUB_APP_PRIVATE_KEY_PATH", "$env:USERPROFILE\.github\genx-app-private-key.pem", "User")
```

## ✅ Step 6: Verify Setup

Run the verification script:

```powershell
.\verify-github-app.ps1
```

Or manually test:

```powershell
# Test with GitHub CLI
gh auth status

# Test API access
gh api /app
```

## 🔧 Step 7: Update Cursor Settings

After updating `mcp-config.json`, apply it to Cursor:

```powershell
# Run the complete setup script
.\complete-setup.ps1
```

Or manually copy:

```powershell
$mcpConfigPath = "$env:APPDATA\Cursor\User\globalStorage\mcp.json"
$sourceConfig = ".\mcp-config.json"
Copy-Item -Path $sourceConfig -Destination $mcpConfigPath -Force
```

## 📝 Configuration Summary

After setup, you should have:

| Credential | Location | Usage |
|------------|----------|-------|
| **App ID** | GitHub App Settings | Authentication |
| **Private Key** | `~/.github/genx-app-private-key.pem` | JWT signing |
| **Installation ID** | GitHub Installations page | Installation access |
| **Webhook Secret** | Secure storage | Webhook verification |
| **Client Secret** | GitHub App Settings | OAuth (if used) |

## 🐛 Troubleshooting

### Issue: "Invalid credentials"

- Verify App ID is correct
- Check private key file path and permissions
- Ensure Installation ID matches your installation

### Issue: "Permission denied"

- Verify repository permissions in app settings
- Check installation includes the repository
- Ensure app has required scopes

### Issue: "Webhook not receiving events"

- Verify webhook URL is accessible
- Check webhook secret matches
- Ensure events are subscribed in app settings

### Issue: MCP server not connecting

- Restart Cursor after updating MCP config
- Check MCP server logs in Cursor
- Verify environment variables are set correctly

## 🔗 Useful Links

- [GitHub Apps Documentation](https://docs.github.com/en/apps)
- [Creating GitHub Apps](https://docs.github.com/en/apps/creating-github-apps/setting-up-a-github-app/creating-a-github-app)
- [Authenticating with GitHub Apps](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app)
- [MCP GitHub Server](https://github.com/modelcontextprotocol/servers/tree/main/src/github)

## 📚 Next Steps

1. ✅ Create the GitHub App
2. ✅ Install on repositories
3. ✅ Configure MCP server
4. ✅ Test authentication
5. ✅ Set up webhooks (if needed)
6. ✅ Configure CI/CD workflows (if needed)

---

**Last Updated**: December 2025  
**App Name**: GenX  
**Status**: Ready for configuration
