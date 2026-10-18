# Neovim 自作環境（macOS）

Neovim を **ゼロから少しずつ育てる** ための設定と学習ノート。  
「1 ステップ = 実際に使ってみる → 不満を洗い出す → 次を足す」で進める。

---

## 🎯 方針

- 自分で理解できる設定だけを入れる（全部入りの配布設定は使わない）
- 見た目は良く、でも起動は速く（必要になるまでプラグインを読み込まない）
- 主な用途: インフラ・設定ファイル（YAML / JSON / Terraform / シェル）、Markdown、ネットワーク機器の config

---

## 🗺 ロードマップ

| Step | 内容 | 状態 |
|---|---|---|
| 0 | 最小構成（基本オプション・キーマップ・テーマ・which-key） | ✅ |
| 1 | 見た目（ステータスライン・アイコン・Treesitter による色分け） | ⬜ |
| 2 | 移動（ファイラー・あいまい検索・全文検索） | ⬜ |
| 3 | IDE 機能（LSP・補完・フォーマット・エラー表示） | ⬜ |
| 4 | Git / GitHub（差分表示・コミット・PR レビュー） | ⬜ |
| 5 | 用途別（Markdown プレビュー・Cisco config の色分け・巨大ログ対策） | ⬜ |

---

## 📂 ファイル構成

| ファイル | 内容 |
|---|---|
| setup-macos.md | 環境構築手順（macOS） |
| keymaps.md | キーマップ早見表（自作分 + Vim 基本操作） |
| nvim/ | 設定本体（`~/.config/nvim` にリンクする） |
| archive/windows-trial/ | 以前 Windows で試した LazyVim ベースの設定（参考用） |

~~~text
nvim/
├─ init.lua              -- 入口。leader キー設定と各ファイルの読み込み
└─ lua/
   ├─ config/
   │  ├─ options.lua     -- 行番号・インデントなど基本動作
   │  ├─ keymaps.lua     -- 自作キーマップ
   │  ├─ autocmds.lua    -- 自動処理（ヤンク時ハイライト・IME 切替）
   │  └─ lazy.lua        -- プラグインマネージャ
   └─ plugins/           -- 1 プラグイン = 1 ファイル
      ├─ colorscheme.lua
      └─ which-key.lua
~~~
