# CI/CD Documentation

## Overview

This project uses GitHub Actions for continuous integration and continuous deployment (CI/CD). The CI/CD pipeline automatically tests, validates, and deploys code changes.

## Workflows

### 1. PowerShell CI (`powershell-ci.yml`)

**Triggers:**
- Push to `main`, `develop`, or `copilot/*` branches
- Pull requests to `main` or `develop`

**What it does:**
- ✅ Lints PowerShell scripts using PSScriptAnalyzer
- ✅ Checks script syntax for errors
- ✅ Reports warnings and errors with line numbers
- ✅ Runs on Windows environment for native PowerShell support

**How to run locally:**
```powershell
# Install PSScriptAnalyzer
Install-Module -Name PSScriptAnalyzer -Force -Scope CurrentUser

# Analyze a script
Invoke-ScriptAnalyzer -Path .\your-script.ps1

# Analyze all scripts
Get-ChildItem -Filter "*.ps1" -Recurse | ForEach-Object {
    Invoke-ScriptAnalyzer -Path $_.FullName
}
```

### 2. Python CI (`python-ci.yml`)

**Triggers:**
- Push to `main`, `develop`, or `copilot/*` branches with changes to `trading-bridge/`
- Pull requests to `main` or `develop` with changes to `trading-bridge/`

**What it does:**
- ✅ Tests with Python 3.9, 3.10, and 3.11
- ✅ Lints code with flake8
- ✅ Checks code formatting with black
- ✅ Runs pytest tests (if available)
- ✅ Checks for security vulnerabilities with safety

**How to run locally:**
```bash
# Install dependencies
pip install flake8 black pytest pytest-cov safety

# Lint code
flake8 trading-bridge --count --select=E9,F63,F7,F82 --show-source --statistics

# Check formatting
black --check trading-bridge

# Format code
black trading-bridge

# Run tests
pytest trading-bridge/tests --verbose

# Check security
safety check -r trading-bridge/requirements.txt
```

### 3. GitHub Pages Deployment (`pages-deploy.yml`)

**Triggers:**
- Push to `main` branch with changes to website files
- Manual workflow dispatch

**What it does:**
- ✅ Validates HTML structure
- ✅ Builds the site
- ✅ Deploys to GitHub Pages
- ✅ Automatic updates to https://mouy-leng.github.io/ZOLO-A6-9VxNUNA-/

**Manual deployment:**
Go to Actions → Deploy to GitHub Pages → Run workflow

## CI/CD Best Practices

### For PowerShell Scripts

1. **Follow PSScriptAnalyzer recommendations**
   - Use approved verbs (Get-, Set-, New-, etc.)
   - Proper parameter naming
   - Add comment-based help
   - Use proper error handling

2. **Code Style**
   - Use consistent indentation (4 spaces)
   - Add descriptive comments
   - Use Write-Host with colors for user feedback
   - Proper try-catch blocks

3. **Testing**
   - Test scripts manually before committing
   - Verify error handling
   - Test with different user permissions

### For Python Code

1. **Follow PEP 8 Style Guide**
   - Maximum line length: 127 characters
   - Use snake_case for functions and variables
   - Use PascalCase for classes
   - Add docstrings to functions and classes

2. **Code Quality**
   - Use type hints
   - Write unit tests
   - Keep functions small and focused
   - Handle exceptions properly

3. **Security**
   - Never commit credentials or tokens
   - Use environment variables for secrets
   - Keep dependencies updated
   - Run safety checks regularly

### For Website Deployment

1. **HTML/CSS/JS**
   - Validate HTML structure
   - Minify CSS and JS for production
   - Optimize images
   - Test responsive design

2. **Performance**
   - Use CDN for external libraries
   - Enable caching
   - Optimize asset loading
   - Test page load times

## Status Badges

Add these badges to your README to show CI/CD status:

```markdown
[![PowerShell CI](https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-/actions/workflows/powershell-ci.yml/badge.svg)](https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-/actions/workflows/powershell-ci.yml)
[![Python CI](https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-/actions/workflows/python-ci.yml/badge.svg)](https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-/actions/workflows/python-ci.yml)
[![Deploy to GitHub Pages](https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-/actions/workflows/pages-deploy.yml/badge.svg)](https://github.com/Mouy-leng/ZOLO-A6-9VxNUNA-/actions/workflows/pages-deploy.yml)
```

## Workflow Secrets

Some workflows may require secrets. Configure them in GitHub repository settings:

1. Go to Settings → Secrets and variables → Actions
2. Add repository secrets:
   - `GH_TOKEN` - GitHub Personal Access Token (if needed)
   - `API_KEYS` - Any API keys for external services

## Troubleshooting

### PowerShell CI Failures

**Issue**: PSScriptAnalyzer warnings
- Review the warnings and fix critical issues
- Some warnings can be suppressed if justified

**Issue**: Syntax errors
- Check for missing brackets, quotes, or parentheses
- Verify proper cmdlet usage
- Test the script locally

### Python CI Failures

**Issue**: Flake8 errors
- Fix syntax errors first (E9, F63, F7, F82)
- Then address style issues
- Use `# noqa` comment to suppress specific warnings if justified

**Issue**: Black formatting
- Run `black trading-bridge` to auto-format
- Commit the formatted code

**Issue**: Test failures
- Check test logs for specific errors
- Verify test dependencies are installed
- Run tests locally to debug

### Pages Deployment Failures

**Issue**: Build fails
- Check HTML syntax
- Verify all referenced assets exist
- Check Jekyll configuration if using _config.yml

**Issue**: Deploy fails
- Verify GitHub Pages is enabled in repository settings
- Check repository permissions
- Ensure workflow has necessary permissions

## Continuous Improvement

1. **Add more tests**
   - Write unit tests for Python code
   - Add Pester tests for PowerShell
   - Increase code coverage

2. **Enhance workflows**
   - Add code coverage reporting
   - Implement automatic versioning
   - Add release automation

3. **Performance monitoring**
   - Track build times
   - Monitor deployment success rate
   - Set up alerts for failures

## Contributing

When contributing code:

1. ✅ Ensure all CI checks pass
2. ✅ Write tests for new features
3. ✅ Update documentation
4. ✅ Follow code style guidelines
5. ✅ Keep commits focused and descriptive

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [PSScriptAnalyzer Rules](https://github.com/PowerShell/PSScriptAnalyzer)
- [PEP 8 Style Guide](https://peps.python.org/pep-0008/)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)

---

**Last Updated**: 2025-01-02
**Maintained by**: A6-9V Organization
