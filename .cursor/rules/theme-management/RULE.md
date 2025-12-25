---
description: "Theme switching, preferences, and automation for Cursor IDE"
alwaysApply: false
globs: ["*theme*.ps1", "*theme*.json", ".vscode/settings.json"]
---

# Theme Management

Guidelines for managing Cursor IDE themes and automating theme switching.

## Theme Configuration

Themes are configured in `.vscode/settings.json`:

```json
{
  "workbench.colorTheme": "Default Light+"
}
```

## Available Themes

### Light Themes
- `Default Light+` - VS Code default light
- `Visual Studio Light` - Classic VS light
- `Quiet Light` - Minimal light theme
- `Solarized Light` - Popular light theme

### Dark Themes
- `Dark+` - VS Code default dark
- `Visual Studio Dark` - Classic VS dark
- `Monokai` - Popular dark theme
- `One Dark Pro` - Atom-inspired dark theme
- `GitHub Dark` - GitHub's dark theme

## Theme Automation

### Time-Based Switching

Switch themes based on time of day:
- **Day (7:00-19:00)**: Light theme
- **Night (19:00-7:00)**: Dark theme

### System Theme Sync

Match Windows system theme:
- Light mode → Light Cursor theme
- Dark mode → Dark Cursor theme

### Preference Storage

Theme preferences stored in `.cursor/theme-preference.json`:

```json
{
  "preferredLightTheme": "Default Light+",
  "preferredDarkTheme": "Dark+",
  "autoSwitch": true,
  "lightThemeStartTime": "07:00",
  "darkThemeStartTime": "19:00"
}
```

## Theme Scripts

### Manual Theme Setting

```powershell
# Set light theme
.\set-cursor-theme.ps1 -Theme Light

# Set dark theme
.\set-cursor-theme.ps1 -Theme Dark

# Set specific theme
.\set-cursor-theme.ps1 -ThemeName "Monokai"
```

### Automatic Theme Switching

```powershell
# Auto-switch based on time
.\auto-switch-cursor-theme.ps1

# Match system theme
.\detect-system-theme.ps1

# Continuous monitoring
.\detect-system-theme.ps1 -ContinuousMonitoring
```

## Implementation Guidelines

### When Creating Theme Scripts

1. Always backup current settings
2. Validate theme names exist
3. Update settings.json safely
4. Restart Cursor notification (optional)
5. Log theme changes

### Error Handling

- Check if settings.json exists
- Validate JSON before writing
- Handle file permission issues
- Provide helpful error messages

### User Preferences

- Respect user's manual theme changes
- Don't force theme changes
- Allow override of automation
- Store preferences persistently
