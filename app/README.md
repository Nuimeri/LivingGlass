# LivingGlass Application

LivingGlass は、リビングなどの常時表示ディスプレイ用マルチWebダッシュボードアプリケーションです。
指定したURL（最大3つ）を自動で分割配置し、画面の焼き付き防止（ピクセルシフト＆定期フェード暗転）を行いながら常時表示します。

---

## ディレクトリ構成

```
LivingGlass/app/
├── frontend/          # フロントエンドWebアプリ
│   ├── config.js      # 表示URL・タイマー周期設定
│   └── index.html     # ダッシュボードメイン画面
├── scripts/           # セットアップ・自動起動スクリプト
│   ├── setup.ps1      # Windows向け セットアップ＆起動スクリプト
│   └── setup.sh       # Linux / macOS向け セットアップ＆起動スクリプト
└── README.md
```

---

## 使い方 (3ステップ)

### 1. ディレクトリの配置
`app` フォルダをお好みの場所（例: `C:\LivingGlass` や `~/LivingGlass`）にコピーまたは移動します。

### 2. 設定ファイルの編集 (`frontend/config.js`)
`frontend/config.js` を開き、表示したいWebアプリ/WebページのURLを最大3つ指定します。

```javascript
window.LIVING_GLASS_CONFIG = {
  urls: [
    "http://localhost:3000",
    "http://localhost:4000"
  ],
  shiftIntervalMs: 5 * 60 * 1000,    // ピクセルシフト (5分)
  refreshIntervalMs: 15 * 60 * 1000  // 暗転リフレッシュ (15分)
};
```

### 3. セットアップ ＆ 初回起動スクリプトの実行

- **Windows の場合**:
  `scripts/setup.ps1` を右クリックして「PowerShell で実行」を選択（またはPowerShell端末から `./scripts/setup.ps1` を実行）。
- **Linux / macOS の場合**:
  ターミナルで `cd scripts && chmod +x setup.sh && ./setup.sh` を実行。

※ スクリプト実行により、自動的にOSのスタートアップ登録が行われ、ブラウザがキオスクモード（全画面）で初回起動します。

---

## キー操作
- **キオスクモードの終了**: キーボードの `Alt + F4` または `Ctrl + W`