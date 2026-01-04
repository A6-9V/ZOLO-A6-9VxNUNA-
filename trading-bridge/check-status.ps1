# Status Check Script
$mt5 = Join-Path $env:APPDATA "MetaQuotes\Terminal"
$d = Get-ChildItem $mt5 -Directory -ErrorAction SilentlyContinue | Select-Object -First 1

if ($d) {
    $ea = Join-Path $d.FullName "MQL5\Experts\PythonBridgeEA.mq5"
    $inc = Join-Path $d.FullName "MQL5\Include\PythonBridge.mqh"
    $ex5 = $ea -replace '\.mq5$', '.ex5'
    $port = Get-NetTCPConnection -LocalPort 5500 -ErrorAction SilentlyContinue
    
    Write-Output "STATUS:EA_FILE:$(if (Test-Path $ea) { 'EXISTS' } else { 'MISSING' })"
    Write-Output "STATUS:INCLUDE_FILE:$(if (Test-Path $inc) { 'EXISTS' } else { 'MISSING' })"
    Write-Output "STATUS:COMPILED:$(if (Test-Path $ex5) { 'YES' } else { 'NO' })"
    Write-Output "STATUS:SERVICE:$(if ($port) { 'RUNNING' } else { 'NOT_RUNNING' })"
    Write-Output "STATUS:MT5_PATH:$($d.FullName)"
} else {
    Write-Output "STATUS:MT5_DIR:MISSING"
}

