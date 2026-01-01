#!/bin/bash

# Jules API Keys - GitHub Secrets Setup Script
# This script stores Jules API keys as GitHub repository secrets
# Requires: GitHub CLI (gh) to be installed and authenticated

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
GRAY='\033[0;90m'

# Output functions
print_status() {
    echo -e "${GRAY}[$(date +'%H:%M:%S')]${NC} ${CYAN}$1${NC}"
}

print_success() {
    echo -e "${GRAY}[$(date +'%H:%M:%S')]${NC} ${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${GRAY}[$(date +'%H:%M:%S')]${NC} ${CYAN}ℹ $1${NC}"
}

print_warning() {
    echo -e "${GRAY}[$(date +'%H:%M:%S')]${NC} ${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${GRAY}[$(date +'%H:%M:%S')]${NC} ${RED}✗ $1${NC}"
}

# Header
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "    ${NC}Jules API Keys - GitHub Secrets Setup${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Configuration
REPO="Mouy-leng/ZOLO-A6-9VxNUNA-"

# Jules API Keys (from the problem statement)
JULES_API_KEYS=(
    "AQ.Ab8RN6LIOs0In6K6BeypynGMY76Q8mDMEweWoB1-8sQY8rKsYA"
    "AQ.Ab8RN6L3CSQcdDzU-5VYC8cUL1u1vpvtols0WOgqOpz1dRtH_A"
    "AQ.Ab8RN6IR6QjwciMPvB7ccaCjjhIHY4Qg6nF3xSUl1BgcpyGVxg"
    "AQ.Ab8RN6IKx9oDSm6lWW3Yu06oJOrMCf_vaZOGntzpgumCQcRL0Q"
    "AQ.Ab8RN6K3J3t0Rc_wsndYjvM0fHmTgzfPBPsWdfOmc9fL6mIGEA"
    "AQ.Ab8RN6KlUp0GO6d0b-Y0d3WuZhS0oBTsfGy_91HNwKeBODSLTA"
    "AQ.Ab8RN6LNLoSXOtt-cAYKeVwEOALRNiH0hd_M9rVZHQRRCdfLVw"
    "AQ.Ab8RN6K4jVdUuKhieDfMnGYkTpX9VfObIa4dV7GalNXs6yqbdA"
    "AQ.Ab8RN6K6Fl1DrzsGISXVIsauEOUrBO4n3X3BSYOMgErgNufTOQ"
    "AQ.Ab8RN6JAoARBRfnKW9SGh1JSHSNm-BmYwRi5ohb4taxGNo6rWA"
    "AQ.Ab8RN6LXpkHn1WPjkwmbjLI54n4XTFYhduUNrvTG53sr9n7zxg"
    "AQ.Ab8RN6L6s4An9ePwJmQwLput1GJX53nShQ3zhOM-A9fdFqko3g"
)

print_info "Repository: $REPO"
print_info "Number of Jules API Keys to store: ${#JULES_API_KEYS[@]}"
echo ""

# Step 1: Check if GitHub CLI is installed
print_status "Checking GitHub CLI installation..."
if command -v gh &> /dev/null; then
    GH_VERSION=$(gh --version | head -n1)
    print_success "GitHub CLI is installed"
    echo -e "  ${GRAY}Version: $GH_VERSION${NC}"
else
    print_error "GitHub CLI (gh) is not installed!"
    echo ""
    echo -e "${YELLOW}Please install GitHub CLI from: https://cli.github.com/${NC}"
    echo -e "${YELLOW}Or run: sudo apt install gh (Ubuntu/Debian)${NC}"
    echo ""
    exit 1
fi

# Step 2: Check GitHub authentication
echo ""
print_status "Checking GitHub authentication..."
if gh auth status &> /dev/null; then
    print_success "Already authenticated with GitHub"
else
    print_warning "Not authenticated with GitHub"
    print_info "Initiating GitHub authentication..."
    echo ""
    
    # Check if we can authenticate (need GH_TOKEN or interactive login)
    if [ -n "$GH_TOKEN" ]; then
        echo "$GH_TOKEN" | gh auth login --with-token
        print_success "Authenticated with GitHub using GH_TOKEN"
    else
        print_error "GitHub authentication required"
        echo ""
        echo -e "${YELLOW}Please set GH_TOKEN environment variable or run:${NC}"
        echo -e "${YELLOW}  gh auth login${NC}"
        echo ""
        exit 1
    fi
fi

# Step 3: Store Jules API Keys as GitHub Secrets
echo ""
echo -e "${GRAY}─────────────────────────────────────────────────────────────${NC}"
print_status "Storing Jules API Keys as GitHub Secrets..."
echo -e "${GRAY}─────────────────────────────────────────────────────────────${NC}"
echo ""

SUCCESS_COUNT=0
FAIL_COUNT=0

for i in "${!JULES_API_KEYS[@]}"; do
    KEY_NUMBER=$((i + 1))
    SECRET_NAME="JULES_API_KEY_$KEY_NUMBER"
    API_KEY="${JULES_API_KEYS[$i]}"
    
    print_status "Setting secret: $SECRET_NAME"
    
    if echo "$API_KEY" | gh secret set "$SECRET_NAME" --repo "$REPO" 2>&1; then
        print_success "  ✓ $SECRET_NAME stored successfully"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        print_error "  ✗ Failed to store $SECRET_NAME"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    
    # Small delay to avoid rate limiting
    sleep 0.2
done

# Step 4: Store a combined key for convenience
echo ""
print_status "Creating combined Jules API keys secret..."

