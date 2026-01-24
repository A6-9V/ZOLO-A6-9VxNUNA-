# Open MetaEditor for EA compilation
$MT5BasePath = "C:\Users\USER\AppData\Roaming\MetaQuotes\Terminal\53785E099C927DB68A545C249CDBCE06"
$metaEditorPath = Join-Path $MT5BasePath "metaeditor64.exe"

if (Test-Path $metaEditorPath) {
    Write-Host "Opening MetaEditor..." -ForegroundColor Green
    Start-Process $metaEditorPath
    Write-Host ""
    Write-Host "After MetaEditor opens:" -ForegroundColor Yellow
    Write-Host "  1. Navigate to: Experts -> EXNESS_GenX_Trader.mq5" -ForegroundColor White
    Write-Host "  2. Press F7 to compile" -ForegroundColor White
    Write-Host "  3. Check Errors tab (should be empty)" -ForegroundColor White
} else {
    Write-Host "MetaEditor not found at: $metaEditorPath" -ForegroundColor Yellow
    Write-Host "Please open MetaEditor manually:" -ForegroundColor Yellow
    Write-Host "  - Open MT5 terminal and press F4" -ForegroundColor White
    Write-Host "  - Or navigate to the MT5 installation folder" -ForegroundColor White
}
