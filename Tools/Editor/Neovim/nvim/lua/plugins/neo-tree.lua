-- ファイルツリー（VS Code のエクスプローラー相当）
-- ツリー内のキー: Enter 開く / a 新規作成 / d 削除 / r 名前変更 / H 隠しファイル表示 / ? ヘルプ
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- アイコン（Nerd Font が必要）
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle reveal<cr>", desc = "ファイルツリー" },
    { "<leader>ge", "<cmd>Neotree float git_status<cr>", desc = "変更ファイル一覧" },
  },
  -- `nvim .` のようにフォルダを開いた時もツリーで表示する
  init = function()
    if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      require("neo-tree")
    end
  end,
  opts = {
    close_if_last_window = true, -- ツリーだけ残ったら Neovim ごと閉じる
    window = { width = 32 },
    filesystem = {
      follow_current_file = { enabled = true }, -- 開いているファイルをツリー上で追従
      use_libuv_file_watcher = true,            -- 外部での変更を自動反映
      hijack_netrw_behavior = "open_current",
      filtered_items = {
        hide_dotfiles = false, -- .github などの隠しファイルも表示
        hide_gitignored = false,
        never_show = { ".DS_Store", ".git" },
      },
    },
  },
}