COMBINED_KEYS=$(IFS=','; echo "${JULES_API_KEYS[*]}")

if echo "$COMBINED_KEYS" | gh secret set JULES_API_KEYS_ALL --repo "$REPO" 2>&1; then
    print_success "  ✓ JULES_API_KEYS_ALL stored successfully"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
else
    print_warning "  ⚠ Failed to store JULES_API_KEYS_ALL"
fi

# Step 5: Verify secrets were created
echo ""
echo -e "${GRAY}─────────────────────────────────────────────────────────────${NC}"
print_status "Verifying secrets..."
echo -e "${GRAY}─────────────────────────────────────────────────────────────${NC}"
echo ""

if SECRETS_LIST=$(gh secret list --repo "$REPO" 2>&1); then
    print_success "Successfully retrieved secrets list"
    echo ""
    echo -e "${CYAN}Current secrets in repository:${NC}"
    echo -e "${GRAY}$SECRETS_LIST${NC}"
else
    print_warning "Could not retrieve secrets list"
fi

# Step 6: Create documentation
echo ""
echo -e "${GRAY}─────────────────────────────────────────────────────────────${NC}"
print_status "Creating usage documentation..."
echo -e "${GRAY}─────────────────────────────────────────────────────────────${NC}"
echo ""

DOC_PATH="$(dirname "$0")/JULES-API-KEYS-USAGE.md"

cat > "$DOC_PATH" << 'EOF'
# Jules API Keys - GitHub Secrets

## Overview

This document describes the Jules API keys stored as GitHub secrets for the repository **Mouy-leng/ZOLO-A6-9VxNUNA-**.

## Stored Secrets

The following secrets have been configured:

EOF

# Add individual keys to documentation
for i in $(seq 1 ${#JULES_API_KEYS[@]}); do
    echo "- \`JULES_API_KEY_$i\` - Jules API Key #$i" >> "$DOC_PATH"
done

cat >> "$DOC_PATH" << EOF

- \`JULES_API_KEYS_ALL\` - All API keys combined (comma-separated)

## Total Keys Stored

- **Individual Keys**: ${#JULES_API_KEYS[@]}
- **Combined Key**: 1
- **Total Secrets**: $((${#JULES_API_KEYS[@]} + 1))

## Usage in GitHub Actions

### Access Individual Key

\`\`\`yaml
name: Use Jules API Key
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Use Jules API Key
        env:
          JULES_API_KEY: \${{ secrets.JULES_API_KEY_1 }}
        run: |
          echo "Using Jules API Key..."
          # Your code here
\`\`\`

### Access All Keys

\`\`\`yaml
name: Use All Jules API Keys
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Use All Jules API Keys
        env:
          JULES_API_KEYS: \${{ secrets.JULES_API_KEYS_ALL }}
        run: |
          # Split keys by comma
          IFS=',' read -ra KEYS <<< "\$JULES_API_KEYS"
          for key in "\${KEYS[@]}"; do
            echo "Processing key: \${key:0:10}..."
          done
\`\`\`

## Usage in Bash Scripts

\`\`\`bash
# Access via environment variable (when running in GitHub Actions)
JULES_KEY=\$JULES_API_KEY_1

# Access via GitHub CLI (local development)
gh secret list --repo $REPO | grep "JULES_API_KEY"
\`\`\`

## Security Notes

1. **Never commit API keys** to the repository
2. **Never log full API keys** in console output
3. **Use secrets only** in secure environments (GitHub Actions, etc.)
4. **Rotate keys regularly** for enhanced security
5. **Monitor usage** to detect any unauthorized access

## Maintenance

### Update a Secret

\`\`\`bash
# Using GitHub CLI
echo "NEW_API_KEY_VALUE" | gh secret set JULES_API_KEY_1 --repo $REPO
\`\`\`

### Delete a Secret

\`\`\`bash
# Using GitHub CLI
gh secret delete JULES_API_KEY_1 --repo $REPO
\`\`\`

### List All Secrets

\`\`\`bash
gh secret list --repo $REPO
\`\`\`

## Support

For issues or questions, please refer to:
- [GitHub Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [GitHub CLI Documentation](https://cli.github.com/manual/gh_secret)

---

**Created**: $(date +'%Y-%m-%d %H:%M:%S')
**Script**: setup-jules-api-keys.sh
**Repository**: $REPO
EOF

print_success "Documentation created: $DOC_PATH"

# Summary
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "                    ${NC}Summary${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "Secrets stored successfully:    ${GREEN}$SUCCESS_COUNT${NC}"
if [ $FAIL_COUNT -gt 0 ]; then
    echo -e "Secrets failed:                 ${RED}$FAIL_COUNT${NC}"
else
    echo -e "Secrets failed:                 ${GREEN}$FAIL_COUNT${NC}"
fi
echo ""

if [ $SUCCESS_COUNT -gt 0 ]; then
    print_success "Jules API keys have been stored in GitHub Secrets!"
    echo ""
    print_info "Next Steps:"
    echo -e "  ${GRAY}1. Review the documentation: JULES-API-KEYS-USAGE.md${NC}"
    echo -e "  ${GRAY}2. Use the secrets in your GitHub Actions workflows${NC}"
    echo -e "  ${GRAY}3. Never commit API keys to the repository${NC}"
    echo ""
fi

if [ $FAIL_COUNT -gt 0 ]; then
    print_warning "Some secrets failed to store. Please review the errors above."
    echo ""
    exit 1
fi

echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
print_success "Setup completed successfully!"
echo ""
