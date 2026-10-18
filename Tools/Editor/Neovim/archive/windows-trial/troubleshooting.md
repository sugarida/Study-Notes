# トラブルシューティング

## fetch failed が出る
- Git が PATH に入っていない可能性
- Git for Windows を再インストール

## gh コマンドが見つからない
- GitHub CLI が未インストール
- https://cli.github.com/ から導入

## gh auth login が必要
- octo.nvim 使用前に一度だけ必要

## アイコンが文字化けする
- Nerd Font を使っていない
- ターミナル設定を確認

## (macOS) live_grep で何も出ない
- ripgrep が未インストール
- `brew install ripgrep`

## (macOS) 色がおかしい / 配色が崩れる
- 標準のターミナル.app は True Color 非対応
- WezTerm / Ghostty / iTerm2 などを使う

## (macOS) Esc 後にコマンドが効かない
- IME が日本語のまま
- macism で InsertLeave 時に英数へ切り替える（setup-macos.md 参照）
