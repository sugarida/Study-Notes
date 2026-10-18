# Neovim セットアップ手順（macOS）

このドキュメントは、本リポジトリの Neovim 設定を  
macOS 環境で再現するための手順をまとめたものです。

---

## 前提環境

- OS: macOS（Apple Silicon / Intel どちらでも可）
- パッケージ管理: Homebrew
- ターミナル: 以下のいずれかを推奨
  - WezTerm / Ghostty / iTerm2 / kitty
  - ※ 標準の「ターミナル.app」は True Color 非対応のため、配色が崩れやすい

---

## Homebrew の導入

未導入の場合のみ実行します。

~~~bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
~~~

---

## 必須ツール

~~~bash
brew install neovim git gh lazygit ripgrep fd node
brew install --cask font-jetbrains-mono-nerd-font
~~~

| ツール | 用途 |
|---|---|
| neovim | 本体（v0.11 以上） |
| git / gh | Git 操作・GitHub の Issue / PR 表示 |
| lazygit | Git 操作画面（`Space g g`） |
| ripgrep | 全文検索（`Space f g`）に必須 |
| fd | 高速なファイル検索 |
| node | 一部 LSP（YAML / JSON など）の実行に必要（Step 3 で使用） |
| Nerd Font | アイコン表示用 |

インストール後、ターミナルのフォント設定で  
**JetBrainsMono Nerd Font** を選択します。

---

## Claude Code のインストール

~~~bash
curl -fsSL https://claude.ai/install.sh | bash
claude   # 初回はブラウザでログイン。終わったら /exit で終了
~~~

Neovim 内では `Space a c` で右側に開く（claudecode.nvim）。

---

## Git / GitHub CLI 確認

~~~bash
nvim --version
git --version
gh --version
~~~

GitHub 認証（初回のみ）を行います。

~~~bash
gh auth login        # GitHub.com → HTTPS → Login with a web browser を選ぶ
gh auth setup-git    # git コマンドでも gh の認証を使うようにする
~~~

※ GitHub はパスワードでの git clone に対応していない。  
　 プライベートリポジトリを clone するには、先にこの認証が必要。

---

## Neovim 設定の配置

macOS での設定パスは以下です。

~~~text
~/.config/nvim
~~~

既存設定をバックアップしてから、本リポジトリの設定を**シンボリックリンク**で配置します。  
（リポジトリ側を編集すれば、そのまま設定に反映される）

~~~bash
# 既存設定のバックアップ（すでに ~/.config/nvim がある場合）
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak

# リポジトリを clone してリンク
gh repo clone sugarida/Study-Notes ~/Study-Notes
mkdir -p ~/.config
ln -s ~/Study-Notes/Tools/Editor/Neovim/nvim ~/.config/nvim
~~~

---

## 初回起動とプラグイン取得

~~~bash
nvim
~~~

起動すると lazy.nvim が自動でプラグインを取得します。  
状態確認は以下。

~~~vim
:Lazy
:checkhealth
~~~

`:checkhealth` で赤い ERROR が出ている項目から潰していく。

---

## macOS ならではの設定

### Caps Lock を Control にする

Vim では `Ctrl` を多用するため、ほぼ必須。

- システム設定 → キーボード → キーボードショートカット → 修飾キー
- Caps Lock → `Control`

「単押しで Esc / 長押しで Ctrl」にしたい場合は Karabiner-Elements を使う。

~~~bash
brew install --cask karabiner-elements
~~~

### Option キーを Meta（Alt）として使う

`<M-j>` などのキーマップを使うために、ターミナル側で設定する。

- iTerm2: Profiles → Keys → Left Option key → `Esc+`
- WezTerm: `config.send_composed_key_when_left_alt_is_pressed = false`
- Ghostty: `macos-option-as-alt = true`

### クリップボード連携

`options.lua` の `vim.opt.clipboard = "unnamedplus"` により、  
macOS ではそのまま `pbcopy` / `pbpaste` 経由でシステムクリップボードと共有される。  
（追加ツール不要）

### 日本語入力（IME）の自動切り替え

Normal モードに戻った時に IME が日本語のままだとコマンドが打てない。  
`macism` で Esc 時に英数へ自動で切り替える。

~~~bash
brew tap laishulu/homebrew
brew install macism
~~~

インストールするだけで OK。`lua/config/autocmds.lua` が macism を見つけると、
Insert モードを抜けた時に自動で英数に切り替える。

※ 簡易的には「Esc の後に英数キー」を押す癖をつけるだけでも OK。

---

## セットアップ完了

以上で macOS 上で Neovim を  
仕事用 IDE として使うための初期セットアップは完了です。

慣れるまでは以下で練習するのがおすすめ。

~~~bash
nvim +Tutor
~~~
