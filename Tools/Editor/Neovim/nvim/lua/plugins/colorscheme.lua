-- 配色テーマ
-- 候補: tokyonight / catppuccin / kanagawa / rose-pine（好みで差し替える）
return {
  "folke/tokyonight.nvim",
  lazy = false,     -- テーマは起動直後に必要なので即読み込み
  priority = 1000,  -- 他のプラグインより先に読み込む
  opts = { style = "night" },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")
  end,
}
