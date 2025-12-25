---
description: "Documentation writing standards and guidelines for this project"
alwaysApply: false
globs: ["*.md", "README*", "CONTRIBUTING*"]
---

# Documentation Standards

Guidelines for writing and maintaining documentation in this project.

## File Naming

- Use UPPERCASE for important docs: `README.md`, `CONTRIBUTING.md`
- Use kebab-case for feature docs: `cursor-setup.md`
- Use descriptive names: `GITHUB-INTEGRATION.md` not `gi.md`

## Document Structure

### Required Sections

1. **Title**: Clear, descriptive H1 heading
2. **Table of Contents**: For docs > 100 lines
3. **Content**: Organized with H2-H4 headings
4. **Examples**: Code blocks with language tags
5. **Last Updated**: Footer with date

### Optional Sections

- Prerequisites
- Installation
- Configuration
- Troubleshooting
- FAQ
- References

## Markdown Style

### Headings

```markdown
# H1 - Document Title (Only one per document)
## H2 - Major Sections
### H3 - Subsections
#### H4 - Details
```

### Emoji Usage

Use emojis to make documents scannable:
- 📋 Table of Contents
- 🚀 Quick Start / Getting Started
- ⚙️ Configuration / Settings
- 🎨 Customization / Themes
- 📚 Documentation / Resources
- 🔧 Troubleshooting
- ✅ Success / Completed
- ⚠️ Warning
- 🔒 Security

### Code Blocks

Always specify language for syntax highlighting:

```powershell
# PowerShell code
Write-Host "Example" -ForegroundColor Green
```

```json
{
  "example": "JSON code"
}
```

### Lists

- Use `-` for unordered lists
- Use `1.` for ordered lists
- Indent nested lists with 2 spaces
- Add blank line before and after lists

### Links

```markdown
[Link Text](URL)
[Internal Link](#anchor)
[Relative Link](./other-file.md)
```

## Content Guidelines

### Be Clear and Concise

- Use simple language
- Avoid jargon without explanation
- Short sentences and paragraphs
- One idea per paragraph

### Provide Examples

- Show don't just tell
- Include code samples
- Provide command examples
- Show expected output

### Be Consistent

- Use same terminology throughout
- Consistent formatting
- Consistent emoji usage
- Consistent code style

## Special Document Types

### README.md

- Project overview first
- Quick start section
- Installation instructions
- Basic usage
- Link to detailed docs

### CONTRIBUTING.md

- How to contribute
- Code standards
- PR process
- Testing requirements

### Setup Guides

- Prerequisites listed first
- Step-by-step instructions
- Verification steps
- Troubleshooting section

## Maintenance

### Update Frequency

- Update when features change
- Fix broken links immediately
- Add troubleshooting as issues arise
- Review quarterly for accuracy

### Version Control

- Commit doc changes with code
- Clear commit messages for docs
- Note major doc updates in changelog
