---
description: "Cursor IDE configuration, settings, and customization guidelines"
alwaysApply: false
globs: [".vscode/settings.json", ".cursor/**", "CURSOR-*.md"]
---

# Cursor IDE Configuration

Guidelines for configuring and customizing Cursor IDE for this project.

## Settings Structure

Cursor uses VS Code-compatible settings stored in `.vscode/settings.json`.

### Core Settings

```json
{
  "editor.formatOnSave": true,
  "editor.rulers": [120],
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000
}
```

### Language-Specific Settings

**PowerShell:**
- Enable script analysis
- Use OTBS formatting preset
- Show syntax errors inline

**YAML:**
- Schema validation for GitHub workflows
- Auto-indentation with 2 spaces

**Markdown:**
- Preview on edit
- Link validation

## Cursor Rules

Rules provide AI assistant context for better suggestions.

### Rule File Structure

```markdown
---
description: "Brief description"
alwaysApply: false
globs: ["file-pattern"]
---

# Rule Title

Content explaining the rule...
```

### Rule Categories

1. **Language-Specific**: For .ps1, .py, .js files
2. **Pattern-Specific**: For automation patterns
3. **Project-Specific**: For this repository's conventions

## AI Assistant Configuration

### Context Files

- `.cursor/rules/`: Directory for all rules
- `AGENTS.md`: Project-specific AI instructions
- `README.md`: Project overview

### Best Practices

- Keep rules focused and specific
- Use globs to target relevant files
- Set `alwaysApply: false` for most rules
- Update rules when conventions change

## Extensions

Recommended Cursor/VS Code extensions:
- PowerShell
- YAML
- GitLens
- Markdown All in One

## Workspace Settings

Settings can be:
- **User**: Apply to all Cursor projects
- **Workspace**: Apply only to this repository (recommended)

Store workspace settings in `.vscode/settings.json` to version control them.
