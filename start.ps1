if ($IsWindows) {
    Write-Host "Windows detected. Starting the setup process..."

    $setupScriptPath = Join-Path $PSScriptRoot "complete-device-setup.ps1"
    if (Test-Path $setupScriptPath) {
        Write-Host "Running complete-device-setup.ps1..."
        & $setupScriptPath
    } else {
        Write-Host "Error: complete-device-setup.ps1 not found."
    }

    $exnessSetupScriptPath = Join-Path $PSScriptRoot "AUTO-SETUP-EXNESS-ALL.ps1"
    if (Test-Path $exnessSetupScriptPath) {
        Write-Host "Running AUTO-SETUP-EXNESS-ALL.ps1..."
        & $exnessSetupScriptPath
    } else {
        Write-Host "Error: AUTO-SETUP-EXNESS-ALL.ps1 not found."
    }

}
elseif ($IsLinux) {
    Write-Host "Linux detected."
    Write-Host "This project is designed to run on Windows or on Windows Subsystem for Linux (WSL)."
    Write-host "Please see LINUX_SETUP.md for instructions on how to set up your environment."
}
else {
    Write-Host "Unsupported operating system."
}
