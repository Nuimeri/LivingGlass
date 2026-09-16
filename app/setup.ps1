# LivingGlass Windows Setup & Launch Script
# PowerShell 5.1 / 7.x Compatible

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "      LivingGlass Setup & Launch          " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. パスの確認
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$FrontendDir = Join-Path $ScriptDir "frontend"
if (-not (Test-Path $FrontendDir)) {
    $FrontendDir = $ScriptDir
}
$HtmlPath = Join-Path $FrontendDir "index.html"
$ConfigPath = Join-Path $FrontendDir "config.js"

if (-not (Test-Path $HtmlPath)) {
    Write-Error "[エラー] index.html が見つかりません: $HtmlPath"
    exit 1
}

if (-not (Test-Path $ConfigPath)) {
    Write-Error "[エラー] config.js が見つかりません: $ConfigPath"
    exit 1
}


Write-Host "[✓] 設定ファイルおよびダッシュボードHTMLを確認しました。" -ForegroundColor Green

# 2. 利用可能なブラウザの検出 (Chrome または Edge)
$BrowserPath = $null
$ChromePaths = @(
    "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
    "${env:LocalAppData}\Google\Chrome\Application\chrome.exe"
)

foreach ($path in $ChromePaths) {
    if (Test-Path $path) {
        $BrowserPath = $path
        break
    }
}

if (-not $BrowserPath) {
    $EdgePaths = @(
        "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
        "${env:ProgramFiles}\Microsoft\Edge\Application\msedge.exe"
    )
    foreach ($path in $EdgePaths) {
        if (Test-Path $path) {
            $BrowserPath = $path
            break
        }
    }
}

if (-not $BrowserPath) {
    Write-Error "[エラー] Google Chrome または Microsoft Edge がインストールされていません。"
    exit 1
}

Write-Host "[✓] 使用ブラウザ: $BrowserPath" -ForegroundColor Green

# 3. スタートアップ登録 (OS起動時の自動スタート)
$StartupDir = [System.IO.Path]::Combine($env:APPDATA, "Microsoft\Windows\Start Menu\Programs\Startup")
$ShortcutPath = Join-Path $StartupDir "LivingGlass.lnk"
$TargetUrl = "file:///" + ($HtmlPath -replace "\\", "/")
$Arguments = "--kiosk --app=`"$TargetUrl`""

try {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $BrowserPath
    $Shortcut.Arguments = $Arguments
    $Shortcut.WorkingDirectory = $ScriptDir
    $Shortcut.Description = "LivingGlass Kiosk Dashboard"
    $Shortcut.Save()
    Write-Host "[✓] スタートアップに自動起動ショートカットを登録しました: $ShortcutPath" -ForegroundColor Green
} catch {
    Write-Host "[!] スタートアップ登録をスキップしました: $_" -ForegroundColor Yellow
}

# 4. キオスクモードでダッシュボードを起動
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  LivingGlass をキオスクモードで起動します... " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

Start-Process -FilePath $BrowserPath -ArgumentList $Arguments
