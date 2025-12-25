# Contributing to ZOLO-A6-9VxNUNA

Thank you for your interest in contributing to this project! This guide will help you get started.

## 🚀 Getting Started

### Prerequisites

- Windows 11 (recommended: Home Single Language 25H2 or later)
- PowerShell 5.1 or higher (PowerShell 7+ recommended)
- Git for Windows
- Administrator access for running setup scripts

### Setting Up Your Development Environment

1. **Clone the repository:**
   ```powershell
   git clone https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-.git
   cd ZOLO-A6-9VxNUNA-
   ```

2. **Review the documentation:**
   - Read [README.md](README.md) for project overview
   - Check [AGENTS.md](AGENTS.md) for coding standards
   - Review [SYSTEM-INFO.md](SYSTEM-INFO.md) for system requirements

3. **Run workspace setup:**
   ```powershell
   .\setup-workspace.ps1
   ```

## 📝 Coding Standards

### PowerShell Scripts

Follow the standards defined in [AGENTS.md](AGENTS.md):

- Use clear, descriptive variable names
- Add comments for complex logic
- Use `Write-Host` with `-ForegroundColor` for user feedback
- Always use try-catch blocks for error handling
- Use consistent status indicators: `[OK]`, `[INFO]`, `[WARNING]`, `[ERROR]`

### Error Handling

- Always use try-catch blocks for operations that might fail
- Skip gracefully if files/services are not found
- Use `Test-Path` before accessing files or directories
- Provide helpful error messages to users

### Security

- Never commit tokens or credentials
- All sensitive files must be in `.gitignore`
- Never log or display token values
- Use Windows Credential Manager for storing credentials

## 🔄 Development Workflow

### 1. Create a Branch

```powershell
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

### 2. Make Changes

- Keep changes focused and atomic
- Follow the coding standards
- Add comments where necessary
- Update documentation if needed

### 3. Test Your Changes

```powershell
# Test script syntax
$null = [System.Management.Automation.PSParser]::Tokenize((Get-Content your-script.ps1 -Raw), [ref]$null)

# Run the script in a test environment
.\your-script.ps1 -WhatIf  # If the script supports it
```

### 4. Commit Your Changes

```powershell
git add .
git commit -m "type(scope): description"
```

**Commit message format:**
- `feat(setup): add new setup script`
- `fix(git): resolve credential storage issue`
- `docs(readme): update installation instructions`
- `refactor(vps): improve service management`
- `test(scripts): add validation tests`
- `chore(deps): update dependencies`

### 5. Push and Create a Pull Request

```powershell
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub with:
- Clear description of changes
- Link to related issues
- Test results
- Screenshots (if UI changes)

## 🐛 Reporting Bugs

Use the [Bug Report template](.github/ISSUE_TEMPLATE/bug_report.yml) and include:

- Clear description of the bug
- Steps to reproduce
- Expected vs actual behavior
- Error messages
- System information

## 💡 Suggesting Features

Use the [Feature Request template](.github/ISSUE_TEMPLATE/feature_request.yml) and include:

- Problem statement
- Proposed solution
- Alternatives considered
- Priority level

## ✅ Pull Request Checklist

Before submitting a PR, ensure:

- [ ] Code follows project standards (see AGENTS.md)
- [ ] Comments added to complex logic
- [ ] Documentation updated if needed
- [ ] Changes tested locally
- [ ] No new warnings or errors
- [ ] No sensitive information included
- [ ] .gitignore updated if new file types added

## 🔒 Security

If you discover a security vulnerability:

1. **DO NOT** open a public issue
2. Email the maintainer directly
3. Provide detailed information about the vulnerability
4. Wait for acknowledgment before disclosing publicly

## 📚 Additional Resources

- [PowerShell Best Practices](https://learn.microsoft.com/en-us/powershell/scripting/dev-cross-plat/performance/script-authoring-considerations)
- [Git Workflow](https://git-scm.com/book/en/v2/Git-Branching-Branching-Workflows)
- [GitHub Flow](https://guides.github.com/introduction/flow/)

## 📞 Getting Help

- Check existing [Issues](https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-/issues)
- Start a [Discussion](https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-/discussions)
- Review the [Documentation](README.md)

## 📜 License

By contributing to this project, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing! 🎉
