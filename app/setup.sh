#!/usr/bin/env bash

# LivingGlass Linux / macOS Setup & Launch Script

set -e

echo "=========================================="
echo "      LivingGlass Setup & Launch          "
echo "=========================================="

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FRONTEND_DIR="${SCRIPT_DIR}/frontend"
if [ ! -d "$FRONTEND_DIR" ]; then
    FRONTEND_DIR="${SCRIPT_DIR}"
fi
HTML_PATH="${FRONTEND_DIR}/index.html"
CONFIG_PATH="${FRONTEND_DIR}/config.js"

if [ ! -f "$HTML_PATH" ]; then
    echo "[エラー] index.html が見つかりません: ${HTML_PATH}"
    exit 1
fi

if [ ! -f "$CONFIG_PATH" ]; then
    echo "[エラー] config.js が見つかりません: ${CONFIG_PATH}"
    exit 1
fi


echo "[✓] 設定ファイルおよびダッシュボードHTMLを確認しました。"

# ブラウザコマンドの検出
BROWSER_CMD=""
if command -v google-chrome &> /dev/null; then
    BROWSER_CMD="google-chrome"
elif command -v chromium-browser &> /dev/null; then
    BROWSER_CMD="chromium-browser"
elif command -v chromium &> /dev/null; then
    BROWSER_CMD="chromium"
elif [ -d "/Applications/Google Chrome.app" ]; then
    BROWSER_CMD="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
fi

if [ -z "$BROWSER_CMD" ]; then
    echo "[エラー] Google Chrome または Chromium がインストールされていません。"
    exit 1
fi

echo "[✓] 使用ブラウザ: ${BROWSER_CMD}"

# 自動起動エントリーの生成 (Linux autostart)
AUTOSTART_DIR="${HOME}/.config/autostart"
if [ -d "${HOME}/.config" ]; then
    mkdir -p "${AUTOSTART_DIR}"
    DESKTOP_FILE="${AUTOSTART_DIR}/livingglass.desktop"
    cat <<EOF > "${DESKTOP_FILE}"
[Desktop Entry]
Type=Application
Name=LivingGlass
Exec=${BROWSER_CMD} --kiosk --app="file://${HTML_PATH}"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF
    echo "[✓] Autostart 設定を保存しました: ${DESKTOP_FILE}"
fi

# キオスクモード起動
echo "=========================================="
echo "  LivingGlass をキオスクモードで起動します... "
echo "=========================================="

"${BROWSER_CMD}" --kiosk --app="file://${HTML_PATH}" &
