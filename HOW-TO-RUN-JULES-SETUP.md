# 🚀 HOW TO RUN: Jules API Keys Setup

## ⚡ Quick Instructions

### Option 1: Windows (Easiest)

**Just double-click this file:**
```
SETUP-JULES-API-KEYS.bat
```

That's it! The script will:
1. ✅ Check GitHub CLI installation
2. ✅ Authenticate with GitHub (if needed)
3. ✅ Create all 13 secrets automatically
4. ✅ Generate usage documentation

---

### Option 2: PowerShell (Windows)

1. **Right-click PowerShell** and select **"Run as Administrator"**
2. **Navigate to the repository:**
   ```powershell
   cd C:\path\to\ZOLO-A6-9VxNUNA-
   ```
3. **Run the script:**
   ```powershell
   .\setup-jules-api-keys.ps1
   ```

---

### Option 3: Command Prompt (Windows)

1. **Open Command Prompt**
2. **Navigate to the repository:**
   ```cmd
   cd C:\path\to\ZOLO-A6-9VxNUNA-
   ```
3. **Run:**
   ```cmd
   powershell -ExecutionPolicy Bypass -File setup-jules-api-keys.ps1
   ```

---

### Option 4: Linux/macOS (Terminal)

1. **Open Terminal**
2. **Navigate to the repository:**
   ```bash
   cd ~/path/to/ZOLO-A6-9VxNUNA-
   ```
3. **Make script executable:**
   ```bash
   chmod +x setup-jules-api-keys.sh
   ```
4. **Run the script:**
   ```bash
   ./setup-jules-api-keys.sh
   ```

---

## 📋 What You'll See

The script will show output like this:

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
[HH:MM:SS] Setting secret: JULES_API_KEY_2
[HH:MM:SS] ✓   ✓ JULES_API_KEY_2 stored successfully
...
```

---

## ❓ Troubleshooting

### Problem: "GitHub CLI not found"

**Solution:**
```bash
# Windows
winget install --id GitHub.cli

# macOS
brew install gh

# Ubuntu/Debian
sudo apt install gh
```

Then re-run the setup script.

---

### Problem: "Not authenticated with GitHub"

**Solution:**
```bash
gh auth login
```

Follow the prompts:
1. Choose "GitHub.com"
2. Choose "HTTPS"
3. Choose "Login with a web browser"
4. Copy the code shown
5. Press Enter to open browser
6. Paste code and authorize

Then re-run the setup script.

---

### Problem: "Permission denied" or "Access denied"

**Solution:**

1. **Check you're logged in as the correct user:**
   ```bash
   gh auth status
   ```

2. **If wrong user, logout and login:**
   ```bash
   gh auth logout
   gh auth login
   ```

3. **Verify you have write access** to the repository:
   - Go to: https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-/settings
   - Check if you can access settings (confirms admin/write access)

---

### Problem: Script runs but secrets not created

**Solution:**

1. **Verify secrets manually:**
   ```bash
   gh secret list --repo Mouy-leng/ZOLO-A6-9VxNUNA-
   ```

2. **If no secrets listed, try creating one manually:**
   ```bash
   echo "TEST_VALUE" | gh secret set TEST_SECRET --repo Mouy-leng/ZOLO-A6-9VxNUNA-
   ```

3. **If that works, re-run the setup script**

---

## ✅ Verification

After running the script, verify secrets were created:

```bash
gh secret list --repo Mouy-leng/ZOLO-A6-9VxNUNA-
```

You should see:
```
JULES_API_KEY_1      Updated 2026-01-01
JULES_API_KEY_2      Updated 2026-01-01
JULES_API_KEY_3      Updated 2026-01-01
...
JULES_API_KEY_12     Updated 2026-01-01
JULES_API_KEYS_ALL   Updated 2026-01-01
```

---

## 🎯 Next Steps

After successful setup:

1. ✅ **Check documentation:**
   - Read: `JULES-API-KEYS-USAGE.md` (created by script)
   - Quick ref: `JULES-API-KEYS-QUICK-REFERENCE.md`

2. ✅ **Test in GitHub Actions:**
   - Go to: https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-/actions
   - Run workflow: "Jules API Integration Example"

3. ✅ **Integrate into your code:**
   - Use `${{ secrets.JULES_API_KEY_1 }}` in workflows
   - Use Python manager: `jules-api-keys-manager.py`

---

## 🆘 Still Need Help?

1. **Check full documentation:**
   - [JULES-API-KEYS-SETUP.md](JULES-API-KEYS-SETUP.md)

2. **GitHub Docs:**
   - [Encrypted Secrets Guide](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
   - [GitHub CLI Manual](https://cli.github.com/manual/)

3. **Open an issue in the repository**

---

## 📌 Important Notes

- ✅ Script is **safe to run multiple times** (updates existing secrets)
- ✅ All 12 API keys are **already embedded** in the scripts
- ✅ Keys are **never logged** or displayed in full
- ✅ Setup takes about **30-60 seconds**
- ✅ No user input required (fully automated)

---

**Ready?** Just double-click `SETUP-JULES-API-KEYS.bat` or run the appropriate script for your platform!

**Repository:** Mouy-leng/ZOLO-A6-9VxNUNA-  
**Created:** 2026-01-01
