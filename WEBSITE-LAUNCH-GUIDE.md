# 🌐 Website Launch Guide

## Overview

This guide helps you launch and test the ZOLO-A6-9VxNUNA website locally before deploying to GitHub Pages.

## 📍 Website Information

- **Production URL**: https://mouy-leng.github.io/ZOLO-A6-9VxNUNA-/
- **Repository**: https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-
- **Website Type**: Static HTML/CSS/JS (GitHub Pages compatible)
- **Configuration**: `_config.yml` (Jekyll configuration)

## 🌿 Branch Strategy

### Main Branch (Production)
- **Branch Name**: `main`
- **Purpose**: Production deployment
- **Auto-Deploy**: Yes (GitHub Pages automatically deploys from `main` branch)
- **URL**: https://mouy-leng.github.io/ZOLO-A6-9VxNUNA-/

### Feature/Test Branches
- **Current Branch**: `copilot/verify-launch-branch-and-port`
- **Purpose**: Development and testing
- **Testing**: Use local development server before merging to `main`

### Branch Workflow
1. Create feature branch from `main`
2. Make changes and test locally
3. Create Pull Request to merge to `main`
4. After merge, GitHub Pages auto-deploys

## 🚀 Local Development Server

### Port Configuration
- **Default Port**: `8000` (Python HTTP server)
- **Alternative Port**: `8080` (if 8000 is in use)
- **Jekyll Port**: `4000` (if using Jekyll serve)

### Method 1: Python HTTP Server (Recommended)

#### Linux/Mac
```bash
# Navigate to repository
cd /path/to/ZOLO-A6-9VxNUNA-

# Launch on port 8000
python3 -m http.server 8000

# Or use the provided script
./launch-website.sh
```

#### Windows (PowerShell)
```powershell
# Navigate to repository
cd C:\path\to\ZOLO-A6-9VxNUNA-

# Launch on port 8000
python -m http.server 8000

# Or use the provided script
.\launch-website.ps1

# Or double-click
launch-website.bat
```

### Method 2: Jekyll Server (Optional)

If you want to use Jekyll for local development:

```bash
# Install Jekyll (one-time)
gem install jekyll bundler

# Install dependencies
bundle install

# Serve the site
jekyll serve

# Access at http://localhost:4000/ZOLO-A6-9VxNUNA-/
```

## 🔍 How to Choose Which Branch to Launch

### For Development/Testing
```bash
# Check current branch
git branch

# Switch to feature branch
git checkout copilot/verify-launch-branch-and-port

# Launch local server
./launch-website.sh

# Test at http://localhost:8000/
```

### For Production Preview
```bash
# Switch to main branch
git checkout main

# Pull latest changes
git pull origin main

# Launch local server
./launch-website.sh

# Preview at http://localhost:8000/
```

## 📝 Quick Reference

### Check Current Branch
```bash
git branch --show-current
```

### Check Available Ports
```bash
# Linux/Mac
lsof -i :8000
netstat -an | grep 8000

# Windows
netstat -an | findstr :8000
```

### Kill Process on Port (if needed)
```bash
# Linux/Mac
lsof -ti :8000 | xargs kill -9

# Windows
netstat -ano | findstr :8000
taskkill /PID <PID> /F
```

## 🎯 Testing Checklist

Before deploying to production, test locally:

- [ ] Homepage loads correctly
- [ ] Navigation links work
- [ ] All sections are visible (Features, Systems, Architecture, etc.)
- [ ] CSS styles are applied properly
- [ ] JavaScript functionality works (mobile menu, copy buttons, etc.)
- [ ] Images and assets load
- [ ] Links to external resources work
- [ ] Responsive design works on different screen sizes
- [ ] Browser console shows no errors

## 🌐 Deployment Process

### To Production (GitHub Pages)

1. **Merge to Main**
   ```bash
   # Switch to main
   git checkout main
   
   # Pull latest
   git pull origin main
   
   # Merge feature branch
   git merge copilot/verify-launch-branch-and-port
   
   # Push to GitHub
   git push origin main
   ```

2. **Automatic Deployment**
   - GitHub Pages automatically builds and deploys
   - Wait 1-2 minutes for deployment
   - Check: https://mouy-leng.github.io/ZOLO-A6-9VxNUNA-/

3. **Verify Deployment**
   - Visit the production URL
   - Test all functionality
   - Check browser console for errors

### GitHub Pages Settings

To verify or change settings:
1. Go to: https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-/settings/pages
2. Ensure:
   - Source: Deploy from a branch
   - Branch: `main`
   - Folder: `/ (root)`

## 🔧 Troubleshooting

### Issue: Website not loading locally
**Solution**: 
- Check if port 8000 is available
- Try alternative port: `python3 -m http.server 8080`
- Check firewall settings

### Issue: CSS/JS not loading
**Solution**:
- Clear browser cache (Ctrl+Shift+R or Cmd+Shift+R)
- Check browser console for errors
- Verify file paths are correct

### Issue: GitHub Pages not updating
**Solution**:
- Check Actions tab: https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-/actions
- Wait a few minutes for deployment
- Clear browser cache
- Check GitHub Pages settings

### Issue: 404 errors on GitHub Pages
**Solution**:
- Verify `baseurl` in `_config.yml` is `/ZOLO-A6-9VxNUNA-`
- Check that all links use relative paths or include baseurl
- Ensure files are committed and pushed to `main` branch

## 📚 Additional Resources

- **VPS Setup**: See `VPS-SETUP-GUIDE.md` for 24/7 deployment
- **Automation**: See `vps-services/website-service.ps1` for automated updates
- **GitHub Pages Docs**: https://docs.github.com/en/pages
- **Jekyll Docs**: https://jekyllrb.com/docs/

## 🔐 Security Notes

- Website is publicly accessible on GitHub Pages
- No sensitive data should be in the repository
- All credentials are in `.gitignore`
- HTTPS is automatically enabled by GitHub Pages

## 📞 Support

For issues or questions:
1. Check GitHub Issues: https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-/issues
2. Review documentation in the repository
3. Check logs in `vps-logs/` directory (if using VPS deployment)

---

**Last Updated**: 2026-01-04
**Version**: 1.0
