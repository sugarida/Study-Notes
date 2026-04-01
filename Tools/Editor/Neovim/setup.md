# Neovim セットアップ手順（Windows）

このドキュメントは、本リポジトリの Neovim 設定を  
Windows 環境で再現するための手順をまとめたものです。

---

## 前提環境

- OS: Windows 10 / 11
- ターミナル: PowerShell または Windows Terminal

---

## 必須ツール

以下のツールを事前にインストールしておきます。

- Neovim（v0.9 以上）
- Git for Windows
- GitHub CLI（gh）
- Nerd Font（JetBrainsMono / FiraCode など）

---

## Git / GitHub CLI 確認

PowerShell で以下を確認します。

~~~powershell
git --version
gh --version
~~~

GitHub 認証（初回のみ）を行います。

~~~powershell
gh auth login
~~~

ブラウザが開くので、GitHub にログインして認可します。

---

## Neovim 設定の配置

本リポジトリの Neovim 設定を以下のパスに配置します。

~~~text
%LOCALAPPDATA%\nvim
~~~

※ 既存の設定がある場合はバックアップを推奨。

---

## 初回起動とプラグイン取得

Neovim を起動後、以下を実行します。

~~~vim
:Lazy
~~~

lazy.nvim により、必要なプラグインが自動でインストールされます。

---

## LSP セットアップ

LSP 管理ツール Mason を起動します。

~~~vim
:Mason
~~~

以下の言語サーバを必要に応じてインストールします。

- lua_ls
- tsserver
- pyright

---

## セットアップ完了

以上で Neovim を  
仕事用 IDE として使うための初期セットアップは完了です。
