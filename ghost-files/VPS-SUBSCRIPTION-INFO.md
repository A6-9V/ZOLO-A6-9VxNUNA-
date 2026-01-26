# VPS Subscription Information

## VPS Subscription ID

**Subscription ID**: `6759730`

## Storage Location

- **Config File**: `vps-config.txt` (gitignored for security)
- **This File**: Reference documentation (safe to commit)

## Usage

The VPS subscription ID is stored in `vps-config.txt` which is excluded from git for security.

To load the subscription ID in scripts:

```powershell
# Load VPS subscription ID
$vpsConfigFile = "vps-config.txt"
if (Test-Path $vpsConfigFile) {
    $config = Get-Content $vpsConfigFile | Where-Object { $_ -match "^VPS_SUBSCRIPTION_ID=" }
    if ($config) {
        $vpsSubscriptionId = ($config -split "=")[1].Trim()
        Write-Host "VPS Subscription ID: $vpsSubscriptionId"
    }
}
```

## Security

- ✅ `vps-config.txt` is in `.gitignore` - will not be committed
- ✅ Subscription ID is stored locally only
- ✅ Safe to reference in documentation (this file)

---

**Last Updated**: 2025-12-09  
**Subscription ID**: 6759730

