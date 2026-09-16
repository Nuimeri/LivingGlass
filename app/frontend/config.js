/**
 * LivingGlass フロントエンド設定ファイル
 * 
 * 表示したいWebページ/WebアプリのURLを最大3つまで配列で指定できます。
 * 1つ指定の場合  : 100% 全画面表示
 * 2つ指定の場合  : 50% / 50% 左右2分割
 * 3つ指定の場合  : 33.3% × 3 左右3分割
 */
window.LIVING_GLASS_CONFIG = {
  // 表示対象のWebページURL（最大3つまで指定可能）
  urls: [
    "https://example.com",
    "https://ja.wikipedia.org"
  ],

  // ピクセルシフト実行間隔（ミリ秒）: 5分 = 300,000ms
  shiftIntervalMs: 5 * 60 * 1000,

  // 全画面暗転＆サイレントリロード実行間隔（ミリ秒）: 15分 = 900,000ms
  refreshIntervalMs: 15 * 60 * 1000
};
