# Python.exe Application Error - Troubleshooting Guide

## Problem
You're encountering a "python.exe application error" when trying to run the trading system. This typically happens when:
1. Python is not installed
2. Python is not in the system PATH
3. Python installation is corrupted or incomplete
4. Required Python packages are missing
5. Python version is incompatible

## Quick Fix (Automated)

Run the automated fix script:
```powershell
.\fix-python-error.ps1
```

This script will:
- Detect your Python installation
- Fix PATH issues
- Install missing dependencies
- Verify everything works

## Manual Fix Steps

### Step 1: Check Python Installation

```powershell
# Check if Python is installed
python --version
# Or try
python3 --version
# Or try with full path
C:\Python311\python.exe --version
```

**Expected Output:** `Python 3.11.x` or similar

**If you see an error:** Python is not installed or not in PATH

### Step 2: Install Python (If Not Installed)

1. **Download Python:**
   - Go to: https://www.python.org/downloads/
   - Download Python 3.11 or newer (64-bit recommended)
   - **IMPORTANT:** During installation, check "Add Python to PATH"

2. **Install with Winget (Alternative):**
   ```powershell
   winget install Python.Python.3.11
   ```

3. **Install with Chocolatey (Alternative):**
   ```powershell
   choco install python --version=3.11.0
   ```

### Step 3: Add Python to PATH (If Installed But Not Found)

1. **Find your Python installation:**
   Common locations:
   - `C:\Python311\`
   - `C:\Users\<USERNAME>\AppData\Local\Programs\Python\Python311\`
   - `C:\Program Files\Python311\`

2. **Add to PATH manually:**
   ```powershell
   # Replace C:\Python311 with your actual Python path
   [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Python311;C:\Python311\Scripts", "Machine")
   ```

3. **Restart PowerShell** to apply changes

### Step 4: Verify Python Works

```powershell
# Close and reopen PowerShell, then test
python --version
pip --version
```

### Step 5: Install Required Packages

```powershell
# Navigate to trading-bridge directory
cd trading-bridge

# Install dependencies
pip install -r requirements.txt
```

**Common Installation Errors:**

**Error: "pip is not recognized"**
```powershell
python -m ensurepip --upgrade
python -m pip install --upgrade pip
```

**Error: "Microsoft Visual C++ 14.0 is required"**
- Download and install: https://visualstudio.microsoft.com/visual-cpp-build-tools/
- Or install specific package binaries from: https://www.lfd.uci.edu/~gohlke/pythonlibs/

**Error: TA-Lib installation fails**
- TA-Lib is optional and commented out by default
- If you need it:
  1. Download TA-Lib from: https://github.com/cgohlke/talib-build/releases
  2. Install: `pip install TA_Lib-0.4.28-cp311-cp311-win_amd64.whl`

## Specific Error Messages

### "python.exe - System Error: The code execution cannot proceed because python311.dll was not found"

**Solution:**
1. Python installation is corrupted
2. Reinstall Python:
   ```powershell
   # Uninstall first
   python -m pip uninstall pip setuptools wheel
   # Then reinstall Python from python.org
   ```

### "python.exe - Application Error: The application was unable to start correctly (0xc000007b)"

**Solution:**
1. 32-bit/64-bit mismatch
2. Install 64-bit Python (recommended for trading system)
3. Download from: https://www.python.org/downloads/

### "ImportError: DLL load failed while importing _ssl"

**Solution:**
1. Missing Microsoft Visual C++ Redistributable
2. Download and install:
   - VC++ 2015-2022: https://aka.ms/vs/17/release/vc_redist.x64.exe

### "python: The term 'python' is not recognized"

**Solution:**
1. Python not in PATH
2. Use full path:
   ```powershell
   C:\Python311\python.exe --version
   ```
3. Or add to PATH (see Step 3 above)

## VPS-Specific Considerations

When running on a Windows VPS:

### 1. Use Python Launcher (py.exe)
```powershell
# Instead of: python script.py
# Use: py -3.11 script.py
py -3.11 --version
```

### 2. Virtual Environment (Recommended for VPS)
```powershell
# Create virtual environment
python -m venv C:\trading-venv

# Activate it
C:\trading-venv\Scripts\Activate.ps1

# Install packages in virtual environment
pip install -r trading-bridge/requirements.txt

# Update scripts to use virtual environment
# Edit start-trading-system.ps1and change:
# python -> C:\trading-venv\Scripts\python.exe
```

### 3. Run as Administrator
Some Python operations require admin privileges on VPS:
```powershell
# Right-click PowerShell, select "Run as Administrator"
# Then run your scripts
```

## Testing After Fix

### Test 1: Python Works
```powershell
python --version
pip --version
```

### Test 2: Packages Installed
```powershell
python -c "import zmq, requests, pandas, numpy; print('All packages OK')"
```

### Test 3: Trading Bridge Works
```powershell
cd trading-bridge
python test-bridge-debug.py
```

### Test 4: Full System Launch
```powershell
.\launch-trading-405347405.ps1
```

## Prevention Tips

1. **Always install Python with "Add to PATH" checked**
2. **Use virtual environments on VPS**
3. **Keep Python updated:** `python -m pip install --upgrade pip`
4. **Document your Python path** in: `C:\PythonPath.txt`
5. **Create backup scripts** that use full Python path:
   ```powershell
   $pythonPath = "C:\Python311\python.exe"
   & $pythonPath script.py
   ```

## System Requirements

### Minimum:
- Python 3.9+
- 4 GB RAM
- Windows 10/11 or Windows Server 2019+

### Recommended for Trading:
- Python 3.11+ (latest stable)
- 8 GB RAM
- 64-bit system
- Microsoft Visual C++ Redistributable 2015-2022

## Getting Help

If you still have issues after following this guide:

1. **Check Python installation log:**
   - Location: `C:\Users\<USERNAME>\AppData\Local\Temp\Python*-*.log`

2. **Run diagnostic script:**
   ```powershell
   .\fix-python-error.ps1 -Diagnose
   ```

3. **Check Event Viewer:**
   - Open Event Viewer → Windows Logs → Application
   - Look for python.exe errors with details

4. **Verify system architecture:**
   ```powershell
   # Should show: AMD64 (64-bit)
   [System.Environment]::GetEnvironmentVariable("PROCESSOR_ARCHITECTURE")
   ```

## Additional Resources

- Python Windows Installation Guide: https://docs.python.org/3/using/windows.html
- Python Package Index (PyPI): https://pypi.org/
- Stack Overflow Python Tag: https://stackoverflow.com/questions/tagged/python
- Python Discord: https://discord.gg/python

## Quick Reference Commands

```powershell
# Check Python
python --version
py --list  # Shows all installed Python versions

# Check packages
pip list
pip show pyzmq requests pandas

# Reinstall package
pip uninstall pyzmq
pip install pyzmq

# Upgrade all packages
pip list --outdated
pip install --upgrade pyzmq requests pandas numpy

# Clear pip cache
pip cache purge

# Test trading bridge
cd trading-bridge
python run-trading-service.py --test
```

---

**Last Updated:** December 2025  
**Tested On:** Windows 10/11, Windows Server 2019/2022  
**Python Versions:** 3.9, 3.10, 3.11, 3.12
