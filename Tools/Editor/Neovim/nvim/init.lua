-- Neovim 設定のエントリポイント
-- 読み込み順: options → keymaps → autocmds → プラグイン(lazy.nvim)

-- <leader> キーは Space（プラグインより先に設定する必要がある）
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
