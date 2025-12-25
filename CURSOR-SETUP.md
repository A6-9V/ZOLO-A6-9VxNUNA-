# Cursor IDE Configuration and Theme Automation

Complete guide for Cursor IDE setup, rules, settings, and automated theme switching.

## 📋 Table of Contents

1. [Cursor Rules](#cursor-rules)
2. [Cursor Settings](#cursor-settings)
3. [Theme Automation](#theme-automation)
4. [Documentation](#documentation)
5. [Usage](#usage)

## 🎨 Cursor Rules

Cursor rules are located in `.cursor/rules/` and provide AI assistant guidance for different file types and scenarios.

### Existing Rules

- **automation-patterns**: Windows setup and git automation patterns
- **powershell-standards**: PowerShell coding standards and best practices
- **github-desktop-integration**: GitHub Desktop workflow integration
- **security-tokens**: Token and credential security guidelines
- **system-configuration**: System setup and configuration patterns

### New Rules (Added)

- **cursor-configuration**: Cursor IDE setup and customization
- **theme-management**: Theme switching and preference management
- **documentation-standards**: Documentation writing guidelines

## ⚙️ Cursor Settings

Settings are configured in `.vscode/settings.json` (Cursor uses VS Code compatible settings).

### Current Configuration

```json
{
  "workbench.colorTheme": "Default Light+",
  "editor.formatOnSave": true,
  "editor.rulers": [120],
  "files.exclude": {
    "**/.git": false,
    "**/node_modules": true,
    "**/*.log": true
  },
  "powershell.scriptAnalysis.enable": true,
  "yaml.schemas": {
    "https://json.schemastore.org/github-workflow.json": ".github/workflows/*.{yml,yaml}"
  }
}
```

### Theme Management

**Light Themes:**
- Default Light+
- Visual Studio Light
- Quiet Light
- Solarized Light

**Dark Themes:**
- Dark+ (default dark)
- Visual Studio Dark
- Monokai
- One Dark Pro
- GitHub Dark

## 🌓 Theme Automation

### Auto Theme Switching Scripts

We provide scripts to automatically switch Cursor theme based on:
- Time of day (day/night)
- System theme preference
- Manual selection

### Scripts Created

1. **`set-cursor-theme.ps1`**: Manually set theme (light/dark)
2. **`auto-switch-cursor-theme.ps1`**: Automatic theme switching based on time
3. **`detect-system-theme.ps1`**: Detect and apply Windows system theme

### Usage Examples

```powershell
# Set light theme
.\set-cursor-theme.ps1 -Theme Light

# Set dark theme
.\set-cursor-theme.ps1 -Theme Dark

# Auto-switch based on time of day
.\auto-switch-cursor-theme.ps1

# Match system theme
.\detect-system-theme.ps1
```

## 📚 Documentation

### Cursor-Specific Documentation

- **CURSOR-SETUP.md**: Complete Cursor IDE setup guide (this file)
- **Theme preferences**: Stored in `.cursor/theme-preference.json`
- **AI rules**: All rules in `.cursor/rules/` directory

### Documentation Standards

All documentation should follow:
- Clear headings with emoji indicators
- Code blocks with language specification
- Table of contents for longer documents
- Examples for complex concepts
- Troubleshooting sections

## 🚀 Usage

### Initial Setup

1. **Install Cursor IDE**: Download from https://cursor.sh
2. **Open Repository**: Open this folder in Cursor
3. **Configure Theme**: Run theme script or use settings
4. **Verify Rules**: Check that `.cursor/rules/` are loading

### Daily Workflow

1. **Automatic Theme**: Runs automatically if scheduled
2. **Manual Override**: Use `set-cursor-theme.ps1` anytime
3. **AI Assistance**: Cursor uses rules automatically
4. **Settings Sync**: Changes sync via git

### Theme Automation Setup

**Option 1: Task Scheduler (Recommended)**
```powershell
# Run setup-theme-automation.ps1 to configure
.\setup-theme-automation.ps1
```

**Option 2: Manual Execution**
```powershell
# Run at startup
.\auto-switch-cursor-theme.ps1

# Or create a shortcut in Startup folder
```

**Option 3: System Theme Sync**
```powershell
# Continuously monitor system theme
.\detect-system-theme.ps1 -ContinuousMonitoring
```

## 🎯 Theme Preferences

Theme preferences are stored in `.cursor/theme-preference.json`:

```json
{
  "preferredLightTheme": "Default Light+",
  "preferredDarkTheme": "Dark+",
  "autoSwitch": true,
  "lightThemeStartTime": "07:00",
  "darkThemeStartTime": "19:00",
  "matchSystemTheme": false
}
```

Edit this file to customize your theme preferences.

## 🔧 Troubleshooting

### Cursor Rules Not Loading

1. Check `.cursor/rules/` directory exists
2. Verify RULE.md files have proper frontmatter
3. Restart Cursor IDE
4. Check Cursor settings for rule enablement

### Theme Not Changing

1. Check settings.json is not read-only
2. Verify script has write permissions
3. Close and reopen Cursor after theme change
4. Check theme name spelling in scripts

### Settings Not Syncing

1. Ensure `.vscode/settings.json` is committed to git
2. Check file is not in `.gitignore`
3. Pull latest changes from repository
4. Restart Cursor to reload settings

## 📖 Additional Resources

- [Cursor Documentation](https://cursor.sh/docs)
- [VS Code Settings Reference](https://code.visualstudio.com/docs/getstarted/settings)
- [VS Code Themes](https://code.visualstudio.com/docs/getstarted/themes)

## 🔄 Updates

This configuration is actively maintained. To get updates:

```powershell
git pull origin main
```

Then restart Cursor IDE to apply changes.

---

**Last Updated**: December 2025  
**Version**: 1.0  
**Maintained By**: @Mouy-leng
