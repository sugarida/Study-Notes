-- プラグインマネージャ lazy.nvim の準備
-- 未インストールなら自動で取得する
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- lua/plugins/ 以下のファイルを全部読み込む
require("lazy").setup({
  spec = { { import = "plugins" } },
  defaults = { lazy = true },           -- 基本は必要になるまで読み込まない（起動を速く）
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      -- 使わない標準プラグインを無効化して起動を速く
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
