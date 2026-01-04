# Automation Rules and Configuration

This document defines the automation rules and intelligent defaults used by the setup scripts.

## Core Principles

1. **Automated Decision Making**: Scripts make intelligent decisions without user prompts
2. **Best Practices First**: Always choose the most secure and recommended options
3. **Fail-Safe**: If something can't be automated, skip it gracefully
4. **Token Security**: GitHub tokens are stored locally and never committed

## Automation Rules

### Windows Setup (`auto-setup.ps1`)

#### Browser Selection
- **Priority Order**: Chrome > Edge > Firefox
- **Decision**: Automatically select the first available browser
- **Action**: Set as default browser automatically

#### File Explorer Settings
- **Show Extensions**: Always enabled (security best practice)
- **Show Hidden Files**: Always enabled (usability)
- **Launch To**: Set to "This PC" (better organization)

#### Windows Sync
- **All Sync Groups**: Enabled automatically
- **Includes**: Settings, Passwords, Theme, Language, etc.

#### Security Configuration
- **Defender Exclusions**: Automatically added for all cloud folders
- **Firewall Rules**: Automatically created for cloud services
- **Controlled Folder Access**: Cloud folders automatically allowed

### Git Operations (`auto-git-push.ps1`, `auto-git-workflow.ps1`)

#### Automated Git Workflow
- **Full Automation**: Pull, commit, push, and merge handled automatically
- **AI Integration**: Powered by @copilot, @jules, @cursor
- **Smart Commits**: Intelligent commit message generation based on changes
- **Conflict Resolution**: Automatic merge conflict handling
- **Multi-Remote Support**: Pushes to all configured remotes

#### Credential Management
- **Token Storage**: Saved in `git-credentials.txt` (gitignored)
- **Windows Credential Manager**: Tokens stored securely after first use
- **Remote URL**: Uses HTTPS with token authentication

#### Commit Strategy
- **Auto-commit**: All changes committed automatically
- **Commit Message**: Intelligent messages based on file changes
- **Branch**: Always uses current or specified branch

#### Push Strategy
- **Automatic Push**: Pushes immediately after commit
- **Error Handling**: Graceful failure with helpful messages
- **Token Usage**: Uses saved token automatically

#### Merge Strategy
- **Auto-Merge**: Merges branches with conflict resolution
- **Strategy**: Uses appropriate merge strategy based on situation
- **Branch Management**: Maintains branch integrity

### Cloud Services

#### Service Detection
- **OneDrive**: Checks standard installation paths
- **Google Drive**: Checks multiple possible locations
- **Dropbox**: Checks standard installation paths

#### Service Management
- **Auto-start**: Services started automatically if found
- **Status Check**: Verifies if services are running
- **No Installation**: Skips if service not found (doesn't install)

## Token Security Rules

1. **Never Commit Tokens**: All token files are in `.gitignore`
2. **Local Storage Only**: Tokens stored in local files only
3. **Credential Manager**: Tokens moved to Windows Credential Manager after first use
4. **Backup Tokens**: Multiple tokens supported for redundancy

## File Organization

### Scripts
- `auto-setup.ps1` - Automated Windows configuration
- `auto-git-push.ps1` - Automated git operations with token
- `auto-git-workflow.ps1` - Complete git workflow automation (pull, commit, push, merge)
- `run-all-auto.ps1` - Master script that runs everything
- `git-setup.ps1` - Initial git repository setup
- `merge-branches.ps1` - Interactive branch merging
- `review-and-push-all-repos.ps1` - Review and push to all repositories

### Configuration
- `git-credentials.txt` - GitHub tokens (gitignored)
- `.gitignore` - Excludes all sensitive files

### Documentation
- `AUTOMATION-RULES.md` - This file
- `README.md` - Project documentation
- `SYSTEM-INFO.md` - System specifications and configuration
- `MANUAL-SETUP-GUIDE.md` - Manual steps guide
- `PRIVACY-BADGER-INFO.md` - Privacy Badger integration
- `GENX-TRADING-INFO.md` - GenX Trading global information

## Execution Flow

1. **User runs**: `AUTO-GIT-WORKFLOW.bat` or `auto-git-workflow.ps1`
2. **Auto-Pull**: Fetches and merges from all remotes
3. **Auto-Commit**: Commits all changes with AI-generated message
4. **Auto-Push**: Pushes to all configured remotes
5. **Auto-Merge**: (Optional) Merges branches if specified
6. **Summary**: Shows what was completed and logs to file

**Alternative flows**:
- `RUN-AUTO-SETUP.bat` or `run-all-auto.ps1` - Complete system setup
- Individual action scripts for specific tasks

## Error Handling

- **Missing Files**: Scripts skip gracefully
- **Permission Errors**: Scripts request elevation automatically
- **Network Errors**: Scripts report but don't fail completely
- **Token Errors**: Scripts provide helpful error messages

## Best Practices Enforced

1. **Security First**: All security settings enabled by default
2. **Privacy**: No data collection, all local
3. **Efficiency**: Minimal prompts, maximum automation
4. **Reliability**: Error handling at every step
5. **Maintainability**: Clear code structure and comments

## System Configuration

- **Device**: NuNa
- **OS**: Windows 11 Home Single Language 25H2 (Build 26220.7344)
- **Architecture**: 64-bit x64-based processor
- **Processor**: Intel(R) Core(TM) i3-N305 (1.80 GHz)
- **RAM**: 8.00 GB (7.63 GB usable)

All scripts are tested and optimized for this system configuration. See `SYSTEM-INFO.md` for complete system details.

## Customization

To customize automation rules, edit the respective script files:
- Browser selection: `Get-BestBrowser()` function in `auto-setup.ps1`
- Git behavior: `auto-git-push.ps1`
- Service detection: Service path arrays in `auto-setup.ps1`

## Token Management

### Adding/Updating Tokens
1. Edit `git-credentials.txt` (local file only)
2. Update `GITHUB_TOKEN` value
3. Scripts will use new token automatically

### Token Permissions Required
- `repo` - Full repository access
- `workflow` - GitHub Actions (if using)

### Security Notes
- Tokens are never logged or displayed
- Tokens stored in Windows Credential Manager after first use
- Token file is gitignored and never committed

