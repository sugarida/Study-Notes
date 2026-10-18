# Neovim as Work IDE (Windows / macOS / Vim-style)

このディレクトリは、Neovim を **仕事用 IDE として運用するための設定・学習ノート**です。  
Windows / macOS 環境において、VS Code の代替として Neovim を常用することを目的としています。

---

## 🎯 目的

- Vim 流儀のキーバインドで作業効率を最大化
- Git / GitHub 操作をエディタ内で完結
- 軽量かつ再現可能な開発環境を構築
- 設定内容を「知識」として再利用できる形で保存

---

## ✅ この環境でできること

### 📁 ファイル管理
- ツリー表示によるプロジェクト構造の把握
- Git ステータスと連動した表示

### 🌱 Git 操作
- 行単位の差分表示
- ステージ / アンステージ
- コミット / プッシュ / プル
- diff / blame 操作

### 🐙 GitHub 連携
- Pull Request 一覧表示
- Issue 一覧表示
- GitHub CLI (`gh`) と連携

### 🧠 IDE 機能
- LSP による定義ジャンプ・参照検索
- ホバー表示
- リネーム
- オートコンプリート

### 🔍 検索
- ファイル名検索
- プロジェクト全体の全文検索

---

## 📂 ファイル構成

| ファイル | 内容 |
|---|---|
| setup.md | 環境構築手順（Windows） |
| setup-macos.md | 環境構築手順（macOS） |
| structure.md | 設定ファイル構成の説明 |
| plugins.md | プラグイン一覧と役割 |
| keymaps.md | よく使うキーマップ |
| troubleshooting.md | ハマりどころ・対処メモ |
