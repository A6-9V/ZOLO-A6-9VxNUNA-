# GitHub Actions Workflow Troubleshooting Guide

## Issue: Workflow Failure in my-drive-projects Repository

### Problem Statement
The GitHub Actions workflow run ([#20689169097](https://github.com/A6-9V/my-drive-projects/actions/runs/20689169097)) failed in the `A6-9V/my-drive-projects` repository on PR #64.

### Root Cause Analysis

All validation jobs failed at the "Checkout repository" step with the following characteristics:
- **Workflow**: Setup Validation (`.github/workflows/validation.yml`)
- **Branch**: `Cursor/A6-9V/all-requests-review-ed8d`
- **Event**: Pull Request #64
- **Conclusion**: Failure at checkout step

#### Common Causes for Checkout Failures

1. **SHA Mismatch**: The workflow ran with a commit SHA that was later changed due to force push or amendment
2. **Permissions Issue**: The workflow lacks proper permissions to checkout the repository
3. **Branch Protection**: Branch protection rules might be interfering with the checkout
4. **Token Expiration**: GitHub token used for checkout has expired or is invalid

### Solution

#### Immediate Fix
1. **Rerun the workflow**: Navigate to the [failed workflow run](https://github.com/A6-9V/my-drive-projects/actions/runs/20689169097) and click "Re-run all jobs"
2. **Check PR sync**: Ensure the PR branch is up-to-date with the base branch
3. **Verify permissions**: Ensure the workflow has proper permissions set

#### Workflow Configuration Review

The validation workflow in `my-drive-projects` uses:
```yaml
permissions:
  contents: read
```

This should be sufficient for checkout, but if issues persist, verify:

1. **Repository Settings**:
   - Go to Settings > Actions > General
   - Ensure "Read and write permissions" or "Read permissions" are enabled for GITHUB_TOKEN

2. **Branch Protection**:
   - Check if the branch has protection rules that might block checkout
   - Verify required status checks aren't creating circular dependencies

3. **Checkout Action Version**:
   - Currently using `actions/checkout@v4`
   - If issues persist, try pinning to a specific version: `actions/checkout@v4.1.0`

#### Alternative Approaches

If the checkout continues to fail:

1. **Simplify the workflow**:
```yaml
- name: Checkout repository
  uses: actions/checkout@v4
  with:
    fetch-depth: 1  # Shallow clone
    persist-credentials: false
```

2. **Add explicit ref**:
```yaml
- name: Checkout repository
  uses: actions/checkout@v4
  with:
    ref: ${{ github.head_ref }}
```

3. **Verify SHA availability**:
```yaml
- name: Debug checkout
  run: |
    echo "Event: ${{ github.event_name }}"
    echo "Ref: ${{ github.ref }}"
    echo "SHA: ${{ github.sha }}"
    echo "Head Ref: ${{ github.head_ref }}"
```

### Prevention

To prevent similar issues in the future:

1. **Avoid force pushes** to PR branches while workflows are running
2. **Use workflow_dispatch** for manual testing before committing workflow changes
3. **Test workflows locally** using tools like [act](https://github.com/nektos/act)
4. **Monitor workflow runs** and fix issues promptly

### Related Resources

- [GitHub Actions Checkout Action](https://github.com/actions/checkout)
- [GitHub Actions Permissions](https://docs.github.com/en/actions/security-guides/automatic-token-authentication)
- [Workflow Syntax Reference](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)

### Implementation in This Repository

This repository now has a similar validation workflow (`.github/workflows/validation.yml`) that:
- ✅ Validates repository structure
- ✅ Checks PowerShell script syntax
- ✅ Performs security validation
- ✅ Verifies documentation completeness
- ✅ Uses proper permissions configuration
- ✅ Handles errors gracefully

The workflow is configured to run on:
- Push to `main`, `develop`, or `copilot/**` branches
- Pull requests to `main` or `develop`
- Manual workflow dispatch

### Testing the Workflow

To test the validation workflow in this repository:

1. **Manual trigger**:
   ```bash
   gh workflow run validation.yml
   ```

2. **Create a test PR**:
   - Make a small change
   - Open a PR
   - Watch the workflow run automatically

3. **Check workflow status**:
   ```bash
   gh run list --workflow=validation.yml
   ```

### Next Steps

1. ✅ Validation workflow added to ZOLO-A6-9VxNUNA- repository
2. ⏳ Rerun failed workflow in my-drive-projects repository
3. ⏳ Monitor workflow runs for both repositories
4. ⏳ Update documentation if workflow patterns need adjustment

---

**Last Updated**: 2026-01-04
**Maintainer**: A6-9V Organization
